import Link from "next/link";
import dynamic from "next/dynamic";

const ReplayChart = dynamic(() => import("@/components/ReplayChart"), {
  ssr: false,
  loading: () => (
    <section className="replay-shell replay-loading" aria-busy="true">
      <p>Loading chart workspace...</p>
    </section>
  ),
});

type ChartPageProps = {
  searchParams?: {
    instrumentKey?: string;
    instrumentLabel?: string;
  };
};

export default function ChartPage({ searchParams }: ChartPageProps) {
  const initialInstrumentKey = searchParams?.instrumentKey?.trim() || "NSE_EQ|INE848E01016";

  return (
    <main className="chart-page-shell">
      <nav className="top-nav" aria-label="Primary">
        <Link href="/" className="btn btn-ghost">
          Back Home
        </Link>
        <div>
          <p className="eyebrow">Master Day Trading</p>
          <h1 className="page-title">Replay Workspace</h1>
        </div>
      </nav>

      <section className="chart-with-ads" aria-label="Chart with ad rails">
        <aside className="ad-rail" aria-label="Left ad slot">
          <p className="ad-title">Ad Slot</p>
          <div className="ad-box">160 x 600</div>
        </aside>

        <div className="chart-center">
          <ReplayChart key={initialInstrumentKey} initialInstrumentKey={initialInstrumentKey} />
        </div>

        <aside className="ad-rail" aria-label="Right ad slot">
          <p className="ad-title">Ad Slot</p>
          <div className="ad-box">160 x 600</div>
        </aside>
      </section>
    </main>
  );
}
