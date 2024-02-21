\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{suncnart}[a wrapper for ctexart]

\LoadClass[fontset=fandol, zihao=5]{ctexart} % ctex, 5 size for text
\RequirePackage[a4paper,top=2.75cm,bottom=2.25cm,left=2.75cm,right=2.75cm,marginparwidth=1.75cm]{geometry}

\setCJKmainfont{FandolSong-Regular}[BoldFont = FandolHei-Regular, ItalicFont = KaiTi] % Hei represents bold, Kai represents italic

\ctexset{
    section/format              += \zihao{-4}\raggedright,
    subsection/format           += \zihao{5}\raggedright,
    subsubsection/format        += \zihao{5}\raggedright,
    subsubsection/numbering      = false
}

% --- title ---

% title
\RequirePackage{titling}
\pretitle{\begin{center} \zihao{-2} \bfseries}
\posttitle{\par\end{center}\vskip 0.5em}
\RequirePackage{etoolbox}
\makeatletter
\providecommand{\subtitle}[1]{
  \apptocmd{\@title}{\vskip 0.5em \par {\zihao{4} \kaishu #1 \par}}{}{}
}
\makeatother
% author
\preauthor{\begin{center}\zihao{-4}\kaishu % \kaishu for Chinese only
    \lineskip 0.5em%
    \begin{tabular}[t]{c}}
\postauthor{\end{tabular}\par\end{center}}
% date
\predate{\begin{center} \zihao{-4} \kaishu}
\postdate{\par\end{center}}

% --- abstract ---

\renewenvironment{abstract}{\subparagraph{摘要}\kaishu}{}
\newenvironment{keywords}{\subparagraph{关键词}\kaishu}{}

% -- amsthm ---

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

\theoremstyle{suncnthm}

\newtheorem{theorem}{定理}[section]     % counter reset on each section
\newtheorem{lemma}{引理}[section]       % counter reset on each section
\newtheorem{corollary}{推论}[section]   % counter reset on each section
\newtheorem{proposition}{命题}[section] % counter reset on each section
\newtheorem{conjecture}{猜想}[section]  % counter reset on each section
\newtheorem{definition}{定义}[section]  % counter reset on each section
\newtheorem{example}{例}[section]       % counter reset on each section
\newtheorem{exercise}{习题}[section]    % counter reset on each section
\newtheorem*{solution}{解}
\newtheorem*{remark}{注记}

\newtheorem*{myproof}{证明}
\renewenvironment{proof}{\begin{myproof}}{\qed \end{myproof}}
% \let \oldproofname \proofname % to avoid recursive call
% \renewcommand{\proofname}{\indent \heiti \oldproofname \nopunct} % strange that using \bfseries do not work properly...

% --- bib ---

\usepackage[backend=biber,style=gb7714-2015,autocite=plain]{biblatex} % gb style