#!/usr/bin/env bash
# Популярность репы за последние 14 дней (данные GitHub Traffic).
# Это окно — ограничение GitHub: данные старше 14 дней он не отдаёт.
# Чтобы копить историю дольше — есть workflow .github/workflows/repo-stats.yml.
#
# Запуск:  ./stats.sh            (по умолчанию kulakov/statement)
#          ./stats.sh owner/repo
# Требует: gh (авторизован, с доступом к репе).
set -euo pipefail
REPO="${1:-kulakov/statement}"

echo "$REPO — GitHub Traffic, последние 14 дней"
echo
echo "Просмотры страницы репы:"
gh api "repos/$REPO/traffic/views" \
  --jq '"  всего: \(.count)   уникальных посетителей: \(.uniques)"'
echo "Клоны (≈ скопировали репу целиком):"
gh api "repos/$REPO/traffic/clones" \
  --jq '"  всего: \(.count)   уникальных: \(.uniques)"'
echo "Откуда переходили (по каналам/сайтам):"
gh api "repos/$REPO/traffic/popular/referrers" \
  --jq 'if length==0 then "  — пока никто" else (.[] | "  \(.referrer): \(.count) переходов (уник. \(.uniques))") end'
echo "Какие пути смотрели:"
gh api "repos/$REPO/traffic/popular/paths" \
  --jq 'if length==0 then "  — пока ничего" else (.[] | "  \(.path): \(.count) (уник. \(.uniques))") end'
