action=$1
pattern=$2
shift 2

bork_symlink_name_for_file () { echo $(basename $1); }

case "$action" in
  status)
    missing=0
    accum=0
    for f in $pattern; do
      (( accum++ ))
      fname=$(bork_symlink_name_for_file $f)
      if [ -e $fname ]; then
        [ ! -L $fname ] && return 20
        [ "$(readlink $fname)" != $f ] && return 20
      else
        (( missing++ ))
      fi
    done
    [ "$missing" -eq $accum ] && return 10
    [ "$missing" -gt 0 ] && return 11
    return 0
    ;;
  install|upgrade)
    for f in $pattern; do
      fname=$(bork_symlink_name_for_file $f)
      [ ! -L $fname ] && bake "ln -s $f $fname"
    done
    return 0
    ;;
  *) return 1;;
esac
