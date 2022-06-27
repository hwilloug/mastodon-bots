#!/bin/bash

# https://stackoverflow.com/questions/19331497/set-environment-variables-from-file-of-key-value-pairs
export $(grep -v '^#' .env | xargs -d '\r\n')

poetry install
poetry run python main.py

unset $(grep -v '^#' .env | xargs -d '\r\n')