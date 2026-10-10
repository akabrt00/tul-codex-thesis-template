Poznámky k zprovozněné verzi šablony na overleaf (Jan Koprnický)

Historie
==========
08.12.2025
- úprava tul.sty a tulthesis.cls do verze 2.3

07.05.2025
- úprava tulthesis, definice prostředí abbrList, tabulka se vypisovala při použití příkazu \listoftables
- řešení v doplnění parametru entry:
\noindent\tblr[long,entry=none]{column{2}={co=1}}}


10.05.2024
- upraven refTULTHESIS.bib soubor, přidána položka 
Guidelines for Writing a Bachelor’s or Master’s Thesis
- implementace šablony tulthesis verze 2.1 - únor 2024
- upraveno číslování na stránce s chapter vpravo

29.11.2023
- Úprava tulthesis.cls, prostředí abbrList

\newenvironment{abbrList}{\ifthenelse{\equal{\TUL@nguage}{EN}}%
{\section*{List of abbreviations}\phantomsection\addcontentsline{toc}{section}{List of abbreviations}}%
{\section*{Seznam zkratek}\phantomsection\addcontentsline{toc}{section}{Seznam zkratek}}
\noindent\tabularx{\linewidth}{@{}lX@{}}}
{\endtabularx
\clearpage}
- Doplnění příkazu \phantomsection pro správné vytvoření hypertextového odkazu z obsahu

16.10.2023
- Úpravena kapitola Jak naložit s citacemi? 
- Do soubor refTULTHESIS.bib 
přidány publikace z roku 2022 a 2023
- Zatím neřešena aplikace normy ČSN ISO 690 (2022) jako BiblaTeXovský styl (výsledný přehled Použité literatury je v souladu s ČSN ISO 690 (2011))

22.05.2023
tul.sty - barva v tabulkách
řádek 46
\RequirePackage[table,xcdraw]{xcolor}

tulthesis.cls - řešení zarovnání čísla stránky s nadpisem vpravo
řádek 171
\if@twoside
   \fancyfoot[RO,LE]{{\thepage}}
   \fancypagestyle{plain}{% % <-- this is new
   \fancyhf{} 
   \fancyfoot[LE,RO]{\thepage} % same placement as with page style "fancy"
   \renewcommand{\headrulewidth}{0pt}}
\else
   \fancyfoot[R]{\thepage}
   \fancypagestyle{plain}{% % <-- this is new
   \fancyhf{} 
   \fancyfoot[R]{\thepage} % same placement as with page style "fancy"
   \renewcommand{\headrulewidth}{0pt}}    
\fi

12. 5. 2023
- úprava tisku seznamu literatury a zařazení nadpisu do obsahu (argument příkazu \printbibliography[title={Použitá literatura}, heading=bibintoc])
- příklad vložení nadpisu bez čísla a vložení do obsahu (Závěr)
