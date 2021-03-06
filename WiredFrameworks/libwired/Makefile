# Makefile.in

abs_top_srcdir	= /Users/mojavemac/Desktop/WiredServer/wired/libwired
datarootdir		= ${prefix}/share
objdir			= ../obj
rundir			= ../run/libwired
headerdir		= $(rundir)/include/wired
empty			=

WI_VERSION		= 1.0
WI_MAINTAINER	= 0

DISTFILES		= LICENSE Makefile Makefile.in config.guess config.h.in \
				  config.status config.sub configure configure.in install-sh \
				  libwired test
SOURCEDIRS		= $(abs_top_srcdir)/libwired $(abs_top_srcdir)/test

VPATH			= $(subst $(empty) $(empty),:,$(shell find $(SOURCEDIRS) -name ".*" -prune -o -type d -print))
LIBWIREDOBJECTS	= $(addprefix $(objdir)/libwired/,$(sort $(notdir $(patsubst %.c,%.o,$(shell find $(abs_top_srcdir)/libwired -name "[a-z]*.c")))))
TESTOBJECTS		= $(addprefix $(objdir)/libwired/,$(notdir $(patsubst %.c,%.o,$(shell find $(abs_top_srcdir)/test -name "[a-z]*.c"))))
TESTSOBJECTS	= $(addprefix $(objdir)/libwired/,$(notdir $(patsubst %.c,%.o,$(shell find $(abs_top_srcdir)/test/tests -name "[a-z]*.c"))))
HEADERS			= $(addprefix $(headerdir)/,$(notdir $(shell find $(abs_top_srcdir)/libwired -name "[a-z]*.h")))
			  
DEFS			= -DHAVE_CONFIG_H
CC				= gcc
CFLAGS			= -g -O2
CPPFLAGS		= -I/usr/local/opt/openssl/include -I/usr/local/include -DWI_CORESERVICES -DWI_CARBON -DWI_DIGESTS -DWI_CIPHERS -DWI_PTHREADS -I/usr/include/libxml2 -DWI_LIBXML2 -DWI_PLIST -DWI_SQLITE3 -DWI_RSA -DWI_ZLIB -DWI_P7 -DWI_TEST_ROOT=\"$(abs_top_srcdir)/test\"
LDFLAGS			= -L$(rundir)/lib -L/usr/local/opt/openssl/lib -L/usr/local/lib
LIBS			= -lwired -framework CoreServices -framework Carbon -lxml2 -lsqlite3 -lcrypto -lz
INCLUDES		= -I$(abs_top_srcdir) -I$(rundir)/include -I$(abs_top_srcdir)/test

COMPILE			= $(CC) $(DEFS) $(INCLUDES) $(CPPFLAGS) $(CFLAGS)
PREPROCESS		= $(CC) -E $(DEFS) $(INCLUDES) $(CPPFLAGS) $(CFLAGS)
DEPEND			= $(CC) -MM $(INCLUDES) $(CPPFLAGS)
LINK			= $(CC) $(CFLAGS) $(LDFLAGS) -o $@
ARCHIVE			= ar rcs $@

.PHONY: all test dist clean distclean scmclean

ifeq ($(WI_MAINTAINER), 1)
ALL				= Makefile configure config.h.in $(rundir)/lib/libwired.a $(rundir)/test
else
ALL				= $(rundir)/lib/libwired.a
endif

all: $(ALL)

ifeq ($(WI_MAINTAINER), 1)
Makefile: Makefile.in config.status
	$(abs_top_srcdir)/config.status
	
configure: configure.in
	autoconf

config.h.in: configure.in
	autoheader
	touch $@
	rm -f $@~
endif
	
$(rundir)/lib/libwired.a: $(HEADERS) $(LIBWIREDOBJECTS)
	@test -d $(@D) || mkdir -p $(@D)
	$(ARCHIVE) $(LIBWIREDOBJECTS)
	
$(objdir)/libwired/%.o: %.c
	@test -d $(@D) || mkdir -p $(@D)
	$(COMPILE) -I$(<D) -c $< -o $@

$(objdir)/libwired/%.d: %.c
	@test -d $(@D) || mkdir -p $(@D)
	($(DEPEND) $< | sed 's,$*.o,$(@D)/&,g'; echo "$@: $<") > $@

$(headerdir)/%.h: %.h
	@test -d $(@D) || mkdir -p $(@D)
	cp $< $@

test: $(rundir)/test
	@MallocStackLogging=1 $(rundir)/test
	
$(rundir)/test: $(rundir)/lib/libwired.a $(TESTOBJECTS)
	@test -d $(@D) || mkdir -p $(@D)
	$(LINK) $(TESTOBJECTS) $(LIBS)
ifeq ($(WI_MAINTAINER), 1)
	@MallocStackLogging=1 $(rundir)/test
endif

$(objdir)/libwired/test.o: test/testlist.h test/testlist.inc

test/testlist.h: $(TESTSOBJECTS)
	-grep -h WI_TEST_EXPORT $(wildcard test/tests/*.c) > $@
	
test/testlist.inc: test/testlist.h
	perl -ne '$$s=(split(/\s+/))[2]; $$s=~ s/(\w+).*/$$1/; print "wi_tests_run_test(\"$$s\", $$s);\n";' $< > $@
	
dist:
	rm -rf libwired-$(WI_VERSION)
	rm -f libwired-$(WI_VERSION).tar.gz
	mkdir libwired-$(WI_VERSION)

	@for i in $(DISTFILES); do \
		if [ -e $$i ]; then \
			echo cp -LRp $$i libwired-$(WI_VERSION)/$$i; \
			cp -LRp $$i libwired-$(WI_VERSION)/$$i; \
		fi \
	done

	$(SHELL) -ec "cd libwired-$(WI_VERSION) && WI_MAINTAINER=0 $(MAKE) -e distclean scmclean"

	tar -czf libwired-$(WI_VERSION).tar.gz libwired-$(WI_VERSION)
	rm -rf libwired-$(WI_VERSION)

clean:
	rm -f $(objdir)/libwired/*.o
	rm -f $(objdir)/libwired/*.d
	rm -f $(headerdir)/*.h
	rm -f $(rundir)/lib/libwired.a
	rm -f $(rundir)/test
	rm -rf autom4te.cache

distclean: clean
	rm -rf $(objdir)/libwired
	rm -f Makefile config.h config.log config.status config.cache
	rm -f libwired-$(WI_VERSION).tar.gz

scmclean:
	find . -name .DS_Store -print0 | xargs -0 rm -f
	find . -name CVS -print0 | xargs -0 rm -rf
	find . -name .svn -print0 | xargs -0 rm -rf

ifeq ($(WI_MAINTAINER), 1)
-include $(LIBWIREDOBJECTS:.o=.d)
-include $(TESTOBJECTS:.o=.d)
endif
