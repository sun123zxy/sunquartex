\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{sunenpre}[a wrapper for beamer]

\LoadClass[fontset=fandol,envcountsect]{beamer}

% --- bibliography ---

\RequirePackage[backend=biber,style=ieee,autocite=plain]{biblatex}

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
\newtheorem{theorem}{Theorem}[section]
\newtheorem{definition}{Definition}[section]
\newtheorem{lemma}{Lemma}[section]
\newtheorem{corollary}{Corollary}[section]
\newtheorem{proposition}{Proposition}[section]
\newtheorem{conjecture}{Conjecture}[section]

\theoremstyle{example}
\newtheorem{example}{Example}[section]
\newtheorem{exercise}{Exercise}[section]

\theoremstyle{remark}
% \newtheorem*{myproof}{Proof}
\newtheorem*{solution}{Solution}
\newtheorem*{remark}{Remark}

% \renewenvironment{proof}{\begin{myproof}}{\qed \end{myproof}}