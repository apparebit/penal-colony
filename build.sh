#!/bin/zsh

scriptname=$(basename $0)

# Handle --no-color early to simplify setup.
if [[ "$1" == "--no-color" ]]; then
    shift
    nocolor="nocolor"
fi

if [[ "$nocolor" != "nocolor" ]] && [ -t 2 ]; then
    BOLD="\e[1m"
    RED="\e[1;31m"
    ORANGE="\e[1;38;5;208m"
    GREEN="\e[1;32m"
    BLUE="\e[1;34m"
    RESET="\e[0m"
else
    BOLD=""
    RED=""
    ORANGE=""
    GREEN=""
    BLUE=""
    RESET=""
fi

# --------------------------------------------------------------------------------------

show_help() {
    {
        printf "${BOLD}${scriptname} [--no-color] [<target>]${RESET}"
        printf " with target one of these:\n"
        printf "    ${BOLD}venv${RESET}       install & activate Python virtual env\n"
        printf "    ${BOLD}build${RESET}      recreate the PDF document (default)\n"
        printf "    ${BOLD}lua${RESET}        recreate PDF document with LuaLaTeX\n"
        printf "    ${BOLD}clean${RESET}      delete auxiliary files\n"
        printf "    ${BOLD}arxiv${RESET}      prepare submission to ArXiv\n"
        printf "    ${BOLD}acm${RESET}        prepare submission to ACM\n"
        printf "    ${BOLD}-h, help${RESET}   print this message\n"
        printf "\n"
        printf "Note that ${BOLD}venv${RESET} installs a new virtual environment only\n"
        printf "if \"$(pwd)/.venv\" doesn't exist.\n"
    } >&2
}

show_info() {
    printf "${BLUE}INFO: $1${RESET}\n" >&2
}

show_success() {
    printf "${GREEN}SUCCESS: $1${RESET}\n" >&2
}

show_warning() {
    printf "${ORANGE}WARNING: $1${RESET}\n" >&2
}

show_error() {
    printf "${RED}ERROR: $1${RESET}\n" >&2
}

# --------------------------------------------------------------------------------------

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

# --------------------------------------------------------------------------------------

export TEXINPUTS=.:emo-graphics/:images/:
local LATEX_ENGINE=pdflatex

check_bibtex() {
    # Surface actionable information from BibTeX's output
    local warnings=$(
        grep -e '^Warning--' main.blg |
        grep -ve 'no number and no volume' |
        grep -ve 'page numbers missing' |
        grep -ve 'can'"'"'t use both author and editor fields')

    if [[ -n $warnings ]]; then
        show_error "Please fix the following BibTeX warnings:\n$warnings"
        exit 1
    fi
}

check_latex() {
    # Surface actionable information from LaTeX's output
    local warnings=$(
        grep -e '^LaTeX Warning: Reference `' main.log)

    if [[ -n $warnings ]]; then
        show_error "Please fix the following LaTeX warnings:\n$warnings"
        exit 1
    fi
}

do_build() {
    $LATEX_ENGINE main

    bibtex main
    check_bibtex

    $LATEX_ENGINE main
    while ( grep -q '^LaTeX Warning: Label(s) may have changed' *.log ); do
        $LATEX_ENGINE main
    done

    check_latex
}

# --------------------------------------------------------------------------------------

do_clean() {
    rm -f source/comment.cut
    rm -f source/missfont.log
    for suffix in aux bbl blg fdb_latexmk fls log out pdf; do
        rm -f "source/main.$suffix"
    done
    rm -f .DS_store source/.DS_store supplements/.DS_store
    rm -rf arxiv
    rm -f acm.zip arxiv.zip
}

# --------------------------------------------------------------------------------------

prep_arxiv() {
    # Make sure that the paper builds and the working directory exists.
    show_info "Build article"
    ( cd source && do_build $@ )
    [ ! -d arxiv ] && mkdir arxiv

    # Combine all LaTeX sources into one and inject pdflatex marker.
    show_info "Stage files"
    ( cd source && latexpand main.tex -o ../arxiv/article.tex )
    sed -i '' '2i\
\\pdfoutput=1' arxiv/article.tex

    # Include the emo package, the bibliography, and all image as well as emoji.
    cp source/emo.sty arxiv
    cp source/emo.def arxiv
    cp source/main.bbl arxiv/article.bbl
    cp source/images/*.{jpg,png} arxiv
    cp source/emo-graphics/*.pdf arxiv

    # Package it all up
    show_info "Create archive"
    zip -r arxiv.zip arxiv/*
}

# --------------------------------------------------------------------------------------

prep_acm() {
    #( cd source && do_build $@ )
    #mv source/main.pdf pdf/main.pdf
    #do_clean
    #zip -r acm.zip pdf source supplements build.sh
}

# --------------------------------------------------------------------------------------

target=${1:-build}
shift

case $target in
    venv      )  do_venv    $@ ;;
    build     )  ( cd source && do_build $@ ) || exit 1 ;;
    lua       )  LATEX_ENGINE=lualatex
                 ( cd source && do_build $@ ) || exit 1 ;;
    clean     )  do_clean   $@ ;;
    arxiv     )  prep_arxiv $@ ;;
    acm       )  prep_acm   $@ ;;
    -h | help )  show_help >&2 ;;
    *)
        show_error "\"$target\" is not a valid build target!"
        show_help
        exit 1
        ;;
esac

show_success "Happy, happy, joy, joy!"
