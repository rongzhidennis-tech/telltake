# ADR-076: Enforce dataset consent through a shared registry

- Status: Accepted
- Date: 2026-09-15
- Scope: EC-18A; implements ADR-029–ADR-031 and ADR-073

## Decision

Dataset operations use one operator-controlled registry shared across collection
projects. Its database is separate from portable creator project packages: a
single project cannot establish creator/source isolation across the corpus.
The registry has its own versioned schema. Personal editing does not constitute
admission into either research dataset.

Register pseudonymous, stable creator identities and canonical source identities
before admitting content. Collection operators are responsible for reconciling
creator aliases and supplying verified source fingerprints. Record consent
evidence references independently for each item and purpose. References contain
no recording, transcript, or annotation content.

Admission and every content access require current consent for the requested
purpose. Development admission requires improvement consent, even when its
immediate requested use is evaluation. Held-out data never permits improvement
access. A creator or source previously admitted to one split cannot enter the
other; withdrawal does not erase this contamination history. No split-transfer
operation is provided in this slice.

Controlled originals and derivatives are purpose-specific artifacts. Derivatives
inherit their parent's admission and purpose. The registry provides authorized
reads rather than durable file-path capabilities. Callers must not retain copies
outside the controlled artifact store. Production authentication and remote
storage are not introduced by this local prototype.

Withdrawal first persists denial of new use, then deletes affected controlled
artifacts. A durable deletion queue records pending, completed, or failed work;
failed work can be retried explicitly. Deletion errors retain only a fixed error
code, never exception text that could contain content or paths. Audit identities
and consent history survive deletion; withdrawn consent cannot be reactivated.
Independent purpose copies remain governed by their own consent.
The registry binds its storage namespace on creation; opening it with another
backend is rejected so an empty backend cannot falsely satisfy deletion.

Creator feedback is unreviewed by default. Explicit, attributed review creates
a new annotation revision, distinguishes error, take preference, style, and
other editorial changes, and records whether creator intent was confirmed.
Disputed or unresolved feedback cannot be promoted to scored ground truth.
Annotation content is a controlled derivative, so withdrawal covers it too.

Evaluation manifests freeze item/source/creator identities, consent references,
annotation revision IDs, and candidate configuration references. They are
versioned and immutable, and include unresolved entries separately from scored
entries. Opening a frozen manifest rechecks current consent; freezing never
creates permanent permission to access withdrawn data. Manifests retain IDs and
references only, not recording or annotation content.

## Consequences

All collection and future evaluation adapters must use this registry boundary.
The synthetic integration tests verify policy and lifecycle behavior, not consent
authenticity, real-data representativeness, or model quality. Local deletion does
not erase operator-made backups or previously exported uncontrolled copies;
operators must keep these outside the collection workflow or track them with a
controlled storage adapter.
