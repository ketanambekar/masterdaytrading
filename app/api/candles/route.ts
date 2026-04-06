import { NextRequest, NextResponse } from "next/server";
import { fetchHistoricalCandles, getAllowedUnits, type SupportedUnit } from "@/lib/upstox";

export const dynamic = "force-dynamic";

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const instrumentKey = (searchParams.get("instrumentKey") ?? "NSE_EQ|INE848E01016").trim();
  const unit = (searchParams.get("unit") ?? "minutes").trim() as SupportedUnit;
  const interval = Number(searchParams.get("interval") ?? "5");
  const fromDate = (searchParams.get("fromDate") ?? "").trim();
  const toDate = (searchParams.get("toDate") ?? "").trim();

  if (!instrumentKey || !fromDate || !toDate) {
    return NextResponse.json(
      { message: "instrumentKey, fromDate, and toDate are required" },
      { status: 400 },
    );
  }

  if (!getAllowedUnits().includes(unit)) {
    return NextResponse.json({ message: "Invalid unit" }, { status: 400 });
  }

  if (!Number.isFinite(interval) || interval <= 0) {
    return NextResponse.json({ message: "Invalid interval" }, { status: 400 });
  }

  try {
    const candles = await fetchHistoricalCandles({
      instrumentKey,
      unit,
      interval,
      fromDate,
      toDate,
    });

    return NextResponse.json({ candles });
  } catch (error) {
    const message = error instanceof Error ? error.message : "Failed to fetch candles";
    return NextResponse.json({ message }, { status: 500 });
  }
}
