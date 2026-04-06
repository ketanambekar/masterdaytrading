"use client";

import { useEffect, useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import { FALLBACK_INSTRUMENTS, parseCompleteInstruments, type InstrumentItem } from "@/lib/instruments";

type InstrumentSearchProps = {
  initialKey?: string;
  placeholder?: string;
  buttonLabel?: string;
  className?: string;
};

export default function InstrumentSearch({
  initialKey,
  placeholder = "Search Equity / Index symbol...",
  buttonLabel = "Open Chart",
  className,
}: InstrumentSearchProps) {
  const router = useRouter();
  const [items, setItems] = useState<InstrumentItem[]>(FALLBACK_INSTRUMENTS);
  const [query, setQuery] = useState("");
  const [selected, setSelected] = useState<InstrumentItem | null>(null);
  const [isOpen, setIsOpen] = useState(false);

  useEffect(() => {
    let cancelled = false;

    const load = async () => {
      try {
        const response = await fetch("/assets/complete.json", { cache: "no-store" });
        if (!response.ok) {
          return;
        }
        const payload = (await response.json()) as unknown;
        if (cancelled) {
          return;
        }
        setItems(parseCompleteInstruments(payload));
      } catch {
        // Keep fallback instruments.
      }
    };

    void load();

    return () => {
      cancelled = true;
    };
  }, []);

  useEffect(() => {
    if (!initialKey || !items.length) {
      return;
    }

    const found = items.find((item) => item.key === initialKey);
    if (found) {
      setSelected(found);
      setQuery(found.label);
    }
  }, [initialKey, items]);

  const filtered = useMemo(() => {
    const input = query.trim().toLowerCase();
    if (!input) {
      return items.slice(0, 12);
    }

    return items
      .filter(
        (item) =>
          item.label.toLowerCase().includes(input) ||
          item.key.toLowerCase().includes(input) ||
          (item.name?.toLowerCase().includes(input) ?? false),
      )
      .slice(0, 12);
  }, [items, query]);

  const commitSelection = (item: InstrumentItem) => {
    setSelected(item);
    setQuery(item.label);
    setIsOpen(false);
  };

  const goToChart = () => {
    const picked = selected ?? filtered[0];
    if (!picked) {
      return;
    }

    const target = `/chart-page?instrumentKey=${encodeURIComponent(picked.key)}&instrumentLabel=${encodeURIComponent(picked.label)}`;
    router.push(target);
  };

  return (
    <section className={`instrument-search ${className ?? ""}`.trim()} aria-label="Instrument Search">
      <div className="instrument-search-head">
        <p className="eyebrow">Smart Symbol Finder</p>
        <h3>Choose Equity or Index</h3>
      </div>

      <div className="instrument-search-row">
        <div className="instrument-search-input-wrap">
          <input
            type="search"
            value={query}
            placeholder={placeholder}
            onFocus={() => setIsOpen(true)}
            onChange={(event) => {
              setQuery(event.target.value);
              setSelected(null);
              setIsOpen(true);
            }}
            onKeyDown={(event) => {
              if (event.key === "Enter") {
                event.preventDefault();
                goToChart();
              }
              if (event.key === "Escape") {
                setIsOpen(false);
              }
            }}
            aria-label="Search instrument"
          />

          {isOpen && filtered.length ? (
            <ul className="instrument-results" role="listbox" aria-label="Search results">
              {filtered.map((item) => (
                <li key={item.key}>
                  <button
                    type="button"
                    className="instrument-option"
                    onMouseDown={(event) => event.preventDefault()}
                    onClick={() => commitSelection(item)}
                  >
                    <span>{item.label}</span>
                    <small className="instrument-meta">
                      {item.name ? `${item.name} \u00b7 ` : ""}
                      {item.kind.toUpperCase()}
                    </small>
                  </button>
                </li>
              ))}
            </ul>
          ) : null}
        </div>

        <button type="button" className="btn btn-primary instrument-go" onClick={goToChart}>
          {buttonLabel}
        </button>
      </div>

      <p className="instrument-help">
        Showing only Equity and Index instruments. Replay starts from the first candle for strict timing practice.
      </p>
    </section>
  );
}
