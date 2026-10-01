-- Durable transcription inputs, cleanup ownership, and explicit coverage.
CREATE TABLE transcription_job (
    ordinal INTEGER PRIMARY KEY AUTOINCREMENT,
    run_id TEXT NOT NULL UNIQUE REFERENCES transcription_run(id),
    cleanup_status TEXT NOT NULL DEFAULT 'not_required'
        CHECK(cleanup_status IN ('not_required', 'pending', 'succeeded', 'failed'))
);
CREATE TABLE transcription_audio (
    run_id TEXT NOT NULL REFERENCES transcription_run(id),
    source_clip_id TEXT NOT NULL REFERENCES source_clip(id),
    fingerprint TEXT NOT NULL,
    content_type TEXT NOT NULL CHECK(content_type IN ('audio/mp4', 'audio/wav')),
    PRIMARY KEY(run_id, source_clip_id)
);
CREATE TABLE transcript_clip_coverage (
    transcript_version_id TEXT NOT NULL REFERENCES transcript_version(id),
    source_clip_id TEXT NOT NULL REFERENCES source_clip(id),
    status TEXT NOT NULL CHECK(status IN ('complete', 'unresolved')),
    PRIMARY KEY(transcript_version_id, source_clip_id)
);
UPDATE database_schema_version SET version = 3, migration_id = '0003_transcription',
    updated_at = strftime('%Y-%m-%dT%H:%M:%fZ', 'now') WHERE singleton_id = 1;
INSERT INTO schema_migration VALUES (3, '0003_transcription', 'documentation-defined', strftime('%Y-%m-%dT%H:%M:%fZ', 'now'));
