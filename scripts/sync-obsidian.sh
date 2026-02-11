#!/usr/bin/env bash
set -euo pipefail

OBSIDIAN_DIR="/home/mike/Documents/obsidian/2. Areas/blog"
BLOG_DIR="/home/mike/dev/blog"

# Sync markdown posts
rsync -av --delete \
  --exclude='.obsidian/' \
  --exclude='.trash/' \
  --exclude='*.canvas' \
  --exclude='images/' \
  --exclude='*.json' \
  "$OBSIDIAN_DIR/" "$BLOG_DIR/src/posts/"

# Sync images
if [ -d "$OBSIDIAN_DIR/images/" ]; then
  rsync -av --delete \
    "$OBSIDIAN_DIR/images/" "$BLOG_DIR/src/posts/images/"
fi

# Convert Obsidian wiki-style image links to standard markdown
# ![[image.png]] → ![](images/image.png)
# ![[image.png|alt text]] → ![alt text](images/image.png)
find "$BLOG_DIR/src/posts/" -name '*.md' -exec sed -i \
  -e 's/!\[\[\([^]|]*\)|\([^]]*\)\]\]/![\2](\/posts\/images\/\1)/g' \
  -e 's/!\[\[\([^]]*\)\]\]/![](\/posts\/images\/\1)/g' \
  -e 's|(images/|(/posts/images/|g' \
  {} +

echo "Sync complete."
