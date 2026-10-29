/// Opt-in ratio-packing masonry script for `ArcaneGallery(packing: true)`.
///
/// Ported from Anim.al's `animal_masonry.js` engine. Its candidate-span scoring,
/// first-fit packing, interior-hole sealing, and squared-off-bottom sealing
/// retain their legacy behavior when optional area controls are omitted. The
/// DOM keying follows the arcane contract and the installer self-initializes.
///
/// Self-initializes on load: it finds every `[data-arcane-gallery]
/// [data-packing="true"]` container, observes each with a `ResizeObserver`, and
/// watches the document with a single `MutationObserver` for newly-added
/// containers/items and for Jaspr re-syncing inline styles. Repacks are
/// rAF-coalesced. No per-container external call is needed; the engine is
/// stateless and keys items off `[data-arcane-gallery-item]` + their
/// `data-ratio`, sized against the render base's `grid-auto-rows: 8px` and
/// `gap: 0.75rem`.
class GalleryScripts {
  GalleryScripts._();

  static String get code => r'''
(function() {
  'use strict';

  const DEFAULT_MAX_COLUMN_SPAN = 4;
  const DEFAULT_MAX_ROW_SPAN = 5;
  const DEFAULT_ROW_DELAY_PENALTY = 0.32;
  const DEFAULT_COLUMN_DRIFT_PENALTY = 0.025;
  const DEFAULT_SEAL_MAX_RATIO_MISMATCH = Math.log(2.4);
  const DEFAULT_BOTTOM_MAX_RATIO_MISMATCH = Math.log(2.1);

  function safeNumber(value, fallback) {
    const parsed = typeof value === 'string'
      ? Number.parseFloat(value)
      : Number(value);
    return Number.isFinite(parsed) && parsed > 0 ? parsed : fallback;
  }

  function optionalPositiveNumber(value) {
    const parsed = typeof value === 'string'
      ? Number.parseFloat(value)
      : Number(value);
    return Number.isFinite(parsed) && parsed > 0 ? parsed : null;
  }

  function trackCount(gridTemplateColumns) {
    if (!gridTemplateColumns || gridTemplateColumns === 'none') {
      return 1;
    }
    return gridTemplateColumns
      .trim()
      .split(/\s+/)
      .filter((track) => track && track !== '/')
      .length || 1;
  }

  function firstTrackWidth(gridTemplateColumns, fallback) {
    const firstTrack = (gridTemplateColumns || '').trim().split(/\s+/)[0] || '';
    const parsed = Number.parseFloat(firstTrack);
    return Number.isFinite(parsed) && parsed > 0 ? parsed : fallback;
  }

  function spanDisplayRatio(columnSpan, rowSpan, columnWidth, rowHeight, gap, item = {}) {
    const width = columnSpan * columnWidth + Math.max(0, columnSpan - 1) * gap
      - safeNumber(item.chromeWidth, 0);
    const height = rowSpan * rowHeight + Math.max(0, rowSpan - 1) * gap
      - safeNumber(item.chromeHeight, 0);
    if (width <= 0 || height <= 0) return Infinity;
    return width / Math.max(1, height);
  }

  function layoutOptions(options, columns) {
    const safeColumns = Math.max(
      1,
      Math.floor(safeNumber(columns ?? options.columns, 1)),
    );
    return {
      columns: safeColumns,
      columnWidth: safeNumber(options.columnWidth, 160),
      rowHeight: safeNumber(options.rowHeight, 80),
      gap: safeNumber(options.gap, 0),
      maxColumnSpan: Math.min(
        safeColumns,
        Math.max(1, Math.floor(safeNumber(options.maxColumnSpan, DEFAULT_MAX_COLUMN_SPAN))),
      ),
      maxRowSpan: Math.max(
        1,
        Math.floor(safeNumber(options.maxRowSpan, DEFAULT_MAX_ROW_SPAN)),
      ),
      rowDelayPenalty: safeNumber(options.rowDelayPenalty, DEFAULT_ROW_DELAY_PENALTY),
      columnDriftPenalty: safeNumber(options.columnDriftPenalty, DEFAULT_COLUMN_DRIFT_PENALTY),
      sealMaxRatioMismatch: safeNumber(
        options.sealMaxRatioMismatch,
        DEFAULT_SEAL_MAX_RATIO_MISMATCH,
      ),
      bottomMaxRatioMismatch: safeNumber(
        options.bottomMaxRatioMismatch,
        DEFAULT_BOTTOM_MAX_RATIO_MISMATCH,
      ),
      minimumTileArea: optionalPositiveNumber(options.minimumTileArea),
      targetTileArea: optionalPositiveNumber(options.targetTileArea),
    };
  }

  function spanRatioScore(aspectRatio, columnSpan, rowSpan, layout, item = {}) {
    const displayRatio = spanDisplayRatio(
      columnSpan,
      rowSpan,
      layout.columnWidth,
      layout.rowHeight,
      layout.gap,
      item,
    );
    return Math.abs(Math.log(displayRatio / aspectRatio));
  }

  function targetAreaFor(aspectRatio) {
    if (aspectRatio >= 1.9 || aspectRatio <= 0.7) {
      return 6;
    }
    if (aspectRatio >= 1.35 || aspectRatio <= 0.9) {
      return 5;
    }
    return 4;
  }

  function galleryCandidateSpans(item, options = {}) {
    const layout = layoutOptions(options, options.columns);
    const aspectRatio = safeNumber(item.aspectRatio, 1);
    const targetArea = layout.targetTileArea ?? targetAreaFor(aspectRatio);
    const candidates = [];
    const undersizedCandidates = [];

    for (let columnSpan = 1; columnSpan <= layout.maxColumnSpan; columnSpan++) {
      for (let rowSpan = 1; rowSpan <= layout.maxRowSpan; rowSpan++) {
        const displayRatio = spanDisplayRatio(
          columnSpan,
          rowSpan,
          layout.columnWidth,
          layout.rowHeight,
          layout.gap,
          item,
        );
        if (!Number.isFinite(displayRatio)) continue;
        const ratioScore = Math.abs(Math.log(displayRatio / aspectRatio));
        const area = columnSpan * rowSpan;
        let score = ratioScore * 4 + Math.abs(area - targetArea) * 0.12;
        if (columnSpan === 1 && rowSpan === 1) {
          score += 1.2;
        } else if (columnSpan === 1 && layout.columns > 3) {
          score += 0.25;
        }
        if (columnSpan === layout.columns && layout.columns > 3) {
          score += 0.5;
        }
        const candidate = {
          columnSpan,
          rowSpan,
          score,
          ratioScore,
          displayRatio,
        };
        if (layout.minimumTileArea !== null && area < layout.minimumTileArea) {
          undersizedCandidates.push(candidate);
        } else {
          candidates.push(candidate);
        }
      }
    }

    // A narrow layout may make the requested floor impossible. Prefer the
    // largest attainable spans instead of letting placement fall back to 1×1.
    if (candidates.length === 0 && undersizedCandidates.length > 0) {
      const largestArea = Math.max(
        ...undersizedCandidates.map(
          (candidate) => candidate.columnSpan * candidate.rowSpan,
        ),
      );
      candidates.push(
        ...undersizedCandidates.filter(
          (candidate) =>
            candidate.columnSpan * candidate.rowSpan === largestArea,
        ),
      );
    }

    candidates.sort((a, b) =>
      a.score - b.score ||
      a.ratioScore - b.ratioScore ||
      b.columnSpan - a.columnSpan ||
      a.rowSpan - b.rowSpan,
    );
    return candidates;
  }

  function galleryJustifiedRows(items, options = {}) {
    const width = safeNumber(options.width, 1);
    const gap = safeNumber(options.gap, 0);
    const targetHeight = safeNumber(options.targetHeight, 280);
    const maxHeight = safeNumber(options.maxHeight, 380);
    const rows = [];
    for (let start = 0; start < items.length;) {
      if (width <= 600) {
        const item = items[start];
        rows.push({
          start, count: 1,
          height: Math.max(1, width - safeNumber(item.chromeWidth, 0)) /
            safeNumber(item.aspectRatio, 1),
          widths: [width],
        });
        start++;
        continue;
      }

      let best = null;
      let ratioSum = 0;
      let chromeSum = 0;
      let minimumHeight = 0;
      for (let count = 1; count <= Math.min(6, items.length - start); count++) {
        const item = items[start + count - 1];
        ratioSum += safeNumber(item.aspectRatio, 1);
        chromeSum += safeNumber(item.chromeWidth, 0);
        minimumHeight = Math.max(minimumHeight,
          (safeNumber(item.minimumWidth, 0) - safeNumber(item.chromeWidth, 0)) /
            safeNumber(item.aspectRatio, 1));
        const availableWidth = width - chromeSum - (count - 1) * gap;
        if (availableWidth <= 0) break;
        const lastRow = start + count === items.length;
        const height = Math.min(
          availableWidth / ratioSum,
          lastRow ? Math.min(maxHeight, Math.max(targetHeight, minimumHeight)) : maxHeight,
        );
        const usedWidth = height * ratioSum + chromeSum + (count - 1) * gap;
        const score = Math.abs(Math.log(height / targetHeight)) +
          Math.max(0, 1 - usedWidth / width) * 0.5;
        const fitsMinimumWidth = height >= minimumHeight;
        if (!best || (fitsMinimumWidth && !best.fitsMinimumWidth) ||
            (fitsMinimumWidth === best.fitsMinimumWidth && score < best.score)) {
          best = { start, count, height, score, fitsMinimumWidth };
        }
      }
      if (!best) break;
      rows.push({
        start, count: best.count, height: best.height,
        widths: items.slice(start, start + best.count).map((item) =>
          best.height * safeNumber(item.aspectRatio, 1) + safeNumber(item.chromeWidth, 0)),
      });
      start += best.count;
    }
    return rows;
  }

  function makeRow(columns) {
    return Array.from({ length: columns }, () => false);
  }

  function ensureRow(occupied, row, columns) {
    while (occupied.length <= row) {
      occupied.push(makeRow(columns));
    }
  }

  function isFree(occupied, row, column, columnSpan, rowSpan, columns) {
    if (column + columnSpan > columns) {
      return false;
    }
    for (let rowOffset = 0; rowOffset < rowSpan; rowOffset++) {
      ensureRow(occupied, row + rowOffset, columns);
      for (let columnOffset = 0; columnOffset < columnSpan; columnOffset++) {
        if (occupied[row + rowOffset][column + columnOffset]) {
          return false;
        }
      }
    }
    return true;
  }

  function occupy(occupied, placement, columns) {
    for (let rowOffset = 0; rowOffset < placement.rowSpan; rowOffset++) {
      ensureRow(occupied, placement.row + rowOffset, columns);
      for (let columnOffset = 0; columnOffset < placement.columnSpan; columnOffset++) {
        occupied[placement.row + rowOffset][placement.column + columnOffset] = true;
      }
    }
  }

  function ownerRowsFor(placements, columns) {
    const rows = [];
    for (let index = 0; index < placements.length; index++) {
      const placement = placements[index];
      for (let rowOffset = 0; rowOffset < placement.rowSpan; rowOffset++) {
        const row = placement.row + rowOffset;
        rows[row] ??= Array.from({ length: columns }, () => -1);
        for (let columnOffset = 0; columnOffset < placement.columnSpan; columnOffset++) {
          rows[row][placement.column + columnOffset] = index;
        }
      }
    }
    return rows.map((row) => row ?? Array.from({ length: columns }, () => -1));
  }

  function canExtendDown(ownerRows, placement, row) {
    const targetRow = ownerRows[row];
    if (!targetRow) {
      return false;
    }
    for (let column = placement.column; column < placement.column + placement.columnSpan; column++) {
      if (targetRow[column] !== -1) {
        return false;
      }
    }
    return true;
  }

  function canExpandRight(ownerRows, placement, column) {
    for (let row = placement.row; row < placement.row + placement.rowSpan; row++) {
      if (ownerRows[row]?.[column] !== -1) {
        return false;
      }
    }
    return true;
  }

  function canExpandLeft(ownerRows, placement, column) {
    for (let row = placement.row; row < placement.row + placement.rowSpan; row++) {
      if (ownerRows[row]?.[column] !== -1) {
        return false;
      }
    }
    return true;
  }

  function canExtendUp(ownerRows, placement, row) {
    const targetRow = ownerRows[row];
    if (!targetRow) {
      return false;
    }
    for (let column = placement.column; column < placement.column + placement.columnSpan; column++) {
      if (targetRow[column] !== -1) {
        return false;
      }
    }
    return true;
  }

  function expansionCandidate(placements, items, index, nextPlacement, layout, maxRatioMismatch) {
    if (index < 0 || index >= placements.length) {
      return null;
    }
    if (
      nextPlacement.column < 0 ||
      nextPlacement.column + nextPlacement.columnSpan > layout.columns ||
      nextPlacement.columnSpan > layout.maxColumnSpan ||
      nextPlacement.rowSpan > layout.maxRowSpan + 3
    ) {
      return null;
    }

    const item = items[index] ?? {};
    const aspectRatio = safeNumber(item.aspectRatio, 1);
    const current = placements[index];
    const currentScore = spanRatioScore(
      aspectRatio,
      current.columnSpan,
      current.rowSpan,
      layout,
      item,
    );
    const nextScore = spanRatioScore(
      aspectRatio,
      nextPlacement.columnSpan,
      nextPlacement.rowSpan,
      layout,
      item,
    );
    const allowedMismatch = Math.max(currentScore + 0.08, maxRatioMismatch);
    if (nextScore > allowedMismatch) {
      return null;
    }

    const sizeDelta =
      Math.max(0, nextPlacement.columnSpan - current.columnSpan) +
      Math.max(0, nextPlacement.rowSpan - current.rowSpan);
    return {
      index,
      placement: nextPlacement,
      score: nextScore + sizeDelta * 0.02,
    };
  }

  function bestExpansionForHole(
    ownerRows,
    placements,
    items,
    row,
    column,
    layout,
    maxRatioMismatch,
    allowBelow,
  ) {
    const candidates = [];
    const columns = layout.columns;

    const aboveIndex = row > 0 ? ownerRows[row - 1]?.[column] : -1;
    if (aboveIndex >= 0) {
      const placement = placements[aboveIndex];
      if (
        placement.row + placement.rowSpan === row &&
        canExtendDown(ownerRows, placement, row)
      ) {
        const candidate = expansionCandidate(
          placements,
          items,
          aboveIndex,
          { ...placement, rowSpan: placement.rowSpan + 1 },
          layout,
          maxRatioMismatch,
        );
        if (candidate) candidates.push(candidate);
      }
    }

    const leftIndex = column > 0 ? ownerRows[row][column - 1] : -1;
    if (leftIndex >= 0) {
      const placement = placements[leftIndex];
      if (
        placement.column + placement.columnSpan === column &&
        canExpandRight(ownerRows, placement, column)
      ) {
        const candidate = expansionCandidate(
          placements,
          items,
          leftIndex,
          { ...placement, columnSpan: placement.columnSpan + 1 },
          layout,
          maxRatioMismatch,
        );
        if (candidate) candidates.push(candidate);
      }
    }

    const rightIndex = column + 1 < columns ? ownerRows[row][column + 1] : -1;
    if (rightIndex >= 0) {
      const placement = placements[rightIndex];
      if (
        placement.column === column + 1 &&
        canExpandLeft(ownerRows, placement, column)
      ) {
        const candidate = expansionCandidate(
          placements,
          items,
          rightIndex,
          {
            ...placement,
            column,
            columnSpan: placement.columnSpan + 1,
          },
          layout,
          maxRatioMismatch,
        );
        if (candidate) candidates.push(candidate);
      }
    }

    const belowIndex = allowBelow && row + 1 < ownerRows.length
      ? ownerRows[row + 1][column]
      : -1;
    if (belowIndex >= 0) {
      const placement = placements[belowIndex];
      if (
        placement.row === row + 1 &&
        canExtendUp(ownerRows, placement, row)
      ) {
        const candidate = expansionCandidate(
          placements,
          items,
          belowIndex,
          {
            ...placement,
            row,
            rowSpan: placement.rowSpan + 1,
          },
          layout,
          maxRatioMismatch,
        );
        if (candidate) candidates.push(candidate);
      }
    }

    candidates.sort((a, b) => a.score - b.score);
    return candidates[0] ?? null;
  }

  function applyExpansion(placements, expansion) {
    const placement = placements[expansion.index];
    placement.row = expansion.placement.row;
    placement.column = expansion.placement.column;
    placement.columnSpan = expansion.placement.columnSpan;
    placement.rowSpan = expansion.placement.rowSpan;
  }

  function sealInteriorHoles(placements, items, layout) {
    let changed = true;
    let guard = placements.length * layout.columns * 8;

    while (changed && guard-- > 0) {
      changed = false;
      const ownerRows = ownerRowsFor(placements, layout.columns);
      const lastRow = ownerRows.length - 1;

      for (let row = 0; row < lastRow && !changed; row++) {
        for (let column = 0; column < layout.columns; column++) {
          if (ownerRows[row][column] !== -1) {
            continue;
          }

          const expansion = bestExpansionForHole(
            ownerRows,
            placements,
            items,
            row,
            column,
            layout,
            layout.sealMaxRatioMismatch,
            true,
          );
          if (!expansion) {
            continue;
          }

          applyExpansion(placements, expansion);
          changed = true;
          break;
        }
      }
    }

    return placements;
  }

  function squareOffBottom(placements, items, layout) {
    let changed = true;
    let guard = placements.length * layout.columns * 2;

    while (changed && guard-- > 0) {
      changed = false;
      const ownerRows = ownerRowsFor(placements, layout.columns);
      const lastRow = ownerRows.length - 1;

      for (let column = 0; column < layout.columns; column++) {
        if (ownerRows[lastRow]?.[column] !== -1) {
          continue;
        }

        const expansion = bestExpansionForHole(
          ownerRows,
          placements,
          items,
          lastRow,
          column,
          layout,
          layout.bottomMaxRatioMismatch,
          false,
        );
        if (!expansion) {
          continue;
        }

        applyExpansion(placements, expansion);
        changed = true;
        break;
      }
    }

    return placements;
  }

  function firstEmptyCell(occupied, columns) {
    for (let row = 0; row < occupied.length; row++) {
      for (let column = 0; column < columns; column++) {
        if (!occupied[row][column]) {
          return { row, column };
        }
      }
    }
    return { row: occupied.length, column: 0 };
  }

  function lastOccupiedRow(occupied) {
    for (let row = occupied.length - 1; row >= 0; row--) {
      if (occupied[row].some(Boolean)) {
        return row;
      }
    }
    return -1;
  }

  function galleryPack(items, options = {}) {
    const layout = layoutOptions(options, options.columns);
    const usesOwnerSizing =
      layout.minimumTileArea !== null ||
      layout.targetTileArea !== null;
    const columns = layout.columns;
    const occupied = [];
    const placements = [];
    for (const item of items) {
      const candidates = galleryCandidateSpans(
        item,
        { ...options, columns },
      );
      const placement = usesOwnerSizing
        ? bestFrontierPlacementForItem(occupied, candidates, layout)
        : bestPlacementForItem(occupied, candidates, layout);
      occupy(occupied, placement, columns);
      placements.push(placement);
    }

    if (usesOwnerSizing) {
      return placements;
    }

    return squareOffBottom(
      sealInteriorHoles(placements, items, layout),
      items,
      layout,
    );
  }

  function bestFrontierPlacementForItem(occupied, candidates, layout) {
    const firstCell = firstEmptyCell(occupied, layout.columns);

    for (const candidate of candidates) {
      const area = candidate.columnSpan * candidate.rowSpan;
      if (
        layout.minimumTileArea !== null &&
        area < layout.minimumTileArea
      ) {
        continue;
      }
      if (firstCell.column + candidate.columnSpan > layout.columns) {
        continue;
      }
      if (
        !isFree(
          occupied,
          firstCell.row,
          firstCell.column,
          candidate.columnSpan,
          candidate.rowSpan,
          layout.columns,
        )
      ) {
        continue;
      }

      return {
        row: firstCell.row,
        column: firstCell.column,
        columnSpan: candidate.columnSpan,
        rowSpan: candidate.rowSpan,
      };
    }

    return {
      row: firstCell.row,
      column: firstCell.column,
      columnSpan: 1,
      rowSpan: Math.max(1, Math.ceil(layout.minimumTileArea ?? 1)),
    };
  }

  function bestPlacementForItem(occupied, candidates, layout) {
    const firstCell = firstEmptyCell(occupied, layout.columns);
    const maxSearchRow = Math.max(
      firstCell.row + layout.maxRowSpan + layout.columns + 4,
      lastOccupiedRow(occupied) + 1,
    );
    let best = null;

    for (const candidate of candidates) {
      const maxColumn = layout.columns - candidate.columnSpan;
      for (let row = firstCell.row; row <= maxSearchRow; row++) {
        const startColumn = row === firstCell.row ? firstCell.column : 0;
        for (let column = startColumn; column <= maxColumn; column++) {
          if (
            !isFree(
              occupied,
              row,
              column,
              candidate.columnSpan,
              candidate.rowSpan,
              layout.columns,
            )
          ) {
            continue;
          }

          const rowDelay = row - firstCell.row;
          const columnDrift = row === firstCell.row
            ? Math.abs(column - firstCell.column)
            : column;
          const score =
            candidate.score +
            rowDelay * layout.rowDelayPenalty +
            columnDrift * layout.columnDriftPenalty;
          if (!best || score < best.score) {
            best = {
              row,
              column,
              columnSpan: candidate.columnSpan,
              rowSpan: candidate.rowSpan,
              score,
            };
          }
        }
      }
    }

    if (best) {
      return {
        row: best.row,
        column: best.column,
        columnSpan: best.columnSpan,
        rowSpan: best.rowSpan,
      };
    }

    const fallback = candidates[0] ?? { columnSpan: 1, rowSpan: 1 };
    return {
      // The scored search always includes the first wholly empty row, so this
      // branch is only defensive. Keep it below every occupied cell instead of
      // forcing a multi-cell tile into a fragmented first gap.
      row: lastOccupiedRow(occupied) + 1,
      column: 0,
      columnSpan: Math.min(fallback.columnSpan, layout.columns),
      rowSpan: fallback.rowSpan,
    };
  }

  // Pure mapping from a placement to its CSS grid-line values.
  function galleryPlacementStyle(placement) {
    return {
      gridColumn: `${placement.column + 1} / span ${placement.columnSpan}`,
      gridRow: `${placement.row + 1} / span ${placement.rowSpan}`,
    };
  }

  // The grid-column value galleryPlacementStyle writes.
  const PACKED_COLUMN = /^\d+ \/ span \d+$/;

  function resetPlacementsForMeasurement(
    elements,
    previousWidth,
    currentWidth,
  ) {
    const isFirstMeasurement = !Number.isFinite(previousWidth);
    const widthShrank = currentWidth < previousWidth - 0.5;
    // A framework re-sync (Jaspr diffing) can rewrite an item's inline style
    // back to its rendered span-only form at an unchanged width. Those spans
    // can also address implicit tracks, so treat any item without a packed
    // `N / span M` placement like a first measurement.
    const placementReplaced = elements.some(
      (element) => !PACKED_COLUMN.test(element.style.gridColumn || ''),
    );
    if (!isFirstMeasurement && !widthShrank && !placementReplaced) {
      return false;
    }

    for (const element of elements) {
      // A placement written for a wider grid can address a column that no longer
      // exists. CSS then creates an implicit sliver track, and the resolved
      // gridTemplateColumns value includes that track. Neutralize our placements
      // while measuring so the packer sees only the current explicit grid.
      element.style.gridColumn = 'auto';
      element.style.gridRow = 'auto';
    }
    return true;
  }

  const lastMeasuredWidth = typeof WeakMap === 'function' ? new WeakMap() : null;

  function setLayoutProperty(element, property, value) {
    if (element.style.getPropertyValue(property) === value) return;
    if (value) element.style.setProperty(property, value);
    else element.style.removeProperty(property);
  }

  function styleNumber(style, property) {
    return Number.parseFloat(style.getPropertyValue(property)) || 0;
  }

  function boxInsets(style) {
    return {
      horizontal: styleNumber(style, 'border-left-width') + styleNumber(style, 'border-right-width') +
        styleNumber(style, 'padding-left') + styleNumber(style, 'padding-right'),
      vertical: styleNumber(style, 'border-top-width') + styleNumber(style, 'border-bottom-width') +
        styleNumber(style, 'padding-top') + styleNumber(style, 'padding-bottom'),
    };
  }

  function layoutHeight(element, style) {
    const height = Number.parseFloat(style.height);
    if (!Number.isFinite(height)) return element.offsetHeight;
    return height + (style.boxSizing === 'border-box' ? 0 : boxInsets(style).vertical);
  }

  function applyJustifiedRows(container) {
    const style = window.getComputedStyle(container);
    // Computed CSS widths retain fractions without inheriting visual transforms.
    const width = styleNumber(style, 'width') -
      (style.boxSizing === 'border-box' ? boxInsets(style).horizontal : 0);
    if (width <= 0) return;
    const items = Array.from(container.children)
      .filter((element) => element.hasAttribute('data-arcane-gallery-item'))
      .map((element) => {
        const media = element.querySelector('[data-arcane-gallery-media]');
        const frameStyle = window.getComputedStyle(element);
        const frameInsets = boxInsets(frameStyle);
        const mediaInsets = media ? boxInsets(window.getComputedStyle(media)) : { horizontal: 0, vertical: 0 };
        return {
          element, media, frameStyle, frameInsets, mediaInsets,
          aspectRatio: safeNumber(element.dataset.ratio, 1),
          chromeWidth: frameInsets.horizontal + mediaInsets.horizontal,
          minimumWidth: element.querySelector('[data-arcane-gallery-caption]') ? 180 : 0,
        };
      });
    const gap = styleNumber(style, 'column-gap');
    const rowGap = styleNumber(style, 'row-gap');
    const clearance = styleNumber(style, '--arcane-gallery-decoration-clearance');
    const horizontalRoom = Math.max(0, Math.min(gap / 2,
      styleNumber(style, 'padding-left'), styleNumber(style, 'padding-right')) - clearance - .5);
    const verticalRoom = Math.max(0, Math.min(rowGap / 2,
      styleNumber(style, 'padding-top'), styleNumber(style, 'padding-bottom')) - clearance - .5);
    const maxHeight = items.some((item) => item.minimumWidth > 0) ? 600 : 380;
    const rows = galleryJustifiedRows(items, { width, gap, maxHeight });

    for (let rowIndex = 0; rowIndex < rows.length; rowIndex++) {
      const row = rows[rowIndex];
      const imageHeight = Math.max(1 / 64, Math.floor(row.height * 64) / 64);
      const rowItems = items.slice(row.start, row.start + row.count);
      const panelWidths = row.widths.map((panelWidth) => Math.floor(panelWidth * 64) / 64);
      const rowWidth = panelWidths.reduce((sum, panelWidth) => sum + panelWidth, 0) +
        (row.count - 1) * gap;
      for (let index = 0; index < rowItems.length; index++) {
        const item = rowItems[index];
        // Round down to the browser's layout unit so a full row cannot wrap
        // its last panel because individual flex widths rounded upward.
        setLayoutProperty(item.element, 'width', panelWidths[index] + 'px');
        // Reserve a capped row's unused space without adding nodes that would
        // conflict with framework reconciliation or change the reading order.
        setLayoutProperty(item.element, 'margin-inline-end', index === rowItems.length - 1
          ? 'max(0px, calc(100% - ' + rowWidth + 'px))'
          : '0px');
        if (item.media) {
          setLayoutProperty(item.media, 'height', (imageHeight + item.mediaInsets.vertical) + 'px');
          setLayoutProperty(item.media, 'aspect-ratio', 'auto');
        }
      }

      let chromeHeight = 0;
      for (const item of rowItems) {
        let extra = item.frameInsets.vertical + item.mediaInsets.vertical;
        const children = Array.from(item.element.children);
        extra += Math.max(0, children.length - 1) * styleNumber(item.frameStyle, 'row-gap');
        for (const child of children) {
          const childStyle = window.getComputedStyle(child);
          extra += styleNumber(childStyle, 'margin-top') + styleNumber(childStyle, 'margin-bottom');
          if (child !== item.media) extra += layoutHeight(child, childStyle);
        }
        chromeHeight = Math.max(chromeHeight, extra);
      }
      for (let index = 0; index < rowItems.length; index++) {
        const item = rowItems[index];
        const panelHeight = imageHeight + chromeHeight;
        setLayoutProperty(item.element, 'height', panelHeight + 'px');
        const desiredAngle = styleNumber(item.frameStyle, '--arcane-gallery-panel-angle');
        let lower = 0;
        let upper = Math.abs(desiredAngle);
        // Reserve the rotated ink and focus bounds without scaling the artwork.
        for (let step = 0; step < 16; step++) {
          const angle = (lower + upper) / 2;
          const radians = angle * Math.PI / 180;
          const expansionX = (panelWidths[index] * (Math.cos(radians) - 1) +
            panelHeight * Math.sin(radians)) / 2;
          const expansionY = (panelHeight * (Math.cos(radians) - 1) +
            panelWidths[index] * Math.sin(radians)) / 2;
          if (expansionX <= horizontalRoom && expansionY <= verticalRoom) lower = angle;
          else upper = angle;
        }
        const rotation = Math.sign(desiredAngle) * Math.floor(lower * 1000) / 1000;
        setLayoutProperty(item.element, '--arcane-gallery-panel-rotation', rotation + 'deg');
        item.element.dataset.arcaneGalleryRow = String(rowIndex);
        item.element.dataset.arcaneGalleryDisplayRatio = String(item.aspectRatio);
        item.element.dataset.arcaneGalleryRatioMismatch = '0';
      }
    }
    container.classList.add('is-arcane-gallery-ready');
  }

  function applyMasonry(container) {
    if (!container || container.clientWidth <= 0) {
      return;
    }
    if (container.dataset.arcaneGalleryComposition === 'justified') {
      applyJustifiedRows(container);
      return;
    }

    const elements = Array.from(container.children).filter((element) =>
      element.hasAttribute('data-arcane-gallery-item'),
    );
    const currentWidth = container.clientWidth;
    resetPlacementsForMeasurement(
      elements,
      lastMeasuredWidth?.get(container),
      currentWidth,
    );
    lastMeasuredWidth?.set(container, currentWidth);

    const styles = window.getComputedStyle(container);
    const columns = trackCount(styles.gridTemplateColumns);
    const columnWidth = firstTrackWidth(
      styles.gridTemplateColumns,
      container.clientWidth / columns,
    );
    const rowHeight = safeNumber(
      styles.getPropertyValue('--arcane-gallery-row') || styles.gridAutoRows,
      80,
    );
    const gap = safeNumber(styles.rowGap, 0);
    const maxColumnSpan = safeNumber(
      container.dataset.arcaneGalleryMaxColumnSpan,
      DEFAULT_MAX_COLUMN_SPAN,
    );
    const maxRowSpan = safeNumber(
      container.dataset.arcaneGalleryMaxRowSpan,
      DEFAULT_MAX_ROW_SPAN,
    );
    const minimumTileArea = optionalPositiveNumber(
      container.dataset.arcaneGalleryMinimumTileArea,
    );
    const targetTileArea = optionalPositiveNumber(
      container.dataset.arcaneGalleryTargetTileArea,
    );
    const layout = layoutOptions(
      {
        columns,
        columnWidth,
        rowHeight,
        gap,
        maxColumnSpan,
        maxRowSpan,
        minimumTileArea,
        targetTileArea,
      },
      columns,
    );
    const items = elements.map((element) => {
      const item = { aspectRatio: safeNumber(element.dataset.ratio, 1) };
      if (element.dataset.arcaneGalleryMeasureMedia === 'true') {
        const media = element.querySelector('[data-arcane-gallery-media]');
        if (media) {
          const frameBounds = element.getBoundingClientRect();
          const mediaBounds = media.getBoundingClientRect();
          item.chromeHeight = Math.max(0, frameBounds.height - mediaBounds.height);
          item.chromeWidth = Math.max(0, frameBounds.width - mediaBounds.width);
        }
      }
      return item;
    });
    const placements = galleryPack(items, {
      columns,
      columnWidth,
      rowHeight,
      gap,
      maxColumnSpan,
      maxRowSpan,
      minimumTileArea: layout.minimumTileArea,
      targetTileArea: layout.targetTileArea,
    });

    for (let index = 0; index < elements.length; index++) {
      const placement = placements[index];
      const element = elements[index];
      const { gridColumn, gridRow } = galleryPlacementStyle(placement);
      // Skip-detection MUST read the live inline style, not a cache: framework
      // re-renders (Jaspr diffing) wipe the inline styles between repacks, and
      // a stale "already written" cache leaves those cells permanently unplaced
      // (1x1 auto-flow tiles + holes after infinite-scroll appends). This live
      // comparison is also the loop-breaker for the document MutationObserver:
      // our own style writes fire style mutations, but the echo repack finds the
      // styles already correct and writes nothing, so the observer settles.
      const displayRatio = spanDisplayRatio(
        placement.columnSpan,
        placement.rowSpan,
        columnWidth,
        rowHeight,
        gap,
        items[index],
      );
      const ratioMismatch = Math.abs(
        Math.log(displayRatio / safeNumber(items[index]?.aspectRatio, 1)),
      );
      if (element.style.gridColumn !== gridColumn) {
        element.style.gridColumn = gridColumn;
      }
      if (element.style.gridRow !== gridRow) {
        element.style.gridRow = gridRow;
      }
      element.dataset.arcaneGalleryColumnSpan = String(placement.columnSpan);
      element.dataset.arcaneGalleryRowSpan = String(placement.rowSpan);
      element.dataset.arcaneGalleryDisplayRatio = displayRatio.toFixed(4);
      element.dataset.arcaneGalleryRatioMismatch = ratioMismatch.toFixed(4);
      element.dataset.arcaneGalleryFit ||= 'cover';
    }

    container.classList.add('is-arcane-gallery-ready');
  }

  if (typeof window === 'undefined' || typeof document === 'undefined') {
    return;
  }

  const CONTAINER_SELECTOR = '[data-arcane-gallery][data-packing="true"], [data-arcane-gallery][data-arcane-gallery-composition="justified"]';
  const CONTENT_SELECTOR = '[data-arcane-gallery-caption], [data-arcane-gallery-footer]';
  const scheduled = new WeakSet();
  const observed = new WeakSet();
  const resizeObserver = 'ResizeObserver' in window
    ? new ResizeObserver((entries) => {
        for (const entry of entries) {
          schedule(containerFor(entry.target));
        }
      })
    : null;

  function schedule(container) {
    if (!container || scheduled.has(container)) {
      return;
    }
    scheduled.add(container);
    window.requestAnimationFrame(() => {
      scheduled.delete(container);
      applyMasonry(container);
    });
  }

  function observeSize(element) {
    if (observed.has(element)) return;
    observed.add(element);
    resizeObserver?.observe(element);
  }

  function observeContent(node) {
    if (node.matches?.(CONTENT_SELECTOR) && containerFor(node)) observeSize(node);
    node.querySelectorAll?.(CONTENT_SELECTOR).forEach((element) => {
      if (containerFor(element)) observeSize(element);
    });
  }

  function unobserveRemoved(node) {
    const elements = [node, ...node.querySelectorAll(CONTAINER_SELECTOR + ', ' + CONTENT_SELECTOR)];
    for (const element of elements) {
      if (!observed.has(element) || (element.isConnected && containerFor(element))) continue;
      resizeObserver?.unobserve(element);
      observed.delete(element);
      if (element.matches?.(CONTAINER_SELECTOR)) delete element.dataset.arcaneGalleryObserved;
    }
  }

  function observe(container) {
    if (!container) return;
    observeContent(container);
    observeSize(container);
    container.dataset.arcaneGalleryObserved = 'true';
    schedule(container);
  }

  function containerFor(node) {
    if (!node) {
      return null;
    }
    const element = node.nodeType === 1 ? node : node.parentElement;
    return element && element.closest
      ? element.closest(CONTAINER_SELECTOR)
      : null;
  }

  function refreshAll() {
    document
      .querySelectorAll(CONTAINER_SELECTOR)
      .forEach((container) => observe(container));
  }

  // Single document-level observer. childList mutations surface newly-added
  // packing containers and newly-added items (infinite-scroll appends);
  // attribute mutations surface Jaspr re-syncing inline styles (which wipes our
  // placements). Both are coalesced through schedule() -> rAF. Our own writes
  // are neutralized by the live-style skip-detection in applyMasonry, so the
  // observer settles instead of looping.
  function handleMutations(mutations) {
    for (const mutation of mutations) {
      if (mutation.type === 'childList') {
        for (const node of mutation.removedNodes) {
          if (node?.nodeType === 1) unobserveRemoved(node);
        }
        for (const node of mutation.addedNodes) {
          if (!node || node.nodeType !== 1) {
            continue;
          }
          if (node.matches && node.matches(CONTAINER_SELECTOR)) {
            observe(node);
          }
          if (node.querySelectorAll) {
            node
              .querySelectorAll(CONTAINER_SELECTOR)
              .forEach((container) => observe(container));
          }
          observeContent(node);
        }
        const container = containerFor(mutation.target);
        if (container) {
          schedule(container);
        }
      } else if (mutation.type === 'attributes') {
        const container = containerFor(mutation.target);
        if (container) {
          // Drag offsets are CSS custom properties on gallery items. Repacking
          // the complete masonry grid on every pointermove causes avoidable
          // layout work and visible jank. The drag runtime explicitly requests
          // one final pack when the gesture finishes.
          if (
            mutation.attributeName === 'style' &&
            container.classList.contains('is-arcane-gallery-drag-active') &&
            mutation.target.matches?.('[data-arcane-draggable-item="true"]')
          ) {
            continue;
          }
          schedule(container);
        }
      }
    }
  }

  const documentObserver = 'MutationObserver' in window
    ? new MutationObserver(handleMutations)
    : null;

  function startDocumentObserver() {
    documentObserver?.observe(document.documentElement || document.body, {
      childList: true,
      subtree: true,
      attributes: true,
      attributeFilter: [
        'style',
        'data-ratio',
        'data-packing',
        'data-arcane-gallery-composition',
        'data-arcane-gallery-minimum-tile-area',
        'data-arcane-gallery-target-tile-area',
      ],
    });
  }

  window.ArcaneGallery = {
    observe,
    refresh: refreshAll,
    refreshAll,
    pack: galleryPack,
    justifiedRows: galleryJustifiedRows,
    candidateSpans: galleryCandidateSpans,
  };

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => {
      startDocumentObserver();
      refreshAll();
    }, { once: true });
  } else {
    startDocumentObserver();
    refreshAll();
  }
})();
''';
}
