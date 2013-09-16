
PERL_GIT:=https://github.com/mirrors/perl.git
PERL_VERSION:=v5.18.1

all: perl
	cd perl && make -f ../Makefile.emcc
	cp perl/microperl.js .

perl:
	git clone --depth 1 -b $(PERL_VERSION) $(PERL_GIT)

clean:
	cd perl && git co . && git clean -dfx

