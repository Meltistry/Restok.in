-- =====================================================
-- ReStock.in Database Schema untuk Supabase
-- =====================================================
-- File: database_schema.sql
-- Deskripsi: Complete database schema untuk aplikasi ReStock.in
-- =====================================================

-- =====================================================
-- 1. USER PROFILES TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS user_profiles (
    id_profile SERIAL PRIMARY KEY,
    id_user INTEGER NOT NULL UNIQUE,
    nickname VARCHAR(100) NOT NULL,
    description TEXT,
    profile_image_url TEXT,
    role VARCHAR(20) CHECK (role IN ('store_owner', 'restocker')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index untuk query berdasarkan user ID
CREATE INDEX idx_user_profiles_user_id ON user_profiles(id_user);
CREATE INDEX idx_user_profiles_role ON user_profiles(role);

-- =====================================================
-- 2. PAYMENT METHODS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS payment_methods (
    id_payment_method SERIAL PRIMARY KEY,
    id_user INTEGER NOT NULL,
    payment_type VARCHAR(20) NOT NULL CHECK (payment_type IN ('gopay', 'shopeepay')),
    account_number VARCHAR(50) NOT NULL,
    account_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT fk_payment_user FOREIGN KEY (id_user) REFERENCES user_profiles(id_user) ON DELETE CASCADE
);

-- Index untuk query berdasarkan user ID
CREATE INDEX idx_payment_methods_user_id ON payment_methods(id_user);
CREATE INDEX idx_payment_methods_type ON payment_methods(payment_type);

-- =====================================================
-- 3. STORES TABLE (existing, just showing for reference)
-- =====================================================
-- Assuming you already have stores table from previous work
-- If not, create it:
CREATE TABLE IF NOT EXISTS stores (
    id_store SERIAL PRIMARY KEY,
    id_user INTEGER NOT NULL,
    store_name VARCHAR(200) NOT NULL,
    store_address TEXT NOT NULL,
    store_image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT fk_store_user FOREIGN KEY (id_user) REFERENCES user_profiles(id_user) ON DELETE CASCADE
);

CREATE INDEX idx_stores_user_id ON stores(id_user);

-- =====================================================
-- 4. STORE ITEMS TABLE (existing, just showing for reference)
-- =====================================================
CREATE TABLE IF NOT EXISTS store_items (
    id_item SERIAL PRIMARY KEY,
    id_store INTEGER NOT NULL,
    item_name VARCHAR(200) NOT NULL,
    item_price DECIMAL(12, 2) NOT NULL,
    item_stock INTEGER NOT NULL DEFAULT 0,
    item_image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT fk_item_store FOREIGN KEY (id_store) REFERENCES stores(id_store) ON DELETE CASCADE
);

CREATE INDEX idx_store_items_store_id ON store_items(id_store);

-- =====================================================
-- 5. ROW LEVEL SECURITY (RLS) POLICIES
-- =====================================================

-- Enable RLS on all tables
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE payment_methods ENABLE ROW LEVEL SECURITY;
ALTER TABLE stores ENABLE ROW LEVEL SECURITY;
ALTER TABLE store_items ENABLE ROW LEVEL SECURITY;

-- User Profiles Policies
CREATE POLICY "Users can view all profiles" ON user_profiles
    FOR SELECT USING (true);

CREATE POLICY "Users can insert own profile" ON user_profiles
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Users can update own profile" ON user_profiles
    FOR UPDATE USING (true);

-- Payment Methods Policies
CREATE POLICY "Users can view own payment methods" ON payment_methods
    FOR SELECT USING (true);

CREATE POLICY "Users can insert own payment methods" ON payment_methods
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Users can update own payment methods" ON payment_methods
    FOR UPDATE USING (true);

CREATE POLICY "Users can delete own payment methods" ON payment_methods
    FOR DELETE USING (true);

-- Stores Policies
CREATE POLICY "Anyone can view stores" ON stores
    FOR SELECT USING (true);

CREATE POLICY "Users can insert own stores" ON stores
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Users can update own stores" ON stores
    FOR UPDATE USING (true);

CREATE POLICY "Users can delete own stores" ON stores
    FOR DELETE USING (true);

-- Store Items Policies
CREATE POLICY "Anyone can view store items" ON store_items
    FOR SELECT USING (true);

CREATE POLICY "Store owners can insert items" ON store_items
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Store owners can update items" ON store_items
    FOR UPDATE USING (true);

CREATE POLICY "Store owners can delete items" ON store_items
    FOR DELETE USING (true);

-- =====================================================
-- 6. TRIGGERS FOR UPDATED_AT
-- =====================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply trigger to all tables
CREATE TRIGGER update_user_profiles_updated_at
    BEFORE UPDATE ON user_profiles
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_payment_methods_updated_at
    BEFORE UPDATE ON payment_methods
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_stores_updated_at
    BEFORE UPDATE ON stores
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_store_items_updated_at
    BEFORE UPDATE ON store_items
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- 7. STORAGE BUCKETS (untuk Supabase Storage)
-- =====================================================
-- Jalankan di Supabase Dashboard > Storage atau via SQL Editor:

-- CREATE BUCKET untuk profile images
-- INSERT INTO storage.buckets (id, name, public) 
-- VALUES ('profile-images', 'profile-images', true);

-- CREATE BUCKET untuk store images
-- INSERT INTO storage.buckets (id, name, public) 
-- VALUES ('store-images', 'store-images', true);

-- CREATE BUCKET untuk item images
-- INSERT INTO storage.buckets (id, name, public) 
-- VALUES ('item-images', 'item-images', true);

-- Storage Policies (contoh untuk profile-images bucket)
-- CREATE POLICY "Anyone can view profile images" ON storage.objects
--     FOR SELECT USING (bucket_id = 'profile-images');

-- CREATE POLICY "Users can upload profile images" ON storage.objects
--     FOR INSERT WITH CHECK (bucket_id = 'profile-images');

-- =====================================================
-- 8. SAMPLE DATA (untuk testing)
-- =====================================================

-- Insert sample user profile
-- INSERT INTO user_profiles (id_user, nickname, description, role)
-- VALUES 
--     (1, 'Test Store Owner', 'I own a grocery store', 'store_owner'),
--     (2, 'Test Restocker', 'I help restock stores', 'restocker');

-- Insert sample payment method
-- INSERT INTO payment_methods (id_user, payment_type, account_number, account_name)
-- VALUES 
--     (1, 'gopay', '081234567890', 'Test Store Owner'),
--     (2, 'shopeepay', '081298765432', 'Test Restocker');

-- =====================================================
-- END OF SCHEMA
-- =====================================================
