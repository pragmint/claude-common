---
name: summary-generator
description: >
  Generates a weekly step-engine summary from live data and writes it to the summaries directory.
  Use this skill whenever the user wants to generate, write, or update a weekly summary — whether
  they say "generate a summary", "write the summary for this week", "summarise the week", or
  provide a date and ask for a summary.
---

## Goal

Gather all data for a given week, synthesise it into a concise, factual summary, and write it to the summaries directory.

---

## Step 1: Resolve the date

If the user provided a date, use it directly. If no date was given, use today's date. Dates must be in `D.M.YYYY` format (no leading zeros) — e.g. `13.3.2026`.


## Step 2: Synthesise

Write a summary with exactly four sections. Be specific and data-driven — name experiments, teams, scores, and blockers directly. Do not pad with generic observations.

### Format

```markdown
**Overview:** [One or two sentences. Name the week (e.g. "Week of 9–15 March 2026"). Describe the most important things that happened — capability scores recorded, experiment milestones, or notable changes.]

**Key Highlights:**
- [A specific positive development. Name the experiment, team, or metric. Include numbers where available.]
- [Repeat for each highlight. Typically 2–4 bullets.]

**Areas of Focus:**
- [A specific concern or risk. Name overdue experiments, blocked experiments with their blockers, score regressions, or stalled action items. Be direct.]
- [Repeat for each area. Typically 2–4 bullets.]

**Next Steps:**
- [A concrete, owner-facing action. Name the experiment or team. One action per bullet.]
- [Repeat. Typically 3–5 bullets.]
```

### Writing rules

- **Overview**: Cover the week in 1–2 sentences. Lead with capability scores if recorded; lead with experiments otherwise.
- **Key Highlights**: Report progress — experiments in polish phase, completed action items, score improvements, or milestones reached. Include the experiment slug or team name and any relevant numbers.
- **Areas of Focus**: Report problems — overdue experiments (state how many weeks over), blocked experiments (state the blocker and how long it has been blocked), score regressions (state the before/after), action items stuck in backlog.
- **Next Steps**: Each item should be actionable and scoped. "Follow up on DBA approval to unblock `team_a/automate-database-migrations`" is good. "Improve CI practices" is not.

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
