#!/bin/bash

grep name game.yml | cut -d ':' -f2 | sort
