# TUL LaTeX diagnostic routing

| Symptom | First evidence | Preferred route |
|---|---|---|
| No TeX executable | environment report | project check, then optional `latex-doctor` |
| First XeLaTeX pass fails | first-pass log | missing file, class, package, font, syntax, or encoding |
| Biber fails or hangs | `.bcf`, Biber log, timeout | verify Biber and BibLaTeX compatibility; do not claim citations resolved |
| MakeIndex fails | `.idx` and MakeIndex output | inspect index input and executable |
| Citations or references unresolved | final log after all passes | verify full multi-pass sequence and source keys |
| Generic plugin builds but project script fails | both command traces | trust the TUL workflow requirements; compare engines and skipped stages |
| Tectonic fails | dependency and feature scan | use the established XeLaTeX/Biber/MakeIndex workflow |
| PDF exists but looks wrong | rendered pages | visual validation, fonts, page size, front matter, headers, and overflow |
| Czech text is corrupted | source encoding and generated `.tex` | require explicit UTF-8 reads and writes on Windows PowerShell 5 |

Never treat a smoke test as a full TUL build, and never treat a full build as human approval of content.
