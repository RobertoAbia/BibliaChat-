-- Migration 00030: Add consent tracking columns
-- GDPR Article 9 requires explicit consent for religious data processing
-- These timestamps prove when consent was given

ALTER TABLE user_profiles
ADD COLUMN consent_terms_at TIMESTAMPTZ,
ADD COLUMN consent_data_at TIMESTAMPTZ;

COMMENT ON COLUMN user_profiles.consent_terms_at IS 'When user accepted Terms of Service and Privacy Policy';
COMMENT ON COLUMN user_profiles.consent_data_at IS 'When user consented to religious data processing (GDPR Art. 9)';
