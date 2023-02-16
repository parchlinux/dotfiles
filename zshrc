#!/usr/bin/env zsh

ZSH_PATH=$HOME/.zsh

#########################
######### PATH ##########
#########################

if [ -d "$HOME/.bin" ] ;
  then PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/Applications" ] ;
  then PATH="$HOME/Applications:$PATH"
fi

if [ -d "$HOME/.cargo/bin" ]
  then PATH="$HOME/.cargo/bin:$PATH"
fi


# Comment this line out to enable default emacs-like bindings
bindkey -v

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# functions
[[ -f "$ZSH_PATH/functions.zsh" ]] && source $ZSH_PATH/functions.zsh


# extra files in ~/.zsh/configs/pre , ~/.zsh/configs , and ~/.zsh/configs/post
# these are loaded first, second, and third, respectively.
_load_settings() {
  _dir="$1"
  if [ -d "$_dir" ]; then
    if [ -d "$_dir/pre" ]; then
      for config in "$_dir"/pre/**/*~*.zwc(N-.); do
        . $config
      done
    fi

    for config in "$_dir"/**/*(N-.); do
      case "$config" in
        "$_dir"/(pre|post)/*|*.zwc)
          :
          ;;
        *)
          . $config
          ;;
      esac
    done

    if [ -d "$_dir/post" ]; then
      for config in "$_dir"/post/**/*~*.zwc(N-.); do
        . $config
      done
    fi
  fi
}
_load_settings "$ZSH_PATH/configs"

# Local config
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# aliases
[[ -f "$ZSH_PATH/aliases.zsh" ]] && source "$ZSH_PATH/aliases.zsh"
