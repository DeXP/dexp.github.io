---
layout: page
subheadline: "Vim"
title:  "Vim and keyboard layout switching"
teaser: 'All Vim commands need to be entered in English. This is a problem if the main text is entered in some other language because you need to frequently switch the layout. One of the solutions makes you get used to a new hotkey to switch layout. Also, there are many platform-dependent solutions with the call of various utilities. The goal of the vim-xkbswitch plug-in is to provide uniform behavior for many operating systems and languages.'
categories: articles
tags:
    - articles
    - linux
    - windows
    - mac os x
    - vim
    - keyboard
image:
   thumb: "thumb/vim-switch.png"
#   title: "other/qtc/qtcreator-play.png"
header: no
#    image_fullwidth: "head/matrix.jpg"
comments: true
---

![Vim and keyboard layout switching]({{ site.urlimg }}thumb/vim-switch.png "Vim and keyboard layout switching"){: .right }

[vim-xkbswitch ›](http://www.vim.org/scripts/script.php?script_id=4503)
{: .t30 .button .radius}

The plug-in uses platform-dependent libraries to change the layout of the operating system. Currently supported are:

1. UNIX / X Server through the [xkb-switch](https://github.com/ierton/xkb-switch) library
2. Windows 32/64bit, for which I had to make [xkb-switch-win](https://github.com/DeXP/xkb-switch-win)
3. Mac OS X via [Xkbswitch-macosx](https://github.com/myshov/xkbswitch-macosx)

First, you need to install the plugin into Vim. Then you need to download these libraries and specify in the Vim config, where to download these libraries. For example, under Windows you need to do this:

1. Download and install the plugin: from [here](http://www.vim.org/scripts/script.php?script_id=4503) or from [here](https://github.com/lyokha/vim-xkbswitch)
2. Download the language switching library (binary files for [32-bit](https://github.com/DeXP/xkb-switch-win/raw/master/bin/libxkbswitch32.dll) and for [64-bit](https://github.com/DeXP/xkb-switch-win/raw/master/bin/libxkbswitch64.dll), about 5kb) and copy it to the root directory of the Vim
3. Add the following lines to vimrc:

```python
let g:XkbSwitchEnabled = 1 
let g:XkbSwitchIMappings = ['ru']
```


We are approaching another interesting feature of the plugin - adding localized hotkeys. For example, if I press `<C-N> v` in the edit mode, I will see NerdTree. But if I edit the text in Russian, `<C-N> м` will be pressed and the plug-in will not start. However, if the plug-in option "g: XkbSwitchIMappings" is enabled, then the plug-in will move all the editing mode mappings to create similar localized ones, i.e. Will add `<C-N> м` for me.

By default, only the Russian language is supported from the box. However, the plugin can load language maps from a file, which will create localized imaps for any language. The [charmapgen](https://github.com/DeXP/xkb-switch-win/tree/master/charmap) utility can help to do this under Windows.

If you want to get a working plug-in for another OS, then you need to make a Vim-compatible library.


[Windows 32/64 xkb-switch-win ›](https://github.com/DeXP/xkb-switch-win) 
{: .t30 .button .radius}
[This article in Russian ›](https://habrahabr.ru/post/175709/) 
{: .t30 .button .radius .success}

## Other Articles
{: .t60 }
{% include list-posts tag='articles' %}
