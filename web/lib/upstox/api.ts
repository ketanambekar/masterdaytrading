import axios, { AxiosInstance } from 'axios'

/**
 * Upstox API Configuration
 * Uses the API token from the Flutter app configuration
 */
const API_BASE_URL = process.env.NEXT_PUBLIC_UPSTOX_API_URL || 'https://api.upstox.com/v3'
const API_TOKEN = process.env.NEXT_PUBLIC_UPSTOX_TOKEN || ''

/**
 * Candle data structure from Upstox API
 */
export interface UpstoxCandle {
  timestamp: number
  open: number
  high: number
  low: number
  close: number
  volume: number
}

/**
 * Transformed candle for charting library
 */
export interface ChartCandle {
  time: number
  open: number
  high: number
  low: number
  close: number
  volume: number
}

/**
 * API request parameters
 */
export interface CandleParams {
  instrument: string
  interval: string
  fromDate?: string  // YYYY-MM-DD
  toDate?: string    // YYYY-MM-DD
}

class UpstoxAPI {
  private client: AxiosInstance
  private requestCache: Map<string, { data: ChartCandle[], timestamp: number }>

  constructor() {
    this.client = axios.create({
      baseURL: API_BASE_URL,
      headers: {
        'Authorization': `Bearer ${API_TOKEN}`,
        'Content-Type': 'application/json',
      },
    })

    // Cache for 5 minutes
    this.requestCache = new Map()

    // Add retry interceptor
    this.client.interceptors.response.use(
      (response) => response,
      async (error) => {
        const config = error.config
        if (!config || !config.retry) {
          config.retry = 0
        }

        config.retry += 1

        if (config.retry <= 3 && error.response?.status >= 500) {
          // Exponential backoff
          await new Promise(resolve => setTimeout(resolve, Math.pow(2, config.retry) * 1000))
          return this.client(config)
        }

        return Promise.reject(error)
      }
    )
  }

  /**
   * Get cache key for request
   */
  private getCacheKey(params: CandleParams): string {
    return `${params.instrument}_${params.interval}_${params.fromDate || ''}_${params.toDate || ''}`
  }

  /**
   * Check if cache is valid (5 minutes)
   */
  private isCacheValid(timestamp: number): boolean {
    return Date.now() - timestamp < 5 * 60 * 1000
  }

  /**
   * Fetch historical candle data
   * API: GET /historical-candle/{instrument_key}/{interval}/{to_date}/{from_date}
   */
  async getHistoricalCandles(params: CandleParams): Promise<ChartCandle[]> {
    const { instrument, interval, fromDate, toDate } = params

    if (!fromDate || !toDate) {
      throw new Error('Historical candles require both fromDate and toDate')
    }

    const cacheKey = this.getCacheKey(params)
    const cached = this.requestCache.get(cacheKey)

    if (cached && this.isCacheValid(cached.timestamp)) {
      console.log('📦 Returning cached historical data')
      return cached.data
    }

    try {
      console.log(`🔄 Fetching historical candles: ${instrument} ${interval} ${fromDate} to ${toDate}`)
      
      const response = await this.client.get(
        `/historical-candle/${instrument}/${interval}/${toDate}/${fromDate}`
      )

      const candles = this.transformCandles(response.data.data.candles)
      
      // Cache the result
      this.requestCache.set(cacheKey, {
        data: candles,
        timestamp: Date.now(),
      })

      return candles
    } catch (error: any) {
      console.error('❌ Error fetching historical candles:', error.message)
      throw new Error(`Failed to fetch historical candles: ${error.message}`)
    }
  }

  /**
   * Fetch intraday candle data (current day)
   * API: GET /intra-day-candle/{instrument_key}/{interval}
   */
  async getIntradayCandles(params: CandleParams): Promise<ChartCandle[]> {
    const { instrument, interval } = params
    
    const cacheKey = this.getCacheKey({ ...params, fromDate: 'today', toDate: 'today' })
    const cached = this.requestCache.get(cacheKey)

    // Shorter cache for intraday (1 minute)
    if (cached && (Date.now() - cached.timestamp < 60 * 1000)) {
      console.log('📦 Returning cached intraday data')
      return cached.data
    }

    try {
      console.log(`🔄 Fetching intraday candles: ${instrument} ${interval}`)
      
      const response = await this.client.get(
        `/intra-day-candle/${instrument}/${interval}`
      )

      const candles = this.transformCandles(response.data.data.candles)
      
      // Cache the result
      this.requestCache.set(cacheKey, {
        data: candles,
        timestamp: Date.now(),
      })

      return candles
    } catch (error: any) {
      console.error('❌ Error fetching intraday candles:', error.message)
      throw new Error(`Failed to fetch intraday candles: ${error.message}`)
    }
  }

  /**
   * Smart candle fetcher - decides between historical and intraday
   */
  async getCandles(params: CandleParams): Promise<ChartCandle[]> {
    const today = new Date().toISOString().split('T')[0]
    
    // If no dates provided or toDate is today, use intraday
    if (!params.fromDate || !params.toDate || params.toDate === today) {
      return this.getIntradayCandles(params)
    }
    
    // Otherwise use historical
    return this.getHistoricalCandles(params)
  }

  /**
   * Stitch multiple date ranges together
   * Useful for getting continuous data across multiple API calls
   */
  async getStitchedCandles(params: CandleParams, maxDaysPerRequest: number = 365): Promise<ChartCandle[]> {
    if (!params.fromDate || !params.toDate) {
      return this.getCandles(params)
    }

    const from = new Date(params.fromDate)
    const to = new Date(params.toDate)
    const diffDays = Math.ceil((to.getTime() - from.getTime()) / (1000 * 60 * 60 * 24))

    // If within single request limit, fetch directly
    if (diffDays <= maxDaysPerRequest) {
      return this.getCandles(params)
    }

    // Split into multiple requests
    const requests: Promise<ChartCandle[]>[] = []
    let currentFrom = new Date(from)

    while (currentFrom < to) {
      const currentTo = new Date(currentFrom)
      currentTo.setDate(currentTo.getDate() + maxDaysPerRequest)
      
      if (currentTo > to) {
        currentTo.setTime(to.getTime())
      }

      requests.push(
        this.getHistoricalCandles({
          ...params,
          fromDate: currentFrom.toISOString().split('T')[0],
          toDate: currentTo.toISOString().split('T')[0],
        })
      )

      currentFrom.setDate(currentFrom.getDate() + maxDaysPerRequest + 1)
    }

    const results = await Promise.all(requests)
    const allCandles = results.flat()

    // Sort by time and remove duplicates
    const uniqueCandles = Array.from(
      new Map(allCandles.map(c => [c.time, c])).values()
    ).sort((a, b) => a.time - b.time)

    return uniqueCandles
  }

  /**
   * Transform Upstox candle format to chart format
   */
  private transformCandles(rawCandles: any[]): ChartCandle[] {
    if (!rawCandles || !Array.isArray(rawCandles)) {
      return []
    }

    return rawCandles.map((candle: any) => ({
      time: typeof candle[0] === 'string' 
        ? Math.floor(new Date(candle[0]).getTime() / 1000)
        : candle[0],
      open: parseFloat(candle[1]),
      high: parseFloat(candle[2]),
      low: parseFloat(candle[3]),
      close: parseFloat(candle[4]),
      volume: parseFloat(candle[5] || 0),
    })).sort((a, b) => a.time - b.time)
  }

  /**
   * Clear cache
   */
  clearCache(): void {
    this.requestCache.clear()
    console.log('🧹 Cache cleared')
  }

  /**
   * Get available intervals for a unit
   */
  getIntervalsForUnit(unit: string): string[] {
    const intervals: Record<string, string[]> = {
      'minutes': ['1minute', '5minute', '15minute', '30minute'],
      'hours': ['60minute'],
      'days': ['day'],
      'weeks': ['week'],
      'months': ['month'],
    }
    return intervals[unit] || intervals['days']
  }
}

// Export singleton instance
export const upstoxAPI = new UpstoxAPI()
