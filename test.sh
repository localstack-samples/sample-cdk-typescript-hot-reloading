#!/bin/bash
# Smoke test for the hot-reloading sample: invoke the function, change the
# handler code on disk, and check that the next invocation picks it up
# without a redeploy.
set -euo pipefail

FN=test-hotreload
HANDLER=lib/fn/index.ts
MAX_ATTEMPTS=${MAX_ATTEMPTS:-30}

invoke() {
  local out
  out=$(mktemp)
  local meta
  meta=$(lstk aws lambda invoke --function-name "$FN" "$out")
  if echo "$meta" | jq -e 'has("FunctionError")' > /dev/null; then
    echo "Invocation failed: $(cat "$out")" >&2
    return 1
  fi
  cat "$out"
}

restore() {
  git checkout -- "$HANDLER"
  npx tsc > /dev/null
}
trap restore EXIT

echo "Invoking $FN"
result=$(invoke)
echo "Response: $result"
if ! echo "$result" | jq -e '.hello == "world"' > /dev/null; then
  echo "Test failed: unexpected response"
  exit 1
fi

echo "Changing the handler code and recompiling"
sed -i.bak 's/"world"/"hot-reload"/' "$HANDLER" && rm -f "$HANDLER.bak"
npx tsc

for attempt in $(seq 1 "$MAX_ATTEMPTS"); do
  result=$(invoke)
  if echo "$result" | jq -e '.hello == "hot-reload"' > /dev/null; then
    echo "Response: $result"
    echo "Test passed: code change was hot reloaded"
    exit 0
  fi
  echo "Attempt $attempt/$MAX_ATTEMPTS: still getting $result"
  sleep 2
done

echo "Test failed: code change was not picked up"
exit 1
