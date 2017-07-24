---
layout: page
subheadline: "GUI"
title:  "AqPicFlash"
teaser: "This application is an attempt to understand how flash memory works. The code is executed both on the controller and application. Used memory chips: Samsung, Hynix."
categories: tools
tags:
    - tools
    - gui
    - crossplatform
    - qt
    - hardware
header:
    image_fullwidth: "head/aqpicflash.jpg"
image:
   thumb: "thumb/aqpicflash.png"
#   title: "other/cagui/info.png"

gallery:
    - image_url: other/picf/photo/01.jpg
    - image_url: other/picf/photo/02.jpg
    - image_url: other/picf/photo/03.jpg
    - image_url: other/picf/photo/04.jpg
    - image_url: other/picf/photo/05.jpg
    - image_url: other/picf/photo/06.jpg
    - image_url: other/picf/photo/07.jpg
    - image_url: other/picf/photo/08.jpg
---

Start screen: 

![AqPicFlash - Start screen]({{ site.urlimg }}other/picf/start.png "AqPicFlash - Start screen")


Debugging form. You can control the Pic18f2550 controller from this form. 

![AqPicFlash - Debug form]({{ site.urlimg }}other/picf/debug-form.png "AqPicFlash - Debug form")


Concrete chip info is shown on "Chip info" form:

![AqPicFlash - Chip info]({{ site.urlimg }}other/picf/chip-info.png "AqPicFlash - Chip info")



The utility works with self-made hardware only.

{% include gallery %}


The utility has an Android version:

![AqPicFlash - Android]({{ site.urlimg }}other/picf/andr/menu.png "AqPicFlash - Android")



{% comment %}
[Download DexpCAgui binary ›]({{ site.release_url }}v.2015-07-18/DexpCAgui.zip) 
{: .t30 .button .radius}
[DexpCAgui for Android ›]({{ site.release_url }}v.2015-07-18/DexpCAandroid-debug.apk)
{: .t30 .button .radius .success}
{% endcomment %}


## Other Tools
{: .t60 }
{% include list-posts tag='tools' %}
