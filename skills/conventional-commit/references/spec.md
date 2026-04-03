# Conventional Commits v1.0.0 — Reference

Source: https://www.conventionalcommits.org/en/v1.0.0/#specification

---

## Commit message format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

Every element after `<type>` is optional except the description.

---

## Type

Required. Communicates intent and drives semantic versioning.

| Type | When to use | SemVer impact |
|------|-------------|---------------|
| `feat` | A new feature visible to users or callers | MINOR |
| `fix` | A bug fix | PATCH |
| `docs` | Documentation only | none |
| `style` | Formatting, whitespace, missing semicolons — no logic change | none |
| `refactor` | Code restructuring with no feature or fix | none |
| `perf` | Performance improvement | none |
| `test` | Adding or correcting tests | none |
| `build` | Build system, dependency changes | none |
| `ci` | CI configuration changes | none |
| `chore` | Everything else (maintenance, housekeeping) | none |

Types are case-insensitive in the spec, but **lowercase is the convention**.

---

## Scope

Optional. Placed in parentheses after the type: `feat(auth):`.

- Identifies the area of the codebase affected
- One word or short hyphenated phrase: `feat(user-api):`, `fix(db):`, `chore(deps):`
- Omit when the change is repo-wide or the scope is obvious

---

## Breaking changes

Indicated in **two ways** (use both when a breaking change occurs):

1. Append `!` immediately before the colon: `feat!:` or `feat(api)!:`
2. Add a `BREAKING CHANGE:` footer (see Footers section)

A `BREAKING CHANGE` footer without `!` is also valid, but using both is clearest.
Breaking changes correlate to a MAJOR version bump.

---

## Description

Required. A short summary of the change.

Rules:
- Imperative mood: "add login" not "added login" or "adds login"
- Lowercase first letter
- No trailing period
- Under 72 characters (aim for under 50 when possible)
- Describes *what* changed, not *why*

Good: `fix(auth): handle null token on logout`
Bad: `Fixed the bug where logout crashed when token was null.`

---

## Body

Optional. Separated from the description by a blank line.

- Use to explain *why* the change was made, or provide additional context
- Wrap lines at 72 characters
- Multiple paragraphs are allowed, separated by blank lines
- Does not repeat the description

---

## Footers

Optional. Separated from the body (or description, if no body) by a blank line.

Format: `<token>: <value>` or `<token> #<value>` (for issue references).

The token is case-insensitive **except** `BREAKING CHANGE`, which must be uppercase.

Common footers:

```
BREAKING CHANGE: <description of what broke and how to migrate>
Closes #123
Reviewed-by: Alice <alice@example.com>
Co-authored-by: Bob <bob@example.com>
```

Multiple footers are allowed, one per line.

---

## Full examples

### Simple fix

```
fix(parser): handle empty input string gracefully
```

### Feature with scope and body

```
feat(auth): add OAuth2 login via GitHub

Users can now sign in using their GitHub account. The existing
username/password flow is unchanged.
```

### Breaking change

```
feat(api)!: rename /users endpoint to /accounts

BREAKING CHANGE: the /users REST endpoint has been renamed to /accounts.
Clients must update their base URL. No other fields were changed.
```

### Chore with issue reference

```
chore(deps): upgrade lodash to 4.17.21

Closes #88
```

---

## What makes a commit message invalid

- Missing type
- Missing description
- No space after the colon (`feat:description` — invalid)
- Description in past tense or with a capital letter at the start
- `BREAKING CHANGE` footer in lowercase (`breaking change:` — invalid)
- Body or footers not separated by a blank line from what precedes them
