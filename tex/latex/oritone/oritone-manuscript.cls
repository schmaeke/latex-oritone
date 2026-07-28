% SPDX-License-Identifier: MIT
\NeedsTeXFormat{LaTeX2e}[2020-10-01]
\ProvidesClass{oritone-manuscript}[2026/05/04 v0.1.0 Oritone manuscript class]

% Scientific manuscript class built on extarticle. It provides a compact title
% block, full-width abstract, localized keywords helper, line numbers, dense
% headings, semantic links, callouts, listings, and running page metadata.
%
% Source organization:
%   1. Class option parsing and extarticle loading.
%   2. Package loading and document-wide typography.
%   3. Title, abstract, keywords, and compile metadata helpers.
%   4. Heading, header/footer, listing, link, and caption setup.
%   5. PDF metadata setup.

\makeatletter

% Default class options. Manuscripts are twoside by default because review PDFs
% commonly need mirrored running heads and footers.
\newif\iforitonemanuscript@twoside
\oritonemanuscript@twosidetrue
\def\oritonemanuscript@paper{a4paper}
\def\oritonemanuscript@fontsize{10pt}
\def\oritonemanuscript@mode{white}
\def\oritonemanuscript@accent{auto}
\def\oritonemanuscript@language{english}
\def\oritonemanuscript@modekey{mode}
\def\oritonemanuscript@accentkey{accent}
\def\oritonemanuscript@languagekey{language}

% Parse key=value class options such as mode=dark, accent=cyan, and
% language=ngerman. Unknown keys are forwarded to extarticle.
\def\oritonemanuscript@handlekeyvalue#1=#2\@nil{%
  \def\oritonemanuscript@key{#1}%
  \ifx\oritonemanuscript@key\oritonemanuscript@modekey
    \def\oritonemanuscript@mode{#2}%
  \else
    \ifx\oritonemanuscript@key\oritonemanuscript@accentkey
      \def\oritonemanuscript@accent{#2}%
    \else
      \ifx\oritonemanuscript@key\oritonemanuscript@languagekey
        \def\oritonemanuscript@language{#2}%
      \else
        \PassOptionsToClass{\CurrentOption}{extarticle}%
      \fi
    \fi
  \fi
}
% Split unknown class options into key=value pairs or plain extarticle options.
\newcommand*\oritonemanuscript@handleunknownoption{%
  \@expandtwoargs\in@{=}{\CurrentOption}%
  \ifin@
    \expandafter\oritonemanuscript@handlekeyvalue\CurrentOption\@nil
  \else
    \PassOptionsToClass{\CurrentOption}{extarticle}%
  \fi
}

% Oritone-specific options plus common extarticle paper, size, and side options.
\DeclareOption{light}{\def\oritonemanuscript@mode{light}}
\DeclareOption{dark}{\def\oritonemanuscript@mode{dark}}
\DeclareOption{white}{\def\oritonemanuscript@mode{white}}
\DeclareOption{black}{\def\oritonemanuscript@mode{black}}
\DeclareOption{english}{\def\oritonemanuscript@language{english}}
\DeclareOption{american}{\def\oritonemanuscript@language{american}}
\DeclareOption{british}{\def\oritonemanuscript@language{british}}
\DeclareOption{ngerman}{\def\oritonemanuscript@language{ngerman}}
\DeclareOption{german}{\def\oritonemanuscript@language{german}}
\DeclareOption{oneside}{\oritonemanuscript@twosidefalse}
\DeclareOption{twoside}{\oritonemanuscript@twosidetrue}
\DeclareOption{a4paper}{\def\oritonemanuscript@paper{a4paper}}
\DeclareOption{a5paper}{\def\oritonemanuscript@paper{a5paper}}
\DeclareOption{b5paper}{\def\oritonemanuscript@paper{b5paper}}
\DeclareOption{letterpaper}{\def\oritonemanuscript@paper{letterpaper}}
\DeclareOption{legalpaper}{\def\oritonemanuscript@paper{legalpaper}}
\DeclareOption{executivepaper}{\def\oritonemanuscript@paper{executivepaper}}
\DeclareOption{8pt}{\def\oritonemanuscript@fontsize{8pt}}
\DeclareOption{9pt}{\def\oritonemanuscript@fontsize{9pt}}
\DeclareOption{10pt}{\def\oritonemanuscript@fontsize{10pt}}
\DeclareOption{11pt}{\def\oritonemanuscript@fontsize{11pt}}
\DeclareOption{12pt}{\def\oritonemanuscript@fontsize{12pt}}
\DeclareOption{14pt}{\def\oritonemanuscript@fontsize{14pt}}
\DeclareOption{17pt}{\def\oritonemanuscript@fontsize{17pt}}
\DeclareOption{20pt}{\def\oritonemanuscript@fontsize{20pt}}
\DeclareOption*{\oritonemanuscript@handleunknownoption}
\ProcessOptions\relax

% extarticle provides the broader 8pt to 20pt size range used by the manuscript
% class while keeping article-like sectioning.
\iforitonemanuscript@twoside
  \LoadClass[\oritonemanuscript@paper,\oritonemanuscript@fontsize,twoside]{extarticle}
\else
  \LoadClass[\oritonemanuscript@paper,\oritonemanuscript@fontsize,oneside]{extarticle}
\fi

% Dependencies. oritone-fonts installs STIX/Roboto/Recursive roles, oritone installs
% semantic colors, and oritone-design installs shared labels, title rules, and
% callout helpers.
\RequirePackage{oritone-fonts}
\RequirePackage[mode=\oritonemanuscript@mode,accent=\oritonemanuscript@accent]{oritone}
\RequirePackage{oritone-design}
\RequirePackage[
  top=2.5cm,
  bottom=3.5cm,
  left=2cm,
  right=2cm
]{geometry}
\RequirePackage[\oritonemanuscript@language]{babel}
\RequirePackage{amsmath}
\RequirePackage{xfrac}
\RequirePackage{fancyhdr}
\RequirePackage[parfill]{parskip}
\RequirePackage{caption}
\RequirePackage[explicit]{titlesec}
\RequirePackage{setspace}
\RequirePackage{microtype}
\RequirePackage{calc}
\RequirePackage{authblk}
\RequirePackage{tikz}
\RequirePackage[skins]{tcolorbox}
\RequirePackage{hyperref}
\RequirePackage[noabbrev,nameinlink]{cleveref}
\RequirePackage{lastpage}
\RequirePackage{datetime}
\PassOptionsToPackage{right}{lineno}
\RequirePackage{lineno}
\RequirePackage{listings}

% Shared Oritone setup. Listings and callouts are defined after their packages
% are loaded. The manuscript body remains serif, with sans used for display
% roles such as title, headings, abstract label, captions, and running heads.
\oritonelistingssetup
\oritonedefinecallouts
\oritoneUseSerifAsDefault
\oritoneApplyPageColors

\setstretch{1.5}
\setcounter{secnumdepth}{4}
\setcounter{tocdepth}{3}

% Keep a copy of the title for hyperref metadata. The underlying \@title is
% still set so normal LaTeX title behavior works.
\def\oritonemanuscript@pdftitle{}
\renewcommand{\title}[1]{%
  \gdef\oritonemanuscript@pdftitle{#1}%
  \gdef\@title{#1}%
}
\renewcommand{\Authfont}{\oritoneDisplayFont\LARGE}
\renewcommand{\Affilfont}{\oritoneDisplayFont\small}

% Title page block. authblk supplies the author table content; the shared ruled
% title helper draws the accent rules around the title.
\def\@maketitle{%
  \newpage
  \null
  \vskip 2em%
  \begin{center}%
    \let\footnote\thanks
    \oritoneRuledTitle{\@title}%
    \vskip 1.5em%
    {\large
      \lineskip .5em%
      \begin{tabular}[t]{c}%
        \@author
      \end{tabular}\par}%
    \vskip 1em%
    {\large \@date}%
  \end{center}%
  \par
  \vskip 1.5em%
}

% Full-width abstract. extarticle's default abstract uses a quotation-like
% wrapper; this class removes that indentation and width reduction.
\renewenvironment{abstract}{%
  \par
  \vskip 1em%
  {\centering\oritoneDisplayFont\bfseries\oritonecurrentlabel{abstract}\par}%
  \vskip 0.5em%
  \begingroup
    \setlength{\parindent}{0pt}%
    \noindent\ignorespaces
}{%
    \par
  \endgroup
  \vskip 1em%
}

% Front-matter helpers. \keywords keeps the label styling in the class instead
% of requiring examples or users to hard-code `Keywords:` formatting.
\newcommand*{\keywordsep}{\oritonemutedseparator}
\newcommand*{\keywordsname}{\oritonecurrentlabel{keywords}}
\newcommand{\keywords}[1]{%
  \par
  \noindent{\oritoneDisplayFont\bfseries\keywordsname:} #1\par
}
\newcommand*{\separator}{\oritoneaccentseparator}
% Section numbers are pulled into the left margin by titleformat through this
% zero-width box.
\newcommand*{\pushtoleft}[1]{\makebox[0pt][r]{#1}}
\newcommand*{\compileinfo}{\enspace}
% Optional footer timestamp. It is opt-in so documents can avoid volatile
% output when reproducible PDFs are important.
\newcommand*{\printcompileinfo}{%
  \renewcommand*{\compileinfo}{%
    \oritonelabel{compiled}{\oritonemanuscript@language}%
    \enspace\today\enspace
    \oritonelabel{at}{\oritonemanuscript@language}%
    \enspace\currenttime}%
}

% Compact heading hierarchy. Section numbers sit in the margin with accent
% separators; all headings use the shared sans display font.
\titleformat{name=\section,numberless}[display]{}{}{0.0cm}{\oritoneDisplayFont\large\color{headings}\bfseries#1}[]
\titleformat{name=\section}[display]{}{}{0.0cm}{\oritoneDisplayFont\large\color{headings}\pushtoleft{\textcolor{accent}{\thesection}\separator}\bfseries#1}[]
\titlespacing{\section}{0cm}{0.0cm}{0.25cm}

\titleformat{name=\subsection,numberless}[display]{}{}{0.0cm}{\oritoneDisplayFont\color{headings}\bfseries#1}[]
\titleformat{name=\subsection}[display]{}{}{0.0cm}{\oritoneDisplayFont\color{headings}\pushtoleft{\textcolor{accent}{\thesubsection}\separator}\bfseries#1}[]
\titlespacing{\subsection}{0cm}{0.0cm}{0.0cm}

\titleformat{name=\subsubsection,numberless}[display]{}{}{0.0cm}{\oritoneDisplayFont\color{headings}\itshape#1}[]
\titleformat{name=\subsubsection}[display]{}{}{0.0cm}{\oritoneDisplayFont\color{headings}\pushtoleft{\textbf{\textcolor{accent}{\thesubsubsection}}\separator}\itshape#1}[]
\titlespacing{\subsubsection}{0cm}{0.0cm}{0.0cm}

\titleformat{name=\paragraph}[runin]{}{}{0.0cm}{\oritoneDisplayFont\color{headings}\textbf{#1}\separator}[]
\titlespacing{\paragraph}{0cm}{0.0cm}{0.0cm}

% Running heads and footers. The `plain` style is made identical so title pages
% and chapter-like pages do not unexpectedly lose the Oritone footer.
\setlength{\headheight}{14.5pt}
\newcommand*\oritonemanuscript@headfootfont{\oritoneDisplayFont\small\color{headerandfooter}}
\fancypagestyle{oritonemanuscript}{%
  \fancyhf{}%
  \renewcommand{\headrulewidth}{0pt}%
  \renewcommand{\footrulewidth}{0pt}%
  \fancyhead[OR]{\oritonemanuscript@headfootfont\nouppercase\rightmark}%
  \fancyhead[EL]{\oritonemanuscript@headfootfont\nouppercase\leftmark}%
  \fancyfoot[OR,EL]{\oritonemanuscript@headfootfont\thepage\enspace\oritonelabel{of}{\oritonemanuscript@language}\enspace\pageref*{LastPage}}%
  \fancyfoot[ER,OL]{\oritonemanuscript@headfootfont\compileinfo}%
}
\fancypagestyle{plain}{%
  \fancyhf{}%
  \renewcommand{\headrulewidth}{0pt}%
  \renewcommand{\footrulewidth}{0pt}%
  \fancyhead[OR]{\oritonemanuscript@headfootfont\nouppercase\rightmark}%
  \fancyhead[EL]{\oritonemanuscript@headfootfont\nouppercase\leftmark}%
  \fancyfoot[OR,EL]{\oritonemanuscript@headfootfont\thepage\enspace\oritonelabel{of}{\oritonemanuscript@language}\enspace\pageref*{LastPage}}%
  \fancyfoot[ER,OL]{\oritonemanuscript@headfootfont\compileinfo}%
}
\pagestyle{oritonemanuscript}

% Cross-reference names for listings.
\crefname{lstlisting}{listing}{listings}
\Crefname{lstlisting}{Listing}{Listings}

\lstdefinestyle{manuscript}{%
  style=oritone-listing,
}
\lstset{style=manuscript}

% Semantic link colors are applied after hyperref has been loaded.
\oritoneSetSemanticLinks

% Captions use sans bold labels but keep body text in the document body font.
\captionsetup{
  labelfont={sf,bf},
  font={stretch=1.5},
  format=hang,
  justification=justified
}

% Hyperref metadata must wait until the document begins because users usually
% call \title in the preamble after the class has loaded.
\AtBeginDocument{%
  \hypersetup{
    pdftitle={\oritonemanuscript@pdftitle}
  }%
}

\makeatother
\endinput
