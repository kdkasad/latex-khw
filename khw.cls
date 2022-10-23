%% khw.cls
%% Copyright (C) 2022  Kian Kasad
%
% This work may be distributed and/or modified under the
% conditions of the LaTeX Project Public License, either version 1.3
% of this license or (at your option) any later version.
% The latest version of this license is in
%   http://www.latex-project.org/lppl.txt
% and version 1.3 or later is part of all distributions of LaTeX
% version 2005/12/01 or later.
%
% This work has the LPPL maintenance status `author-maintained'.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{khw}[2022-10-07 Kian's Homework Assignment Class]

%% PROCESS OPTIONS %%

% Pass unknown options to article base class
\DeclareOption*{%
    \PassOptionsToClass{\CurrentOption}{article}
}

\ProcessOptions\relax

%% END PROCESS OPTIONS %%

% Based on article class
\LoadClass[letterpaper, 12pt]{article}

% Page geometry
\RequirePackage[
    letterpaper,
    left=2.5cm,
    right=2.5cm,
    top=2cm,
    bottom=2cm
]{geometry}

% Fonts
\RequirePackage{fontspec}
\RequirePackage{plex-otf}
% Use semi-bold as standard bold
\linespread{1.3}

% For colors
\RequirePackage[dvipsnames]{xcolor}
\colorlet{khwaccent}{Dandelion!85!black}
\definecolor{khwmain}{HTML}{434343}
\definecolor{khwdark}{HTML}{252525}
\colorlet{khwlight}{black!65}
\color{khwmain}

% For PDF links
\RequirePackage[hyphens]{url}
\RequirePackage[
    colorlinks,
    linkcolor=khwmain,
    urlcolor=khwaccent,
    bookmarks=true,
    bookmarksopen=true,
    pdfpagelabels,
    breaklinks=true
]{hyperref}
\AtBeginDocument{
    \hypersetup{
        pdfborder={1 1 1},
        pdfborderstyle={/S/U/W 1},
        linkbordercolor=white, % fake transparency
        urlbordercolor=khwaccent
    }
}
\urlstyle{same}

% For length calculations
\RequirePackage{calc}

% For footnote formatting
\RequirePackage[bottom]{footmisc}

% For e-TeX features
\RequirePackage{etoolbox}

% English language
\RequirePackage[english]{babel}

% Skip space between paragraphs
\RequirePackage{parskip}

% For changing heading styles
\RequirePackage[explicit]{titlesec}

% For images/graphics
\RequirePackage{graphicx}
\graphicspath{{img/}}

% Change list spacing
\RequirePackage{enumitem}
\setlist{nosep}

% Smaller image captions
\usepackage[font=small,skip=0pt]{caption}

% We don't want paragraphs to indent, but we do want \indent to work
%\newlength{\tindent}
%\setlength{\tindent}{\parindent}
%\setlength{\parindent}{0pt}
%\renewcommand{\indent}{\hspace*{\tindent}}

%% COMMANDS %%

\newcommand{\@khw@titleparam}[1]{
    \@namedef{@#1}{\ClassError{khw}{\expandafter\noexpand\csname#1\endcsname{...} must be specified}{}}
    \@namedef{#1}##1{\@namedef{@#1}{##1}}
}

% Title page parameters
\@khw@titleparam{course}
\@khw@titleparam{instructor}
\@khw@titleparam{titlehead}
\@khw@titleparam{subtitle}

% Title
\newcommand{\@titleA}{\ClassError{khw}{\noexpand\title{...}{...} not specified.}}
\newcommand{\@titleB}{\ClassError{khw}{\noexpand\title{...}{...} not specified.}}
\renewcommand{\@title}{\ClassError{khw}{\noexpand\title{...}{...} not specified.}}
\renewcommand{\title}[2]{
    \renewcommand{\@titleA}{#1}
    \renewcommand{\@titleB}{#2}
    \renewcommand{\@title}{#1 #2}
    \hypersetup{pdftitle={#1 #2}}
}

% Author
% \renewcommand{\@author}{\ClassError{khw}{\noexpand\author{...} not specified}{}}
% \renewcommand{\author}[1]{
%     \renewcommand{\@author}{#1}
%     \hypersetup{pdfauthor={#1}}
% }

\renewcommand{\maketitle}{
    \thispagestyle{empty}
    \pagecolor{khwaccent}
    \color{white}

	\vspace*{2cm}
    \begingroup
    \raggedright
    \hyphenpenalty=10000
	{ \sffamily \fontsize{48pt}{48pt}\selectfont
      \textcolor{khwdark}{\@titleA}\\[8pt] \@titleB }

    { \sffamily \bfseries \Large
      \textcolor{khwlight}{\@subtitle} }
    \endgroup

    \vspace{3.5cm}
    \@course{} --- \@instructor

    \vfill
    {\raggedleft \@author \par}
    \vspace{0.5cm}

	\clearpage
    % Reset colors for rest of document
    \nopagecolor \color{khwmain}
}

% Parbox with depth problem fixed
\newcommand{\fparbox}[2]{
    \parbox{#1}{
        #2
        \par\xdef\khw@tpd{\the\prevdepth}
    }\par
    \prevdepth\khw@tpd
}

% \blockquote{quote}{source/author}{URL}
\newcommand{\blockquote}[3]{
    \hfill\fparbox{\textwidth-1cm}{
        {\itshape #1}\\
        {\hspace*{\fill} -- #2%
            \if \relax \detokenize{#3}\relax \else
            \footnotemark
            \fi
        }
    }
    \if \relax \detokenize{#3}\relax \else
        \footnotetext{\url{#3}}
    \fi
}
 
% Extract first word from argument
\def\firstword#1 #2\relax{#1}
\def\notfirstword#1 #2\relax{#2}

\titleformat{\section}%
    {\sffamily \fontsize{25pt}{25pt} \selectfont}{}{0pt}%
    {\textcolor{khwaccent}{\firstword #1 \relax}
     \textcolor{khwdark}{\notfirstword #1 \relax}}

\titleformat{\subsection}%
    {\sffamily \fontsize{19pt}{19pt} \selectfont}{}{0pt}%
    {\textcolor{khwdark}{#1}}

\titleformat{\subsubsection}%
    {\sffamily \fontsize{14pt}{14pt} \selectfont}{}{0pt}%
    {\textcolor{khwdark}{#1}}

%
% Labeled footnotes
%
\newcommand{\fntext}[2]{%
	\expandafter\newcommand \csname @khw@fntext:#1 \endcsname {#2}%
}
\newcommand{\fn}[1]{%
	\footnote{\label{fn:#1}\csname @khw@fntext:#1 \endcsname}%
}
\newcommand{\fnref}[1]{%
    \footnote{See \autoref{fn:#1}.}%
}

% Footnote formatting:
%   - Non-breaking space between number and text
%   - Hang indent to keep text flush on left side
\newlength{\@khw@fnhangindent}
\renewcommand{\@makefntext}[1]{
    \raggedright \noindent%
    \settowidth{\@khw@fnhangindent}{\@makefnmark~}%
    \hangindent \@khw@fnhangindent %
    \fontsize{9pt}{9pt} \selectfont %
    \@makefnmark~#1
}

% Include image with frame
\newcommand{\framedgraphics}[2][\textwidth]{%
    {
        \setlength{\fboxsep}{0pt}
        \framebox{\includegraphics[width=#1-2\fboxrule]{#2}}
    }%
}

%
% List shortcuts
%
\newcommand{\ul}[1]{ \begin{itemize} #1 \end{itemize} }
% Creates a nested \ul with a single item
\def\nestitem#1\par{\ul{\item #1}}

%% END COMMANDS %%
