#!/usr/bin/env bash
set -euo pipefail

# Ensures all posts have required SEO frontmatter fields.
# Run after syncing from Obsidian but before building.
# Adds missing: description, date, tags, layout

POSTS_DIR="${1:-/home/mike/dev/blog/src/posts}"

for file in "$POSTS_DIR"/*.md; do
  [ -f "$file" ] || continue
  filename="$(basename "$file")"

  # Check if file has frontmatter
  if ! head -1 "$file" | grep -q '^---'; then
    echo "[seo] WARN: $filename has no frontmatter, skipping"
    continue
  fi

  changed=false

  # Extract existing frontmatter
  frontmatter=$(sed -n '/^---$/,/^---$/p' "$file" | head -n -1 | tail -n +2)

  # Add description if missing — use first paragraph of content as fallback
  if ! echo "$frontmatter" | grep -q '^description:'; then
    # Grab first non-empty line after the closing ---
    first_para=$(awk '/^---$/{n++; next} n==1 && /[a-zA-Z]/{print; exit}' "$file" | head -c 155)
    if [ -n "$first_para" ]; then
      # Escape double quotes in the description
      first_para=$(echo "$first_para" | sed 's/"/\\"/g')
      sed -i "0,/^---$/! { 0,/^---$/ s/^---$/description: \"$first_para\"\n---/ }" "$file"
      echo "[seo] Added description to $filename"
      changed=true
    fi
  fi

  # Re-read frontmatter after possible changes
  frontmatter=$(sed -n '/^---$/,/^---$/p' "$file" | head -n -1 | tail -n +2)

  # Add layout if missing
  if ! echo "$frontmatter" | grep -q '^layout:'; then
    sed -i "0,/^---$/! { 0,/^---$/ s/^---$/layout: layouts\/post.njk\n---/ }" "$file"
    echo "[seo] Added layout to $filename"
    changed=true
  fi

  # Add date if missing (use file modification time)
  if ! echo "$frontmatter" | grep -q '^date:'; then
    file_date=$(date -r "$file" +%Y-%m-%d)
    sed -i "0,/^---$/! { 0,/^---$/ s/^---$/date: $file_date\n---/ }" "$file"
    echo "[seo] Added date ($file_date) to $filename"
    changed=true
  fi

  # Warn if description is too short or too long
  desc=$(echo "$frontmatter" | grep '^description:' | sed 's/^description: *//' | tr -d '"'"'")
  if [ -n "$desc" ]; then
    len=${#desc}
    if [ "$len" -lt 50 ]; then
      echo "[seo] WARN: $filename description is short ($len chars, aim for 50-160)"
    elif [ "$len" -gt 160 ]; then
      echo "[seo] WARN: $filename description is too long ($len chars, aim for 50-160)"
    fi
  fi

  if [ "$changed" = true ]; then
    echo "[seo] Updated $filename"
  fi
done

echo "[seo] Frontmatter check complete."
