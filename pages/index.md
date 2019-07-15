---
title: ALL PAGES
category: main
---

<p>{{site.categories}}</p>

{% for category in site.categories %}
<a href="#{{category[0]|slugify}}">{{category[0]}}</a>
{% endfor %}
