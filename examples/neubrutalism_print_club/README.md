# Print Club

A standalone workshop site using the local Arcane Jaspr Neubrutalism renderer.
The fictional studio demonstrates Classic and NeuComic variants in light and dark appearances, responsive cards,
tabs, search, form validation, styled listboxes, radio cards, checkboxes, dialogs,
and toast notifications. Workshop plans stay in memory for the current visit;
the demo never reserves places or takes payments.

From this directory:

```sh
bash tool/build.sh
python3 -m http.server 4184 --bind 127.0.0.1 --directory build/web
```

Open [Classic light](http://127.0.0.1:4184),
[Classic dark](http://127.0.0.1:4184/?theme=dark),
[NeuComic light](http://127.0.0.1:4184/?variant=neucomic), or
[NeuComic dark](http://127.0.0.1:4184/?variant=neucomic&theme=dark).
The labeled Visual style and Corners selectors and Dark mode switch update the current URL
while preserving workshop filters, form entries, and the current plan.
Corners default to Square. Select Rounded or add `corners=rounded` to the URL;
the preference survives reloads and navigation between the workshop and gallery.
The build copies the library's Lucide font and bundles
the theme's display, heading, body, and monospace fonts without remote requests.
SVG print artwork is original source material in `web/prints`. NeuComic uses
separate inked illustrations: rolling and pulling a print, overlapping risograph
inks, a folded zine, and a screenprinted poster. Their halftones use opaque
spot-ink screens over cream paper. Dot area follows the local tone; cyan and
magenta screens use different angles and multiply to create violet where they
overlap. Yellow and magenta screens create the warm shading. Text, controls,
and page backgrounds stay solid; print effects remain inside the artwork.
These are stylized screen-print illustrations, not a color-managed press proof.
The build fingerprints the artwork URLs along with CSS and JavaScript so local
rebuilds show the current assets.

```sh
env -u GIT_CONFIG_COUNT dart analyze lib web/main.dart
```

## Component gallery

Open the [Classic gallery](http://127.0.0.1:4184/?view=components&variant=classic)
or [NeuComic gallery](http://127.0.0.1:4184/?view=components&variant=neucomic).
The gallery has 37 interactive fixtures covering all 104 renderer slots. Use the
appearance controls and group navigation to review inputs, navigation, overlays,
feedback, cards, and layout. The manifest in `lib/component_manifest.dart` records
the renderer slots exercised by each fixture. Menus, dialogs, rating controls,
forms, and counters respond to interaction; motion respects reduced-motion
preferences.
