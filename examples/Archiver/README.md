## Cleanup & Archiver

This script automatically detects, archives, and manages “trashed” screenshots from your device’s `DCIM/Screenshots` folder.

### Features

* Scans the `./../../DCIM/Screenshots` directory
* Detects files starting with `.trashed`
* (Optional) Moves or zips them into `./../../SS_Archive`
* (Optional) Deletes the originals after archiving
* Archives can be timestamped (e.g., `2025-10-14T11.20.45Z.zip`)

### How It Works

1. Read all files from the screenshot folder.
2. Create an output folder `SS_Archive` if it doesn’t exist.
3. Identify all trashed files (those starting with `.trashed`).
4. (If enabled) Add them into a ZIP archive and save it with the current date/time.
5. (If enabled) Remove originals after successful compression.

### Notes

* By default, the script only **prints trashed filenames** — all destructive actions are commented out for safety.
* Uncomment the copy, zip, and delete lines to fully automate cleanup.

### Example Output

```
Found 43 files
0 .trashed-IMG_0012.png
1 .trashed-IMG_0021.png
...
```

---
