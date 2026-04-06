'use client'

import { useState } from 'react'
import { useChartStore } from '@/store/chartStore'
import { useUIStore } from '@/store/uiStore'
import { useDrawingStore } from '@/store/drawingStore'
import { upstoxAPI } from '@/lib/upstox/api'
import { format } from 'date-fns'

/**
 * Toolbar Component
 * Contains instrument selector, timeframe selector, drawing tools, theme toggle
 */
export default function Toolbar() {
  const {
    instrument,
    interval,
    fromDate,
    toDate,
    setInstrument,
    setInterval,
    setFromDate,
    setToDate,
    setCandles,
    isLoading,
  } = useChartStore()

  const { theme, toggleTheme } = useUIStore()
  const { activeTool, setActiveTool } = useDrawingStore()

  // Initialize dates with proper defaults
  const today = new Date()
  const thirtyDaysAgo = new Date()
  thirtyDaysAgo.setDate(today.getDate() - 30)

  const [localInstrument, setLocalInstrument] = useState(instrument)
  const [localInterval, setLocalInterval] = useState(interval)
  const [localFromDate, setLocalFromDate] = useState(
    fromDate || format(thirtyDaysAgo, 'yyyy-MM-dd')
  )
  const [localToDate, setLocalToDate] = useState(
    toDate || format(today, 'yyyy-MM-dd')
  )
  const [error, setError] = useState<string | null>(null)

  const intervals = [
    { value: '1minute', label: '1m' },
    { value: '5minute', label: '5m' },
    { value: '15minute', label: '15m' },
    { value: '30minute', label: '30m' },
    { value: '1hour', label: '1h' },
    { value: 'day', label: '1D' },
    { value: 'week', label: '1W' },
    { value: 'month', label: '1M' },
  ]

  const drawingTools = [
    { type: 'none', icon: '↖', label: 'Select' },
    { type: 'trendline', icon: '╱', label: 'Trendline' },
    { type: 'horizontal', icon: '―', label: 'Horizontal' },
    { type: 'fib', icon: 'φ', label: 'Fibonacci' },
    { type: 'brush', icon: '✎', label: 'Brush' },
    { type: 'text', icon: 'T', label: 'Text' },
    { type: 'eraser', icon: '⌫', label: 'Eraser' },
  ]

  const handleFetchData = async () => {
    try {
      setError(null)
      setInstrument(localInstrument)
      setInterval(localInterval)
      setFromDate(localFromDate)
      setToDate(localToDate)

      const candles = await upstoxAPI.getCandles({
        instrument: localInstrument,
        interval: localInterval,
        fromDate: localFromDate,
        toDate: localToDate,
      })

      setCandles(candles)
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to fetch data')
    }
  }

  return (
    <div className="toolbar flex flex-col gap-4 p-4 bg-dark-surface border-r border-dark-border w-80">
      {/* Header */}
      <div className="flex items-center justify-between">
        <h2 className="text-xl font-bold text-dark-text">Trading Chart</h2>
        <button
          onClick={toggleTheme}
          className="p-2 rounded hover:bg-dark-hover"
          title={`Switch to ${theme === 'dark' ? 'light' : 'dark'} mode`}
        >
          {theme === 'dark' ? '☀️' : '🌙'}
        </button>
      </div>

      {/* Instrument Input */}
      <div>
        <label className="block text-sm font-medium text-dark-text-secondary mb-1">
          Instrument Key
        </label>
        <input
          type="text"
          value={localInstrument}
          onChange={(e) => setLocalInstrument(e.target.value)}
          placeholder="NSE_EQ|INE848E01016"
          className="w-full px-3 py-2 bg-dark-bg border border-dark-border rounded text-dark-text focus:outline-none focus:border-primary"
        />
        <p className="text-xs text-dark-text-secondary mt-1">
          Example: NSE_EQ|INE848E01016 (Reliance)
        </p>
      </div>

      {/* Interval Selector */}
      <div>
        <label className="block text-sm font-medium text-dark-text-secondary mb-1">
          Timeframe
        </label>
        <div className="grid grid-cols-4 gap-2">
          {intervals.map((int) => (
            <button
              key={int.value}
              onClick={() => setLocalInterval(int.value)}
              className={`px-3 py-2 rounded text-sm font-medium transition-colors ${
                localInterval === int.value
                  ? 'bg-primary text-white'
                  : 'bg-dark-bg text-dark-text hover:bg-dark-hover'
              }`}
            >
              {int.label}
            </button>
          ))}
        </div>
      </div>

      {/* Date Range */}
      <div className="grid grid-cols-2 gap-2">
        <div>
          <label className="block text-sm font-medium text-dark-text-secondary mb-1">
            From Date
          </label>
          <input
            type="date"
            value={localFromDate}
            onChange={(e) => setLocalFromDate(e.target.value)}
            className="w-full px-3 py-2 bg-dark-bg border border-dark-border rounded text-dark-text focus:outline-none focus:border-primary"
          />
        </div>
        <div>
          <label className="block text-sm font-medium text-dark-text-secondary mb-1">
            To Date
          </label>
          <input
            type="date"
            value={localToDate}
            onChange={(e) => setLocalToDate(e.target.value)}
            className="w-full px-3 py-2 bg-dark-bg border border-dark-border rounded text-dark-text focus:outline-none focus:border-primary"
          />
        </div>
      </div>

      {/* Fetch Button */}
      <button
        onClick={handleFetchData}
        disabled={isLoading}
        className="w-full px-4 py-2 bg-primary text-white rounded font-medium hover:bg-primary-dark disabled:opacity-50 disabled:cursor-not-allowed"
      >
        {isLoading ? 'Loading...' : 'Fetch Data'}
      </button>

      {error && (
        <div className="p-3 bg-red-500/10 border border-red-500 rounded text-red-500 text-sm">
          {error}
        </div>
      )}

      {/* Drawing Tools */}
      <div className="border-t border-dark-border pt-4">
        <label className="block text-sm font-medium text-dark-text-secondary mb-2">
          Drawing Tools
        </label>
        <div className="grid grid-cols-2 gap-2">
          {drawingTools.map((tool) => (
            <button
              key={tool.type}
              onClick={() => setActiveTool(tool.type as any)}
              className={`px-3 py-2 rounded text-sm font-medium transition-colors flex items-center gap-2 ${
                activeTool === tool.type
                  ? 'bg-primary text-white'
                  : 'bg-dark-bg text-dark-text hover:bg-dark-hover'
              }`}
              title={tool.label}
            >
              <span className="text-lg">{tool.icon}</span>
              <span>{tool.label}</span>
            </button>
          ))}
        </div>
      </div>

      {/* Quick Info */}
      <div className="border-t border-dark-border pt-4 text-xs text-dark-text-secondary">
        <p className="mb-1">
          <span className="font-medium">Keyboard Shortcuts:</span>
        </p>
        <ul className="space-y-1">
          <li>R - Toggle Replay Mode</li>
          <li>Space - Play/Pause</li>
          <li>N - Next Bar</li>
          <li>P - Previous Bar</li>
          <li>Esc - Cancel Drawing</li>
        </ul>
      </div>
    </div>
  )
}
