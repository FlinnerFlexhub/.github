#!/usr/bin/env bash
# Runs the script inside .github/workflows/conventions.yml against gitflow/title cases. Usage: bash tests/conventions.sh
cd "$(dirname "$0")/.."
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
printf '#!/bin/bash\n' > "$tmp/gh"; chmod +x "$tmp/gh"   # stub: never call GitHub
awk '/run: \|/{f=1;next} f{sub(/^          /,""); print}' .github/workflows/conventions.yml > "$tmp/conv.sh"
failures=0
t() { # expected event repo title base head gitflow
  if PATH="$tmp:$PATH" EVENT=$2 REPO=$3 NUMBER=1 TITLE="$4" BASE=$5 HEAD=$6 GITFLOW=$7 bash "$tmp/conv.sh" >/dev/null 2>&1
  then r=pass; else r=fail; fi
  [ "$r" = "$1" ] || { echo "expected $1: '$4' $6 -> $5"; failures=$((failures+1)); }
}
B=FlinnerFlexhub/Flinner-Back
t pass pull_request $B "[back] feat: add x"                      development        feature/42 true
t pass pull_request $B "feat: add x"                             development        feature/42 true
t pass pull_request $B "[back] chore(deps): Bump x from 1 to 2"  development        dependabot/nuget/x-1.2 true
t pass pull_request $B "[back] feat(notifications)!: drop x"     development        feature/42 true
t fail pull_request $B "Dev/cleanup"                             development        dev/cleanup true
t fail pull_request $B "[back] feat: x"                          development        dev/cleanup true
t fail pull_request $B "[back] feat: x"                          main               feature/42 true
t pass pull_request $B "[back] release: 1.2.0"                   main               development/1.2.0 true
t fail pull_request $B "[back] release: 1.2"                     main               development/1.2 true
t pass pull_request $B "[back] fix: x"                           development/1.2.0  hotfix/7 true
t fail pull_request $B "[back] fix: x"                           development/1.2.0  feature/7 true
t pass pull_request $B "[back] release: merge back 1.2.0"        development        development/1.2.0 true
t pass pull_request FlinnerFlexhub/Flinner-Claude "docs: x"      main               feature/3 false
t fail pull_request FlinnerFlexhub/Flinner-Front "[front] Feat: x" development      feature/3 true
t pass issues       FlinnerFlexhub/Flinner-Front "anything"      ""                 "" true
[ $failures -eq 0 ] && echo "all cases pass" || { echo "$failures case(s) failed"; exit 1; }
