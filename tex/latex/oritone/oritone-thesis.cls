% SPDX-License-Identifier: MIT
\NeedsTeXFormat{LaTeX2e}[2020-10-01]
\ProvidesClass{oritone-thesis}[2026/05/04 v0.1.0 Oritone thesis class]

% Thesis class built on book. It adds Oritone colors and fonts, thesis-specific
% metadata setters, a ruled title page, localized front-matter labels, optional
% biblatex support, declaration pages, dense headings, semantic callouts,
% listings, plots, and two-sided running heads.
%
% Source organization:
%   1. Class option parsing and book loading.
%   2. Package loading, engine-specific math helpers, and shared setup.
%   3. Localization, PDF metadata, thesis metadata setters, and utilities.
%   4. Front-matter helpers, bibliography helpers, and declaration page.
%   5. Headings, page styles, captions, listings, and title page.

\makeatletter

\RequirePackage{iftex}

% Option state. Boolean options control bibliography backend, hyperref link
% visibility, and draft overfull-rule behavior.
\newif\iforitonethesis@biblatex
\newif\iforitonethesis@hidelinks
\newif\iforitonethesis@draft

\def\oritonethesis@paper{a4paper}
\def\oritonethesis@sides{twoside}
\def\oritonethesis@fontsize{12pt}
\def\oritonethesis@draftoption{final}
\def\oritonethesis@language{english}
\def\oritonethesis@mode{white}
\def\oritonethesis@accent{auto}
\def\oritonethesis@modekey{mode}
\def\oritonethesis@accentkey{accent}
\def\oritonethesis@languagekey{language}

% Parse key=value class options. The explicit keys are Oritone-specific; any
% unknown key=value option is forwarded to book for normal LaTeX behavior.
\def\oritonethesis@handlekeyvalue#1=#2\@nil{%
  \def\oritonethesis@key{#1}%
  \ifx\oritonethesis@key\oritonethesis@modekey
    \def\oritonethesis@mode{#2}%
  \else
    \ifx\oritonethesis@key\oritonethesis@accentkey
      \def\oritonethesis@accent{#2}%
    \else
      \ifx\oritonethesis@key\oritonethesis@languagekey
        \def\oritonethesis@language{#2}%
      \else
        \PassOptionsToClass{\CurrentOption}{book}%
      \fi
    \fi
  \fi
}
% Split unknown options into key=value Oritone options or plain book options.
\newcommand*\oritonethesis@handleunknownoption{%
  \@expandtwoargs\in@{=}{\CurrentOption}%
  \ifin@
    \expandafter\oritonethesis@handlekeyvalue\CurrentOption\@nil
  \else
    \PassOptionsToClass{\CurrentOption}{book}%
  \fi
}

% Oritone modes, page options, draft/final behavior, language options,
% bibliography selection, and hyperref link behavior.
\DeclareOption{light}{\def\oritonethesis@mode{light}}
\DeclareOption{dark}{\def\oritonethesis@mode{dark}}
\DeclareOption{white}{\def\oritonethesis@mode{white}}
\DeclareOption{black}{\def\oritonethesis@mode{black}}
\DeclareOption{a4paper}{\def\oritonethesis@paper{a4paper}}
\DeclareOption{a5paper}{\def\oritonethesis@paper{a5paper}}
\DeclareOption{b5paper}{\def\oritonethesis@paper{b5paper}}
\DeclareOption{letterpaper}{\def\oritonethesis@paper{letterpaper}}
\DeclareOption{legalpaper}{\def\oritonethesis@paper{legalpaper}}
\DeclareOption{executivepaper}{\def\oritonethesis@paper{executivepaper}}
\DeclareOption{oneside}{\def\oritonethesis@sides{oneside}}
\DeclareOption{twoside}{\def\oritonethesis@sides{twoside}}
\DeclareOption{10pt}{\def\oritonethesis@fontsize{10pt}}
\DeclareOption{11pt}{\def\oritonethesis@fontsize{11pt}}
\DeclareOption{12pt}{\def\oritonethesis@fontsize{12pt}}
\DeclareOption{draft}{\oritonethesis@drafttrue\def\oritonethesis@draftoption{draft}}
\DeclareOption{final}{\oritonethesis@draftfalse\def\oritonethesis@draftoption{final}}
\DeclareOption{english}{\def\oritonethesis@language{english}}
\DeclareOption{ngerman}{\def\oritonethesis@language{ngerman}}
\DeclareOption{german}{\def\oritonethesis@language{german}}
\DeclareOption{bibtex}{\oritonethesis@biblatexfalse}
\DeclareOption{biblatex}{\oritonethesis@biblatextrue}
\DeclareOption{colorlinks}{\oritonethesis@hidelinksfalse}
\DeclareOption{hidelinks}{\oritonethesis@hidelinkstrue}
\DeclareOption*{\oritonethesis@handleunknownoption}
\ProcessOptions\relax

% Load the base book class with the normalized option values.
\LoadClass[
  \oritonethesis@paper,
  \oritonethesis@sides,
  \oritonethesis@fontsize,
  \oritonethesis@draftoption
]{book}

\iforitonethesis@draft
  \overfullrule=5pt
\fi

% Core Oritone dependencies and thesis layout packages. geometry uses a wider
% inner margin for bound two-sided output and a larger bottom margin for the
% running footer.
\RequirePackage{oritone-fonts}
\RequirePackage[mode=\oritonethesis@mode,accent=\oritonethesis@accent]{oritone}
\RequirePackage{oritone-design}
\RequirePackage[
  inner=2.25cm,
  outer=1.50cm,
  top=2.50cm,
  bottom=4.00cm,
  footskip=2.0cm
]{geometry}
\RequirePackage[\oritonethesis@language]{babel}
\RequirePackage{graphicx}
\RequirePackage{tabularx}
\RequirePackage{fancyhdr}
\RequirePackage[parfill]{parskip}
\RequirePackage{caption}
\RequirePackage[explicit]{titlesec}
\RequirePackage{setspace}
\RequirePackage{microtype}
\RequirePackage[most]{tcolorbox}
\RequirePackage{listings}
\RequirePackage{booktabs}
\RequirePackage{colortbl}
\RequirePackage{tikz}
\RequirePackage{tikz-3dplot}
\RequirePackage{pgfplots}
\RequirePackage{subcaption}
\RequirePackage{xfrac}
\RequirePackage{scalerel}

% Engine-specific bold symbol helper. pdfLaTeX uses bm, while unicode engines
% can use unicode-math's \symbf through the font package.
\ifPDFTeX
  \RequirePackage{amsmath}
  \RequirePackage{bm}
  \newcommand{\bs}[1]{\bm{#1}}
\else
  \RequirePackage{amsmath}
  \newcommand{\bs}[1]{\symbf{#1}}
\fi

% Shared plot/listing/callout setup used by the example thesis and downstream
% documents.
\usetikzlibrary{arrows.meta,calc,spy,shadings,patterns,perspective,decorations,decorations.markings}
\pgfplotsset{compat=1.18, compat/show suggested version=false}
\oritonepgfplotssetup
\oritonelistingssetup
\oritonedefinecallouts

% Optional bibliography backend. The default is classic BibTeX for fewer
% dependencies; the biblatex option switches to biber/authoryear.
\iforitonethesis@biblatex
  \RequirePackage{csquotes}
  \RequirePackage[backend=biber,style=authoryear]{biblatex}
\fi

\RequirePackage{hyperref}
\RequirePackage[noabbrev,nameinlink]{cleveref}

% Global document typography and counters. Thesis body text is serif; display
% roles and running heads use the shared sans font.
\oritoneUseSerifAsDefault
\oritoneApplyPageColors
\setstretch{1.3}
\setlength{\headheight}{14.5pt}
\setcounter{secnumdepth}{3}
\setcounter{tocdepth}{3}

% Lightweight language switch used by thesis helper text. Full label lookup is
% handled by oritone-design, but this flag keeps any longer future branch text
% easy to express.
\newif\iforitonethesis@germanlanguage
\def\oritonethesis@ngerman{ngerman}
\def\oritonethesis@german{german}
\edef\oritonethesis@language@tmp{\oritonethesis@language}
\ifx\oritonethesis@language@tmp\oritonethesis@ngerman
  \oritonethesis@germanlanguagetrue
\else
  \ifx\oritonethesis@language@tmp\oritonethesis@german
    \oritonethesis@germanlanguagetrue
  \fi
\fi
\long\def\oritonethesis@ifgerman#1#2{%
  \iforitonethesis@germanlanguage
    #1%
  \else
    #2%
  \fi
}

% Localized label macros. These resolve through the shared label registry using
% the class-selected language and are used across title page and front matter.
\def\oritonethesis@abstractname{\oritonelabel{abstract}{\oritonethesis@language}}
\def\oritonethesis@declarationname{\oritonelabel{declaration}{\oritonethesis@language}}
\def\oritonethesis@declarationtext{\oritonelabel{declaration-text}{\oritonethesis@language}}
\def\oritonethesis@placeDateLabel{\oritonelabel{place-date}{\oritonethesis@language}}
\def\oritonethesis@signatureLabel{\oritonelabel{signature}{\oritonethesis@language}}
\def\oritonethesis@firstExaminerLabel{\oritonelabel{first-examiner}{\oritonethesis@language}}
\def\oritonethesis@secondExaminerLabel{\oritonelabel{second-examiner}{\oritonethesis@language}}
\def\oritonethesis@dateLabel{\oritonelabel{date}{\oritonethesis@language}}
\def\oritonethesis@degreeSentence{\oritonelabel{degree-sentence}{\oritonethesis@language}}
\def\oritonethesis@byLabel{\oritonelabel{by}{\oritonethesis@language}}
\def\oritonethesis@onLabel{\oritonelabel{on}{\oritonethesis@language}}

% Hyperref link policy. `hidelinks` is useful for submission copies; otherwise
% the semantic Oritone link colors are used.
\iforitonethesis@hidelinks
  \hypersetup{hidelinks}
\else
  \oritoneSetSemanticLinks
\fi

% PDF metadata setters. The user supplies subject and keywords in the preamble.
\newcommand{\thesisSubject}[1]{\gdef\oritonethesis@subject{#1}}
\newcommand{\thesisKeywords}[1]{\gdef\oritonethesis@keywords{#1}}
\def\oritonethesis@subject{}
\def\oritonethesis@keywords{}

% Metadata is applied at begin-document so it sees title/author/subject/keywords
% after the user has set them.
\AtBeginDocument{%
  \hypersetup{
    pdftitle={\@title},
    pdfauthor={\@author},
    pdfsubject={\oritonethesis@subject},
    pdfkeywords={\oritonethesis@keywords}
  }%
}

% Thesis title-page state. Empty defaults keep the title page compilable even
% before all metadata is filled in.
\def\oritonethesis@universityName{}
\def\oritonethesis@universityLogo{}
\def\oritonethesis@universityLogoWidth{10cm}
\def\oritonethesis@studyProgram{}
\def\oritonethesis@desiredDegree{}
\def\oritonethesis@firstExaminerName{}
\def\oritonethesis@firstExaminerField{}
\def\oritonethesis@secondExaminerName{}
\def\oritonethesis@secondExaminerField{}
\def\oritonethesis@bibresource{}
\def\oritonethesis@bibstyle{apalike}

% User-facing title-page metadata setters.
\newcommand{\universityName}[1]{\gdef\oritonethesis@universityName{#1}}
\newcommand{\universityLogo}[1]{\gdef\oritonethesis@universityLogo{#1}}
\newcommand{\universityLogoWidth}[1]{\gdef\oritonethesis@universityLogoWidth{#1}}
\newcommand{\studyProgram}[1]{\gdef\oritonethesis@studyProgram{#1}}
\newcommand{\desiredDegree}[1]{\gdef\oritonethesis@desiredDegree{#1}}
\newcommand{\firstExaminer}[2]{%
  \gdef\oritonethesis@firstExaminerName{#1}%
  \gdef\oritonethesis@firstExaminerField{#2}%
}
\newcommand{\secondExaminer}[2]{%
  \gdef\oritonethesis@secondExaminerName{#1}%
  \gdef\oritonethesis@secondExaminerField{#2}%
}

% Front matter helper. It creates an unnumbered abstract chapter and updates
% both running marks to the localized abstract label.
\newcommand{\abstractChapter}{%
  \chapter*{\oritonethesis@abstractname}%
  \markboth{\oritonethesis@abstractname}{\oritonethesis@abstractname}%
}

% Small document utility macros used by the example and intended for ordinary
% thesis prose.
\newcommand{\todo}[1]{%
  \textcolor{danger}{\itshape #1}%
}
\newcommand{\linktt}[1]{\href{#1}{\texttt{#1}}}
\newcommand{\intd}[1]{\ensuremath{\,\mathrm{d}#1}}
\DeclareMathOperator*{\Assembly}{\scalerel*{\mathrm{A}}{\sum}}

% Bibliography helpers abstract over BibTeX and biblatex so the user-facing
% thesis source does not need separate branches.
\newcommand{\thesisBibliographyStyle}[1]{\gdef\oritonethesis@bibstyle{#1}}
\newcommand{\thesisBibliographyResource}[1]{%
  \gdef\oritonethesis@bibresource{#1}%
  \iforitonethesis@biblatex
    \addbibresource{#1.bib}%
  \fi
}
\newcommand{\printThesisBibliography}{%
  \iforitonethesis@biblatex
    \printbibliography
  \else
    \bibliographystyle{\oritonethesis@bibstyle}%
    \bibliography{\oritonethesis@bibresource}%
  \fi
}

% Localized declaration page placed after the bibliography/front matter. The
% vertical fill centers the declaration text within the page body.
\newcommand{\declarationOfAcademicIntegrity}{%
  \cleardoublepage
  \chapter*{\oritonethesis@declarationname}%
  \markboth{\oritonethesis@declarationname}{\oritonethesis@declarationname}%
  \vspace*{\fill}
  \noindent\oritonethesis@declarationtext\par
  \vspace{3mm}
  \noindent\oritonelabel{digital-identical}{\oritonethesis@language}\par
  \vspace{14mm}
  \noindent\oritonethesis@placeDateLabel\hspace{0.35\textwidth}\hfill\oritonethesis@signatureLabel
  \vspace*{\fill}
}

% Chapter and section heading styles. Numbered chapter headings split the
% chapter label and title into two display lines with an accent label.
\titleformat{name=\chapter,numberless}[display]{}{}{0cm}{\oritoneDisplayFont\color{headings}\bfseries\Huge#1}[]
\titleformat{name=\chapter}[display]{}{}{-0.5cm}{%
  {\oritoneDisplayFont\Huge\bfseries\textcolor{accent}{\MakeUppercase{\chaptername}\ \thechapter}}\\[-2mm]%
  \oritoneDisplayFont\color{headings}\LARGE#1%
}[]
\titlespacing{\chapter}{0cm}{0cm}{1cm}

\titleformat{name=\section,numberless}[display]{}{}{0cm}{\oritoneDisplayFont\large\color{headings}\bfseries#1}[]
\titleformat{name=\section}[display]{}{}{0cm}{\oritoneDisplayFont\large\color{headings}\textcolor{accent}{\thesection}\oritoneaccentseparator\bfseries#1}[]
\titlespacing{\section}{0cm}{0cm}{0.25cm}

\titleformat{name=\subsection,numberless}[display]{}{}{0cm}{\oritoneDisplayFont\color{headings}\bfseries#1}[]
\titleformat{name=\subsection}[display]{}{}{0cm}{\oritoneDisplayFont\color{headings}\textcolor{accent}{\thesubsection}\oritoneaccentseparator\bfseries#1}[]
\titlespacing{\subsection}{0cm}{0cm}{0.25cm}

\titleformat{name=\subsubsection,numberless}[display]{}{}{0cm}{\oritoneDisplayFont\color{headings}\itshape#1}[]
\titleformat{name=\subsubsection}[display]{}{}{0cm}{\oritoneDisplayFont\color{headings}\textbf{\textcolor{accent}{\thesubsubsection}}\oritoneaccentseparator\itshape#1}[]
\titlespacing{\subsubsection}{0cm}{0cm}{0cm}

% Two-sided running heads and page numbers. The plain page style is matched to
% the main thesis style so chapter-opening pages keep the same visual language.
\newcommand*\oritonethesis@headfootfont{\oritoneDisplayFont\small\color{headerandfooter}}
\fancypagestyle{oritonethesis}{%
  \fancyhf{}%
  \renewcommand{\headrulewidth}{0pt}%
  \renewcommand{\footrulewidth}{0pt}%
  \fancyhead[OR]{\oritonethesis@headfootfont\nouppercase\rightmark}%
  \fancyhead[EL]{\oritonethesis@headfootfont\nouppercase\leftmark}%
  \fancyhead[OL,ER,C]{}%
  \fancyfoot[OR,EL]{\oritonethesis@headfootfont\thepage}%
  \fancyfoot[ER,OL,C]{}%
}
\fancypagestyle{plain}{%
  \fancyhf{}%
  \renewcommand{\headrulewidth}{0pt}%
  \renewcommand{\footrulewidth}{0pt}%
  \fancyhead[OR]{\oritonethesis@headfootfont\nouppercase\rightmark}%
  \fancyhead[EL]{\oritonethesis@headfootfont\nouppercase\leftmark}%
  \fancyhead[OL,ER,C]{}%
  \fancyfoot[OR,EL]{\oritonethesis@headfootfont\thepage}%
  \fancyfoot[ER,OL,C]{}%
}
\pagestyle{oritonethesis}

% Captions use sans bold labels and the thesis line-spacing stretch.
\captionsetup{
  labelfont={sf,bf},
  font={stretch=1.3},
  format=hang,
  justification=justified
}

% Thesis listing style is currently the shared Oritone listing style. The alias
% gives future thesis-specific tuning one place to live.
\lstdefinestyle{oritone-thesis}{%
  style=oritone-listing,
}
\lstset{style=oritone-thesis}

% Cross-reference names for listings.
\renewcommand{\lstlistingname}{Listing}
\crefname{lstlisting}{listing}{listings}
\Crefname{lstlisting}{Listing}{Listings}

% Title page. The page temporarily uses symmetric margins so the title and
% university/logo block are centered on the physical page, then restores the
% normal thesis geometry before the main matter starts.
\renewcommand{\maketitle}{%
  \newgeometry{inner=1.5cm,outer=1.5cm,top=2cm,bottom=2cm}
  \begin{titlepage}%
    \thispagestyle{empty}
    \color{foreground}
    \begin{center}
      \ifx\oritonethesis@universityLogo\@empty
        {\oritoneDisplayFont\Large\oritonethesis@universityName\par}
      \else
        \includegraphics[width=\oritonethesis@universityLogoWidth,keepaspectratio]{\oritonethesis@universityLogo}\par
      \fi
      \vfill
      \oritoneRuledTitle{\@title}
      \vfill
      {\oritoneDisplayFont\large\oritonethesis@studyProgram}\\[3mm]
      {\oritoneDisplayFont\oritonethesis@degreeSentence}\\[2mm]
      {\oritoneDisplayFont\large\bfseries\oritonethesis@desiredDegree}\\[9mm]
      {\oritoneDisplayFont\large\oritonethesis@byLabel}\\[2mm]
      {\oritoneDisplayFont\bfseries\@author}\\[6mm]
      {\oritoneDisplayFont\large\oritonethesis@onLabel}\\[2mm]
      {\oritoneDisplayFont\@date}
      \vfill
      \oritoneDisplayFont
      \begin{tabular}{r l}
        \oritonethesis@firstExaminerLabel &
        \textit{\oritonethesis@firstExaminerName\quad\oritonethesis@firstExaminerField}\\
        \oritonethesis@secondExaminerLabel &
        \textit{\oritonethesis@secondExaminerName\quad\oritonethesis@secondExaminerField}
      \end{tabular}
    \end{center}
  \end{titlepage}
  \restoregeometry
  \cleardoublepage
}

\makeatother
\endinput
