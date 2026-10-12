# Šablony dokumentů

Nové projekty se zakládají skriptem `scripts/init-project.ps1`. Rozpracované
dokumenty skript nepřepisuje. Všechny pracovní dokumenty mají vstup `main.tex`.

| Varianta | Využití | Uspořádání a překlad |
|---|---|---|
| `Organized` | Výchozí pro nové závěrečné a odborné práce | Komunitní TULthesis 0.8 z webu, text v `main.tex`, údaje a balíčky v `nastaveni/`, bibliografie `literatura/zdroje.bib`, třída a loga v `sablona/`; XeLaTeX + Biber + MakeIndex |
| `Semester` | Výchozí pro českou semestrálku (`SP`) na sedmi fakultách | Samostatná semestrální šablona 1.1, `article`, údaje v `main.tex`, `literatura.bib`, loga `podklady/`; pdfLaTeX + BibTeX |
| `Original` | Původní rozložení TULthesis, například kvůli kompatibilitě | Technické soubory vedle `main.tex`, `references.bib`; XeLaTeX + Biber + MakeIndex |

`Auto` respektuje volbu uloženou v `PROJECT_PROFILE.json`, jinak použije pravidla
výše. České `SP` pro CXI a anglické práce použijí `Organized`, protože semestrální
šablona 1.1 tyto varianty nepodporuje. Její explicitní výběr je v takovém případě
odmítnut s vysvětlením. V profilu se fakulta umění eviduje jako `FA`, do
semestrálky se převádí na `FUA`. Oba typy práce mohou být hlavní nebo samostatný
podpůrný dokument; každý se registruje v `PROJECT_CONTEXT.md`.

## Co potřebuje semestrálka

Autor, fakulta, český název a rok přicházejí z profilu. Dále potvrďte předmět,
datum práce, verzi zadání a použitý software; `setup-profile.ps1` má parametry
`-Course`, `-WorkDate`, `-AssignmentVersion`, `-Software`. Neznámé údaje zůstanou
označené k doplnění. Nepotřebné položky titulní strany lze upravit v pracovní
kopii podle zadání. Nevyžaduje se mužská/ženská varianta ani úvodní listy STAG.

Semestrálka má jeden `\TitulniStrana`; TULthesis jeden `\ThesisStart`.
Zdroje se stále registrují v `zdroje/`, použití AI v `POUZITI_AI.md` a skutečná
deklarace se řídí zadáním. Starter nepřebírá autora, smyšlenou citaci ani měření
z veřejné ukázky. Prázdná bibliografie je pouze výchozí stav; před odevzdáním ji
doplňte ověřenými zdroji nebo odstraňte, pokud ji práce podle zadání nepoužívá.
Styl `unsrt` sám nedokládá soulad s ISO 690.

```powershell
# Po vytvoření profilu: hlavní dokument nebo samostatná semestrálka
./scripts/init-project.ps1 -Target Thesis
./scripts/init-project.ps1 -Target Document -DocumentName protokol -TemplateVariant Semester
# Původní TULthesis do prázdného workspace
./scripts/init-project.ps1 -Target Thesis -TemplateVariant Original
# Překlad automaticky zvolí workflow podle stylu v main.tex
./scripts/check-environment.ps1 -DocumentKind Semester
./scripts/compile-thesis.ps1 -ProjectDir ./prace -Clean
./scripts/validate-deliverable.ps1 -ProjectDir ./prace -DocumentKind Semester
```

## Původ a úpravy

Veřejné ZIPy byly načteny z aktuálního zdroje webu LaTeX TUL (commit
`b80527e40cbe6b330686e567b49935974b37fed8`) dne 10. 10. 2026. Jejich SHA-256
odpovídají metadatům webu. Nezměněné obsahy v `templates/community/` mají
manifesty `templates/manifests/`; s těmito podklady se zachází jako s dodanými
šablonami, nejsou odbornými citovatelnými zdroji a nekompilují se na místě.

- TULthesis: Pavel Satrapa, místní balíček s úpravami Jana Koprnického;
  komunitní uspořádání Adam Kábrt s využitím Codexu. Verze 0.8 mění uspořádání
  a cestu fontu, nikoli sazbu třídy. Návrh 0.9 a programovatelná loga nejsou
  aktivním vydáním a nebyly použity.
- Semestrálka: Adam Kábrt ve spolupráci s Codexem, grafické podklady tul 2.3
  Pavla Satrapy, CC BY podle původního balíku. Původní dokumentace a autorství
  zůstávají přibalené. Nejde o oficiální schválení požadavků konkrétního předmětu.

Inicializace mění pouze pracovní kopii: doplní profil, odstraní ukázkový obsah
z aktivního dokumentu a zachová původní technické podklady. Přechod existující
práce na jiné uspořádání vyžaduje samostatné porovnání cest, obsahu a výsledného
PDF; tento postup žádnou existující práci automaticky nemigruje.
