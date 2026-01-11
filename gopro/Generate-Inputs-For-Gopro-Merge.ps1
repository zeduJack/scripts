$Date = "2024-09-26"

# Verzeichnis mit GoPro-Videos (anpassen, falls nötig)
$videoDir = "/Users/zedu/Movies/100GOPRO"
Set-Location $videoDir

# Versuche, das Datum korrekt zu parsen
try {
    $targetDate = [DateTime]::ParseExact($Date, "yyyy-MM-dd", $null)
} catch {
    Write-Error "❌ Ungültiges Datumsformat. Bitte verwende yyyy-MM-dd, z. B. 2026-01-09"
    exit 1
}

# Dateien filtern und sortieren
$files = Get-ChildItem -Filter *.MP4 | Where-Object {
    $_.CreationTime.Date -eq $targetDate.Date
} | Sort-Object CreationTime

# Ausgabe-Datei vorbereiten
$outFile = "inputs.txt"
if ($files.Count -eq 0) {
    Write-Warning "⚠️ Keine Videos gefunden für das Datum $Date im Ordner: $videoDir"
} else {
    Remove-Item -Force $outFile -ErrorAction SilentlyContinue
    $files | ForEach-Object {
        "file '$($_.Name)'" | Out-File -Append -Encoding UTF8 $outFile
    }
    Write-Host "✅ inputs.txt erstellt mit $($files.Count) Videos vom $Date."
}
