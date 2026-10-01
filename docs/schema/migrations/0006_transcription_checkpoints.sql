CREATE TABLE transcription_clip_checkpoint (
    run_id TEXT NOT NULL REFERENCES transcription_run(id),
    source_clip_id TEXT NOT NULL REFERENCES source_clip(id),
    source_fingerprint TEXT NOT NULL,
    source_fingerprint_algorithm TEXT NOT NULL,
    audio_fingerprint TEXT NOT NULL,
    output_json TEXT NOT NULL,
    created_at TEXT NOT NULL,
    PRIMARY KEY(run_id, source_clip_id)
);
CREATE TABLE transcription_clip_review_note (
    transcript_version_id TEXT NOT NULL REFERENCES transcript_version(id),
    source_clip_id TEXT NOT NULL REFERENCES source_clip(id),
    ordinal INTEGER NOT NULL,
    note TEXT NOT NULL,
    PRIMARY KEY(transcript_version_id, source_clip_id, ordinal)
);
UPDATE database_schema_version SET version = 6, migration_id = '0006_transcription_checkpoints',
    updated_at = strftime('%Y-%m-%dT%H:%M:%fZ', 'now') WHERE singleton_id = 1;
INSERT INTO schema_migration VALUES (6, '0006_transcription_checkpoints', 'documentation-defined', strftime('%Y-%m-%dT%H:%M:%fZ', 'now'));
