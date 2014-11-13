%%%
%%% handout.cls (a LaTeX2e version of handout.sty, by Leo Guibas)
%%%

%% Style file for class handouts, to be invoked by:
%%      \documentclass{handout}
%% This is basically the latex 'article' style, with several modifications
%% grafted around it.  You can use all the usual article options.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{handout_utfpr}
[1997/9/30 v1.0
 Document class for course handouts]

\newif\if@scribe \@scribefalse          % scribe (notes) format switch
\newif\if@hmwk \@hmwkfalse              % hmwk (homework) format switch

\DeclareOption{hmwk}{\@hmwktrue}
\DeclareOption{scribe}{\@scribetrue}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\PassOptionsToClass{twoside,12pt}{article}

\ProcessOptions
\LoadClass{article}

\RequirePackage{epsfig}
\RequirePackage[utf8]{inputenc}

\setlength{\textheight}{8.5in}
\setlength{\topmargin}{0in}
\setlength{\textwidth}{6.25in}
\setlength{\oddsidemargin}{0.125in}
\setlength{\evensidemargin}{0.125in}

\def\floatpagefraction{.9}      % default .5
\def\topfraction{.9}            % default .7
\def\bottomfraction{.9}         % default .3
\def\textfraction{.1}           % default .2

% Scribe format variables:
%
\def\lecturer#1{\gdef\@lecturer{#1}\@scribetrue}
\def\scribe#1{\gdef\@scribe{#1}\@scribetrue}
\def\reviewer#1{\gdef\@reviewer{#1}\@scribetrue}
\def\lecturedate#1{\gdef\@lecturedate{#1}\@scribetrue}
\def\lecturenumber#1{\gdef\@lecturenumber{#1}\@scribetrue}

\def\@scribe{Who???}
\def\@lecturer{Who???}
%reviewer not required
\def\@lecturedate{When???}
\def\@lecturenumber{???}

% Homework format variables:
%
\def\hmwknumber#1{\gdef\@hmwknumber{#1}\@hmwktrue}
\def\duedate#1{\gdef\@duedate{#1}\@hmwktrue}
\def\topic#1{\title{#1}\@hmwktrue}

\def\@hmwknumber{Number???}
\def\@duedate{When???}
% Note: hmwk mode *does* require a \title (aka \topic)
% For now we leave \@title undefined.

% \maketitle bits used by both formats (usually defined in contents.tex):
\def\subjnum#1{\gdef\@subjnum{#1}}
\def\subject#1{\gdef\@subject{#1}}
\def\subjelab#1{\gdef\@subjelab{#1}}
\def\handout#1{\gdef\@handout{Handout \##1}}

\subjnum{CC31C}
\subject{Introdução à Ciência da Computação}
\subjelab{Introdução ao linux}
\def\@handout{\if@hmwk%
Homework \#\@hmwknumber\else%
Lecture \#\@lecturenumber\fi}

% We take over the \@date variable to be the date of the handout, i.e.
% when it is handed out.  Because there are so many dates floating
% around, we disable the \date command as too ambiguous:

\let\handoutdate=\date
\handoutdate{Handout Date ???} % do not use default (\today)
\def\date#1{\@warning{Ambiguous \noexpand\date{#1} command ignored}}

%%% ``titling'' list environment, may have some independent use

\def\mklableft#1{#1\hfil} % transpose of usual \@mklab
\newdimen\titlingitemwidth
\titlingitemwidth 18ex % wide enough for ``Handout #99'', etc

\def\titling{\list{}{%
\let\makelabel\mklableft
\labelwidth \titlingitemwidth
\leftmargin \titlingitemwidth
\labelsep 0pt
\parsep0pt
\itemsep0pt}}
\let\endtitling=\endlist

%%% New Title Macros (\@maketitle, \maketitle)

% Different format depending on [scribe] or [hmwk] version,
% makes a standard header for the course.

\def\@maketitle{% Put up the `class banner', with handout # and date:
\vfill\eject\vspace*{-2\headheight}\vspace*{-\headsep}
\vbox{\hbox to\textwidth{{\bf\@subjnum: \@subject}\hfil%\@handout
\ifdim\overfullrule>\z@{\rm\bf\ DRAFT}\fi\strut}
\hbox to\textwidth{{\bf\@subjelab}\hfil\strut}
\hbox to\textwidth{{\sf Universidade Tecnológica Federal do Paraná}\hfil\@date\strut}\hrule}
% Check that one of the formats is specified:
\if@hmwk
 \if@scribe
  \@warning{[scribe] format overriding [hmwk] format}
  \@hmwkfalse
 \fi
\else
 \if@scribe\else
  \@warning{Neither [scribe] nor [hmwk] format specified, no title}
 \fi
\fi
% scribe format: optional centered title, list lecture#, date, and scribe
\if@scribe
 \medskip
 \@ifundefined{@title}{}{\begin{center}
        \Large\bf\@title \end{center}}
 \titling
 \item[Lecture \#\@lecturenumber:]\@lecturedate
 \item[Lecturer:]\@lecturer
 \item[Scribe:]\@scribe
 \@ifundefined{@reviewer}{}{\item[Reviewer:]\@reviewer}
 \endtitling
\fi
% hmwk format: list homework #, topic, and duedate (aka title)
\if@hmwk
 \medskip
 \titling
 \item[Homework \#\@hmwknumber:]
  \@ifundefined{@title}{\bf What is the topic???}{\@title}
 \item[Due Date:]\@duedate
 \endtitling
\fi
% final skip before text
\bigskip
}

% \maketitle definition from article.dtx, modified to set
% \thispagestyle to empty rather than plain:

\def\maketitle{\par
  \begingroup
    \renewcommand\thefootnote{\@fnsymbol\c@footnote}%
    \def\@makefnmark{\rlap{\@textsuperscript{\normalfont\@thefnmark}}}%
    \long\def\@makefntext##1{\parindent 1em\noindent
            \hb@xt@1.8em{%
                \hss\@textsuperscript{\normalfont\@thefnmark}}##1}%
    \newpage
    \global\@topnum\z@   % Prevents figures from going at top of page.
    \@maketitle
    \thispagestyle{empty}\@thanks
  \endgroup
  \setcounter{footnote}{0}%
  \global\let\thanks\relax
  \global\let\maketitle\relax
  \global\let\@maketitle\relax
  \global\let\@thanks\@empty
  \global\let\@scribe\@empty
  \global\let\@date\@empty
  \global\let\@title\@empty
  \global\let\title\relax
  \global\let\author\relax
  \global\let\date\relax
  \global\let\and\relax

  %%% Page Numbering Style

  % Modify the default page numbering style on subsequent pages,
  % to have headers only, page number away from staple.  Must do
  % this in \maketitle, since \@handout is not defined until then.

  \pagestyle{myheadings}
%  \markboth{\@subjnum: \@handout}{\@subjnum: \@handout}

}

%%% Theorems

% Modify theorem environments (from latex.tex) to add a period
% after the theorem number:
\def\thmstyle{\it} % style of text in theorem environment
\def\@begintheorem#1#2{\it \trivlist \item[\hskip
        \labelsep{\bf #1\ #2.}]\thmstyle}
\def\@opargbegintheorem#1#2#3{\it \trivlist \item[\hskip
        \labelsep{\bf #1\ #2\ (#3).}]\thmstyle}

% Main theorem env, for ``Theorem 2.1'' format delete the next '%':
\newtheorem{theorem}{Theorem}%[section]
% all these use the same ``theorem'' counter
\newtheorem{lemma}[theorem]{Lemma}
\newtheorem{corollary}[theorem]{Corollary}
\newtheorem{claim}[theorem]{Claim}
\newtheorem{porism}[theorem]{Porism}
\newtheorem{definition}[theorem]{Definition}

% short-cuts theorem macros, with optional arguments; for example:
%  \lem[Zorn]{What is yellow and equivalent to the axiom of choice?}

\def\makeshortcutthm#1#2{%
 \@namedef{#1}{\@ifnextchar[{\@nameuse{scto@#1}}{\@nameuse{sct@#1}}}
 \@namedef{sct@#1}##1{\begin{#2}##1\end{#2}}
 \@namedef{scto@#1}[##1]##2{\begin{#2}[##1]##2\end{#2}}}
\makeshortcutthm{thm}{theorem}
\makeshortcutthm{cor}{corollary}
\makeshortcutthm{clm}{claim}
\makeshortcutthm{lem}{lemma}
\makeshortcutthm{por}{porism}
\makeshortcutthm{Def}{definition}

%% Proof macros, e.g.: \Pf Because I say so.\qed
\newcommand{\Pf}{\par\noindent{\bf Proof:\quad}} % or \textindent

% \qed is the usual version
% \noqed is for use inside theorems (where we don't prove anything)
% \eqqed is for when the proof ends with an equation

\newcommand{\noqed}{~\hspace{1em}\rule{0.5em}{1.5ex}}
\newcommand{\qed}{\noqed\par\bigskip} % good ifmmode version?
\newcommand{\eqqed}{\mbox{\noqed}}

\newenvironment{proof}{\Pf}{\qed}

%%% Problems and Solutions

% problems and subproblems (like sections), for example:
%  \problem{[10 points]} blah blah blah
%  \subproblem{} blah blah
%  \solution blah blah
\newcounter{problem}
\newcounter{subproblem}[problem]
% Note: this is really an incorrect use of \the... macros,
% how else to get this effect?
\def\theproblem{Problem \arabic{problem}.}
\def\thesubproblem{\arabic{problem}(\alph{subproblem}).}
\def\problem{\@startsection{problem}{2}{\z@}{-2.5ex plus -.7ex minus
    -.2ex}{1.5 ex plus .2ex}{\normalsize\bf}}
\def\problemmark#1{}
\def\subproblem{\@startsection {subproblem}{3}{\parindent}{-2ex plus
    -.5ex minus -.2ex}{-1em}{\normalsize\bf}}
\def\subproblemmark#1{}

%% To start solutions (rather like \Pf):
\newcommand{\solution}{\medskip\noindent{\bf Solution:}\quad}

%%% Random useful Mathy Macros

% Size-sensitive bracketing commands:
\newcommand{\set}[1]{\ensuremath{\left\{{#1}\right\}}}
\newcommand{\bracket}[1]{\ensuremath{\left [{#1}\right]}}
\newcommand{\brocket}[1]{\ensuremath{\left\langle{#1}\right\rangle}}
\newcommand{\norm}[1]{\left\|{#1}\right\|}
\newcommand{\ceil}[1]{\ensuremath{\left\lceil {#1}\right\rceil}}
\newcommand{\floor}[1]{\ensuremath{\left\lfloor {#1}\right\rfloor}}
\newcommand{\paren}[1]{\ensuremath{\left({#1}\right)}}
% (don't forget \brack, \choose, \brace)


%%% Figures

% Modify 'caption' command to by default take a null [optional]
% argument.  This avoids problems where a very long caption would
% be sent to the aux file (on the other hand, it will change
% the expected list-of-figures behavior, i.e. many figures will
% not have any caption in the list.

%\def\caption{\refstepcounter\@captype \@dblarg{\@caption\@captype}}
\def\caption{\refstepcounter\@captype
        \@ifnextchar[{\@caption\@captype}{\@caption\@captype[]}}

%% Modify figure numbering to be ``problem.figure'':
% This does not work (figure counter does not reset), why?
%\@addtoreset{figure}{problem}
%\def\thefigure{\arabic{problem}.\arabic{figure}}

% Centered PostScript figure
\def\cpsfig#1{\centerline{\mbox{\epsfig{#1}}}}
% Even more telegraphic (assumes standardized naming of ps figure
% files, no need to fool with width/height etc):
\def\cpsjob#1#2{\begin{figure}\cpsfig{figure=\jobname-#1.ps}
 \caption[]{\label{fig:#1}#2}\end{figure}}


%%% Miscellany

% Use [draft] option to reveal these inline comments; they
% will not show up in the output otherwise.
\long\def\comment#1{\ifdim\overfullrule>\z@{\sf[{#1}]}\fi}

% End of handout.sty

