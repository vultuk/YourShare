import type { FundEntry, CalculationResult } from '../types';

export function calculateInvestmentValue(
  initialPool: number,
  memberShares: number,
  entries: FundEntry[]
): CalculationResult {
  let fundTotal = initialPool;

  // Apply each month's profit, fees, and withdrawals
  for (const entry of entries) {
    const profitPct = Number(entry.profit_pct) || 0;
    const feePct = Number(entry.fee_pct) || 0;
    const withdrawals = Number(entry.withdrawals) || 0;

    // Calculate profit after fees
    const profit = fundTotal * (profitPct / 100) * (1 - feePct / 100);

    // Apply withdrawals and add profit
    fundTotal = (fundTotal - withdrawals) + profit;
  }

  // Calculate sell price (value per share)
  const sellPrice = fundTotal / initialPool;

  // Calculate member's current value
  const currentValue = memberShares * sellPrice;

  // Calculate percentage gain
  const percentageGain = memberShares > 0
    ? ((currentValue - memberShares) / memberShares) * 100
    : 0;

  // Get last updated month
  const lastUpdatedMonth = entries.length > 0
    ? entries[entries.length - 1].month
    : null;

  return {
    fundTotal,
    sellPrice,
    currentValue,
    percentageGain,
    lastUpdatedMonth,
  };
}
