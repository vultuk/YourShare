export interface Member {
  id: string;
  code: string;
  name: string;
  shares: number;
  language: 'en' | 'hu';
  created_at: string;
}

export interface FundEntry {
  id: string;
  month: string;
  profit_pct: number;
  fee_pct: number;
  withdrawals: number;
  created_at: string;
}

export interface FundConfig {
  key: string;
  value: number;
}

export interface CalculationResult {
  fundTotal: number;
  sellPrice: number;
  currentValue: number;
  percentageGain: number;
  lastUpdatedMonth: string | null;
}
