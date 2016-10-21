rebuild:
	git submodule update --init --recursive
	rm -rf ./node_modules
	rm -rf ./bower_components
	npm install
	bower install --allow-root
	brunch b --production
	brunch b --production
desktop:
	rm -rf ./public/desktop_tmp
	rm -rf ./public/desktop
	mkdir ./public/desktop_tmp
	mkdir ./public/desktop
	pushd ./public/desktop_tmp && electron-packager ../../ nextgenjs --platform=all --arch=all --ignore="node_modules|bower_components|\.git" && for i in *; do zip -r $$i $$i; done && popd
	cp ./public/desktop_tmp/*.zip ./public/desktop
	rm -rf ./public/desktop_tmp
