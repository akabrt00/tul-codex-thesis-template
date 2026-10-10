# Začněte tím, co chcete vytvořit

S tímto projektem pracujete hlavně přes chat s Codexem. Popíšete svůj záměr,
přidáte dostupné podklady a Codex připraví návrh, upraví projektové soubory a
provede potřebné technické kontroly. Nemusíte znát příkazy ani ručně psát LaTeX.
Obsah práce řídíte vy.

## Než dáte podklady AI

Přečtěte si [pravidla AI na TUL](AI_NA_TUL.md) podle dodané směrnice 7/2026.
AI smí pomáhat i autonomně, ale podstatné použití přiznáte a výsledek samostatně
ověříte a obhájíte. Codex průběžně vede [evidenci použití](POUZITI_AI.md).
Nepublikovaná vědecká data, chráněný kód, citlivé údaje, neveřejné dokumenty TUL
a osobní údaje třetích osob nevkládejte do AI bez doloženého schválení systému
univerzitou. Souhlas s nahráním ani soukromý GitHub toto schválení nenahrazují.
Dodané PDF schválení Codexu nedokládá.

## 1. Otevřete vlastní kopii projektu

Na GitHubu můžete použít **Use this template** a vytvořit vlastní soukromý
repozitář, tedy projekt s historií změn. Pokud zatím nechcete řešit GitHub,
stáhněte ZIP a rozbalte jej do vlastní místní složky. Otevřete celou složku
v Codexu jako projekt, aby viděl také pravidla a podklady.

Pracujte ve vlastní kopii; změny pak nezasáhnou původní šablonu. O zálohování se
s Codexem domluvíte během nastavení. Můžete zvolit soukromý Git, univerzitní
Google Drive nebo jiné podporované úložiště, jejich kombinaci, nebo zatím jen
místní práci. Nerozhodnuté úložiště nebrání prvnímu návrhu. Podrobnosti jsou
v [návodu k ukládání a sdílení](README.md#zálohování-github-a-online-úložiště).

## 2. Napište, co potřebujete a co už máte

Například:

> Chci začít bakalářskou práci. Tady je moje zadání. Pomoz mi z něj připravit strukturu práce a první pracovní dokument. Proveď mě tím, technické věci zatím neznám.

Můžete také napsat:

- „Mám zatím jen nápad na téma. Pomoz mi ujasnit, co by práce měla řešit.“
- „Mám rozepsanou práci. Nejdřív se podívej, co už mám, a pomoz mi s další kapitolou.“
- „Chci zatím jen nastavit projekt, obsah doplním později.“

Codex nejdřív využije informace, které dostal. Zeptá se na to, co potřebuje pro
nejbližší krok; nemusíte znovu přepisovat celé zadání do odpovědí. Neznámý údaj
můžete označit „nevím“ nebo „doplním později“.

Pokud agent pravidla projektu sám nenačte, napište:

> Přečti `AGENTS.md`, `PROJECT_CONTEXT.md` a `.agents/skills/setup-tul-project/SKILL.md`. Proveď mě od mého zadání k prvnímu užitečnému výsledku.

## 3. Prohlédněte si první výsledek

Ze zadání může vzniknout přehled požadavků a návrh kapitol s vysvětlením jejich
účelu. Z nápadu pracovní vymezení tématu a nejbližší krok. Codex odliší, co plyne
z podkladů a co sám navrhuje; nevymýšlí odborné výsledky ani oficiální údaje.
První návrh vám může ukázat přímo v chatu ještě před nastavením dokumentu.

Před vytvořením formální práce si postupně potvrdí jméno, fakultu, druh práce,
jazyk, rok a mužskou nebo ženskou variantu pracovní titulní strany a prohlášení.
Ostatní neznámé údaje nechá k doplnění. Bez povinných údajů dokument zatím
nevytvoří, ale může pomoci s návrhem obsahu.

Když jsou údaje a potřebné programy připravené, vytvoří pracovní dokument,
zapracuje dohodnutý počáteční obsah a sestaví a zkontroluje PDF. Ukáže vám
skutečný výstup a řekne, co ještě chybí. Pokud PDF zatím vytvořit nelze,
vysvětlí překážku; programy ani balíky automaticky neinstaluje.

Osobní profil zůstává v souboru ignorovaném Gitem. Jméno může být také v samotné
práci; před jeho vložením do veřejného projektu je nutný váš souhlas.
Pracovní titulní strany později nahradíte oficiálním PDF z IS STAG.

## 4. Upravujte výsledek a příště na něj navažte

> Praktickou část rozděl na návrh a ověření. Uprav dokument a ukaž mi nové PDF.

Codex provede požadovanou změnu v souborech a ověří výsledek. Technická kontrola
nepotvrzuje odbornou správnost; význam a obsah posuzujete vy.

Při návratu do stejného projektu stačí:

> Chci pokračovat v rozpracované práci.

Codex přečte uložený stav a příslušné soubory, stručně připomene poslední
výsledek a naváže. Pokud není jasné, kde pokračovat, položí cílenou otázku.

Po prvním nastavení doporučí zaměřený chat **MAIN – hlavní práce**, a pokud
vznikl i praktický deník, také **EXPERIMENTY – praktický deník**. Připraví úvodní
zprávy; chaty vytvoří jen na vaše přání. Všechny pracují se stejnými soubory.
Rozpracovaný požadavek můžete dokončit i v původním chatu. Další možnosti jsou
v [přehledu doporučených chatů](README.md#doporučené-chaty).

Další inspiraci najdete v [praktických ukázkách zadání](ukazky/ZADANI_PRO_CODEX.md).
Následující příklady a vysvětlení můžete číst až ve chvíli, kdy je potřebujete.

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
- „Připrav předávací balíček této kapitoly pro vedoucího, ale nepřidávej osobní profil ani jiné citlivé soubory.“
- „Ověř přijatý balíček od kolegy, porovnej každý soubor s mojí prací a nejdřív mi ukaž konflikty.“
- „Ulož ověřené změny do historie a vysvětli mi, co se uloží na GitHub.“

Předávací balíčky patří do `predavani/`. Jejich obsah se do Gitu standardně neukládá.
Kontrola balíčku ověří jeho integritu a bezpečné cesty, ale Codex stále nesmí bez
porovnání přepsat vaši práci ani považovat převzatý odborný obsah za automaticky
správný. Podrobný návod je v `predavani/README.md`.

## Agent připravuje, člověk schvaluje

AI agent může text napsat, výpočet přepočítat, zdroj dohledat a PDF technicky zkontrolovat. Pořád ale může špatně pochopit význam, použít nepřiměřené tvrzení nebo vytvořit výsledek, který sice projde kompilací, ale nedává odborně smysl.

Každou důležitou změnu proto projekt rozděluje na dvě brány:

1. **technická kontrola** – soubory, výpočty, citace, odkazy a PDF projdou dostupnými automatickými testy;
2. **lidská kontrola** – vy si přečtete přesně vymezenou změnu a teprve potom ji schválíte nebo vrátíte k opravě.

Agent nesmí označit vlastní materiální změnu jako schválenou. Bez vašeho rozhodnutí má říct, že je technicky zkontrolovaná a čeká na lidskou kontrolu. Můžete napsat například:

> Připrav tuto kapitolu ke kontrole a vypiš mi, co mám ověřit já.

> Ověř tento důležitý výpočet nezávislou metodou, ale do práce ho vlož až po mé kontrole.

## Čtyři pokročilé požadavky obyčejnou větou

Nemusíte znát názvy skriptů ani skills. Stačí později napsat například:

- „Zkontroluj práci před odevzdáním.“
- „Porovnej hotovou práci s oficiálním zadáním.“
- „Zapracuj připomínky vedoucího a udržuj seznam jejich stavu.“
- „Připrav mě k obhajobě podle skutečného obsahu práce.“

Finální kontrola ověří čistý build, zdroje, citace, odkazy, placeholdery, fonty a výsledné PDF. Je to technický preflight, nikoli potvrzení, že je práce automaticky obsahově správná.

## Volitelné pluginy

LaTeX nebo Wolfram plugin může práci urychlit, ale není povinný. LaTeX plugin pomáhá s diagnostikou prostředí; závazný build TUL práce stále provádějí projektové skripty. Wolfram je vhodný jako výpočetní kontrola symbolické matematiky nebo jednotek, nikoli jako náhrada odborného zdroje. Po instalaci pluginu může být potřeba otevřít nový chat, aby jej agent viděl.

Citlivá nebo neveřejná data se do externí služby neposílají bez vašeho předchozího souhlasu. Když plugin není dostupný, agent má použít bezpečný místní nástroj nebo srozumitelně popsat omezení; nemá nic automaticky instalovat.

## Pět pojmů, které stačí znát

- **Repozitář** – projektová složka společně s historií změn.
- **GitHub** – internetové úložiště vaší kopie projektu; není to samotný textový editor.
- **Git** – historie změn, ke které se lze vracet.
- **LaTeX** – systém, který ze zdrojového textu vytvoří správně vysázené PDF.
- **AI agent** – technický spolupracovník, který může měnit soubory a spouštět kontroly; za obsah práce a odevzdaný výsledek odpovídá autor.

## Semestrálka nebo kratší protokol

Stačí zadat například: „Chci semestrální práci pro Fakultu textilní, předmět
Materiály. Tady je zadání; pomoz mi připravit dokument.“ Agent použije samostatnou
semestrální šablonu 1.1, potvrdí název, autora a údaje o předmětu a připraví
`prace/main.tex`. Není potřeba řešit mužskou/ženskou variantu ani úvodní listy
STAG. Platí skutečné pokyny vyučujícího, ověřování zdrojů a evidence použití AI.
Závěrečná práce používá uspořádanou TULthesis 0.8; rozpracované soubory se
automaticky nepřevádějí. [Podrobnosti o variantách](templates/TEMPLATE_VARIANTS.md).

## Bezpečné cvičení před vlastní prací

Chcete nejprve vyzkoušet postup bez skutečných údajů? Použijte [oddělené cvičení od projektu po první PDF](ukazky/prvni-projekt/README.md). Nevytváří vaši práci a nepotvrzuje schválení obsahu. U chráněných podkladů nejprve doložte schválení konkrétního AI systému TUL podle AI_NA_TUL.md; samotný souhlas s přenosem nestačí.
