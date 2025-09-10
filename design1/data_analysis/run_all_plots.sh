#!/bin/bash

# Enhanced Plots Generation and Display Script with Selective Options
# Usage: ./run_all_plots.sh [p1-1|p1-2|p2-1|p2-2]
# p1-1: Initial within-list
# p1-2: Initial between-list  
# p2-1: Final within-list
# p2-2: Final between-list
# No argument: Run all plots

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTION]"
    echo ""
    echo "Plot Options:"
    echo "  p1-1    Generate Initial Within-List plot only"
    echo "  p1-2    Generate Initial Between-List plot only"
    echo "  p2-1    Generate Final Within-List plot only"
    echo "  p2-2    Generate Final Between-List plot only"
    echo "  (none)  Generate all plots"
    echo ""
    echo "Examples:"
    echo "  $0          # Run all plots"
    echo "  $0 p1-1     # Run only initial within-list plot"
    echo "  $0 p2-2     # Run only final between-list plot"
    echo ""
}

# Parse command line arguments
PLOT_OPTION="$1"

if [ "$PLOT_OPTION" = "-h" ] || [ "$PLOT_OPTION" = "--help" ]; then
    show_usage
    exit 0
fi

echo "============================================"
if [ -z "$PLOT_OPTION" ]; then
    echo "Running All Enhanced Plot Generation..."
else
    echo "Running Selected Plot Generation: $PLOT_OPTION"
fi
echo "============================================"

# Change to the script directory
cd "$(dirname "$0")"

# First generate the data (always needed)
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

# Define plot mappings
declare -A plot_scripts
plot_scripts["p1-1"]="E1-initial-within-list.R"
plot_scripts["p1-2"]="E1-initial-between-list.R"
plot_scripts["p2-1"]="E1-finaltest-within-list.R"
plot_scripts["p2-2"]="E1-finaltest-between-list.R"

declare -A plot_files
plot_files["p1-1"]="enhanced_within_list_plot.png"
plot_files["p1-2"]="enhanced_plot_figure3.png"
plot_files["p2-1"]="enhanced_finaltest_within_list_plot.png"
plot_files["p2-2"]="enhanced_finaltest_between_list_plot.png"

declare -A plot_names
plot_names["p1-1"]="Initial Within-List"
plot_names["p1-2"]="Initial Between-List"
plot_names["p2-1"]="Final Within-List"
plot_names["p2-2"]="Final Between-List"

# Determine which scripts to run
if [ -z "$PLOT_OPTION" ]; then
    # Run all plots
    scripts_to_run=("E1-initial-within-list.R" "E1-initial-between-list.R" "E1-finaltest-within-list.R" "E1-finaltest-between-list.R")
    plots_to_open=("enhanced_within_list_plot.png" "enhanced_plot_figure3.png" "enhanced_finaltest_within_list_plot.png" "enhanced_finaltest_between_list_plot.png")
else
    # Run selected plot
    if [[ -v plot_scripts["$PLOT_OPTION"] ]]; then
        scripts_to_run=("${plot_scripts[$PLOT_OPTION]}")
        plots_to_open=("${plot_files[$PLOT_OPTION]}")
        echo "Selected: ${plot_names[$PLOT_OPTION]} (${plot_scripts[$PLOT_OPTION]})"
    else
        echo "❌ Error: Invalid plot option '$PLOT_OPTION'"
        echo ""
        show_usage
        exit 1
    fi
fi

# Run each R script
for script in "${scripts_to_run[@]}"; do
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
echo "Opening generated plots..."
echo "============================================"

# Open generated plots
plot_count=0
for plot in "${plots_to_open[@]}"; do
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
echo "✓ Scripts processed: ${#scripts_to_run[@]}"
echo "✓ Plots opened: $plot_count"
if [ -z "$PLOT_OPTION" ]; then
    echo "✓ Mode: All plots generated"
else
    echo "✓ Mode: Selected plot (${plot_names[$PLOT_OPTION]})"
fi
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