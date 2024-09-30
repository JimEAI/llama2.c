SHELL := /usr/bin/env bash

ACTIVATE := source venv/bin/activate
PYTHON := $(ACTIVATE) && python3

setup:
	if [ ! -d venv ]; then python3 -m venv venv; fi
	$(ACTIVATE) && python3 -m pip install -r requirements.txt
