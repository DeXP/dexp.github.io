---
layout: category
title: "Photo"
permalink: "/photo/"
header:
    image_fullwidth: "Dexp_sea_run.jpg" 
---
{% comment %}
<div class="row">
	<div class="medium-8 columns t30">
		{% include _post.html posts=site.categories.photo %}
	</div><!-- /.medium-7.columns -->

	<div class="medium-4 columns t30">
	<div class="panel radius">
		<h3>Photos</h3>
		<p>Here you can find photos, made by DeXPeriX.</p>
	</div>

	</div><!-- /.medium-5.columns -->
</div><!-- /.row -->
{% endcomment %}


<div class="row">
<div class="medium-12 columns t30">

<h3>DeXPeriX's photoalbums.</h3>

{% assign postsByYear = site.categories.photo | group_by_exp:"post", "post.date | date: '%Y'"  %}
{% for yearItem in postsByYear %}
  <h2 id="y{{ yearItem.name }}" class="t60">{{ yearItem.name }}</h2>
   <div class="row">
 
      {% for post in yearItem.items %}
<div class="column">
		{% if post.image.thumb %}<a href="{{ site.url }}{{ post.url }}" title="{{ post.title | escape }}"><img src="{{ site.urlimg }}{{ post.image.thumb }}" class="alignleft" width="150" height="150" alt="{{ page.title | escape }}"></a>{% endif %}

        <h2><a href="{{ site.url }}{{ post.url }}">{{ post.title }}</a></h2>

		{% if post.meta_description %}{{ post.meta_description | strip_html | escape }}{% elsif post.teaser %}{{ post.teaser | strip_html | escape }}{% endif %}

		<a href="{{ site.url }}{{ post.url }}" title="{{ site.data.language.read }} {{ post.title | escape | remove:'"' }}"><strong>{{ site.data.language.read_more }}</strong></a>
</div>

      {% endfor %}
    </div>
{% endfor %}

	</div><!-- /.medium-5.columns -->
</div><!-- /.row -->

