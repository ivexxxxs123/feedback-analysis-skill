# Terminal execution mode

Use this mode when the user wants Codex to plan the analysis first and then run it from their own terminal.

## Command

```bash
bash ~/.codex/skills/feedback-analysis/scripts/run_analysis_and_open.sh "/absolute/path/to/feedback.csv"
```

The helper performs a preview first, requires the user to type `yes`, then calls the API in this order:

1. Import the file.
2. Run feedback analysis.
3. Cluster pain points.
4. Calculate priority.
5. Open the isolated results page for this analysis task.

Set `FEEDBACK_API_BASE_URL` before the command to use another deployment:

```bash
FEEDBACK_API_BASE_URL="https://example.com" bash ~/.codex/skills/feedback-analysis/scripts/run_analysis_and_open.sh "/absolute/path/to/feedback.csv"
```

The current deployment has no general account/API-token authentication. The generated results URL is a bearer link; use only test data until authentication and project-level authorization are added.
