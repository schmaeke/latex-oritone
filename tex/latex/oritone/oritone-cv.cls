% SPDX-License-Identifier: MIT
\NeedsTeXFormat{LaTeX2e}[2020-10-01]
\ProvidesClass{oritone-cv}[2026/05/04 v0.1.0 Oritone curriculum vitae class]

% Compact CV class built on article. The class keeps the page sans-serif,
% removes paragraph indentation and extra paragraph skips, and provides a small
% set of semantic user commands for header data, sections, entries, and contact
% links.
%
% Source organization:
%   1. Class option parsing and article defaults.
%   2. Package loading and page-level typography.
%   3. Page footer and localized labels.
%   4. CV data setters and entry-rendering helpers.
%   5. User-facing CV commands.

\makeatletter

% Option state. Paper and size are tracked explicitly because article has no
% class-level defaults here until we pass them on.
\newif\iforitonecv@paper@set
\newif\iforitonecv@size@set
\def\oritonecv@mode{white}
\def\oritonecv@accent{auto}
\def\oritonecv@language{english}
\def\oritonecv@modekey{mode}
\def\oritonecv@accentkey{accent}
\def\oritonecv@languagekey{language}

% Language options all do the same thing, so declare them through one helper.
\newcommand*\oritonecv@DeclareLanguageOption[1]{%
  \DeclareOption{#1}{\def\oritonecv@language{#1}}%
}

% Handle key=value options such as mode=dark, accent=amber, or language=german.
% Unknown key=value options are passed to article to preserve normal class
% option behavior.
\def\oritonecv@handlekeyvalue#1=#2\@nil{%
  \def\oritonecv@key{#1}%
  \def\oritonecv@value{#2}%
  \ifx\oritonecv@key\oritonecv@modekey
    \def\oritonecv@mode{#2}%
  \else
    \ifx\oritonecv@key\oritonecv@accentkey
      \def\oritonecv@accent{#2}%
    \else
      \ifx\oritonecv@key\oritonecv@languagekey
        \def\oritonecv@language{#2}%
      \else
        \PassOptionsToClass{\CurrentOption}{article}%
      \fi
    \fi
  \fi
}

% Standard LaTeX option parsing does not understand arbitrary key=value class
% options. This hook separates those from plain article options.
\newcommand*\oritonecv@handleunknownoption{%
  \@expandtwoargs\in@{=}{\CurrentOption}%
  \ifin@
    \expandafter\oritonecv@handlekeyvalue\CurrentOption\@nil
  \else
    \PassOptionsToClass{\CurrentOption}{article}%
  \fi
}

% Oritone mode and accent options.
\DeclareOption{light}{\def\oritonecv@mode{light}}
\DeclareOption{dark}{\def\oritonecv@mode{dark}}
\DeclareOption{white}{\def\oritonecv@mode{white}}
\DeclareOption{black}{\def\oritonecv@mode{black}}

% Paper and size options are forwarded to article and remembered so we only
% install defaults if the user did not choose explicit values.
\DeclareOption{a4paper}{\oritonecv@paper@settrue\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption{a5paper}{\oritonecv@paper@settrue\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption{b5paper}{\oritonecv@paper@settrue\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption{letterpaper}{\oritonecv@paper@settrue\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption{legalpaper}{\oritonecv@paper@settrue\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption{executivepaper}{\oritonecv@paper@settrue\PassOptionsToClass{\CurrentOption}{article}}

\DeclareOption{10pt}{\oritonecv@size@settrue\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption{11pt}{\oritonecv@size@settrue\PassOptionsToClass{\CurrentOption}{article}}
\DeclareOption{12pt}{\oritonecv@size@settrue\PassOptionsToClass{\CurrentOption}{article}}

\oritonecv@DeclareLanguageOption{english}
\oritonecv@DeclareLanguageOption{american}
\oritonecv@DeclareLanguageOption{british}
\oritonecv@DeclareLanguageOption{ngerman}
\oritonecv@DeclareLanguageOption{german}
\oritonecv@DeclareLanguageOption{french}
\oritonecv@DeclareLanguageOption{spanish}
\oritonecv@DeclareLanguageOption{italian}
\oritonecv@DeclareLanguageOption{portuguese}
\oritonecv@DeclareLanguageOption{dutch}

\DeclareOption*{\oritonecv@handleunknownoption}
\ProcessOptions\relax

% Defaults for compact CV output.
\iforitonecv@paper@set\else
  \PassOptionsToClass{a4paper}{article}
\fi
\iforitonecv@size@set\else
  \PassOptionsToClass{10pt}{article}
\fi

\LoadClass{article}

% Core Oritone packages provide fonts, color roles, labels, and design lengths.
% The remaining dependencies support layout, icons, links, and the page footer.
\RequirePackage{oritone-fonts}
\RequirePackage[mode=\oritonecv@mode,accent=\oritonecv@accent]{oritone}
\RequirePackage{oritone-design}
\RequirePackage{geometry}
\RequirePackage{graphicx}
\RequirePackage{tabularx}
\RequirePackage{fancyhdr}
\RequirePackage{setspace}
\RequirePackage{microtype}
\RequirePackage{lastpage}
\RequirePackage{fontawesome5}
\RequirePackage[\oritonecv@language]{babel}
\RequirePackage{hyperref}

% Global page design. CVs use sans as the body font, tighter line spacing, no
% paragraph spacing, and ragged bottom pages to avoid stretched vertical gaps.
\oritoneUseSansAsDefault
\geometry{
  top=15mm,
  bottom=20mm,
  left=10mm,
  right=10mm
}
\setstretch{1.1}
\setlength{\parindent}{0pt}
\setlength{\parskip}{0pt}
\emergencystretch=3em
\raggedbottom

\oritoneApplyPageColors
\oritoneSetSemanticLinks
\hypersetup{pdftitle={Curriculum Vitae}}
\urlstyle{same}

% Wrapper around the shared label registry using the class-selected language.
\newcommand*\oritonecv@localized[1]{%
  \oritonelabel{#1}{\oritonecv@language}%
}

% Minimal footer with localized page count. CVs do not use running headers.
\fancypagestyle{oritonecv}{%
  \fancyhf{}%
  \renewcommand*\headrulewidth{0pt}%
  \renewcommand*\footrulewidth{0pt}%
  \fancyfoot[C]{%
    \small\color{text-muted}%
    \oritonecv@localized{page}\ \textbf{\thepage}%
    \ \oritonecv@localized{of}\ \textbf{\pageref*{LastPage}}%
  }%
}
\pagestyle{oritonecv}

% Internal rendering state. Sections are held as "pending" so the spacing above
% a section belongs to the first entry that follows it, avoiding stranded
% headings at the bottom of a page.
\newif\iforitonecv@section@pending
\newlength{\oritonecv@shortinfowidth}
\newlength{\oritonecv@sectionbeforeskip}
\newlength{\oritonecv@entryskip}
\setlength{\oritonecv@shortinfowidth}{0.85\textwidth}
\setlength{\oritonecv@sectionbeforeskip}{6mm}
\setlength{\oritonecv@entryskip}{2mm}

\def\oritonecv@name{}
\def\oritonecv@surname{}
\def\oritonecv@shortinfo{}
\def\oritonecv@phrase{}
\def\oritonecv@sectiontitle{}

% User-facing data setters. They store values for the later \cvhead render.
\newcommand*\name[1]{\gdef\oritonecv@name{#1}}
\newcommand*\surname[1]{\gdef\oritonecv@surname{#1}}
\newcommand*\shortinfo[1]{\gdef\oritonecv@shortinfo{#1}}
\newcommand*\phrase[1]{\gdef\oritonecv@phrase{#1}}
\newcommand*\shortinfowidth[1]{\setlength{\oritonecv@shortinfowidth}{#1}}
\newcommand*\sectionbeforeskip[1]{\setlength{\oritonecv@sectionbeforeskip}{#1}}

\DeclareRobustCommand{\highlighted}[1]{\textcolor{accent}{#1}}

% Link helpers. \oritonecv@href accepts either a full URL or a bare host name
% and normalizes bare hosts to https:// links.
\newcommand*\oritonecv@linktext[1]{\textcolor{linkcolor}{#1}}
\newcommand*\oritonecv@nowrap[1]{\mbox{#1}}
\newcommand*\oritonecv@balancedcenter{%
  \leftskip=0pt plus 0.5fil
  \rightskip=0pt plus -0.5fil
  \parfillskip=0pt plus 1fil
}
\newcommand*\oritonecv@href[2]{%
  \@expandtwoargs\in@{://}{#2}%
  \ifin@
    \href{#2}{#1}%
  \else
    \href{https://#2}{#1}%
  \fi
}

% Render the visible section heading and rule. The public \cvsection command
% schedules this; entry blocks decide exactly when it is flushed.
\newcommand*\oritonecv@sectionformat[1]{%
  \noindent{\oritoneDisplayFont\color{accent}\bfseries\large #1\par}%
  \vspace{-1.5mm}%
  \noindent\textcolor{accent!25}{\rule{\linewidth}{\oritonerulewidth}}\par
  \vspace{1mm}%
}

% If a section is pending, print it now and clear the flag.
\newcommand*\oritonecv@flushpendingsection{%
  \iforitonecv@section@pending
    \oritonecv@sectionformat{\oritonecv@sectiontitle}%
    \global\oritonecv@section@pendingfalse
  \fi
}

% Common wrapper for all CV entries. The minipage keeps each entry together and
% prevents a section title from separating from its first entry.
\long\def\oritonecv@entryblock#1{%
  \par
  \iforitonecv@section@pending
    \addvspace{\oritonecv@sectionbeforeskip}%
  \fi
  \noindent\begin{minipage}{\linewidth}
    \setlength{\parskip}{0pt}%
    \oritonecv@flushpendingsection
    #1%
  \end{minipage}\par
  \addvspace{\oritonecv@entryskip}%
}

% Header block containing the name, contact line, accent rule, and short phrase.
\newcommand{\cvhead}{%
  \begin{center}
    {\oritoneDisplayFont\fontsize{32pt}{32pt}\selectfont\bfseries
      \oritonecv@name\space\MakeUppercase{\oritonecv@surname}\par}%
    \vspace{3mm}%
    \begin{minipage}{\oritonecv@shortinfowidth}
      \oritonecv@balancedcenter
      \small\oritonecv@shortinfo\par
    \end{minipage}\par
    \vspace{1mm}%
    \textcolor{accent!25}{\rule{30mm}{\oritonerulewidth}}\par
    \vspace{1mm}%
    {\oritonecv@phrase\par}%
  \end{center}%
}

% Schedule a section heading. The heading is flushed by the next entry or at the
% end of the document if the user created an empty trailing section.
\newcommand{\cvsection}[1]{%
  \oritonecv@flushpendingsection
  \gdef\oritonecv@sectiontitle{#1}%
  \global\oritonecv@section@pendingtrue
}

% Entry variants. The custom form accepts explicit left title, right meta, and
% body; the other commands are convenience wrappers around that structure.
\long\def\cvcustomentry#1#2#3{%
  \oritonecv@entryblock{%
    \begin{tabularx}{\linewidth}{@{}>{\oritoneDisplayFont\bfseries}X@{\hspace{1em}}r@{}}%
      #1 & #2%
    \end{tabularx}%
    \par\nobreak\noindent
    #3\par
  }%
}
\long\def\cventry#1#2{\cvcustomentry{#1}{}{#2}}
\long\def\cvdatedentry#1#2#3{\cvcustomentry{#1}{\textbf{#2}}{#3}}
\long\def\cvdatedentryshort#1#2#3{%
  \oritonecv@entryblock{%
    \begin{tabularx}{\linewidth}{@{}X@{\hspace{1em}}>{\oritoneDisplayFont\bfseries}r@{}}%
      {\oritoneDisplayFont\bfseries #1}\enspace #3 & #2%
    \end{tabularx}%
  }%
}

% Inline helpers for contact rows and compact metadata. \sep is discretionary so
% long contact lines can break without leaving a bullet at the line start.
\newcommand*\sep{\discretionary{}{}{\enspace\textbullet\enspace}}
\newcommand{\icon}[1]{#1\enspace}
\newcommand{\weblink}[3]{\oritonecv@nowrap{\icon{#1}\oritonecv@href{\oritonecv@linktext{#2}}{#3}}}
\newcommand{\maillink}[1]{\oritonecv@nowrap{\icon{\faEnvelope}\href{mailto:#1}{\oritonecv@linktext{#1}}}}
\newcommand{\phonelink}[1]{\oritonecv@nowrap{\icon{\faPhone}\href{tel:#1}{\oritonecv@linktext{#1}}}}
\newcommand{\inlinelink}[2]{\textsuperscript{\normalfont\oritonecv@nowrap{[\oritonecv@href{\oritonecv@linktext{#1}}{#2}]}}}
\newcommand{\lastupdated}{\oritonecv@nowrap{\oritonecv@localized{updated}~\today}}

% Flush a final pending section instead of silently dropping it.
\AtEndDocument{\oritonecv@flushpendingsection}

\makeatother
\endinput
