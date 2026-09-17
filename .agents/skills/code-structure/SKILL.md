---
name: code-structure
description: "Trigger: duplicate operational logic, action refactoring, or service layer design. Separates business orchestration from reusable mechanics."
license: MIT
metadata:
  author: michaelshimeles
  version: "2.0"
---

# Code Structure

Two-layer architecture separating action orchestration from reusable service mechanics.

## Activation Contract

- **Trigger:** Operational logic duplicated across 2+ workflows, refactoring repeated blocks in action files, or adding features sharing mechanics with existing flows.
- **Goal:** Move low-level mechanics into composable service functions while keeping business rules in action orchestrators.

## Hard Rules

- Never extract single-use logic (avoid premature abstraction).
- Never allow service functions to query or mutate database state directly.
- Service functions must accept explicit parameters and return structured results.
- Actions must own all business policy, authorization, state transitions, and error classifications.
- Refactor iteratively: migrate one caller, verify, then migrate remaining callers.

## Decision Gates

| Responsibility | Target Layer | Rationale |
|---|---|---|
| Business rules, auth checks, state transitions | Action / Orchestration | Represents product intent and user-facing policy |
| Low-level operations, SDK calls, shell execution | Service Layer | Centralizes operational reliability and mechanics |
| Logic used by only 1 caller | Action / Inline | Avoid premature complexity |
| Error retry policy / user error messages | Action / Orchestration | Callers dictate UX and failure tolerance |

## Execution Steps

1. Identify operational blocks duplicated across 2 or more callers.
2. Design a modular service function signature taking explicit arguments and returning typed results.
3. Extract operational mechanics to the service layer without direct DB access.
4. Update the first calling action to invoke the new service function.
5. Run tests, linter, and typecheck to verify the first caller behaves identically.
6. Progressively migrate remaining callers, verifying each step.

## Output Contract

- Composable service module file exporting explicit parameter and result interfaces.
- Refactored caller action files containing only orchestration and business policy.
- Zero typecheck or lint regressions across affected modules.

## References

- [Service Layer Guide](references/service-layer-guide.md): Architectural patterns, composability principles, anti-patterns, and email service example.
