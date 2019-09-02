---
title: News
category: main
---

## Index

<ul>
{% for page in site.pages reversed %}
{% if page.category == 'news' and page.title %}
<li>
<a href="{{page.url}}">{{page.title}}</a>
</li>
{% endif %}
{% endfor %}
</ul>
