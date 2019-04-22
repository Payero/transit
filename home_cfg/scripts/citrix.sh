#!/bin/bash

SRC_DIR=~/.ICAClient
TMP_DIR=~/.ICAClient_TMPL

echo "Killing all ICAClient applications"
pk ICAClient
echo "Deleting $SRC_DIR content"
rm -fR $SRC_DIR/*
rm -fR $SRC_DIR/.tmp

echo "Copying $TGT_DIR content"
cp -R $TMP_DIR/* $SRC_DIR

echo "Running service"
/opt/Citrix/ICAClient/selfservice --icaroot /opt/Citrix/ICAClient &

echo "Done!!"