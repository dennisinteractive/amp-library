#!/bin/bash
set -e
set -x

# Go to the right location.
cd "$(dirname "$0")"

BIN_PATH="$(pwd)"
PROJECT_PATH=$(dirname $PWD)
VENDOR_PATH=$PROJECT_PATH/vendor

if ! command -v apt-get >/dev/null 2>&1; then
	echo "The AMP HTML uses apt-get, make sure to run this script in a Linux environment"
	exit 1
fi

# Install dependencies.
sudo apt-get install git python protobuf-compiler python-protobuf

# Create and go to vendor.
if [ ! -e $VENDOR_PATH ]; then
	mkdir $VENDOR_PATH
fi
cd $VENDOR_PATH

# Clone amphtml repo.
if [ ! -e $VENDOR_PATH/amphtml ]; then
	git clone https://github.com/ampproject/amphtml amphtml
else
	cd $VENDOR_PATH/amphtml/validator
	git fetch --tags
fi

# Check out the latest tag.
cd $VENDOR_PATH/amphtml
LATEST_TAG=$( git describe --abbrev=0 --tags )
git checkout $LATEST_TAG
clear

cp $BIN_PATH/*.py $VENDOR_PATH/amphtml/validator
cd validator

# Create dist folder.
if [ ! -e dist ]; then
	mkdir dist
fi

# Run WP script.
python amphtml-update-wp.py
# Run Lullabot Script.
python validator_gen_php.py

cp dist/validator-generated.php $PROJECT_PATH/src/Spec/
cp dist/class-amp-allowed-tags-generated.php $PROJECT_PATH/src/Spec/

echo "Generated from tag $LATEST_TAG"
