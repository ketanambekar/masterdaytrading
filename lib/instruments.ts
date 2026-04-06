export type InstrumentItem = {
  key: string;
  label: string;
  kind: string;
  name?: string;
};

export const FALLBACK_INSTRUMENTS: InstrumentItem[] = [
  { key: "NSE_EQ|INE848E01016", label: "Reliance", kind: "equity" },
  { key: "NSE_EQ|INE467B01029", label: "TCS", kind: "equity" },
  { key: "NSE_EQ|INE009A01021", label: "Infosys", kind: "equity" },
  { key: "NSE_EQ|INE040A01034", label: "HDFC Bank", kind: "equity" },
  { key: "NSE_INDEX|Nifty 50", label: "Nifty 50", kind: "index" },
  { key: "NSE_INDEX|Nifty Bank", label: "Nifty Bank", kind: "index" },
];

function pickString(record: Record<string, unknown>, keys: string[]): string {
  for (const key of keys) {
    const value = record[key];
    if (typeof value === "string" && value.trim()) {
      return value.trim();
    }
  }

  return "";
}

function looksLikeEquityOrIndex(key: string, kind: string): boolean {
  const keyNorm = key.toUpperCase();
  const kindNorm = kind.toUpperCase();

  if (keyNorm.includes("_EQ|") || keyNorm.includes("_INDEX|")) {
    return true;
  }

  return /\bEQUITY\b|\bEQ\b|\bINDEX\b/.test(kindNorm);
}

function normalizeInstrument(raw: unknown): InstrumentItem | null {
  if (!raw || typeof raw !== "object") {
    return null;
  }

  const record = raw as Record<string, unknown>;

  const key = pickString(record, [
    "instrument_key",
    "instrumentKey",
    "key",
    "instrumentKeyValue",
  ]);

  const label = pickString(record, [
    "trading_symbol",
    "tradingSymbol",
    "symbol",
    "name",
    "display_name",
    "displayName",
  ]);

  const exchange = pickString(record, ["exchange", "exchange_segment", "exchangeSegment"]);
  const kind = pickString(record, ["instrument_type", "instrumentType", "type", "segment", "asset_type"]);

  if (!key || !label || !looksLikeEquityOrIndex(key, kind)) {
    return null;
  }

  const finalLabel = exchange ? `${label} (${exchange})` : label;
  const normalizedKind = /INDEX/i.test(kind) || key.toUpperCase().includes("_INDEX|") ? "index" : "equity";

  const rawName = pickString(record, ["name"]);
  const companyName = rawName && rawName !== label ? rawName : undefined;

  return {
    key,
    label: finalLabel,
    kind: normalizedKind,
    name: companyName,
  };
}

function uniqByKey(items: InstrumentItem[]): InstrumentItem[] {
  const seen = new Set<string>();
  const out: InstrumentItem[] = [];

  for (const item of items) {
    if (seen.has(item.key)) {
      continue;
    }
    seen.add(item.key);
    out.push(item);
  }

  return out;
}

export function parseCompleteInstruments(payload: unknown): InstrumentItem[] {
  const fromRoot = Array.isArray(payload)
    ? payload
    : payload && typeof payload === "object"
      ? ((payload as Record<string, unknown>).data ??
          (payload as Record<string, unknown>).instruments ??
          (payload as Record<string, unknown>).results ??
          (payload as Record<string, unknown>).items)
      : [];

  if (!Array.isArray(fromRoot)) {
    return FALLBACK_INSTRUMENTS;
  }

  const parsed = uniqByKey(fromRoot.map(normalizeInstrument).filter((item): item is InstrumentItem => Boolean(item)));

  if (!parsed.length) {
    return FALLBACK_INSTRUMENTS;
  }

  return parsed.sort((a, b) => a.label.localeCompare(b.label));
}
