# TULthesis — přehlednější projekt, prototyp 0.8

**Rychlý start: START.md. Kontrola vlastní práce: KONTROLA.md.** Verze 0.8 doplňuje popsané údaje, vyhledatelné komentáře TODO a volitelný místní kontrolní skript. Výchozí sazba a ukázkový PDF obsah zůstávají zachované.

Plný balíček obsahuje značky všech fakult. PDF v `sablona/loga/` jsou rozdělená do složek `TUL/`, `FM/`, `FS/`, `FT/`, `FP/`, `EF/`, `FUA/`, `FZS/` a `CXI/`; společné vyhledávání nastavuje `nastaveni/cesty-loga.tex`. Jde o organizační úpravu pilotu 0.8, názvy a obsah PDF zůstávají stejné.

Toto je **komunitní návrh uspořádání**, nikoli nové oficiální vydání TULthesis. Začněte otevřením `main.tex`; vlastní text píšete přímo v `main.tex`.

## První spuštění v Overleafu

1. Nahrajte ZIP projektu přes New project → Upload project.
2. Nastavte hlavní dokument na `main.tex` a kompilátor na **XeLaTeX**.
3. Spusťte Recompile. Pro odkazy a citace může být potřeba další běh; bibliografii zpracovává Biber.
4. V `main.tex` nastavte fakultu a typ práce (výchozí ukázka: `FM,BP`). Vyplňte `nastaveni/udaje.tex`.
5. Nahraďte texty kapitol, abstraktů a poděkování přímo v `main.tex`. Ukázková osnova ani prohlášení nejsou závazné fakultní pokyny.

## Překladač a další ověření rychlosti

Projekt používá **XeLaTeX, Polyglossii a Biber**. Výstupem je PDF; to neznamená použití překladače pdfLaTeX. Experiment 0.3 s jiným překladačem je odložený a není doporučeným nastavením.

Další krok je změřit první úplné sestavení včetně Biberu a běžný opakovaný překlad. Teprve podle výsledků budeme navrhovat úpravy konkrétních balíčků nebo obrázků. Vhodnost pro free účet Overleaf zatím není potvrzená.

Před změnou překladače, fontů, stylu citací nebo sazby návrh nejprve projdeme s Adamem. Samotné uspořádání podkladů a celý text v main.tex zůstávají zachované.

## Co kam patří

Ukázkový obrázek `obrazky/ukazka-mereni.png` pochází ze syntetického cvičení portálu „Moje první PDF“ a je pod CC0 1.0. Není výsledkem vaší práce. Obrázek i tabulka mají označený blok pro odstranění; při mazání odstraňte i větu s odkazem. Graf je statický, změna tabulky jej nepřepočítá. Při vlastní práci nahraďte také ukázkový bibliografický záznam ověřeným zdrojem.

V main.tex vás vedou výrazné komentářové oddělovače: **PREAMBULE → ÚVODNÍ ČÁSTI → TEXT PRÁCE → POUŽITÁ LITERATURA → PŘÍLOHY → KONEC DOKUMENTU**. Řádky začínající znakem `%` jsou poznámky pro práci v editoru; do PDF se nevysází. Ukázková tabulka má označený začátek i konec bloku pro snadné odstranění. Vlastní text nahrazuje ukázkové věty; pokyny v komentářích vám říkají, které příkazy zachovat.

| Místo | Účel |
| --- | --- |
| `main.tex` | Celý text práce, abstrakty, poděkování, kapitoly a textové přílohy |
| `nastaveni/` | Údaje o práci, jazyk, balíčky a citace |
| `literatura/zdroje.bib` | Vlastní bibliografické záznamy |
| `obrazky/` | Vlastní obrázky a grafy |
| `prilohy/` | Samostatné PDF a jiné doprovodné soubory; text příloh zůstává v main.tex |
| `sablona/` | Technické podklady, loga a fonty; běžně se neupravují |
| `dokumentace/original/` | Původní manuály, poznámky, licence a ukázková bibliografie |
| `tulthesis.cls`, `tul.sty` v kořeni | Dva malé zavaděče podkladů ve složce sablona |

Hlavní dokument zůstává v kořeni projektu. Text není rozdělený do dalších souborů; složky slouží pro nastavení a podklady.

Původní manuály ve složce dokumentace slouží jako zdroj informací; jejich zdrojové kódy nejsou hlavním dokumentem tohoto projektu. Pro jejich původní sestavení použijte původní balíček. Soubory nejsou přepsané tak, aby předstíraly autorství nového návrhu.

## Psát v jednom souboru, orientovat se přes PDF

Mějte vedle sebe editor a náhled PDF. Po sestavení dvojklikem na běžný text v PDF přejdete na odpovídající místo zdrojového kódu. Šipky mezi panely umožňují přechod oběma směry. Náhled musí používat prohlížeč **Overleaf**, nikoli **Browser**. Pokud jste text právě změnili, nejprve znovu sestavte PDF.

Pište zdroj po kratších řádcích, například jednu větu na řádek. Jedno zalomení řádku ve zdroji samo nevytváří nový odstavec; nový odstavec odděluje prázdný řádek. Kratší řádky pomáhají přesnosti přechodu mezi PDF a kódem, který pracuje na úrovni řádků. Nadpisy vytvářejte běžnými příkazy chapter, section a subsection.

Propojení přes SyncTeX může fungovat i u projektu rozděleného do více souborů. Jeden hlavní soubor zde volíme kvůli jednoduchosti psaní. Seznam literatury se generuje přes pomocný soubor, takže skok z citace nebo bibliografie nemusí vést přímo na záznam v .bib.

[Oficiální návod Overleafu: přechod mezi editorem a PDF](https://docs.overleaf.com/navigating-in-the-editor/working-with-the-pdf-viewer/moving-between-the-editor-and-pdf)

## Původ a změny

- Autor třídy TULthesis a balíčku TUL: **Pavel Satrapa**.
- Výchozí místní ZIP obsahuje také komentáře, nastavení BibLaTeXu a další úpravy **Jana Koprnického**; nejde o čistě původní Satrapův balíček. Původní záznamy zachovávají `00README.txt` a `00README-JK.txt`.
- Organizace, zavaděče a nový stručný startovací dokument: **Adam Kábrt s využitím Codexu**, říjen 2026. Podněty: adam.kabrt@tul.cz.
- Třída je zachována beze změn. V `sablona/tul.sty` se mění pouze načtení souboru TULMono-Bold.ttf na cestu do `sablona/fonty/`. Vyhledávání log řeší zavaděč pomocí graphicspath.
- Původní README uvádí licenci **CC BY** bez čísla verze. Toto uspořádání zachovává připsání autorství i licenční text; žádnou konkrétní verzi licence nedoplňuje.

Fonty Inter a Noto Sans Mono nejsou v původním ZIPu přibaleny; volby `fonts` a `localfonts` proto nejsou v ukázce zapnuté. Přesunutí souborů tuto původní závislost samo neřeší.

Před odevzdáním ověřte aktuální požadavky fakulty, styl citací a úvodní listy z IS/STAG. Zde generované listy pouze demonstrují sestavení. Tento prototyp nebyl zatím ručně vyzkoušen v účtu Overleaf.
