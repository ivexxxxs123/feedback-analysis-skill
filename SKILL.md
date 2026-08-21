---
name: feedback-analysis
description: Analyze user feedback into structured insights, pain points, priorities, and product/operations strategies through the configured feedback-analysis web API. Use when the user asks to process feedback data or explain prioritization results.
---

# Feedback Analysis

Use this skill to operate the feedback-analysis application through its API while presenting concise, evidence-based results.

## Runtime configuration

- The default API base URL is `https://user-feedback-prioritization.onrender.com`.
- Use `FEEDBACK_API_BASE_URL` only when the user wants to target a different deployment; do not require users to set it for the default website.
- If the public result website is hosted at a different URL from the API, read `FEEDBACK_SITE_URL`; otherwise use the API base URL for result links.
- If the API requires authentication, read the token from the runtime secret store or environment only. Never ask the user to paste a token into chat and never print tokens in output.
- The current demo deployment may not have user authentication. Treat it as a test-only service and warn before using real or sensitive data.

## Workflow

1. Confirm the input file or feedback source and required fields: `user_id`, `user_type`, `is_paid`, `feedback`, and `created_at`.
2. Preview and validate the data before importing it. Report invalid rows and ask for confirmation before a write.
3. Import only after confirmation.
4. Ask whether the user wants to connect Feishu. If yes, explain that the website uses that user's own Feishu authorization and open the deployed website for the optional connection. If no, continue with file analysis only.
5. Run feedback analysis, then pain-point clustering, then priority calculation. Run strategy generation only when the user asks for strategies.
6. Summarize counts, high-priority pain points, evidence, and any failed rows. Distinguish rule-based results from AI-generated results.
7. Before deleting an import batch or triggering a destructive operation, explain the consequence and obtain explicit confirmation.

## Terminal execution mode

When the user asks to run the completed workflow through their terminal:

1. Complete the analysis plan and show the user what will be imported and processed.
2. Ask for explicit confirmation before generating a write command.
3. Generate one copy-pasteable command using the installed helper:

   ```bash
   bash ~/.codex/skills/feedback-analysis/scripts/run_analysis_and_open.sh "/absolute/path/to/feedback.csv"
   ```

4. Tell the user to paste the command into their own terminal. Do not execute it on the user's behalf and do not put API keys or tokens in the command.
5. The helper previews the file, asks for confirmation, imports it into a new isolated analysis task, runs analysis, clustering, and priority calculation, then opens that task's results page on macOS.

Use `FEEDBACK_API_BASE_URL` to target a different API deployment. Use `FEEDBACK_SITE_URL` when the result website has a different public URL; otherwise it defaults to the API URL. The helper opens `/api/analysis/access?analysisId=...`, which selects the isolated analysis task before redirecting to the dashboard.

After the command completes, provide these result links:

- Dashboard: `${FEEDBACK_API_BASE_URL}/`
- Analysis: `${FEEDBACK_API_BASE_URL}/analysis`
- Pain points: `${FEEDBACK_API_BASE_URL}/pain-points`
- Priority: `${FEEDBACK_API_BASE_URL}/priority`

## Data handling

- Do not expose raw feedback, user IDs, Feishu tokens, API keys, or database URLs unless the user explicitly requests a specific record and is authorized to see it.
- Keep each user's project scope separate. Each import must use the returned `analysisId`; never rely on the shared demo project.
- Do not claim that data is isolated when the API is running in demo mode.

## API details

Read [references/api.md](references/api.md) when making API calls or troubleshooting a failed workflow. Read [references/terminal-mode.md](references/terminal-mode.md) when generating the copy-pasteable terminal command.
