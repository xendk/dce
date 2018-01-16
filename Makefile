
VERSION := $(shell ruby -r rubygems -e 'spec = Gem::Specification::load("dce.gemspec"); puts spec.version')

test:
	cucumber -f progress

dce-$(VERSION).gem: dce.gemspec bin/dce
	gem build dce.gemspec

build: dce-$(VERSION).gem


release: dce-$(VERSION).gem
	gem push dce-$(VERSION).gem

clean:
	rm dce-*.gem
