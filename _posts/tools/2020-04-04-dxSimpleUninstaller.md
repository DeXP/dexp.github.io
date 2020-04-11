---
layout: page
subheadline: "GUI"
title:  "dxSimpleUninstaller"
teaser: "dxSimpleUninstaller is a Simple GUI script to uninstall your Windows applications. The tool contains ~100 lines of code, written in PowerShell. "
categories: tools
tags:
    - tools
    - powershell
    - gui
    - windows
header: no
image:
   thumb: "thumb/dxSimpleUninstaller.png"
   title: "other/dxSimpleUninstaller.png"
---

The stuff bundled in:

- Dark WPF UI theme
- Registry parser
- Uninstall command parser and invoker
- Filtering and sorting around the data

## Why?
Windows Core (Server, no UI version) does not have any visual interface for the uninstallation of applications on the target machine. But it can be handy if you creating an application installer and want to verify it on the server.

Or maybe you just need easy and fast access to uninstall? :-)

## How does it work
The tool gets the list of the entries in the registry: HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\

The uninstall command can be like this: `MsiExec.exe /I{bla-blah}`, i.e. "Do you want to uninstall or modify?". Windows Core does not like it and runs nothing. So the format is automatically changed to: `MsiExec.exe /X{bla-blah}`,  i.e. "Uninstall this app?"

Then uninstall command invoked. No additional folders cleaning etc - do just what uninstaller do.


[GitHub ›](https://github.com/DeXP/dxSimpleUninstaller)
{: .t30 .button .radius}


## Other Tools
{: .t60 }
{% include list-posts tag='tools' %}