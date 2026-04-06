import { ISeriesApi, IChartApi } from 'lightweight-charts'

/**
 * Candle data structure from Upstox API
 */
export interface ChartCandle {
  time: number // Unix timestamp in seconds
  open: number
  high: number
  low: number
  close: number
  volume: number
}

/**
 * Indicator definition
 */
export interface Indicator {
  id: string
  type: string
  enabled: boolean
  params: Record<string, any>
}

/**
 * Drawing tool definition
 */
export interface Drawing {
  id: string
  type: 'trendline' | 'horizontal' | 'fib' | 'brush' | 'text'
  points: Array<{ time: number; price: number }>
  color: string
  text?: string
  thickness?: number
}
