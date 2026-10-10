# Kontrola vlastní práce

Tento seznam není potvrzením požadavků fakulty. Body odškrtněte až po vlastní kontrole.

- [ ] Fakulta, typ práce, jméno, vedoucí, program, obor a rok odpovídají zadání.
- [ ] Úvodní listy a prohlášení odpovídají aktuálním pokynům fakulty / IS/STAG.
- [ ] Český a anglický název, abstrakty i klíčová slova jsou vlastní a vzájemně odpovídají.
- [ ] V main.tex ani nastaveni/udaje.tex nezůstaly nevyřízené komentáře TODO.
- [ ] Syntetická tabulka, graf a ukázkový bibliografický záznam jsou nahrazené nebo odstraněné i se souvisejícími odkazy.
- [ ] Každá citace vychází z existujícího přečteného zdroje a jeho údaje jsou ověřené.
- [ ] PDF neobsahuje otazníky místo odkazů či citací. Obsah, seznam literatury a přílohy jsou úplné.
- [ ] V náhledu jsou čitelné české znaky, celé obrázky a tabulky; nic nepřesahuje okraje.
- [ ] Finální PDF jsem stáhl/a a prohlédl/a mimo editor. Uložil/a jsem také zdrojový ZIP.

## Volitelná kontrola místní kopie

V PowerShellu z kořene projektu:

```powershell
./nastroje/zkontrolovat.ps1
```

Skript zkontroluje potřebné soubory, známé ukázkové údaje, komentáře TODO a odkazy v main.tex. Nepřekládá dokument, neposílá data a nic neupravuje. Varování jsou ve výchozí ukázce očekávaná. Po vyplnění vlastní práce lze použít `-Strict`, který vrátí neúspěch i při zbývajících varováních. Výsledek nenahrazuje sestavení a odbornou ani fakultní kontrolu.
