# Začněte zde — komunitní projekt 0.8

Pro první vlastní odstavec potřebujete upravovat jen **main.tex**. Osobní a školní údaje vyplníte v **nastaveni/udaje.tex**. Složku **sablona/** ponechte beze změn.

## 1. Nejdřív sestavte nezměněnou ukázku

Nahrajte celý ZIP do Overleafu. Zvolte Main document **main.tex** a Compiler **XeLaTeX**. Spusťte Recompile. Ukázka obsahuje text, tabulku, syntetický graf a bibliografii; nejsou to vaše výsledky. Při otaznících v citacích nebo odkazech sestavte znovu. Projekt používá BibLaTeX/Biber.

## 2. Vyplňte nastavení

| Co | Kde | Co upravit |
|---|---|---|
| Fakulta a typ práce | začátek main.tex | volby v `\documentclass[FM,BP]{tulthesis}`; podle zadání a původního manuálu |
| Název, autor, program, obor, vedoucí, rok | nastaveni/udaje.tex | obsah závorek; počet argumentů ponechat |
| Úvodní listy / prohlášení | main.tex, `\ThesisStart` | postup podle fakulty; ukázkový rod nebo cesta k požadovanému PDF |
| Balíčky a bibliografie | nastaveni/balicky.tex | pro první psaní nemusíte měnit |

`FM,BP`, rok a všechna jména jsou příklady. Údaje neopisujte z tohoto balíčku. Před nahrazením úvodních listů ověřte, které strany má dodat IS/STAG a které generuje šablona.

## 3. Napište první vlastní odstavec

V main.tex vyhledejte `\chapter{Úvod}`. Nahraďte dvě ukázkové věty svým textem a znovu sestavte. Názvy a počet kapitol přizpůsobte práci. Celý text, abstrakty a textové přílohy zůstávají v main.tex.

- Jedna věta na řádek pomůže orientaci v editoru. Odstavec odděluje prázdný řádek.
- Text `% TODO:` je poznámka, do PDF se nevysází. Po vyřízení ji smažte; vyhledání `TODO` ukáže zbývající ruční kontroly.
- Neodstraňujte `\begin{document}` / `\end{document}` ani párové příkazy kolem obrázků a tabulek.
- Před větší úpravou si stáhněte ZIP jako zálohu. Úspěšné sestavení nepotvrzuje správnost obsahu.

## 4. Nahraďte ukázky postupně

Obrázky ukládejte do obrazky/, zdroje do literatura/zdroje.bib. Ukázkové bloky tabulky a grafu mají v main.tex označený začátek a konec. Při jejich odstranění smažte také související věty a odkazy. Graf je statický PNG; změna tabulky jej nepřepočítá.

Před odevzdáním otevřete **KONTROLA.md**. Úplné vysvětlení původu a technických omezení je v README.md. Kontrola prostřednictvím PowerShellu je volitelná pro místní kopii; v Overleafu žádný skript spouštět nemusíte.
