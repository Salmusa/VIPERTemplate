#!/bin/sh
TEMPLATE_PATH=$1
BUILD_TARGET_PATH=$2
CUSTOMIZABLE_FILE_PATH=$3
TEMPLATE_DESCRIPTION=$4
# Custom file paths
CUSTOM_FILE_HEADER_FILE_PATH="FileHeader"
CUSTOM_FILE_HEADER_VARIABLES_FILE_PATH="FileHeaderVariables"

# Create build target path
mkdir -p "$BUILD_TARGET_PATH"

# Copy template files
mkdir -p "$BUILD_TARGET_PATH/template/template"
cp -R "$TEMPLATE_PATH/template" "$BUILD_TARGET_PATH/template/template/--META_MODULE_NAME--Tests"
cp "$TEMPLATE_PATH/template.yml" "$BUILD_TARGET_PATH/template.yml"

# Copy file header
mkdir -p "$BUILD_TARGET_PATH/include"
if [ -f "$CUSTOM_FILE_HEADER_FILE_PATH" ]; then
  cp "$CUSTOM_FILE_HEADER_FILE_PATH" "$BUILD_TARGET_PATH/include/FileHeader"
else
  cp "$CUSTOMIZABLE_FILE_PATH/FileHeader" "$BUILD_TARGET_PATH/include/FileHeader"
fi

# Process file header variables
FILE_HEADER_VARIABLES_FILE_PATH="$CUSTOMIZABLE_FILE_PATH/FileHeaderVariables"
if [ -f "$CUSTOM_FILE_HEADER_VARIABLES_FILE_PATH" ]; then
  FILE_HEADER_VARIABLES_FILE_PATH="$CUSTOM_FILE_HEADER_VARIABLES_FILE_PATH"
fi
TEMPLATE_YAML_FILE_OUTPUT_PATH="$BUILD_TARGET_PATH/template/template.yml"
echo "description: ""$TEMPLATE_DESCRIPTION" >> "$TEMPLATE_YAML_FILE_OUTPUT_PATH"
echo "variables:" >> "$TEMPLATE_YAML_FILE_OUTPUT_PATH"
while read line
do
  echo "  - name: ""$line" >> "$TEMPLATE_YAML_FILE_OUTPUT_PATH"
done < "$FILE_HEADER_VARIABLES_FILE_PATH"
echo "  - name: Module Name" >> "$TEMPLATE_YAML_FILE_OUTPUT_PATH"
echo "  - name: Host Target Name" >> "$TEMPLATE_YAML_FILE_OUTPUT_PATH"
