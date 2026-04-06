"use client";

import { useEffect, useMemo, useRef, useState } from "react";
import {
  createChart,
  type CandlestickData,
  type IChartApi,
  type IPriceLine,
  type ISeriesApi,
  type LineData,
  type LineStyle,
  type MouseEventParams,
  type Time,
  type UTCTimestamp,
} from "lightweight-charts";
import { FALLBACK_INSTRUMENTS, parseCompleteInstruments, type InstrumentItem } from "@/lib/instruments";

const SPEEDS = [1, 2, 4, 8];

const UNIT_INTERVALS: Record<string, number[]> = {
  minutes: [1, 3, 5, 15, 30, 60],
  hours: [1, 2, 4],
  days: [1],
  weeks: [1],
  months: [1],
};

function formatDate(date: Date): string {
  return new Intl.DateTimeFormat("en-CA", {
    timeZone: "Asia/Kolkata",
  }).format(date);
}

function formatIstLabel(time: UTCTimestamp): string {
  return new Intl.DateTimeFormat("en-IN", {
    timeZone: "Asia/Kolkata",
    day: "2-digit",
    month: "short",
    year: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
    hour12: false,
  }).format(new Date(Number(time) * 1000));
}

function calculateSma(
  data: CandlestickData<UTCTimestamp>[],
  period: number,
): LineData<Time>[] {
  if (data.length < period) return [];

  const out: LineData<Time>[] = [];
  for (let i = period - 1; i < data.length; i += 1) {
    let sum = 0;
    for (let j = i - period + 1; j <= i; j += 1) {
      sum += data[j].close;
    }

    out.push({
      time: data[i].time,
      value: Number((sum / period).toFixed(2)),
    });
  }

  return out;
}

function calculateEma(
  data: CandlestickData<UTCTimestamp>[],
  period: number,
): LineData<Time>[] {
  if (!data.length) return [];

  const out: LineData<Time>[] = [];
  const multiplier = 2 / (period + 1);
  let ema = data[0].close;

  for (let i = 0; i < data.length; i += 1) {
    ema = i === 0 ? data[i].close : (data[i].close - ema) * multiplier + ema;

    if (i >= period - 1) {
      out.push({
        time: data[i].time,
        value: Number(ema.toFixed(2)),
      });
    }
  }

  return out;
}

type DrawingMode = "none" | "trend" | "hline";

type ReplayChartProps = {
  initialInstrumentKey?: string;
};

export default function ReplayChart({ initialInstrumentKey }: ReplayChartProps) {
  const containerRef = useRef<HTMLDivElement | null>(null);
  const chartRef = useRef<IChartApi | null>(null);
  const seriesRef = useRef<ISeriesApi<"Candlestick"> | null>(null);
  const smaSeriesRef = useRef<ISeriesApi<"Line"> | null>(null);
  const emaSeriesRef = useRef<ISeriesApi<"Line"> | null>(null);
  const trendLinesRef = useRef<Array<ISeriesApi<"Line">>>([]);
  const horizontalLinesRef = useRef<IPriceLine[]>([]);
  const trendStartRef = useRef<{ time: Time; price: number } | null>(null);
  const drawingModeRef = useRef<DrawingMode>("none");
  const timerRef = useRef<ReturnType<typeof setInterval> | null>(null);

  const defaultToDate = useMemo(() => formatDate(new Date()), []);
  const defaultFromDate = useMemo(() => {
    const d = new Date();
    d.setDate(d.getDate() - 10);
    return formatDate(d);
  }, []);

  const [candles, setCandles] = useState<CandlestickData<UTCTimestamp>[]>([]);
  const [instruments, setInstruments] = useState<InstrumentItem[]>(FALLBACK_INSTRUMENTS);
  const [cursor, setCursor] = useState(0);
  const [isPlaying, setIsPlaying] = useState(false);
  const [speed, setSpeed] = useState(1);
  const [instrumentKey, setInstrumentKey] = useState(initialInstrumentKey ?? FALLBACK_INSTRUMENTS[0].key);
  const [unit, setUnit] = useState("minutes");
  const [interval, setIntervalValue] = useState(5);
  const [fromDate, setFromDate] = useState(defaultFromDate);
  const [toDate, setToDate] = useState(defaultToDate);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [showSma, setShowSma] = useState(true);
  const [showEma, setShowEma] = useState(false);
  const [drawingMode, setDrawingMode] = useState<DrawingMode>("none");

  useEffect(() => {
    drawingModeRef.current = drawingMode;
  }, [drawingMode]);

  useEffect(() => {
    let cancelled = false;

    const loadInstruments = async () => {
      try {
        const response = await fetch("/assets/complete.json", { cache: "no-store" });
        if (!response.ok) return;
        const payload = (await response.json()) as unknown;
        if (cancelled) return;
        const parsed = parseCompleteInstruments(payload);
        setInstruments(parsed);
      } catch {
        // Keep fallback list.
      }
    };

    void loadInstruments();

    return () => {
      cancelled = true;
    };
  }, []);

  useEffect(() => {
    if (!initialInstrumentKey) return;
    setInstrumentKey(initialInstrumentKey);
  }, [initialInstrumentKey]);

  useEffect(() => {
    if (!instruments.length) return;
    const exists = instruments.some((item) => item.key === instrumentKey);
    if (!exists) {
      setInstrumentKey(instruments[0].key);
    }
  }, [instrumentKey, instruments]);

  useEffect(() => {
    if (!containerRef.current) return;

    const chart = createChart(containerRef.current, {
      autoSize: true,
      layout: {
        background: { color: "#0f1317" },
        textColor: "#cfd6df",
      },
      grid: {
        vertLines: { color: "rgba(207,214,223,0.06)" },
        horzLines: { color: "rgba(207,214,223,0.06)" },
      },
      rightPriceScale: {
        borderColor: "rgba(207,214,223,0.20)",
      },
      timeScale: {
        borderColor: "rgba(207,214,223,0.20)",
        timeVisible: true,
      },
      localization: {
        locale: "en-IN",
        timeFormatter: (time: Time) => {
          if (typeof time === "number") {
            return formatIstLabel(time as UTCTimestamp);
          }

          if (typeof time === "string") {
            const unix = Math.floor(new Date(time).getTime() / 1000) as UTCTimestamp;
            return formatIstLabel(unix);
          }

          const asUnix = Math.floor(Date.UTC(time.year, time.month - 1, time.day) / 1000) as UTCTimestamp;
          return formatIstLabel(asUnix);
        },
      },
      crosshair: {
        vertLine: { color: "#f7a623", width: 1 },
        horzLine: { color: "#f7a623", width: 1 },
      },
    });

    const series = chart.addCandlestickSeries({
      upColor: "#00b894",
      downColor: "#ff6b6b",
      borderUpColor: "#00b894",
      borderDownColor: "#ff6b6b",
      wickUpColor: "#00b894",
      wickDownColor: "#ff6b6b",
    });

    chartRef.current = chart;
    seriesRef.current = series;

    const onChartClick = (param: MouseEventParams<Time>) => {
      if (!seriesRef.current || !param.time || !param.point) return;
      const price = seriesRef.current.coordinateToPrice(param.point.y);
      if (price === null || price === undefined) return;

      if (drawingModeRef.current === "hline") {
        const line = seriesRef.current.createPriceLine({
          price,
          color: "#74b9ff",
          lineWidth: 1,
          lineStyle: 2 as LineStyle,
          axisLabelVisible: true,
          title: "H",
        });
        horizontalLinesRef.current.push(line);
        return;
      }

      if (drawingModeRef.current === "trend") {
        if (!trendStartRef.current) {
          trendStartRef.current = { time: param.time, price };
          return;
        }

        const trendLine = chart.addLineSeries({
          color: "#9b59b6",
          lineWidth: 2,
          priceLineVisible: false,
          crosshairMarkerVisible: false,
        });

        trendLine.setData([
          {
            time: trendStartRef.current.time,
            value: trendStartRef.current.price,
          },
          { time: param.time, value: price },
        ]);

        trendLinesRef.current.push(trendLine);
        trendStartRef.current = null;
      }
    };

    chart.subscribeClick(onChartClick);

    return () => {
      if (timerRef.current) {
        clearInterval(timerRef.current);
      }
      chart.unsubscribeClick(onChartClick);
      chart.remove();
    };
  }, []);

  useEffect(() => {
    if (!seriesRef.current) return;
    seriesRef.current.setData(candles.slice(0, cursor));
    chartRef.current?.timeScale().fitContent();
  }, [candles, cursor]);

  useEffect(() => {
    if (!chartRef.current) return;

    const visible = candles.slice(0, cursor);

    if (showSma) {
      if (!smaSeriesRef.current) {
        smaSeriesRef.current = chartRef.current.addLineSeries({
          color: "#f7a623",
          lineWidth: 2,
          priceLineVisible: false,
          crosshairMarkerVisible: false,
        });
      }
      smaSeriesRef.current.setData(calculateSma(visible, 20));
    } else if (smaSeriesRef.current) {
      chartRef.current.removeSeries(smaSeriesRef.current);
      smaSeriesRef.current = null;
    }

    if (showEma) {
      if (!emaSeriesRef.current) {
        emaSeriesRef.current = chartRef.current.addLineSeries({
          color: "#00d2d3",
          lineWidth: 2,
          priceLineVisible: false,
          crosshairMarkerVisible: false,
        });
      }
      emaSeriesRef.current.setData(calculateEma(visible, 20));
    } else if (emaSeriesRef.current) {
      chartRef.current.removeSeries(emaSeriesRef.current);
      emaSeriesRef.current = null;
    }
  }, [candles, cursor, showSma, showEma]);

  const fetchHistoricalData = async () => {
    setLoading(true);
    setError(null);
    setIsPlaying(false);

    try {
      const query = new URLSearchParams({
        instrumentKey,
        unit,
        interval: String(interval),
        fromDate,
        toDate,
      });

      const response = await fetch(`/api/candles?${query.toString()}`, {
        method: "GET",
      });

      const payload = (await response.json()) as {
        message?: string;
        candles?: Array<{
          time: number;
          open: number;
          high: number;
          low: number;
          close: number;
        }>;
      };

      if (!response.ok || !payload.candles) {
        throw new Error(payload.message ?? "Could not load historical candles");
      }

      const nextCandles = payload.candles.map((c) => ({
        time: c.time as UTCTimestamp,
        open: c.open,
        high: c.high,
        low: c.low,
        close: c.close,
      }));

      setCandles(nextCandles);
      setCursor(Math.min(15, nextCandles.length));
    } catch (err) {
      setCandles([]);
      setCursor(0);
      setError(err instanceof Error ? err.message : "Failed to load data");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    void fetchHistoricalData();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    if (timerRef.current) {
      clearInterval(timerRef.current);
      timerRef.current = null;
    }

    if (!isPlaying) return;

    const intervalMs = Math.max(150, 1000 / speed);

    timerRef.current = setInterval(() => {
      setCursor((prev) => {
        if (prev >= candles.length) {
          setIsPlaying(false);
          return prev;
        }
        return prev + 1;
      });
    }, intervalMs);

    return () => {
      if (timerRef.current) {
        clearInterval(timerRef.current);
        timerRef.current = null;
      }
    };
  }, [candles.length, isPlaying, speed]);

  const latest = candles[Math.max(0, cursor - 1)] as CandlestickData<UTCTimestamp> | undefined;

  const allowedIntervals = UNIT_INTERVALS[unit] ?? [1];

  useEffect(() => {
    if (!allowedIntervals.includes(interval)) {
      setIntervalValue(allowedIntervals[0]);
    }
  }, [allowedIntervals, interval]);

  const clearDrawings = () => {
    if (!chartRef.current || !seriesRef.current) return;

    for (const line of trendLinesRef.current) {
      chartRef.current.removeSeries(line);
    }
    trendLinesRef.current = [];

    for (const line of horizontalLinesRef.current) {
      seriesRef.current.removePriceLine(line);
    }
    horizontalLinesRef.current = [];
    trendStartRef.current = null;
    setDrawingMode("none");
  };

  return (
    <section className="replay-shell" aria-live="polite">
      <header className="replay-header">
        <div>
          <p className="eyebrow">Historical Replay</p>
          <h2>Candle-by-candle simulator</h2>
        </div>
        <p className="meta">
          Rendered: <strong>{cursor}</strong> / {candles.length} candles
        </p>
      </header>

      <form className="filter-grid" onSubmit={(e) => {
        e.preventDefault();
        void fetchHistoricalData();
      }}>
        <label>
          Instrument
          <select value={instrumentKey} onChange={(e) => setInstrumentKey(e.target.value)}>
            {instruments.map((instrument) => (
              <option key={instrument.key} value={instrument.key}>
                {instrument.label}
              </option>
            ))}
          </select>
        </label>
        <label>
          Unit
          <select value={unit} onChange={(e) => setUnit(e.target.value)}>
            {Object.keys(UNIT_INTERVALS).map((u) => (
              <option key={u} value={u}>
                {u}
              </option>
            ))}
          </select>
        </label>
        <label>
          Interval
          <select value={interval} onChange={(e) => setIntervalValue(Number(e.target.value))}>
            {allowedIntervals.map((value) => (
              <option key={value} value={value}>
                {value}
              </option>
            ))}
          </select>
        </label>
        <label>
          From
          <input type="date" value={fromDate} onChange={(e) => setFromDate(e.target.value)} />
        </label>
        <label>
          To
          <input type="date" value={toDate} onChange={(e) => setToDate(e.target.value)} />
        </label>
        <button className="btn btn-primary filter-submit" type="submit" disabled={loading}>
          {loading ? "Loading..." : "Fetch Historical"}
        </button>
      </form>

      {error ? <p className="error-banner">{error}</p> : null}

      <div className="chart-wrap" ref={containerRef} />

      <div className="control-row" role="group" aria-label="Replay controls">
        <button
          className="btn btn-primary"
          onClick={() => setIsPlaying((p) => !p)}
          disabled={!candles.length}
        >
          {isPlaying ? "Pause" : "Play"}
        </button>
        <button
          className="btn btn-ghost"
          onClick={() => setCursor((c) => Math.min(c + 1, candles.length))}
          disabled={!candles.length}
        >
          Step +1
        </button>
        <button
          className="btn btn-ghost"
          onClick={() => {
            setIsPlaying(false);
            setCursor(Math.min(15, candles.length));
          }}
          disabled={!candles.length}
        >
          Reset
        </button>
        <label className="speed-select" htmlFor="speed">
          Speed
          <select
            id="speed"
            value={speed}
            onChange={(e) => setSpeed(Number(e.target.value))}
          >
            {SPEEDS.map((v) => (
              <option key={v} value={v}>
                {v}x
              </option>
            ))}
          </select>
        </label>
      </div>

      <div className="analysis-row" role="group" aria-label="Indicators and drawing tools">
        <button
          type="button"
          className={`chip-btn ${showSma ? "chip-active" : ""}`}
          onClick={() => setShowSma((prev) => !prev)}
        >
          SMA 20
        </button>
        <button
          type="button"
          className={`chip-btn ${showEma ? "chip-active" : ""}`}
          onClick={() => setShowEma((prev) => !prev)}
        >
          EMA 20
        </button>
        <button
          type="button"
          className={`chip-btn ${drawingMode === "trend" ? "chip-active" : ""}`}
          onClick={() => {
            trendStartRef.current = null;
            setDrawingMode((prev) => (prev === "trend" ? "none" : "trend"));
          }}
        >
          Trend Line
        </button>
        <button
          type="button"
          className={`chip-btn ${drawingMode === "hline" ? "chip-active" : ""}`}
          onClick={() => {
            trendStartRef.current = null;
            setDrawingMode((prev) => (prev === "hline" ? "none" : "hline"));
          }}
        >
          Horizontal Line
        </button>
        <button type="button" className="chip-btn" onClick={clearDrawings}>
          Clear Drawings
        </button>
        <span className="tool-hint">
          Mode: {drawingMode === "none" ? "Browse" : drawingMode === "trend" ? "Trend (2 clicks)" : "Horizontal (click)"}
        </span>
      </div>

      <footer className="ticker-strip">
        <span>T: {latest ? formatIstLabel(latest.time as UTCTimestamp) : "-"}</span>
        <span>O: {latest?.open ?? "-"}</span>
        <span>H: {latest?.high ?? "-"}</span>
        <span>L: {latest?.low ?? "-"}</span>
        <span>C: {latest?.close ?? "-"}</span>
      </footer>
    </section>
  );
}
