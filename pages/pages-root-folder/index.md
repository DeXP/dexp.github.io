---
#
# Use the widgets beneath and the content will be
# inserted automagically in the webpage. To make
# this work, you have to use › layout: frontpage
#
layout: frontpage
header:
  image_fullwidth: Dexp_Tesla.jpg
widget1:
  title: "Games & Fun"
  url: '/games/'
  image: 'widget-games-303x182.jpg'
  text: 'Some great games:<br/>1. One Manga Day - visual novel<br/>2. Winter Novel - visual novel<br/>3. Wordlase - word puzzle<br/>Available on <em>Steam</em>!'
widget2:
  title: "Tools & Utilities"
  url: '/tools/'
  image: 'widget-tools-303x182.jpg'
  text: 'Different tools. Starting from different calculators and ends with pseudo-random sequences generators!<br/>Most of the tools have the source code. So you can compile it by yourself.'
widget3:
  title: "Sites & Applications"
  url: '/sites/'
  image: 'widget-sites-303x182.jpg'
  text: 'Commercial and opensource websites.<br/>PHP, Jekyll, AJAX, JQuery and many other interesting technologies!<br/>Also web-based HTML/JavaScript applications.'

#
# Use the call for action to show a button on the frontpage
#
# To make internal links, just use a permalink like this
# url: /getting-started/
#
# To style the button in different colors, use no value
# to use the main color or success, alert or secondary.
# To change colors see sass/_01_settings_colors.scss
#
#callforaction:
#  url: https://tinyletter.com/feeling-responsive
#  text: Inform me about new updates and features ›
#  style: alert
permalink: /index.html
---
{% comment %}
<div id="videoModal" class="reveal-modal large" data-reveal="">
  <div class="flex-video widescreen vimeo" style="display: block;">
    <iframe width="1280" height="720" src="https://www.youtube.com/embed/3b5zCFSmVvU" frameborder="0" allowfullscreen></iframe>
  </div>
  <a class="close-reveal-modal">&#215;</a>
</div>
{% endcomment %}
