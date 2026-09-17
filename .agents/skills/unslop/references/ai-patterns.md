# AI Patterns Catalog: unslop

The complete 31-item index of synthetic patterns, AI tells, and concrete transformations.

---

## 1. Content

1. **Puffery:** "pivotal moment", "testament to", "evolving landscape", "setting the stage for", "indelible mark", "deeply rooted".
   - *Fix:* Cut puffery completely; state the concrete event or measurement.
2. **Name-Dropping:** Listing media outlets or firms without substantive context.
   - *Fix:* Quote a specific finding or delete the list.
3. **Superficial -ing Phrases:** "highlighting...", "ensuring...", "reflecting...", "showcasing...", "fostering...".
   - *Fix:* Split into distinct sentences or state exact mechanism.
4. **Promotional Language:** "nestled", "vibrant", "breathtaking", "groundbreaking", "renowned", "stunning", "must-visit".
   - *Fix:* Use neutral, objective descriptions.
5. **Vague Attributions:** "Experts believe", "Industry reports suggest", "Some critics argue".
   - *Fix:* Name the specific source or remove attribution.
6. **Formulaic Challenges:** "Despite challenges... continues to thrive."
   - *Fix:* State specific challenges and quantified metrics directly.

---

## 2. Language

7. **AI Vocabulary:** "additionally", "crucial", "delve", "enduring", "enhance", "fostering", "garner", "interplay", "intricate", "landscape" (abstract), "pivotal", "showcase", "tapestry", "testament", "underscore", "vibrant".
   - *Fix:* Replace with plain English equivalents ("examine", "shows", "key", "helps").
8. **Fancy Ways to Say "is":** "serves as", "stands as", "boasts", "features".
   - *Fix:* Use "is" or "has".
9. **"Not Just X, but Y":** Clichéd contrast framing.
   - *Fix:* State the core point directly.
10. **Rule of Three:** Forcing arguments or examples into artificial triplets.
    - *Fix:* Present only the natural number of items.
11. **Synonym Cycling:** Cycling through "protagonist", "main character", "hero" within one paragraph.
    - *Fix:* Pick one clear term and use it consistently.
12. **False Ranges:** "from X to Y" where X and Y do not share a meaningful continuum.
    - *Fix:* Enumerate topics as a direct list.

---

## 3. Style & Punctuation

13. **Em Dash Overuse:** Using em dashes as multi-clause separators.
    - *Fix:* Avoid em dashes entirely. Use periods or commas.
14. **Colon Overuse:** Using colons as mid-sentence explanatory connectors.
    - *Fix:* Rewrite as two standalone sentences.
15. **Boldface Overuse:** Bolding every technical term or noun phrase.
    - *Fix:* Restrict bolding to primary headings or term definitions.
16. **Inline-Header Lists:** Label followed by colon restating the line (`**Performance:** Performance improved`).
    - *Fix:* Convert to natural narrative prose.
17. **Title Case Headings:** Capitalizing Every Word in Headings.
    - *Fix:* Use sentence case headings.
18. **Decorative Emojis:** Prefixing headings or bullet items with emojis.
    - *Fix:* Remove all decorative emojis.
19. **Curly Quotes:** Typographic smart quotes (`“`, `”`, `‘`, `’`).
    - *Fix:* Use straight ASCII quotes (`"`, `'`).

---

## 4. Communication Artifacts

20. **Chatbot Preambles & Sign-offs:** "I hope this helps!", "Let me know if...", "Certainly!", "Of course!".
    - *Fix:* Delete entirely; begin immediately with the answer.
21. **Cutoff Disclaimers:** "While specific details are limited..."
    - *Fix:* Cite available data directly or omit.
22. **Sycophantic Tone:** "Great question! You're absolutely right!"
    - *Fix:* Respond directly to the inquiry without flattery.

---

## 5. Filler

23. **Filler Phrases:** "In order to" -> "To"; "Due to the fact that" -> "Because"; "It is important to note that" -> (delete).
24. **Excessive Hedging:** "could potentially possibly be argued that it might" -> "may".
25. **Generic Conclusions:** "The future looks bright." -> Provide specific roadmap milestones or concrete next steps.

---

## 6. Jargon & Metaphors

26. **Abstract Metaphor Nouns:** "substrate", "wedge", "vector", "locus", "vantage", "nexus", "primitive", "harness" (metaphor), "API surface", "bedrock", "scaffolding", "modality", "paradigm", "gold-plating", "ratchet", "evacuate", "endgame", "north star", "flywheel".
    - *Fix:* Use concrete terminology ("base", "add", "method", "core component", "migration").

---

## 7. Plain Speech

27. **Say What It Does, Not How It Feels:** Avoid "types that follow your schema" or "SQL you can read".
    - *Fix:* Name the mechanism: "a column rename fails the build", "`.toSQL()` returns raw query string".
28. **Shorten or Split Dense Sentences:** Break multi-clause sentences requiring reader backtracking.
29. **Active Voice:** Catch passive constructions ("queries are validated") and name the actor ("the compiler validates queries").
30. **Cut Adverbs / Use Strong Verbs:** Replace "runs quickly" with "is fast" or benchmark numbers.
31. **Prefer the Plain Word:** "utilize" -> "use", "leverage" -> "use", "facilitate" -> "help", "in the event that" -> "if".
