mountcheck() {
  grep -v '^#' "$BBX_MNTCONF" |
  while read ifc; do
    if ! mountpoint -q "$BBX_MNTDIR/$ifc"; then
      echo "Abort, interface '$DCKR_MNT/$ifc' not bound." 1>&2
      return 1
    fi
  done
}

isoption() {
  [ "$(echo "$1" | cut -c -2)" = '--' ]
}
