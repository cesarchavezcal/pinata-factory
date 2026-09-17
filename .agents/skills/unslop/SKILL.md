---
name: unslop
description: "Trigger: unslop text, remove AI tells, or edit prose for humans. Strips synthetic phrasing, jargon, and stylistic artifacts."
license: MIT
metadata:
  author: michaelshimeles
  version: "2.0"
---

# Unslop

Edit and refine text to eliminate AI writing patterns, corporate buzzwords, and stylistic tells while restoring genuine human voice.

## Activation Contract

- **Trigger:** Editing or authoring text for human readers (commit messages, PR descriptions, docs, comments, or replies).
- **Scope:** Apply exclusively to agent-authored or edited prose; preserve existing user prose untouched.

## Hard Rules

- Never use em dashes; use periods or commas instead.
- Never use mid-sentence colons as connectors.
- Never use decorative emojis or title-cased subheadings.
- Replace all curly quotes with straight quotes.
- Eliminate chatbot filler ("I hope this helps!", "Certainly!") and sycophantic praise.
- Preserve all underlying technical facts, specifications, and code accuracy.

## Decision Gates

| Tell Category | Pattern Detected | Correction |
|---|---|---|
| Punctuation | Em dash, connector colon, curly quote | Use period, comma, straight quotes |
| Vocabulary | "delve", "pivotal", "landscape", "testament" | Replace with plain concrete terms |
| Jargon | "substrate", "vector", "flywheel", "surface" | Replace with direct functional names |
| Voice | Sterile, passive, or formulaic pros/cons | Add direct opinion, vary sentence length |
| Filler | "in order to", "due to the fact that" | Shorten to "to", "because" |

## Execution Steps

1. Scan candidate text across the 31 AI pattern categories.
2. Substitute plain vocabulary for AI buzzwords and abstract metaphors.
3. Fix punctuation tells: remove em dashes, connector colons, and curly quotes.
4. Convert passive constructions into active voice with concrete subjects.
5. Vary sentence rhythm: blend punchy short sentences with longer explanatory ones.
6. Run self-audit: ensure text sounds like a pragmatic engineer, not a marketing chatbot.

## Output Contract

- Rewritten prose in clean human voice with straight quotes, sentence-case headers, and zero AI tells.
- Emitted directly without conversational chatbot preambles or disclaimers.

## References

- [AI Patterns Catalog](references/ai-patterns.md): Comprehensive 31-item catalog with pattern explanations, banned terms, and transformations.
