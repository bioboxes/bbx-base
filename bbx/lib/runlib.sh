mountcheck() {
  grep -v '^#' "$BBX_MNTCONF" |
  while read ifc; do
    if ! mountpoint -q "$BBX_MNTDIR/$ifc"; then
      echo "Abort, interface '$BBX_MNTDIR/$ifc' not bound."
      return 1
    fi
  done
}

isoption() {
  [ "$(echo "$1" | cut -c -2)" = '--' ]
}

tasklist() {
  if test -d "$BBX_TASKDIR"; then
    (cd "$BBX_TASKDIR" && find -L -maxdepth 1 -type f -printf "%f\n" | sort -u)
  fi
}

cpucount() {
  grep -m 1 '^Cpus_allowed:' /proc/self/status |
  cut -f 2 |
  tr -d ',' |
  tr '[:lower:]' '[:upper:]' |
  xargs echo "obase=2; ibase=16;" |
  bc |
  tr -d -c '1' |
  wc -c
}
