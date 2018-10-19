#!/bin/env bash

multiple_cmd() {
  if grep -aiHsrE -m 1 '^#!(/usr/|/)[sb]+in(/env[[:space:]]+|/)(bash|sh|py[thon]+|js|perl|php)$' "${@}"; then
    sudo chmod +x "${@}"
  else
    sudo chmod -x "${@}"
  fi
}

export -f multiple_cmd

find . -type f -exec bash -c 'multiple_cmd "$0"' {} \;
