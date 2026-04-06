import { IChartApi, ISeriesApi, LineStyle } from 'lightweight-charts'
import { Indicator } from '@/store/chartStore'
import { ChartCandle } from '@/lib/upstox/api'
import {
  calculateSMA,
  calculateEMA,
  calculateVWAP,
  calculateRSI,
  calculateMACD,
  calculateBollingerBands,
  calculateSupertrend,
  calculateATR,
} from '@/lib/indicators/calculations'

/**
 * Render all active indicators on the chart
 */
export function renderIndicators(
  chart: IChartApi,
  candles: ChartCandle[],
  indicators: Indicator[]
) {
  // Remove all existing indicator series
  // Note: In production, you'd want to track series and update them instead
  
  indicators.forEach((indicator) => {
    if (!indicator.enabled) return

    try {
      switch (indicator.type) {
        case 'sma':
          renderSMA(chart, candles, indicator)
          break
        case 'ema':
          renderEMA(chart, candles, indicator)
          break
        case 'vwap':
          renderVWAP(chart, candles, indicator)
          break
        case 'rsi':
          renderRSI(chart, candles, indicator)
          break
        case 'macd':
          renderMACD(chart, candles, indicator)
          break
        case 'bollinger':
          renderBollingerBands(chart, candles, indicator)
          break
        case 'supertrend':
          renderSupertrend(chart, candles, indicator)
          break
        case 'atr':
          renderATR(chart, candles, indicator)
          break
      }
    } catch (error) {
      console.error(`Error rendering ${indicator.type}:`, error)
    }
  })
}

function renderSMA(chart: IChartApi, candles: ChartCandle[], indicator: Indicator) {
  const period = indicator.params.period || 20
  const color = indicator.params.color || '#2962FF'
  
  const data = calculateSMA(candles, period)
  const series = chart.addLineSeries({
    color,
    lineWidth: 2,
    title: `SMA(${period})`,
  })
  series.setData(data)
}

function renderEMA(chart: IChartApi, candles: ChartCandle[], indicator: Indicator) {
  const period = indicator.params.period || 20
  const color = indicator.params.color || '#FF6D00'
  
  const data = calculateEMA(candles, period)
  const series = chart.addLineSeries({
    color,
    lineWidth: 2,
    title: `EMA(${period})`,
  })
  series.setData(data)
}

function renderVWAP(chart: IChartApi, candles: ChartCandle[], indicator: Indicator) {
  const color = indicator.params.color || '#00897B'
  
  const data = calculateVWAP(candles)
  const series = chart.addLineSeries({
    color,
    lineWidth: 2,
    lineStyle: LineStyle.Dashed,
    title: 'VWAP',
  })
  series.setData(data)
}

function renderRSI(chart: IChartApi, candles: ChartCandle[], indicator: Indicator) {
  const period = indicator.params.period || 14
  const color = indicator.params.color || '#7E57C2'
  const overbought = indicator.params.overbought || 70
  const oversold = indicator.params.oversold || 30
  
  const data = calculateRSI(candles, period)
  
  // RSI needs its own pane
  const series = chart.addLineSeries({
    color,
    lineWidth: 2,
    title: `RSI(${period})`,
    priceScaleId: 'rsi',
  })
  
  chart.priceScale('rsi').applyOptions({
    scaleMargins: {
      top: 0.1,
      bottom: 0.8,
    },
  })
  
  series.setData(data)
  
  // Add overbought/oversold lines
  const overboughtLine = chart.addLineSeries({
    color: '#ef5350',
    lineWidth: 1,
    lineStyle: LineStyle.Dotted,
    priceScaleId: 'rsi',
  })
  overboughtLine.setData(data.map(d => ({ time: d.time, value: overbought })))
  
  const oversoldLine = chart.addLineSeries({
    color: '#26a69a',
    lineWidth: 1,
    lineStyle: LineStyle.Dotted,
    priceScaleId: 'rsi',
  })
  oversoldLine.setData(data.map(d => ({ time: d.time, value: oversold })))
}

function renderMACD(chart: IChartApi, candles: ChartCandle[], indicator: Indicator) {
  const fast = indicator.params.fast || 12
  const slow = indicator.params.slow || 26
  const signal = indicator.params.signal || 9
  const color = indicator.params.color || '#F50057'
  
  const { macd, signal: signalLine, histogram } = calculateMACD(candles, fast, slow, signal)
  
  // MACD line
  const macdSeries = chart.addLineSeries({
    color,
    lineWidth: 2,
    title: 'MACD',
    priceScaleId: 'macd',
  })
  macdSeries.setData(macd)
  
  // Signal line
  const signalSeries = chart.addLineSeries({
    color: '#FFB300',
    lineWidth: 2,
    title: 'Signal',
    priceScaleId: 'macd',
  })
  signalSeries.setData(signalLine)
  
  // Histogram
  const histogramSeries = chart.addHistogramSeries({
    color: '#26a69a',
    priceScaleId: 'macd',
  })
  histogramSeries.setData(histogram.map(h => ({
    ...h,
    color: h.value >= 0 ? '#26a69a80' : '#ef535080',
  })))
  
  chart.priceScale('macd').applyOptions({
    scaleMargins: {
      top: 0.1,
      bottom: 0.8,
    },
  })
}

function renderBollingerBands(chart: IChartApi, candles: ChartCandle[], indicator: Indicator) {
  const period = indicator.params.period || 20
  const stdDev = indicator.params.stdDev || 2
  const color = indicator.params.color || '#FFB300'
  
  const { upper, middle, lower } = calculateBollingerBands(candles, period, stdDev)
  
  const upperSeries = chart.addLineSeries({
    color,
    lineWidth: 1,
    lineStyle: LineStyle.Dashed,
    title: `BB Upper(${period})`,
  })
  upperSeries.setData(upper)
  
  const middleSeries = chart.addLineSeries({
    color,
    lineWidth: 2,
    title: `BB Middle(${period})`,
  })
  middleSeries.setData(middle)
  
  const lowerSeries = chart.addLineSeries({
    color,
    lineWidth: 1,
    lineStyle: LineStyle.Dashed,
    title: `BB Lower(${period})`,
  })
  lowerSeries.setData(lower)
}

function renderSupertrend(chart: IChartApi, candles: ChartCandle[], indicator: Indicator) {
  const period = indicator.params.period || 10
  const multiplier = indicator.params.multiplier || 3
  
  const { supertrend, direction } = calculateSupertrend(candles, period, multiplier)
  
  // Color based on direction
  const coloredData = supertrend.map((point, i) => ({
    ...point,
    color: direction[i].value === 1 ? '#26a69a' : '#ef5350',
  }))
  
  const series = chart.addLineSeries({
    lineWidth: 2,
    title: `Supertrend(${period},${multiplier})`,
  })
  
  // Set data with colors
  supertrend.forEach((point, i) => {
    series.setData([{
      time: point.time,
      value: point.value,
    }])
  })
}

function renderATR(chart: IChartApi, candles: ChartCandle[], indicator: Indicator) {
  const period = indicator.params.period || 14
  const color = indicator.params.color || '#D84315'
  
  const data = calculateATR(candles, period)
  
  const series = chart.addLineSeries({
    color,
    lineWidth: 2,
    title: `ATR(${period})`,
    priceScaleId: 'atr',
  })
  series.setData(data)
  
  chart.priceScale('atr').applyOptions({
    scaleMargins: {
      top: 0.1,
      bottom: 0.8,
    },
  })
}
