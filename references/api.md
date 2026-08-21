# Feedback Analysis API

The default deployment URL is:

```text
https://user-feedback-prioritization.onrender.com
```

Prefer `FEEDBACK_API_BASE_URL` so the skill can be pointed at another deployment.

## Health check

```text
GET /api/health
```

## Main workflow

1. `POST /api/feedback/import` with multipart form data:
   - `file`: CSV/XLS/XLSX file
   - `mode=preview`
2. After user confirmation, repeat with `mode=import`.
3. Read `analysisId` from the import response.
4. Send `x-analysis-id: <analysisId>` to `POST /api/analysis/run`.
5. Send the same header to `POST /api/pain-points/cluster`.
6. Send the same header to `POST /api/priority/calculate`.
6. Optional: `POST /api/strategies`

Use the corresponding `GET` endpoints to read status and results. Follow the API response's `error` field and HTTP status instead of assuming success.

## Feishu

Feishu OAuth is initiated by opening:

```text
GET /api/feishu/oauth/start
```

The user must complete authorization in the browser and bind their own `app_token` and `table_id` in the website. Never put the Feishu App Secret or user access token in this skill repository.

## Current deployment boundary

The current demo has browser/Feishu-based project selection but no general account login or API token authentication. The analysis ID isolates tasks but is a bearer link; do not use it for sensitive production data until the backend adds authentication, authorization, and rate limiting.
