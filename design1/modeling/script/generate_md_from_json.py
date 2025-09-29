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

# If no new commits, exit
if not log:
    exit(0)

# 获取 HEAD 的 SHA
try:
    head_sha = subprocess.check_output(
        ["git", "rev-parse", "HEAD"], text=True
    ).strip()
except subprocess.CalledProcessError:
    head_sha = None

# Get the newest commit (first in the JSON array)
newest_entry = log[0]
newest_sha = newest_entry.get("commit", "unknown")

# Read existing markdown content
existing_content = ""
if os.path.exists(md_path):
    with open(md_path, "r") as f:
        existing_content = f.read()

# Check if this commit is already in the markdown
if f"## Commit [{newest_sha}]" in existing_content:
    # Commit already exists, don't add it again
    exit(0)

# Generate the new entry for the newest commit
sha = newest_entry.get("commit", "unknown")
branch = newest_entry.get("branch", "unknown")
ts = newest_entry.get("timestamp", "")
plot1 = newest_entry.get("plot1", "")
plot2 = newest_entry.get("plot2", "")
files = newest_entry.get("changed_files", [])

# Get full message for the newest commit
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
    full_msg = newest_entry.get("message", "Unable to retrieve full message.")

# Build the new entry
new_entry = f"## Commit [{sha}](https://github.com/naszhu/REM_E3_model_fixed/commit/{sha}) (branch: `{branch}`)\n"
new_entry += f"**Time:** {ts}  \n"
new_entry += f"**Message:**\n```\n{full_msg}\n```\n"

if files:
    new_entry += "**Changed Files:**\n"
    for fname in files:
        new_entry += f"- `{fname.strip()}`  \n"

if plot1:
    new_entry += f"![](../{plot1})  \n"
if plot2:
    new_entry += f"![](../{plot2})  \n"

new_entry += "\n"

# Insert the new entry at the top of existing content
if existing_content:
    # Find the position after "# Model Progress\n\n"
    header = "# Model Progress\n\n"
    if existing_content.startswith(header):
        updated_content = header + new_entry + existing_content[len(header):]
    else:
        # Fallback: just prepend
        updated_content = header + new_entry + existing_content
else:
    # Create new file
    updated_content = "# Model Progress\n\n" + new_entry

# Write the updated content
with open(md_path, "w") as f:
    f.write(updated_content)