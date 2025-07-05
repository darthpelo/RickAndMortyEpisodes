#!/bin/bash

# Script to add SwiftLint Build Phase to Xcode project
# This script modifies the project.pbxproj file to include SwiftLint in the build process

set -e

echo "🔧 Adding SwiftLint Build Phase to Xcode project..."

PROJECT_FILE="RickAndMortyEpisodes.xcodeproj/project.pbxproj"

if [ ! -f "$PROJECT_FILE" ]; then
    echo "❌ Error: project.pbxproj not found"
    exit 1
fi

# Backup original project file
cp "$PROJECT_FILE" "$PROJECT_FILE.backup"
echo "✅ Created backup of project.pbxproj"

# Use xcodeproj gem or plutil to modify the project
# For now, we'll provide manual instructions
echo ""
echo "📋 Please manually add SwiftLint Build Phase in Xcode:"
echo ""
echo "1. Open RickAndMortyEpisodes.xcodeproj in Xcode"
echo "2. Select your project in the navigator"
echo "3. Select the 'RickAndMortyEpisodes' target"
echo "4. Go to 'Build Phases' tab"
echo "5. Click '+' button and choose 'New Run Script Phase'"
echo "6. Name it 'SwiftLint'"
echo "7. Move it above 'Compile Sources'"
echo "8. Add this script:"
echo ""
echo 'if [ -f "../Scripts/swiftlint-build.sh" ]; then'
echo '    ../Scripts/swiftlint-build.sh'
echo 'elif which swiftlint >/dev/null; then'
echo '    swiftlint --config .swiftlint.yml'
echo 'else'
echo '    echo "SwiftLint not found, install using: brew install swiftlint"'
echo 'fi'
echo ""
echo "9. Save and build your project"
echo ""
echo "✅ SwiftLint will now run on every build and show warnings in Xcode!"

# Alternative: Create a simple script to run from Xcode directly
echo ""
echo "🔗 Alternatively, you can use this simplified script in Xcode Build Phase:"
echo ""
echo 'if which swiftlint >/dev/null; then'
echo '  swiftlint'
echo 'else'
echo '  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"'
echo 'fi' 