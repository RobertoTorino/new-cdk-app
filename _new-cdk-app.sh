#!/bin/sh
# Set the terminal you use here: bash or zsh or another.
# Installs the latest AWS CDK. Only tested on macOS.
export TERM=xterm-256color

CDK="CREATE_CDK_APP_EXAMPLE"
DATE=$( date "+%d-%m-%YT%H:%M:%S" )
DIR="cdk-app-example"

# Get the absolute path of the source directory
SOURCE_DIR="$(pwd)/copy"

select cdk in $CDK; do
case $cdk in
"CREATE_CDK_APP_EXAMPLE")

echo "Date/time: $DATE"
cd || exit
# if dir does not exist, create it
if [ ! -d "$DIR" ]; then
  mkdir -p "$DIR" && chmod -R 755 "$DIR"
else
  rm -rvf "$DIR"
  mkdir -p "$DIR" && chmod -R 755 "$DIR"
  echo "Removed old files"
fi

echo "Directory [ $DIR ] is created!"
cd "$DIR" || exit
if command aws-cdk version &> /dev/null; then
     "echo ⚠️ CDK is already installed: $(cdk version)"
        echo "checking and installing update: $(npm i -g aws-cdk@latest)"
 	        echo "CDK installed successfully. ✨ ✨ "
 	            echo "Using AWS CDK: $(cdk version)"
else
     echo "Installing CDK: $(npm i -g aws-cdk@latest)"

if command -v cdk &> /dev/null; then
    echo "CDK installed successfully. ✨ ✨ "
    echo "Using AWS CDK: $(cdk version)"
else
    echo "Error: CDK installation failed."
    exit 1
fi
fi

echo
break
;;
*)
echo "Error! Please check your logs."
;;
esac
done

echo
echo "*****"
echo "Initializing app, using Typescript"
cdk init app --language typescript

echo
echo "*****"
echo "Configuring the app"
# Define the source files and their respective destinations
source_files=(
    "$SOURCE_DIR/cdk-app-example.ts"
    "$SOURCE_DIR/cdk-app-example-stack.ts"
    "$SOURCE_DIR/.gitignore"
    "$SOURCE_DIR/Makefile"
    "$SOURCE_DIR/functions"
    "$SOURCE_DIR/images"
    "$SOURCE_DIR/test"
    "$SOURCE_DIR/dev"
)

destination_paths=(
    "$HOME/cdk-app-example/bin"
    "$HOME/cdk-app-example/lib"
    "$HOME/cdk-app-example"
    "$HOME/cdk-app-example"
    "$HOME/cdk-app-example"
    "$HOME/cdk-app-example"
    "$HOME/cdk-app-example"
    "$HOME/cdk-app-example"
)

# Loop through each source file and its destination
for i in "${!source_files[@]}"; do
    source="${source_files[$i]}"
    destination="${destination_paths[$i]}"

    # Check if the source file/directory exists
    if [ -e "$source" ]; then
        echo "Source $source exists. Copying it to $destination."
        cp -rvf "$source" "$destination"
    else
        echo "Source $source does not exist. Please check the path."
        exit 1
    fi
done

echo
echo "*****"
echo "Uninstall deprecated packages"
npm r source-map-support
npm r inflight@1.0.6
npm r glob@7.2.3

echo
echo "*****"
echo "Initialize Go project"
go mod init github.com/new-cdk-app
go get -u github.com/aws/aws-lambda-go/lambda
go mod tidy

echo
echo "*****"
echo "Add and commit changes to git"
git add .
git commit -m "First commit for the example-cdk-app repository."
git log --pretty=oneline

echo
echo "*****"
echo "List the stack(s)"
cdk ls

open .

# Exit script.
kill -15 $PPID
