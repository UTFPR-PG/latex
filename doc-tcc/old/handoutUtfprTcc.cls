%%%
%%% handoutUtfprTcc.cls
%%% a LaTeX2e version of abntex2.cls, by Gabriel B. Casella - gbc921@gmail.com
%%%

%% The purpouse is to simulate the documentation and handouts layout needed to the TCC course at UTFPR (Ponta Grossa)

%% The options to the class are:
%% "cocic", "coads", "cronograma", "relatorio" or nothing at all
%% "cocic" and "coads" format the header table with the respective title; cocic is default.
%% The difference between "cronograma" and "relatorio" is that relatorio has some extra fields like date, time, place and duration of the meeting. They can be set by \data{date}, \hora{time}, \local{place}, \duracao{duration time}.

%% The former two options share the same "body header". It includes professor(s) and student(s) name and paper title.
%% These options can be set, respectively, by \orientador{name}, \coorientador{name},\aluno{name},\alunoDois{name} and \tituloTCC{title}.
%% Besides, "cronograma" has an extra command \coordenadorTCC[]{} that is used on \imprimirassinatura to print the signature fields and extra text

%% Using no option at all means that "cocic" departament is default and just the main header will be printed.
%% 
%% E.g., one can use it as
%%      \documentclass[cocic,cronograma]{handoutUtfprTcc}
%%      OR
%%      \documentclass[coads,relatorio]{handoutUtfprTcc}
%%      OR
%%      \documentclass[coads]{handoutUtfprTcc}

%%      THEN inside document: \imprimircapa

%%		AND at the end: \imprimirassinatura

%% This is basically the abntex2 style, with some modifications
%% grafted around it.  You can use all the usual abntex2 options.
%%
%% TODO:
%% - The logos need to be at the same directory as the .TEX not the .CLS! Do something!!! (I tried, but no success)=
%% - Declare an \ifthenelse wrapper instead of \iftoggle in optional commands
%% - Use \theauthor to include names, so one can use \autor (from abntex2) with \and to include multiple authors. The problem is how to check if there is just one or two authors defined.


\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{handoutUtfprTcc}[2013/10/12 v1.0 Document class for TCC documentation and handouts to UTFPR]

% \newif was causing trouble. Also is good to know that http://tex.stackexchange.com/a/2951/20977
\RequirePackage{etoolbox}
\newtoggle{cocic}
\toggletrue{cocic}	% set COCIC as default if nothing is passed to class

\newtoggle{cronograma}
\togglefalse{cronograma}	% class default is nothing else other then header and \title

\newtoggle{relatorio}	% to define extra header about meeting report
\togglefalse{relatorio}

\DeclareOption{cocic}{%
	\toggletrue{cocic}
}
\DeclareOption{coads}{%
	\togglefalse{cocic}
}
\DeclareOption{cronograma}{% meeting schedule
	\toggletrue{cronograma}
	\togglefalse{relatorio}
}
\DeclareOption{relatorio}{% meeting report
	\toggletrue{relatorio}
	\togglefalse{cronograma}
}
\ProcessOptions\relax

\DeclareOption*{% redirect any other option to abntex2 class
	\PassOptionsToClass{\CurrentOption}{abntex2}
}
\PassOptionsToClass{12pt,a4paper,article,english,brazil}{abntex2}
\ProcessOptions\relax
\LoadClass{abntex2}

\RequirePackage[brazil]{babel}
\RequirePackage[utf8]{inputenc}

\PassOptionsToPackage{left=3.0cm,right=2.5cm,top=2.0cm,bottom=2.0cm}{geometry}
\RequirePackage{geometry}

\RequirePackage{graphicx}
\RequirePackage{array}	% for table column adjustment - http://goo.gl/MBCXJO
\newcolumntype{C}[1]{>{\centering\let\newline\\\arraybackslash\hspace{0pt}}m{#1}}

% Renew \title to make it optional
\renewcommand\title[1]{\renewcommand\title{#1}}

% Renew \orientador to use same name as abntex2
\renewcommand\orientador[1]{\renewcommand\@orientador{#1}}
\newcommand\@orientador[1]{\@latex@error{\noexpand\orientador nao especificado}\@ehc}

% Renew \coorientador to use same name as abntex2 and be optional
\newtoggle{coorientador}
\togglefalse{coorientador}
\renewcommand\coorientador[1]{\renewcommand\@coorientador{#1}\toggletrue{coorientador}}
\newcommand\@coorientador[1]{\togglefalse{coorientador}}

% Aluno1
\newcommand\aluno[1]{\renewcommand\@aluno{#1}}
\newcommand\@aluno{\@latex@error{\noexpand\aluno nao especificado}\@ehc}

% Aluno2
\newtoggle{students}
\newcommand\alunoDois[1]{\renewcommand\@alunoDois{#1}\toggletrue{students}}
\newcommand\@alunoDois{\togglefalse{students}} % alunoDois is optional

% Titulo TCC
\newcommand\tituloTCC[1]{\renewcommand\@tituloTCC{#1}}
\newcommand\@tituloTCC{\@latex@error{\noexpand\tituloTCC nao especificado}\@ehc}


% Fields for the small "relatorio" body header
% Data
\newtoggle{data}
\renewcommand\data[1]{\renewcommand\@data{#1}\toggletrue{data}}
\newcommand\@data{}

% Hora
\newtoggle{hora}
\newcommand\hora[1]{\renewcommand\@hora{#1}\toggletrue{hora}}
\newcommand\@hora{}

% Local
\newtoggle{local}
\renewcommand\local[1]{\renewcommand\@local{#1}\toggletrue{local}}
\newcommand\@local{}

% Duracao
\newtoggle{duracao}
\newcommand\duracao[1]{\renewcommand\@duracao{#1}\toggletrue{duracao}}
\newcommand\@duracao{}

% Professor Coordenador de TCC
\newcommand{\coordenadorTCC}[2][o]{\renewcommand\@coordenadorTCC{Prof$^{#1}$ #2}}
\newcommand{\@coordenadorTCC}{\@latex@error{\noexpand\coordenadorTCC nao especificado}\@ehc}


\renewcommand{\imprimircapa}{% header and "body header"
	% table header
	\begin{table}
		\centering
		\label{table:header}
%		\renewcommand{\arraystretch}{1.5} % increase space between text and lines
		\begin{tabular}{C{0.15\columnwidth} C{0.6\columnwidth} C{0.15\columnwidth}}
%			\hline
			\includegraphics[width=0.15\columnwidth]{./logoUtfpr.png}&
			
			\textbf{Universidade Tecnológica Federal do Paraná}\newline
			Campus Ponta Grossa\newline
			Departamento Acadêmico de Informática (DAINF)\newline
			Coordenação do Curso Superior de
			\iftoggle{cocic}{%
				Bacharelado em Ciência da Computação (COCIC)&
			}
			{% else
				Tecnologia em Análise e Desenvolvimento de Sistemas (COADS)&
			}
			
			\includegraphics[width=0.15\columnwidth]{./logoDainf.png}\\
%			\hline
		\end{tabular}
	\end{table}
	
	\begin{center}
		\iftoggle{cronograma}{%
			\textbf{\MakeUppercase{Cronograma} - Trabalho de Conclusão de Curso}\par
		}
		
		\iftoggle{relatorio}{%
			\textbf{\MakeUppercase{Relatório de acompanhamento} - Trabalho de Conclusão de Curso}\par
		}

		\textbf{\title}
	\end{center}
	
	\ifboolexpr { togl {cronograma} or togl {relatorio} }{
		\textbf{Professor Orientador:} \@orientador
		
		\iftoggle{coorientador}{%
			\textbf{Professor Coorientador:} \@coorientador\par
		}
		
		\iftoggle{students}{%
			\textbf{Alunos:} \@aluno, \@alunoDois\par
		}
		{ % else
			\textbf{Aluno:} \@aluno\par
		}
		
		\textbf{Título do Trabalho de Conclusão de Curso:} \@tituloTCC\par

		\iftoggle{relatorio}{%
			\begin{table}[!h]
				\centering
				\begin{tabular}{l l}
					\iftoggle{data}{%
						\textbf{Data:} \@data&
					}
					{% else
						\textbf{Data:} \underline{\hspace{1cm}}/\underline{\hspace{1cm}}/\underline{\hspace{1.2cm}}&
					}
					
					\iftoggle{hora}{%
						\textbf{Horário:} \@hora \\
					}
					{% else
						\textbf{Horário:} \underline{\hspace{1.2cm}}h \underline{\hspace{1.3cm}}min \\
					}
					& \\
					
					\iftoggle{local}{%
						\textbf{Local:} \@local&
					}
					{% else
						\textbf{Local:} \underline{\hspace{3.3cm}} &
					}
					\iftoggle{duracao}{%
						\textbf{Duração:} \@duracao
					}
					{% else
						\textbf{Duração:} \underline{\hspace{2.8cm}}
					}
				\end{tabular}
			\end{table}
			
			\textbf{Resumo dos assuntos abordados na reunião:}\par
		}
	}
	\par
}
\newcommand{\imprimirassinatura}{% signature fields and text
	\iftoggle{cronograma}{%
		\textbf{OBS:} Quaisquer alterações nestas datas previstas deverão ser definidas com antecedência e em comum acordo entre ambos os professor/aluno, ou caso necessite de mais orientações sejam elas em datas e horários diferentes, deverão ser registrados na tabela no verso deste documento.
		\par
		A cada reunião de orientação o aluno deverá apresentar relatórios sucintos sobre os assuntos tratados.

		\begin{center}
			\iftoggle{data}{%
				Ciente data: \@data
			}
			{% else = no data set
				Ciente data: \underline{\hspace{1cm}}/\underline{\hspace{1cm}}/\underline{\hspace{1cm}}
			}
		\end{center}
	
		\begin{center}
		\underline{\hspace{7cm}}
		\par
		\@coordenadorTCC
		\par
		Responsável pelo Trabalho de Conclusão de Curso COCIC/COADS
		\end{center}
	}
	{% else = relatorio
		\begin{center}
			\vspace{1cm}
			\par
			\underline{\hspace{8cm}}
			\par
			\@orientador
			
			\vspace{1cm}
			\par
			\iftoggle{students}{%
				\begin{tabular}{c c}
					\underline{\hspace{7cm}} & \underline{\hspace{7cm}}\\
					\@aluno	& \@alunoDois
				\end{tabular}
			}
			{% one student/author only
				\underline{\hspace{8cm}}\par
				\@aluno
			}
		\end{center}
	}
}
% End of handoutUtfprTcc.cls
