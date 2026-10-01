-- Colour and bit-depth facts about a clip's video, recorded at import so export can
-- keep them and the compatibility gate can refuse to join HDR and SDR clips. Clips
-- imported before this version have NULLs here; a fresh inspection is never required
-- to match a value the project did not record.
ALTER TABLE source_clip ADD COLUMN video_codec TEXT;
ALTER TABLE source_clip ADD COLUMN video_bit_depth INTEGER CHECK (video_bit_depth IS NULL OR video_bit_depth BETWEEN 8 AND 16);
ALTER TABLE source_clip ADD COLUMN color_primaries TEXT;
ALTER TABLE source_clip ADD COLUMN color_transfer TEXT;
ALTER TABLE source_clip ADD COLUMN color_matrix TEXT;
UPDATE database_schema_version SET version = 7, migration_id = '0007_video_format',
    updated_at = strftime('%Y-%m-%dT%H:%M:%fZ', 'now') WHERE singleton_id = 1;
INSERT INTO schema_migration VALUES (7, '0007_video_format', 'documentation-defined', strftime('%Y-%m-%dT%H:%M:%fZ', 'now'));
