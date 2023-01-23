# Letters from the Stochastic Penal Colony 🏝

Latex sources for the paper by Robert Grimm


## Abstract

This paper serves as pointed critique that far too many algorithmic
interventions outside the criminal injustice system are excessively punitive,
often resulting in the figurative death of users through permanent account
suspension. First, based on my own experiences and grounded in procedural
justice, this paper starts by exploring the many ways policy and automated
enforcement turn punitive on the example of OpenAI’s DALL·E 2. Second, it
illustrates how even best-practices policy turns punitive performance on the
example of pre-Musk Twitter. Third, a comprehensive survey of non-Chinese social
media demonstrates the pervasiveness of excessively punitive content moderation.
It also tests the limits of their accountability, notably by projecting the
likely impact of the European Union’s Digital Services Act and by correlating
data released by Facebook, Google, and the National Center for Missing and
Exploited Children. Fourth, to counter any hope that doing better is a viable
strategy for addressing the basic inhumanity of these interventions, this paper
next illustrates the impossibility of ridding ourselves even of punitive
algorithmic snake oil on the example of the October 2020 bar exam in California.
Fifth, it illustrates the limits of algorithmic content moderation through a
successful strategy for subverting DALL·E 2’s aggressive automated censor, which
inadvertently also unleashed grotesquely racist imagery. This paper concludes by
pointing towards harm reduction as a strategy for, possibly maybe, making life
in the penal colony at least somewhat bearable — because, I fear, we are stuck
in just that penal colony.


## Using Emoji with the ACM’s acmart.cls

I tried for two days to make color emoji work with [the ACM’s article
format](https://github.com/borisveytsman/acmart) — to no avail. Neither
`xelatex` nor `lualatex` nor `luahbtex` could get Unicode glyphs to render with
that format — even though `luahbtex` did show them with plain article format.
So, I developed my own lightweight work-around based on vector graphics. How
hard could that be? Hah!

 1. I started with the SVG source files from [Google's Noto Emoji
    font](https://github.com/googlefonts/noto-emoji) and converted them to PDF
    with [rsvg-convert](https://gitlab.gnome.org/GNOME/librsvg)

 2. For some reason, the resulting PDF files include superfluous “page group
    objects” that trip up `pdflatex`. So I wrote [a short
    script](supplements/fix-page-groups.py) that relies on
    [QPDF](https://github.com/qpdf/qpdf) to remove these objects again.

    As so often, Stack Overflow provided
    [critical](https://tex.stackexchange.com/questions/183149/cant-silence-a-pdftex-pdf-inclusion-multiple-pdfs-with-page-group-error)
    [information](https://tex.stackexchange.com/questions/76273/multiple-pdfs-with-page-group-included-in-a-single-page-warning)
    for solving the problem. Also as so often, the solutions on Stack Overflow
    weren’t quite right. In particular, removing all such objects may result in
    invalid PDF files since they may appear at different nodes in the object
    graph as well.

 3. I wrote a short and sweet Latex macro that takes care of right-sizing the
    emoji for use within text:
    ```latex
    \newcommand\emoji[1]{\raisebox{-0.2ex}{\includegraphics[height=1em]{{#1}}}}
    ```
    Now I can just write
    ```latex
    A stochastic parrot \emoji{parrot} in a stochastic penal colony \emoji{island}!
    ```
    to generate

    > “A stochastic parrot 🦜 in a stochastic penal colony 🏝!”

    Yay! 🎉

I’m starting to miss Sheridan Printing, the ACM’s previous vendor for handling
publications...

---

(C) 2023 by Robert Grimm.
