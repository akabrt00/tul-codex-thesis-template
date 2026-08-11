# TUL Codex Thesis Template

Přenositelná projektová základna pro závěrečnou práci, další samostatné dokumenty a obhajobu na Technické univerzitě v Liberci. Obsahuje TUL LaTeX šablony, správu odborných zdrojů a onboarding pro AI agenty. Je navržená i pro studenty, kteří dosud pracovali pouze ve Wordu a neznají Git ani LaTeX.

> **Jste úplný začátečník?** Začněte českým průvodcem [START_HERE.md](START_HERE.md). Nemusíte používat příkazový řádek ani ručně upravovat LaTeX.

## Nejrychlejší začátek

1. Na GitHubu klikněte na **Use this template** a vytvořte si vlastní, ideálně soukromý repozitář. Vaše práce tím nemůže přepsat původní šablonu.
2. Stáhněte svou kopii a otevřete celou její složku jako workspace AI agenta.
3. Pošlete agentovi:

   > Přečti `AGENTS.md` a `START_HERE.md`. Použij `$setup-tul-project` a proveď mě prvním nastavením. S Gitem ani LaTeXem jsem zatím nepracoval, proto mi každý důležitý krok vysvětli jednoduše a nic o mých školních údajích neodhaduj.

4. Agent se v malých krocích zeptá na jméno, fakultu, typ práce, jazyk, rok, mužskou nebo ženskou variantu dočasné titulní strany a známé školní údaje. Můžete odpovídat běžnými názvy; interní zkratky vyřeší agent. Nic oficiálního nesmí hádat.
5. Po dokončení onboardingu oddělte práci do zaměřených chatů nad stejným projektem. Při hlavní práci a praktickém deníku jsou výchozí `MAIN – hlavní práce` a `EXPERIMENTY – praktický deník`; agent připraví jejich úvodní zprávy a vytvoří je pouze po vašem souhlasu.

Podrobný vstupní postup, srovnání s Wordem a příklady běžných požadavků jsou v [START_HERE.md](START_HERE.md).

## Doporučené chaty

Chat odděluje kontext rozhovoru, nikoli soubory nebo repozitář. Všechny chaty mají pracovat nad stejnou projektovou složkou.

- `MAIN – hlavní práce` – vybírá a formuluje finální obsah hlavního dokumentu.
- `EXPERIMENTY – praktický deník` – uchovává úplné záznamy praktické práce, včetně slepých cest a chyb.
- `OTÁZKY A REŠERŠE` – volitelný prostor pro hledání, ověřování a nezávazné dotazy.
- `OBHAJOBA` – zakládá se až při přípravě prezentace.

Toto rozdělení brání tomu, aby se úplný pracovní deník míchal s výslednou zkrácenou verzí v bakalářské práci. Agent nesmí mezi dokumenty přenášet obsah bez kontroly původu, významu a výběru.

## Experimentální deník

Praktický nebo technologický dokument může fungovat jako úplný zdroj pravdy pro praktickou část. Skill `$manage-experiments` převede i hrubý popis pokusu na dohledatelný záznam se stabilním ID `EXP-NNNN`. Uchovává cíl, datum, vzorek, zařízení, nastavení, postup, data, grafy, fotografie, odchylky, chyby a průběžné závěry. Neznámé údaje označí, ale nevymyslí.

Výsledky se do hlavní práce nekopírují automaticky. Na požadavek typu:

> Z experimentů EXP-0012 až EXP-0018 vyber výsledky vhodné do hlavní práce.

agent ověří původní záznamy a soubory, oddělí metodiku, výsledky a diskusi, připraví potřebné grafy a vytvoří záznam o přenosu. Hlavní text tak zůstává stručný, zatímco úplná historie včetně neúspěchů zůstane zachována v deníku.

## Profil a soukromí

Onboarding vytvoří `PROJECT_PROFILE.json`. Obsahuje osobní a studijní údaje a je záměrně ignorovaný Gitem. Ukázka struktury je v `PROJECT_PROFILE.example.json`.

Při založení práce se aktivuje právě jedna pracovní titulní strana: mužská (`male`) nebo ženská (`female`) varianta TUL šablony. Až získáte oficiální úvodní strany z IS STAG, předejte jejich PDF agentovi. Agent upozorní na osobní údaje, soubor uloží jako verzovanou součást hlavního dokumentu a původní variantu jím nahradí; nesmí ponechat dvě aktivní varianty ani všechny možnosti vypnout.

`PROJECT_CONTEXT.md` je naopak verzovaný. Uchovává téma, strukturu projektu, seznam výstupů a dlouhodobá rozhodnutí, ale nemá duplikovat osobní profil.

Pozor: pracovní `.tex` dokument může obsahovat jméno autora. Před jeho odesláním do veřejného repozitáře zkontrolujte, které osobní údaje zveřejňujete.

## Dokumenty

Každý samostatně kompilovaný dokument má vlastní `main.tex` a záznam v tabulce výstupů v `PROJECT_CONTEXT.md`.

- `prace/main.tex` — hlavní závěrečná nebo odborná práce.
- `prace/dokumenty/<slug>/main.tex` — další samostatný dokument, například technologický deník, měřicí protokol nebo projektová zpráva.
- `obhajoba/main.tex` — prezentace k obhajobě.
- `zdroje/` — jediná složka pro odborné a citovatelné podklady.

Běžná kapitola nebo příloha vložená do hlavní práce nepotřebuje vlastní workspace. Samostatný dokument se zakládá tehdy, když má mít vlastní titulní údaje, číslování nebo výsledné PDF.

## Kontrola člověkem a finální preflight

Automatická kontrola není totéž jako schválení práce. Materiální texty, výpočty, interpretace, citace, tabulky, obrázky a prezentace po technické kontrole zůstávají ve stavu `awaiting-human-review`, dokud autor výslovně neposoudí jejich význam a kvalitu. Agent nesmí schválit vlastní výstup.

Začátečník nemusí znát interní příkazy. Požadavek:

> Zkontroluj práci před odevzdáním.

spustí orchestraci auditu zdrojů, čistého buildu, kontroly logů a PDF preflightu. Deterministický skript rozlišuje `PASS`, `WARN` a `FAIL`, umí vytvořit i kompaktní JSON report a při kritickém problému vrací nenulový exit code. Technický verdikt neprohlašuje obsah za odborně správný.

U hlavní práce finální preflight také odmítne pracovní `male`/`female` úvodní strany. Před skutečným odevzdáním musí být nahrazeny oficiálním PDF z IS STAG; výjimka existuje pouze pro automatický test šablony.

Další běžné vstupy jsou „Porovnej práci se zadáním“, „Zapracuj připomínky vedoucího“, „Zkontroluj kapitolu“ a „Připrav mě k obhajobě“. Detailní postupy jsou načítány až prostřednictvím příslušných repository skills, aby základní kontext zůstal malý.

## Volitelné pluginy a vědecké nástroje

Projekt funguje bez pluginů. Nainstalované schopnosti se používají pouze tehdy, když jsou pro úlohu vhodné a v aktuálním chatu skutečně dostupné.

- LaTeX plugin je doplňková diagnostika. Nenahrazuje projektový build XeLaTeX → Biber → MakeIndex → XeLaTeX → XeLaTeX.
- Wolfram může ověřovat symbolické nebo numerické výpočty, jednotky a transformace. Je to výpočetní nástroj, ne odborný citační zdroj.
- MATLAB a Simulink se volí pro úlohy, kde přinášejí konkrétní výhodu; jednoduché operace mohou použít lehčí místní nástroj.
- Po instalaci pluginu může být nutné otevřít nový chat. Nedostupnost pluginu není chyba projektu a agent má hledat reprodukovatelný fallback.

Projekt nic automaticky neinstaluje a neposílá citlivá nebo neveřejná data do externí služby bez předchozího vysvětlení a potvrzení uživatele.

## Ruční inicializace

AI onboarding používá stejné reprodukovatelné PowerShell skripty, které lze spustit i ručně.

Kontrola prostředí:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\check-environment.ps1
```

Lokální profil:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\setup-profile.ps1 `
  -FullName "Jméno Příjmení" -Faculty FM -WorkType BP -Language CZ -Year 2026 `
  -FrontMatterVariant male
```

Hlavní práce a prezentace:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\init-project.ps1 -Target Thesis
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\init-project.ps1 -Target Presentation
```

Pozdější výměna pracovní titulní strany za oficiální PDF z IS STAG:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\set-thesis-start.ps1 `
  -ProjectDir .\prace -StagPdf ".\uvodni-strany-ze-stag.pdf"
```

Další samostatný dokument:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\init-project.ps1 `
  -Target Document -DocumentName technologicky-denik
```

Inicializace kontroluje SHA-256 upstream stromů před kopírováním i po něm. Do `templates/upstream/` nikdy nezapisuje.
Pro hlavní práci a další formální dokumenty vytvoří stručný pracovní `main.tex`; nepoužije jako výchozí obsah celý manuál šablony. Pokud existuje lokální profil, bezpečně do starteru doplní známá metadata a neznámé hodnoty ponechá jako jasné položky k doplnění.

## Kompilace

Hlavní práce:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\compile-thesis.ps1 `
  -ProjectDir .\prace -MainTex main.tex -Clean
```

Samostatný doplňkový dokument:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\compile-thesis.ps1 `
  -ProjectDir .\prace\dokumenty\technologicky-denik -MainTex main.tex -Clean
```

Prezentace:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\compile-presentation.ps1 `
  -ProjectDir .\obhajoba -MainTex main.tex -Clean
```

Práce se skládá v pořadí XeLaTeX → Biber → MakeIndex → XeLaTeX → XeLaTeX. Finální PDF a log je nutné také vizuálně a obsahově zkontrolovat.

## Architektura

- `.agents/skills/` — projektové skills pro onboarding, TUL dokumenty, prezentaci, lokální nástroje a zdroje.
- `templates/upstream/TUL/` — neměnné upstream TUL šablony; nejsou odborným zdrojem a necitují se.
- `prace/` — pracovní kopie hlavní práce a dalších formálních dokumentů.
- `obhajoba/` — pracovní kopie TULpresentation.
- `zdroje/` — odborné a citovatelné materiály s registry `SRC-NNNN`.
- `scripts/` — inicializace, kompilace, extrakce a kontroly.

## Grafy z MATLABu

MATLAB grafy, soubory `.fig`, vykreslovací skripty, `.mat` data a tabulkové exporty automaticky spouštějí skill `$matlab-to-tikz`. Agent zachová vykreslená data v přenositelném souboru, vytvoří editovatelný graf TikZ/PGFPlots a zkontroluje jeho číselnou shodu i vzhled ve výsledném PDF. Uživatel nemusí instalovat `matlab2tikz` ani znát příkazy převodu.

Příklad běžného požadavku:

> Tady je MATLAB graf. Převeď ho do práce jako pěkný vektorový graf, zachovej data a zkontroluj jednotky i legendu.

## Automatické návrhy obrázků a schémat

Uživatel může obsah popsat hrubě, například „tady vysvětluju tok materiálu výrobní linkou“. Skill `$create-project-visuals` sám posoudí, zda pomůže schéma, graf, fotografie, výřez ze zdroje nebo žádný obrázek. Jednoduchá odborná schémata kreslí v TikZ, datové grafy předává workflow PGFPlots a vhodné obrázky z registrovaných dokumentů umí dohledat, vytáhnout a připravit pro sazbu.

Každý použitý vizuál uchovává informaci o původu, stránce, licenci a provedené úpravě. Převzatý obrázek se cituje, překreslení se označí jako zpracované podle zdroje a AI ilustrace nesmí sloužit jako odborný důkaz. Experimentální fotografie, mikroskopické snímky ani naměřené grafy se generativně „nevylepšují“ způsobem, který by změnil jejich význam.

Příklad:

> Vysvětluju tu postup měření jen hrubě. Navrhni, jestli by pomohl obrázek nebo schéma, a připrav nejlepší variantu do práce.

## Zdroje a kontroly

Každý odborný zdroj má trvalé interní ID `SRC-NNNN`, samostatný `citacni_klic`, původ, datum, SHA-256, licenci a vazbu na odvozené soubory. Po předem registrovaných pravidlech TUL je první volné ID `SRC-0006`.

Výchozí pravidla citování TUL, práce s přímými a nepřímými citacemi, číselným systémem a deklarací AI jsou shrnuta v `zdroje/90_zpracovane/poznamky-a-souhrny/SRC-0003_SRC-0004_SRC-0005_citation-policy.md`. Vycházejí z registrovaných primárních zdrojů; aktuální pravidla konkrétní fakulty mají vždy přednost.

Po přidání PDF agent vytvoří stránkovou extrakci, mapu témat a tvrzení a společný fulltextový index. Při dotazu nejprve prohledá registrované podklady, otevře nalezenou stránku a ověří ji proti originálu. Když podklady tvrzení nepodporují, nesmí vytvořit falešnou citaci; místo toho doporučí, jaký nový odborný materiál je potřeba získat.

Příklad požadavku:

> Prohledej moje zdroje k tématu opotřebení textilních materiálů. U každého použitelného tvrzení ověř konkrétní stránku a navrhni citaci. Co nenajdeš, vypiš jako chybějící podklad.

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate-skills.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\audit-sources.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\build-source-search-index.ps1 -Force
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\search-sources.ps1 -Query "hledaný pojem"
```

Šablona nic automaticky neinstaluje. Chybějící programy, balíky nebo fonty pouze nahlásí.
