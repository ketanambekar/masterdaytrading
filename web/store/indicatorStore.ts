import { create } from 'zustand'
import { persist } from 'zustand/middleware'
import { Indicator } from './chartStore'

/**
 * Available indicator types
 */
export const INDICATOR_TYPES = {
  SMA: 'sma',
  EMA: 'ema',
  VWAP: 'vwap',
  RSI: 'rsi',
  MACD: 'macd',
  BB: 'bollinger',
  SUPERTREND: 'supertrend',
  VOLUME: 'volume',
  ATR: 'atr',
} as const

/**
 * Default indicator parameters
 */
export const DEFAULT_PARAMS: Record<string, Record<string, any>> = {
  sma: { period: 20, color: '#2962FF' },
  ema: { period: 20, color: '#FF6D00' },
  vwap: { color: '#00897B' },
  rsi: { period: 14, overbought: 70, oversold: 30, color: '#7E57C2' },
  macd: { fast: 12, slow: 26, signal: 9, color: '#F50057' },
  bollinger: { period: 20, stdDev: 2, color: '#FFB300' },
  supertrend: { period: 10, multiplier: 3, color: '#00C853' },
  volume: { color: '#546E7A' },
  atr: { period: 14, color: '#D84315' },
}

/**
 * Indicator store state
 */
interface IndicatorState {
  indicators: Indicator[]
  
  // Actions
  addIndicator: (type: string, params?: Record<string, any>) => void
  removeIndicator: (id: string) => void
  updateIndicator: (id: string, updates: Partial<Indicator>) => void
  toggleIndicator: (id: string) => void
  clearIndicators: () => void
  getIndicatorsByType: (type: string) => Indicator[]
}

export const useIndicatorStore = create<IndicatorState>()(
  persist(
    (set, get) => ({
      indicators: [],

      addIndicator: (type, params) => {
        const id = `${type}_${Date.now()}`
        const defaultParams = DEFAULT_PARAMS[type] || {}
        const newIndicator: Indicator = {
          id,
          type,
          enabled: true,
          params: { ...defaultParams, ...params },
          color: params?.color || defaultParams.color,
        }
        set((state) => ({
          indicators: [...state.indicators, newIndicator],
        }))
      },

      removeIndicator: (id) => {
        set((state) => ({
          indicators: state.indicators.filter((ind) => ind.id !== id),
        }))
      },

      updateIndicator: (id, updates) => {
        set((state) => ({
          indicators: state.indicators.map((ind) =>
            ind.id === id ? { ...ind, ...updates } : ind
          ),
        }))
      },

      toggleIndicator: (id) => {
        set((state) => ({
          indicators: state.indicators.map((ind) =>
            ind.id === id ? { ...ind, enabled: !ind.enabled } : ind
          ),
        }))
      },

      clearIndicators: () => set({ indicators: [] }),

      getIndicatorsByType: (type) => {
        return get().indicators.filter((ind) => ind.type === type)
      },
    }),
    {
      name: 'indicator-storage',
    }
  )
)
