---
title: News
category: main
---

Apologies if this is broken, the News page is in the process of being split into multiple pages so an RSS feed can be added!

## Index

<ul>
{% for page in site.pages reversed %}
{% if page.category == 'news' %}
{% if page.title % }
<li>
<a href="{{page.url}}">{{page.title}}</a>
</li>
{% endif %}
{% endif %}
{% endfor %}
</ul>
