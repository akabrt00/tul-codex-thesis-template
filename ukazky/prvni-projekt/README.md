# Nejdřív bezpečné cvičení: první PDF s Codexem

Tato cesta vyzkouší technické prostředí bez skutečné práce, jména, zadání,
nepublikovaných měření nebo dalších chráněných podkladů. Nevyžaduje instalaci
nového programu ani GitHub účet. Projekt šablony zůstane neinicializovaný;
cvičení vzniká v oddělené ignorované složce `.ci-work/`.

## Co napsat agentovi

> Chci si nejdřív vyzkoušet šablonu se smyšlenými údaji. Přečti AGENTS.md,
> PROJECT_CONTEXT.md a AI_NA_TUL.md. Spusť tests/test-build-smoke.ps1 s novou
> nepoužitou podsložkou .ci-work/ pro práci, novou podsložkou .ci-artifacts/ pro
> výsledky a přepínačem KeepWork. Použij pouze syntetická data testu; mužská
> varianta titulní strany je součást testovacího příkladu a neurčuje moje údaje.
> Nic neinstaluj ani nenahrávej. Ukaž mi výslednou práci a prezentaci, shrň
> kontroly a vysvětli každý krok od profilu po PDF. Pokud nástroj chybí nebo test
> selže, napiš přesně, co nebylo ověřeno.

Agent může spustit například:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tests\test-build-smoke.ps1 -WorkDir .ci-work/prvni-pokus -ArtifactDir .ci-artifacts/prvni-pokus -KeepWork
```

**Před spuštěním ověří, že obě zvolené složky neexistují.** Smoke test je určen
pro testovací složky a jeho výchozí chování umí jejich obsah odstranit. Nikdy mu
nepředávejte složku skutečné práce. Automatický test je technické cvičení, nikoli
průvodce psaním odborné kapitoly.

## Co vznikne a co uvidíte

- Lokální profil obsahuje výhradně smyšlené testovací hodnoty.
- Práce má právě jednu cvičnou titulní variantu, kapitoly a testovací bibliografii.
  Bibliografický záznam CI fixture je výslovně testovací; nepoužívejte ho jako zdroj.
- Prezentace má titulní snímek, jeden obsahový snímek a závěrečný snímek.
  Písma Inter se načítají z přibalených souborů se zachovanou licencí.
- Práce obsahuje ukázkovou deklaraci skutečného původu cvičení. Kontrola vyhledá
  celý její text v PDF a ověří také odmítnutí deklarace, která v PDF není.
- JSON reporty zachycují technické výsledky. Potvrzení autora zůstává otevřené;
  test neprokazuje institucionální schválení ani správnost odborného obsahu.

Nechte si otevřít PDF a zkontrolujte titulní stranu, obsah, kapitoly a konec.
U prezentace ověřte čitelnost všech tří snímků. Napište například:

> V cvičném projektu změň nadpis prvního obsahového snímku a přidej moji větu
> „Toto je můj první pokus.“ Zapiš skutečný zásah do cvičné evidence použití AI,
> znovu sestav PDF a ukaž mi změnu. Neoznačuj kontrolu agentem za moje schválení.

## Potom vlastní projekt

Až cvičení funguje, pokračujte [START_HERE.md](../../START_HERE.md). Agent se
zeptá na skutečné známé údaje, titulní variantu, pravidla úlohy a vhodné ukládání.
Testovací profil, bibliografii a deklaraci nepřenášejte do skutečné práce.
Podstatné použití AI evidujte od začátku podle skutečnosti; před odevzdáním
vyberte formu deklarace podle pokynů školy. Oficiální úvodní PDF IS STAG se nemění.
