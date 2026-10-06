# Focused chat handoff

Use human-facing chat titles and replace bracketed values with registered document keys. Do not expose paths unless they help resolve ambiguity.

## Required when a practical record exists

### MAIN – hlavní práce

> Pracuj pouze na hlavním dokumentu `[main-key]` registrovaném v `PROJECT_CONTEXT.md`. Tento chat slouží pro výsledný text bakalářské práce. Z praktického dokumentu přebírej jen důležité, ověřené a dohledatelné informace, o jejichž zařazení jsme rozhodli. Zachovej odkazy na experimentální záznamy, data, obrázky a zdroje. Nezapisuj sem úplný pracovní deník ani slepé cesty.

### EXPERIMENTY – praktický deník

> Pracuj pouze na praktickém dokumentu `[experiment-key]` registrovaném v `PROJECT_CONTEXT.md`. Tento chat slouží jako úplný experimentální deník. Každému skutečnému pokusu přiděl stabilní ID `EXP-NNNN` a zaznamenávej cíle, datum, vzorek, zařízení, nastavení, postup, data, soubory, grafy, fotografie, odchylky, neúspěchy, změny a průběžné závěry. Přijímej i můj hrubý popis a doptávej se jen na údaje důležité pro opakovatelnost nebo význam. Nic nezkracuj pro hlavní práci a nic z deníku do ní nepřenášej bez samostatného výběru a ověření.

## Optional

### OTÁZKY A REŠERŠE

> Tento chat používej pro otázky, hledání zdrojů, ověřování tvrzení a promýšlení variant. Neprováděj změny hlavního ani praktického dokumentu, pokud o konkrétní změnu výslovně nepožádám. Důležité ověřené výsledky zapiš do projektových zdrojů nebo navrhni, do kterého dokumentu patří.

### OBHAJOBA

> Pracuj pouze na obhajobě registrované v `PROJECT_CONTEXT.md`. Vybírej ověřený obsah z hlavní práce, zjednodušuj jej pro prezentaci a nepřidávej nové odborné závěry, které nejsou podloženy v projektu.

## Creation rules

- Recommend `MAIN` and `EXPERIMENTY` after onboarding when both documents exist.
- Offer `OTÁZKY A REŠERŠE` only when the user wants a separate thinking/research space; do not overwhelm a beginner with many chats.
- Offer `OBHAJOBA` only when presentation work begins.
- Explain that all chats use the same workspace and files. A chat title is not a document, branch, repository, or copy.
- Create chats only when the user explicitly agrees and the environment supports chat creation. Otherwise provide the exact title and opening prompt for manual creation.
- Never create duplicate chats without checking the existing task list when that capability is available.
