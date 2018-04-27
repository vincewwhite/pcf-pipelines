#!/bin/bash

cat ../install-tile-pipeline.yml | yaml-patch -o pipeline-patch.yml > p-sso-pipeline-patched.yml

fly format-pipeline -c p-sso-pipeline-patched.yml > p-sso-pipeline-final.yml
