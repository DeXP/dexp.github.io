---
layout: page
title: "About me"
subheadline: ""
teaser: ""
permalink: "/about/"
header:
    image_fullwidth: "Dexp_Paskevich.jpg"
buttons:
    - caption: "Gamedev"
      url: "/download/Hrabrov_CV_gamedev.pdf"
      class: "info"
    - caption: "Linux"
      url: "/download/Hrabrov_CV_linux.pdf"
      class: warning
    - caption: "Web"
      url: "/download/Hrabrov_CV_web.pdf"
      class: success
    - caption: "Source"
      url: https://github.com/DeXP/CV
      target: "_blank"
---

My name is Dmitry Hrabrov. I'm a programmer since 2004.

I started my IT education at [Gomel state regional lyceum](http://gsrl.by/) with specializing in mathematics and informatics, Olympiad programming. There were algorithmic times. I also started to write first [tools]({{ site.url }}/tools/) this time. The main language was Pascal (both Turbo and Free) and Delphi.

2006-2012 is my [University](https://www.gstu.by/) studies time. There was lot fun times and technologies: operation systems (Linux, Windows), command line, multithreading, C/C++, C#, Lisp, Prolog. Also, it was time for first commercial [websites]({{ site.url }}/sites/). So web-technologies: PHP, MySQL, HTML, CSS, JavaScript, JQuery, Prototype.js, Memcached, XML, XSLT, C++/CGI.

Post-graduate studies were in 2012-2016. At this times I started my beloved [GameDev career]({{ site.url }}/games/). It started with [One Manga Day]({{ site.url }}/games/onemangaday/): RenPy (Python), Manga Maker Comipo, Magix Music Maker. [Winter Novel]({{ site.url }}/games/winternovel/) and [Wordlase]({{ site.url }}/games/wordlase/) made in C, OpenGL, WinAPI/SDL.

Also, it was time for hardware development: C (Pic-controllers), VHDL (Xilinx), Flash memory, pseudo-random sequences generators.


### Main skills

I use Linux as my main operating system for 10 years. I prefer to write not platform-specific but cross platform applications. 

My main programming language is C. I totally love it more than 10 years. For GUI applications I prefer C++ language with Qt framework.

For web applications: I prefer PHP for dynamic applications and Jekyll for static websites.




### Curriculum vitae

[![DeXPeriX gamedev CV]({{ site.urlimg }}other/Hrabrov_CV_gamedev.png "DeXPeriX gamedev CV")]({{ site.url }}/download/Hrabrov_CV_gamedev.pdf)

{% include buttons %}



### This site statistics

{% assign blogCount = site.posts | size %}
{% assign pagesCount = site.pages | size %}
{% assign staticCount = site.static_files | size %} 
{% assign rusCount = site.categories.russian | size %}  
{% assign gamesCount = site.categories.games | size %}
{% assign toolsCount = site.categories.tools | size %}
{% assign sitesCount = site.categories.sites | size %} 
{% assign albumsCount = site.categories.photo | size %}
{% assign articlesCount = site.categories.articles | size %}

{% assign articlesWords = 0 %}
{% assign articlesChars = 0 %}
{% assign bigArticle = site.categories.articles[0] %} 
{% assign bigArtSize = bigArticle.content | number_of_words %}
{% for post in site.categories.articles %}
	{% assign curChars = post.content.size %}
	{% assign curWords = post.content | number_of_words %}
	{% if curWords > bigArtSize %}
		{% assign bigArticle = post %}
		{% assign bigArtSize = curWords %} 
	{% endif %}
	{% assign articlesWords = articlesWords | plus: curWords %}
	{% assign articlesChars = articlesChars | plus: curChars %}
{% endfor %}
{% assign wordsPerArticle = articlesWords | divided_by: articlesCount %}

{% assign rusWords = 0 %}
{% assign rusChars = 0 %}
{% assign bigRussian = site.categories.russian[0] %} 
{% assign bigRusSize = bigRussian.content | number_of_words %}
{% for post in site.categories.russian %}
	{% assign curChars = post.content.size %}
	{% assign curWords = post.content | number_of_words %}
	{% if curWords > bigRusSize %}
		{% assign bigRussian = post %}
		{% assign bigRusSize = curWords %} 
	{% endif %}
	{% assign rusWords = rusWords | plus: curWords %}
	{% assign rusChars = rusChars | plus: curChars %}
{% endfor %}
{% assign wordsPerRus = rusWords | divided_by: rusCount %}
{% assign bigRusChars = bigRussian.content.size %}

{% assign photoCount = 0 %}
{% for post in site.categories.photo %}
	{% assign curPhotos = post.gallery.size %}
	{% assign photoCount = photoCount | plus: curPhotos %}
{% endfor %}

{% assign postsWords = 0 %}
{% assign oldest = site.posts[0] %}
{% assign newest = site.posts[0] %} 
{% for post in site.posts %}
	{% if post.date < oldest.date %}
		{% assign oldest = post %}
	{% endif %}
	{% if post.date > newest.date %}
		{% assign newest = post %}
	{% endif %}
	{% assign curWords = post.content | number_of_words %}
	{% assign postsWords = postsWords | plus: curWords %}
{% endfor %}

{% assign genTime = site.time   | date: "%Y-%m-%d" %}
{% assign oldTime = oldest.date | date: "%Y-%m-%d" %}
{% assign newTime = newest.date | date: "%Y-%m-%d" %}
 

|-------------------------|---------------------------|-------------------------|---------------------------|
| Parameter               | Value                     | Parameter               | Value                     |
|------------------------:|---------------------------|------------------------:|---------------------------|
| Total [blog][1] posts   | **{{ blogCount }}**       | [Articles][5] count     | **{{ articlesCount }}**   | 
|-------------------------|---------------------------|-------------------------|---------------------------|
| [Games][2] count        | **{{ gamesCount }}**      | Total words in articles | **{{ articlesWords }}**   |
|-------------------------|---------------------------|-------------------------|---------------------------|
| [Tools][3] count        | **{{ toolsCount }}**      | Characters in articles  | **{{ articlesChars }}**   |
|-------------------------|---------------------------|-------------------------|---------------------------|
| [Sites][4] count        | **{{ sitesCount }}**      | Words per one article   | **{{ wordsPerArticle }}** |
|-------------------------|---------------------------|-------------------------|---------------------------|
| [Photo albums][6]       | **{{ albumsCount }}**     | Biggest article (words) | **[{{ bigArtSize }}][10]**|
|-------------------------|---------------------------|-------------------------|---------------------------| 
| Photos count            | **{{ photoCount }}**      | [Russian][7] materials  | **{{ rusCount }}**        | 
|-------------------------|---------------------------|-------------------------|---------------------------|
| Static files            | **{{ staticCount }}**     | Total words in russian  | **{{ rusWords }}**        |
|-------------------------|---------------------------|-------------------------|---------------------------|
| Total pages             | **{{ pagesCount }}**      | Characters in russian   | **{{ rusChars }}**        |
|-------------------------|---------------------------|-------------------------|---------------------------|
| Oldest post             | **[{{ oldTime }}][8]**    | Words per one russian   | **{{ wordsPerRus }}**     |
|-------------------------|---------------------------|-------------------------|---------------------------|
| Newest post             | **[{{ newTime }}][9]**    | Biggest russian (words) | **[{{ bigRusSize }}][11]**| 
|-------------------------|---------------------------|-------------------------|---------------------------|
| Generated on            | **{{ genTime }}**         | Words in all posts      | **{{ postsWords }}**      |  
|-------------------------|---------------------------|-------------------------|---------------------------|


[1]: {{ site.url }}/blog/
[2]: {{ site.url }}/games/
[3]: {{ site.url }}/tools/
[4]: {{ site.url }}/sites/
[5]: {{ site.url }}/articles/
[6]: {{ site.url }}/photo/
[7]: {{ site.url }}/russian/
[8]: {{ site.url }}{{ oldest.url }}
[9]: {{ site.url }}{{ newest.url }}
[10]: {{ site.url }}{{ bigArticle.url }}
[11]: {{ site.url }}{{ bigRussian.url }}

