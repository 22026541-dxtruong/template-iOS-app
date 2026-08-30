#!/bin/bash

# Usage:
# ./rename_project.sh MyNewApp
# or: bash rename_project.sh MyNewApp

NEW_NAME="${1:-MyNewApp}"

if [ -z "$NEW_NAME" ]; then
  echo "Usage: ./rename_project.sh <NewProjectName>"
  exit 1
fi

if [ ! -d "ios/MyApp" ]; then
  echo "Folder ios/MyApp not found."
  exit 1
fi

mv "ios/MyApp" "ios/$NEW_NAME"
mv "ios/$NEW_NAME/App/MyAppApp.swift" "ios/$NEW_NAME/App/${NEW_NAME}App.swift"

# Update project.yml
sed -i '' "s/name: MyApp/name: $NEW_NAME/g" ios/project.yml
sed -i '' "s/MyApp/$NEW_NAME/g" ios/project.yml

# Update all Swift, YML, plist and entitlements files
find ios -type f \( -iname "*.swift" -o -iname "*.yml" -o -iname "*.plist" -o -iname "*.entitlements" \) -print0 | while IFS= read -r -d '' file; do
  sed -i '' "s/MyApp/$NEW_NAME/g" "$file"
done

cd ios
xcodegen generate

echo "Project renamed to $NEW_NAME"
echo "Please check bundle identifier and DEVELOPMENT_TEAM in ios/project.yml"
