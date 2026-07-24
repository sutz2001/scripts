# Repository Rules (Copilot)

## Synchronisation Pflicht
Diese Datei und .clinerules/rules.md muessen immer inhaltlich abgeglichen sein und auf demselben Stand bleiben.
Bei jeder Aenderung an einer der beiden Dateien muss die andere Datei im selben Commit mit aktualisiert werden.

## Kontext
Dieses Repository enthaelt kleine, wiederverwendbare Administrationsskripte fuer SQL Server, PowerShell und VBScript.

## Allgemeine Regeln
- Nur gezielte, minimale und sichere Aenderungen vornehmen.
- Vorhandene Ordnerstruktur und Dateibenennung beibehalten.
- Dateinamen im bestehenden Stil halten: lowercase, Bindestriche, sprechende Namen.
- Platzhalterwerte klar kennzeichnen (z. B. YOUR_SERVER, YOUR_DATABASE).
- Keine Zugangsdaten, Tokens oder Umgebungsgeheimnisse in Dateien eintragen.
- Neue Skripte immer im fachlich passenden Unterordner anlegen.

## SQL-Regeln
- Auf SQL Server 2016+ ausrichten, sofern nicht explizit anders gefordert.
- Lesende Skripte von schreibenden/deployenden Skripten klar trennen.
- Potenziell riskante Befehle (ALTER, DROP, DELETE, UPDATE ohne WHERE) nur mit klarer Absicherung und Kommentar verwenden.
- Skripte so schreiben, dass sie in fremden Umgebungen mit minimaler Anpassung lauffaehig sind.

## PowerShell-Regeln
- Defensive Defaults verwenden (z. B. aussagekraeftige Fehlermeldungen, klare Parameter).
- Keine hartkodierten Server-, Pfad- oder Zugangsdatenwerte.
- Bei datei- oder systemveraendernden Schritten transparent dokumentieren, was passiert.

## VBScript-Regeln
- Bestehenden Stil und einfache Wartbarkeit priorisieren.
- Seiteneffekte (z. B. Aenderungen an AD/Benutzerkontext) nur klar nachvollziehbar implementieren.

## Dokumentation
- Bei neuen oder verschobenen Skripten die Struktur in README.md aktualisieren.
- Kurz dokumentieren, welche Platzhalter vor Ausfuehrung ersetzt werden muessen.
