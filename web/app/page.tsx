'use client'

import dynamic from 'next/dynamic'
import Toolbar from '@/components/Toolbar'
import IndicatorPanel from '@/components/IndicatorPanel'
import ReplayControls from '@/components/ReplayControls'
import AdBanner from '@/components/AdBanner'

// Dynamic import to avoid SSR issues with lightweight-charts
const ChartContainer = dynamic(
  () => import('@/components/chart/ChartContainer'),
  { ssr: false }
)

export default function Home() {
  return (
    <div className="flex flex-col h-screen w-screen overflow-hidden">
      {/* Top Ad Banner */}
      <AdBanner position="top" />

      {/* Indicator Panel */}
      <IndicatorPanel />

      {/* Main Content Area */}
      <div className="flex flex-1 overflow-hidden">
        {/* Sidebar Toolbar */}
        <Toolbar />

        {/* Chart Area */}
        <div className="flex-1 relative">
          <ChartContainer />
        </div>
      </div>

      {/* Replay Controls */}
      <ReplayControls />

      {/* Bottom Ad Banner */}
      <AdBanner position="bottom" />
    </div>
  )
}
