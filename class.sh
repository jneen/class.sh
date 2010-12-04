#!/bin/bash
. util.sh
. ptr.sh
debug "loading object.sh"

Class() {
  local _class=$1; shift
  debug "Class load $_class"

  mode=$1; shift
  putd mode

  case $mode in
    new)
      # create an instance of $_class
      debug "$_class new"
      local var=$1; shift

      local $_self="$_class __inst__ $_self"
      :s $_self $($_class::construct "$@")

      :g $_self
    ;;

    __inst__)
      # This is an instance of $_class

      debug "$_class __inst__ $@"
      local _self=$1; shift

      # load up the instance variables
      while true; do
        case $1 in
          --*)
            local w="${1:2}"
          debug _${w%%=*}="${w#*=}"
            local _${w%%=*}="${w#*=}"; shift
          ;;

          *)
            unset w
            break
          ;;
        esac
      done

      local _method=$1; shift

      # run the method, piping in stdin if it's not the terminal
      # TODO: there's gotta be a better way than this.
      if [ -t 0 ]; then
        echo
      else
        cat -
      fi | $_class::$_method $@
    ;;

    *)
      # running a class method
      if defined? $_class.$mode; then
        if [ -t 0 ]; then
          echo
        else
          cat -
        fi | $_class.$mode $@
      else
        raise "undefined method $mode for $_class."
      fi
    ;;
  esac
}

Class::repr() {
debug "Class::repr"
putd $_self
  :g $_self
debug here
debug $(:g $_self)
}

ivar_set() {
  local var=$1; shift
  local val="$@"

  :s $_self $(@d $var)
  echo $(:g $_self) --$var=$val
}
alias @s='ivar_set'

ivar_delete() {
  local var=$1; shift
  :g $_self | sed "s/--$var=\S\+//g"
}
alias @d='ivar_delete'

Class::type() {
  echo $1
}
