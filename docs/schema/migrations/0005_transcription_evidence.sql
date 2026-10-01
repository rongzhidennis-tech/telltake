CREATE TABLE transcription_provider_evidence (
    transcription_run_id TEXT NOT NULL REFERENCES transcription_run(id),
    ordinal INTEGER NOT NULL,
    response_json TEXT NOT NULL,
    PRIMARY KEY(transcription_run_id, ordinal)
);
CREATE TABLE utterance_review_note (
    utterance_id TEXT NOT NULL REFERENCES utterance(id),
    ordinal INTEGER NOT NULL,
    note TEXT NOT NULL,
    PRIMARY KEY(utterance_id, ordinal)
);
UPDATE database_schema_version SET version = 5, migration_id = '0005_transcription_evidence',
    updated_at = strftime('%Y-%m-%dT%H:%M:%fZ', 'now') WHERE singleton_id = 1;
INSERT INTO schema_migration VALUES (5, '0005_transcription_evidence', 'documentation-defined', strftime('%Y-%m-%dT%H:%M:%fZ', 'now'));
