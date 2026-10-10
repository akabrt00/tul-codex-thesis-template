param([switch]$Strict)
$ErrorActionPreference = 'Stop'
$projectRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$problems = [Collections.Generic.List[string]]::new()
$warnings = [Collections.Generic.List[string]]::new()
foreach ($file in @('main.tex','nastaveni/udaje.tex','nastaveni/balicky.tex','literatura/zdroje.bib','tulthesis.cls','tul.sty','sablona/tulthesis.cls','sablona/tul.sty')) {
    if (!(Test-Path -LiteralPath (Join-Path $projectRoot $file) -PathType Leaf)) { $problems.Add("Chybí soubor: $file") }
}
if ($problems.Count -eq 0) {
    $main = [IO.File]::ReadAllText((Join-Path $projectRoot 'main.tex'))
    $data = [IO.File]::ReadAllText((Join-Path $projectRoot 'nastaveni/udaje.tex'))
    $bib = [IO.File]::ReadAllText((Join-Path $projectRoot 'literatura/zdroje.bib'))
    # TeX comments are removed for reference checks; escaped percent signs remain.
    $active = [regex]::Replace($main, '(?m)(?<!\\)%.*$', '')
    foreach ($file in @('main.tex','nastaveni/udaje.tex')) {
        $text = [IO.File]::ReadAllText((Join-Path $projectRoot $file))
        $todos = [regex]::Matches($text, '(?m)^\s*%\s*TODO:').Count
        if ($todos) { $warnings.Add("${file}: $todos nevyřízených komentářů TODO") }
    }
    foreach ($sample in @('Ukázková práce','Example thesis','Jméno Příjmení','KÓD','Název programu','Programme name','Název oboru','Field of study','Jméno vedoucího')) {
        if ($data.Contains($sample)) { $warnings.Add("Ukázkový údaj v nastaveni/udaje.tex: $sample") }
    }
    if ($active.Contains('ukazka-mereni.png')) { $warnings.Add('V práci je stále syntetický ukázkový graf.') }
    if ($active.Contains('satrapa-manual')) { $warnings.Add('V práci je ukázková citace; ověřte vlastní zdroj a bibliografické údaje.') }
    $labels = @([regex]::Matches($active, '\\label\{([^}]+)\}') | ForEach-Object { $_.Groups[1].Value })
    foreach ($group in ($labels | Group-Object | Where-Object Count -gt 1)) { $problems.Add("Duplicitní label: $($group.Name)") }
    foreach ($reference in [regex]::Matches($active, '\\(?:ref|pageref|autoref|eqref)\{([^}]+)\}')) {
        $key = $reference.Groups[1].Value
        if ($key -notin $labels) { $warnings.Add("Odkaz bez label v main.tex: $key (ověřte také případné vložené soubory)") }
    }
    $keys = @([regex]::Matches($bib, '@\w+\s*\{\s*([^,\s]+)\s*,') | ForEach-Object { $_.Groups[1].Value })
    foreach ($citation in [regex]::Matches($active, '\\(?:auto|text|paren)?cite(?:\[[^\]]*\])*\{([^}]+)\}')) {
        foreach ($key in $citation.Groups[1].Value.Split(',')) {
            if ($key.Trim() -notin $keys) { $warnings.Add("Citace bez záznamu v literatura/zdroje.bib: $($key.Trim())") }
        }
    }
}
foreach ($problem in $problems) { Write-Output "CHYBA: $problem" }
foreach ($warning in $warnings) { Write-Output "KONTROLA: $warning" }
Write-Output "Výsledek: $($problems.Count) chyb, $($warnings.Count) bodů k ruční kontrole. Sestavení ani obsah nejsou tímto ověřené."
if ($problems.Count -gt 0 -or ($Strict -and $warnings.Count -gt 0)) { exit 1 }
