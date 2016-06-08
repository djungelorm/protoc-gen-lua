.PHONY: all rockspec build install-test clean

VERSION = 1.1.1
NAME = protobuf-lua-$(VERSION)-0

all: build

rockspec:
	sed "s/%VERSION%/$(VERSION)/g" protobuf-lua.rockspec.tmpl > protobuf-lua-$(VERSION)-0.rockspec

build: rockspec
	luarocks pack protobuf-lua-$(VERSION)-0.rockspec

install-test: build
	luarocks --tree=tree install protobuf-lua-1.1.1-0.src.rock

clean:
	rm -rf *.rockspec *.rock src/pb.o src/pb.so tree
	find . -name "*.pyc" -exec rm -rf {} \;
