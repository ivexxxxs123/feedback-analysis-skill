---
name: feedback-analysis
description: Analyze user feedback into structured insights, pain points, priorities, and product/operations strategies through the configured feedback-analysis web API. Use when the user asks to process feedback data or explain prioritization results.
---

# Feedback Analysis

Use this skill to operate the feedback-analysis application through its API while presenting concise, evidence-based results.

## Runtime configuration

- Read the API base URL from `FEEDBACK_API_BASE_URL`.
- If it is not set, ask the user for the deployed website URL; do not guess a private or local URL.
- If the API requires authentication, read the token from the runtime secret store or environment only. Never ask the user to paste a token into chat and never print tokens in output.
- The current demo deployment may not have user authentication. Treat it as a test-only service and warn before using real or sensitive data.

## Workflow

1. Confirm the input file or feedback source and required fields: `user_id`, `user_type`, `is_paid`, `feedback`, and `created_at`.
2. Preview and validate the data before importing it. Report invalid rows and ask for confirmation before a write.
3. Import only after confirmation.
4. Run feedback analysis, then pain-point clustering, then priority calculation. Run strategy generation only when the user asks for strategies.
5. Summarize counts, high-priority pain points, evidence, and any failed rows. Distinguish rule-based results from AI-generated results.
6. Before deleting an import batch or triggering a destructive operation, explain the consequence and obtain explicit confirmation.

## Data handling

- Do not expose raw feedback, user IDs, Feishu tokens, API keys, or database URLs unless the user explicitly requests a specific record and is authorized to see it.
- Keep each user's project scope separate when the API provides a user identity or project token.
- Do not claim that data is isolated when the API is running in demo mode.

## API details

Read [references/api.md](references/api.md) when making API calls or troubleshooting a failed workflow.
