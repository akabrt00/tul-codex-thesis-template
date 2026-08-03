# TUL Codex Thesis Template

Přenositelná projektová základna pro závěrečnou práci, další samostatné dokumenty a obhajobu na Technické univerzitě v Liberci. Obsahuje TUL LaTeX šablony, správu odborných zdrojů a onboarding pro AI agenty.

## Nejrychlejší začátek

1. Naklonujte nebo stáhněte repozitář.
2. Otevřete jeho kořenovou složku jako workspace AI agenta.
3. Pošlete agentovi:

   > Přečti `AGENTS.md` a použij `$setup-tul-project`. Proveď mě prvním nastavením, vytvoř můj lokální profil, založ potřebné dokumenty a řekni mi, kde mám pokračovat.

4. Agent si vyžádá jméno, fakultu, typ práce, jazyk, rok a známé školní údaje. Nic oficiálního nesmí hádat.
5. Po dokončení onboardingu otevřete nový chat ve stejném projektu a pracujte už jen na konkrétním dokumentu.

Podrobný vstupní postup je v [START_HERE.md](START_HERE.md).

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

## Zdroje a kontroly

Každý odborný zdroj má trvalé interní ID `SRC-NNNN`, samostatný `citacni_klic`, původ, datum, SHA-256, licenci a vazbu na odvozené soubory. První volné ID v čisté šabloně je `SRC-0003`.

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate-skills.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\audit-sources.ps1
```

Šablona nic automaticky neinstaluje. Chybějící programy, balíky nebo fonty pouze nahlásí.
