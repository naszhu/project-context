#!/bin/bash

# All Enhanced Plots Generation and Display Script
echo "============================================"
echo "Running All Enhanced Plot Generation..."
echo "============================================"

# Change to the script directory
cd "$(dirname "$0")"

# First generate the data
echo ""
echo "----------------------------------------"
echo "Generating data: generate_data.R"
echo "----------------------------------------"
if [ -f "generate_data.R" ]; then
    Rscript "generate_data.R"
    echo "✓ Data generation completed"
else
    echo "⚠ Warning: generate_data.R not found!"
fi

# List of plot R scripts to run
declare -a scripts=(
    "E1-initial-between-list.R"
    "E1-initial-within-list.R"
)

# List of expected plot files
declare -a plots=(
    "enhanced_plot_figure3.png"
    "enhanced_within_list_plot.png"
)

# Run each R script
for script in "${scripts[@]}"; do
    if [ -f "$script" ]; then
        echo ""
        echo "----------------------------------------"
        echo "Executing: $script"
        echo "----------------------------------------"
        Rscript "$script"
        echo "✓ Completed: $script"
    else
        echo "⚠ Warning: $script not found, skipping..."
    fi
done

echo ""
echo "============================================"
echo "Opening all generated plots..."
echo "============================================"

# Open all generated plots
plot_count=0
for plot in "${plots[@]}"; do
    if [ -f "$plot" ]; then
        echo "Opening: $plot"
        if command -v xdg-open &> /dev/null; then
            xdg-open "$plot"
            ((plot_count++))
            sleep 1  # Small delay between opening plots
        fi
    else
        echo "⚠ Warning: $plot not found"
    fi
done

echo ""
echo "============================================"
echo "Summary:"
echo "✓ Scripts processed: ${#scripts[@]}"
echo "✓ Plots opened: $plot_count"
echo "============================================"

# List all generated files
echo ""
echo "Generated files:"
for file in *.png *.csv; do
    if [ -f "$file" ]; then
        echo "• $file"
    fi
done

echo ""
echo "============================================"
echo "All plots generation completed!"
echo "============================================"