# Průběžná evidence použití AI

Pracovní pomůcka podle [AI na TUL](AI_NA_TUL.md). Tento prázdný template
nepotvrzuje, že autor AI nepoužil. Zapisujte skutečné podstatné použití v konkrétní
práci; běžné pravopisné a typografické opravy evidujte jen při odlišném předem
stanoveném požadavku vyučujícího. Nezapisujte chráněné prompty, osobní údaje,
tajné vstupy ani celé výstupy.

| Datum | Dokument a konkrétní část / soubor | Nástroj a dostupná verze | Způsob použití a vliv na výstup | Kontrola agentem / důkaz | Samostatné ověření autorem |
|---|---|---|---|---|---|

Verzi zapisujte jen podle dostupných údajů; jinak uveďte „verze nezjištěna“.
Kontrolu autorem ponechte jako „čeká na autora“, dokud ji autor nepotvrdí.
Datum zapisujte jako `YYYY-MM-DD`. Druhou buňku začínejte registrovaným klíčem
dokumentu, například `main: prace/main.tex, kapitola 2`; pro další výstup použijte
jeho vlastní klíč z `PROJECT_CONTEXT.md`. Znak svislé čáry uvnitř buňky nahraďte
`&#124;`, aby se tabulka nerozbila. Pro totožný zásah ve více dokumentech vytvořte
samostatný řádek pro každý dokument. Prázdná tabulka neprokazuje nepoužití AI.
Při použití generovaných dat doplňte odkaz na jejich původ, označení a zdůvodnění
v metodice. U autonomního úkolu zachovejte dohledatelné kroky a mezivýsledky.

## Deklarace v odevzdávaném dokumentu

- Dokument a umístění deklarace: `[doplnit před odevzdáním]`
- Pokyn vyučujícího / vydavatele k formě deklarace: `[zatím nepotvrzen]`
- Porovnání deklarace se skutečnou evidencí: `[čeká na kontrolu]`
- Samostatná kontrola a porozumění autorem: `[čeká na autora]`

Agent před odevzdáním připraví text podle skutečných záznamů a ověří jeho
přítomnost ve výsledném dokumentu. Tato tabulka nepředepisuje umístění deklarace
a nesmí měnit oficiální prohlášení či úvodní PDF z IS STAG.

## Kontrola evidence

Agent může spustit `scripts/check-ai-evidence.ps1 -DocumentKey main`.
Kontrola označí chybějící či neúplné záznamy a vrací pracovní výsledek `WARN`;
nevytváří potvrzení autora ani institucionálního souladu.

Před odevzdáním použije `-Submission -DeclarationPath prace/ai-declaration.txt
-PdfPath prace/main.pdf`. Soubor deklarace je prostý text UTF-8 přesně podle
textu vloženého do dokumentu, nikoli LaTeX s příkazy. Pokud existuje podstatné
použití, chybějící deklarace nebo její nepřítomnost v PDF je `FAIL`. Dostupný
`pdftotext` porovná úplný text po sjednocení mezer; případný rozdíl způsobený
dělením slov vyžaduje ruční kontrolu. Nalezení textu neověřuje pravdivost,
úplnost, předepsané umístění ani souhlas autora. Bez záznamů nebo dostupného
extraktoru zůstává ruční kontrola nutná. Soubor neobsahuje prompty ani vstupní data.
