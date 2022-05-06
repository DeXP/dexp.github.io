export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
export PATH="$PATH:$GEM_HOME/bin"
bundle exec jekyll serve --incremental --config _config.yml,_config_dev.yml --force_polling