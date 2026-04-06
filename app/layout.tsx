import type { Metadata } from "next";
import { Space_Grotesk } from "next/font/google";
import "./globals.css";

const spaceGrotesk = Space_Grotesk({
  subsets: ["latin"],
  display: "swap",
  variable: "--font-space-grotesk",
});

export const metadata: Metadata = {
  title: {
    default: "Master Day Trading",
    template: "%s | Master Day Trading",
  },
  description: "Practice market structure with a fast, historical candle replay simulator for day traders.",
  keywords: ["day trading", "chart replay", "candlestick simulator", "historical candles", "trading practice"],
  robots: {
    index: true,
    follow: true,
  },
  openGraph: {
    title: "Master Day Trading",
    description: "Replay historical candles, train your chart reading, and improve decision timing.",
    type: "website",
  },
  twitter: {
    card: "summary_large_image",
    title: "Master Day Trading",
    description: "Candle-by-candle historical replay for deliberate trading practice.",
  },
};

export default function RootLayout({
  children,
}: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="en">
      <body className={spaceGrotesk.variable}>{children}</body>
    </html>
  );
}
