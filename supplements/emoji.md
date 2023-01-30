## Color Emoji and pdflatex

Getting color emoji to work with ancient `pdflatex` took some effort. This
document summarizes the steps involved. In particular, I start by summarizing my
workflow for creating the necessary graphics files and then show the LaTeX macro
for using them.

 1. __Acquire Emoji Graphics__: My preferred because least bad source for color
    emoji is [Google's Noto emoji
    font](https://github.com/googlefonts/noto-emoji). Since the SVG files are
    named after the sequence of hexadecimal Unicode code points, we need to map
    emoji of interest to their code points by replacing the bullseye with
    another emoji and evaluating the expression:

    ```js
    [...'🎯'].map(el => el.codePointAt(0).toString(16))
    ```

    For example, the code sequence for 👨‍🔬, the male scientist emoji, is
    `["1f468", "200d", "1f52c"]` and, sure enough, the corresponding file
    [emoji_u1f468_1f3fb_200d_1f52c.svg](https://raw.githubusercontent.com/googlefonts/noto-emoji/main/svg/emoji_u1f468_1f3fb_200d_1f52c.svg)
    does contain the corresponding line art.

    Once found and downloaded, I suggest renaming the SVG file based on its
    [Unicode name](https://unicode.org/emoji/charts/emoji-list.html).

 2. __Convert Noto's SVG to PDF__: `pdflatex` can't handle SVG, so we need to
    convert SVG emoji into PDF emoji. Several people on Stack Overflow suggest
    `rsvg-convert`, which is part of
    [librsvg](https://gitlab.gnome.org/GNOME/librsvg). It works:

    ```bash
    rsvg-convert -f PDF -o island.pdf island.svg
    ```

 3. __Fix the Resulting PDF__: Alas, the resulting PDF file contains a so-called
    “page group object.” But `pdflatex` doesn't really handle that object
    correctly and starts complaining. Worse, the
    [solutions](https://tex.stackexchange.com/questions/183149/cant-silence-a-pdftex-pdf-inclusion-multiple-pdfs-with-page-group-error)
    already
    [suggested](https://tex.stackexchange.com/questions/76273/multiple-pdfs-with-page-group-included-in-a-single-page-warning)
    on Stack Overflow don't work, including because they remove *all* `/Group`
    objects instead of just the one belonging to the `/Page`. Thankfully, I had
    just read a rather inspired blog post about [the PDF
    format](https://web.archive.org/web/20140502013429/http://jimpravetz.com/blog/2012/12/in-defense-of-cos/)
    and figured that I could do better. First, I used
    [QPDF](https://github.com/qpdf/qpdf) to inspect a few PDF files:

    ```bash
    qpdf input.pdf --qdf -
    ```

    Then I wrote the fairly simple [fix-page-groups.py](fix-page-groups.py) to
    delete those pesky `/Page` `/Group` objects. It leverages QPDF for parsing
    and generating PDF.

 4. __Integrate with LaTeX__: I collect the new and improved PDF files in the
    emoji subdirectory of the paper's source files and tell LaTeX about them:

    ```latex
    \usepackage{graphicx}
    \graphicspath{ {./emoji/}{./images/} }
    ```

    Then I write the actual `\emoji` command. It's pretty darn simple — in part
    because it doesn't handle conversion to HTML (yet). Also, the length for
    `\raisebox` may need some tweaking.

    ```latex
    \newcommand\emoji[1]{\raisebox{-0.2em}{\includegraphics[height=1em]{{#1}}}}
    ```

    So, when I need the penal colony emoji, I just write `\emoji{island}` and
    LaTeX produces a beautiful 🏝️.

    Yay! 🎉
