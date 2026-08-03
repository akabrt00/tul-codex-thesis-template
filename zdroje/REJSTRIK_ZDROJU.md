# Rejstřík odborných zdrojů

Každý odborný zdroj má trvalý interní identifikátor `SRC-NNNN` a samostatný citační klíč. Výchozí `citacni_klic` odpovídá názvu lokálního zdrojového souboru bez přípony. Identifikátor se nikdy nemění; citační klíč lze změnit pouze řízeně se současnou aktualizací všech citací.

Obsah `templates/` se zde nikdy neeviduje a nesmí být nabízen jako odborný nebo citovatelný zdroj.

| ID | citacni_klic | Stav | Název nebo popis | Typ | Lokální cesta | SHA-256 | Původ, autor nebo URL | Získáno | Účel | Licence / omezení | Odvozené soubory |
|---|---|---|---|---|---|---|---|---|---|---|---|
| `SRC-0003` | `SRC-0003_metodika-citovani-tul-2023` | `pouze odkaz` | Metodika citování, 3. upravené vydání | metodika / online kniha | pouze odkaz | — | Marta Zizienová; Pavla Vrabcová; Jan Koprnický; Luboš Běhálek. Technická univerzita v Liberci, 2023. ISBN 978-80-7494-650-9. https://etul.publi.cz/book/2636-metodika-citovani | 2026-08-03 | Primární pravidla TUL pro citování podle ČSN ISO 690:2022 | Přístup přes licencovanou platformu eTUL/Publi; uživatelem poskytnutý PDF originál se kvůli neověřené redistribuční licenci neukládá do veřejného repozitáře | `90_zpracovane/poznamky-a-souhrny/SRC-0003_SRC-0004_SRC-0005_citation-policy.md`; `90_zpracovane/prevedene-soubory/SRC-0003_SRC-0004_SRC-0005_tul-guidance.bib` |
| `SRC-0004` | `SRC-0004_smernice-rektora-5-2018` | `pouze odkaz` | Směrnice rektora TUL č. 5/2018: Jednotná úprava a zveřejňování bakalářských, diplomových, rigorózních, disertačních a habilitačních prací, revize 04 | směrnice / PDF online | pouze odkaz | — | Technická univerzita v Liberci. https://doc.tul.cz/11367 | 2026-08-03 | Struktura, formální úprava a zveřejňování závěrečných prací | Veřejný oficiální dokument TUL; evidován odkaz, nikoli další distribuovaná kopie | `90_zpracovane/poznamky-a-souhrny/SRC-0003_SRC-0004_SRC-0005_citation-policy.md`; `90_zpracovane/prevedene-soubory/SRC-0003_SRC-0004_SRC-0005_tul-guidance.bib` |
| `SRC-0005` | `SRC-0005_smernice-rektora-4-2023-ai` | `pouze odkaz` | Směrnice rektora č. 4/2023: Využití umělé inteligence při výuce a tvůrčí práci | směrnice / PDF online | pouze odkaz | — | Technická univerzita v Liberci. https://doc.tul.cz/12546 | 2026-08-03 | Pravidla přiznání, kontroly a odpovědnosti při použití AI | Veřejný oficiální dokument TUL; evidován odkaz, nikoli další distribuovaná kopie | `90_zpracovane/poznamky-a-souhrny/SRC-0003_SRC-0004_SRC-0005_citation-policy.md`; `90_zpracovane/prevedene-soubory/SRC-0003_SRC-0004_SRC-0005_tul-guidance.bib` |

Povolené stavy: `příchozí`, `aktivní`, `nahrazený`, `archivovaný`, `pouze odkaz`.

## Rezervované identifikátory

- `SRC-0001` a `SRC-0002` jsou trvale rezervované historické identifikátory upstream TUL balíčků. Od 2026-08-03 nejsou odbornými zdroji a nesmějí být znovu použity. Jejich integritní záznam je pouze v `templates/upstream/TUL/UPSTREAM_MANIFEST.md`.
- Identifikátory `SRC-0003` až `SRC-0005` jsou přidělené. První další odborný zdroj použije `SRC-0006`.
