bbx_mountcheck() {
  bbx_mountcheck_retval=0
  grep -v '^#' "$BBX_MNTCONF" |
  while read ifc; do
    if [ -n "$ifc" ] && ! mountpoint -q "$BBX_MNTDIR/$ifc"; then
      echo "Warning: unbound interface '$BBX_MNTDIR/$ifc'" 1>&2
      bbx_mountcheck_retval=1
    fi
  done
  return "$bbx_mountcheck_retval"
}

isoption() {
  [ "$(echo "$1" | cut -c -2)" = '--' ]
}

bbx_tasklist() {
  if [ -d "$BBX_TASKDIR" ]; then
    (cd "$BBX_TASKDIR" && find -L -maxdepth 1 -type f -printf "%f\n" | sort -u)
  fi
}

cpucount() {  # TODO: check if it works everywhere, there seems to be a problem on some systems
  grep -m 1 '^Cpus_allowed:' /proc/self/status |
  cut -f 2 |
  tr -d ',' |
  tr '[:lower:]' '[:upper:]' |
  xargs echo "obase=2; ibase=16;" |
  bc |
  tr -d -c '1' |
  wc -c
}


bbx_parse_yaml() {
  if [ -r "$BBX_MNTDIR/input/biobox.yaml" ]; then
    eval $(yaml-parser "$BBX_MNTDIR/input/biobox.yaml" 'export bbx')
  else
    echo 'Warning: biobox.yaml not accessible' 1>&2
    return 1
  fi
}

