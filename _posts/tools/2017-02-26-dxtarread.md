---
layout: page
subheadline: "Console"
title:  "dxTarRead"
teaser: "A minimalistic non compressed archive file readers written in ANSI C. Supported formats: GNU tar (tape archive) and PAX in tar-compatibility mode, GNU ar, Cpio (binary for little- and big-endian machines, old an new ACSII)."
categories: tools
tags:
    - tools
    - windows
    - linux
    - c
image:
   thumb: "thumb/dxtarread.png"
buttons:
    - caption: "dxTarRead on GitHub"
      url: "https://github.com/DeXP/dxTarRead"
      class: "info"
    - caption: "Article about TAR reading"
      url: "{{ site.url }}/articles/read-tar-in-26-lines/"
      class: success
comments: true
---

![dxTarRead]({{ site.urlimg }}thumb/dxtarread.png "dxTarRead"){: .right }

- public domain
- single file with one function for each format (tar, ar, binary cpio)
- less than 50 lines of code, including comments, license and blanks
- or one file for all formats - more complicated, but more powerful
- easy to use, just returns a pointer to your file inside archive
- no dependencies (even stdlibc not used), embedded friendly
- requires no memory/malloc or copying, uses only what is passed in
- optimized for high speed routing of small archive files, stops parsing upon match
- designed to work in pair with tinfl.c from miniz

{% include buttons %}

## Other TAR
{: .t60 }
{% include list-posts tag='tar' %}
