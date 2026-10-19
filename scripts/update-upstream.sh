#!/usr/bin/env bash
# Regenerate data/upstream.json: public pull requests by $UPSTREAM_AUTHOR that were
# merged into repositories outside that account, grouped by repository.
#
#   scripts/update-upstream.sh            # writes data/upstream.json
#   UPSTREAM_AUTHOR=someone scripts/update-upstream.sh out.json
#
# Repositories to leave out entirely (for example a client's private-use fork) go in
# .upstream-exclude, one owner/name per line. That file is gitignored so the names stay
# private. Individual PRs are hidden from the site with data/upstream_exclude.yaml.
#
# Requires gh (authenticated) and jq.
set -euo pipefail

author=${UPSTREAM_AUTHOR:-ashtonian}
out=${1:-data/upstream.json}
exclude_file=.upstream-exclude

for tool in gh jq; do
  command -v "$tool" >/dev/null || { echo "update-upstream: $tool is required" >&2; exit 1; }
done

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

gh api -X GET search/issues \
  -f q="author:${author} type:pr is:public is:merged -user:${author}" \
  -f per_page=100 --paginate \
  --jq '.items[] | {repo: (.repository_url | sub("^https://api.github.com/repos/"; "")), title: (.title | gsub("^\\s+|\\s+$"; "")), url: .html_url, merged: .pull_request.merged_at[0:10]}' \
  > "$tmp/prs.jsonl"

touch "$tmp/exclude"
[ -f "$exclude_file" ] && grep -v '^\s*\(#\|$\)' "$exclude_file" > "$tmp/exclude" || true

jq -r '.repo' "$tmp/prs.jsonl" | sort -u | grep -vxF -f "$tmp/exclude" | while IFS= read -r repo; do
  gh api "repos/${repo}" --jq '{repo: .full_name, url: .html_url, stars: .stargazers_count, description: (.description // "")}'
done > "$tmp/repos.jsonl"

jq -n \
  --slurpfile prs "$tmp/prs.jsonl" \
  --slurpfile repos "$tmp/repos.jsonl" \
  --arg generated "$(date -u +%F)" \
  --arg author "$author" \
  '{
     generated: $generated,
     source: "GitHub search: public pull requests by \($author) merged into repositories outside that account",
     projects: (
       [ $repos[] as $r
         | $r + {prs: ([ $prs[] | select(.repo == $r.repo) | {title, url, merged} ] | sort_by(.merged, (.url | split("/") | last | tonumber)) | reverse)} ]
       | sort_by(-.stars, (.repo | ascii_downcase))
     )
   }' > "$out"

echo "update-upstream: wrote $out ($(jq '.projects | length' "$out") projects, $(jq '[.projects[].prs[]] | length' "$out") pull requests)"
