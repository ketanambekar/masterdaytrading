import { create } from 'zustand'
import { persist } from 'zustand/middleware'
import { Indicator } from './chartStore'

/**
 * Replay state
 */
interface ReplayState {
  // Replay mode
  isReplayMode: boolean
  isPlaying: boolean
  currentIndex: number
  replaySpeed: number // milliseconds per candle
  startDate: string
  
  // Progress tracking
  lastPlayedIndex: number
  bookmarkedIndex: number
  
  // Actions
  setReplayMode: (enabled: boolean) => void
  setPlaying: (playing: boolean) => void
  setCurrentIndex: (index: number) => void
  setReplaySpeed: (speed: number) => void
  setStartDate: (date: string) => void
  nextCandle: () => void
  previousCandle: () => void
  jumpToIndex: (index: number) => void
  saveProgress: (index: number) => void
  restoreProgress: () => number
  toggleBookmark: () => void
  reset: () => void
}

export const useReplayStore = create<ReplayState>()(
  persist(
    (set, get) => ({
      isReplayMode: false,
      isPlaying: false,
      currentIndex: 0,
      replaySpeed: 1000,
      startDate: '',
      lastPlayedIndex: 0,
      bookmarkedIndex: -1,

      setReplayMode: (enabled) => set({ isReplayMode: enabled }),
      setPlaying: (playing) => set({ isPlaying: playing }),
      setCurrentIndex: (index) => set({ currentIndex: index }),
      setReplaySpeed: (speed) => set({ replaySpeed: speed }),
      setStartDate: (date) => set({ startDate: date }),
      
      nextCandle: () => set((state) => ({
        currentIndex: state.currentIndex + 1,
        lastPlayedIndex: state.currentIndex + 1,
      })),
      
      previousCandle: () => set((state) => ({
        currentIndex: Math.max(0, state.currentIndex - 1),
      })),
      
      jumpToIndex: (index) => set({ currentIndex: index }),
      
      saveProgress: (index) => set({ lastPlayedIndex: index }),
      
      restoreProgress: () => get().lastPlayedIndex,
      
      toggleBookmark: () => set((state) => ({
        bookmarkedIndex: state.bookmarkedIndex === state.currentIndex 
          ? -1 
          : state.currentIndex,
      })),
      
      reset: () => set({
        isReplayMode: false,
        isPlaying: false,
        currentIndex: 0,
      }),
    }),
    {
      name: 'replay-storage',
      partialize: (state) => ({
        lastPlayedIndex: state.lastPlayedIndex,
        bookmarkedIndex: state.bookmarkedIndex,
        replaySpeed: state.replaySpeed,
      }),
    }
  )
)
