---
layout: page
subheadline: "GUI"
title:  "Tiny desktop GUI application in PHP - 2 MB is enough"
teaser: "I often worry about minimizing the size of my GUI applications. My last article was about Nuklear. But now I want more modern technologies: HTML5, CSS3 and PHP. The final application shouldn't depend on anything, i.e. it should be built on the principle of all inclusive. The final size of the application should not exceed 2 megabytes. Is it possible?"
categories: articles
tags:
    - articles
    - linux
    - windows
    - gui
    - tiny
    - php
    - jquery
    - bootstrap
    - desktop
    - web
image:
   thumb: "thumb/civetwebview.png"
header:
    image_fullwidth: "other/civetwebview/CivetWebView-Windows-screenshot.png"
imgs_path: "other/civetwebview/"
comments: true
buttons:
    - caption: "CivetWebView on GitHub"
      url: "https://github.com/DeXP/CivetWebView"
      class: "warning"
    - caption: "This article in Russian"
      url: "https://habr.com/ru/post/674192/"
      class: "info"
---

I often worry about minimizing the size of my GUI applications. My last article was about [Nuklear](/articles/nuklear-cross/). But now I want more modern technologies: HTML5, CSS3, and PHP. The final application shouldn't depend on anything, i.e. it should be built on the principle of all-inclusive. The final size of the application should not exceed 2 megabytes. Is it possible?

I use the [df](https://opensource.com/article/21/7/check-disk-space-linux-df) utility in Linux pretty often. I really miss it in Windows, and I'm too lazy to look for analogs. So a strong-willed decision was made to make my own, in PHP 5, with bootstrap and jQuery.

Brief solution to my problem: [CivetWeb](https://github.com/civetweb/civetweb) + [WebView](https://github.com/webview/webview) + [PH7](https://github.com/symisc/PH7).

That is, the resulting application is also a web server that distributes static files and executes scripts (CivetWeb), and the browser that connects to this web server (WebView). PHP is executed as CGI-BIN through a third-party PH7 interpreter.

Here is the main feature of the bundle - any language/compiler/interpreter can be used as a CGI-BIN interpreter. You could use, for example, Haxe, or Go, or generate web pages in Powershell, or take a full PHP. Also, a Lua interpreter is built-in right into CivetWeb, which allows you to make lightweight but full-fledged applications.


{% include image path="CivetWebView-Windows-screenshot.png" caption="Resulting application in Windows 11" %}


Enough of the lyrics, let's move on to the code. PHP is not the best language for building system applications. For example, it does not have a function to get system disks. But when did such a fact stopped us? We'll use iterating through the entire alphabet and checking if the directory exists in Windows. The function reads the `/etc/fstab` file line by line in Linux, splits each line on spaces to get the columns, and checks for the existence of a directory:

```php
function fs_get_roots() {
    static $roots = null;
    if ($roots === null) {
        if (strncasecmp(PHP_OS, 'WIN', 3) === 0) {
            $driveLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
            for ($i = 0; $i < strlen($driveLetters); $i++) {
                $curDrive = $driveLetters[$i].':\\';
                if (is_dir($curDrive)) {
                    $roots[] = $curDrive;
                }
            }
        } else {
            foreach (file('/etc/fstab') as $line) {
                if ($line[0] != '#') {
                    $line = str_replace('\t', ' ', $line);
                    do 
                        $line = str_replace('  ', ' ', $line, $count);
                    while($count);
                    $rows = explode(' ', $line);
                    if (count($rows) && is_dir($rows[1])) {
                        $roots[] = $rows[1];
                    }
                }
            }
        }      
    }
    return $roots;
}
```

The roots of the file system are cached in the `$roots` static variable. That is, if you call this function several times when generating a page then the next call will work very quickly since the disk will not be rescanned.


{% include image path="CivetWebView-Linux-screenshot.png" caption="Resulting application in Ubuntu Linux" %}


On the one hand, the code turned out not very beautiful. Direct parsing of system files is used in Linux to write low-level utilities. For example, some of the implementations of `df` may really read `/etc/fstab`. Such code is normal for programs written in C. But not for high-level programming languages. Guessing the disk name alphabetically is generally a malicious hack. For example, if a disc is inserted into a DVD drive, it will spin up every time it is accessed...

On the other hand, the result has been achieved. PHP was created for generating web pages. But if you want, you can even write system software on it.


### JQuery

I use [the example of a progress bar on the bootstrap](https://bbbootstrap.com/snippets/linear-progress-bar-99672162) as a view. Here you have Bootstrap itself, HTML5, and also JQuery included for some reason.

One of the desires was to have a localization system built into the application. So that Russian-speaking users see the application in Russian, Czechs - in Czech, etc. The localization system will be made in jQuery. Well, you need to use it at least for something:

```javascript
$(document).ready(function() {
    var userLang = (navigator.language || navigator.userLanguage)
        ?.substring(0, 2)?.toLowerCase(); 
    $('[data-' + userLang + ']').each(function(element) {
        var localized = $(this).data(userLang);
        $(this).text(localized);
    });
});
```

The `userLang` variable stores 2 letters of the user's browser language. For example, `ru`. Next, iterate through all the tags that have the `data-ru` attribute. Further, the text of the current element is simply set to the obtained from the data.

An example of HTML markup for using such a localization system:

```html
<h2 data-ru="Системный диск" data-cz="Systémový disk">System Drive</h2>
```

The main disadvantage of such a localization system is visible here - the code becomes very overloaded, and all users always download data for all languages. Such localization is suitable if the project needs to translate just a few short phrases into a small number of languages. So: good for example _only_.



### PH7

[PH7](https://github.com/symisc/PH7) is an alternative PHP implementation for embedded systems. PH7 was developed to revive the UI in routers, where raw HTML codes were embedded directly into the firmware written in C.

PH7 is free for open source projects. The main advantage is the extremely small size - I was able to compile `ph7-cgi` into an application with a size of about 300 kilobytes.

The number of disadvantages of the PH7 is slightly bigger than the advantages. The main disadvantages of PH7:

1. Outdated version of PHP. Version 5.3 was released in 2009...
2. No support for regular expressions. This automatically declines the possibility of using many libraries (Smarty, Twig, etc.)
3. Not all features work cross-platform.
4. Not all features work at all.

For example, the functions `disk_total_space` and `disk_free_space` always return a null value in Linux (visible on the screenshot). I did not make an alternative implementation of these functions (for example, through the parsing of the `df` output) since this is not the purpose of this publication. And it is problematic to call third-party utilities since there is a null value instead of the `exec` function.

In general, PHP in this publication is more of an element of humor than real benefit.


### CivetWebView

The short solution has already been written above. Let's look at the client-server part: [CivetWeb](https://github.com/civetweb/civetweb) + [WebView](https://github.com/webview/webview).

CivetWeb (formerly Mongoose before the license change) is the de facto standard when you need to quickly distribute something over HTTP on the desktop. It's not a production solution like Nginx - my local server doesn't need to serve millions of files per second. And hundreds of evil hackers won't try to crack it. And a very big question is whether it will ever be allowed into the external network.

WebView is just the ability to embed a system browser in your application. It will be Edge for Windows, it will be GTK WebKit for Linux, it will be Cocoa or WebKit for Mac. That is, some modern browser that supports HTML5, CSS3, and JavaScript well. At the same time, the resulting application will not grow to hundreds of megabytes, since the engine will not be built directly into the resulting application.

Both of these technologies look good to me. The only thing is, I never found a single project that combines them. So I had to make my own: CivetWebView - https://github.com/DeXP/CivetWebView

Basically, CivetWebView is a combination of code from two examples: CivetWeb and WebView. At the moment, the project is more likely at the prototype stage - only the functionality I need has been implemented. Many things are simply set as constants in the code.

An example of project improvements: the ability to load values from a configuration file, support for full-screen mode, and the ability to dynamically set the window title and its size.



### Size

A complete Win32 application is 1.53MB. The largest component is CivetWebView, which takes up almost a megabyte. Next comes the PHP interpreter at 282 kilobytes. Rounding out the top three are Bootstrap and JQuery, which take up a total of 274 kilobytes (excluding debug map files). The application code itself (PHP + HTML + CSS) takes about 5 kilobytes.


{% include image path="CivetWebView-size.png" alt="CivetWebView size" %}


Source codes and archives with binaries can be downloaded from Github: [https://github.com/DeXP/CivetWebView-PH7-Example](https://github.com/DeXP/CivetWebView-PH7-Example)



### Licenses

Everything except PH7 is licensed under "yes, do what you want with it, we don't care at all". That is, if you exclude PH7 from the bundle, then you can make commercial applications. Can someone explain to me why? :-)


{% include image path="opensource.png" alt="Everything is opensource" %}



### Why

Initially, I did not have the task of creating a spherical GUI project in a vacuum. There was a project for an online visual novel interpreter from the DS console - [VNDS-Online](https://github.com/VaYurik/vnds-online). And I immediately wanted to be able to run these games not only on some site but also locally on my computer. Or on some other device.


{% include image path="vnds-online.png" caption="VNDS-Online game select screenshot" %}


vnds-online cannot work without a back end. At a minimum, you should be able to get a list of available games. This functionality was not too difficult to [rewrite in LUA](https://github.com/VaYurik/vnds-online/blob/master/lua/get_games_list.lua).

In addition, I wanted to give the opportunity to run games with a simple double click on the EXE file. So that even the most web development unrelated person could play.

As a result, the project turned out to be compact due to the fact that most of the code implies execution in the browser. Which is already installed in the system, well debugged and optimized. In general, thank you very much [VaYurik](https://github.com/VaYurik) for a wonderful engine.

However, `vnds-online` also has room for improvements.  For example, the engine clearly needs the ability to be localized. I would also like the ability to adapt the picture to modern wide screens. Well, debugging existing bugs, of course.



### Questions instead of conclusion

Instead of a conclusion, I want to ask the community two questions:

1. Does anyone need a CivetWebView? Is it worth developing? Would you use it? For what? Are there any real use cases where it would come in handy? Or has the world already been taken over by Electron and Node.js?
2. Does anyone need another VNDS interpreter? Perhaps for some strange platforms, but with a modern browser. Is there any point in developing `vnds-online` at all?



### Useful links

{% include buttons %}



**Other Articles**
{: .t60 }
{% include list-posts tag='articles' %}
