PELICANOPTS=

BASEDIR=$(CURDIR)
INPUTDIR=$(BASEDIR)/content
OUTPUTDIR=$(BASEDIR)/output
CONFFILE=$(BASEDIR)/pelicanconf.py
PUBLISHCONF=$(BASEDIR)/publishconf.py

GITHUB_PAGES_BRANCH=gh-pages

VENV := $(shell echo $${VIRTUAL_ENV-$(shell pwd)/.venv})
VIRTUALENV = virtualenv --python python2.7
INSTALL_STAMP = $(VENV)/.install.stamp

PYTHON=$(VENV)/bin/python
PELICAN=$(VENV)/bin/pelican
PIP=$(VENV)/bin/pip
PORT := $(shell echo $${PORT-8080})

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
	$(PELICAN) -lr -p $(PORT)

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
