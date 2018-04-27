#!/bin/bash

cat ../install-tile-pipeline.yml | yaml-patch -o pipeline-patch.yml > healthwatch-pipeline-patched.yml

fly format-pipeline -c healthwatch-pipeline-patched.yml > healthwatch-pipeline-final.yml
