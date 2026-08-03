# Citační a zdrojová politika TUL

## Provenience

Tento projektový výtah vychází z těchto primárních zdrojů:

- `SRC-0003` / `SRC-0003_metodika-citovani-tul-2023` — Metodika citování TUL, 3. upravené vydání, 2023;
- `SRC-0004` / `SRC-0004_smernice-rektora-5-2018` — Směrnice rektora TUL č. 5/2018, revize 04;
- `SRC-0005` / `SRC-0005_smernice-rektora-4-2023-ai` — Směrnice rektora č. 4/2023 k využití AI.

Záznamy a oficiální URL jsou v `zdroje/REJSTRIK_ZDROJU.md`. Tento soubor je praktický výtah, nikoli náhrada úplného znění zdrojů nebo aktuálních fakultních pravidel.

## Pořadí autority

1. Aktuální závazná směrnice fakulty nebo univerzity.
2. Aktuální zadání a výslovné pokyny vedoucího práce.
3. Metodika citování TUL.
4. Nastavení citačního balíku nebo referenčního manažeru.

Při rozporu se nesmí automaticky upřednostnit výstup softwaru. Pravidla fakulty se musí ověřit a rozhodnutí zaznamenat v `PROJECT_CONTEXT.md`.

## Výchozí systém

- V celém dokumentu používat jediný citační systém, jednotný formát a interpunkci.
- Pro technické obory metodika doporučuje číselný systém; TUL u něj doporučuje hranaté závorky.
- Čísla zdrojů přidělovat podle prvního výskytu v textu, při dalším použití zachovat stejné číslo a seznam literatury řadit číselně.
- Fakultní nebo oborový požadavek může určit jiný systém, například autor–datum. Onboarding musí systém potvrdit, ne odhadnout pouze podle názvu fakulty.
- Volba `style=iso-numeric` nebo `style=iso-authoryear` sama o sobě nedokazuje plný soulad s ČSN ISO 690:2022 a pravidly TUL; výsledné záznamy se musí zkontrolovat.

## Citace v textu

- Citaci vložit bezprostředně za konkrétní převzaté tvrzení. Neslučovat informace z více zdrojů do odstavce a nepřidávat všechny citace až na jeho konec.
- Přímou citaci převzít přesně, zřetelně ji označit a uvést stránku, pokud je zdroj stránkovaný.
- Parafrázi formulovat vlastními slovy bez změny významu; pouhá záměna několika slov za synonyma není parafráze. Stránka není povinná, ale lze ji doplnit pro přesnější dohledání.
- Citovat převzaté myšlenky, texty, obrázky, tabulky, grafy, data, části vlastních dřívějších prací i data použitá ve vlastním grafu nebo tabulce.
- Sekundární citace používat jen výjimečně. Přednostně dohledat a ověřit původní zdroj.
- Automaticky vytvořená metadata vždy ověřit podle primárního informačního zdroje.

## Seznam literatury a evidence

- Seznam musí obsahovat všechny skutečně použité bibliografické, informační a datové zdroje, cizí i vlastní.
- Každá citace v textu musí mít odpovídající bibliografický záznam a každý záznam v seznamu musí být v dokumentu skutečně použit, pokud fakultní pravidla výslovně neurčí jinak.
- V LaTeXu používat `citacni_klic` z registru. Interní `SRC-NNNN` zachovat pro dohledatelnost, ale nepoužívat ho jako náhradu veřejné bibliografické citace.
- U citátu nebo tvrzení závislého na konkrétní části PDF zachovat číslo fyzické stránky zdroje.

## Použití AI

- Za správnost výsledku odpovídá autor práce, nikoli AI.
- Výstupy AI kriticky kontrolovat proti odborným a primárním zdrojům.
- AI není spoluautor a podle směrnice TUL se neuvádí v seznamu použité literatury.
- Použití AI výslovně přiznat v textu, uvést konkrétní nástroj a podle rozsahu také části práce, ve kterých byl použit. Bez upřesnění se deklarace vztahuje na celou práci.
- Přesné znění deklarace přizpůsobit skutečně použitému nástroji, jeho verzi a rozsahu práce; nevkládat nepravdivý nebo obecný placeholder.

## Kontrola před odevzdáním

- Ověřit zvolený systém proti aktuálním pravidlům fakulty a pokynům vedoucího.
- Zkontrolovat pořadí čísel, opakované odkazy, stránky přímých citací a úplnost bibliografie.
- Zkontrolovat autory, názvy, vydání, rok, identifikátory, DOI/URL a datum citování podle původního zdroje.
- Ověřit, že obrázky, tabulky a datové podklady mají zdroj přímo u popisku nebo na místě požadovaném fakultou.
- Ověřit, že deklarace použití AI odpovídá skutečnému workflow.
