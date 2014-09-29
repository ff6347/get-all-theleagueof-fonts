#!/bin/zsh

main(){
  if [ $# -eq 0 ]
    then
      echo "please provide one :org name"
    exit
  fi
  if hash jq 2>/dev/null; then
    echo "jq is installed"
  else
    echo "you need 'jq' for this script. Please install via"
    echo "'brew install jq'"
    exit
  fi
  curl --request GET https://api.github.com/orgs/$1/repos | jq '.[].clone_url' > tmp.txt
  IFS=$'\n'       # make newlines the only separator
  set -f          # disable globbing
  echo "\\n"  >> .gitignore
  for i in $(cat "tmp.txt"); do
    tmp=$(echo $i | tr -d '"')
    subtmp=$(echo $tmp | sed -e 's/https:\/\/g\ithub\.com\/theleagueof\///' -e 's/\.\g\it//')
    echo $subtmp"/" >> .gitignore
    # git clone $tmp
  done
  rm tmp.txt
}
main $1
