/// Callout/admonition block styles.
///
/// Provides styles for note, tip, important, warning, and caution blocks.
const String arcaneCalloutStyles = '''
/* Callout/Admonition blocks */
.callout {
  margin: 1rem 0;
  padding: 1rem;
  border-radius: var(--radius);
  border: 1px solid var(--border);
}

.callout-title {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-weight: 600;
  margin-bottom: 0.5rem;
}

.callout-icon {
  display: flex;
  align-items: center;
}

.callout-content {
  font-size: 0.875rem;
  line-height: 1.6;
}

/* Note - Blue */
.callout-note {
  background: rgba(59, 130, 246, 0.1);
  border-color: #3b82f6;
}
.callout-note .callout-title { color: #3b82f6; }

/* Tip - Green */
.callout-tip {
  background: rgba(34, 197, 94, 0.1);
  border-color: #22c55e;
}
.callout-tip .callout-title { color: #22c55e; }

/* Important - Purple */
.callout-important {
  background: rgba(168, 85, 247, 0.1);
  border-color: #a855f7;
}
.callout-important .callout-title { color: #a855f7; }

/* Warning - Yellow/Orange */
.callout-warning {
  background: rgba(234, 179, 8, 0.1);
  border-color: #eab308;
}
.callout-warning .callout-title { color: #eab308; }

/* Caution - Red */
.callout-caution {
  background: rgba(239, 68, 68, 0.1);
  border-color: #ef4444;
}
.callout-caution .callout-title { color: #ef4444; }
''';
