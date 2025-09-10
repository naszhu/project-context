#!/bin/bash
# Script that runs parallel simulation first, then generates combined data vs prediction plots
# This script calls the existing run_parallel.sh and then run_combined_plots.sh

echo "=========================================="
echo "Running Simulation + Combined Plots"
echo "=========================================="
echo ""

# Get the repository root directory
REPO_ROOT=$(git rev-parse --show-toplevel)
cd "$REPO_ROOT"

echo "Step 1: Running parallel simulation..."
echo "Working directory: $REPO_ROOT"
echo ""

# Run the existing parallel simulation script
if [ -f "design1/modeling/run_parallel.sh" ]; then
    echo "🚀 Starting parallel simulation..."
    bash design1/modeling/run_parallel.sh
    
    # Check if simulation completed successfully
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ Parallel simulation completed successfully!"
        echo ""
    else
        echo ""
        echo "❌ Parallel simulation failed!"
        exit 1
    fi
else
    echo "❌ Error: design1/modeling/run_parallel.sh not found!"
    exit 1
fi

echo "Step 2: Generating combined data vs prediction plots..."
echo ""

# Change to design1 directory for combined plots
cd design1

# Check if the combined plots script exists
if [ -f "run_combined_plots.sh" ]; then
    echo "📊 Starting combined plots generation..."
    bash run_combined_plots.sh
    
    # Check if combined plots completed successfully
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ Combined plots generation completed successfully!"
        echo ""
    else
        echo ""
        echo "❌ Combined plots generation failed!"
        exit 1
    fi
else
    echo "❌ Error: run_combined_plots.sh not found in design1 directory!"
    exit 1
fi

echo "=========================================="
echo "🎉 Complete Pipeline Finished Successfully!"
echo "=========================================="
echo ""
echo "Generated files:"
echo "📈 Simulation Results:"
echo "  • DF.csv - Initial test aggregated results"
echo "  • all_results.csv - Raw initial test simulation data"
echo "  • allresf.csv - Raw final test simulation data"
echo "  • plot1.png - Initial test prediction plot"
echo "  • plot2.png - Final test prediction plot"
echo ""
echo "📊 Combined Data vs Prediction Plots:"
if [ -f "E1_final_test_between_list_combined.png" ]; then
    echo "  • E1_final_test_between_list_combined.png"
fi
if [ -f "E1_final_test_within_list_combined.png" ]; then
    echo "  • E1_final_test_within_list_combined.png"
fi
echo "  • E1_initial_between_list_combined.png"
echo "  • E1_initial_within_list_combined.png"
echo ""
echo "All plots should now be displayed in eog (Eye of GNOME)!"
echo ""
echo "Pipeline completed successfully! 🎉"
