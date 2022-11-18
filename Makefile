# var
MODULE = $(notdir $(CURDIR))
module = $(shell echo $(MODULE) | tr A-Z a-z)
OS     = $(shell uname -o|tr / _)
NOW    = $(shell date +%d%m%y)
REL    = $(shell git rev-parse --short=4 HEAD)
BRANCH = $(shell git rev-parse --abbrev-ref HEAD)

# tool
CURL   = curl -L -o
CF     = clang-format

.PHONY: all
all:

.PHONY: format
format:

.PHONY: doc
doc:
	rsync -rv ~/mdoc/$(MODULE)/* doc/$(MODULE)/ && git add doc

.PHONY: doxy
doxy: doc

install update: gz
	sudo apt update
	sudo apt install -yu `cat apt.txt`

gz:	share/keyrings/orel.gpg

share/keyrings/orel.gpg:
	$(CURL) $@ http://dl.astralinux.ru/astra/stable/2.12_x86-64/repository/dists/orel/Release.gpg

ARCH  ?= i386
INCL  += ssh,vim,mc,git,make,curl,rsync
EXCL  += nano,gcc
PROXY  = http_proxy=http://127.0.0.1:8000
ROOT   = tmp/root
APT   += linux-image-686 syslinux

# Astra CE
REPO  ?= http://dl.astralinux.ru/astra/stable/2.12_x86-64/repository/
DISTR ?= orel

# # Debian
# REPO =
# DISTR = stretch

deb: gz
	export $(PROXY)
	sudo $(DEBPROXY) debootstrap --verbose \
		--arch=$(ARCH) --variant=minbase --components=main \
		$(DISTR) $(ROOT) $(REPO)
# 	--components=main,contrib,non-free \
# 	--include=$(INCL) --exclude=$(EXCL) \
# 	$(ROOT) $(REPO)

# merge
MERGE  = Makefile README.md .clang-format .doxygen $(S)
MERGE += apt.txt
MERGE += .vscode bin doc lib inc src tmp
MERGE += share

dev:
	git push -v
	git checkout $@
	git pull -v
	git checkout shadow -- $(MERGE)
	$(MAKE) doc
#	$(MAKE) doxy ; git add -f docs

shadow:
	git push -v
	git checkout $@
	git pull -v

release:
	git tag $(NOW)-$(REL)
	git push -v --tags
	$(MAKE) shadow

ZIP = tmp/$(MODULE)_$(NOW)_$(REL)_$(BRANCH).zip
zip:
	git archive --format zip --output $(ZIP) HEAD
