# Terminal execution mode

Use this mode when the user wants Codex to plan the analysis first and then run it from their own terminal.

## Command

```bash
bash "/absolute/path/to/feedback-analysis-skill/feedback-analysis/scripts/run_analysis_and_open.sh" "/absolute/path/to/feedback.csv"
```

The helper performs a preview first, requires the user to type `yes`, then calls the API in this order:

1. Import the file.
2. Run feedback analysis.
3. Cluster pain points.
4. Calculate priority.
5. Open the isolated results page for this analysis task.

The helper uses the current deployment automatically. Set `FEEDBACK_API_BASE_URL` before the command only when using another API deployment. If the website is hosted at a different URL, also set `FEEDBACK_SITE_URL`:

```bash
FEEDBACK_API_BASE_URL="https://api.example.com" FEEDBACK_SITE_URL="https://app.example.com" bash "/absolute/path/to/feedback-analysis-skill/feedback-analysis/scripts/run_analysis_and_open.sh" "/absolute/path/to/feedback.csv"
```

The current deployment has no general account/API-token authentication. The generated results URL is a bearer link; use only test data until authentication and project-level authorization are added.
