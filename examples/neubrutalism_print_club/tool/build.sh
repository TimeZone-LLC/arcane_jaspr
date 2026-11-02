#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
env -u GIT_CONFIG_COUNT dart pub get
mkdir -p build/web/assets/fonts/lucide
print_artwork_revision="$(python3 - <<'PY_HASH'
from hashlib import sha256
from pathlib import Path

artwork = sorted(Path('web/prints').glob('*.svg'))
digest = sha256()
for path in artwork:
    digest.update(path.name.encode('utf-8'))
    digest.update(path.read_bytes())
print(digest.hexdigest()[:16])
PY_HASH
)"
env -u GIT_CONFIG_COUNT dart compile js -O2 -DPRINT_ARTWORK_REVISION="$print_artwork_revision" web/main.dart -o build/web/main.dart.js
cp web/print-club.css web/component-gallery.css build/web/
cp -R web/prints build/web/
cp ../../assets/fonts/lucide/lucide.woff2 build/web/assets/fonts/lucide/
python3 - <<'PY'
from hashlib import sha256
from pathlib import Path

build_dir = Path('build/web')
index = Path('web/index.html').read_text(encoding='utf-8')
for asset in ('print-club.css', 'component-gallery.css', 'main.dart.js'):
    digest = sha256((build_dir / asset).read_bytes()).hexdigest()[:16]
    index = index.replace(f'"/{asset}"', f'"/{asset}?v={digest}"')
(build_dir / 'index.html').write_text(index, encoding='utf-8')
PY
