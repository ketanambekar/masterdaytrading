"use client";

import { useEffect, useMemo, useRef, useState } from "react";
import {
  createChart,
  type CandlestickData,
  type IChartApi,
  type ISeriesApi,
  type UTCTimestamp,
} from "lightweight-charts";

const SPEEDS = [1, 2, 4, 8];
const INSTRUMENTS = [
  { label: "Reliance", key: "NSE_EQ|INE848E01016" },
  { label: "TCS", key: "NSE_EQ|INE467B01029" },
  { label: "Infosys", key: "NSE_EQ|INE009A01021" },
  { label: "HDFC Bank", key: "NSE_EQ|INE040A01034" },
];

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

export default function ReplayChart() {
  const containerRef = useRef<HTMLDivElement | null>(null);
  const chartRef = useRef<IChartApi | null>(null);
  const seriesRef = useRef<ISeriesApi<"Candlestick"> | null>(null);
  const timerRef = useRef<ReturnType<typeof setInterval> | null>(null);

  const defaultToDate = useMemo(() => formatDate(new Date()), []);
  const defaultFromDate = useMemo(() => {
    const d = new Date();
    d.setDate(d.getDate() - 10);
    return formatDate(d);
  }, []);

  const [candles, setCandles] = useState<CandlestickData<UTCTimestamp>[]>([]);
  const [cursor, setCursor] = useState(0);
  const [isPlaying, setIsPlaying] = useState(false);
  const [speed, setSpeed] = useState(1);
  const [instrumentKey, setInstrumentKey] = useState(INSTRUMENTS[0].key);
  const [unit, setUnit] = useState("minutes");
  const [interval, setIntervalValue] = useState(5);
  const [fromDate, setFromDate] = useState(defaultFromDate);
  const [toDate, setToDate] = useState(defaultToDate);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const previousHtmlOverflow = document.documentElement.style.overflow;
    const previousBodyOverflow = document.body.style.overflow;
    document.documentElement.style.overflow = "hidden";
    document.body.style.overflow = "hidden";

    return () => {
      document.documentElement.style.overflow = previousHtmlOverflow;
      document.body.style.overflow = previousBodyOverflow;
    };
  }, []);

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
        timeFormatter: (time) => {
          if (typeof time === "number") {
            return formatIstLabel(time as UTCTimestamp);
          }

          const asUnix = Math.floor(
            Date.UTC(time.year, time.month - 1, time.day) / 1000,
          ) as UTCTimestamp;
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

    return () => {
      if (timerRef.current) {
        clearInterval(timerRef.current);
      }
      chart.remove();
    };
  }, []);

  useEffect(() => {
    if (!seriesRef.current) return;
    seriesRef.current.setData(candles.slice(0, cursor));
    chartRef.current?.timeScale().fitContent();
  }, [candles, cursor]);

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
      setCursor(Math.min(25, nextCandles.length));
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
            {INSTRUMENTS.map((instrument) => (
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
            setCursor(Math.min(25, candles.length));
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
