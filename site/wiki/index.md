---
title: WIKI
category: main
---

Welcome to the KISS Linux WIKI.

## Index

<ul>
{% for page in site.pages reversed %}
{% if page.category == 'wiki' and page.title %}
<li>
<a href="{{page.url}}">{{page.title}}</a>
</li>
{% endif %}
{% endfor %}
</ul>
