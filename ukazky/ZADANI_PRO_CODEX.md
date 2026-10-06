# Co můžete zadat Codexu a co potom udělá

Tato šablona mění Codex z obecného chatu na spolupracovníka, který zná strukturu
projektu, používá specializované pracovní postupy, upravuje skutečné soubory a umí
své změny technicky ověřit. Uživatel přitom nemusí znát Git, LaTeX ani příkazový
řádek.

Codex ale není autor, vedoucí ani zkušební komise. Dokáže připravit a zkontrolovat
technickou stránku práce; význam, pravdivost, školní údaje a konečné schválení vždy
zůstávají na člověku.

Celý pracovní cyklus názorně ukazuje simulace
[Člověk pracuje s Codexem](prace-s-codexem/README.md).

## Jak probíhá běžný úkol

| Uživatel | Codex | Výsledek v projektu | Člověk kontroluje |
|---|---|---|---|
| Popíše cíl obyčejnou větou a přiloží potřebný podklad. | Přečte pravidla a trvalý kontext projektu. | Změny vzniknou ve správné části projektu. | Zda Codex správně pochopil záměr. |
| Doplní pouze chybějící skutečnosti. | Zvolí odpovídající workflow a zachová existující práci. | Zdroj, kapitola, experiment, graf nebo kontrolní záznam. | Odborný význam a pravdivost. |
| Požádá o ověření. | Spustí vhodný test, audit nebo kompilaci. | Dohledatelný výsledek a popis omezení kontroly. | Zda je výsledek skutečně vhodný k použití. |
| Výslovně změnu schválí nebo vrátí. | Zachová stav lidské kontroly a další kroky. | Rozlišení technicky ověřeného návrhu od schváleného obsahu. | Konečné rozhodnutí. |

## 1. První otevření projektu

### Co napsat

> Otevírám tuto šablonu poprvé. Proveď mě nastavením jako úplného začátečníka.
> Vysvětluj jen to, co právě potřebuji, a žádné školní údaje neodhaduj.

### Co Codex udělá

- ověří, že pracujete ve své kopii projektu;
- v malých skupinách se zeptá na fakultu, druh práce, jazyk, rok a známé údaje;
- samostatně se zeptá na mužskou nebo ženskou variantu pracovní titulní strany;
- osobní údaje uloží do Git-ignorovaného `PROJECT_PROFILE.json`;
- inicializuje pouze požadované dokumenty a zaregistruje je v projektovém kontextu;
- zkontroluje prostředí a doporučí jeden nebo dva smysluplné pracovní chaty.

### Co získáte

Editovatelný zdroj hlavní práce, jasně označené chybějící údaje a připravený postup
pro vytvoření PDF. Codex nesmí vymyslet vedoucího, program, název práce ani jiný
oficiální údaj.

## 2. Rozhodnutí o záloze a online sdílení

### Co napsat

> Jako student mám univerzitní Google Drive nebo jiné online úložiště. Navrhni mi
> bezpečné rozdělení mezi lokální projekt, soukromý GitHub a zvolenou službu podle
> typů souborů. Nejdřív ověř, zda k této službě máš v aktuálním chatu konektor.
> Zatím nic nenahrávej; nejdřív mi ukaž plán a upozorni na osobní, licenční nebo
> neveřejná data.

### Co Codex udělá

- vysvětlí rozdíl mezi Git historií a cloudovým úložištěm souborů;
- rozdělí verzované texty, velká data, fotografie, videa, archivy a předávací balíčky;
- ověří, zda je konektor pro zvolené úložiště v aktuálním chatu skutečně dostupný;
- pokud není, navrhne místní export nebo ověřený ZIP pro ruční přenos;
- nic neodešle bez potvrzeného cíle a rozsahu;
- do projektového kontextu zapíše pouze přenositelné rozhodnutí, nikoli heslo,
  soukromý odkaz nebo místní synchronizovanou cestu.

### Co získáte

Srozumitelnou politiku, co patří do verzované historie, co lze sdílet přes
zvolené online úložiště a kdo rozhoduje o každém externím přenosu.

## 3. Návrh struktury podle skutečného zadání

### Co napsat

> Tady je oficiální zadání práce. Navrhni strukturu kapitol tak, aby každý bod zadání
> měl jasné místo. U každé kapitoly napiš její účel, potřebné podklady a očekávaný
> výsledek. Zatím nepiš hotový odborný text.

### Co Codex udělá

- vytáhne cíle, povinné části, omezení a očekávané výsledky;
- navrhne osnovu vedenou důkazy, nikoli jen obecnými názvy kapitol;
- ukáže, pro které části už podklady existují a kde chybí;
- nevydává návrh osnovy za schválení vedoucím.

### Co získáte

Pracovní mapu celé práce. Každá kapitola má důvod existence a seznam informací,
které bude potřeba získat.

## 4. Přidání odborného PDF a bezpečné citování

### Co napsat

> Přidej tento PDF článek mezi zdroje. Zaregistruj původ a licenci, připrav jej k
> vyhledávání a řekni mi, které konkrétní stránky podporují tvrzení o [téma].

### Co Codex udělá

- uloží originál do `zdroje/` a přidělí mu stabilní ID `SRC-NNNN`;
- zaznamená původ, kontrolní součet, bibliografické údaje a známá omezení;
- vytvoří odvozený text a stránkový index pro rychlé hledání;
- před citováním otevře původní nalezenou stránku;
- pokud zdroj tvrzení nepodporuje, označí mezeru v podkladech místo vytvoření falešné
  citace.

### Co získáte

Dohledatelný zdroj, který lze později znovu ověřit. Samotný souhrn nebo výstup AI
nenahrazuje původní odbornou publikaci.

## 5. Z poznámek vznikne pracovní kapitola

### Co napsat

> Tady jsou moje hrubé poznámky k metodice. Uspořádej je do logické podkapitoly.
> Nejasné údaje označ a na chybějící skutečnosti se zeptej. Nic odborného
> nedoplňuj jen proto, aby text působil hotově.

### Co Codex udělá

- rozliší doložené informace, autorské poznámky a chybějící údaje;
- navrhne strukturu a odstraní zbytečné opakování;
- zachová terminologii projektu a návaznost na okolní kapitoly;
- vloží pouze citace, které lze ověřit v registrovaných zdrojích;
- označí výstup jako návrh čekající na lidskou kontrolu.

### Co získáte

Čitelnou pracovní kapitolu se zřetelnými místy, která musí doplnit nebo potvrdit
autor.

## 6. Experimentální deník bez ztráty neúspěchů

### Co napsat

> Dnes jsme měřili vzorek B při rychlosti 20 metrů za minutu. Tenzometr na začátku
> kmital a druhé měření jsme opakovali. Zapiš to jako nový experiment a doptávej se
> jen na údaje důležité pro opakovatelnost.

### Co Codex udělá

- založí stabilní záznam `EXP-NNNN`;
- zachová datum, vzorek, zařízení, nastavení, postup, data, odchylky i neúspěchy;
- nevymyslí chybějící hodnotu a nepřepíše historii na „čistší“ verzi;
- propojí záznam s fotografiemi, daty a grafy;
- do hlavní práce později přenese jen výslovně vybrané a ověřené výsledky.

### Co získáte

Úplný praktický zdroj pravdy, ze kterého lze dohledat, jak konkrétní výsledek vznikl.

## 7. Ověření důležitého výpočtu

### Co napsat

> Z těchto vstupů vypočítej plošnou hmotnost. Uveď jednotky, předpoklady a přesnost,
> výsledek ověř nezávislým postupem a zatím jej nevkládej do závěru práce.

### Co Codex udělá

- vytvoří dohledatelný záznam `CALC-NNNN`;
- uchová vstupy, jednotky, předpoklady, rovnici a reprodukovatelný postup;
- provede nezávislou kontrolu vhodnou pro daný výpočet;
- upozorní na rozpor, nevhodné zaokrouhlení nebo chybějící nejistotu;
- nechá odbornou vhodnost a schválení na autorovi.

### Co získáte

Výsledek, který lze nejen opsat, ale také znovu přepočítat a obhájit jeho původ.

## 8. Graf z MATLABu nebo naměřených dat

### Co napsat

> Tady je MATLABový graf a zdrojová data. Připrav z něj editovatelný graf do práce,
> zachovej číselné hodnoty, zkontroluj jednotky, legendu a čitelnost ve výsledném PDF.

### Co Codex udělá

- podle dostupného vstupu vytáhne vykreslená data nebo použije dodaný export;
- uchová data v přenositelném souboru;
- vytvoří editovatelný TikZ/PGFPlots graf místo pouhého screenshotu, pokud je to
  technicky vhodné;
- porovná vykreslené řady s původními daty a zkontroluje sazbu v PDF;
- nemění naměřená data kvůli hezčímu vzhledu.

### Co získáte

Publikačně použitelný graf s dohledatelnými daty, který lze později upravit bez
ztráty kvality.

## 9. Odborný obrázek nebo schéma

### Co napsat

> V této části vysvětluji tok materiálu strojem. Posuď, zda pomůže schéma. Pokud ano,
> připrav jednoduchou odbornou variantu, popiš původ a vlož ji s popiskem a odkazem
> v textu.

### Co Codex udělá

- nejdřív rozhodne, zda vizuál opravdu něco vysvětluje;
- hledá vhodný podklad nejprve v projektových zdrojích;
- rozliší původní, převzatý, adaptovaný a AI vytvořený materiál;
- zachová licenci, věcný význam, popisek a stabilní křížový odkaz;
- nepoužije generativní úpravu naměřeného snímku jako odborný důkaz.

### Co získáte

Smysluplný a dohledatelný vizuál namísto dekorativního obrázku bez původu.

## 10. Fotografie a video z experimentu

### Co napsat

> Přikládám fotografii měřicí sestavy a krátké video problému při měření. Popiš jen
> to, co je skutečně viditelné, vyber z videa reprezentativní snímek s časem a
> připoj jej k experimentu. Připrav věcný popisek a navrhni, kam obrázek patří v
> dokumentu. Nejasné zařízení nebo děj si nech potvrdit.

### Co Codex udělá

- prohlédne fotografii a při dostupném místním nástroji také relevantní snímky videa;
- oddělí viditelné pozorování od uživatelova vysvětlení a vlastního odhadu;
- u vybraného videosnímku zachová časovou pozici a vazbu na původní video;
- uloží původ, popis povolených úprav a připraví faktický popisek i odkaz v textu;
- může provést pouze přiznaný ořez, otočení nebo převod formátu, který nemění význam;
- nebude generativně odstraňovat vady, měnit naměřený děj ani z fotografie hádat
  skryté nastavení, rozměry či přesný typ zařízení;
- pokud video nelze místně přečíst, oznámí omezení a požádá o snímek nebo povolený
  převod místo předstírání analýzy.

### Co získáte

Dohledatelnou experimentální fotografii nebo videosnímek s věcným popiskem,
proveniencí a jasným rozlišením mezi tím, co je vidět, a tím, co potvrdil autor.

## 11. Připomínky vedoucího

### Co napsat

> Tady jsou připomínky vedoucího. Rozděl je na konkrétní úkoly, najdi dotčená místa
> a nejdřív mi ukaž plán změn. Jednoznačné opravy potom zapracuj, nejasné body mi
> předlož k rozhodnutí.

### Co Codex udělá

- rozloží komentáře na dohledatelné položky a přiřadí je k souborům či částem;
- rozliší jasnou opravu, odborné rozhodnutí a požadavek vyžadující doplnění zdroje;
- zachová původní připomínku i stav jejího řešení;
- po změnách spustí odpovídající kontroly;
- netvrdí, že vedoucí změny schválil, dokud to skutečně nepotvrdí.

### Co získáte

Přehled, co bylo opraveno, co zůstává otevřené a proč.

## 12. Spolupráce s kolegou nebo vedoucím

### Co napsat odesílajícímu Codexu

> Připrav pro vedoucího předávací balíček kapitoly metodiky a souvisejícího grafu.
> Přidej stav práce, provedené kontroly a otevřené otázky. Nepřidávej osobní profil,
> tajné údaje ani jiné soubory, které jsem neurčil.

### Co napsat přijímajícímu Codexu

> Ověř přijatý balíček, porovnej každý navržený cíl s mojí prací a nejdřív mi ukaž
> konflikty. Nic automaticky nepřepisuj.

### Co Codex udělá

- vytvoří manifest s přenositelnými cestami, velikostmi a SHA-256;
- odmítne známé citlivé, generované a nebezpečné soubory;
- ZIP vytvoří až po dokončení popisu a úspěšném ověření;
- na přijímající straně znovu ověří integritu a připraví cílený diff;
- začlení jen odsouhlasené řešení konfliktů.

### Co získáte

Kontrolovatelnou spolupráci i mezi lidmi, kteří nemají jeden společný chat nebo
pracovní kopii. Funkční příklad je v [ukázce spolupráce](spoluprace/README.md).

## 13. Když sestavení PDF selže

### Co napsat

> PDF se nevytvořilo. Zjisti příčinu podle projektového postupu, vysvětli mi ji
> jednoduše a zatím nic neinstaluj.

### Co Codex udělá

- odliší chybu prostředí od chyby v dokumentu;
- použije projektový sled XeLaTeX → Biber → MakeIndex → XeLaTeX → XeLaTeX;
- lokalizuje první podstatnou chybu místo zahlcení celým logem;
- provede bezpečnou opravu, pokud byla požadována, a znovu sestaví dokument;
- bez souhlasu neinstaluje software, balíčky ani fonty.

### Co získáte

Srozumitelnou diagnózu a reprodukovatelný postup, nikoli náhodnou změnu kompilátoru.

## 14. Kontrola kapitoly před odevzdáním vedoucímu

### Co napsat

> Zkontroluj kapitolu výsledků. Posuď logiku, opakování, návaznost tvrzení na tabulky
> a zdroje a odděl technické chyby od věcí, které musím rozhodnout já.

### Co Codex udělá

- zkontroluje účel kapitoly, strukturu, terminologii, evidence a interpretaci;
- dohledá neověřené nebo příliš silné tvrzení;
- prověří odkazy na tabulky, obrázky, experimenty a zdroje;
- připraví seskupený kontrolní bod pro člověka;
- nikdy neschválí vlastní text místo autora nebo vedoucího.

### Co získáte

Konkrétní seznam oprav a krátký seznam odborných otázek, které automatická kontrola
nemůže rozhodnout.

## 15. Finální technická kontrola práce

### Co napsat

> Připrav práci k finální kontrole před odevzdáním. Proveď čisté sestavení, zkontroluj
> zdroje, citace, odkazy, placeholdery, fonty, formát stránek a výsledné PDF. Jasně
> odděl chyby, upozornění a věci pro mou kontrolu.

### Co Codex udělá

- spustí audit zdrojů a autoritativní čistý build;
- kontroluje chybějící PDF, citace, odkazy, duplicity, placeholdery a logy;
- ověří čitelnost, A4, vložené fonty a další dostupné vlastnosti PDF;
- odmítne finální BP/DP s pracovní titulní stranou místo oficiálních stránek IS STAG;
- vytvoří verdikt `PASS`, `WARN` nebo `FAIL`, ale negarantuje přijetí školou.

### Co získáte

Reprodukovatelný technický preflight a přesně vymezenou poslední lidskou kontrolu.

## 16. Příprava obhajoby

### Co napsat

> Z této práce připrav desetiminutový příběh obhajoby. Vyber problém, metodu, hlavní
> výsledky, omezení a přínos. Nepřidávej závěry, které nejsou doložené v práci.

### Co Codex udělá

- opře příběh o skutečný obsah, zadání, výsledky a známá omezení;
- navrhne časovou strukturu a obsah jednotlivých snímků;
- může vytvořit a technicky ověřit TUL Beamer prezentaci;
- připraví otázky pro nácvik obhajoby;
- nevyrábí „lepší“ výsledek, který v práci ve skutečnosti není.

### Co získáte

Soustředěnou obhajobu navázanou na ověřené části projektu, nikoli obecnou prezentaci
vytvořenou bez znalosti práce.

## Tři doporučené pracovní chaty

Chaty používají stejné soubory; pouze oddělují kontext rozhovorů.

### MAIN – hlavní práce

> Pracuj pouze na hlavním dokumentu `main` registrovaném v `PROJECT_CONTEXT.md`.
> Připravuj výsledný odborný text a přebírej jen důležité, ověřené a dohledatelné
> informace. Zachovej odkazy na experimenty, data, obrázky a zdroje.

### EXPERIMENTY – praktický deník

> Pracuj pouze na registrovaném praktickém dokumentu. Každému skutečnému pokusu
> přiděl stabilní ID `EXP-NNNN` a zachovávej úplný průběh včetně změn, chyb a
> neúspěchů. Nic automaticky nezkracuj pro hlavní práci.

### OTÁZKY A REŠERŠE – volitelné

> Tento chat používej pro otázky, hledání zdrojů a promýšlení variant. Hlavní ani
> praktický dokument neměň bez mého výslovného požadavku. Ověřené výsledky navrhni
> uložit na správné místo v projektu.

Chat `OBHAJOBA` má smysl přidat až ve chvíli, kdy skutečně začnete připravovat
prezentaci.

## Co šablona záměrně nedělá

- nevymýšlí chybějící výsledky, citace ani oficiální školní údaje;
- nezaměňuje úspěšnou kompilaci za odbornou správnost;
- nemaže neúspěšné experimenty z historie;
- nepřepisuje cizí nebo místní změny bez porovnání;
- neposílá citlivá data do externí služby bez vysvětlení a souhlasu;
- neinstaluje software nebo pluginy bez souhlasu;
- neprohlašuje práci za schválenou autorem, vedoucím, komisí nebo školou.

Právě tato omezení jsou součástí síly šablony: Codex má práci urychlit, ale zároveň
zachovat původ, kontrolovatelnost a odpovědnost autora.
