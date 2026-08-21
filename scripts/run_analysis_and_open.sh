#!/usr/bin/env bash
set -euo pipefail

API_BASE_URL="${FEEDBACK_API_BASE_URL:-https://user-feedback-prioritization.onrender.com}"
INPUT_FILE="${1:-}"

if [[ -z "$INPUT_FILE" || ! -f "$INPUT_FILE" ]]; then
  echo "用法：$0 /绝对路径/feedback.csv" >&2
  exit 2
fi

echo "正在预览：$INPUT_FILE"
PREVIEW="$(curl -sS -f -X POST \
  -F "file=@${INPUT_FILE}" \
  -F "mode=preview" \
  "${API_BASE_URL}/api/feedback/import")"
printf '%s\n' "$PREVIEW"

printf '确认将这份文件写入网站并开始分析？输入 yes 继续： '
read -r CONFIRM
if [[ "$CONFIRM" != "yes" ]]; then
  echo "已取消，没有写入数据。"
  exit 0
fi

echo "正在导入数据……"
IMPORT_RESPONSE="$(curl -sS -f -X POST \
  -F "file=@${INPUT_FILE}" \
  -F "mode=import" \
  "${API_BASE_URL}/api/feedback/import")"
printf '%s\n' "$IMPORT_RESPONSE"
ANALYSIS_ID="$(printf '%s' "$IMPORT_RESPONSE" | node -e 'let input=""; process.stdin.on("data", chunk => input += chunk); process.stdin.on("end", () => { try { process.stdout.write(JSON.parse(input).analysisId || ""); } catch {} });')"
if [[ -z "$ANALYSIS_ID" ]]; then
  echo "导入成功但没有收到分析任务 ID，无法隔离本次结果。" >&2
  exit 1
fi
REQUEST_HEADER=("-H" "x-analysis-id: ${ANALYSIS_ID}")
printf '\n'

echo "正在运行反馈分析……"
curl -sS -f "${REQUEST_HEADER[@]}" -X POST "${API_BASE_URL}/api/analysis/run"
printf '\n'

echo "正在聚合痛点……"
curl -sS -f "${REQUEST_HEADER[@]}" -X POST "${API_BASE_URL}/api/pain-points/cluster"
printf '\n'

echo "正在计算优先级……"
curl -sS -f "${REQUEST_HEADER[@]}" -X POST "${API_BASE_URL}/api/priority/calculate"
printf '\n'

RESULT_URL="${API_BASE_URL}/api/analysis/access?analysisId=${ANALYSIS_ID}"
echo "分析完成，正在打开：${RESULT_URL}"
if command -v open >/dev/null 2>&1; then
  open "$RESULT_URL"
elif command -v xdg-open >/dev/null 2>&1; then
  xdg-open "$RESULT_URL"
else
  echo "请手动打开：${RESULT_URL}"
fi
