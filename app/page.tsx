import Link from "next/link";

export default function HomePage() {
  return (
    <main className="hero-shell">
      <section className="hero-card">
        <p className="eyebrow">Master Day Trading</p>
        <h1>Train your chart reading, one candle at a time.</h1>
        <p className="lead">
          This platform focuses on historical data replay so traders can practice without live intraday noise.
          You can pause, step, and speed-control candle plotting for deliberate learning.
        </p>
        <div className="hero-actions">
          <Link className="btn btn-primary" href="/chart-page">
            Open Replay Chart
          </Link>
          <a className="btn btn-ghost" href="#features">
            See Features
          </a>
        </div>
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
