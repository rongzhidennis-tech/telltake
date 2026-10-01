CREATE TABLE passage_take_candidate (
    id TEXT PRIMARY KEY NOT NULL,
    recommendation_id TEXT NOT NULL REFERENCES ai_recommendation(id) ON DELETE CASCADE,
    ordinal INTEGER NOT NULL CHECK(ordinal >= 0),
    is_preferred INTEGER NOT NULL CHECK(is_preferred IN (0, 1)),
    UNIQUE(recommendation_id, ordinal)
);
CREATE UNIQUE INDEX passage_one_preference ON passage_take_candidate(recommendation_id) WHERE is_preferred = 1;
CREATE TABLE passage_take_member (
    candidate_id TEXT NOT NULL REFERENCES passage_take_candidate(id) ON DELETE CASCADE,
    utterance_id TEXT NOT NULL REFERENCES utterance(id),
    ordinal INTEGER NOT NULL CHECK(ordinal >= 0),
    PRIMARY KEY(candidate_id, ordinal),
    UNIQUE(candidate_id, utterance_id)
);
UPDATE database_schema_version SET version = 4, migration_id = '0004_passage_takes',
    updated_at = strftime('%Y-%m-%dT%H:%M:%fZ', 'now') WHERE singleton_id = 1;
INSERT INTO schema_migration VALUES (4, '0004_passage_takes', 'documentation-defined', strftime('%Y-%m-%dT%H:%M:%fZ', 'now'));
