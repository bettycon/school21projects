export PYGAME_HIDE_SUPPORT_PROMPT=hide

.PHONY: uninstall_all_dependencies

run:
	rm -f log/*
	python3 src/main.py

install: hooks-install
	pip install -e . -U

install_dev: hooks-install
	pip install -e .[dev,test] -U

uninstall_all_dependencies:
	pip freeze | grep -v '^-e' | xargs pip uninstall -y
	pip cache purge

test:
	pytest tests/

lint:
	ruff check .
	ruff format . --check

format:
	ruff check . --fix
	ruff format .

clean:
	rm -rf __pycache__ build/ log/*
	find . -type d -name "__pycache__" -exec rm -rf {} +
	@echo "🧹"

pre-commit: format

hooks-install:
	echo "#!/bin/sh\nmake pre-commit" > .git/hooks/pre-commit
	chmod +x .git/hooks/pre-commit