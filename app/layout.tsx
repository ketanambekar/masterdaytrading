import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Master Day Trading",
  description: "Historical chart replay platform with candle-by-candle playback.",
};

export default function RootLayout({
  children,
}: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
