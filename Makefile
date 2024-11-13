current-dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
docker-compose := docker compose -f $(current-dir)docker-compose.yml
make := /usr/bin/make -f $(current-dir)Makefile
source-env-file := $(current-dir).env-dist
target-env-file := $(current-dir).env

# Be sure that default configuration is loaded the first time.
include $(source-env-file)
# If already present, load customized local configuration.
-include $(target-env-file)

include $(current-dir)general-rules.mk

# This target must be run before starting the WIMS service.
.PHONY: warmup
warmup:
	# [WARM UP] Nothing to do for local and testing WIMS instances.
