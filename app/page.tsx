import Link from "next/link";
import InstrumentSearch from "@/components/InstrumentSearch";

export default function HomePage() {
  return (
    <main className="hero-shell">
      <header className="site-header">
        <div className="site-brand">
          <div className="brand-icon" aria-hidden="true">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none">
              <path d="M3 17l4-8 4 4 4-6 4 3" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" />
            </svg>
          </div>
          <span className="brand-name">MasterDayTrading</span>
        </div>
        <nav className="site-links" aria-label="Page sections">
          <a href="#features">Features</a>
          <a href="#data-source">Data</a>
          <a href="#terms">Terms</a>
        </nav>
        <Link className="btn btn-primary btn-sm" href="/chart-page">
          Launch App →
        </Link>
      </header>

      <section className="hero-card" aria-labelledby="hero-title">
        <div className="hero-content">
          <p className="eyebrow-badge">
            <span className="eyebrow-dot" aria-hidden="true" />
            Historical Replay Simulator
          </p>
          <h1 id="hero-title">
            Train smarter.<br />
            <span className="gradient-text">One candle at a time.</span>
          </h1>
          <p className="lead">
            Replay real NSE market history with zero live noise. Step through each
            candle, control playback speed, and build precise chart-reading habits.
          </p>
          <div className="hero-actions">
            <Link className="btn btn-primary btn-lg" href="/chart-page">
              Open Replay Chart
            </Link>
          </div>
          <InstrumentSearch
            className="hero-search"
            buttonLabel="Start Replay"
            placeholder="Search equity or index symbol..."
          />
        </div>

        <aside className="hero-metrics" aria-label="Key highlights">
          <article>
            <div className="metric-num">01</div>
            <h3>Historical-Only Data</h3>
            <p>No live feed. Replay real NSE history without distraction.</p>
          </article>
          <article>
            <div className="metric-num">02</div>
            <h3>Step-by-Step Replay</h3>
            <p>Advance candle by candle or run playback at adjustable speed.</p>
          </article>
          <article>
            <div className="metric-num">03</div>
            <h3>Testing-Only Tool</h3>
            <p>Designed exclusively for practice, review, and backtest analysis.</p>
          </article>
        </aside>
      </section>

      <div className="ad-band" aria-label="Sponsored content">
        <div className="ad-card">
          <span className="ad-label">Ad</span>
          <h3>Partner Placement</h3>
          <p>Reserved for broker tools, analytics platforms, or educational content.</p>
        </div>
        <div className="ad-card">
          <span className="ad-label">Ad</span>
          <h3>Trading Journal Slot</h3>
          <p>Ideal for journal software, risk management, or strategy-tracking apps.</p>
        </div>
      </div>

      <section id="features" className="features-section" aria-labelledby="features-title">
        <header className="section-header">
          <p className="eyebrow">What you get</p>
          <h2 id="features-title">Built for deliberate practice</h2>
        </header>
        <div className="feature-grid">
          <article>
            <div className="feature-num">01</div>
            <h3>Historical-Only Mode</h3>
            <p>Replay curated NSE market data without any live streaming or noise.</p>
          </article>
          <article>
            <div className="feature-num">02</div>
            <h3>Candle-by-Candle Plot</h3>
            <p>Each candle renders progressively so decisions feel like real sessions.</p>
          </article>
          <article>
            <div className="feature-num">03</div>
            <h3>Speed-Controlled Replay</h3>
            <p>Adjust playback 1×–8× or step manually to dissect any setup.</p>
          </article>
        </div>
      </section>

      <section id="data-source" className="info-grid" aria-labelledby="data-source-title">
        <article className="info-card">
          <div className="info-icon accent-icon" aria-hidden="true">◈</div>
          <h2 id="data-source-title">Data Source</h2>
          <p>
            All candle data is fetched server-side from the Upstox Historical Candle API
            using a private access token. No data is cached or redistributed.
          </p>
          <ul>
            <li><strong>Provider:</strong> Upstox Historical Candle API v3</li>
            <li><strong>Timeframes:</strong> 1m · 3m · 5m · 15m · 30m · 1h · 1D · 1W · 1M</li>
            <li><strong>Delivery:</strong> On-request date ranges only — no live feed</li>
            <li><strong>Exchange:</strong> NSE Equity &amp; Indices</li>
          </ul>
        </article>
        <article className="info-card warning-card">
          <div className="info-icon warning-icon" aria-hidden="true">⚠</div>
          <h2>Usage Notice</h2>
          <p>
            This platform is for <strong>chart practice and data testing only</strong>.
            It is not financial advice, not a signal service, and cannot place any orders.
          </p>
          <p>
            Always validate each setup independently before applying any pattern in live markets.
          </p>
        </article>
      </section>

      <section id="terms" className="terms-card" aria-labelledby="terms-title">
        <div className="terms-header">
          <div className="info-icon" aria-hidden="true">§</div>
          <h2 id="terms-title">Terms &amp; Conditions</h2>
        </div>
        <ol>
          <li>Use is strictly for backtesting, simulation, and personal training only.</li>
          <li>Historical data does not predict or guarantee future market outcomes.</li>
          <li>Users are solely responsible for their API credentials and regulatory compliance.</li>
          <li>No liability is assumed for losses arising from interpretations of replay data.</li>
          <li>This tool is provided as-is with no warranties of accuracy, uptime, or trading fitness.</li>
        </ol>
      </section>

      <footer className="site-footer">
        <div className="footer-inner">
          <div className="footer-brand">
            <div className="brand-icon" aria-hidden="true">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none">
                <path d="M3 17l4-8 4 4 4-6 4 3" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" />
              </svg>
            </div>
            <span>MasterDayTrading</span>
          </div>
          <p className="footer-copy">
            © {new Date().getFullYear()} &nbsp;·&nbsp; For historical data testing and chart practice only. Not financial advice.
          </p>
          <nav className="footer-links" aria-label="Footer navigation">
            <a href="#features">Features</a>
            <a href="#data-source">Data Source</a>
            <a href="#terms">Terms</a>
            <Link href="/chart-page">Replay App</Link>
          </nav>
        </div>
      </footer>
    </main>
  );
}
