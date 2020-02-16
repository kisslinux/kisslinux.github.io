b=document.getElementsByTagName("pre")[0].innerHTML
b=b.replace(/(https:\/\/[^\s]+)/g,"<a href=$1>$1</a>")
