---
layout: page
subheadline: "Linux"
title:  "Double Commander - Russian free Total Commander"
teaser: 'Double Commander is a cross platform open source file manager with two panels side by side. It is inspired by Total Commander and features some new ideas. It is written in Lazarus - some people think that pascal is a language for learning only. But on the other hand, it is possible to implement support for plugins from Total Commander easily, a little speed up development and give the user a choice of libraries to display the user interface (QT or GTK - are relevant only for Linux).'
categories: articles
tags:
    - articles
    - file manager
    - linux
image:
   thumb: "thumb/doublecmd.png"
header:
    image_fullwidth: "other/kde430-desktop.png"
redirect_from:
  - "/articles/linux/double_commander+blp+en.html"
  - "/articles/linux/double_commander+npi+en.html"
  - "/articles/linux/double_commander+gray+en.html"
comments: true
---

![Double Commander in Windows XP]({{ site.urlimg }}other/dcmd/MainWindow_small.png "Double Commander in Windows XP")



Let's consider the upper part of Double Commander a little more in detail:

![Double Commander: main menu]({{ site.urlimg }}other/dcmd/MainWindow_levels.png "Double Commander: main menu")


1 - the main menu. It is not used very often, but if something is missing - take it there.

2 - the toolbar. By default, there is quite a few buttons, the usefulness is questionable. In the screenshot the main used programs are placed: GIMP, a notepad, a browser, a player. Maybe it’s useful for someone. Personally, I have it all either on the desktop or in the Quick Launch toolbar. So it’s great that there is an opportunity to disable this toolbar.  

3 - disk buttons. I have used them occasionally in Total Commander, but in Double Commander somehow immediately liked the selection button of the current drive in the 4 line. I left only the button.

The 4 line except buttons drive has useful buttons on the right: the return to a higher level, moving into a home / root directory, menu, the favorite directories, which is proposed to replenish itself to the user.

5 - tabs. It’s a very useful thing when working with files. However, with just one tab it is not rational to display it as on-screen space is wasted. Fortunately, Double Commander has the option of "Folder tabs - Show tab header also when there is only one tab". Just uncheck this and tabs bar will appear only when creating the second tab (`Ctrl + T`). After closing the tab (`Ctrl + W`), the line will disappear automatically.

6 - current directory name. There you can see a full path. If you lose where you are, it is enough to look at this line and everything will be clear :)

7 - tabstop header. The standard behavior is to click for sorting, pull the edge to resize.

As a result, my Double Commander looks like this:

![Tuned Double Commander by DeXPeriX]({{ site.urlimg }}other/dcmd/my_win_800.png "Tuned Double Commander by DeXPeriX")

And modern Windows 10 version:

![Tuned Double Commander by DeXPeriX Windows 10]({{ site.urlimg }}other/dcmd/dcmd-win10.png "Tuned Double Commander by DeXPeriX Windows 10")


By the way, the preferences dialog is rather intuitive, friendly and pleasant. It was a pleasure to set up a program for myself. For example, to get a Double Commander as in the previous screenshot, I used the following layout configuration:

![Options dialog Double Commander]({{ site.urlimg }}other/dcmd/win_options.png "Options dialog Double Commander"){: .center}


A little more cool features of Double Commander. One of the most pleasant surprises was "Behaviors - Lynx like movement". This means that to go to the directory you can press Enter or the right arrow. To return to the directory above - the left arrow. At the result you can easily work using the keyboard arrows only.

"Quick Search - Letter only" turns on a quick search, similar to Total Commander. That is, you simply start typing the file name on the keyboard and the cursor automatically moves to the closest match.

Well, the most important super opportunity is the support for plugins from Total Commander. I was interested in Ext2+Reiser. You can find it on page http://www.ghisler.com/plugins.htm. Periodically you need to download a music form Linux-partition, watch some config files. To run a separate program for that is lazy and strange. This plugin also allows you to display ReiserFS/Ext2/Ext3/Ext4 partition almost like a local folder (read only). Also with version 1.4 supports UTF-8, which solved the problem with strange symbols instead of letters, if your system language is not English. The viewer also has no problems with viewing text files and allows you to change the encoding on the fly.


Installing the plugins into Double Commander is exactly 3 times harder than Total Commander :D  This means that just to click 2 times on the archive is not enough - you need to unpack it anywhere. For simplicity, I extract it to a subfolder plugins of program. Then, go to the settings dialog "Configure - Plugins - File system plugins". Next, click the "Add" button and select the unzipped WFX-file.

![Installing WFX-plugin into Double Commander]({{ site.urlimg }}other/dcmd/adding-plugin.png "Installing WFX-plugin into Double Commander")


By the way for the functioning of the UTF-8 do not forget to create a file *ex2fs.ini* in a directory with a wfx-file. The content is:

```ini
[Options]
utf8=true
```

Not without some drawbacks. Thus, the shortcomings of Double Commander: 

1. It is slow. Of course not really, but for a while waiting for the opening of the directory still exists. Total Commander displays the contents almost instantly. 
2. No wrapping in the embedded text editor. Built-in viewer and editor as a whole looks very good and promising. However, to date (version 0.4.5.2), there are some problems with the folding of long lines.

![Double Commander. Built-in text editor]({{ site.urlimg }}other/dcmd/editor.png "Double Commander. Built-in text editor"){: .center }


3. The project is under active development. Periodically, there are disadvantages or drawbacks. This is especially evident when using the plugins from Total Commander - Double Commander periodically issues an error and crashes. Have to restart ;)

4. Not everything is rosy for Linux. For example, I still have a very slow rendering when resizing the window with the mouse. Frankly speaking, I have not used Double Commander on Linux for a long time and do not plan to do it - mc (Midnight Commander) is our all :)

![Dark theme of Double Commander in Linux, GTK2]({{ site.urlimg }}other/dcmd/dcommander-lnx-sml.png "Dark theme of Double Commander in Linux, GTK2")


I do not like light color theme for my files. So I changed a colors a bit:

![Tuned Double Commander by DeXPeriX in Linux]({{ site.urlimg }}other/dcmd/doublecmd-linux-2017.png "Tuned Double Commander by DeXPeriX in Linux")


### Conclusion:

A great free alternative! Despite some minor shortcomings, you can forget about proprietary Total Commander and use the free Double Commander.


[This publication in Russian ›]({{ site.url }}/russian/double-commander/)
{: .t30 .button .radius}
