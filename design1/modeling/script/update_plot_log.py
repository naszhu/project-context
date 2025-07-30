import sys, json, os

commit, branch, message, timestamp, plot1, plot2, changed_files = sys.argv[1:]
changed_list = changed_files.split(",") if changed_files else []

entry = {
    "commit": commit,
    "branch": branch,
    "message": message,
    "timestamp": timestamp,
    "plot1": plot1,
    "plot2": plot2,
    "changed_files": changed_list
}

log_path = "design1/modeling/log/model_progress.json"

if os.path.exists(log_path):
    try:
        with open(log_path, "r") as f:
            log = json.load(f)
    except json.JSONDecodeError:
        log = []
else:
    log = []

log.insert(0, entry)

with open(log_path, "w") as f:
    json.dump(log, f, indent=2)
