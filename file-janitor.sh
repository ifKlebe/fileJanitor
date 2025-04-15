#!/bin/bash
# Dynamisch das aktuelle Jahr holen
YEAR=$(date +%Y)
# Scriptname dynamisch holen
SCRIPT_NAME=$(basename "$0")
# Print general information
echo "File Janitor, $YEAR"
echo "Powered by Bash"
echo ""
# Wenn keine Argumente oder ungültige Optionen übergeben wurden
if [[ $# -eq 0 ]]; then
    echo "Type $SCRIPT_NAME help to see available options"
    exit 1
fi
# Hilfe anzeigen
if [[ "$1" == "help" ]]; then
    if [[ -f "file-janitor-help.txt" ]]; then
        cat "file-janitor-help.txt"
    else
        echo "Help file not found: file-janitor-help.txt"
    fi
    exit 0
fi
# Option "list"
if [[ "$1" == "list" ]]; then
    # Wenn kein Pfad übergeben wurde
    if [[ -z "$2" ]]; then
        echo "Listing files in the current directory"
        ls -A1 | sort
    else
        TARGET="$2"
        if [[ ! -e "$TARGET" ]]; then
            echo "$TARGET is not found"
        elif [[ ! -d "$TARGET" ]]; then
            echo "$TARGET is not a directory"
        else
            echo "Listing files in $TARGET"
            ls -A1 "$TARGET" | sort
        fi
    fi
    exit 0
fi
if [[ "$1" == "report" ]]; then
    if [[ -z "$2" ]]; then
        TARGET="."
        echo "The current directory contains:"
    else
        TARGET="$2"
        if [[ ! -e "$TARGET" ]]; then
            echo "$TARGET is not found"
            exit 1
        elif [[ ! -d "$TARGET" ]]; then
            echo "$TARGET is not a directory"
            exit 1
        else
            echo "$TARGET contains:"
        fi
    fi

    # .tmp files
    TMP_COUNT=$(find "$TARGET" -maxdepth 1 -type f -name "*.tmp" | wc -l)
    TMP_SIZE=0
    if [[ "$TMP_COUNT" -gt 0 ]]; then
        TMP_SIZE=$(find "$TARGET" -maxdepth 1 -type f -name "*.tmp" -exec du -b {} + | awk '{s+=$1} END{print s}')
    fi
    echo "$TMP_COUNT tmp file(s), with total size of $TMP_SIZE bytes"

    # .log files
    LOG_COUNT=$(find "$TARGET" -maxdepth 1 -type f -name "*.log" | wc -l)
    LOG_SIZE=0
    if [[ "$LOG_COUNT" -gt 0 ]]; then
        LOG_SIZE=$(find "$TARGET" -maxdepth 1 -type f -name "*.log" -exec du -b {} + | awk '{s+=$1} END{print s}')
    fi
    echo "$LOG_COUNT log file(s), with total size of $LOG_SIZE bytes"

    # .py files – immer anzeigen, auch bei 0
    PY_COUNT=$(find "$TARGET" -maxdepth 1 -type f -name "*.py" | wc -l)
    PY_SIZE=0
    if [[ "$PY_COUNT" -gt 0 ]]; then
        PY_SIZE=$(find "$TARGET" -maxdepth 1 -type f -name "*.py" -exec du -b {} + | awk '{s+=$1} END{print s}')
    fi
    echo "$PY_COUNT py file(s), with total size of $PY_SIZE bytes"

    exit 0
fi

# Option "clean"
if [[ "$1" == "clean" ]]; then
    if [[ -z "$2" ]]; then
        TARGET="."
        echo "Cleaning the current directory..."
        CLEAN_TARGET="the current directory"
    else
        TARGET="$2"
        if [[ ! -e "$TARGET" ]]; then
            echo "$TARGET is not found"
            exit 1
        elif [[ ! -d "$TARGET" ]]; then
            echo "$TARGET is not a directory"
            exit 1
        else
            echo "Cleaning $TARGET..."
            CLEAN_TARGET="$TARGET"
        fi
    fi

    # Delete old .log files (older than 3 days)
    echo -n "Deleting old log files... "
    LOG_COUNT=$(find "$TARGET" -maxdepth 1 -type f -name "*.log" -mtime +3 | wc -l)
    find "$TARGET" -maxdepth 1 -type f -name "*.log" -mtime +3 -exec rm -f {} +
    echo "done! $LOG_COUNT files have been deleted"

    # Delete .tmp files
    echo -n "Deleting temporary files... "
    TMP_COUNT=$(find "$TARGET" -maxdepth 1 -type f -name "*.tmp" | wc -l)
    find "$TARGET" -maxdepth 1 -type f -name "*.tmp" -exec rm -f {} +
    echo "done! $TMP_COUNT files have been deleted"

    # Move .py files
    echo -n "Moving python files... "
    
    # Suche nach .py-Dateien, speichere sie in ein Array
    mapfile -t PY_FILES < <(find "$TARGET" -maxdepth 1 -type f -name "*.py")
    PY_COUNT=${#PY_FILES[@]}
    
    if [[ "$PY_COUNT" -gt 0 ]]; then
        mkdir -p "$TARGET/python_scripts"
        for file in "${PY_FILES[@]}"; do
            mv "$file" "$TARGET/python_scripts/"
        done
    fi
    echo "done! $PY_COUNT files have been moved"

    echo ""
    echo "Clean up of $CLEAN_TARGET is complete!"
    exit 0
fi

# Wenn eine ungültige Option übergeben wurde
echo "Type $SCRIPT_NAME help to see available options"
exit 1