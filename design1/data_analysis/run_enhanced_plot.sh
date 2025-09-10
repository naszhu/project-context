#!/bin/bash

# Enhanced Plot Generation and Display Script
echo "============================================"
echo "Running Enhanced Plot Generation..."
echo "============================================"

# Change to the script directory
cd "$(dirname "$0")"

# Run the R script
echo "Executing R script..."
Rscript E1-initial-between-list.R

# Check if the plot was created successfully
if [ -f "enhanced_plot_figure3.png" ]; then
    echo "✓ Enhanced plot created successfully!"
    
    # Try different methods to open the plot
    echo "Opening plot..."
    
    # Try xdg-open first (works on most Linux distributions)
    if command -v xdg-open &> /dev/null; then
        xdg-open enhanced_plot_figure3.png
        echo "✓ Plot opened with xdg-open"
    # # Try gnome-open (GNOME desktop)
    # elif command -v gnome-open &> /dev/null; then
    #     gnome-open enhanced_plot_figure3.png
    #     echo "✓ Plot opened with gnome-open"
    # # Try kde-open (KDE desktop)
    # elif command -v kde-open &> /dev/null; then
    #     kde-open enhanced_plot_figure3.png
    #     echo "✓ Plot opened with kde-open"
    # # Try opening with default image viewer
    # elif command -v eog &> /dev/null; then
    #     eog enhanced_plot_figure3.png &
    #     echo "✓ Plot opened with Eye of GNOME (eog)"
    # elif command -v gwenview &> /dev/null; then
    #     gwenview enhanced_plot_figure3.png &
    #     echo "✓ Plot opened with Gwenview"
    # elif command -v display &> /dev/null; then
    #     display enhanced_plot_figure3.png &
    #     echo "✓ Plot opened with ImageMagick display"
    # else
    #     echo "⚠ Could not automatically open the plot."
    #     echo "Please manually open: enhanced_plot_figure3.png"
    fi
    
    # Also try opening the sample version as backup
    sleep 2
    # if [ -f "enhanced_plot_figure3_sample.png" ]; then
    #     echo "Also opening sample version..."
    #     if command -v xdg-open &> /dev/null; then
    #         xdg-open enhanced_plot_figure3_sample.png
    #     fi
    # fi
    
else
    echo "❌ Error: Enhanced plot was not created."
    echo "Please check the R script output above for errors."
fi

echo "============================================"
echo "Script completed!"
echo "============================================"