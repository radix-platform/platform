#!/usr/bin/make -f

#
# NOTES:
#   Unpack scowl-$VERSION.tar.gz, create 'scowl-$VERSION/build'
#   directory and copy this file and man pages template
#   'wordlist.5.in' into 'scowl-$VERSION/build'.
#   Then change dir to 'scowl-$VERSION' and run make command:
#
#     $ make -f build/build.mk build
#
#   Use
#
#     $ make -f build/build.mk clean
#
#   command for cleanig results.
#
#   For partial building chortify the $(sizes) and
#   $(spellings) lists in this file below.
#


man_page_template = $(CURDIR)/build/wordlist.5.in

#
# available package sizes: small "" large huge insane
#
sizes = small "" large huge insane

# scowl file extensions:
size_exts_small  :=                    10 20 35
size_exts        := $(size_exts_small) 40 50
size_exts_large  := $(size_exts)       55 60 70
size_exts_huge   := $(size_exts_large) 80
size_exts_insane := $(size_exts_huge)  95

export size_exts_small
export size_exts
export size_exts_large
export size_exts_huge
export size_exts_insane

#
# available scowl languages: american british canadian
#
spellings := american british canadian

# scowl word list classes:
classes   := words proper-names upper contractions
variants  := 0 1

build-stamp = .built

build: $(build-stamp)

$(build-stamp):
	@set -e ; \
	 for spelling in $(spellings) ; do \
	   suffix= ; \
	   if   [ "$$spelling" == "american" ] ; then suffix="en_US" ; \
	   elif [ "$$spelling" == "british"  ] ; then suffix="en_GB" ; \
	   elif [ "$$spelling" == "canadian" ] ; then suffix="en_CA" ; \
	   else suffix= ; \
	   fi ; \
	   for size in $(sizes) ; do \
	     if [ -n "$$size" ] ; then sizename="_$$size" ; size="-$$size" ; else sizename="" ; size="" ; fi ; \
	     echo ""                                                      > words-$$suffix$$size.scowl-wordlists ; \
	     echo "The following SCOWL word lists were concatenated and" >> words-$$suffix$$size.scowl-wordlists ; \
	     echo "sorted (with duplicates removed) to create this word" >> words-$$suffix$$size.scowl-wordlists ; \
	     echo "list:"                                                >> words-$$suffix$$size.scowl-wordlists ; \
	     echo ""                                                     >> words-$$suffix$$size.scowl-wordlists ; \
	     for class in $(classes) ; do \
	       for ext in $$(eval echo "\$$""size_exts$$sizename") ; do \
	         if [ "$$sizename" != "" ] ; then \
	           shtool echo -e "%B####### collecting%b: %Bclass%b=$$class %Bext%b=$$ext %Bsize%b=`echo $$sizename | sed -e 's/^_//'` ..." ; \
	         else \
	           shtool echo -e "%B####### collecting%b: %Bclass%b=$$class %Bext%b=$$ext ..." ; \
	         fi ; \
	         if [ -f final/english-$$class.$$ext ] ; then \
	           cat final/english-$$class.$$ext >> $$spelling-english$$size.unsorted ; \
	           echo "   english-$$class.$$ext" >> words-$$suffix$$size.scowl-wordlists ; \
	         fi ; \
	         for variant in $(variants) ; do \
	           if [ -f final/variant_$$variant-$$class.$$ext ] ; then \
	             cat final/variant_$$variant-$$class.$$ext >> $$spelling-english$$size.unsorted ; \
	             echo "   variant_$$variant-$$class.$$ext" >> words-$$suffix$$size.scowl-wordlists ; \
	           fi ; \
	         done ; \
	         if [ "$$size" = "insane" ] ; then \
	           for special in special_hacker.50 ; do \
	             cat final/final/$$special >> $$spelling-english$$size.unsorted ; \
	             echo "   final/$$special" >> words-$$suffix$$size.scowl-wordlists ; \
	           done ; \
	         fi ; \
	         if [ -f final/$$spelling-$$class.$$ext ] ; then \
	           cat final/$$spelling-$$class.$$ext >> $$spelling-english$$size.unsorted ; \
	           echo "   $$spelling-$$class.$$ext" >> words-$$suffix$$size.scowl-wordlists ; \
	         fi ; \
	       done ; \
	     done ; \
	     shtool echo -e "%B####### dictionary%b: $$spelling-english$$size - %Bdone%b" ; \
	     cat $$spelling-english$$size.unsorted | sort -u | iconv -f 'iso8859-1' -t 'utf-8' > $$spelling-english$$size ; rm $$spelling-english$$size.unsorted ; \
	     cat $(man_page_template) | sed -e "s/@WORDLIST@/$$spelling-english$$size/g" > $$spelling-english$$size.5 ; \
	   done ; \
	 done
	@touch $@

clean:
	@set -e ; \
	 for size in $(sizes) ; do \
	   if [ -n "$$size" ]; then size="-$$size" ; fi ; \
	   for spelling in $(spellings) ; do \
	     suffix= ; \
	     if   [ "$$spelling" == "american" ] ; then suffix="en_US" ; \
	     elif [ "$$spelling" == "british"  ] ; then suffix="en_GB" ; \
	     elif [ "$$spelling" == "canadian" ] ; then suffix="en_CA" ; \
	     else suffix= ; \
	     fi ; \
	     rm -f $$spelling-english$$size.unsorted \
	           $$spelling-english$$size          \
	           $$spelling-english$$size.5        \
	           words-$$suffix$$size.scowl-wordlists ; \
	   done;\
	 done
	@rm -f $(build-stamp)
