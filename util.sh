#!/bin/bash

debug() {
  if [ -n "$DEBUG" ]; then
    stderr "debug: $@" 1>&2
  fi
}
debug "loading util.sh"

putd() {
  debug "$1=%(${!1})"
}

raise() {
  caller | stderr "ERROR: $@"
  # exit 1
}

stderr() {
  echo $@ 1>&2
  if [ ! -t 0 ]; then
    cat - | 1>&2
  fi
}


match?() {
  grepped="$(cat - | grep "$@")"
  test -n "$grepped"
}

numeric?() {
  if [ -n $1 ]; then
    echo $1
  else
    echo $(cat -)
  fi | match? -E '^[0-9]+$'
}

not() {
  if cat - | $@; then
    false
  else
    true
  fi
}

empty?() {
  test -z "$(cat -)"
}

defined?() {
  if [ -n $1 ]; then
    type $1
  else
    type $(cat -)
  fi &> /dev/null
}

termfix() {
  echo 'if [ -t 0 ]; then echo; else; cat -; fi'
}
