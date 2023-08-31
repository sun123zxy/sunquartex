\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{sunenart}

\LoadClass{article}
\RequirePackage[a4paper,top=2.75cm,bottom=2.25cm,left=2.75cm,right=2.75cm,marginparwidth=1.75cm]{geometry}

% subtitle (optional) & title
% need reconstruction (by titling?)
\let \oldtitle \title % to avoid recursive call
\renewcommand{\title}[2][\vspace{-0.5em}]{\oldtitle{#2 \\ \vspace{0.5em} {\large #1}}}

% \renewenvironment{abstract}{\subparagraph{摘要}\kaishu}{}
% \newenvironment{keywords}{\subparagraph{关键词}\kaishu}{}

% amsthm

\RequirePackage{amsmath} % better math. including \eqref
\RequirePackage{amsthm} % better theorem-like environment support (such as proof, unordered, etc.)

\theoremstyle{definition}
\newtheorem{theorem}{Theorem}[section]     % counter reset on each section
\newtheorem{lemma}{Lemma}[section]       % counter reset on each section
\newtheorem{corollary}{Corollary}[section]   % counter reset on each section
\newtheorem{proposition}{Proposition}[section] % counter reset on each section
\newtheorem{conjecture}{Conjecture}[section]  % counter reset on each section
\newtheorem{definition}{Definition}[section]  % counter reset on each section
\newtheorem{example}{Example}[section]       % counter reset on each section
\newtheorem{exercise}{Exersise}[section]    % counter reset on each section

\theoremstyle{remark}
\newtheorem*{solution}{Solution}
\newtheorem*{remark}{Remark}

% bib

\usepackage[backend=biber,style=ieee,autocite=plain]{biblatex} % ieee style