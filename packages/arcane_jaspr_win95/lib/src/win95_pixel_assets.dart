/// Pixel-art SVG data URIs for the Windows 95 theme.
///
/// Every asset is authored on the integer pixel grid, one rectangle per run,
/// with `shape-rendering='crispEdges'`, so it lands 1:1 on device pixels
/// instead of being anti-aliased the way a vector stroke is. The URIs are
/// URL-encoded (`%3C`, `%3E`, `%23`) for use inside a CSS `url("...")`.
///
/// Bevel colours cannot be tinted through `currentColor`, so each coloured
/// asset ships a light and a dark variant; the stylesheet's dark block
/// re-points the token at the dark one. Shape-only glyphs are masks and follow
/// the element's colour instead.
library;

const String _svgOpen = "%3Csvg xmlns='http://www.w3.org/2000/svg'";
const String _crisp = "shape-rendering='crispEdges'";

// ---------------------------------------------------------------------------
// Caption buttons
// ---------------------------------------------------------------------------

// One 16x14 caption cap, painted face first and then the four bevel runs:
// inner top-left light, inner bottom-right shadow, outer top-left highlight,
// outer bottom-right dark. The dark runs own the top-right and bottom-left
// corner pixels, exactly as the push-button box-shadow recipe resolves.
const String _capFace = 'M0 0h16v14H0z';
const String _capLight = 'M1 1h13v1H1zM1 2h1v10H1z';
const String _capShadow = 'M14 1h1v11h-1zM1 12h14v1H1z';
const String _capHilite = 'M0 0h15v1H0zM0 1h1v12H0z';
const String _capDark = 'M15 0h1v14h-1zM0 13h15v1H0z';

// Glyphs at their own origin; the caps and mask cells place them.
/// Minimize: a 6x2 bar.
const String _minimizeGlyph = 'M0 0h6v2H0z';

/// Maximize: a 9x9 box whose top edge is two pixels thick.
const String _maximizeGlyph = 'M0 0h9v2H0zM0 2h1v7H0zM8 2h1v7H8zM1 8h7v1H1z';

/// Close: the stepped 8x7 cross, one run per stroke per row
/// (`XX....XX / .XX..XX. / ..XXXX.. / ...XX... / ..XXXX.. / .XX..XX. /
/// XX....XX`).
const String _closeGlyph =
    'M0 0h2v1H0zM6 0h2v1H6z'
    'M1 1h2v1H1zM5 1h2v1H5z'
    'M2 2h4v1H2z'
    'M3 3h2v1H3z'
    'M2 4h4v1H2z'
    'M1 5h2v1H1zM5 5h2v1H5z'
    'M0 6h2v1H0zM6 6h2v1H6z';

// Glyph placement inside a 16x14 cap.
const String _minimizeAt = "transform='translate(4 9)'";
const String _maximizeAt = "transform='translate(3 2)'";
const String _closeAt = "transform='translate(4 3)'";

const String _capLightScheme =
    "%3Cpath fill='%23c0c0c0' d='$_capFace'/%3E"
    "%3Cpath fill='%23dfdfdf' d='$_capLight'/%3E"
    "%3Cpath fill='%23808080' d='$_capShadow'/%3E"
    "%3Cpath fill='%23ffffff' d='$_capHilite'/%3E"
    "%3Cpath fill='%23000000' d='$_capDark'/%3E";
const String _capDarkScheme =
    "%3Cpath fill='%233a3a3a' d='$_capFace'/%3E"
    "%3Cpath fill='%23646464' d='$_capLight'/%3E"
    "%3Cpath fill='%231c1c1c' d='$_capShadow'/%3E"
    "%3Cpath fill='%238e8e8e' d='$_capHilite'/%3E"
    "%3Cpath fill='%23000000' d='$_capDark'/%3E";

const String _minimizeCapLight =
    "$_capLightScheme%3Cpath fill='%23000000' $_minimizeAt "
    "d='$_minimizeGlyph'/%3E";
const String _maximizeCapLight =
    "$_capLightScheme%3Cpath fill='%23000000' $_maximizeAt "
    "d='$_maximizeGlyph'/%3E";
const String _closeCapLight =
    "$_capLightScheme%3Cpath fill='%23000000' $_closeAt d='$_closeGlyph'/%3E";
const String _minimizeCapDark =
    "$_capDarkScheme%3Cpath fill='%23ffffff' $_minimizeAt "
    "d='$_minimizeGlyph'/%3E";
const String _maximizeCapDark =
    "$_capDarkScheme%3Cpath fill='%23ffffff' $_maximizeAt "
    "d='$_maximizeGlyph'/%3E";
const String _closeCapDark =
    "$_capDarkScheme%3Cpath fill='%23ffffff' $_closeAt d='$_closeGlyph'/%3E";

const String _secondCap = "%3Cg transform='translate(16 0)'%3E";
const String _closeCapAfterGap = "%3Cg transform='translate(34 0)'%3E";
const String _endGroup = '%3C/g%3E';
const String _endSvg = '%3C/svg%3E';

/// Minimize + maximize (touching) + 2px gap + close, 50x14, light scheme.
const String win95CaptionButtonsLight =
    "data:image/svg+xml,$_svgOpen width='50' height='14' "
    "viewBox='0 0 50 14' $_crisp%3E"
    '$_minimizeCapLight'
    '$_secondCap$_maximizeCapLight$_endGroup'
    '$_closeCapAfterGap$_closeCapLight$_endGroup'
    '$_endSvg';

/// Minimize + maximize (touching) + 2px gap + close, 50x14, dark scheme.
const String win95CaptionButtonsDark =
    "data:image/svg+xml,$_svgOpen width='50' height='14' "
    "viewBox='0 0 50 14' $_crisp%3E"
    '$_minimizeCapDark'
    '$_secondCap$_maximizeCapDark$_endGroup'
    '$_closeCapAfterGap$_closeCapDark$_endGroup'
    '$_endSvg';

/// Minimize + maximize pair, 32x14, light scheme.
const String win95CaptionMinMaxLight =
    "data:image/svg+xml,$_svgOpen width='32' height='14' "
    "viewBox='0 0 32 14' $_crisp%3E"
    '$_minimizeCapLight'
    '$_secondCap$_maximizeCapLight$_endGroup'
    '$_endSvg';

/// Minimize + maximize pair, 32x14, dark scheme.
const String win95CaptionMinMaxDark =
    "data:image/svg+xml,$_svgOpen width='32' height='14' "
    "viewBox='0 0 32 14' $_crisp%3E"
    '$_minimizeCapDark'
    '$_secondCap$_maximizeCapDark$_endGroup'
    '$_endSvg';

/// The lone close cap, 16x14, light scheme.
const String win95CaptionCloseLight =
    "data:image/svg+xml,$_svgOpen width='16' height='14' "
    "viewBox='0 0 16 14' $_crisp%3E"
    '$_closeCapLight'
    '$_endSvg';

/// The lone close cap, 16x14, dark scheme.
const String win95CaptionCloseDark =
    "data:image/svg+xml,$_svgOpen width='16' height='14' "
    "viewBox='0 0 16 14' $_crisp%3E"
    '$_closeCapDark'
    '$_endSvg';

// ---------------------------------------------------------------------------
// Caption glyph masks
// ---------------------------------------------------------------------------

// The same three glyphs as shape-only masks in a 10x10 cell. A cell centred in
// a 16x14 cap sits at offset (3, 2), so these placements land every glyph on
// the same cap pixels as the sprites above.

/// Minimize glyph mask (10x10 cell).
const String win95ControlMinimizeMask =
    "data:image/svg+xml,$_svgOpen viewBox='0 0 10 10' $_crisp%3E"
    "%3Cpath fill='%23000000' transform='translate(1 7)' "
    "d='$_minimizeGlyph'/%3E"
    '$_endSvg';

/// Maximize glyph mask (10x10 cell).
const String win95ControlMaximizeMask =
    "data:image/svg+xml,$_svgOpen viewBox='0 0 10 10' $_crisp%3E"
    "%3Cpath fill='%23000000' d='$_maximizeGlyph'/%3E"
    '$_endSvg';

/// Close glyph mask (10x10 cell).
const String win95ControlCloseMask =
    "data:image/svg+xml,$_svgOpen viewBox='0 0 10 10' $_crisp%3E"
    "%3Cpath fill='%23000000' transform='translate(1 1)' "
    "d='$_closeGlyph'/%3E"
    '$_endSvg';

// ---------------------------------------------------------------------------
// Radio button
// ---------------------------------------------------------------------------

// The 12x12 ring split along the anti-diagonal: an outer arc (shadow over
// highlight) around an inner arc (dark over light), the sunken order of every
// other well. The field is left clear so the control's own var(--w95-field)
// background shows through, clipped to the circle by win95RadioMask.
const String _radioOuterTopLeft =
    'M4 0h4v1H4zM2 1h2v1H2zM8 1h2v1H8zM1 2h1v2H1zM0 4h1v4H0zM1 8h1v2H1z';
const String _radioInnerTopLeft =
    'M4 1h4v1H4zM2 2h2v1H2zM8 2h2v1H8zM2 3h1v1H2zM1 4h1v4H1zM2 8h1v2H2z';
const String _radioInnerBottomRight =
    'M9 3h1v1H9zM10 4h1v4H10zM9 8h1v1H9zM3 9h1v1H3zM8 9h2v1H8zM4 10h4v1H4z';
const String _radioOuterBottomRight =
    'M10 2h1v2H10zM11 4h1v4H11zM10 8h1v2H10zM2 10h2v1H2zM8 10h2v1H8z'
    'M4 11h4v1H4z';

/// Radio ring, light scheme (#808080 / #000000 over #dfdfdf / #ffffff).
const String win95RadioRingLight =
    "data:image/svg+xml,$_svgOpen width='12' height='12' "
    "viewBox='0 0 12 12' $_crisp%3E"
    "%3Cpath fill='%23808080' d='$_radioOuterTopLeft'/%3E"
    "%3Cpath fill='%23000000' d='$_radioInnerTopLeft'/%3E"
    "%3Cpath fill='%23dfdfdf' d='$_radioInnerBottomRight'/%3E"
    "%3Cpath fill='%23ffffff' d='$_radioOuterBottomRight'/%3E"
    '$_endSvg';

/// Radio ring, dark scheme (#1c1c1c / #000000 over #646464 / #8e8e8e).
const String win95RadioRingDark =
    "data:image/svg+xml,$_svgOpen width='12' height='12' "
    "viewBox='0 0 12 12' $_crisp%3E"
    "%3Cpath fill='%231c1c1c' d='$_radioOuterTopLeft'/%3E"
    "%3Cpath fill='%23000000' d='$_radioInnerTopLeft'/%3E"
    "%3Cpath fill='%23646464' d='$_radioInnerBottomRight'/%3E"
    "%3Cpath fill='%238e8e8e' d='$_radioOuterBottomRight'/%3E"
    '$_endSvg';

/// The radio's circular silhouette (ring plus field), used as a mask so the
/// square control box paints nothing outside the bitmap circle.
const String win95RadioMask =
    "data:image/svg+xml,$_svgOpen width='12' height='12' "
    "viewBox='0 0 12 12' $_crisp%3E"
    "%3Cpath fill='%23000000' d='M4 0h4v1H4zM2 1h8v1H2zM1 2h10v2H1zM0 4h12v4H0z"
    "M1 8h10v2H1zM2 10h8v1H2zM4 11h4v1H4z'/%3E"
    '$_endSvg';

// ---------------------------------------------------------------------------
// Scroll bar arrows
// ---------------------------------------------------------------------------

// Stepped 7x4 (up/down) and 4x7 (left/right) triangles centred in the 16x16
// scroll button's 12x12 client area, the way the Win95 arrow bitmaps sit.
const String _arrowUp = 'M7 6h1v1H7zM6 7h3v1H6zM5 8h5v1H5zM4 9h7v1H4z';
const String _arrowDown = 'M4 6h7v1H4zM5 7h5v1H5zM6 8h3v1H6zM7 9h1v1H7z';
const String _arrowLeft =
    'M9 4h1v1H9zM8 5h2v1H8zM7 6h3v1H7zM6 7h4v1H6zM7 8h3v1H7zM8 9h2v1H8z'
    'M9 10h1v1H9z';
const String _arrowRight =
    'M6 4h1v1H6zM6 5h2v1H6zM6 6h3v1H6zM6 7h4v1H6zM6 8h3v1H6zM6 9h2v1H6z'
    'M6 10h1v1H6z';

const String _arrowOpen =
    "data:image/svg+xml,$_svgOpen width='16' height='16' "
    "viewBox='0 0 16 16' $_crisp%3E";

/// Scroll-up arrow, black glyph.
const String win95ScrollUpLight =
    "$_arrowOpen%3Cpath fill='%23000000' d='$_arrowUp'/%3E$_endSvg";

/// Scroll-down arrow, black glyph.
const String win95ScrollDownLight =
    "$_arrowOpen%3Cpath fill='%23000000' d='$_arrowDown'/%3E$_endSvg";

/// Scroll-left arrow, black glyph.
const String win95ScrollLeftLight =
    "$_arrowOpen%3Cpath fill='%23000000' d='$_arrowLeft'/%3E$_endSvg";

/// Scroll-right arrow, black glyph.
const String win95ScrollRightLight =
    "$_arrowOpen%3Cpath fill='%23000000' d='$_arrowRight'/%3E$_endSvg";

/// Scroll-up arrow, white glyph.
const String win95ScrollUpDark =
    "$_arrowOpen%3Cpath fill='%23ffffff' d='$_arrowUp'/%3E$_endSvg";

/// Scroll-down arrow, white glyph.
const String win95ScrollDownDark =
    "$_arrowOpen%3Cpath fill='%23ffffff' d='$_arrowDown'/%3E$_endSvg";

/// Scroll-left arrow, white glyph.
const String win95ScrollLeftDark =
    "$_arrowOpen%3Cpath fill='%23ffffff' d='$_arrowLeft'/%3E$_endSvg";

/// Scroll-right arrow, white glyph.
const String win95ScrollRightDark =
    "$_arrowOpen%3Cpath fill='%23ffffff' d='$_arrowRight'/%3E$_endSvg";

// ---------------------------------------------------------------------------
// Trackbar thumb
// ---------------------------------------------------------------------------

// The 11x21 pointed trackbar thumb: a raised 11x16 body whose bottom tapers
// one pixel per row per side to a single-pixel point, with the highlight runs
// following the left diagonal and the shadow runs the right one.
const String _thumbHilite =
    'M0 0h10v1H0zM0 1h1v15H0zM1 16h1v1H1zM2 17h1v1H2zM3 18h1v1H3zM4 19h1v1H4z';
const String _thumbLight =
    'M1 1h8v1H1zM1 2h1v14H1zM2 16h1v1H2zM3 17h1v1H3zM4 18h1v1H4z';
const String _thumbFace = 'M2 2h7v14H2zM3 16h5v1H3zM4 17h3v1H4zM5 18h1v1H5z';
const String _thumbShadow =
    'M9 1h1v15H9zM8 16h1v1H8zM7 17h1v1H7zM6 18h1v1H6zM5 19h1v1H5z';
const String _thumbDark =
    'M10 0h1v16H10zM9 16h1v1H9zM8 17h1v1H8zM7 18h1v1H7zM6 19h1v1H6z'
    'M5 20h1v1H5z';

const String _thumbOpen =
    "data:image/svg+xml,$_svgOpen width='11' height='21' "
    "viewBox='0 0 11 21' $_crisp%3E";

/// Trackbar thumb, light scheme.
const String win95SliderThumbLight =
    '$_thumbOpen'
    "%3Cpath fill='%23ffffff' d='$_thumbHilite'/%3E"
    "%3Cpath fill='%23dfdfdf' d='$_thumbLight'/%3E"
    "%3Cpath fill='%23c0c0c0' d='$_thumbFace'/%3E"
    "%3Cpath fill='%23808080' d='$_thumbShadow'/%3E"
    "%3Cpath fill='%23000000' d='$_thumbDark'/%3E"
    '$_endSvg';

/// Trackbar thumb, dark scheme.
const String win95SliderThumbDark =
    '$_thumbOpen'
    "%3Cpath fill='%238e8e8e' d='$_thumbHilite'/%3E"
    "%3Cpath fill='%23646464' d='$_thumbLight'/%3E"
    "%3Cpath fill='%233a3a3a' d='$_thumbFace'/%3E"
    "%3Cpath fill='%231c1c1c' d='$_thumbShadow'/%3E"
    "%3Cpath fill='%23000000' d='$_thumbDark'/%3E"
    '$_endSvg';
