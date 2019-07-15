---
title: ALL PAGES
category: main
---

{% for category in site.categories %}
    {{category}}
    <ul>
    {% for page in site.pages %}
    {% if page.category == category %}
    <li><a href="{{page.url}}">{{page.title}}</a></li>
    {% endif %}
    {% endfor %}
    </ul>
{% endfor %}
