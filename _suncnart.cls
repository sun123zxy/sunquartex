\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{_suncnart}[2022/12/20 modified from ctexart]

\LoadClass[fontset=fandol, zihao=5]{ctexart} % ctex, 5 size for text
\RequirePackage[a4paper,top=2.75cm,bottom=2.25cm,left=2.75cm,right=2.75cm,marginparwidth=1.75cm]{geometry}

\ctexset{
    section/format              += \zihao{-4}\heiti\mdseries\raggedright,
    section/numberformat        += \rmfamily\bfseries,
    subsection/format           += \zihao{5}\heiti\mdseries\raggedright,
    subsection/numberformat     += \rmfamily\bfseries,
    subsubsection/format        += \zihao{5}\heiti\mdseries\raggedright,
    subsubsection/numberformat  += \rmfamily\bfseries,
    paragraph/format            += \heiti\mdseries,
    subparagraph/format         += \heiti\mdseries,
}

% subtitle (optional) & title
\let \oldtitle \title % to avoid recursive call
\renewcommand{\title}[2][\vspace{-0.5em}]{\oldtitle{{\zihao{-2} \heiti #2} \\ \vspace{0.5em} {\zihao{4} \kaishu #1}}}

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
{\thmname{\heiti#1}\thmnumber{ \textbf{#2}}\thmnote{\heiti（#3）}}% Theorem head spec % bold number

\let \oldproofname \proofname % to avoid recursive call
\renewcommand{\proofname}{\indent \heiti \oldproofname \nopunct}

\theoremstyle{suncnthm}