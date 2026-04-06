'use client'

import { useEffect } from 'react'
import { useReplayStore } from '@/store/replayStore'
import { useChartStore } from '@/store/chartStore'

/**
 * Replay Controls Component
 * Controls for bar-by-bar playback: play/pause, next/prev, speed control
 */
export default function ReplayControls() {
  const {
    isReplayMode,
    isPlaying,
    currentIndex,
    replaySpeed,
    setReplayMode,
    setPlaying,
    nextCandle,
    previousCandle,
    jumpToIndex,
    setSpeed,
    reset,
  } = useReplayStore()

  const { candles } = useChartStore()

  // Auto-advance candles when playing
  useEffect(() => {
    if (!isPlaying || !isReplayMode) return

    const timer = setInterval(() => {
      if (currentIndex < candles.length - 1) {
        nextCandle()
      } else {
        setPlaying(false)
      }
    }, replaySpeed)

    return () => clearInterval(timer)
  }, [isPlaying, isReplayMode, currentIndex, candles.length, replaySpeed, nextCandle, setPlaying])

  // Keyboard shortcuts
  useEffect(() => {
    const handleKeyPress = (e: KeyboardEvent) => {
      if (e.target instanceof HTMLInputElement || e.target instanceof HTMLTextAreaElement) {
        return // Don't trigger shortcuts when typing in inputs
      }

      switch (e.key.toLowerCase()) {
        case 'r':
          setReplayMode(!isReplayMode)
          break
        case ' ':
          e.preventDefault()
          if (isReplayMode) setPlaying(!isPlaying)
          break
        case 'n':
          if (isReplayMode) nextCandle()
          break
        case 'p':
          if (isReplayMode) previousCandle()
          break
        case 'escape':
          if (isReplayMode) {
            setPlaying(false)
            setReplayMode(false)
          }
          break
      }
    }

    window.addEventListener('keydown', handleKeyPress)
    return () => window.removeEventListener('keydown', handleKeyPress)
  }, [isReplayMode, isPlaying, setReplayMode, setPlaying, nextCandle, previousCandle])

  if (!isReplayMode) {
    return (
      <div className="replay-controls bg-dark-surface border-t border-dark-border p-3 flex items-center justify-center">
        <button
          onClick={() => setReplayMode(true)}
          className="px-4 py-2 bg-primary text-white rounded font-medium hover:bg-primary-dark"
        >
          Enter Replay Mode (R)
        </button>
      </div>
    )
  }

  const progress = candles.length > 0 ? ((currentIndex + 1) / candles.length) * 100 : 0
  const currentCandle = candles[currentIndex]

  return (
    <div className="replay-controls bg-dark-surface border-t border-dark-border p-4">
      {/* Progress Bar */}
      <div className="mb-4">
        <div className="flex items-center justify-between text-sm text-dark-text-secondary mb-1">
          <span>
            Bar {currentIndex + 1} of {candles.length}
          </span>
          {currentCandle && (
            <span>
              {new Date(currentCandle.time * 1000).toLocaleString()}
            </span>
          )}
        </div>
        <div className="relative w-full h-2 bg-dark-bg rounded-full overflow-hidden">
          <div
            className="absolute top-0 left-0 h-full bg-primary transition-all duration-200"
            style={{ width: `${progress}%` }}
          />
        </div>
        <input
          type="range"
          min="0"
          max={candles.length - 1}
          value={currentIndex}
          onChange={(e) => jumpToIndex(parseInt(e.target.value))}
          className="w-full mt-2 opacity-0 cursor-pointer absolute"
          style={{ marginTop: '-2rem', height: '2rem' }}
        />
      </div>

      {/* Controls */}
      <div className="flex items-center justify-center gap-4">
        {/* Previous Bar */}
        <button
          onClick={previousCandle}
          disabled={currentIndex === 0}
          className="px-3 py-2 bg-dark-bg hover:bg-dark-hover rounded disabled:opacity-30 disabled:cursor-not-allowed"
          title="Previous bar (P)"
        >
          ⏮
        </button>

        {/* Play/Pause */}
        <button
          onClick={() => setPlaying(!isPlaying)}
          disabled={currentIndex >= candles.length - 1}
          className="px-6 py-3 bg-primary hover:bg-primary-dark text-white rounded font-medium disabled:opacity-50 disabled:cursor-not-allowed"
          title={isPlaying ? 'Pause (Space)' : 'Play (Space)'}
        >
          {isPlaying ? '⏸' : '▶'}
        </button>

        {/* Next Bar */}
        <button
          onClick={nextCandle}
          disabled={currentIndex >= candles.length - 1}
          className="px-3 py-2 bg-dark-bg hover:bg-dark-hover rounded disabled:opacity-30 disabled:cursor-not-allowed"
          title="Next bar (N)"
        >
          ⏭
        </button>

        {/* Speed Control */}
        <select
          value={replaySpeed}
          onChange={(e) => setSpeed(parseInt(e.target.value))}
          className="px-3 py-2 bg-dark-bg border border-dark-border rounded text-dark-text cursor-pointer"
        >
          <option value={2000}>0.5x</option>
          <option value={1000}>1x</option>
          <option value={500}>2x</option>
          <option value={200}>5x</option>
          <option value={100}>10x</option>
        </select>

        {/* Reset */}
        <button
          onClick={reset}
          className="px-3 py-2 bg-dark-bg hover:bg-dark-hover rounded text-dark-text-secondary"
          title="Reset replay"
        >
          ↺
        </button>

        {/* Exit Replay Mode */}
        <button
          onClick={() => {
            setPlaying(false)
            setReplayMode(false)
          }}
          className="px-4 py-2 bg-red-500/20 hover:bg-red-500/30 text-red-500 rounded"
          title="Exit replay mode (Esc)"
        >
          Exit Replay
        </button>
      </div>

      {/* Current Candle Info */}
      {currentCandle && (
        <div className="mt-4 grid grid-cols-5 gap-4 text-sm">
          <div>
            <span className="text-dark-text-secondary">Open:</span>
            <span className="ml-2 text-dark-text font-medium">{currentCandle.open.toFixed(2)}</span>
          </div>
          <div>
            <span className="text-dark-text-secondary">High:</span>
            <span className="ml-2 text-green-500 font-medium">{currentCandle.high.toFixed(2)}</span>
          </div>
          <div>
            <span className="text-dark-text-secondary">Low:</span>
            <span className="ml-2 text-red-500 font-medium">{currentCandle.low.toFixed(2)}</span>
          </div>
          <div>
            <span className="text-dark-text-secondary">Close:</span>
            <span className="ml-2 text-dark-text font-medium">{currentCandle.close.toFixed(2)}</span>
          </div>
          <div>
            <span className="text-dark-text-secondary">Volume:</span>
            <span className="ml-2 text-dark-text font-medium">{currentCandle.volume.toLocaleString()}</span>
          </div>
        </div>
      )}
    </div>
  )
}
