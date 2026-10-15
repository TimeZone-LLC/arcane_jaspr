/// The entrypoint for the **server** app (static generation).
library;

import 'package:arcane_lexicon/arcane_lexicon.dart' hide runApp;
import 'package:arcane_jaspr_ascii/arcane_jaspr_ascii.dart';
import 'package:arcane_jaspr_neon/arcane_jaspr_neon.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';
import 'package:arcane_jaspr_win95/arcane_jaspr_win95.dart';
import 'package:arcane_jaspr_kb/arcane_jaspr_kb.dart';
import 'package:jaspr/server.dart';

import 'package:arcane_neon_web/components/ascii_showcase.dart';
import 'package:arcane_neon_web/components/interactive_demo.dart';
import 'package:arcane_neon_web/main.server.options.dart';

/// Base URL for the site (for GitHub Pages subdirectory hosting)
const String baseUrl = String.fromEnvironment('BASE_URL', defaultValue: '');
const ArcaneStylesheet shadcnStylesheet = ShadcnStylesheet(
  theme: ShadcnTheme.midnight,
);
const ArcaneStylesheet shadcnCharcoal = ShadcnStylesheet(
  theme: ShadcnTheme.charcoal,
);
const ArcaneStylesheet shadcnCream = ShadcnStylesheet(theme: ShadcnTheme.cream);
const ArcaneStylesheet shadcnSlate = ShadcnStylesheet(theme: ShadcnTheme.slate);
const ArcaneStylesheet shadcnRose = ShadcnStylesheet(theme: ShadcnTheme.rose);
const ArcaneStylesheet shadcnLavender = ShadcnStylesheet(
  theme: ShadcnTheme.lavender,
);
const ArcaneStylesheet shadcnMint = ShadcnStylesheet(theme: ShadcnTheme.mint);
const ArcaneStylesheet shadcnSky = ShadcnStylesheet(theme: ShadcnTheme.sky);
const ArcaneStylesheet shadcnPeach = ShadcnStylesheet(theme: ShadcnTheme.peach);
const ArcaneStylesheet shadcnTeal = ShadcnStylesheet(theme: ShadcnTheme.teal);

const ArcaneStylesheet neonStylesheet = NeonStylesheet(theme: NeonTheme.green);

const ArcaneStylesheet neubrutalismStylesheet = NeubrutalismStylesheet(
  theme: NeubrutalismTheme.yellow,
);
const ArcaneStylesheet neubrutalismPink = NeubrutalismStylesheet(
  theme: NeubrutalismTheme.pink,
);
const ArcaneStylesheet neubrutalismMint = NeubrutalismStylesheet(
  theme: NeubrutalismTheme.mint,
);
const ArcaneStylesheet neubrutalismOrange = NeubrutalismStylesheet(
  theme: NeubrutalismTheme.orange,
);
const ArcaneStylesheet neubrutalismSky = NeubrutalismStylesheet(
  theme: NeubrutalismTheme.sky,
);
const ArcaneStylesheet neubrutalismLavender = NeubrutalismStylesheet(
  theme: NeubrutalismTheme.lavender,
);
const ArcaneStylesheet neubrutalismLime = NeubrutalismStylesheet(
  theme: NeubrutalismTheme.lime,
);
const ArcaneStylesheet neubrutalismRed = NeubrutalismStylesheet(
  theme: NeubrutalismTheme.red,
);
const ArcaneStylesheet neubrutalismGreyscale = NeubrutalismStylesheet(
  theme: NeubrutalismTheme.greyscale,
);

const ArcaneStylesheet win95Standard = Win95Stylesheet(
  theme: Win95Theme.standard,
);
const ArcaneStylesheet win95RainyDay = Win95Stylesheet(
  theme: Win95Theme.rainyDay,
);
const ArcaneStylesheet win95Eggplant = Win95Stylesheet(
  theme: Win95Theme.eggplant,
);
const ArcaneStylesheet win95Desert = Win95Stylesheet(theme: Win95Theme.desert);
const ArcaneStylesheet win95Rose = Win95Stylesheet(theme: Win95Theme.rose);

const ArcaneStylesheet asciiStylesheet = AsciiStylesheet();
const ArcaneStylesheet selectedStylesheet = asciiStylesheet;
const List<KBStylesheetOption> stylesheetOptions = <KBStylesheetOption>[
  KBStylesheetOption(id: 'ascii', label: 'Ascii', stylesheet: asciiStylesheet),
  KBStylesheetOption(
    id: 'win95',
    label: 'Windows 95',
    stylesheet: win95Standard,
    knowledgeBaseRenderers: Win95KnowledgeBaseRenderers(),
    palettes: <KBPaletteOption>[
      KBPaletteOption(
        id: 'standard',
        label: 'Standard',
        stylesheet: win95Standard,
        swatch: '#008080',
      ),
      KBPaletteOption(
        id: 'rainyDay',
        label: 'Rainy Day',
        stylesheet: win95RainyDay,
        swatch: '#3a5a78',
      ),
      KBPaletteOption(
        id: 'eggplant',
        label: 'Eggplant',
        stylesheet: win95Eggplant,
        swatch: '#524e66',
      ),
      KBPaletteOption(
        id: 'desert',
        label: 'Desert',
        stylesheet: win95Desert,
        swatch: '#9c8a63',
      ),
      KBPaletteOption(
        id: 'rose',
        label: 'Rose',
        stylesheet: win95Rose,
        swatch: '#7a5a5a',
      ),
    ],
  ),
  KBStylesheetOption(
    id: 'shadcn',
    label: 'Shadcn',
    stylesheet: shadcnStylesheet,
    knowledgeBaseRenderers: ShadcnKnowledgeBaseRenderers(),
    palettes: <KBPaletteOption>[
      KBPaletteOption(
        id: 'midnight',
        label: 'Midnight',
        stylesheet: shadcnStylesheet,
        swatch: '#020617',
      ),
      KBPaletteOption(
        id: 'charcoal',
        label: 'Charcoal',
        stylesheet: shadcnCharcoal,
        swatch: '#1f2937',
      ),
      KBPaletteOption(
        id: 'cream',
        label: 'Cream',
        stylesheet: shadcnCream,
        swatch: '#fafaf9',
      ),
      KBPaletteOption(
        id: 'slate',
        label: 'Slate',
        stylesheet: shadcnSlate,
        swatch: '#64748b',
      ),
      KBPaletteOption(
        id: 'rose',
        label: 'Rose',
        stylesheet: shadcnRose,
        swatch: '#f43f5e',
      ),
      KBPaletteOption(
        id: 'lavender',
        label: 'Lavender',
        stylesheet: shadcnLavender,
        swatch: '#a78bfa',
      ),
      KBPaletteOption(
        id: 'mint',
        label: 'Mint',
        stylesheet: shadcnMint,
        swatch: '#34d399',
      ),
      KBPaletteOption(
        id: 'sky',
        label: 'Sky',
        stylesheet: shadcnSky,
        swatch: '#38bdf8',
      ),
      KBPaletteOption(
        id: 'peach',
        label: 'Peach',
        stylesheet: shadcnPeach,
        swatch: '#fb923c',
      ),
      KBPaletteOption(
        id: 'teal',
        label: 'Teal',
        stylesheet: shadcnTeal,
        swatch: '#14b8a6',
      ),
    ],
  ),
  KBStylesheetOption(
    id: 'neon',
    label: 'Neon',
    stylesheet: neonStylesheet,
    knowledgeBaseRenderers: NeonKnowledgeBaseRenderers(),
    palettes: <KBPaletteOption>[
      KBPaletteOption(
        id: 'green',
        label: 'Green',
        stylesheet: neonStylesheet,
        bodyClass: 'neon-green',
        swatch: '#00f5a0',
      ),
    ],
  ),
  KBStylesheetOption(
    id: 'neubrutalism',
    label: 'NeuBrutalism',
    stylesheet: neubrutalismStylesheet,
    knowledgeBaseRenderers: NeubrutalismKnowledgeBaseRenderers(),
    palettes: <KBPaletteOption>[
      KBPaletteOption(
        id: 'yellow',
        label: 'Yellow',
        stylesheet: neubrutalismStylesheet,
        bodyClass: 'neubrutalism-yellow',
        swatch: '#ffd700',
      ),
      KBPaletteOption(
        id: 'pink',
        label: 'Pink',
        stylesheet: neubrutalismPink,
        bodyClass: 'neubrutalism-pink',
        swatch: '#ff80c0',
      ),
      KBPaletteOption(
        id: 'mint',
        label: 'Mint',
        stylesheet: neubrutalismMint,
        bodyClass: 'neubrutalism-mint',
        swatch: '#7be8b6',
      ),
      KBPaletteOption(
        id: 'orange',
        label: 'Orange',
        stylesheet: neubrutalismOrange,
        bodyClass: 'neubrutalism-orange',
        swatch: '#ff8c42',
      ),
      KBPaletteOption(
        id: 'sky',
        label: 'Sky',
        stylesheet: neubrutalismSky,
        bodyClass: 'neubrutalism-sky',
        swatch: '#7cd0ff',
      ),
      KBPaletteOption(
        id: 'lavender',
        label: 'Lavender',
        stylesheet: neubrutalismLavender,
        bodyClass: 'neubrutalism-lavender',
        swatch: '#c8a2ff',
      ),
      KBPaletteOption(
        id: 'lime',
        label: 'Lime',
        stylesheet: neubrutalismLime,
        bodyClass: 'neubrutalism-lime',
        swatch: '#c8ff42',
      ),
      KBPaletteOption(
        id: 'red',
        label: 'Red',
        stylesheet: neubrutalismRed,
        bodyClass: 'neubrutalism-red',
        swatch: '#ff5c5c',
      ),
      KBPaletteOption(
        id: 'greyscale',
        label: 'Greyscale',
        stylesheet: neubrutalismGreyscale,
        bodyClass: 'neubrutalism-greyscale',
        swatch: '#e5e5e5',
      ),
    ],
  ),
];

void main() async {
  Jaspr.initializeApp(options: defaultServerOptions);

  runApp(
    await KnowledgeBaseApp.create(
      config: SiteConfig(
        name: 'ArcaneJaspr',
        description:
            'Documentation for ArcaneJaspr - A dart package for building web ui with Jaspr.',
        contentDirectory: 'content',
        landingPath: 'Landing',
        baseUrl: baseUrl,
        githubUrl: 'https://github.com/ArcaneArts/arcane_jaspr',
        searchEnabled: true,
        tocEnabled: true,
        themeToggleEnabled: true,
        stylesheetSwitcherEnabled: true,
        paletteSwitcherEnabled: true,
        pageNavEnabled: true,
        headerLinks: const <NavLink>[
          NavLink(label: 'Ascii', href: '/ascii'),
          NavLink(label: 'Docs', href: '/docs'),
          NavLink(label: 'Components', href: '/docs/components/accordion'),
          NavLink(label: 'Styling', href: '/styling'),
        ],
        navigationBarEnabled: true,
        navigationBarPosition: KBNavigationBarPosition.top,
        defaultTheme: KBThemeMode.light,
        showEditLink: true,
        editBranch: 'master',
        sidebarFooter: 'Built with Arcane Lexicon',
        sidebarFooterUrl: 'https://github.com/ArcaneArts/arcane_lexicon',
      ),
      stylesheet: selectedStylesheet,
      stylesheetOptions: stylesheetOptions,
      demoBuilder: (String componentType) => componentType == 'ascii-showcase'
          ? const AsciiShowcase()
          : InteractiveDemoPage(componentType: componentType),
    ),
  );
}
