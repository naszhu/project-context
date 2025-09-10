#!/bin/bash

echo "Starting enhanced R plot generation (with EXACT original data aggregation)..."
echo "Working directory: $(pwd)"

echo "Running fixed enhanced R_plots.r..."
if Rscript R_plots_enhanced_fixed.r; then
    echo "✓ R_plots_enhanced_fixed.r completed successfully"
else
    echo "✗ Error running R_plots_enhanced_fixed.r"
    exit 1
fi

echo "Running fixed enhanced R_plots_finalt.r..."
if Rscript R_plots_finalt_enhanced_fixed.r; then
    echo "✓ R_plots_finalt_enhanced_fixed.r completed successfully"
else
    echo "✗ Error running R_plots_finalt_enhanced_fixed.r"
    exit 1
fi

echo ""
echo "All R scripts completed successfully!"
echo ""

# Wait a moment for files to be fully written
sleep 1

# Check if plot files exist before trying to open them
if [ -f "plot1_enhanced.png" ] && [ -f "plot2_enhanced.png" ]; then
    echo "Both plot files found. Opening images..."
    
    if command -v eog >/dev/null 2>&1; then
        echo "Opening plots with Eye of GNOME (eog)..."
        eog plot1_enhanced.png &
        sleep 1
        eog plot2_enhanced.png &
    elif command -v feh >/dev/null 2>&1; then
        echo "Opening plots with feh..."
        feh plot1_enhanced.png &
        sleep 1
        feh plot2_enhanced.png &
    elif command -v xdg-open >/dev/null 2>&1; then
        echo "Opening plots with default image viewer..."
        xdg-open plot1_enhanced.png &
        sleep 0.5
        xdg-open plot2_enhanced.png &
    elif command -v display >/dev/null 2>&1; then
        echo "Opening plots with ImageMagick display..."
        display plot1_enhanced.png &
        sleep 1
        display plot2_enhanced.png &
    else
        echo "No suitable image viewer found. Please install eog, feh, or ImageMagick to view plots."
    fi
else
    echo "Warning: One or both plot files are missing!"
    ls -la plot*enhanced.png 2>/dev/null || echo "No enhanced plot files found."
fi

echo ""
echo "Generated files:"
[ -f "plot1_enhanced.png" ] && echo "  ✅ plot1_enhanced.png ($(stat -c%s plot1_enhanced.png) bytes)"
[ -f "plot2_enhanced.png" ] && echo "  ✅ plot2_enhanced.png ($(stat -c%s plot2_enhanced.png) bytes)"

echo ""
echo "Plot generation and display complete!"
