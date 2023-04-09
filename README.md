# Letters from the Stochastic Penal Colony 🏝

[Paper](penal-colony-v1.pdf) (v1.0, PDF) by Robert Grimm, Independent
Investigator, Brooklyn, NY, USA.


## Abstract

This paper serves as pointed critique of algorithmic practice outside the
criminal injustice system. Far too many interventions including social media's
content moderation are excessively punitive, often resulting in the figurative
death of users through permanent account suspension. First, based on my own
experiences and grounded in procedural justice, this paper starts by exploring
the many ways policy and automated enforcement turn punitive on the example of
OpenAI's DALL•E 2. Second, it illustrates how even best-practices policy turns
punitive performance on the example of pre-Musk Twitter. Third, a comprehensive
survey of non-Chinese social media demonstrates the pervasiveness of excessively
punitive content moderation. It also tests the limits of their accountability,
notably by projecting the likely impact of the European Union's Digital Services
Act and by correlating data released by Facebook, Google, and the National
Center for Missing and Exploited Children. Fourth, to illustrate the limits of
algorithmic content moderation, this paper presents a successful strategy for
subverting DALL•E's aggressive automated censor, which inadvertently also
unleashed grotesquely racist imagery. Fifth, this paper proposes a new
intellectual property regime specifically for AI. It re-combines proven
elements from copyright and patent law, resulting in a framework that balances
the interests of those who invest in state-of-the-art AI and everyone else.
Finally, this paper concludes by pointing towards harm reduction as a mindset
for, possibly maybe, making life in this digital penal colony at least somewhat
bearable—because, I fear, we are stuck in it.


## Findings

Highlights of the paper’s findings include:

  * Content moderation by all surveyed social media is punitive and excessively
    so. Social media are on the best way to creating a new underclass of people
    without a voice on these platforms.
  * Content moderation by all surveyed social media runs against the public
    interest. Particularly prohibitions against misinformation are extremely
    chilling given pervasive failures by medical experts during the pandemic.
  * Transparency reports by all surveyed social media besides Reddit and YouTube
    suffer from significant data quality issues.
  * Transparency disclosures by Meta are so ridden by data quality issues to be
    wholly untrustworthy and meaningless. Unfortunately, that is the case for
    Meta’s data disclosures to researchers and customers as well.
  * As demonstrated on OpenAI’s DALL•E 2, algorithmic censors based on large
    language models are vulnerable to a new kind of attack strategy that is hard
    if not impossible to mitigate.
  * As demonstrated on ChatGPT, large language models can significantly simplify
    and shorten the experiments necessary for that attack, raising significant
    doubts about the efficacy of AI-based content moderation.
  * OpenAI’s DALL•E 2 produces deeply racist images without being prompted to do
    so, most likely due to a naive diversity mitigation.

The paper explores regulatory responses to this sorry state of content
moderation and transparency reporting but rejects them as too punitive. Instead
it points towards more subversive, harm-reducing approaches to dismantling the
stochastic penal colony. It also proposes a new intellectual property regime for
AI that remixes existing, proven copyright and patent provisions to ensure that
all of society benefits from this amazing new technology.


## Source Code and Supplements

Source code and supplements for the paper “Letters from the Stochastic Penal
Colony 🏝” by Robert Grimm.

  * A [__custom build script__](build.sh) in the repository root takes care of
    repetitive tasks. The one optional argument is the name of the task to
    execute.
  * By default, i.e., when invoked without argument, the build script runs
    `pdflatex` and `bibtex` to __create the PDF document__ from the LaTeX files
    in the [source](source) directory.
  * Since LaTeX and BibTex are incredibly noisy in their output, the build
    script contains custom logic to __detect actionable warnings__ and then
    error out.
  * To work with the ACM's new (but arguably not improved) publishing flow, the
    paper uses only approved LaTeX packages and __compiles with `pdflatex`__. To
    produce my own copies, it also compiles with `lualatex` when the build
    script is given the `lua` argument.
  * Unfortunately, that leaves only one subpar option for __color emoji__,
    namely simulating them by including graphics files. I wrote my own LaTeX
    package, emo, to take care of that and then some. Emo is included with the
    paper sources, but may be outdated. Check out [its
    repository](https://github.com/apparebit/emo) or
    [CTAN](https://ctan.org/pkg/emo).
  * Transparency data and Jupyter notebooks with the code for __analyzing the
    data__ are inside the [supplements](supplements) directory.
  * The build script assumes that the __virtual environment__ with Python
    packages necessary for running the notebooks is contained in the `.venv`
    directory. When invoked with the `venv` argument, it checks whether that
    directory exists, creating the virtual environment and installing packages
    otherwise, and then activates the virtual environment.


## (C) Copyright 2023 by Robert Grimm

The shell script and Jupyter notebooks included in this repository have been
released as open source under the Apache 2.0 license. Otherwise, all rights are
reserved, including for the paper itself.
