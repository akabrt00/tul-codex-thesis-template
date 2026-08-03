# TUL Codex Thesis Template

Přenositelná projektová základna pro závěrečnou práci, další samostatné dokumenty a obhajobu na Technické univerzitě v Liberci. Obsahuje TUL LaTeX šablony, správu odborných zdrojů a onboarding pro AI agenty. Je navržená i pro studenty, kteří dosud pracovali pouze ve Wordu a neznají Git ani LaTeX.

> **Jste úplný začátečník?** Začněte českým průvodcem [START_HERE.md](START_HERE.md). Nemusíte používat příkazový řádek ani ručně upravovat LaTeX.

## Nejrychlejší začátek

1. Na GitHubu klikněte na **Use this template** a vytvořte si vlastní, ideálně soukromý repozitář. Vaše práce tím nemůže přepsat původní šablonu.
2. Stáhněte svou kopii a otevřete celou její složku jako workspace AI agenta.
3. Pošlete agentovi:

   > Přečti `AGENTS.md` a `START_HERE.md`. Použij `$setup-tul-project` a proveď mě prvním nastavením. S Gitem ani LaTeXem jsem zatím nepracoval, proto mi každý důležitý krok vysvětli jednoduše a nic o mých školních údajích neodhaduj.

4. Agent se v malých krocích zeptá na jméno, fakultu, typ práce, jazyk, rok a známé školní údaje. Můžete odpovídat běžnými názvy; interní zkratky vyřeší agent. Nic oficiálního nesmí hádat.
5. Po dokončení onboardingu otevřete nový chat ve stejném projektu a pracujte už jen na konkrétním dokumentu.

Podrobný vstupní postup, srovnání s Wordem a příklady běžných požadavků jsou v [START_HERE.md](START_HERE.md).

## Profil a soukromí

Onboarding vytvoří `PROJECT_PROFILE.json`. Obsahuje osobní a studijní údaje a je záměrně ignorovaný Gitem. Ukázka struktury je v `PROJECT_PROFILE.example.json`.

`PROJECT_CONTEXT.md` je naopak verzovaný. Uchovává téma, strukturu projektu, seznam výstupů a dlouhodobá rozhodnutí, ale nemá duplikovat osobní profil.

Pozor: pracovní `.tex` dokument může obsahovat jméno autora. Před jeho odesláním do veřejného repozitáře zkontrolujte, které osobní údaje zveřejňujete.

## Dokumenty

Každý samostatně kompilovaný dokument má vlastní `main.tex` a záznam v tabulce výstupů v `PROJECT_CONTEXT.md`.

- `prace/main.tex` — hlavní závěrečná nebo odborná práce.
- `prace/dokumenty/<slug>/main.tex` — další samostatný dokument, například technologický deník, měřicí protokol nebo projektová zpráva.
- `obhajoba/main.tex` — prezentace k obhajobě.
- `zdroje/` — jediná složka pro odborné a citovatelné podklady.

Běžná kapitola nebo příloha vložená do hlavní práce nepotřebuje vlastní workspace. Samostatný dokument se zakládá tehdy, když má mít vlastní titulní údaje, číslování nebo výsledné PDF.

## Ruční inicializace

AI onboarding používá stejné reprodukovatelné PowerShell skripty, které lze spustit i ručně.

Kontrola prostředí:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\check-environment.ps1
```

Lokální profil:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\setup-profile.ps1 `
  -FullName "Jméno Příjmení" -Faculty FM -WorkType BP -Language CZ -Year 2026
```

Hlavní práce a prezentace:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\init-project.ps1 -Target Thesis
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\init-project.ps1 -Target Presentation
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
