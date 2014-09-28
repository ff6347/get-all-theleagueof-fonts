#!/bin/zsh

main(){
  json='{
    "results": [
        {
        "repos": "https://github.com/theleagueof/league-spartan"
        }]}'
  if [ $# -eq 0 ]
    then
      echo "please provide one json file with the following stricture"
      echo $json
    exit
  fi
  if hash jq 2>/dev/null; then
    echo "jq is installed"
  else
    echo "you need 'jq' for this script. Please install via"
    echo "'brew install jq'"
    exit
  fi
  cat $1 | jq '.results[].repos' > tmp.txt
  IFS=$'\n'       # make newlines the only separator
  set -f          # disable globbing
  for i in $(cat "tmp.txt"); do
    tmp=$(echo $i | tr -d '"')
    echo $tmp
    git clone $tmp
  done
  rm tmp.txt
}
main $1