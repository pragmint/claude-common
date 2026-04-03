---
name: summary-generator
description: >
  Generates a weekly step-engine summary from live data and writes it to the summaries directory.
  Use this skill whenever the user wants to generate, write, or update a weekly summary — whether
  they say "generate a summary", "write the summary for this week", "summarise the week", or
  provide a date and ask for a summary.
---

## Goal

Gather all data for a given week, synthesise it into a concise, factual, and forward-looking executive summary, and write it to the summaries directory.

---

## Step 1: Resolve the date

If the user provided a date, use it directly. If no date was given, use today's date. Dates must be in `D.M.YYYY` format (no leading zeros) — e.g. `13.3.2026`.


## Step 2: Synthesise

Write a summary with exactly four sections. Be specific and data-driven — name experiments, teams, scores, and blockers directly. Do not pad with generic observations.

### Tone

The summary is an executive communication — it should feel energising and forward-looking, not clinical or deflating.

- **Factual first.** Never invent, omit, or distort facts. Every claim must be grounded in the source data.
- **Always positive and optimistic in framing.** Even a rough week has progress worth celebrating. Lead with what moved forward.
- **Lighthearted where appropriate.** A touch of warmth goes a long way. Avoid language that sounds like a status report from a courtroom.
- **Frame negatives constructively — without distorting them.** Acknowledge blockers and setbacks accurately, then pair each with the path forward. Do not sugarcoat facts; reframe the *language* around them.
- **Never catastrophise.** Avoid words like "stalled", "failed", "missed", "overdue" in isolation — pair them with the path forward.
- **Assume the reader is on your side.** Write as if everyone reading this is already rooting for the team.

### Format

```markdown
**Overview:** [One or two sentences. Name the week (e.g. "Week of 9–15 March 2026"). Describe the most important things that happened — capability scores recorded, experiment milestones, or notable changes.]

**Key Highlights:**
- [A specific positive development. Name the experiment, team, or metric. Include numbers where available.]
- [Repeat for each highlight. Typically 2–4 bullets.]

**Areas of Focus:**
- [A challenge the team is actively navigating. Name the experiment, blocker, or metric — then frame it constructively with the path forward.]
- [Repeat for each area. Typically 2–4 bullets.]

**Next Steps:**
- [A concrete, owner-facing action. Name the experiment or team. One action per bullet.]
- [Repeat. Typically 3–5 bullets.]
```

### Writing rules

- **Overview**: Cover the week in 1–2 sentences. Lead with capability scores if recorded; lead with experiments otherwise.
- **Key Highlights**: Report progress — experiments in polish phase, completed action items, score improvements, or milestones reached. Include the experiment slug or team name and any relevant numbers.
- **Areas of Focus**: Frame challenges as active priorities, not failures. Name what needs attention — a blocked experiment, a score that dipped, an action item awaiting resolution — but pair each one with why the team is well-placed to address it, or what's already being done. Acknowledge blockers factually (name the blocker, how long it has been in place) while keeping the framing constructive: "waiting on DBA approval — good opportunity to accelerate once unblocked" rather than "blocked for 3 weeks".
- **Next Steps**: Each item should be actionable and scoped. "Follow up on DBA approval to unblock `team_a/automate-database-migrations`" is good. "Improve CI practices" is not.

### Bullet point guidelines

- **Voice & Perspective**: Use exclusively first-person plural ("We", "Our") — team-oriented, never individual. Avoid passive voice; the team is always the subject doing the action.
- **Tense Usage**: Present perfect for completed/ongoing work ("have been briefed", "have started"); present continuous for active in-progress efforts ("are making", "are actively working"); simple present or gerund for next steps ("Follow up", "Continuing", "Keep").
- **Tone**: Measured optimism — acknowledges problems without alarm. Frame issues diplomatically (e.g. "MR volume has been overwhelming" rather than "we are behind" or "we are blocked"). Confident but not boastful.
- **Sentence Structure**: Short to medium length, declarative sentences. Each bullet contains one main idea, often with a brief elaborating clause. Next steps use action-verb openers.
- **Vocabulary**: Plain, non-technical language even when referencing technical concepts. Avoids jargon for impact/status ("opens the door", "reduce the impact"). Slightly formal but conversational — no contractions, no slang.
- **Framing Patterns**: Problems are paired with mitigation — state the issue, then immediately note the response. Outcomes and benefits are called out explicitly.

---

## Step 3: Write the summary

Place the summary in the `./summaries/` folder and name the file with the following format. 

Examples:

9.1.2026.md
13.3.2026.md
16.1.2026.md
23.1.2026.md

Make sure you get the current date and use that for the schema.

---

## Step 4: Confirm

Tell the user:
- The date the summary was written for (and the week it covers)
- A one-sentence description of the most important thing captured in the summary
