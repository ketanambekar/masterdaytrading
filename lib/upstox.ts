import "server-only";

export type SupportedUnit = "minutes" | "hours" | "days" | "weeks" | "months";

export type UpstoxCandle = {
  time: number;
  open: number;
  high: number;
  low: number;
  close: number;
  volume: number;
  oi: number;
};

const ALLOWED_UNITS: SupportedUnit[] = ["minutes", "hours", "days", "weeks", "months"];

function toUnix(iso: string): number {
  const parsed = new Date(iso);
  if (Number.isNaN(parsed.getTime())) {
    throw new Error(`Invalid candle timestamp: ${iso}`);
  }
  return Math.floor(parsed.getTime() / 1000);
}

export function getAllowedUnits(): SupportedUnit[] {
  return ALLOWED_UNITS;
}

export async function fetchHistoricalCandles(params: {
  instrumentKey: string;
  unit: SupportedUnit;
  interval: number;
  fromDate: string;
  toDate: string;
}): Promise<UpstoxCandle[]> {
  const token = process.env.UPSTOX_ACCESS_TOKEN;
  if (!token) {
    throw new Error("UPSTOX_ACCESS_TOKEN is missing. Set it in .env.local");
  }

  const baseUrl = process.env.UPSTOX_BASE_URL ?? "https://api.upstox.com/v3";
  const url = `${baseUrl}/historical-candle/${params.instrumentKey}/${params.unit}/${params.interval}/${params.toDate}/${params.fromDate}`;

  const response = await fetch(url, {
    method: "GET",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
    },
    cache: "no-store",
  });

  const payload = (await response.json()) as {
    status?: string;
    message?: string;
    data?: {
      candles?: Array<[string, number, number, number, number, number, number]>;
    };
  };

  if (!response.ok || payload.status === "error") {
    throw new Error(payload.message ?? `Upstox request failed (${response.status})`);
  }

  const candles = payload.data?.candles ?? [];
  return candles
    .map((candle) => ({
      time: toUnix(candle[0]),
      open: Number(candle[1]),
      high: Number(candle[2]),
      low: Number(candle[3]),
      close: Number(candle[4]),
      volume: Number(candle[5]),
      oi: Number(candle[6]),
    }))
    .reverse();
}
