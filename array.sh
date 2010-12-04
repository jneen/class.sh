. object.sh
debug "loading array.sh"

Array() {
  if [ -t 0 ]; then
    echo
  else  
    cat -
  fi | Class Array $@
}

Array::construct() {
  debug "Array::construct $@"
  :s $_self $(@s length 0)
  :g $_self
}

Array::push() {
putd _length
  local next=$(expr $_length + 1)
  :s $_self $(@s $_length $1)
  :s $_self $(@s length $(expr $_length + 1))
  :g $_self
}

Array::pop() {
  (( $_count == 0 )) && return

  local new_len=$(expr $_length - 1)
  :s $_self $(@s length $new_len)
  :g _$new_len
}

Array::load() {
  while read line; do
    :s $_self $(Array::push $line)
  done
}

Array::pipe() {
  for i in {1..$_length}; do
    ptr get _$i
  done
}
