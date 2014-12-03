# Shortcut for: find <dir> -iname *<search>*
flike() {
  local search path
  if [ -z "$2" ]; then
    search="$1"
    path=.
  else
    search="$2"
    path="$1"
  fi
  find "${path}" -iname "*${search}*"
}

# Shortcut for: find -iname *<search>* -print0 | xargs -0 grep <grepfor>
ffg() {
  local search grepfor
  if [ -z "$2" ]; then
    grepfor="$1"
    search=
  else
    grepfor="$2"
    search="$1"
  fi

  gfind -type f -iname "*${search}*" -print0|xargs -0 grep "${grepfor}"
}

listening_ports() {
  sudo lsof -P -i -n | grep LISTEN
}

ip() {
   ifconfig |grep "inet "  | cut -d\  -f2
}


