SHELL := /usr/bin/env bash

ACTIVATE := source venv/bin/activate
PYTHON := $(ACTIVATE) && python3

setup:
	if [ ! -d venv ]; then python3 -m venv venv; fi
	$(ACTIVATE) && python3 -m pip install -r requirements.txt

data/tok1000.model:
	$(PYTHON) tinystories.py download
	$(PYTHON) tinystories.py train_vocab --vocab_size=1000
	$(PYTHON) tinystories.py pretokenize --vocab_size=1000

data/tok4000.model:
	$(PYTHON) tinystories.py download
	$(PYTHON) tinystories.py train_vocab --vocab_size=4000
	$(PYTHON) tinystories.py pretokenize --vocab_size=4000

train_tinyllama1: data/tok1000.model
	$(PYTHON) train.py \
		--out_dir=$@ --max_iters=10000 --log_interval=100 --init_from=scratch --eval_only=False \
		--batch_size=128 --max_seq_len=1024 --vocab_source=custom --vocab_size=1000 \
		--dim=192 --n_layers=2 --n_heads=6 --n_kv_heads=6 --multiple_of=32

train_tinyllama2: data/tok1000.model
	$(PYTHON) train.py \
		--out_dir=$@ --max_iters=20000 --log_interval=100 --init_from=scratch --eval_only=False \
		--batch_size=32 --max_seq_len=1024 --vocab_source=custom --vocab_size=1000 \
		--dim=512 --n_layers=4 --n_heads=8 --n_kv_heads=8 --multiple_of=32

train_tinyllama2: data/tok4000.model
	$(PYTHON) train.py \
		--out_dir=$@ --max_iters=40000 --log_interval=100 --init_from=scratch --eval_only=False \
		--batch_size=16 --max_seq_len=1024 --vocab_source=custom --vocab_size=4000 \
		--dim=1024 --n_layers=8 --n_heads=8 --n_kv_heads=4 --multiple_of=32