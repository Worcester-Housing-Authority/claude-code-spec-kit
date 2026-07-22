#!/usr/bin/env bash
# Create a new Architecture Decision Record (ADR) from the decision template
# Usage: ./create-new-adr.sh "decision title"
#        ./create-new-adr.sh --json "decision title"

set -e

JSON_MODE=false

# Collect non-flag args
ARGS=()
for arg in "$@"; do
    case "$arg" in
        --json)
            JSON_MODE=true
            ;;
        --help|-h)
            echo "Usage: $0 [--json] <decision_title>"; exit 0 ;;
        *)
            ARGS+=("$arg") ;;
    esac
done

ADR_TITLE="${ARGS[*]}"
if [ -z "$ADR_TITLE" ]; then
        echo "Usage: $0 [--json] <decision_title>" >&2
        exit 1
fi

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

REPO_ROOT=$(get_repo_root)
ADR_DIR="$REPO_ROOT/docs/decisions"

# Create decisions directory if it doesn't exist
mkdir -p "$ADR_DIR"

# Find the highest numbered ADR
HIGHEST=0
if [ -d "$ADR_DIR" ]; then
    for file in "$ADR_DIR"/ADR-*.md; do
        [ -e "$file" ] || continue
        filename=$(basename "$file")
        number=$(echo "$filename" | grep -o '^ADR-[0-9]\+' | grep -o '[0-9]\+' || echo "0")
        number=$((10#$number))
        if [ "$number" -gt "$HIGHEST" ]; then
            HIGHEST=$number
        fi
    done
fi

# Generate next ADR number with zero padding
NEXT=$((HIGHEST + 1))
ADR_NUM=$(printf "%03d" "$NEXT")

# Create slug from title
SLUG=$(echo "$ADR_TITLE" | \
    tr '[:upper:]' '[:lower:]' | \
    sed 's/[^a-z0-9]/-/g' | \
    sed 's/-\+/-/g' | \
    sed 's/^-//' | \
    sed 's/-$//')

ADR_FILE="$ADR_DIR/ADR-${ADR_NUM}-${SLUG}.md"

# Copy template if it exists and fill in number/title
TEMPLATE="$REPO_ROOT/templates/decision-template.md"

if [ -f "$TEMPLATE" ]; then
    sed "s/ADR-000: <Title>/ADR-${ADR_NUM}: ${ADR_TITLE}/" "$TEMPLATE" > "$ADR_FILE"
else
    echo "Warning: Template not found at $TEMPLATE" >&2
    printf '# ADR-%s: %s\n' "$ADR_NUM" "$ADR_TITLE" > "$ADR_FILE"
fi

if $JSON_MODE; then
    printf '{"ADR_NUM":"%s","ADR_FILE":"%s","ADR_DIR":"%s","ADR_TITLE":"%s"}\n' \
        "$ADR_NUM" "$ADR_FILE" "$ADR_DIR" "$ADR_TITLE"
else
    # Output results for the LLM to use (legacy key: value format)
    echo "ADR_NUM: $ADR_NUM"
    echo "ADR_FILE: $ADR_FILE"
    echo "ADR_DIR: $ADR_DIR"
    echo "ADR_TITLE: $ADR_TITLE"
fi
