#!/usr/bin/env bash
# install script for cleanfiles oh-my-zsh plugin
set -uo pipefail


ZSHRC_FILE=~/.zshrc
ZSH=${ZSH:-~/.oh-my-zsh}
REPO=${REPO:-nc9/zsh-cleanfiles}
REMOTE=${REMOTE:-https://github.com/${REPO}.git}
BRANCH=${BRANCH:-master}

command_exists() {
	command -v "$@" >/dev/null 2>&1
}

fmt_underline() {
  printf '\033[4m%s\033[24m\n' "$*"
}

fmt_code() {
  # shellcheck disable=SC2016 # backtic in single-quote
  printf '`\033[38;5;247m%s%s`\n' "$*" "$RESET"
}

_logerror() {
  printf '%sError: %s%s\n' "$BOLD$RED" "$*" "$RESET" >&2
}

_log() {
    printf "%sInfo: %s%s\n" "$BOLD$GREEN" "$*" "$RESET" >&1
}


_continue_or_exit() {
    read -p "Do you want to continue? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        _logerror "Exiting"
        exit -1
    fi
}

setup_color() {
	# Only use colors if connected to a terminal
	if [ -t 1 ]; then
		RED=$(printf '\033[31m')
		GREEN=$(printf '\033[32m')
		YELLOW=$(printf '\033[33m')
		BLUE=$(printf '\033[34m')
		BOLD=$(printf '\033[1m')
		RESET=$(printf '\033[m')
	else
		RED=""
		GREEN=""
		YELLOW=""
		BLUE=""
		BOLD=""
		RESET=""
	fi
}


install_plugin() {
    umask g-w,o-w
}

check_deps() {
    if [ ! -w $ZSHRC_FILE ]; then
        _logerror "Could not read file $ZSHRC_FILE"
        exit -1
    fi

}

backup_config() {
    BACKUP_STAMP=`date '+%Y%m%d%S'`
    BACKUP_FILENAME=$ZSHRC_FILE-backup.$BACKUP_STAMP

    cp -np $ZSHRC_FILE $BACKUP_FILENAME

    BACKUP_RETURN_CODE=$?

    if [ -z $BACKUP_RETURN_CODE ] || [ $BACKUP_RETURN_CODE -ne 0 ]; then
        _logerror "Backup copy failed. Could not write or overwrite $BACKUP_FILENAME"
        _continue_or_exit
    else
        _log "Backed up zsh init to $BACKUP_FILENAME"
    fi
}

main() {
    setup_color

    check_deps

    if grep -Fxq "# cleanfiles plugin" $ZSHRC_FILE; then
        _logerror "Already installed."
        exit -1
    fi

    backup_config


    echo >> $ZSHRC_FILE
    echo "# cleanfiles plugin" >> $ZSHRC_FILE
    echo "plugins+=('cleanfiles')" >> $ZSHRC_FILE
    echo  >> $ZSHRC_FILE

    _log "Installed."
}

main "$@"