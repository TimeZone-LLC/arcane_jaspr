/// Base prose typography styles for markdown content.
///
/// Include this in your stylesheet's baseCss for prose styling:
/// ```dart
/// @override
/// String get baseCss => '''
/// ${super.baseCss}
/// $arcaneProseStyles
/// ''';
/// ```
const String arcaneProseStyles = '''
/* ============================================
   PROSE CONTENT STYLES
   Typography for markdown/documentation
   ============================================ */
.prose {
  max-width: 65ch;
  color: var(--foreground);
}

.prose h1, .prose h2, .prose h3,
.prose h4, .prose h5, .prose h6 {
  color: var(--foreground);
  font-weight: 600;
  line-height: 1.25;
  margin-top: 2rem;
  margin-bottom: 1rem;
}

.prose h1 { font-size: 2.25rem; margin-top: 0; }
.prose h2 {
  font-size: 1.5rem;
  border-bottom: 1px solid var(--border);
  padding-bottom: 0.5rem;
}
.prose h3 { font-size: 1.25rem; }
.prose h4 { font-size: 1rem; }

.prose p {
  color: var(--muted-foreground);
  margin-bottom: 1rem;
}

.prose li {
  color: var(--muted-foreground);
  margin-bottom: 0.25rem;
}

.prose a {
  color: var(--primary);
  text-decoration: none;
  transition: color var(--arcane-transition-fast);
}

.prose a:hover {
  color: var(--primary);
  text-decoration: underline;
  opacity: 0.8;
}

.prose strong, .prose b {
  color: var(--foreground);
  font-weight: 600;
}

.prose em {
  font-style: italic;
}

.prose ul, .prose ol {
  margin-bottom: 1rem;
  padding-left: 1.5rem;
}

.prose li::marker {
  color: var(--muted-foreground);
}

.prose blockquote {
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 0.75rem 1rem;
  margin: 1rem 0;
  font-style: italic;
  color: var(--muted-foreground);
}

.prose hr {
  border: none;
  border-top: 1px solid var(--border);
  margin: 2rem 0;
}

.prose table {
  width: 100%;
  border-collapse: collapse;
  margin: 1rem 0;
}

.prose th, .prose td {
  border: 1px solid var(--border);
  padding: 0.75rem;
  text-align: left;
}

.prose th {
  background-color: var(--muted);
  color: var(--foreground);
  font-weight: 600;
}

.prose td {
  color: var(--muted-foreground);
}

.prose img {
  max-width: 100%;
  height: auto;
  border-radius: var(--radius);
}
''';
