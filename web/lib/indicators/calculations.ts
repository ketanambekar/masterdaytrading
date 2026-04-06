import { ChartCandle } from '@/lib/upstox/api'

/**
 * Simple Moving Average (SMA)
 */
export function calculateSMA(candles: ChartCandle[], period: number): Array<{ time: number; value: number }> {
  const result: Array<{ time: number; value: number }> = []
  
  for (let i = period - 1; i < candles.length; i++) {
    let sum = 0
    for (let j = 0; j < period; j++) {
      sum += candles[i - j].close
    }
    result.push({
      time: candles[i].time,
      value: sum / period,
    })
  }
  
  return result
}

/**
 * Exponential Moving Average (EMA)
 */
export function calculateEMA(candles: ChartCandle[], period: number): Array<{ time: number; value: number }> {
  const result: Array<{ time: number; value: number }> = []
  const multiplier = 2 / (period + 1)
  
  // Start with SMA for first value
  let ema = 0
  for (let i = 0; i < period; i++) {
    ema += candles[i].close
  }
  ema /= period
  
  result.push({ time: candles[period - 1].time, value: ema })
  
  // Calculate EMA for remaining candles
  for (let i = period; i < candles.length; i++) {
    ema = (candles[i].close - ema) * multiplier + ema
    result.push({ time: candles[i].time, value: ema })
  }
  
  return result
}

/**
 * Volume Weighted Average Price (VWAP)
 */
export function calculateVWAP(candles: ChartCandle[]): Array<{ time: number; value: number }> {
  const result: Array<{ time: number; value: number }> = []
  let cumulativeTPV = 0
  let cumulativeVolume = 0
  
  for (const candle of candles) {
    const typicalPrice = (candle.high + candle.low + candle.close) / 3
    cumulativeTPV += typicalPrice * candle.volume
    cumulativeVolume += candle.volume
    
    if (cumulativeVolume > 0) {
      result.push({
        time: candle.time,
        value: cumulativeTPV / cumulativeVolume,
      })
    }
  }
  
  return result
}

/**
 * Relative Strength Index (RSI)
 */
export function calculateRSI(candles: ChartCandle[], period: number = 14): Array<{ time: number; value: number }> {
  const result: Array<{ time: number; value: number }> = []
  const changes: number[] = []
  
  // Calculate price changes
  for (let i = 1; i < candles.length; i++) {
    changes.push(candles[i].close - candles[i - 1].close)
  }
  
  // Calculate initial average gains and losses
  let avgGain = 0
  let avgLoss = 0
  
  for (let i = 0; i < period; i++) {
    if (changes[i] > 0) {
      avgGain += changes[i]
    } else {
      avgLoss += Math.abs(changes[i])
    }
  }
  
  avgGain /= period
  avgLoss /= period
  
  // Calculate RSI
  for (let i = period; i < changes.length; i++) {
    const rs = avgGain / avgLoss
    const rsi = 100 - (100 / (1 + rs))
    
    result.push({
      time: candles[i + 1].time,
      value: rsi,
    })
    
    // Update averages using Wilder's smoothing method
    const change = changes[i]
    const gain = change > 0 ? change : 0
    const loss = change < 0 ? Math.abs(change) : 0
    
    avgGain = (avgGain * (period - 1) + gain) / period
    avgLoss = (avgLoss * (period - 1) + loss) / period
  }
  
  return result
}

/**
 * Moving Average Convergence Divergence (MACD)
 */
export function calculateMACD(
  candles: ChartCandle[],
  fastPeriod: number = 12,
  slowPeriod: number = 26,
  signalPeriod: number = 9
): {
  macd: Array<{ time: number; value: number }>
  signal: Array<{ time: number; value: number }>
  histogram: Array<{ time: number; value: number }>
} {
  const fastEMA = calculateEMA(candles, fastPeriod)
  const slowEMA = calculateEMA(candles, slowPeriod)
  
  // Calculate MACD line
  const macdLine: ChartCandle[] = []
  const startIndex = slowPeriod - 1
  
  for (let i = 0; i < fastEMA.length && i + startIndex < slowEMA.length; i++) {
    const macdValue = fastEMA[i + (fastPeriod - 1)].value - slowEMA[i + startIndex].value
    macdLine.push({
      time: slowEMA[i + startIndex].time,
      open: macdValue,
      high: macdValue,
      low: macdValue,
      close: macdValue,
      volume: 0,
    })
  }
  
  // Calculate signal line (EMA of MACD)
  const signalLine = calculateEMA(macdLine, signalPeriod)
  
  // Calculate histogram
  const histogram: Array<{ time: number; value: number }> = []
  for (let i = 0; i < signalLine.length; i++) {
    histogram.push({
      time: signalLine[i].time,
      value: macdLine[i + signalPeriod - 1].close - signalLine[i].value,
    })
  }
  
  return {
    macd: macdLine.map(c => ({ time: c.time, value: c.close })),
    signal: signalLine,
    histogram,
  }
}

/**
 * Bollinger Bands
 */
export function calculateBollingerBands(
  candles: ChartCandle[],
  period: number = 20,
  stdDev: number = 2
): {
  upper: Array<{ time: number; value: number }>
  middle: Array<{ time: number; value: number }>
  lower: Array<{ time: number; value: number }>
} {
  const middle = calculateSMA(candles, period)
  const upper: Array<{ time: number; value: number }> = []
  const lower: Array<{ time: number; value: number }> = []
  
  for (let i = period - 1; i < candles.length; i++) {
    // Calculate standard deviation
    let sum = 0
    for (let j = 0; j < period; j++) {
      const diff = candles[i - j].close - middle[i - period + 1].value
      sum += diff * diff
    }
    const sd = Math.sqrt(sum / period)
    
    const middleValue = middle[i - period + 1].value
    upper.push({ time: candles[i].time, value: middleValue + stdDev * sd })
    lower.push({ time: candles[i].time, value: middleValue - stdDev * sd })
  }
  
  return { upper, middle, lower }
}

/**
 * Average True Range (ATR)
 */
export function calculateATR(candles: ChartCandle[], period: number = 14): Array<{ time: number; value: number }> {
  const trueRanges: number[] = []
  
  // Calculate True Range for each candle
  for (let i = 1; i < candles.length; i++) {
    const high = candles[i].high
    const low = candles[i].low
    const prevClose = candles[i - 1].close
    
    const tr = Math.max(
      high - low,
      Math.abs(high - prevClose),
      Math.abs(low - prevClose)
    )
    trueRanges.push(tr)
  }
  
  // Calculate ATR using EMA-like smoothing
  const result: Array<{ time: number; value: number }> = []
  let atr = 0
  
  // Initial ATR is simple average
  for (let i = 0; i < period; i++) {
    atr += trueRanges[i]
  }
  atr /= period
  result.push({ time: candles[period].time, value: atr })
  
  // Subsequent ATR values use smoothing
  for (let i = period; i < trueRanges.length; i++) {
    atr = (atr * (period - 1) + trueRanges[i]) / period
    result.push({ time: candles[i + 1].time, value: atr })
  }
  
  return result
}

/**
 * Supertrend Indicator
 */
export function calculateSupertrend(
  candles: ChartCandle[],
  period: number = 10,
  multiplier: number = 3
): {
  supertrend: Array<{ time: number; value: number }>
  direction: Array<{ time: number; value: 1 | -1 }> // 1 = bullish, -1 = bearish
} {
  const atr = calculateATR(candles, period)
  const supertrend: Array<{ time: number; value: number }> = []
  const direction: Array<{ time: number; value: 1 | -1 }> = []
  
  for (let i = 0; i < atr.length; i++) {
    const idx = i + period
    const candle = candles[idx]
    const atrValue = atr[i].value
    
    const hl2 = (candle.high + candle.low) / 2
    const basicUpperBand = hl2 + multiplier * atrValue
    const basicLowerBand = hl2 - multiplier * atrValue
    
    let finalUpperBand = basicUpperBand
    let finalLowerBand = basicLowerBand
    
    // Adjust bands based on previous values
    if (i > 0) {
      const prevUpper = supertrend[i - 1].value
      const prevLower = supertrend[i - 1].value
      
      if (basicUpperBand < prevUpper || candles[idx - 1].close > prevUpper) {
        finalUpperBand = basicUpperBand
      } else {
        finalUpperBand = prevUpper
      }
      
      if (basicLowerBand > prevLower || candles[idx - 1].close < prevLower) {
        finalLowerBand = basicLowerBand
      } else {
        finalLowerBand = prevLower
      }
    }
    
    // Determine direction and supertrend value
    const isUptrend = i === 0 
      ? candle.close > hl2 
      : candle.close > supertrend[i - 1].value
    
    supertrend.push({
      time: candle.time,
      value: isUptrend ? finalLowerBand : finalUpperBand,
    })
    
    direction.push({
      time: candle.time,
      value: isUptrend ? 1 : -1,
    })
  }
  
  return { supertrend, direction }
}
