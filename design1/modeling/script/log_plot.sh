#!/bin/bash

commit=$(git rev-parse --short HEAD)
branch=$(git rev-parse --abbrev-ref HEAD)
commit_msg=$(git log -1 --pretty=%s)
# timestamp=$(date "+%Y-%m-%d %H:%M:%S")
commit_ts=$(git log -1 --format=%cd --date=format:'%Y-%m-%d %H:%M:%S' HEAD)
changed_files=$(git diff-tree --no-commit-id --name-only -r HEAD | paste -sd "," -)

mkdir -p design1/modeling/plot_archive
# safe_time=$(date "+%Y%m%d_%H%M%S")
safe_time=$(git log -1 --format=%cd --date=format:'%Y%m%d_%H%M%S' HEAD)
# this is last commit commit name address below
plot1_dest="plot_archive/${commit}_${safe_time}_plot1.png"
plot2_dest="plot_archive/${commit}_${safe_time}_plot2.png"
# cp plot1.png "$plot1_dest"
# cp plot2.png "$plot2_dest"

python3 design1/modeling/script/update_plot_log.py "$commit" "$branch" "$commit_msg" "$commit_ts" "$plot1_dest" "$plot2_dest" "$changed_files"
python3 design1/modeling/script/generate_md_from_json.py

echo "✅ Logged $commit on $branch to design1/modeling/log/model_progress.md and design1/modeling/log/model_progress.html"

echo "✅ Logged $commit on $branch to design1/modeling/log/model_progress.json"
# design1/modeling/script/generate_html_from_json.py