import { create } from 'zustand'
import { persist } from 'zustand/middleware'
import { Drawing, DrawingTool } from './chartStore'

/**
 * Drawing store state
 */
interface DrawingState {
  drawings: Drawing[]
  activeTool: DrawingTool
  isDrawing: boolean
  currentDrawing: Drawing | null

  // Actions
  setActiveTool: (tool: DrawingTool) => void
  startDrawing: (drawing: Drawing) => void
  updateDrawing: (updates: Partial<Drawing>) => void
  finishDrawing: () => void
  cancelDrawing: () => void
  addDrawing: (drawing: Drawing) => void
  removeDrawing: (id: string) => void
  clearDrawings: () => void
  updateDrawingPoint: (id: string, pointIndex: number, point: { time: number; value: number }) => void
}

export const useDrawingStore = create<DrawingState>()(
  persist(
    (set, get) => ({
      drawings: [],
      activeTool: 'none',
      isDrawing: false,
      currentDrawing: null,

      setActiveTool: (tool) => set({ activeTool: tool }),

      startDrawing: (drawing) => set({
        isDrawing: true,
        currentDrawing: drawing,
      }),

      updateDrawing: (updates) => set((state) => ({
        currentDrawing: state.currentDrawing
          ? { ...state.currentDrawing, ...updates }
          : null,
      })),

      finishDrawing: () => {
        const { currentDrawing } = get()
        if (currentDrawing) {
          set((state) => ({
            drawings: [...state.drawings, currentDrawing],
            isDrawing: false,
            currentDrawing: null,
            activeTool: 'none',
          }))
        }
      },

      cancelDrawing: () => set({
        isDrawing: false,
        currentDrawing: null,
        activeTool: 'none',
      }),

      addDrawing: (drawing) => set((state) => ({
        drawings: [...state.drawings, drawing],
      })),

      removeDrawing: (id) => set((state) => ({
        drawings: state.drawings.filter((d) => d.id !== id),
      })),

      clearDrawings: () => set({ drawings: [] }),

      updateDrawingPoint: (id, pointIndex, point) => set((state) => ({
        drawings: state.drawings.map((d) =>
          d.id === id
            ? {
                ...d,
                points: d.points.map((p, i) => (i === pointIndex ? point : p)),
              }
            : d
        ),
      })),
    }),
    {
      name: 'drawing-storage',
      partialize: (state) => ({
        drawings: state.drawings,
      }),
    }
  )
)
