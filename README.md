# Letters from the Stochastic Penal Colony 🏝

Source code and supplements for the paper “Letters from the Stochastic Penal
Colony 🏝” by Robert Grimm.

  * A [__custom build script__](build.sh) in the repository root takes care of
    repetitive tasks. The one optional argument is the name of the task to
    execute.
  * By default, i.e., when invoked without argument, the build script runs
    `pdflatex` and `bibtex` to recreate the PDF document from the LaTeX files in
    the [source](source) directory.
  * To work with the ACM's new (but arguably not improved) publishing flow, the
    paper uses only approved LaTeX packages and compiles with `pdflatex`.
  * Unfortunately, that leaves only one subpar option for color emoji, namely
    simulating them by including graphics files. I wrote [my own LaTeX
    package](https://github.com/apparebit/emo) to take care of that and then
    some. It's included inline with the paper sources.
  * Transparency data and Jupyter notebooks with the code for analyzing the data
    are inside the [supplements](supplements) directory.
  * The build script assumes that the virtual environment with Python packages
    necessary for running the notebooks is contained in the `.venv` directory.
    When invoked with the `venv` argument, it checks whether that directory
    exists, creating the virtual environment and installing packages otherwise,
    and then activates the virtual environment.


## Abstract

This paper serves as pointed critique of algorithmic practice outside the
criminal injustice system. Far too many interventions including social media's
content moderation are excessively punitive, often resulting in the figurative
death of users through permanent account suspension. First, based on my own
experiences and grounded in procedural justice, this paper starts by exploring
the many ways policy and automated enforcement turn punitive on the example of
OpenAI's DALL•E 2. Second, it illustrates how even best-practices policy turns
punitive performance on the example of pre-Musk Twitter. Third, a comprehensive
survey of non-Chinese social media demonstrates the pervasiveness of excessively
punitive content moderation. It also tests the limits of their accountability,
notably by projecting the likely impact of the European Union's Digital Services
Act and by correlating data released by Facebook, Google, and the National
Center for Missing and Exploited Children. Fourth, to illustrate the limits of
algorithmic content moderation, it presents a successful strategy for subverting
DALL•E's aggressive automated censor, which inadvertently also unleashed
grotesquely racist imagery. This paper concludes by pointing towards harm
reduction as a strategy for, possibly maybe, making life in this digital penal
colony at least somewhat bearable — because, I fear, we are stuck in it.


## (C) Copyright 2023 by Robert Grimm

The shell script and Jupyter notebooks included in this repository are open
source under the Apache 2.0 license. I have not yet settled on a license for the
paper itself. For now, all rights are reserved.
