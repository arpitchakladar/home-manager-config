set -euo pipefail

embed=0
if [[ "${GIT_LOG_GRAPH_EMBED:-}" == "1" || "${1:-}" == "--embed" ]]; then
  embed=1
fi

fmt=$(printf '\033[1;34mCommit:\033[0m \033[33m%%h\033[0m \033[91m%%d\033[0m%%n\x01%%H\x01%%n\033[1;34mParents:\033[0m \033[35m%%p\033[0m%%n\033[1;34mAuthor:\033[0m \033[32m%%an\033[0m <\033[96m%%ae\033[0m>%%n\033[1;34mDate:\033[0m \033[36m%%ad (%%ar)\033[0m%%n%%n%%B%%n\033[90m--------------------------------------------------------\033[0m')

# shellcheck disable=SC2016 # awk expressions must not be expanded by bash
awk_prog='
  index($0, "\x01") > 0 {
    line  = $0
    start = index(line, "\x01")
    rest  = substr(line, start + 1)
    stop  = index(rest, "\x01")
    hash   = substr(rest, 1, stop - 1)
    prefix = substr(line, 1, start - 1)

    gsub(/\033\[[0-9;]*[a-zA-Z]/, "", hash)
    gsub(/[^0-9a-fA-F]/, "", hash)

    if (length(hash) >= 7) {
      cmd = "git log -1 --format=\"%G?|%GK\" " hash " 2>/dev/null"
      cmd | getline sig
      close(cmd)
      split(sig, a, "|")
      st = a[1]; key = a[2]
    } else {
      st = ""; key = ""
    }

    if      (st == "G") label = "\033[32mgood\033[0m"
    else if (st == "B") label = "\033[31mbad\033[0m"
    else if (st == "U") label = "\033[33muntrusted\033[0m"
    else if (st == "X") label = "\033[33mexpired sig\033[0m"
    else if (st == "Y") label = "\033[33mexpired key\033[0m"
    else if (st == "R") label = "\033[31mrevoked\033[0m"
    else if (st == "E") label = "\033[90munverifiable\033[0m"
    else                label = "\033[90mnone\033[0m"
    keydisp = (key == "") ? "\033[90m-\033[0m" : "\033[35m" key "\033[0m"
    printf "%s\033[1;34mSignature:\033[0m %s %s\n", prefix, label, keydisp
    next
  }
  { print }
'

graph() {
  if [[ $embed -eq 1 ]]; then
    git-graph --model custom --color always --sparse --style round --no-pager --format="$fmt" | gawk "$awk_prog"
  else
    git-graph --model custom --color always --sparse --style round --format="$fmt" | gawk "$awk_prog"
  fi
}

if [[ $embed -eq 1 ]]; then
  graph
else
  less -R < <(graph)
fi
