/// Prose code block styles with syntax highlighting.
///
/// Includes styles for both light and dark modes using
/// GitHub-inspired color schemes.
const String arcaneProseCodeStyles = '''
/* ============================================
   PROSE CODE BLOCK STYLES
   Syntax highlighting for code
   ============================================ */
.prose pre {
  background-color: var(--code-background);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 16px 20px;
  overflow-x: auto;
  margin: 1.5rem 0;
  position: relative;
}

.prose code {
  font-family: var(--font-mono);
  font-size: 13px;
  line-height: 1.7;
}

/* Syntax colors are variables set per mode inside :where(), which has no
   specificity, so a theme or site restyles any token or the block background
   with a plain `.prose { --code-*: ... }` rule in either mode.
   Light values are GitHub Light, dark values GitHub Dark. */
:where(.prose) {
  --code-background: oklch(0.97 0 0);
  --code-text: #24292f;
  --code-keyword: #cf222e;
  --code-string: #0a3069;
  --code-number: #0550ae;
  --code-function: #8250df;
  --code-comment: #6e7781;
  --code-variable: #953800;
  --code-class: #116329;
}

:where(.dark .prose) {
  --code-background: oklch(0.145 0 0);
  --code-text: #c9d1d9;
  --code-keyword: #ff7b72;
  --code-string: #a5d6ff;
  --code-number: #79c0ff;
  --code-function: #d2a8ff;
  --code-comment: #8b949e;
  --code-variable: #ffa657;
  --code-class: #7ee787;
}

.prose pre code {
  color: var(--code-text);
}

.prose .hljs-keyword,
.prose .hljs-selector-tag,
.prose .hljs-literal,
.prose .hljs-section,
.prose .hljs-link {
  color: var(--code-keyword);
}

.prose .hljs-string,
.prose .hljs-attr {
  color: var(--code-string);
}

.prose .hljs-number,
.prose .hljs-type {
  color: var(--code-number);
}

.prose .hljs-function,
.prose .hljs-title {
  color: var(--code-function);
}

.prose .hljs-comment {
  color: var(--code-comment);
  font-style: italic;
}

.prose .hljs-variable,
.prose .hljs-params {
  color: var(--code-variable);
}

.prose .hljs-class,
.prose .hljs-built_in {
  color: var(--code-class);
}

/* Inline code follows the theme tokens, so it reads in either mode. */
.prose :not(pre) > code {
  background-color: var(--muted);
  color: var(--foreground);
  padding: 2px 6px;
  border-radius: var(--radius);
  font-size: 0.875em;
  font-weight: 500;
}
''';

/// Code block copy button styles.
const String arcaneCodeCopyButtonStyles = '''
/* Code block copy button */
.code-wrapper {
  position: relative;
}

.code-copy-button {
  position: absolute;
  top: 12px;
  right: 12px;
  padding: 6px 10px;
  background: var(--muted);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  color: var(--muted-foreground);
  font-size: 12px;
  cursor: pointer;
  opacity: 0;
  transition: all 0.15s ease;
}

.code-wrapper:hover .code-copy-button {
  opacity: 0.8;
}

.code-copy-button:hover {
  opacity: 1 !important;
  background: var(--accent);
  color: var(--foreground);
}

.code-copy-button.copied {
  color: var(--success, #22c55e);
  opacity: 1 !important;
}
''';
