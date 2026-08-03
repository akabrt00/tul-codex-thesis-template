# Začněte tady – i pokud jste dosud psali jen ve Wordu

Tento projekt je pracovní prostředí pro závěrečnou práci s AI asistentem. Nemusíte umět Git, GitHub, LaTeX ani příkazový řádek. Na začátku stačí vytvořit vlastní kopii projektu, otevřít ji v AI agentovi a odpovídat na jeho otázky.

## Co je oproti Wordu jiné

| Ve Wordu | V tomto projektu |
|---|---|
| Práce bývá hlavně jeden soubor `.docx`. | Práce je bezpečně rozdělená na text, zdroje, obrázky a nastavení. |
| Formátování často upravujete ručně. | Vzhled hlídá oficiální TUL šablona a LaTeX. |
| Změny ukládáte jako další kopie souboru. | Git uchovává historii a umožňuje návrat ke starší verzi. |
| Citace vkládáte ručně nebo přes doplněk. | Zdroje se evidují a seznam literatury se vytváří z jejich záznamů. |
| Dokument upravujete sami. | AI agent provádí technické změny, ale obsah a správnost stále řídíte vy. |

Soubor `prace/main.tex` je zdroj hlavní práce. Je podobný dokumentu ve Wordu, ale většinu času ho nemusíte ručně upravovat: řeknete agentovi, co potřebujete, a ke čtení nebo odevzdání si necháte vytvořit PDF.

## 1. Vytvořte si vlastní kopii

Nepracujte přímo v původním repozitáři šablony. Na GitHubu použijte **Use this template** a vytvořte nový repozitář pod svým účtem. Pro školní práci je bezpečná výchozí volba **Private**.

Příklad:

- původní šablona: `akabrt00/tul-codex-thesis-template`;
- vaše pracovní kopie: `vas-ucet/moje-bakalarska-prace`.

Vaše změny se pak ukládají pouze do vaší kopie. Původní šablonu tím nemůžete přepsat. Pokud tlačítko **Use this template** nevidíte, můžete použít **Fork** nebo stáhnout ZIP; vlastní repozitář je ale vhodnější kvůli záloze a historii.

## 2. Otevřete projekt v AI agentovi

Stáhněte svou kopii do počítače a otevřete celou složku jako projekt nebo workspace v Codexu či jiném AI agentovi. Neotvírejte jen jeden `.tex` soubor, protože agent potřebuje vidět i instrukce, zdroje a nastavení.

Do nového chatu pošlete:

> Přečti `AGENTS.md` a `START_HERE.md`. Použij `$setup-tul-project` a proveď mě prvním nastavením. S Gitem ani LaTeXem jsem zatím nepracoval, proto mi každý důležitý krok vysvětli jednoduše a nic o mých školních údajích neodhaduj.

Pokud agent nepodporuje pojmenované skills, pošlete:

> Přečti `AGENTS.md`, `PROJECT_CONTEXT.md` a `.agents/skills/setup-tul-project/SKILL.md`. Proveď mě prvním nastavením jako úplného začátečníka a nic o mých školních údajích neodhaduj.

## 3. Odpovězte na krátké otázky

Agent se postupně zeptá například na jméno, fakultu, druh práce, jazyk a známé údaje ze zadání. Můžete odpovídat běžně, například „Fakulta textilní“ a „bakalářská práce“; interní zkratky doplní agent.

Když údaj ještě neznáte, napište „nevím“ nebo „doplním později“. Agent jej nesmí vymyslet. Technicky nutnou prozatímní hodnotu smí použít jen po vašem potvrzení a musí ji označit k pozdější kontrole.

Lokální `PROJECT_PROFILE.json` obsahuje osobní údaje a Git ho ignoruje. Samotná práce může obsahovat vaše jméno, proto vás agent před jeho zapsáním do verzovaných souborů upozorní.

## 4. Rozdělte práci do zaměřených chatů

Po nastavení vám agent řekne, co vytvořil, co ještě chybí a kde vznikne výsledné PDF. Chat je samostatný pracovní rozhovor, nikoli kopie projektu: všechny chaty pracují nad stejnými soubory, ale každý si drží vlastní téma a historii.

Pokud máte hlavní práci a samostatný praktický nebo experimentální dokument, začněte dvěma chaty:

1. **MAIN – hlavní práce** – výsledný odborný text, do kterého se vybírají pouze důležité a ověřené informace.
2. **EXPERIMENTY – praktický deník** – úplné záznamy postupů, nastavení, chyb, dat, grafů, fotografií a průběžných poznámek.

Agent vám po onboardingu nabídne jejich vytvoření a připraví přesné úvodní zprávy. Chat smí založit pouze po vašem souhlasu. Pro hlavní chat lze použít například:

> Pracuj na hlavním dokumentu `main` uvedeném v `PROJECT_CONTEXT.md`. Nejdřív mi pomoz navrhnout strukturu práce podle zadání. Zatím nepiš hotové odborné závěry a nic necituj bez dohledatelného zdroje.

Pro experimentální chat:

> Pracuj pouze na praktickém dokumentu registrovaném v `PROJECT_CONTEXT.md`. Zaznamenávej úplný průběh experimentů včetně neúspěchů, nastavení, dat a odkazů na soubory. Nic automaticky nezkracuj pro hlavní práci.

Podle potřeby můžete později přidat chat **OTÁZKY A REŠERŠE**, kde se hledá, ověřuje a přemýšlí bez míchání rozpracovaných dotazů do hlavního textu, a samostatný chat **OBHAJOBA**. Na začátku ale není potřeba zakládat mnoho chatů.

## Běžné požadavky bez příkazového řádku

Agentovi můžete psát normálními větami:

- „Přidej tento PDF zdroj do projektu a připrav ho k citování.“
- „Pomoz mi rozdělit tuto kapitolu do logických podkapitol.“
- „Zapracuj připomínky vedoucího, ale nejdřív mi shrň navrhované změny.“
- „Zkontroluj citace a seznam literatury.“
- „Vytvoř aktuální PDF a zkontroluj, zda se správně zobrazuje.“
- „Tady je graf z MATLABu. Převeď ho na pěkný vektorový graf do práce a ověř, že se nezměnila data.“
- „Tady hrubě popisuji, jak zařízení funguje. Navrhni vhodný obrázek nebo schéma; když už je v mých podkladech, najdi ho a správně uprav pro práci.“
- „Dnes jsme zkoušeli vzorek B při rychlosti 20 metrů za minutu, ale tenzometr na začátku kmital. Zapiš to jako nový experiment a doptávej se jen na nezbytné údaje.“
- „Z experimentů EXP-0012 až EXP-0018 vyber ověřené výsledky vhodné do hlavní práce a zachovej odkazy na původní záznamy.“
- „Ulož ověřené změny do historie a vysvětli mi, co se uloží na GitHub.“

## Pět pojmů, které stačí znát

- **Repozitář** – projektová složka společně s historií změn.
- **GitHub** – internetové úložiště vaší kopie projektu; není to samotný textový editor.
- **Git** – historie změn, ke které se lze vracet.
- **LaTeX** – systém, který ze zdrojového textu vytvoří správně vysázené PDF.
- **AI agent** – technický spolupracovník, který může měnit soubory a spouštět kontroly; za obsah práce a odevzdaný výsledek odpovídá autor.
