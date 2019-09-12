---
title: Wiki
category: main
---

Welcome to the KISS Linux wiki.

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
