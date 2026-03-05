#!/bin/bash

set -euo pipefail

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"
rbenv local 3.2.4
bundle install
if [ ! -d node_modules ]; then
  npm install
fi
npm run build:css
npm run watch:css &
TAILWIND_PID=$!
trap 'kill $TAILWIND_PID' EXIT
bundle exec jekyll serve --livereload --host 127.0.0.1 --port 4000
