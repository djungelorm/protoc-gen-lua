.PHONY: all rockspec build install-test clean


VERSION = 1.1.1
NAME = protobuf-$(VERSION)-0
OUTPUTDIR = $(BUILDDIR)/$(NAME)

all: build

rockspec:
	mkdir -p $(OUTPUTDIR)
	sed "s/%VERSION%/$(VERSION)/g" protobuf.rockspec > $(OUTPUTDIR)/$(NAME).rockspec

build: rockspec
	mkdir -p $(OUTPUTDIR)/protobuf
	mkdir -p $(OUTPUTDIR)/src
	cp README.md LICENSE $(OUTPUTDIR)/
	cp -R protobuf/*.lua $(OUTPUTDIR)/protobuf/
	cp -R protobuf/*.c $(OUTPUTDIR)/src/
	cp -R protoc-plugin $(OUTPUTDIR)/
	(cd $(BUILDDIR); tar czvpf $(NAME).tar.gz $(NAME)/)

install: build
	cd $(OUTPUTDIR); luarocks make $(NAME).rockspec

clean:
	rm -rf *.rockspec *.rock src/pb.o src/pb.so tree
	find . -name "*.pyc" -exec rm -rf {} \;
