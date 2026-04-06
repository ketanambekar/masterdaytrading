'use client'

import { useEffect, useRef } from 'react'
import { createChart, ColorType, IChartApi } from 'lightweight-charts'
import { useChartStore } from '@/store/chartStore'
import { useReplayStore } from '@/store/replayStore'
import { useUIStore } from '@/store/uiStore'
import { useIndicatorStore } from '@/store/indicatorStore'
import { useDrawingStore } from '@/store/drawingStore'
import { renderIndicators } from './IndicatorRenderer'
import { renderDrawings } from './DrawingRenderer'

/**
 * Main Chart Container Component
 * Renders the TradingView-style chart using lightweight-charts
 */
export default function ChartContainer() {
  const chartContainerRef = useRef<HTMLDivElement>(null)
  const chartRef = useRef<IChartApi | null>(null)

  const {
    visibleCandles,
    setChartApi,
    setCandlestickSeries,
    setVolumeSeries,
  } = useChartStore()

  const { theme, showVolume, showGrid } = useUIStore()
  const { indicators } = useIndicatorStore()
  const { drawings } = useDrawingStore()
  const { isReplayMode, currentIndex } = useReplayStore()

  // Initialize chart
  useEffect(() => {
    if (!chartContainerRef.current) return

    const chart = createChart(chartContainerRef.current, {
      width: chartContainerRef.current.clientWidth,
      height: chartContainerRef.current.clientHeight,
      layout: {
        background: { type: ColorType.Solid, color: theme === 'dark' ? '#0a0a0b' : '#ffffff' },
        textColor: theme === 'dark' ? '#d1d4dc' : '#191919',
      },
      grid: {
        vertLines: { visible: showGrid, color: theme === 'dark' ? '#2a2e39' : '#e1e3eb' },
        horzLines: { visible: showGrid, color: theme === 'dark' ? '#2a2e39' : '#e1e3eb' },
      },
      crosshair: {
        mode: 1,
        vertLine: {
          width: 1,
          color: theme === 'dark' ? '#758696' : '#9598a1',
          style: 3,
        },
        horzLine: {
          width: 1,
          color: theme === 'dark' ? '#758696' : '#9598a1',
          style: 3,
        },
      },
      rightPriceScale: {
        borderColor: theme === 'dark' ? '#2a2e39' : '#e1e3eb',
      },
      timeScale: {
        borderColor: theme === 'dark' ? '#2a2e39' : '#e1e3eb',
        timeVisible: true,
        secondsVisible: false,
      },
    })

    chartRef.current = chart
    setChartApi(chart)

    // Create candlestick series
    const candlestickSeries = chart.addCandlestickSeries({
      upColor: '#26a69a',
      downColor: '#ef5350',
      borderUpColor: '#26a69a',
      borderDownColor: '#ef5350',
      wickUpColor: '#26a69a',
      wickDownColor: '#ef5350',
    })
    setCandlestickSeries(candlestickSeries)

    // Create volume series if enabled
    if (showVolume) {
      const volumeSeries = chart.addHistogramSeries({
        color: '#26a69a',
        priceFormat: {
          type: 'volume',
        },
        priceScaleId: 'volume',
      })
      chart.priceScale('volume').applyOptions({
        scaleMargins: {
          top: 0.8,
          bottom: 0,
        },
      })
      setVolumeSeries(volumeSeries)
    }

    // Handle resize
    const handleResize = () => {
      if (chartContainerRef.current && chartRef.current) {
        chartRef.current.applyOptions({
          width: chartContainerRef.current.clientWidth,
          height: chartContainerRef.current.clientHeight,
        })
      }
    }

    window.addEventListener('resize', handleResize)

    return () => {
      window.removeEventListener('resize', handleResize)
      chart.remove()
    }
  }, [theme, showVolume, showGrid, setChartApi, setCandlestickSeries, setVolumeSeries])

  // Update chart data when candles change
  useEffect(() => {
    if (!chartRef.current) return

    const candlestickSeries = useChartStore.getState().candlestickSeries
    const volumeSeries = useChartStore.getState().volumeSeries

    if (candlestickSeries && visibleCandles.length > 0) {
      // In replay mode, only show candles up to currentIndex
      const displayCandles = isReplayMode 
        ? visibleCandles.slice(0, currentIndex + 1)
        : visibleCandles

      candlestickSeries.setData(displayCandles)

      if (volumeSeries) {
        const volumeData = displayCandles.map(c => ({
          time: c.time,
          value: c.volume,
          color: c.close >= c.open ? '#26a69a80' : '#ef535080',
        }))
        volumeSeries.setData(volumeData)
      }

      // Fit content to screen
      chartRef.current.timeScale().fitContent()
    }
  }, [visibleCandles, isReplayMode, currentIndex])

  // Render indicators
  useEffect(() => {
    if (!chartRef.current || visibleCandles.length === 0) return

    renderIndicators(chartRef.current, visibleCandles, indicators)
  }, [indicators, visibleCandles])

  // Render drawings
  useEffect(() => {
    if (!chartRef.current || visibleCandles.length === 0) return

    renderDrawings(chartRef.current, drawings)
  }, [drawings, visibleCandles])

  return (
    <div 
      ref={chartContainerRef} 
      className="chart-container w-full h-full bg-dark-bg"
    />
  )
}
