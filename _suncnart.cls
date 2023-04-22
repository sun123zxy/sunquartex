\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{_suncnart}[2022/12/20 modified from ctexart]

\LoadClass[fontset=fandol, zihao=5]{ctexart} % ctex, 5 size for text
\RequirePackage[a4paper,top=2.75cm,bottom=2.25cm,left=2.75cm,right=2.75cm,marginparwidth=1.75cm]{geometry}

\setCJKmainfont{FandolSong-Regular}[BoldFont = FandolHei-Regular, ItalicFont = KaiTi] % Hei represents bold, Kai represents italic

\ctexset{
    section/format              += \zihao{-4}\raggedright,
    subsection/format           += \zihao{5}\raggedright,
    subsubsection/format        += \zihao{5}\raggedright
}

% subtitle (optional) & title
\let \oldtitle \title % to avoid recursive call
\renewcommand{\title}[2][\vspace{-0.5em}]{\oldtitle{{\zihao{-2} \bfseries #2} \\ \vspace{0.5em} {\zihao{4} \kaishu #1}}}

% author
\let \oldauthor \author % to avoid recursive call
\renewcommand{\author}[1]{\oldauthor{\zihao{-4} \kaishu #1}}

% date
\let \olddate \date % to avoid recursive call
\renewcommand{\date}[1]{\olddate{\zihao{-4} \kaishu #1}}

\renewenvironment{abstract}{\subparagraph{摘要}\kaishu}{}
\newenvironment{keywords}{\subparagraph{关键词}\kaishu}{}

% amsthm

\RequirePackage{amsmath} % better math. including \eqref
\RequirePackage{amsthm} % better theorem-like environment support (such as proof, unordered, etc.)

\newtheoremstyle{suncnthm}% name
{}% Space above
{}% Space below
{}% Body font
{\parindent}% Indent amount
{}% Theorem head font
{\phantom{.}}% Punctuation after theorem head % no punctuation
{5pt plus 1pt minus 1pt}% Space after theorem head % default
{\bfseries \thmname{#1}\thmnumber{ #2}\thmnote{（#3）}}% Theorem head spec % bold number

\let \oldproofname \proofname % to avoid recursive call
\renewcommand{\proofname}{\indent \heiti \oldproofname \nopunct} % strange that using \bfseries do not work properly...

\theoremstyle{suncnthm}