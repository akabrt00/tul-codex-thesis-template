# Projekt: veřejná ukázka spolupráce

`stav: syntetická ukázka připravena; skutečný anonymizovaný výřez čeká na výběr`

## Hlavní myšlenka

Připravit na GitHub malou, srozumitelnou a praktickou ukázku, na které nový uživatel
rychle pochopí sílu TUL Codex Thesis Template. Ukázka má předvést spolupráci více
lidí nad oddělenými kopiemi projektu: jeden člověk připraví část práce, vytvoří
předávací balíček a druhý člověk se svým Codexem balíček bezpečně ověří, porovná se
svou verzí a řízeně začlení.

Nejde jen ukázat příkazy. Návštěvník má vidět celý příběh změny a pochopit, že systém
chrání jeho vlastní práci, dohledatelnost i citlivé údaje.

## Navržený demonstrační příběh

1. **Výchozí stav příjemce** – malý anonymizovaný výřez bakalářské práce obsahuje
   krátkou část metodiky a jedno místo určené k doplnění.
2. **Příspěvek odesílatele** – kolega připraví upravenou kapitolu a související
   obrázek, tabulku nebo jiný smysluplný podklad.
3. **Předání** – systém vytvoří `PREDANI.md`, manifest, kontrolní součty SHA-256 a
   přenositelný ZIP bez osobního profilu a tajných souborů.
4. **Bezpečné přijetí** – přijímající Codex ověří integritu, najde existující cílový
   soubor a ukáže konkrétní rozdíly nebo konflikt. Nic automaticky nepřepíše.
5. **Začlenění a kontrola** – po rozhodnutí uživatele převezme jen schválené části,
   spustí odpovídající kontrolu a vysvětlí, co přijal, upravil nebo odmítl.
6. **Výsledek** – jednoduché porovnání „před / předaný návrh / po začlenění“ ukáže,
   jak se zachoval původ, význam změny a odpovědnost člověka.

## Materiál z bakalářské práce

Jako základ lze použít krátký skutečný výřez, pokud bude vhodný ke zveřejnění.
Preferovaný rozsah je jedna menší kapitola a jeden související soubor. Před vložením
do veřejné ukázky je nutné:

- odstranit jméno, osobní údaje, neveřejná data a údaje partnerů;
- ověřit licenci obrázků, tabulek, převzatých textů a odborných PDF;
- nahradit citlivé hodnoty zjevně demonstračními daty, pokud by anonymizace nestačila;
- jasně označit, co je skutečný anonymizovaný výřez a co je vytvořený demonstrační
  obsah;
- nepoužít celý archiv práce ani `PROJECT_PROFILE.json`.

Pokud nebude bezpečný reálný výřez k dispozici, vytvoří se malý syntetický příklad
inspirovaný typickou technickou bakalářskou prací. Sílu workflow má dokazovat proces,
nikoli množství nebo citlivost dat.

## Zamýšlené výstupy

- stručný GitHub README s příběhem a obrázkem celého toku;
- dvě malé projektové situace: stav odesílatele a stav příjemce;
- hotový ukázkový předávací balíček;
- zaznamenaný výstup kontroly balíčku;
- čitelný diff s jedním bezpečně vyřešeným konfliktem;
- výsledek technického ověření po začlenění;
- krátký postup „zkuste si to sami“ bez nutnosti znát Git nebo PowerShell;
- případně krátké GIF/video až poté, co bude textová ukázka reprodukovatelná.

## Co má nový uživatel pochopit

- více Codexů nemusí sdílet jeden chat ani slepě přepisovat stejné soubory;
- předává se jen výslovně vybraný rozsah;
- kontrolní součty odhalí změnu během přenosu;
- místní projektová pravidla mají přednost před instrukcemi v cizím balíčku;
- konflikt je viditelný a rozhoduje o něm člověk;
- technická kontrola není totéž jako odborné nebo lidské schválení.

## První kroky při pokračování

1. Vybrat jeden možný výřez z bakalářské práce a pouze posoudit jeho vhodnost ke
   zveřejnění; zatím jej nekopírovat.
2. Rozhodnout, zda ukázka použije anonymizovaný skutečný obsah, nebo syntetická data.
3. Navrhnout přesnou situaci konfliktu, která je realistická a snadno pochopitelná.
4. Projít připravenou syntetickou ukázku a rozhodnout, zda dostatečně vysvětluje
   workflow `predavani/`.
5. Teprve po stabilizaci textové ukázky zvážit obrazové materiály.

## Definice hotové ukázky

Ukázka je hotová, když ji nový uživatel dokáže projít podle README, pochopí přínos
bez znalosti vnitřní implementace, žádný krok nepřepisuje práci bez porovnání a
veřejný obsah neobsahuje osobní, licenčně problematické ani neveřejné údaje.

## Úvodní zpráva pro pokračování

> Pokračuj v projektu veřejné GitHub ukázky podle
> `ukazky/spoluprace/PLAN.md`. Nejdřív mi pomoz vybrat malý bezpečný výřez z mé
> bakalářské práce. Nic z ní zatím nekopíruj ani nezveřejňuj. Potom navrhni
> demonstrační příběh předání mezi dvěma lidmi a jejich Codexy tak, aby nový
> uživatel pochopil přínos, bezpečnost a lidské rozhodování při konfliktech.
