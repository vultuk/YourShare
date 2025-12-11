-- ============================================
-- Share Certificate App Database Schema
-- ============================================

-- ============================================
-- TABLES
-- ============================================

-- fund_config: Stores configuration values for the fund
CREATE TABLE fund_config (
    key TEXT PRIMARY KEY,
    value DECIMAL NOT NULL
);

-- fund_entries: Monthly fund performance entries
CREATE TABLE fund_entries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    month DATE UNIQUE NOT NULL,
    profit_pct DECIMAL NOT NULL,
    withdrawals DECIMAL DEFAULT 0,
    fee_pct DECIMAL DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- members: Certificate holders with their share allocations
CREATE TABLE members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    shares DECIMAL NOT NULL,
    language TEXT DEFAULT 'en' CHECK (language IN ('en', 'hu')),
    created_at TIMESTAMPTZ DEFAULT now()
);

-- ============================================
-- ROW LEVEL SECURITY
-- ============================================

-- Enable RLS on all tables
ALTER TABLE fund_config ENABLE ROW LEVEL SECURITY;
ALTER TABLE fund_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE members ENABLE ROW LEVEL SECURITY;

-- Allow anonymous read access to fund_config
CREATE POLICY "Allow anonymous read access to fund_config"
    ON fund_config
    FOR SELECT
    TO anon
    USING (true);

-- Allow anonymous read access to fund_entries
CREATE POLICY "Allow anonymous read access to fund_entries"
    ON fund_entries
    FOR SELECT
    TO anon
    USING (true);

-- Allow anonymous read access to members
CREATE POLICY "Allow anonymous read access to members"
    ON members
    FOR SELECT
    TO anon
    USING (true);

-- ============================================
-- SEED DATA
-- ============================================

-- fund_config seed data
INSERT INTO fund_config (key, value) VALUES
    ('initial_pool', 40381.30);

-- members seed data with memorable codes
INSERT INTO members (code, name, shares, language) VALUES
    ('ANYU-2024', 'Anyu', 5688.44, 'hu'),
    ('DEL-STAR', 'Del', 3810.12, 'en'),
    ('MUM-GOLD', 'Mum', 23179.74, 'en'),
    ('DOM-HERO', 'Domchi', 0, 'en');

-- fund_entries seed data
INSERT INTO fund_entries (month, profit_pct, withdrawals, fee_pct) VALUES
    ('2024-10-01', 0.0133, 0, 1),
    ('2024-11-01', 0.0856, 800, 0.5),
    ('2024-12-01', 0.1206, 2000, 0.3),
    ('2025-01-01', 0.09, 0, 0.3),
    ('2025-02-01', 0.1197, 750, 0.4),
    ('2025-03-01', 0.02, 0, 0),
    ('2025-04-01', 0.02, 0, 0),
    ('2025-05-01', 0.02, 0, 0),
    ('2025-06-01', 0.02, 0, 0),
    ('2025-07-01', 0.027, 0, 0),
    ('2025-08-01', 0.01, 0, 0),
    ('2025-09-01', 0.03, 0, 0),
    ('2025-10-01', 0.02, 0, 0),
    ('2025-11-01', 0.02, 0, 0);
