"use client";

import { useEffect, useMemo, useRef, useState } from "react";
import {
  createChart,
  type CandlestickData,
  type IChartApi,
  type ISeriesApi,
  type UTCTimestamp,
} from "lightweight-charts";
import { getHistoricalCandles } from "@/lib/historicalData";

const SPEEDS = [1, 2, 4, 8];

export default function ReplayChart() {
  const containerRef = useRef<HTMLDivElement | null>(null);
  const chartRef = useRef<IChartApi | null>(null);
  const seriesRef = useRef<ISeriesApi<"Candlestick"> | null>(null);
  const timerRef = useRef<ReturnType<typeof setInterval> | null>(null);

  const candles = useMemo(() => getHistoricalCandles(300), []);

  const [cursor, setCursor] = useState(30);
  const [isPlaying, setIsPlaying] = useState(false);
  const [speed, setSpeed] = useState(1);

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

  useEffect(() => {
    if (timerRef.current) {
      clearInterval(timerRef.current);
      timerRef.current = null;
    }

    if (!isPlaying) return;

    const intervalMs = 1000 / speed;

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

  return (
    <section className="replay-shell">
      <header className="replay-header">
        <div>
          <p className="eyebrow">Historical Replay</p>
          <h2>Candle-by-candle simulator</h2>
        </div>
        <p className="meta">
          Rendered: <strong>{cursor}</strong> / {candles.length} candles
        </p>
      </header>

      <div className="chart-wrap" ref={containerRef} />

      <div className="control-row">
        <button className="btn btn-primary" onClick={() => setIsPlaying((p) => !p)}>
          {isPlaying ? "Pause" : "Play"}
        </button>
        <button
          className="btn btn-ghost"
          onClick={() => setCursor((c) => Math.min(c + 1, candles.length))}
        >
          Step +1
        </button>
        <button
          className="btn btn-ghost"
          onClick={() => {
            setIsPlaying(false);
            setCursor(30);
          }}
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
        <span>O: {latest?.open ?? "-"}</span>
        <span>H: {latest?.high ?? "-"}</span>
        <span>L: {latest?.low ?? "-"}</span>
        <span>C: {latest?.close ?? "-"}</span>
      </footer>
    </section>
  );
}
