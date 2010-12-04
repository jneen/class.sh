putd() {
  debug "$1=%(${!1})"
}

debug() {
  if [ -n "$DEBUG" ]; then
    echo "debug: $@" 1>&2
  fi
}

raise() {
  caller | stderr "ERROR: $@"
  # exit 1
}

stderr() {
  echo $@ 1>&2
  cat - | 1>&2
}

debug "loading util.sh"

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

false() {
  test 1 -eq 0
}

true() {
  test 0 -eq 0
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
