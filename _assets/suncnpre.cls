\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{suncnpre}[a wrapper for ctexbeamer]

\LoadClass[fontset=fandol,envcountsect]{ctexbeamer}

% --- bibliography ---

\RequirePackage[backend=biber,style=gb7714-2015,autocite=plain]{biblatex}

% --- theorem ---

\makeatletter
\def\cleartheorem#1{%
    \expandafter\let\csname#1\endcsname\relax
    \expandafter\let\csname c@#1\endcsname\relax
}
\makeatother

\cleartheorem{theorem}
\cleartheorem{lemma}
\cleartheorem{corollary}
\cleartheorem{definition}
\cleartheorem{example}
\cleartheorem{solution}

\theoremstyle{theorem}
\newtheorem{theorem}{定理}[section]
\newtheorem{definition}{定义}[section]
\newtheorem{lemma}{引理}[section]
\newtheorem{corollary}{推论}[section]
\newtheorem{proposition}{命题}[section]
\newtheorem{conjecture}{猜想}[section]

\theoremstyle{example}
\newtheorem{example}{例}[section]
\newtheorem{exercise}{习题}[section]

\theoremstyle{remark}
\newtheorem*{myproof}{证明}
\newtheorem*{solution}{解}
\newtheorem*{remark}{评注}

\renewenvironment{proof}{\begin{myproof}}{\qed \end{myproof}}

% --- styles ---

\setlength{\parindent}{2em}
\addtobeamertemplate{block begin}{}{\setlength\parindent{2em}}
\addtobeamertemplate{block example begin}{}{\setlength\parindent{2em}}
\addtobeamertemplate{alertblock alerted begin}{}{\setlength\parindent{2em}}

\setlength{\parskip}{3pt} % slighty more spacing