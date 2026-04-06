import { create } from 'zustand'
import { persist } from 'zustand/middleware'

/**
 * UI preferences and settings
 */
interface UIState {
  theme: 'light' | 'dark'
  sidebarCollapsed: boolean
  showVolume: boolean
  showGrid: boolean
  chartType: 'candlestick' | 'line' | 'bar'
  
  // Actions
  setTheme: (theme: 'light' | 'dark') => void
  toggleTheme: () => void
  setSidebarCollapsed: (collapsed: boolean) => void
  toggleSidebar: () => void
  setShowVolume: (show: boolean) => void
  setShowGrid: (show: boolean) => void
  setChartType: (type: 'candlestick' | 'line' | 'bar') => void
}

export const useUIStore = create<UIState>()(
  persist(
    (set) => ({
      theme: 'dark',
      sidebarCollapsed: false,
      showVolume: true,
      showGrid: true,
      chartType: 'candlestick',

      setTheme: (theme) => {
        set({ theme })
        if (theme === 'dark') {
          document.documentElement.classList.add('dark')
        } else {
          document.documentElement.classList.remove('dark')
        }
      },

      toggleTheme: () => {
        set((state) => {
          const newTheme = state.theme === 'dark' ? 'light' : 'dark'
          if (newTheme === 'dark') {
            document.documentElement.classList.add('dark')
          } else {
            document.documentElement.classList.remove('dark')
          }
          return { theme: newTheme }
        })
      },

      setSidebarCollapsed: (collapsed) => set({ sidebarCollapsed: collapsed }),
      toggleSidebar: () => set((state) => ({ sidebarCollapsed: !state.sidebarCollapsed })),
      setShowVolume: (show) => set({ showVolume: show }),
      setShowGrid: (show) => set({ showGrid: show }),
      setChartType: (type) => set({ chartType: type }),
    }),
    {
      name: 'ui-storage',
    }
  )
)
