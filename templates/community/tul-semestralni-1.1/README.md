# Šablona malých semestrálních prací TUL

Verze 1.1: sjednocená velikost písmen fakultních logotypů a pevná výška
bloku loga na titulní straně. FP a FM mají čitelné víceřádkové záhlaví.
Loga zůstávají vektorová PDF; šablona nepotřebuje načítat font TUL Mono.

Otevři `semestralni-prace.tex`. Na začátku změň `\Fakulta{FS}` a údaje
o předmětu, práci, autorovi, datu, roku, verzi zadání a softwaru.
Pak nahraď ukázkový text vlastním obsahem. Obsah není povinný; pokud ho chceš,
vlož `\tableofcontents\newpage` za `\TitulniStrana`.

Fakulty: FS – strojní, FT – textilní, FP – přírodovědně-humanitní a pedagogická,
EF – ekonomická, FUA – umění a architektury, FM – mechatroniky, informatiky
a mezioborových studií, FZS – zdravotnických studií.

Překlad: pdfLaTeX dvakrát (kvůli celkovému počtu stran):

```text
pdflatex semestralni-prace.tex
bibtex semestralni-prace
pdflatex semestralni-prace.tex
pdflatex semestralni-prace.tex
```

Pro Overleaf nahraj celý projekt a vyber pdfLaTeX. Složka `podklady` musí
zůstat součástí projektu. Titulní strana je bez záhlaví a číslování, další
strany mají fakultní logotyp vlevo, symbol vpravo a kontaktní zápatí.
Číslování 1 / N zahrnuje pouze obsahové stránky. Rok se standardně bere
z data překladu; lze jej nastavit ručně, stejně jako datum práce.

## Kam přidat bibliografii

Soubor `literatura.bib` je v kořeni projektu, hned vedle
`semestralni-prace.tex`. Otevři jej a nahraď smyšlený ukázkový záznam svými
zdroji ve formátu BibTeX. Další záznamy přidávej do stejného souboru.
Export ze Zotera nebo jiného správce vyber jako **BibTeX**. Obsah exportovaného
`.bib` vlož do `literatura.bib`, případně jej nahraj do kořene Overleaf projektu
pod názvem `literatura.bib` a nahraď původní soubor.

V textu odkazuj na klíč záznamu: `\cite{ukazka}`. Záznam s klíčem
`novak2025` použiješ jako `\cite{novak2025}`. Na konci práce se automaticky
vypíší pouze citované zdroje, číslované podle prvního použití.
Overleaf překlad bibliografie obstará při Recompile; lokálně použij výše
uvedené čtyři příkazy. Zvolené jednoduché číselné citace nejsou tvrzením
souladu s ČSN ISO 690. Pokud zdroje nepotřebuješ, odstraň ukázkovou citaci
a dva příkazy `\bibliographystyle` a `\bibliography` na konci dokumentu.

Grafické podklady a fakultní barvy: veřejný balík **tul 2.3**, Pavel Satrapa,
https://www.nti.tul.cz/~satrapa/vyuka/latex-tul/ (licence CC BY dle balíku).
Původní soubory a dokumentace jsou zachovány ve složce `podklady`.
Loga TUL: https://www.tul.cz/univerzita/media/logo/.
Adresy a barvy přebírá tato šablona z balíku verze 2.3 (2025).

Jde o vlastní šablonu podle dodaných vizuálních ukázek, nikoli o potvrzení
formálních požadavků konkrétního předmětu. FT má původní barvu loga z balíku;
světlejší odstín na snímku nebyl použit k přebarvení loga.
