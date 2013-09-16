
PERL_GIT:=https://github.com/mirrors/perl.git
PERL_VERSION:=v5.18.1

all: perl gen.node-prelude.js
	cd perl && make -f ../Makefile.emcc
	cp perl/microperl.js .

perl:
	git clone --depth 1 -b $(PERL_VERSION) $(PERL_GIT)

gen.node-prelude.js: gen.modules.js
	echo '#!/usr/bin/env node' > $@
	cat gen.modules.js >> $@

gen.modules.js:
	perl pack-pm.pl > $@

clean:
	cd perl && git co . && git clean -dfx


