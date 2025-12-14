import { createClient } from '@supabase/supabase-js';
import type { Member, FundEntry, FundConfig } from '../types';

const supabaseUrl = 'https://lmtwvioutznspggclasv.supabase.co';
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxtdHd2aW91dHpuc3BnZ2NsYXN2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU0NDQyNTMsImV4cCI6MjA4MTAyMDI1M30.ZQ2Q6d-Bnn5oNW2VasZlrsUoq21gwWXE9n2mhpmt1TQ';

export const supabase = createClient(supabaseUrl, supabaseAnonKey);

export async function fetchMemberByCode(code: string): Promise<Member | null> {
  const { data, error } = await supabase
    .from('members')
    .select('*')
    .ilike('code', code)
    .limit(1)
    .single();

  if (error || !data) {
    return null;
  }

  return data as Member;
}

export async function fetchFundConfig(): Promise<FundConfig | null> {
  const { data, error } = await supabase
    .from('fund_config')
    .select('*')
    .eq('key', 'initial_pool')
    .limit(1)
    .single();

  if (error || !data) {
    return null;
  }

  return data as FundConfig;
}

export async function fetchFundEntries(): Promise<FundEntry[]> {
  const { data, error } = await supabase
    .from('fund_entries')
    .select('*')
    .order('month', { ascending: true });

  if (error || !data) {
    return [];
  }

  return data as FundEntry[];
}
