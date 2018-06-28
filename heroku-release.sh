#!/bin/bash
set -ex
printf '\e[32mmigrating...\e[0m\n'
bundle exec rake db:migrate