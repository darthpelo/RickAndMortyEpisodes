#!/bin/bash

# SwiftLint Build Script for Rick and Morty Episodes App
# This script runs SwiftLint during Xcode build and shows warnings/errors

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "🔍 Running SwiftLint..."

# Check if SwiftLint is installed
if which swiftlint >/dev/null; then
    echo "✅ SwiftLint found"
else
    echo "❌ SwiftLint not installed, install using 'brew install swiftlint'"
    exit 1
fi

# Run SwiftLint with configuration
if [ -f ".swiftlint.yml" ]; then
    echo "📋 Using .swiftlint.yml configuration"
    swiftlint --config .swiftlint.yml
else
    echo "⚠️  No .swiftlint.yml found, using default configuration"
    swiftlint
fi

echo "✅ SwiftLint completed successfully" 