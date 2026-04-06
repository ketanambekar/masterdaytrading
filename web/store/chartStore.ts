import { create } from 'zustand'
import { ChartCandle } from '@/lib/upstox/api'
import { IChartApi, ISeriesApi } from 'lightweight-charts'

/**
 * Drawing tool types
 */
export type DrawingTool = 'none' | 'trendline' | 'horizontal' | 'fib' | 'brush' | 'text' | 'eraser'

/**
 * Drawing object
 */
export interface Drawing {
  id: string
  type: Exclude<DrawingTool, 'none' | 'eraser'>
  points: { time: number; value: number }[]
  color?: string
  text?: string
  thickness?: number
}

/**
 * Indicator configuration
 */
export interface Indicator {
  id: string
  type: string
  enabled: boolean
  params: Record<string, any>
  color?: string
}

/**
 * Chart store state
 */
interface ChartState {
  // Candle data
  candles: ChartCandle[]
  visibleCandles: ChartCandle[]
  isLoading: boolean
  error: string | null

  // Chart refs
  chartApi: IChartApi | null
  candlestickSeries: ISeriesApi<'Candlestick'> | null
  volumeSeries: ISeriesApi<'Histogram'> | null

  // Instrument config
  instrument: string
  interval: string
  fromDate: string
  toDate: string

  // Actions
  setCandles: (candles: ChartCandle[]) => void
  setVisibleCandles: (candles: ChartCandle[]) => void
  setLoading: (loading: boolean) => void
  setError: (error: string | null) => void
  setChartApi: (api: IChartApi | null) => void
  setCandlestickSeries: (series: ISeriesApi<'Candlestick'> | null) => void
  setVolumeSeries: (series: ISeriesApi<'Histogram'> | null) => void
  setInstrument: (instrument: string) => void
  setInterval: (interval: string) => void
  setFromDate: (date: string) => void
  setToDate: (date: string) => void
  clearData: () => void
}

export const useChartStore = create<ChartState>((set) => ({
  candles: [],
  visibleCandles: [],
  isLoading: false,
  error: null,
  chartApi: null,
  candlestickSeries: null,
  volumeSeries: null,
  instrument: 'NSE_EQ|INE848E01016', // Reliance
  interval: 'day',
  fromDate: '',
  toDate: '',

  setCandles: (candles) => set({ candles }),
  setVisibleCandles: (candles) => set({ visibleCandles: candles }),
  setLoading: (isLoading) => set({ isLoading }),
  setError: (error) => set({ error }),
  setChartApi: (chartApi) => set({ chartApi }),
  setCandlestickSeries: (candlestickSeries) => set({ candlestickSeries }),
  setVolumeSeries: (volumeSeries) => set({ volumeSeries }),
  setInstrument: (instrument) => set({ instrument }),
  setInterval: (interval) => set({ interval }),
  setFromDate: (fromDate) => set({ fromDate }),
  setToDate: (toDate) => set({ toDate }),
  clearData: () => set({ candles: [], visibleCandles: [], error: null }),
}))
