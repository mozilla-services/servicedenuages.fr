PELICANOPTS=

BASEDIR=$(CURDIR)
INPUTDIR=$(BASEDIR)/content
OUTPUTDIR=$(BASEDIR)/output
CONFFILE=$(BASEDIR)/pelicanconf.py
PUBLISHCONF=$(BASEDIR)/publishconf.py

GITHUB_PAGES_BRANCH=gh-pages

VENV := $(shell echo $${VIRTUAL_ENV-$(shell pwd)/.venv})
VIRTUALENV = virtualenv
INSTALL_STAMP = $(VENV)/.install.stamp

PYTHON=$(VENV)/bin/python
PELICAN=$(VENV)/bin/pelican
PIP=$(VENV)/bin/pip

DEBUG ?= 0
ifeq ($(DEBUG), 1)
	PELICANOPTS += -D
endif

install: $(INSTALL_STAMP)
$(INSTALL_STAMP): $(PYTHON) requirements.txt
	$(VENV)/bin/pip install -r requirements.txt
	touch $(INSTALL_STAMP)

virtualenv: $(PYTHON)
$(PYTHON):
	$(VIRTUALENV) $(VENV)

html: install
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)
	cp self-hosting-a-hard-promess.html $(OUTPUTDIR)/en/

clean:
	[ ! -d $(OUTPUTDIR) ] || rm -rf $(OUTPUTDIR)
	rm -rf $(VENV)

serve: install
ifdef PORT
	cd $(OUTPUTDIR) && $(PYTHON) -m pelican.server $(PORT)
else
	cd $(OUTPUTDIR) && $(PYTHON) -m pelican.server 8080
endif

regenerate:
	cd $(OUTPUTDIR) && $(PYTHON) -m pelican.server &
	$(PELICAN) -r $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)
	cp self-hosting-a-hard-promess.html $(OUTPUTDIR)/en/

publish: install
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(PUBLISHCONF) $(PELICANOPTS)
	echo "www.servicedenuages.fr" > $(OUTPUTDIR)/CNAME
	cp self-hosting-a-hard-promess.html $(OUTPUTDIR)/en/

github: publish
	$(VENV)/bin/ghp-import -b $(GITHUB_PAGES_BRANCH) $(OUTPUTDIR)
	git push origin $(GITHUB_PAGES_BRANCH) --force

.PHONY: html clean serve devserver github publish
