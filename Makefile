update: clean
	git submodule update --remote --merge
	hugo

server:
	hugo server

clean:
	rm -rf docs resources public
