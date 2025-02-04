update:
	git submodule foreach git pull # git submodule update --init --recursive
	rm -rf docs
	mkdir docs
	hugo -d docs
server:
	hugo server
