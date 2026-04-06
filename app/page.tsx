import Link from "next/link";

export default function HomePage() {
  return (
    <main className="hero-shell">
      <section className="hero-card" aria-labelledby="hero-title">
        <div className="hero-content">
          <p className="eyebrow">Master Day Trading</p>
          <h1 id="hero-title">Train your chart reading, one candle at a time.</h1>
          <p className="lead">
            Practice with historical data replay only. Pause, step, and speed-control each candle so every setup can be reviewed with intent.
          </p>
          <div className="hero-actions">
            <Link className="btn btn-primary" href="/chart-page">
              Open Replay Chart
            </Link>
            <a className="btn btn-ghost" href="#features">
              See Features
            </a>
          </div>
        </div>

        <aside className="hero-metrics" aria-label="Platform highlights">
          <article>
            <h3>Historical-Only</h3>
            <p>No live data noise while practicing structure and timing.</p>
          </article>
          <article>
            <h3>Step + Replay</h3>
            <p>Move candle-by-candle or run playback at controlled speed.</p>
          </article>
        </aside>
      </section>

      <section id="features" className="feature-grid">
        <article>
          <h3>Historical-Only Mode</h3>
          <p>Replay curated market history without streaming live data.</p>
        </article>
        <article>
          <h3>One-by-One Plotting</h3>
          <p>Candles are rendered progressively to mimic real-time decision making.</p>
        </article>
        <article>
          <h3>Built for Replay</h3>
          <p>Control playback speed and step through candles to review setups.</p>
        </article>
      </section>
    </main>
  );
}
