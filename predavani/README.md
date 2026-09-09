# Předávání práce mezi lidmi a jejich Codexy

Tato složka slouží k řízenému předávání hotových i rozpracovaných výstupů mezi
samostatnými kopiemi projektu. Předávací balíček není automatický merge. Přijímající
Codex musí nejdřív ověřit jeho integritu a bezpečnost, porovnat obsah s cílovým
projektem a respektovat místní `AGENTS.md` a `PROJECT_CONTEXT.md`.

## Struktura

- `odchozi/` – lokální balíčky připravované k odeslání;
- `prijate/` – lokálně rozbalené balíčky od jiných lidí;
- `sablona/PREDANI.md` – osnova lidského popisu předávané práce;
- `AGENTS.md` – závazný postup pro Codex, který balíček vytváří nebo přijímá.

Obsah `odchozi/` a `prijate/` je ignorovaný Gitem. Verzují se pouze jejich prázdné
adresáře. Balíčky proto předávejte cíleně, obvykle jako ZIP přes schválený kanál.

Každý balíček obsahuje:

- `PREDANI.md` – účel, stav, rozhodnutí, ověření, rizika a požadovaný další krok;
- `manifest.json` – bezpečné cílové cesty, velikosti a SHA-256 všech souborů;
- `obsah/` – předávané soubory v původní projektové struktuře.

## Vytvoření balíčku

```powershell
& .\scripts\new-handoff-package.ps1 `
  -Name "kapitola-metodika" `
  -Recipient "vedoucí práce" `
  -Purpose "Kontrola a začlenění metodiky" `
  -SourcePaths @("prace\kapitoly\metodika.tex", "prace\obrazky\schema.png")
```

Skript zachová relativní cesty, vytvoří manifest a případně ZIP. Potom ve vytvořeném
balíčku dokončete `PREDANI.md`. Před odesláním spusťte stejnou kontrolu, jakou použije
příjemce:

```powershell
& .\scripts\verify-handoff-package.ps1 `
  -PackagePath .\predavani\odchozi\<id-balicku> `
  -CreateZip
```

ZIP vzniká až po úspěšné kontrole, takže vždy obsahuje stejný dokončený popis a
soubory, které právě prošly ověřením. Nedokončený popis, změněný hash, neočekávaný soubor, nebezpečná cílová cesta nebo
citlivý typ souboru kontrolou neprojde. Přepínač `-AllowIncompleteDescription` je
určen pouze pro kontrolu rozpracovaného místního balíčku, nikdy pro přijetí nebo
odeslání; nelze jej kombinovat s vytvořením ZIP.

## Přijetí balíčku

1. ZIP nejdřív zkontrolujte běžným bezpečnostním nástrojem a rozbalte jej do
   `predavani/prijate/<id-balicku>/`.
2. Požádejte Codex:

   > Zkontroluj a navrhni začlenění balíčku v `predavani/prijate/<id-balicku>`.
   > Nejdřív ověř manifest a porovnej každý cílový soubor. Nic automaticky
   > nepřepisuj.

3. Codex spustí `verify-handoff-package.ps1`, přečte `PREDANI.md`, zkontroluje místní
   pravidla a připraví přesný diff nebo seznam konfliktů.
4. Teprve po odsouhlasení postupu soubory začlení a spustí odpovídající test, audit
   nebo kompilaci.

Úspěšné ověření dokazuje integritu balíčku, nikoli odbornou správnost jeho obsahu.
Citace, výpočty, výsledky a závěry musí projít kontrolami cílového projektu a lidským
posouzením.

## Co se nepředává automaticky

- `PROJECT_PROFILE.json`, `.env*`, přístupové údaje, soukromé klíče a správci hesel;
- `.git/`, lokální cache, sestavovací meziprodukty a jiné generované soubory;
- celý lokální archiv `prace/migrace/kompletni-archiv/`;
- odborné zdroje bez oprávnění k dalšímu sdílení;
- neověřená tvrzení nebo cizí změny přepsané bez porovnání.
