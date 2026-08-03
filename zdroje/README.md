# Zdroje

Toto je jediné místo pro odborné a citovatelné podklady projektu. Originál nikdy neupravuj. Každý uložený zdroj zapiš do `REJSTRIK_ZDROJU.md` a teprve potom vytvářej jeho odvozeniny. Upstream šablony v `templates/` nejsou odbornými zdroji, tento systém je zcela ignoruje a nikdy je nenabízí k citování.

## Automatická práce se zdroji

Uživatel nemusí znát název skillu, rejstřík ani žádný příkaz. Stačí v aktivním chatu přiložit podklad, vložit jej do `00_prichozi/` a napsat agentovi, nebo se běžně zeptat například „Co moje podklady říkají o tomto tématu?“. Agent automaticky zkontroluje nové soubory, zdroj zařadí, vytvoří potřebnou stránkovou extrakci a mapu, obnoví index, vyhledá důkazy a před citací ověří původní stránku.

Automatika se spouští při práci agenta. Nejde o program běžící nepřetržitě na pozadí, takže soubor vložený do složky se zpracuje při nejbližší zprávě nebo úkolu v projektu. Samotný informační dotaz nemění text práce; citaci agent zapíše do dokumentu tehdy, když uživatel požádá o napsání nebo úpravu jeho obsahu.

## Rozdělení

| Složka | Co do ní patří | Co do ní nepatří |
|---|---|---|
| `00_prichozi/` | Nové, dosud neroztříděné soubory | Dlouhodobě uložené a už zařazené zdroje |
| `01_literatura/clanky/` | Odborné články, konferenční příspěvky a preprinty | Knihy, normy a webové stránky |
| `01_literatura/knihy-a-kapitoly/` | Knihy, kapitoly a monografie | Články a kvalifikační práce |
| `01_literatura/normy-a-predpisy/` | Normy, zákony, předpisy a metodické pokyny | Běžné manuály a technické listy |
| `01_literatura/kvalifikacni-prace/` | Bakalářské, diplomové a disertační práce | Vlastní výstupy projektu |
| `02_web/ulozene-stranky/` | Povolené lokální kopie webových stránek a exporty | Pouhé odkazy bez lokálního souboru; ty eviduj jen v rejstříku |
| `02_web/snimky/` | Screenshoty a vizuální doklady webového obsahu | Obecná obrázková aktiva |
| `03_data/puvodni/` | Původní externí datasety, tabulky, databázové exporty a měření | Vyčištěná nebo transformovaná data |
| `03_data/metadata/` | Datové slovníky, schémata, popisy proměnných a metadata | Samotné datové soubory |
| `04_dokumentace/manualy/` | Uživatelské a servisní manuály | Technické listy jednotlivých produktů |
| `04_dokumentace/technicke-listy/` | Datasheety, produktové listy a bezpečnostní listy | Obecné odborné články |
| `04_dokumentace/api/` | Exporty nebo lokální kopie API dokumentace | Zdrojový kód klienta |
| `05_media/obrazky-a-grafika/` | Zdrojové fotografie, obrázky, diagramy, loga a grafická aktiva | Výsledné obrázky vytvořené projektem |
| `05_media/audio-video/` | Zdrojové audio a video | Překódované pracovní verze |
| `06_software/repozitare/` | Zdrojové snapshoty nebo povolené kopie externích repozitářů | Vlastní implementace projektu |
| `06_software/skripty/` | Samostatné externí skripty a ukázkový kód | Skripty vytvořené přímo pro projekt |
| `07_poskytnute/` | Materiály předané uživatelem, klientem nebo partnerem, které nezapadají jinam | Veřejné zdroje, které lze zařadit podle typu |
| `90_zpracovane/extrahovany-text/` | Text extrahovaný z PDF po jednotlivých stránkách, OCR a přepisy s manifestem mapování | Původní dokumenty a extrakce bez stránkového mapování |
| `90_zpracovane/prevedene-soubory/` | Formátové konverze a pracovní kopie | Originály |
| `90_zpracovane/vycistena-data/` | Vyčištěná, filtrovaná a sjednocená data | Neupravené datové zdroje |
| `90_zpracovane/poznamky-a-souhrny/` | Poznámky, anotace a souhrny navázané na konkrétní zdroj | Finální projektové zprávy |
| `90_zpracovane/index/` | Generovaný stránkový fulltextový index a jeho manifest | Originály nebo jediná kopie důležitých informací |
| `99_archiv/` | Nahrazené nebo zastaralé podklady, které je nutné zachovat | Aktivní aktuální zdroje |

## Hledací vrstva

Vyhledávání má tři úrovně:

1. `REJSTRIK_ZDROJU.md` určuje, co je zdroj, odkud pochází a jak se cituje.
2. `INDEX_ZDROJU.md` a jednotlivé mapy obsahu ukazují témata, tvrzení, omezení a relevantní stránky.
3. `90_zpracovane/index/search-index.jsonl` umožňuje fulltextové hledání v extrahovaných stránkách.

Výsledek hledání není důkaz. Před citací vždy otevři odpovídající stránku a podle potřeby i originální PDF, zejména u tabulek, rovnic, obrázků a nejasné extrakce.

## Pracovní postup

1. Ulož nový materiál do `00_prichozi/`, pokud jeho kategorie není okamžitě zřejmá.
2. Zkontroluj duplicity, oprávnění, citlivé údaje a licenční omezení.
3. Přesuň originál do odpovídající kategorie a už jej neupravuj.
4. Přidej položku do `REJSTRIK_ZDROJU.md`, přiděl jí další volné stabilní ID `SRC-NNNN` a u lokálního souboru zaznamenej SHA-256.
5. Přidej samostatný `citacni_klic`. Výchozí hodnota je přesný název uloženého zdrojového souboru bez přípony.
6. Pojmenuj uložený originál ve tvaru `SRC-NNNN_strucny-popis.ext`, pokud tím neztratíš významné původní označení.
7. Odvozené soubory pojmenuj s ID a citačním klíčem a ulož je do příslušné části `90_zpracovane/`.
8. PDF extrahuj pouze pomocí stránkového workflow: jeden textový soubor na jednu PDF stránku plus `manifest.json` s úplným mapováním.
9. Vytvoř mapu obsahu podle skillu, doplň `INDEX_ZDROJU.md` a spusť `scripts/build-source-search-index.ps1 -Force`.
10. Zdroj označ jako `aktivní` až po dokončení a ověření hledací vrstvy.
11. Při nahrazení zdroje zachovej historii v `99_archiv/` a aktualizuj stav v rejstříku.

Respektuj autorská práva, licence, ochranu osobních údajů a podmínky zdroje. Pokud lokální kopie není dovolena nebo potřebná, ulož do rejstříku pouze odkaz a metadata.
