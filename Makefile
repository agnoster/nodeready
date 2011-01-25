default:	index.html

push:	rebase
	git push

rebase:	index.html
	git rebase master gh-pages

index.html:	README.md nodeready.sh template.php
	php template.php > index.html
