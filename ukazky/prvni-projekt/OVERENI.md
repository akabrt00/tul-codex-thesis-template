# Ověření šablony 6. 10. 2026

V odděleném syntetickém projektu proběhl celý postup: profil → inicializace →
čisté sestavení práce → technický preflight → kontrola deklarace AI v PDF →
sestavení prezentace. Původní `templates/upstream/` zůstaly beze změny.

| Výsledek | Ověření |
|---|---|
| Práce | 13 stran A4, přesně jedna aktivní titulní varianta, 7 vložených fontů |
| Bibliografie a odkazy | Testovací záznam se sestavil přes Biber; žádné nevyřešené citace, odkazy nebo duplicitní značky |
| Deklarace AI | Celý skutečný text deklarace nalezen v PDF; odlišný text správně odmítnut |
| Prezentace | 3 snímky, 4 vložené fonty, žádná substituce fontů ani přetečení textu |
| Vizuální kontrola | Titulní strana, obsah, deklarace a literatura práce; všechny 3 snímky prezentace |
| Regresní testy | Inicializace, negativní AI evidence, preflight, skills/routing, výpočty/review, předávání balíčků a schema místních nástrojů |
| Lint a zdroje | Bez strukturálních chyb, audit registrovaných zdrojů prošel |

Build práce: XeLaTeX → Biber → MakeIndex → XeLaTeX → XeLaTeX. Prezentace:
XeLaTeX dvakrát. Použit stávající MiKTeX, Poppler a Windows PowerShell; nebyl
instalován žádný program nebo font.

Zbývající technická upozornění: nepřítomný volitelný qpdf; u pracovní titulní
varianty práce hlášení overfull a fancyhdr převzatého stylu (kontrolované
strany neměly viditelné oříznutí); testovací generované titulní strany nejsou
oficiální IS STAG PDF. Prezentace nemá bibliografii, protože syntetický
obsahový snímek neobsahuje odborná tvrzení. Úplný text evidence vždy zůstává
k lidské kontrole; test nepotvrzuje odbornou správnost ani univerzitní schválení
konkrétního AI systému. CI bez TeXu uvádí sestavení jako přeskočené, nikoli ověřené.
