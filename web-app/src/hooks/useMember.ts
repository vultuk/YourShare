import { useQuery, useQueryClient } from '@tanstack/react-query';
import { fetchMemberByCode, fetchFundConfig, fetchFundEntries } from '../services/supabase';
import { calculateInvestmentValue } from '../services/calculation';
import type { Member, CalculationResult } from '../types';

const MEMBER_CODE_KEY = 'yourshare_member_code';

export function saveMemberCode(code: string): void {
  localStorage.setItem(MEMBER_CODE_KEY, code);
}

export function getSavedMemberCode(): string | null {
  return localStorage.getItem(MEMBER_CODE_KEY);
}

export function clearMemberCode(): void {
  localStorage.removeItem(MEMBER_CODE_KEY);
}

export function useMember(code: string | null) {
  return useQuery({
    queryKey: ['member', code],
    queryFn: async () => {
      if (!code) return null;
      return fetchMemberByCode(code);
    },
    enabled: !!code,
    staleTime: 1000 * 60 * 5, // 5 minutes
  });
}

export function useFundData(enabled: boolean) {
  return useQuery({
    queryKey: ['fundData'],
    queryFn: async () => {
      const [config, entries] = await Promise.all([
        fetchFundConfig(),
        fetchFundEntries(),
      ]);
      return { config, entries };
    },
    enabled,
    staleTime: 1000 * 60 * 5, // 5 minutes
  });
}

export function useCalculation(member: Member | null | undefined, enabled: boolean): {
  data: CalculationResult | null;
  isLoading: boolean;
  error: Error | null;
  refetch: () => void;
} {
  const queryClient = useQueryClient();

  const { data: fundData, isLoading, error, refetch } = useFundData(enabled && !!member);

  let calculationResult: CalculationResult | null = null;

  if (fundData?.config && fundData?.entries && member) {
    calculationResult = calculateInvestmentValue(
      fundData.config.value,
      member.shares,
      fundData.entries
    );
  }

  return {
    data: calculationResult,
    isLoading,
    error: error as Error | null,
    refetch: () => {
      queryClient.invalidateQueries({ queryKey: ['fundData'] });
      refetch();
    },
  };
}
