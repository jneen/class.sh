. util.sh

debug "loading alloc.sh"

ptr() {
  mode=$1;shift

  case $mode in
    hash)
      echo $$_$(date +'%s_%N')_$RANDOM
    ;;

    set)
      local var=$1;shift
      eval "$var=\"$@\""
    ;;

    copy)
      local var=$1;shift
      local ref=$1;shift

      eval "$var=\$$ref"
    ;;

    get)
      eval "echo \$$1"
    ;;

    alloc)
      echo ALLOC_$(ptr hash)
    ;;
  esac
}

alias :s='ptr set'
alias :g='ptr get'
alias :a='ptr alloc'
