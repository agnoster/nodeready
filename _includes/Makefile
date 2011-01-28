test:	nodeready.sh
	cat nodeready.sh | bash

push:
	git checkout gh-pages
	git merge master -s subtree
	git push
	git checkout master
