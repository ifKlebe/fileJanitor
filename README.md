[OLD SCRIPT]

# File Janitor

**File Janitor** ist ein praktisches Bash-Skript zum Aufräumen, Auflisten und Berichten über Dateien in einem Verzeichnis.  
Ideal für Entwickler:innen und Systemadministrator:innen, die regelmäßig temporäre, Log- oder Python-Dateien verwalten möchten.

## 🛠 Features

- 🔍 Auflisten von Dateien in einem Verzeichnis
- 📊 Berichte über `.log`, `.tmp` und `.py` Dateien
- 🧹 Automatisches Aufräumen von temporären Dateien und alten Log-Dateien
- 📦 Automatisches Verschieben von Python-Dateien in ein Unterverzeichnis `python_scripts/`
- 📄 Dynamische Hilfe über externe Textdatei (`file-janitor-help.txt`)
- 🗓 Automatische Anzeige des aktuellen Jahres im Header

---

## 📦 Installation

```bash
chmod +x file-janitor.sh
