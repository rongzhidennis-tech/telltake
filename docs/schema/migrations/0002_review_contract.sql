-- Schema v2: current Creator Cut groups, plan approval, captured exports,
-- and strict optional duration pairs. Apply transactionally after 0001.
-- Fail without rewriting historical rows if an existing range is invalid.
CREATE TEMP TABLE migration_0002_range_guard (valid INTEGER NOT NULL CHECK (valid = 1));
INSERT INTO migration_0002_range_guard
SELECT CASE WHEN (target_min_us IS NULL AND target_max_us IS NULL)
    OR (target_min_us IS NOT NULL AND target_max_us IS NOT NULL
        AND target_min_us > 0 AND target_max_us >= target_min_us)
    THEN 1 ELSE 0 END FROM analysis_run;
INSERT INTO migration_0002_range_guard
SELECT CASE WHEN (target_min_us IS NULL AND target_max_us IS NULL)
    OR (target_min_us IS NOT NULL AND target_max_us IS NOT NULL
        AND target_min_us > 0 AND target_max_us >= target_min_us)
    THEN 1 ELSE 0 END FROM cut_variant;
DROP TABLE migration_0002_range_guard;

CREATE TRIGGER analysis_run_target_pair_insert
BEFORE INSERT ON analysis_run
WHEN NOT ((NEW.target_min_us IS NULL AND NEW.target_max_us IS NULL)
    OR (NEW.target_min_us IS NOT NULL AND NEW.target_max_us IS NOT NULL
        AND NEW.target_min_us > 0 AND NEW.target_max_us >= NEW.target_min_us))
BEGIN
    SELECT RAISE(ABORT, 'target duration requires both valid bounds or neither');
END;

CREATE TRIGGER analysis_run_target_pair_update
BEFORE UPDATE ON analysis_run
WHEN NOT ((NEW.target_min_us IS NULL AND NEW.target_max_us IS NULL)
    OR (NEW.target_min_us IS NOT NULL AND NEW.target_max_us IS NOT NULL
        AND NEW.target_min_us > 0 AND NEW.target_max_us >= NEW.target_min_us))
BEGIN
    SELECT RAISE(ABORT, 'target duration requires both valid bounds or neither');
END;

CREATE TRIGGER cut_variant_target_pair_insert
BEFORE INSERT ON cut_variant
WHEN NOT ((NEW.target_min_us IS NULL AND NEW.target_max_us IS NULL)
    OR (NEW.target_min_us IS NOT NULL AND NEW.target_max_us IS NOT NULL
        AND NEW.target_min_us > 0 AND NEW.target_max_us >= NEW.target_min_us))
BEGIN
    SELECT RAISE(ABORT, 'target duration requires both valid bounds or neither');
END;

CREATE TRIGGER cut_variant_target_pair_update
BEFORE UPDATE ON cut_variant
WHEN NOT ((NEW.target_min_us IS NULL AND NEW.target_max_us IS NULL)
    OR (NEW.target_min_us IS NOT NULL AND NEW.target_max_us IS NOT NULL
        AND NEW.target_min_us > 0 AND NEW.target_max_us >= NEW.target_min_us))
BEGIN
    SELECT RAISE(ABORT, 'target duration requires both valid bounds or neither');
END;

-- Current creator-owned grouping; original AI grouping remains immutable.
CREATE TABLE creator_take_group (
    id TEXT NOT NULL PRIMARY KEY,
    cut_variant_id TEXT NOT NULL,
    source_ai_take_group_id TEXT,
    preferred_utterance_id TEXT NOT NULL,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    UNIQUE (id, cut_variant_id),
    FOREIGN KEY (cut_variant_id) REFERENCES cut_variant(id) ON DELETE CASCADE,
    FOREIGN KEY (source_ai_take_group_id) REFERENCES take_group(id) ON DELETE RESTRICT,
    FOREIGN KEY (id, preferred_utterance_id)
        REFERENCES creator_take_group_member(group_id, utterance_id)
        DEFERRABLE INITIALLY DEFERRED
) WITHOUT ROWID;

CREATE TABLE creator_take_group_member (
    group_id TEXT NOT NULL,
    cut_variant_id TEXT NOT NULL,
    utterance_id TEXT NOT NULL,
    ordinal INTEGER NOT NULL CHECK (ordinal >= 0),
    PRIMARY KEY (group_id, utterance_id),
    UNIQUE (group_id, ordinal),
    UNIQUE (cut_variant_id, utterance_id),
    FOREIGN KEY (group_id, cut_variant_id)
        REFERENCES creator_take_group(id, cut_variant_id) ON DELETE CASCADE,
    FOREIGN KEY (utterance_id) REFERENCES utterance(id) ON DELETE RESTRICT
) WITHOUT ROWID;

-- Mutable creator approval, separate from immutable AI cut metadata.
CREATE TABLE cut_review_state (
    cut_variant_id TEXT NOT NULL PRIMARY KEY,
    previewed_plan_hash TEXT,
    approved_plan_hash TEXT,
    approved_at TEXT,
    updated_at TEXT NOT NULL,
    CHECK ((approved_plan_hash IS NULL AND approved_at IS NULL)
        OR (approved_plan_hash IS NOT NULL AND approved_at IS NOT NULL
            AND previewed_plan_hash IS NOT NULL
            AND approved_plan_hash = previewed_plan_hash)),
    FOREIGN KEY (cut_variant_id) REFERENCES cut_variant(id) ON DELETE CASCADE
) WITHOUT ROWID;

-- Captured source plan for each export, independent of subsequent cut edits.
CREATE TABLE export_segment (
    export_record_id TEXT NOT NULL,
    ordinal INTEGER NOT NULL CHECK (ordinal >= 0),
    source_clip_id TEXT NOT NULL,
    source_start_us INTEGER NOT NULL CHECK (source_start_us >= 0),
    source_end_us INTEGER NOT NULL CHECK (source_end_us > source_start_us),
    PRIMARY KEY (export_record_id, ordinal),
    FOREIGN KEY (export_record_id) REFERENCES export_record(id) ON DELETE CASCADE,
    FOREIGN KEY (source_clip_id) REFERENCES source_clip(id) ON DELETE RESTRICT
) WITHOUT ROWID;

CREATE INDEX idx_creator_group_cut ON creator_take_group(cut_variant_id);
CREATE INDEX idx_creator_group_ai ON creator_take_group(source_ai_take_group_id);

INSERT INTO schema_migration (version, migration_id, checksum, applied_at)
VALUES (2, '0002_review_contract', 'documentation-defined', strftime('%Y-%m-%dT%H:%M:%fZ', 'now'));
UPDATE database_schema_version
SET version = 2, migration_id = '0002_review_contract',
    updated_at = strftime('%Y-%m-%dT%H:%M:%fZ', 'now')
WHERE singleton_id = 1;
