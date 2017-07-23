---
layout: page
subheadline: "Low level programming"
title:  "Read TAR-file in 26 lines of Ansi-C code"
teaser: "Archivers - it's scary! Huge and terrible algorithms that an ordinary person will never understand! Rar, zip, gzip, tar are modern de facto standards, which means extremely complex and tricky things that you should not try to understand. Well, tar looks simpler, maybe it's not that hard? See <a href='http://git.savannah.gnu.org/cgit/tar.git/tree/src'>git</a> with the sources. We see dozens of files, many for tens of kilobytes. Hmm. Apparently, a dead end."
categories: articles
tags:
    - articles
    - linux
    - archivers
    - c
    - low level
image:
   thumb: "thumb/dxTarRead-article.png"
---

```
__________________|      |____________________________________________
     ,--.    ,--.          ,--.   ,--.
    |oo  | _  \  `.       | oo | |  oo|
o  o|~~  |(_) /   ;       | ~~ | |  ~~|o  o  o  o  o  o  o  o  o  o  o
    |/\/\|   '._,'        |/\/\| |/\/\|
__________________        ____________________________________________
                  |      |dwb
```

In fact, everything is not so difficult. The documentation described that tar is just a way to write multiple files to tape. So everything should be simple. In fact - a set of auxiliary information for each file, than its contents directly. Only understanding of this fact allowed me to write the reader of tar-files in 26 lines.

Why should tar be used instead zip? For me the question of using tar comes when I wanted to get the archiver "for free" in my tiny C-applications. With minimal growth of the executable and without unnecessary dependencies. For example, the [dxPmdxConverter](https://github.com/DeXP/dxPmdxConverter) utility can read BMP and convert it to PNG using [LodePNG](http://lodev.org/lodepng/). So the application already has a functional that "archives" an array of pixels into a compressed PNG format. PNG is compressed by the [Deflate](https://en.wikipedia.org/wiki/DEFLATE) algorithm, which is used in zip and gzip. Moreover, it used directly in gzip - the gzip header is written, than the data stream from Deflate, than the crc-sum. The output is a ready .gz file which can be opened by any archiver. However, gzip can compress only one file. So you need to combine several files into one before compression. The most common way to do this is tar.

```
 ____  _   _  ____      __  ____        __ _       _            __   ____ ______       
|  _ \| \ | |/ ___|    / / |  _ \  ___ / _| | __ _| |_ ___     / /  / ___|__  (_)_ __  
| |_) |  \| | |  _    / /  | | | |/ _ \ |_| |/ _` | __/ _ \   / /  | |  _  / /| | '_ \ 
|  __/| |\  | |_| |  / /   | |_| |  __/  _| | (_| | ||  __/  / /   | |_| |/ /_| | |_) |
|_|   |_| \_|\____| /_/    |____/ \___|_| |_|\__,_|\__\___| /_/     \____/____|_| .__/ 
                                                                                |_|
``` 

Next time I needed tar in a similar situation. I wanted not simple store the resources for [Wordlase]({{ site.url }}/games/wordlase/) game, but archive and compress them. I can pack resources for a really long time on my machine. But the resources will be unpacked every time when user starts the game. So the solution should work quickly. Public domain implementation of the compression algorithm was found on the Internet, but it can pack only one file. Thats how hero of this publication was born - [dxTarRead](https://github.com/DeXP/dxTarRead/).

Advantages of dxTarRead:

1. Does not require additional memory, uses only what is passed in 
2. Easy to use, only 1 function
3. No dependencies (even stdlibc not used), embedded friendly
4. C89, i.e. theoretically can be correctly compiled even on a microwave using Visual Studio
5. Public Domain


The main disadvantage is that the tar file must be entirely read into memory before usage. On the other hand resources will still be used, i.e. will be loaded. Then why not load them from the disk at once, and take the data from tar directly when you need it.

So, tar. The basic information on the standard can be found on [GNU.org](https://www.gnu.org/software/tar/manual/html_node/Standard.html). I used only the description of the structure "struct posix_header". This constants are taken from it:

```c
const int NAME_OFFSET = 0, SIZE_OFFSET = 124, MAGIC_OFFSET = 257;
const int BLOCK_SIZE = 512, NAME_SIZE = 100, SZ_SIZE = 12, MAGIC_SIZE =5;
```

These constants can be read like this: if you move from the beginning of the tar block to 124 bytes (SIZE_OFFSET), then in the next 12 bytes (SZ_SIZE) will store the file size inside the tar.

Do not forget to read the documentation! There we can find out that the size is stored in the octal system ;-) If you read the bytes from the end of SZ_SIZE and add a digit multiplied by 8, you get the size in the usual decimal form.

In C language its looks like:

```c
const char* sz = tar + SIZE_OFFSET + currentBlockStart;
long size = 0;
for(i=SZ_SIZE-2, mul=1; i>=0; mul*=8, i--) /* Octal str to int */
    if( (sz[i]>='1') && (sz[i] <= '9') ) size += (sz[i] - '0') * mul;
```

Now we very close to the topic of tar-blocks. It's just 512 bytes of data - either the tar header, or bytes of the file written consecutively. The 512 bytes are still reserved if the last block of the file takes less than 512 bytes. Each tarball looks like this:

```
+-------+-------+-------+-------+-------+-------+
| tar 1 | file1 |  ...  | file1 | tar 2 | file2 | ...
+-------+-------+-------+-------+-------+-------+
```

There is a block with the tar header which specifies the size of the stored file. Next come *N* blocks with the contents of the file. So you need to move to (N + 1) * 512 bytes to move to the next file in tar. Code:

```c
newOffset = (1 + size/BLOCK_SIZE) * BLOCK_SIZE; /* trim by block size */
if( (size % BLOCK_SIZE) > 0 ) newOffset += BLOCK_SIZE;
```

The algorithm:

1. Read file name and its size from the block.
2. Return the link to the user if the file name matches.
3. Otherwise jump to the next block and repeat from step 1.

I had to implement strncmp analog on the loop to compare the file name:

```c
i = 0;
while((i<NAME_SIZE) && (fileName[i]!=0) && (name[i]==fileName[i])) i++;
if( (i > 0) && (name[i] == 0) && (fileName[i] == 0) ) found = 1;
```

That's all. All source code is considered. Full function code:

```c
const char* dxTarRead(const void* tarData, const long tarSize, 
                      const char* fileName, long* fileSize)
{
   const int NAME_OFFSET=0, SIZE_OFFSET=124, MAGIC_OFFSET=257;
   const int BLOCK_SIZE=512, NAME_SIZE=100, SZ_SIZE=12, MAGIC_SIZE=5;
   const char MAGIC[] = "ustar"; /* Modern GNU tar's magic const */
   const char* tar = (const char*) tarData; /*From "void*" to "char*" */
   long size, mul, i, p = 0, found = 0, newOffset = 0;

   *fileSize = 0; /*will be zero if TAR wrong or there is no such file*/
   do { /* "Load" data from tar - just point to passed memory */
       const char* name = tar + NAME_OFFSET + p + newOffset;
       const char* sz = tar + SIZE_OFFSET + p + newOffset; /* size str */
       p += newOffset; /* pointer to current file's data in TAR */

       for(i=0; i<MAGIC_SIZE; i++) /* Check for supported TAR version */
           if( tar[i + MAGIC_OFFSET + p] != MAGIC[i] ) return 0;

       size = 0; /* Convert file size from string into integer */
       for(i=SZ_SIZE-2, mul=1; i>=0; mul*=8, i--) /* Octal str to int */
           if( (sz[i]>='1') && (sz[i] <= '9') ) size += (sz[i]-'0')*mul;

       /*Offset size in bytes. Depends on file size and TAR block size */
       newOffset = (1 + size/BLOCK_SIZE) * BLOCK_SIZE; /*trim by block */
       if( (size % BLOCK_SIZE) > 0 ) newOffset += BLOCK_SIZE;

       i = 0; /* strncmp - compare file's name with that a user wants */
       while((i<NAME_SIZE)&&(fileName[i]!=0)&&(name[i]==fileName[i]))i++;
       if( (i > 0) && (name[i] == 0) && (fileName[i] == 0) ) found = 1;
   } while( !found && (p + newOffset + BLOCK_SIZE <= tarSize) );
   if( found ){
       *fileSize = size;
       return tar + p + BLOCK_SIZE; /* skip header, point to data */
   } else return 0; /* No file found in TAR - return NULL */
}
```

### Conclusion

Tar does not compress data but stores it in clear text. This is what allows not to allocate new memory but simply to return a pointer to an existing one.

The size of the tar block is 512 bytes. In addition each file must be saved with a tar header. So a several bytes file will occupy 1 kilobyte in the tar file. Tar is a bad choise if you need to store many small files and do not compress the file.


[This article in Russian ›](https://habrahabr.ru/post/320834/)
{: .t30 .button .radius}


## Other Articles
{: .t60 }
{% include list-posts tag='articles' %}
