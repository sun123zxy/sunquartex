\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{sunenart}

\LoadClass{article}
\RequirePackage[a4paper,top=2.75cm,bottom=2.25cm,left=2.75cm,right=2.75cm,marginparwidth=1.75cm]{geometry}

% --- title ---

\RequirePackage{etoolbox}
\makeatletter
\providecommand{\subtitle}[1]{
  \apptocmd{\@title}{\vskip 0.5em \par {\large #1 \par}}{}{}
}
\makeatother

% --- amsthm ---

\RequirePackage{amsmath}
\RequirePackage{amsthm}

\theoremstyle{definition}
\newtheorem{theorem}{Theorem}[section]
\newtheorem{lemma}{Lemma}[section]
\newtheorem{corollary}{Corollary}[section]
\newtheorem{proposition}{Proposition}[section]
\newtheorem{conjecture}{Conjecture}[section]
\newtheorem{definition}{Definition}[section]
\newtheorem{example}{Example}[section]
\newtheorem{exercise}{Exersise}[section]

\theoremstyle{remark}
\newtheorem*{solution}{Solution}
\newtheorem*{remark}{Remark}

% --- bib ---

\RequirePackage[backend=biber,style=ieee,autocite=plain]{biblatex} % ieee style