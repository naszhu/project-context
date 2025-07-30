import json
from pathlib import Path
from datetime import datetime

log_path = Path("design1/modeling/log/model_progress.json")
html_path = Path("design1/modeling/log/model_progress.html")

with open(log_path, "r") as f:
    logs = json.load(f)

html = """
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Model Progress Summary</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 40px;
            background: #fafafa;
        }
        .commit-block {
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 10px;
            margin-bottom: 40px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }
        .commit-header {
            margin-bottom: 10px;
        }
        .commit-header a {
            font-weight: bold;
            color: #3366cc;
            text-decoration: none;
        }
        .commit-header small {
            color: #777;
            font-size: 0.9em;
        }
        .plot-row {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-top: 15px;
        }
        .plot-row img {
            width: 300px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        h1 {
            margin-bottom: 30px;
        }
        .changed-files {
            font-size: 0.9em;
            color: #444;
            margin-top: 5px;
        }
    </style>
</head>
<body>
<h1>Model Progress Summary</h1>
"""

for entry in reversed(logs):
    commit = entry["commit"]
    branch = entry["branch"]
    message = entry["message"]
    time = entry["timestamp"]
    changed = entry.get("changed_files", [])
    plot1 = entry.get("plot1", "")
    plot2 = entry.get("plot2", "")
    plot_imgs = [plot1, plot2]

    html += f"""
    <div class="commit-block">
        <div class="commit-header">
            Commit <a href="https://github.com/naszhu/REM_E3_model_fixed/commit/{commit}">{commit}</a><br>
            <small>Branch: {branch} &nbsp;|&nbsp; Time: {time} &nbsp;|&nbsp; Message: {message}</small>
        </div>
        <div class="changed-files">
            Changed Files: {', '.join(changed) if changed else 'N/A'}
        </div>
        <div class="plot-row">
    """
    for plot in plot_imgs:
        if plot:
            html += f'<img src="../{plot}" alt="plot image">'
    html += "</div></div>"

html += "</body></html>"

with open(html_path, "w") as f:
    f.write(html)
