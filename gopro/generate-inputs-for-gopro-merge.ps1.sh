#!/bin/bash

# Ordner mit den Videos (anpassen bei Bedarf)
VIDEO_DIR="/Users/zedu/Movies/100GOPRO"
cd "$VIDEO_DIR" || exit 1

# Fixes Datum (statt gestern)
TARGET_DATE="2024-09-26"

# Output-Datei
OUTPUT="inputs.txt"
> "$OUTPUT"

# Alle MP4-Dateien durchgehen
for file in *.MP4; do
  # Hole Erstellungsdatum (ISO-Format)
  CREATED=$(mdls -name kMDItemContentCreationDate -raw "$file" | cut -d ' ' -f 1)

  # Wenn Erstellungsdatum übereinstimmt
  if [[ "$CREATED" == "$TARGET_DATE" ]]; then
    echo "$file" >> .tempfiles.txt
  fi
done

# Nach Dateierstellzeit sortieren (mit stat) und inputs.txt erstellen
if [[ -f .tempfiles.txt ]]; then
  while read -r fname; do
    echo "$(stat -f "%B $fname")"
  done < .tempfiles.txt | sort -n | cut -d' ' -f2- | while read -r sortedfile; do
    echo "file '$sortedfile'" >> "$OUTPUT"
  done
  rm .tempfiles.txt
  echo "✅ inputs.txt erfolgreich erstellt mit allen Videos vom $TARGET_DATE, in richtiger Reihenfolge."
else
  echo "⚠️ Keine Videos vom $TARGET_DATE gefunden."
fi
