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

## 4. Pokračujte v novém chatu

Po nastavení vám agent řekne, co vytvořil, co ještě chybí a kde vznikne výsledné PDF. Potom založte nový chat ve stejné složce a napište například:

> Pracuj na hlavním dokumentu `main` uvedeném v `PROJECT_CONTEXT.md`. Nejdřív mi pomoz navrhnout strukturu práce podle zadání. Zatím nepiš hotové odborné závěry a nic necituj bez dohledatelného zdroje.

## Běžné požadavky bez příkazového řádku

Agentovi můžete psát normálními větami:

- „Tady je nový odborný podklad. Co z něj můžeme použít v práci?“
- „Co moje podklady říkají o opotřebení textilních materiálů?“
- „Pomoz mi rozdělit tuto kapitolu do logických podkapitol.“
- „Zapracuj připomínky vedoucího, ale nejdřív mi shrň navrhované změny.“
- „Zkontroluj citace a seznam literatury.“
- „Vytvoř aktuální PDF a zkontroluj, zda se správně zobrazuje.“
- „Ulož ověřené změny do historie a vysvětli mi, co se uloží na GitHub.“

U zdrojů nemusíte žádat o registraci, extrakci ani indexování a nemusíte znát název žádného skillu. Když v aktivním chatu přiložíte soubor nebo se zeptáte na odbornou informaci, agent tento postup spustí automaticky, ověří konkrétní stránku a buď připraví správnou citaci, nebo řekne, jaký podklad chybí. Projekt neběží bez agenta na pozadí; soubor vložený do `zdroje/00_prichozi/` se proto zpracuje při vaší nejbližší zprávě.

## Pět pojmů, které stačí znát

- **Repozitář** – projektová složka společně s historií změn.
- **GitHub** – internetové úložiště vaší kopie projektu; není to samotný textový editor.
- **Git** – historie změn, ke které se lze vracet.
- **LaTeX** – systém, který ze zdrojového textu vytvoří správně vysázené PDF.
- **AI agent** – technický spolupracovník, který může měnit soubory a spouštět kontroly; za obsah práce a odevzdaný výsledek odpovídá autor.
