default:	index.html

push:	rebase
	git push

rebase:	index.html
	git rebase master gh-pages
	git checkout master

index.html:	README.md nodeready.sh template.php
	php template.php > index.html

test: 
	rm .nodeready.log
	cat nodeready.sh | bash
