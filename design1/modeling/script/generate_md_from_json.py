import json
import os
import subprocess

json_path = "design1/modeling/log/model_progress.json"
md_path = "design1/modeling/log/model_progress.md"

# 读取 JSON
if not os.path.exists(json_path) or os.path.getsize(json_path) == 0:
    log = []
else:
    try:
        with open(json_path, "r") as f:
            log = json.load(f)
    except json.JSONDecodeError:
        log = []

# 获取 HEAD 的 SHA
try:
    head_sha = subprocess.check_output(
        ["git", "rev-parse", "HEAD"], text=True
    ).strip()
except subprocess.CalledProcessError:
    head_sha = None

# 写入 markdown
with open(md_path, "w") as f:
    f.write("# Model Progress\n\n")
    for idx, entry in enumerate(log):
        sha = entry.get("commit", "unknown")
        branch = entry.get("branch", "unknown")
        ts = entry.get("timestamp", "")
        plot1 = entry.get("plot1", "")
        plot2 = entry.get("plot2", "")
        files = entry.get("changed_files", [])

        # 若是 HEAD 的 commit（可能刚 amend），强制用 HEAD 获取
        try:
            if sha == head_sha:
                full_msg = subprocess.check_output(
                    ["git", "show", "-s", "--format=%B", "HEAD"],
                    text=True
                ).strip()
            else:
                full_msg = subprocess.check_output(
                    ["git", "show", "-s", "--format=%B", sha],
                    text=True
                ).strip()
        except subprocess.CalledProcessError:
            full_msg = "Unable to retrieve full message."

        # 写入 markdown
        f.write(f"## Commit [{sha}](https://github.com/naszhu/REM_E3_model_fixed/commit/{sha}) (branch: `{branch}`)\n")
        f.write(f"**Time:** {ts}  \n")
        f.write(f"**Message:**\n```\n{full_msg}\n```\n")

        if files:
            f.write("**Changed Files:**\n")
            for fname in files:
                f.write(f"- `{fname.strip()}`  \n")

        if plot1:
            f.write(f"![](../{plot1})  \n")
        if plot2:
            f.write(f"![](../{plot2})  \n")

        f.write("\n")
