#!/bin/bash

scriptname=$(basename $0)
BOLD="\e[1m"
RED="\e[1;31m"
GREEN="\e[1;32m"
RESET="\e[0m"

do_help() {
    printf "${BOLD}${scriptname} <target>${RESET}  # with <target> being:\n"
    printf "    ${BOLD}build${RESET}      recreates the document (default)\n"
    printf "    ${BOLD}-h, help${RESET}   print this message\n"
}

do_build() {
    pdflatex -output-directory=../pdf main
    bibtex main
    pdflatex -output-directory=../pdf main
    while ( grep -q '^LaTeX Warning: Label(s) may have changed' ../pdf/*.log ); do
        pdflatex -output-directory=../pdf main
    done
}

target=${1:-build}
shift

case $target in
    build    )  ( cd source && do_build $@ ) ;;
    -h | help)  do_help     ;;
    *)
        printf "${RED}ERROR: \"$target\" is not a valid build target!${RESET}\n" >&2
        do_help
        exit 1
        ;;
esac

printf "${GREEN}Happy, happy joy, joy!${RESET}\n"
