#!/usr/bin/env bash
set -euo pipefail

BLOG_DIR="/home/mike/dev/blog"

cd "$BLOG_DIR"

echo "==> Syncing from Obsidian..."
bash scripts/sync-obsidian.sh

echo "==> Checking SEO frontmatter..."
bash scripts/seo-frontmatter.sh

echo "==> Building site..."
npx @11ty/eleventy

echo "==> Deploying to server..."
rsync -avz --delete _site/ mike@blog.miker.be:/var/www/blog/

echo "==> Done."
