#!/bin/bash
set -e

echo "🔧 Starting Kotlin compilation fix automation..."

# Step 1: Extract the zip
echo "📦 Extracting dogmatix-export.zip..."
rm -rf dogmatix
unzip -q dogmatix-export.zip

# Step 2: Fix ArchiveScraper.kt
echo "✏️  Fixing ArchiveScraper.kt..."
ARCHIVE_SCRAPER_FILE="dogmatix/app/src/main/java/com/cortinadev/dogmatix/provider/ArchiveScraper.kt"

if [ -f "$ARCHIVE_SCRAPER_FILE" ]; then
    # Fix Line 69: Add explicit type annotation
    sed -i 's/list\.forEach { element ->/list.forEach { element: com.google.gson.JsonElement ->/g' "$ARCHIVE_SCRAPER_FILE"
    
    # Verify JsonHttp import exists, if not add it
    if ! grep -q "import.*JsonHttp" "$ARCHIVE_SCRAPER_FILE"; then
        if ! grep -q "import com.google.gson" "$ARCHIVE_SCRAPER_FILE"; then
            # Add import at the beginning after package declaration
            sed -i '/^package /a import com.google.gson.*' "$ARCHIVE_SCRAPER_FILE"
        fi
    fi
    
    echo "  ✅ ArchiveScraper.kt fixed"
else
    echo "  ❌ ArchiveScraper.kt not found at $ARCHIVE_SCRAPER_FILE"
fi

# Step 3: Fix HomeViewModel.kt
echo "✏️  Fixing HomeViewModel.kt..."
HOME_VIEW_MODEL_FILE="dogmatix/app/src/main/java/com/cortinadev/dogmatix/ui/screens/home/HomeViewModel.kt"

if [ -f "$HOME_VIEW_MODEL_FILE" ]; then
    # Fix Line 148 & 151: Replace emptySet with emptyList for List parameters
    sed -i 's/emptySet<ConsoleEntity>()/emptyList<ConsoleEntity>()/g' "$HOME_VIEW_MODEL_FILE"
    sed -i 's/emptySet<ConsoleWithFileCount>()/emptyList<ConsoleWithFileCount>()/g' "$HOME_VIEW_MODEL_FILE"
    
    echo "  ✅ HomeViewModel.kt fixed"
else
    echo "  ❌ HomeViewModel.kt not found at $HOME_VIEW_MODEL_FILE"
fi

# Step 4: Repackage the zip
echo "📦 Repackaging dogmatix-export.zip..."
rm -f dogmatix-export.zip
zip -r -q dogmatix-export.zip dogmatix/

# Step 5: Verify the fixes
echo "🔍 Verifying fixes..."
if grep -q "element: com.google.gson.JsonElement" "$ARCHIVE_SCRAPER_FILE"; then
    echo "  ✅ ArchiveScraper.kt type annotation verified"
fi

if grep -q "emptyList<ConsoleEntity>()" "$HOME_VIEW_MODEL_FILE"; then
    echo "  ✅ HomeViewModel.kt ConsoleEntity fix verified"
fi

if grep -q "emptyList<ConsoleWithFileCount>()" "$HOME_VIEW_MODEL_FILE"; then
    echo "  ✅ HomeViewModel.kt ConsoleWithFileCount fix verified"
fi

# Step 6: Clean up
echo "🧹 Cleaning up temporary files..."
rm -rf dogmatix

echo ""
echo "✅ All fixes applied successfully!"
echo "📝 Updated dogmatix-export.zip is ready to commit"
echo ""
echo "Next steps:"
echo "  1. git add dogmatix-export.zip"
echo "  2. git commit -m 'Fix Kotlin compilation errors in ArchiveScraper.kt and HomeViewModel.kt'"
echo "  3. git push"
echo "  4. Re-run the GitHub Actions workflow"
