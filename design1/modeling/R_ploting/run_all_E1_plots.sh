#!/bin/bash

echo "=== Running All E1 Enhanced Plot Scripts ==="
echo "Working directory: $(pwd)"
echo ""

# Array to track which plots were created
declare -a created_plots=()
declare -a failed_scripts=()

echo "1. Running E1 Initial Within-List plot..."
if Rscript E1-initial-within-list-enhanced.R; then
    echo "✓ E1 Initial Within-List completed successfully"
    created_plots+=("E1_initial_within_list_enhanced.png")
else
    echo "✗ Error running E1-initial-within-list-enhanced.R"
    failed_scripts+=("E1-initial-within-list-enhanced.R")
fi

echo ""
echo "2. Running E1 Initial Between-List plot..."
if Rscript E1-initial-between-list-enhanced.R; then
    echo "✓ E1 Initial Between-List completed successfully"
    created_plots+=("E1_initial_between_list_enhanced.png")
else
    echo "✗ Error running E1-initial-between-list-enhanced.R"
    failed_scripts+=("E1-initial-between-list-enhanced.R")
fi

echo ""
echo "3. Running E1 Final Test Within-List plot..."
if Rscript E1-finaltest-within-list-enhanced.R; then
    echo "✓ E1 Final Test Within-List completed successfully"
    created_plots+=("E1_finaltest_within_list_enhanced.png")
else
    echo "✗ Error running E1-finaltest-within-list-enhanced.R"
    failed_scripts+=("E1-finaltest-within-list-enhanced.R")
fi

echo ""
echo "4. Running E1 Final Test Between-List plot..."
if Rscript E1-finaltest-between-list-enhanced.R; then
    echo "✓ E1 Final Test Between-List completed successfully"
    created_plots+=("E1_finaltest_between_list_enhanced.png")
else
    echo "✗ Error running E1-finaltest-between-list-enhanced.R"
    failed_scripts+=("E1-finaltest-between-list-enhanced.R")
fi

echo ""
echo "=== SUMMARY ==="

# Check for failures
if [ ${#failed_scripts[@]} -gt 0 ]; then
    echo "⚠ Some scripts failed:"
    for script in "${failed_scripts[@]}"; do
        echo "  ✗ $script"
    done
    echo ""
fi

# Wait for files to be written
sleep 1

# Report created plots
echo "📊 Generated plot files:"
for plot in "${created_plots[@]}"; do
    if [ -f "$plot" ]; then
        size=$(stat -c%s "$plot" 2>/dev/null || echo "unknown")
        echo "  ✅ $plot (${size} bytes)"
    else
        echo "  ⚠ $plot (file not found)"
    fi
done

echo ""

# Open plots if any were created
if [ ${#created_plots[@]} -gt 0 ]; then
    echo "🖼️ Opening plot images..."
    
    # Try different image viewers
    if command -v eog >/dev/null 2>&1; then
        echo "Opening with Eye of GNOME (eog)..."
        for plot in "${created_plots[@]}"; do
            if [ -f "$plot" ]; then
                eog "$plot" &
                sleep 0.8  # Small delay between opening each plot
            fi
        done
    elif command -v feh >/dev/null 2>&1; then
        echo "Opening with feh..."
        for plot in "${created_plots[@]}"; do
            if [ -f "$plot" ]; then
                feh "$plot" &
                sleep 0.8
            fi
        done
    elif command -v xdg-open >/dev/null 2>&1; then
        echo "Opening with default image viewer..."
        for plot in "${created_plots[@]}"; do
            if [ -f "$plot" ]; then
                xdg-open "$plot" &
                sleep 0.8
            fi
        done
    else
        echo "No image viewer found. Please manually open the plot files."
    fi
else
    echo "❌ No plots were successfully created."
fi

echo ""
echo "=== E1 PLOT GENERATION COMPLETE ==="

if [ ${#failed_scripts[@]} -eq 0 ]; then
    echo "🎉 All scripts ran successfully!"
    exit 0
else
    echo "⚠ Some scripts failed. Check the error messages above."
    exit 1
fi
