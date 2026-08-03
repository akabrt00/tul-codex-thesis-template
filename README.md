# Codex Project Template

Přenositelná projektová základna pro odbornou práci, TUL LaTeX dokument a obhajobu. Neobsahuje osobní cesty ani obsah konkrétní práce.

## Architektura

- `.agents/skills/` — repozitářové skilly používané Codexem.
- `templates/upstream/TUL/` — neměnné upstream šablony TUL; nejsou odbornými zdroji a necitují se.
- `prace/` — pracovní kopie TULthesis.
- `obhajoba/` — pracovní kopie TULpresentation.
- `zdroje/` — pouze odborné a citovatelné materiály.
- `scripts/` — inicializace, kompilace, extrakce a kontroly.

Nejbližší `AGENTS.md` určuje lokální pravidla pro práci, obhajobu nebo zdroje. Kořenový `AGENTS.md` obsahuje pouze pravidla platná pro celý projekt.

## První spuštění

V PowerShellu z kořene projektu:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\check-environment.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\init-project.ps1 -Target All
```

Inicializace vytvoří pracovní kopie a `main.tex` v `prace/` a `obhajoba/`. Skript kontroluje SHA-256 upstream stromů před kopírováním i po něm a nikdy do `templates/upstream/` nezapisuje.

## Kompilace

Závěrečná práce, včetně čistého odstranění pomocných souborů:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\compile-thesis.ps1 -ProjectDir .\prace -MainTex main.tex -Clean
```

Pořadí je vždy XeLaTeX → Biber → MakeIndex → XeLaTeX → XeLaTeX.

Prezentace:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\compile-presentation.ps1 -ProjectDir .\obhajoba -MainTex main.tex -Clean
```

## Odborné zdroje

Každý zdroj má:

- trvalý interní identifikátor `SRC-NNNN`;
- samostatný `citacni_klic`, standardně shodný s názvem zdrojového souboru bez přípony;
- původ, datum, SHA-256, licenci a vazbu na odvozené soubory.

PDF text se extrahuje po jednotlivých stránkách:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\extract-pdf-text.ps1 -InputPdf .\zdroje\01_literatura\clanky\SRC-0003_priklad.pdf -SourceId SRC-0003
```

Výsledkem jsou soubory `page-0001.txt`, `page-0002.txt`, … a `manifest.json` s jednoznačným mapováním na PDF stránky.

## Kontroly

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate-skills.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\audit-sources.ps1
```

Šablona nic automaticky neinstaluje. Chybějící komponenty vypíše `check-environment.ps1` spolu s konkrétním návodem k nápravě.

