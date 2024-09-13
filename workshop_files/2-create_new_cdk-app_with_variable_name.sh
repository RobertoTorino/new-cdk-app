#!/bin/sh
# Set the terminal you use here: bash or zsh or another.
# Installs the latest AWS CDK. Only tested on macOS.
# Set your name for the app.
export TERM=xterm-256color

YELLOW='\033[1;33m'
CDK="CREATE_NEW_CDK_APP"
DATE=$(date "+%d-%m-%YT%H:%M:%S")

echo "$YELLOW"

# Prompt for app name and allow corrections
while true; do
    read -p "Enter the name for your CDK app: " APPNAME
    read -p "You entered '$APPNAME'. Is this correct? (y/n): " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) echo "Please enter the app name again.";;
        * ) echo "Please answer yes or no.";;
    esac
done

select cdk in $CDK; do
case $cdk in
"CREATE_NEW_CDK_APP")

echo "Date/time: $DATE"
cd || exit
# if dir does not exists create it
if [ ! -d "$APPNAME" ]; then
  mkdir -p "$APPNAME" && chmod -R 755 "$APPNAME"
else
  rm -rvf "$APPNAME"
  mkdir -p "$APPNAME" && chmod -R 755 "$APPNAME"
  echo "Removed old files"
fi

echo "Directory [ $APPNAME ] is created!"
cd "$APPNAME" || exit
 if command aws-cdk version &> /dev/null; then
     echo "⚠️""$YELLOW""CDK is already installed: $(cdk version)"
     echo "checking and installing update: $(npm i -g aws-cdk@latest)"
     echo "CDK installed successfully. ✨ ✨ "
     echo "Using AWS CDK: $(cdk version)"
 else
     echo "$YELLOW""Installing CDK: $(npm i -g aws-cdk@latest)"
     echo "Using AWS CDK: $(cdk version)"

     if command -v cdk &> /dev/null; then
         echo "CDK installed successfully. ✨ ✨ "
         echo "Using AWS CDK: $(cdk version)"
     else
         echo "Error: CDK installation failed."
         exit 1
     fi
 fi

  if command dot -V &> /dev/null; then
      echo "⚠️""$YELLOW""Graphviz is already installed: $(cdk version)"
  else
      echo "$YELLOW""Installing Graphviz: $(brew install Graphviz)"
      echo "Using Graphviz: $(dot -V)"

      if command dot -V &> /dev/null; then
          echo "Graphviz installed successfully. ✨ ✨ "
          echo "Using Graphviz: $(dot -V)"
      else
          echo "Error: Graphviz installation failed."
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

echo "$YELLOW""Initializing app, using Typescript"
cdk init app --language typescript

cd || exit
cd ${APPNAME} || exit

echo "$YELLOW""Uninstall deprecated packages"
npm r source-map-support
npm r inflight@1.0.6
npm r glob@7.2.3

echo "$YELLOW""Uninstalled source-map-support, inflight@1.0.6 and glob@7.2.3"

# Initialize Go project:
go mod init bitbucket.org/"$APPNAME"
go get -u github.com/aws/aws-lambda-go/lambda
go mod tidy

echo "$YELLOW""Add and commit changes to git"
git add .
git commit -m "First commit for the $APPNAME  repository."
git log

echo "$YELLOW""List the stack(s)"
cdk ls

git add .

open .

# Exit script.
kill -15 $PPID
