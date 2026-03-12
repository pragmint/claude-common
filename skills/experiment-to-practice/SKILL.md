# Experiment to Practice

## Overview

This skill converts a structured experiment YAML file into a practice markdown file following the open-practices format. Use it when you have an experiment file and want to generate a first draft of the corresponding practice page.

## Trigger

Use this skill when the user asks to:
- Generate a practice from an experiment
- Convert an experiment file into a practice
- Create a practice based on an experiment YAML

## Instructions

When invoked, follow these steps exactly:

### Step 1: Read the experiment file

Read the experiment YAML file the user provides. If no path is given, ask for it. The file will have these top-level keys:
- `context` — `problem_statement`, `desired_outcome`
- `hypothesis` — `statement`, `assumptions`, `risks`, `risk_mitigations`
- `intervention` — `practice_under_test`, `description`, `expected-duration-in-weeks`, `success_criteria`, `action-plan`

### Step 2: Read the practice template and a reference practice

Read both of these files to understand the expected format and tone:
- `templates/new-practice.md`
- `practices/visualize-all-work-on-a-storyboard.md` (use as a high-quality reference)

Also read `practices/adopt-the-opentelemetry-standard.md` if the topic is observability-related.

### Step 3: Determine the output filename

Derive the filename from `intervention.practice_under_test`. Convert the value to kebab-case if it isn't already. The output file goes in `practices/<practice_under_test>.md`.

### Step 4: Generate the practice file

Write the practice file using the following section-by-section mapping from the experiment data. Follow the tone, style, and length conventions of the reference practices:

#### Title (`# Practice Name`)
Convert `intervention.practice_under_test` from kebab-case to Title Case.

#### Introduction (2–4 paragraphs, no heading)
Write this fresh — do not copy experiment text verbatim. Draw from:
- `context.problem_statement` — the problem the practice addresses
- `context.desired_outcome` — what good looks like after adoption
- `hypothesis.statement` — the core mechanism / why this practice works

Frame the content from the perspective of a reader considering whether to adopt the practice. Be concrete and explain the real-world consequences of the problem. End with what the practice makes possible.

#### `## When to Experiment`
Write 3–5 persona-style bullet points. Each starts with a role (bolded) followed by a concrete pain they are experiencing that makes this practice relevant. Draw from `hypothesis.assumptions` and `context.problem_statement` to identify the right roles and motivations. Format: `- You are a **[Role]** who [pain/need].`

#### `## How to Gain Traction`
Open with one short paragraph framing the approach. Then write 2–4 `###` sub-headings, each covering one concrete step. Draw from:
- `intervention.action-plan` items for step ideas
- `hypothesis.risk_mitigations` for practical guidance within steps
- `intervention.description` for the overall approach

Each sub-section is one paragraph. Steps should be ordered logically (discover → set up → run → improve).

#### `## Lessons From The Field`
Write 3–5 bullet points, each starting with an italicised lesson title followed by a period and 1–3 sentences of elaboration. Draw from `hypothesis.risks` and `hypothesis.risk_mitigations`. Present these as wisdom from experience, not warnings. Format:
```
- *Lesson Title.* Elaboration sentence(s).
```

#### `## Deciding to Polish or Pitch`
Start with the fixed sentence (replacing X with the experiment's `expected-duration-in-weeks`):
```
After experimenting with this practice for **X weeks**, bring the team together to determine whether the following metrics and/or signals have changed in a positive direction:
```

Then create subsections for each item in `intervention.success_criteria`. Classify each criterion as one of:
- `### Fast & Measurable` — quantitative metric, visible within weeks
- `### Fast & Intangible` — qualitative signal, visible within weeks
- `### Slow & Measurable` — quantitative metric, visible over months
- `### Slow & Intangible` — qualitative signal, visible over months

Each subsection has a bolded benefit title followed by 2–4 sentences explaining what to look for and how to measure it. Multiple criteria can share the same sub-heading label if appropriate.

#### `## Supported Capabilities`
Choose 2–4 capabilities from this list that are most relevant to the practice. For each, write 2–4 sentences explaining how this practice advances the capability. Use `###` headings with a markdown link.

Available capabilities (link format: `/capabilities/<filename>.md`):
`ai-accessible-internal-data.md`, `clear-and-communicated-ai-stance.md`, `code-maintainability.md`, `continuous-delivery.md`, `continuous-integration.md`, `customer-feedback.md`, `database-change-management.md`, `deployment-automation.md`, `documentation-quality.md`, `empowering-teams-to-choose-tools.md`, `flexible-infrastructure.md`, `generative-organizational-culture.md`, `healthy-data-ecosystems.md`, `job-satisfaction.md`, `learning-culture.md`, `loosely-coupled-teams.md`, `monitoring-and-observability.md`, `monitoring-systems-to-inform-business-decisions.md`, `pervasive-security.md`, `platform-engineering.md`, `proactive-failure-notification.md`, `streamline-change-approval.md`, `team-experimentation.md`, `test-automation.md`, `test-data-management.md`, `transformational-leadership.md`, `trunk-based-development.md`, `user-centric-focus.md`, `version-control.md`, `visibility-of-work-in-the-value-stream.md`, `visual-management.md`, `well-being.md`, `work-in-process-limits.md`, `working-in-small-batches.md`

Capability display names should be converted from the filename (e.g. `monitoring-and-observability.md` → `Monitoring and Observability`).

### Step 5: Write the file

Write the generated content to `practices/<practice_under_test>.md`. After writing, tell the user:
- The file path created
- A brief note on any sections that needed significant creative inference (e.g. if the experiment had sparse data)
- A reminder that "Lessons From The Field" and the introduction especially benefit from human review and real team experience

## Quality Guidelines

- **Tone:** Direct, practitioner-facing, grounded. Avoid marketing language. Match the voice of `visualize-all-work-on-a-storyboard.md`.
- **Length:** Introduction ~3 paragraphs. Each "How to Gain Traction" step ~1 paragraph. Each "Lessons" bullet 1–3 sentences. Each capability 2–4 sentences.
- **Do not** copy experiment YAML text verbatim into the practice — rewrite everything in prose.
- **Do not** add sections not in the template.
- **Do not** invent external links, tool names, or citations not present in the experiment file.
- If the experiment is sparse, write reasonable content based on the practice name and problem domain, and flag the assumptions made.
