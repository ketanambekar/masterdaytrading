import Link from "next/link";
import ReplayChart from "@/components/ReplayChart";

export default function ChartPage() {
  return (
    <main className="chart-page-shell">
      <nav className="top-nav">
        <Link href="/" className="btn btn-ghost">
          Back Home
        </Link>
        <h1>Master Day Trading</h1>
      </nav>
      <ReplayChart />
    </main>
  );
}
