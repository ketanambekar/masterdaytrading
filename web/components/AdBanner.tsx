'use client'

/**
 * Ad Banner Component
 * Placeholder for Google AdSense or other ad networks
 */
export default function AdBanner({ position }: { position: 'top' | 'bottom' }) {
  const isAdsEnabled = process.env.NEXT_PUBLIC_ENABLE_ADS === 'true'

  if (!isAdsEnabled) return null

  return (
    <div className={`ad-banner bg-dark-surface border-dark-border p-2 ${position === 'top' ? 'border-b' : 'border-t'}`}>
      <div className="max-w-7xl mx-auto flex items-center justify-center">
        <div className="w-full h-20 bg-dark-bg border border-dark-border rounded flex items-center justify-center text-dark-text-secondary text-sm">
          Advertisement Space ({position})
        </div>
      </div>
    </div>
  )
}
