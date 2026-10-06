# AI na TUL: co platí a jak s tím pracuje tento template

TUL podporuje použití AI při výuce, kvalifikačních pracích i tvůrčí činnosti.
Povoleni jsou také autonomní agenti. Za odevzdaný výsledek ale plně odpovídá
autor: musí ověřit fakta a zdroje a samostatně vysvětlit a obhájit každý krok,
mezivýsledek a logiku řešení. Úspěšná kompilace ani kontrola agentem tuto
odpovědnost nenahrazují.

Podklad: uživatelem poskytnutá směrnice rektora TUL č. 7/2026, revize 00,
„Pravidla používání AI při vzdělávací a tvůrčí činnosti“, č. j.
TUL26/9615/098476, JID TUL1001660109. Schválena 23. 9. 2026; titulní strana
uvádí účinnost od 1. 10. 2026, čl. 5 váže účinnost na zveřejnění.
Jde o praktický výtah, nikoli potvrzení aktuálního seznamu schválených služeb.
[Evidence a mapa zdroje](zdroje/90_zpracovane/poznamky-a-souhrny/SRC-0006_smernice-rektora-7-2026-ai_mapa-obsahu.md).

## Co musíte přiznat

Deklarujte generativní AI, která ovlivnila obsah, argumentaci, strukturu, analýzu,
zdrojový kód, seznam literatury nebo jiný hodnocený výstup. Uveďte konkrétní
nástroj, verzi, pokud je dostupná, konkrétní části práce a způsob použití.
Běžné pravopisné a typografické opravy se neuvádějí, pokud vyučující předem
neurčil jinak. Stylistická úprava není automaticky touto výjimkou.
AI se neuvádí jako spoluautor. Forma dokumentování může být stanovena vyučujícím,
vydavatelem nebo citační normou. Směrnice 7/2026 nestanoví obecný zákaz
bibliografického záznamu AI; samotná citace však nenahrazuje potřebnou deklaraci.
(Čl. 2 odst. 1 písm. a, c-f; str. 1-2.)

V tomto templatu agent průběžně zapisuje podstatné použití do
[POUZITI_AI.md](POUZITI_AI.md). Jde o pracovní evidenci, kterou směrnice sama
nepředepisuje. Před odevzdáním z ní připraví konkrétní deklaraci v dokumentu
podle skutečného použití a pokynů školy. Autor ověří její úplnost a pravdivost.
Pracovní tabulka sama o sobě není deklarací v odevzdávaném PDF.

Příklad formy, nikoli text určený k automatickému převzetí:

> Pro návrh struktury kapitoly 2 a úpravu skriptu v příloze B byl použit nástroj
> [skutečný název a dostupná verze]. Nástroj navrhl členění a opravu [konkrétní
> části kódu]. Autor samostatně ověřil [konkrétní fakta, zdroje a výsledky].

Agent nesmí doplnit smyšlenou verzi, vydávat svou kontrolu za kontrolu autorem,
ani automaticky tvrdit, že AI nebyla použita.

## Jaká data lze dát do Codexu nebo jiné AI

Nepublikovaná vědecká data, licenčně chráněný nebo obchodně tajný zdrojový kód,
citlivá data, neveřejné dokumenty univerzity a osobní údaje třetích osob lze
vkládat pouze do AI systému schváleného TUL. Souhlas uživatele, placený účet,
soukromý repozitář ani vypnuté trénování samy o sobě schválení TUL nedokládají.
Tato hranice se týká i obsahu souborů čtených cloudovým agentem, promptů,
příloh a dalších AI služeb volaných přes pluginy. (Čl. 3 odst. 1-2; str. 2.)

Dodané znění označuje **Gemini jako schválený a DeepSeek jako zakázaný systém
ke dni účinnosti**. Bez ohledu na data zakazuje nástroje, před nimiž vydal
varování NÚKIB. Konkrétní službu a aktuální institucionální podmínky je nutné
ověřit; nelze schválení automaticky rozšířit na libovolný účet, model nebo plugin.
Schválení Codexu/OpenAI pro chráněná data toto PDF nedokládá.
(Čl. 3 odst. 3-4; str. 2.)

Před zpřístupněním chráněných podkladů ověřte schválení konkrétního systému.
Dokud není doloženo, agent má pracovat s veřejnými, syntetickými nebo bezpečně
anonymizovanými vstupy, případně připravit postup pro schválené prostředí.
Anonymizace musí skutečně odstranit chráněné informace; přejmenování souboru
nestačí. Umístění souboru na lokálním disku neznamená, že jej cloudová AI
zpracovává lokálně. Také kontroly citlivosti musí proběhnout před zpřístupněním.

## Fakta, data a obhajoba

- Autor samostatně ověřuje fakta i citované zdroje. Fiktivní citace a smyšlená
  měření se nesmějí vydávat za skutečné podklady.
- AI data pro simulace, testování či trénování modelů jsou přípustná, pokud jsou
  v metodice výslovně popsána, zdůvodněna a označena. Zachovejte jejich původ
  odděleně od empirických měření.
- Nepřiznané generování podstatného obsahu může být podle rozsahu a charakteru
  posouzeno jako závažné podvodné jednání. Autor musí rozumět převzatým výstupům.
- AI detektor nemůže být přímým ani jediným důkazem porušení pravidel. Podezření
  se primárně ověřuje cílenou obhajobou postupu; rozhoduje oprávněný člověk.

(Čl. 2 odst. 1 písm. b-d, g; str. 1-2; čl. 4 odst. 4-6; str. 3.)

## Výuka, zkoušky a publikace

Vyučující může použití AI pro konkrétní úlohu předem omezit nebo zakázat a musí
vysvětlit didaktické či metodické důvody. Při přímém ověřování znalostí
(zápočty, zkoušky, státní závěrečné zkoušky včetně písemných testů) AI standardně
povolena není, pokud zadání výslovně nestanoví jinak. U distančního ověřování a
audio/video studijních výstupů vyžadují syntéza či klonování hlasu a digitální
avatary představující studenta předchozí výslovný souhlas vyučujícího.
Příprava na obhajobu se musí odlišit od použití AI během samotné zkoušky.
(Čl. 4 odst. 1-3; str. 3.)

Při publikování mimo TUL dodržte také pravidla příslušného vydavatele, časopisu
nebo konference. Konkrétní omezení a formu deklarace zapište do
`PROJECT_CONTEXT.md`; agent je nesmí odhadnout. (Čl. 2 odst. 1 písm. h; str. 2.)
