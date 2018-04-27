#!/bin/bash

cat ../install-tile-pipeline.yml | yaml-patch -o pipeline-patch.yml > iso-segments-pipeline-patched.yml

fly format-pipeline -c iso-segments-pipeline-patched.yml > iso-segments-pipeline-final.yml
