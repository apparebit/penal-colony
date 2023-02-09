#!/bin/zsh

scriptname=$(basename $0)
BOLD="\e[1m"
RED="\e[1;31m"
GREEN="\e[1;32m"
BLUE="\e[1;34m"
RESET="\e[0m"

show_help() {
    printf "${BOLD}${scriptname} <target>${RESET}  # with <target> being one of:\n"
    printf "    ${BOLD}venv${RESET}       install & activate Python virtual env\n"
    printf "    ${BOLD}build${RESET}      recreate the PDF document (default)\n"
    printf "    ${BOLD}clean${RESET}      delete auxiliary files\n"
    printf "    ${BOLD}arxiv${RESET}      prepare submission to ArXiv\n"
    printf "    ${BOLD}acm${RESET}        prepare submission to ACM\n"
    printf "    ${BOLD}-h, help${RESET}   print this message\n"
    printf "\n"
    printf "Note that ${BOLD}venv${RESET} installs a new virtual environment only\n"
    printf "if \"$(pwd)/.venv\" doesn't exist.\n"
}

show_info() {
    printf "${BLUE}${scriptname}: $1${RESET}\n" >&2
}

show_error() {
    printf "${RED}ERROR: $1${RESET}\n" >&2
}

do_venv() {
    local installing=0

    if [[ -d "$VIRTUAL_ENV" ]]; then
        show_info "Already running inside Python virtual environment!"
        return
    elif [[ ! -d ./.venv ]]; then
        show_info "Creating virtual environment in '.venv'"
        installing=1
        python3 -m venv .venv
    fi

    # Since activate is not being sourced in an interactive shell, PS1 is not
    # defined and the resulting prompt a bit bare. Extracting PS1 from an
    # interactive shell (which only executes one command) helps avoid that.
    DEFAULT_PS1=$(/bin/zsh -i -c "echo \"[[[\$PS1]]]\"")

    show_info "Activating virtual environment in '.venv'"
    source ./.venv/bin/activate

    PS1="(.venv) ${DEFAULT_PS1:3:(-3)}"
    export PS1

    if [[ $installing == 1 ]]; then
        show_info "Installing required Python packages."
        pip install -r supplements/requirements.txt
    fi

    show_info "'.venv' is activated, use 'exit' to deactivate!"
    exec /bin/zsh -f -i
}

local LATEX_TOOL=pdflatex

do_build() {
    $LATEX_TOOL main
    bibtex main
    $LATEX_TOOL main
    while ( grep -q '^LaTeX Warning: Label(s) may have changed' *.log ); do
        $LATEX_TOOL main
    done
}

do_clean() {
    rm -f source/comment.cut
    for f in aux bbl blg log out pdf; do
        rm -f "source/main.$f"
    done
    rm -f .DS_store pdf/.DS_store source/.DS_store supplements/.DS_store
    rm -f acm.zip arxiv.zip
}

prep_arxiv() {
    ( cd source && do_build $@ )
    do_clean
    zip -r arxiv.zip source/*
}

prep_acm() {
    ( cd source && do_build $@ )
    mv source/main.pdf pdf/main.pdf
    do_clean
    zip -r acm.zip pdf source supplements build.sh
}

target=${1:-build}
shift

case $target in
    venv     )  do_venv    $@ ;;
    build    )  ( cd source && do_build $@ ) ;;
    lua      )  LATEX_TOOL=lualatex
                ( cd source && do_build $@ ) ;;
    clean    )  do_clean   $@ ;;
    arxiv    )  prep_arxiv $@ ;;
    acm      )  prep_acm   $@ ;;
    -h | help)  show_help  $@ ;;
    *)
        show_error "\"$target\" is not a valid build target!"
        printf "\n"
        show_help
        exit 1
        ;;
esac

printf "${GREEN}Happy, happy joy, joy!${RESET}\n"
