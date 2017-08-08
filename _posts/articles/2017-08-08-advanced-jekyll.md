---
layout: page
subheadline: "Static site creation"
title:  "Advanced Jekyll"
teaser: "<a href='https://jekyllrb.com'>Jekyll</a> is a static site generator. That means, that you give some info to it and get HTML pages as a result. It's ok when the site is pretty simple or even single page. What about more complicated websites? Will Jekyll handle it? Will it be convenient?"
categories: articles
tags:
    - articles
    - jekyll
    - github pages
    - html
    - css
    - web
image:
   thumb: "thumb/advanced-jekyll.png"
header: 
    image_fullwidth: "head/jekyll.png"
comments: true
gallery:
    - image_url: omd/OMD-s0001.jpg
    - image_url: omd/OMD-s0002.jpg
    - image_url: omd/OMD-s0003.jpg
    - image_url: omd/OMD-s0004.jpg
    - image_url: omd/OMD-s0005.jpg
    - image_url: omd/OMD-s0006.jpg
    - image_url: omd/OMD-s0007.jpg
    - image_url: omd/OMD-s0008.jpg
buttons:
    - caption: "This article in Russian"
      url: "https://habrahabr.ru/post/320834/"
      class: ""
    - caption: "dxTarRead on GitHub"
      url: "https://github.com/DeXP/dxTarRead"
      class: "success"
---

**Table of contents:**
{: #toc }
*  TOC
{:toc}




### Static HTML

[Github Pages](https://pages.github.com/) use Jekyll as generator engine. Can GitHub Pages be used without any Jekyll? Yes! You can use GitHub Pages as a simple HTML hosting (it's free) if you have a site generated in some other place.

[![Winter Novel web demo]({{ site.urlimg }}other/jekyll/wn-demo.png "Winter Novel web demo")](https://winternovel.dexp.in)


For example, [Winter Novel web Demo](https://winternovel.dexp.in) was generated in C-application. It's just a bunch of pure HTML pages, hosted on GitHub Pages! You can see the source [here](https://github.com/DeXP/WinterNovel-demo).




### Custom domains

As you can see, there is an opportunity to use your own domain name instead of *\*.github.io*. It's pretty simple. You just need to create a [CNAME](https://github.com/DeXP/WinterNovel-demo/blob/gh-pages/CNAME) file with the only line - your domain name:

```
winternovel.dexp.in
```

You can see the correct domain in your repository settings after commit:

![GitHub Pages options in repository settings]({{ site.urlimg }}other/jekyll/domain-settings.png "GitHub Pages options in repository settings")


You can use domain names of any levels. For example, [dexp.in](https://dexp.in) is hosted on GitHub too.




### CloudFlare

Another great free service is [CloudFlare](https://www.cloudflare.com). You need a DNS manager for you domains anyway. But CloudFlare not only a DNS manager but a CDN too. It means that CloudFlare can cache your pages and show them even if GitHub Pages will be down.

![dexp.in on CloidFlare]({{ site.urlimg }}other/jekyll/cloudflare-dexp-in.png "dexp.in on CloidFlare")

Main domain directly points to GitHub's IP's. Subdomains were made via cname alias to `dexp.github.io`.




### Markdown

Jekyll supports both HTML and Markdown for writing posts. HTML gives you more opportunities, but too heavy. Markdown is really cool for writing any texts. 

Examples of [HTML post](https://github.com/DeXP/onemangaday/blob/gh-pages/tutorials/_posts/2014-12-25-making-site-in-comipo.html):

```html
<p>Creating a website in Manga Maker Comipo is almost like creating it in Photoshop. That means the program is only responsible for creating the image of the future design. Everything else must be done in other programs and requires skills and knowledge of HTML and CSS.</p>
<p>Let's see an example shown below:</p>

<p class="centered"><img src="{{ page.linkadd }}pic/tutorials/site/OneMangaDay-site-comipo.png" alt="Website in Comipo" class="imgshad"></p>

<p>You can see "Layer List" panel. It already has a stack of layers. You just need to implement this stack in HTML! The most convenient way is exporting each layer as a separate image. Export can be accessed from the menu "File - Export Image File". Also you can press F2. Export options:</p>
<p class="centered"><img src="{{ page.linkadd }}pic/tutorials/site/OneMangaDay-branch-export.png" alt="Export parameters for website miking in Comipo"></p>
```

You need to add both `<p>` and `</p>` at least... And example of [Markdown post](https://raw.githubusercontent.com/DeXP/onemangaday/gh-pages/tutorials/_posts/2015-03-28-simple-game-in-renpy.md): 

```md
{% raw %}Visual novels creating is not such a difficult thing, as it might seem. And RenPy engine will help us: [http://renpy.org](http://renpy.org){:target="_blank"}. On the one hand, the engine is simple and understandable even for beginners. On the other hand, the engine is quite powerful and allows you to create really cool games. You need to download engine and install it. Nothing complicated in this process is not present, the default settings are good. Here is the RenPy main window:

![RenPy main window]({{ page.picdir }}RenPy-main-en.png){:.imgshad}

There is a list of projects on left. And active project options on the right (the active project is highlighted with blue in projects list ). To create your game you need to click "Add New Project" under the list of projects. Further, the engine will ask a few simple questions. Remember the name of the game should be in English (do not use international/unicode symbols).{% endraw %}
```

The Markdown code is much better. Just give it a try.




### Layouts

Ok, pure HTML is good. But have Jekyll something like `include` directive? I want to make my pages something like that:

```yml
include header.html
{ my strings }
include footer.html
```

Yes, Jekyll have `include`. But it is better to use it in other places. A better solution for site appearance is a layout mechanism.

Let's see some example. The page's source code will look like this:

```yml
---
layout: default
---
{ my strings }
```

And `_layouts/default.html`:

```html
{% raw %}<html>...
{{ content }}
...</html>{% endraw %}
```

So the page generates some code and stores it to the `content` variable. Jekyll can see that next file will be `_layouts/default.html` and parse it. The programmer can output `content` variable at any place of the code. 

The code is more complicated in real cases. For example, `One Manga Day's` [index page](https://github.com/DeXP/onemangaday/blob/gh-pages/index.html) and [default layout](https://github.com/DeXP/onemangaday/blob/gh-pages/_layouts/default.html) for it.




### Variables

We've touched the variables theme. So let's see the header from `One Manga Day's` [index page](https://github.com/DeXP/onemangaday/blob/gh-pages/index.html): 

```yml
---
layout: default
curlang: en
title: Home page
addcss: badges
---
```

The `layout` variable gives the Jekyll info about next file to parse. All other variables used in code by programmer like in [layout](https://github.com/DeXP/onemangaday/blob/gh-pages/_layouts/default.html): 

```html
{% raw %}<!DOCTYPE html>
<html>
	<head>
		<title>{{ site.name }} | {{ page.title }}</title> {% endraw %}
```

The `page.title` was in the page's header. The `site.name` variable is in [_config.yml](https://github.com/DeXP/onemangaday/blob/gh-pages/_config.yml). The result of this line's parsing is: `One Manga Day | Home page`




### Collections

Previous features were not very advanced. But collections help to do really powerful things. For example, galleries. And particular example: [Manga](https://onemangaday.dexp.in/manga.html) page.

![One Manga Day: Manga page]({{ site.urlimg }}other/jekyll/manga.jpg "One Manga Day: Manga page")


A short excerpt from [_data/galleries.yml](https://github.com/DeXP/onemangaday/blob/gh-pages/_data/galleries.yml):

```
- id: screenshots
  description: One Manga Day screenshots 
  imagefolder: pic/scr
  images:
  - name: OMD-s0001.png
    thumb: thumb-1.jpg
    text: Main menu
  - name: OMD-s0002.png
    thumb: thumb-2.jpg
    text: Instructor
```

In this code `site.data.galleries` collection was created. First `-` means that we created collection item. The `images` is a subcollection, each element of which has `name`, `thumb` and `text` fields.

And example how to work with this collection, [_includes/mangascript.html](https://github.com/DeXP/onemangaday/blob/gh-pages/_includes/mangascript.html):

```liquid
{% raw %}<script type="text/javascript">
  var imageGallery = [
  {% for gallery in site.data.galleries %}
    {% if gallery.id == page.galleryid %}
      {% for image in gallery.images %}
        "{{ page.linkadd }}{{ gallery.imagefolder }}/{{ image.name }}",
      {% endfor %}
    {% endif %}
  {% endfor %}
  ];
...
</script>{% endraw %}
```

The top most `for` is for see all galleries in site and choose the particular one. Another `for` is for images in this collection.

The output will be like this:

```javascript
  var imageGallery = [
        "pic/manga/OneMangaDay_000_001.png",
        "pic/manga/OneMangaDay_000_002.png", 
        ...
        "pic/manga/OneMangaDay_999.png"
  ];
```

[Good Jekyll (Liquid) reference ›](https://help.shopify.com/themes/liquid)
{: .t30 .button .radius}




### Inpage galleries

Another good approach for galleries is to store their collections in page directly. For example, One Manga Day page [source](https://raw.githubusercontent.com/DeXP/dexp.github.io/master/_posts/games/2014-06-30-onemangaday.md):

```yml
---
layout: page
title:  "One Manga Day"
gallery:
    - image_url: omd/OMD-s0001.jpg
    - image_url: omd/OMD-s0002.jpg
    - image_url: omd/OMD-s0003.jpg
...
buttons:
    - caption: "Website"
      url: "http://onemangaday.dexp.in/"
      class: "warning"
    - caption: "Steam"
      url: "http://store.steampowered.com/app/365070/"
      class: "info"
...
---
Manga are... {% raw %}
{% include gallery %}
...
{% include buttons %}
{% endraw %}
```

There are two collections, inlined to that page: `gallery` and `buttons`. The `page.gallery` and `page.buttons` are variables for using in [_includes/gallery](https://github.com/DeXP/dexp.github.io/blob/master/_includes/gallery) or [_includes/buttons](https://github.com/DeXP/dexp.github.io/blob/master/_includes/buttons).

{% include gallery %}

This method is useful for inlining info for this page only. But if you want cross site collections (to show contact/menus/etc on every page) than previous method is for you.





### Variable capture

For example, I want not to put parsed code directly to `{% raw %}{{ content }}{% endraw %}`, but put it into some variable, modify somehow, and put to the page after that.

Usual assignment:

```liquid
{% raw %}{% assign someString = "value" %}{% endraw %}
```

It is not working in this case since I want not raw-strings but preprocessed by Jekyll.

The solution is `capture` directive. Let's see an example of compress.html [bug avoid hack](https://github.com/penibelst/jekyll-compress-html/issues/71#issuecomment-188144901). Initially, you have the code like:

```liquid
{% raw %}{% highlight AnyLanguage linenos %}
Some code
{% endhighlight %}{% endraw %}
```

Change it to using `capture`:

```liquid
{% raw %}{% capture _code %}{% highlight AnyLanguage linenos %}
Some code
{% endhighlight %}{% endcapture %}{% include fixlinenos.html %}
{{ _code }}{% endraw %}
```

So highlighted code in `_code` variable. Then it will be processed by `_include/fixlinenos.html`:

```liquid
{% raw %}{% if _code contains '<pre class="lineno">' %}
    {% assign _code = _code | replace: "<pre><code", "<code" %}
    {% assign _code = _code | replace: "</code></pre>", "</code>" %}
{% endif %}{% endraw %}
```

The code just check for `<pre class="lineno">` substring. If it exists, then we have buggy HTML output. Just trim, replace it with correct ones.

[ Jekyll (Liquid) string filters ›](https://help.shopify.com/themes/liquid/filters/string-filters)
{: .t30 .button .radius}




### Custom highlight

I need to highlight some rare programming language, that is not in Jekyll opportunities. Ok, I will do it programmatically. 

I made [customhighlight.html](https://github.com/DeXP/onemangaday/blob/gh-pages/_includes/customhighlight.html) for highlighting RenPy code (based on Python language). The main idea is pretty simple and based on `replace` filter too:

```liquid
{% raw %}{% assign _customtag = "image side hide play show scene" | split: " " %}

{% for _element in _customtag %}
  {% capture _from %}<span class="n">{{ _element }}{% endcapture %}
  {% capture _to %}<span class="k">{{ _element }}{% endcapture %}
  {% assign _code = _code | replace: _from, _to %}
{% endfor %}{% endraw %}
```

Just form an array of tags, then search-replace for each one in code string. Simple. The only new thing is splitting the string into the array.

Usage example can be found [here](https://raw.githubusercontent.com/DeXP/onemangaday/gh-pages/tutorials/_posts/2015-03-28-simple-game-in-renpy.md).




### Tag cloud

The tag cloud is a more complicated task. First of all, page for each tag must be created. Secondly, there must be an array of valid tags with human-readable names. Thirdly, the script needs to count articles for each tag.

[![Tag cloud]({{ site.urlimg }}other/jekyll/tag-cloud.png "Tag cloud")](http://onemangaday.dexp.in/tutorials/)


Main calculations are in[_includes/tagcloud.html](https://github.com/DeXP/onemangaday/blob/gh-pages/_includes/tagcloud.html):

```liquid
{% raw %}<ul id="cloud">
  <li style="font-size: 150%"><a href="index.html">All</a></li>
{% for tag in site.tags %}
  {% assign curTag = tag | first | slugize %}
  {% for data_tag in landat.tags %}
    {% if data_tag.slug == curTag %}
      {% assign langtag = data_tag %}
    {% endif %}
  {% endfor %}
  <li style="font-size: {{ tag | last | size | times: 100 | divided_by: site.tags.size | plus: 20 }}%">
    <a href="{{ curTag }}.html">{{ langtag.name }}</a>
  </li>
{% endfor %}
</ul>{% endraw %}
```

The `site.tags` variable stores all used tags from all posts. The first subcycle is for search this current tag in human readable tags, defined in [_data/lang.yml](https://github.com/DeXP/onemangaday/blob/gh-pages/_data/lang.yml).

The `tag` variable from `site.tags` will be there for each iteration. It contains the list of all posts with this tag. So we can count it, multiply, divide etc. The smallest one was too small for me, so I added extra 20%.


[ Jekyll (Liquid) array filters ›](https://help.shopify.com/themes/liquid/filters/array-filters)
{: .t30 .button .radius}




### Multilingual sites

Jekyll does not support internationalization itself. So the programmer completely implements it. The easiest way is just to isolate another language materials by category: [Russian articles]({{ site.url }}/russian/).

Another way is to use a subdomain for another language. But you need to have exactly 2 sites in this case. And 10 if you have 10 languages.

![One Manga Day in Polish]({{ site.urlimg }}other/jekyll/omd-polish.png "One Manga Day in Polish"){: .center}

[One Manga Day](https://onemangaday.dexp.in) has separate folders for each language. The idea is pretty simple. For example, there is an English page `cat/page.html`. If this page has Russian variant, it will have URL `ru/cat/page.html`. You can just create all pages by hands when you have a small amount. But if there are a lot of pages, then you need to check page existence somehow. But there are no file functions in Jekyll for GitHub servers security purposes. 

You can use [_includes/CHECKEXISTS.html](https://github.com/DeXP/onemangaday/blob/gh-pages/_includes/CHECKEXISTS.html) for checking file existence. The idea is to check all site pages and posts:


```liquid
{% raw %}{% assign curUrlExists = false %}
{% assign curFUrl = curUrl | remove: ".html" %}

{% for curFile in site.pages %}
    {% assign cFile = curFile.url | remove: ".html" %}
    {% if cFile == curFUrl %}
        {% assign curUrlExists = true %}
    {% endif %}
{% endfor %}

{% for curFile in site.posts %}
    {% assign cFile = curFile.url | remove: ".html" %}
    {% if cFile == curFUrl %}
        {% assign curUrlExists = true %}
    {% endif %}
{% endfor %}{% endraw %}
```

Now you need to add only some info to your URL if an appropriate file exists.



### Comments system

The first and easiest solution - [Disqus](https://disqus.com/) or another AJAX-based JavaScript commentary system. You just inline some small JS-code into your page and all works fine.

[![One Manga Day Disqus comments]({{ site.urlimg }}other/jekyll/omd-disqus.png "One Manga Day Disqus comments")](https://onemangaday.dexp.in/feedback.html)


But I like [Staticman](https://staticman.net) - comments system, based on Pull Requests to your site repo. So comments are in Jekyll collection too! 

So the code to show your [page's comments](https://github.com/DeXP/dexp.github.io/blob/master/_includes/_comments.html):

```liquid
{% raw %}{% capture post_slug %}{{ page.url | slugify }}{% endcapture %}
{% if site.data.comments[post_slug] %}
  {% assign comments = site.data.comments[post_slug] | sort %}
				
  {% for comment in comments %}
    {% assign email = comment[1].email %}
    {% assign name = comment[1].name %}
    {% assign url = comment[1].url %}
    {% assign date = comment[1].date %}
    {% assign message = comment[1].message %}

    {% include _post-comment.html index=forloop.index 
       email=email name=name url=url date=date message=message %}
  {% endfor %}
{% endif %}{% endraw %}
```

[Posting form](https://github.com/DeXP/dexp.github.io/blob/master/_includes/_post-new-comment.html) is pretty simple too. This form is on the bottom of this page. You can moderate comments via approving pull request. Or just ask Staticman to pull comments to your site directly.




### Conclusion

Jekyll is a really cool tool for small sites and blogs. Just try it, you will love it!

![Jekyll logo]({{ site.urlimg }}other/jekyll/logo-2x.png "Jekyll logo"){: .center}




### Useful links

- [GitHub Pages](https://pages.github.com/)
- [Jekyll Themes](http://jekyllthemes.org/)
- [Liquid reference](https://help.shopify.com/themes/liquid)

**Other Articles**
{: .t60 }
{% include list-posts tag='articles' %}
