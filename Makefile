
PERL_GIT:=https://github.com/Perl/perl5.git
PERL_VERSION:=v5.18.1

all: microperl.js
	echo '(function bootPerl() {' > perl.js
	cat prelude.js >> perl.js
	cat microperl.js >> perl.js
	echo '}());' >> perl.js
	echo '#!/usr/bin/env node' > perl-cli.js
	cat perl.js >> perl-cli.js
	chmod +x perl-cli.js
	mv perl.js web/assets

microperl.js: perl5 gen.modules.js
	cd perl5 && make -f ../Makefile.emcc
	cp perl5/microperl.js microperl.js

perl5:
	git clone --depth 1 -b $(PERL_VERSION) $(PERL_GIT)

gen.modules.js: # may have NO_MODULES=1
	perl pack-pm.pl > $@

gh-pages:
	#JAVA_TOOL_OPTIONS=-Xmx1024m closure-compiler --compilation_level WHITESPACE_ONLY --js web/perl.js --js_output_file perl.js
	cp -r web/* .
	git add -f index.html assets/*.*

update-gh-pages:
	git checkout gh-pages
	git merge master
	make gh-pages
	git commit -am 'make gh-pages'
	git checkout -
	git push origin gh-pages

clean:
	cd perl5 && git co . && git clean -dfx
	rm -rf microperl.js perl.js perl-cli.js

