---
title: ALL PAGES
category: main
---

{% for category in site.categories %}
    {{category | first | strip_html}}
    <ul>
    {% for page in site.pages %}
    {% if page.category == {{category | first | strip_html}} %}
    <li><a href="{{page.url}}">{{page.title}}</a></li>
    {% endif %}
    {% endfor %}
    </ul>
{% endfor %}
