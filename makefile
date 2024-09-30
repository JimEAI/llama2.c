SHELL := /usr/bin/env bash

ACTIVATE := source venv/bin/activate
PYTHON := $(ACTIVATE) && python3

V ?= 1000

setup:
	if [ ! -d venv ]; then python3 -m venv venv; fi
	$(ACTIVATE) && python3 -m pip install -r requirements.txt

vocab:
	$(PYTHON) tinystories.py download
	$(PYTHON) tinystories.py train_vocab --vocab_size=$V
	$(PYTHON) tinystories.py pretokenize --vocab_size=$V

train_tinyllama1:
	$(PYTHON) train.py \
		--eval_interval=1000 --log_interval=100 --init_from=scratch --eval_only=False \
		--batch_size=64 --max_seq_len=1024 --vocab_source=custom --vocab_size=1000 \
		--dim=192 --n_layers=2 --n_heads=6 --n_kv_heads=6 --multiple_of=32