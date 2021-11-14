update:
	git submodule update --init --recursive
	hugo # hugo -d docs
server:
	hugo server
