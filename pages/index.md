---
title: ALL PAGES
category: main
---

## Main

<ul>
{% for page in site.pages %}
{% if page.category == 'main' %}
    <li><a href="{{page.url}}">{{page.title}}</a></li>
{% endif %}
{% endfor %}
</ul>
