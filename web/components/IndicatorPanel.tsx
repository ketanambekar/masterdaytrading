'use client'

import { useState } from 'react'
import { useIndicatorStore, INDICATOR_TYPES, DEFAULT_PARAMS } from '@/store/indicatorStore'

/**
 * Indicator Panel Component
 * Manage active indicators, add new ones, configure parameters
 */
export default function IndicatorPanel() {
  const { indicators, addIndicator, removeIndicator, updateIndicator, toggleIndicator } = useIndicatorStore()
  const [showAddModal, setShowAddModal] = useState(false)

  const handleAddIndicator = (type: keyof typeof INDICATOR_TYPES) => {
    addIndicator(type)
    setShowAddModal(false)
  }

  return (
    <div className="indicator-panel bg-dark-surface border-b border-dark-border p-4">
      <div className="flex items-center justify-between mb-3">
        <h3 className="text-sm font-semibold text-dark-text">Active Indicators</h3>
        <button
          onClick={() => setShowAddModal(true)}
          className="px-3 py-1 bg-primary text-white rounded text-sm hover:bg-primary-dark"
        >
          + Add Indicator
        </button>
      </div>

      {/* Active Indicators List */}
      <div className="flex flex-wrap gap-2">
        {indicators.length === 0 ? (
          <p className="text-sm text-dark-text-secondary">No indicators added</p>
        ) : (
          indicators.map((indicator) => (
            <div
              key={indicator.id}
              className="flex items-center gap-2 px-3 py-1.5 bg-dark-bg border border-dark-border rounded text-sm"
            >
              <input
                type="checkbox"
                checked={indicator.enabled}
                onChange={() => toggleIndicator(indicator.id)}
                className="cursor-pointer"
              />
              <span
                className="w-3 h-3 rounded"
                style={{ backgroundColor: indicator.params.color }}
              />
              <span className="text-dark-text font-medium">
                {INDICATOR_TYPES[indicator.type as keyof typeof INDICATOR_TYPES]}
                {indicator.params.period && `(${indicator.params.period})`}
              </span>
              <button
                onClick={() => removeIndicator(indicator.id)}
                className="ml-2 text-dark-text-secondary hover:text-red-500"
                title="Remove indicator"
              >
                ✕
              </button>
            </div>
          ))
        )}
      </div>

      {/* Add Indicator Modal */}
      {showAddModal && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
          <div className="bg-dark-surface border border-dark-border rounded-lg p-6 max-w-md w-full mx-4">
            <div className="flex items-center justify-between mb-4">
              <h4 className="text-lg font-semibold text-dark-text">Add Indicator</h4>
              <button
                onClick={() => setShowAddModal(false)}
                className="text-dark-text-secondary hover:text-dark-text"
              >
                ✕
              </button>
            </div>

            <div className="space-y-2 max-h-96 overflow-y-auto">
              {Object.entries(INDICATOR_TYPES).map(([key, label]) => (
                <button
                  key={key}
                  onClick={() => handleAddIndicator(key as keyof typeof INDICATOR_TYPES)}
                  className="w-full px-4 py-3 bg-dark-bg hover:bg-dark-hover border border-dark-border rounded text-left text-dark-text transition-colors"
                >
                  <div className="font-medium">{label}</div>
                  <div className="text-xs text-dark-text-secondary mt-1">
                    {getIndicatorDescription(key)}
                  </div>
                </button>
              ))}
            </div>
          </div>
        </div>
      )}
    </div>
  )
}

function getIndicatorDescription(type: string): string {
  const descriptions: Record<string, string> = {
    sma: 'Simple Moving Average - smooths price data',
    ema: 'Exponential Moving Average - more weight to recent prices',
    vwap: 'Volume Weighted Average Price - intraday benchmark',
    rsi: 'Relative Strength Index - momentum oscillator (0-100)',
    macd: 'Moving Average Convergence Divergence - trend following',
    bollinger: 'Bollinger Bands - volatility bands around SMA',
    supertrend: 'Supertrend - trend following indicator',
    volume: 'Volume bars - trading volume visualization',
    atr: 'Average True Range - volatility measurement',
  }
  return descriptions[type] || ''
}
