#!/bin/bash

# Script to run all 4 combined R plot files
# This script runs the R files that combine data and prediction plots side by side

echo "=========================================="
echo "Running Combined Data vs Prediction Plots"
echo "=========================================="

# Set the working directory to the design1 folder
cd "$(dirname "$0")"

# Check if R is available
if ! command -v Rscript &> /dev/null; then
    echo "Error: Rscript is not installed or not in PATH"
    exit 1
fi

# Check if required data files exist
echo "Checking for required data files..."

# Check data_analysis files
if [ ! -f "data_analysis/dfchanged.csv" ]; then
    echo "Error: data_analysis/dfchanged.csv not found"
    exit 1
fi

# Check modeling files (only check if final test is enabled)
if [ -f "../allresf.csv" ]; then
    echo "✓ Final test data found (allresf.csv)"
else
    echo "⚠️  Final test data not found (allresf.csv) - will skip final test plots"
fi

if [ ! -f "modeling/R_ploting/../../../all_results.csv" ]; then
    echo "Error: modeling data files not found (all_results.csv)"
    exit 1
fi

if [ ! -f "modeling/R_ploting/../../../DF.csv" ]; then
    echo "Error: modeling data files not found (DF.csv)"
    exit 1
fi

echo "All required data files found!"
echo ""

# Function to run R script and check for errors
run_r_script() {
    local script_name=$1
    local description=$2
    
    echo "Running $description..."
    echo "Script: $script_name"
    
    if Rscript "$script_name"; then
        echo "✓ $description completed successfully"
    else
        echo "✗ $description failed"
        return 1
    fi
    echo ""
}

# Run all 4 combined plot scripts
echo "Starting to generate combined plots..."
echo ""

# Check if final test is enabled by looking for allresf.csv
if [ -f "../allresf.csv" ]; then
    echo "✓ Final test is enabled (is_finaltest = true)"
    echo ""
    
    # 1. Final Test Between List
    run_r_script "combined_finaltest_between_list.R" "Final Test Between List (Data vs Prediction)"
    
    # 2. Final Test Within List  
    run_r_script "combined_finaltest_within_list.R" "Final Test Within List (Data vs Prediction)"
else
    echo "⚠️  Final test is disabled (is_finaltest = false)"
    echo "Skipping final test plots..."
    echo ""
fi

# 3. Initial Between List (always run)
run_r_script "combined_initial_between_list.R" "Initial Between List (Data vs Prediction)"

# 4. Initial Within List (always run)
run_r_script "combined_initial_within_list.R" "Initial Within List (Data vs Prediction)"

echo "=========================================="
echo "All Combined Plots Generation Complete!"
echo "=========================================="
echo ""
echo "Generated files:"
if [ -f "E1_final_test_between_list_combined.png" ]; then
    echo "• E1_final_test_between_list_combined.png"
fi
if [ -f "E1_final_test_within_list_combined.png" ]; then
    echo "• E1_final_test_within_list_combined.png"
fi
echo "• E1_initial_between_list_combined.png"
echo "• E1_initial_within_list_combined.png"
echo ""
echo "These files show data plots on the left and prediction plots on the right"
echo "for easy comparison between experimental results and model predictions."
echo ""
echo "Displaying plots with eog..."
echo ""

# Display all generated plots
if command -v eog &> /dev/null; then
    echo "Opening plots with eog (Eye of GNOME)..."
    if [ -f "E1_final_test_between_list_combined.png" ]; then
        eog E1_final_test_between_list_combined.png &
    fi
    if [ -f "E1_final_test_within_list_combined.png" ]; then
        eog E1_final_test_within_list_combined.png &
    fi
    eog E1_initial_between_list_combined.png &
    eog E1_initial_within_list_combined.png &
    echo "All available plots opened in eog!"
else
    echo "eog not found. Please install eog or manually open the PNG files."
    echo "You can also try: xdg-open *.png"
fi

echo ""
echo "Script completed successfully!"
