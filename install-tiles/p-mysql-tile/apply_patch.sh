#!/bin/bash

cat ../install-tile-pipeline.yml | yaml-patch -o pipeline-patch.yml > mysql-pipeline-patched.yml

fly format-pipeline -c mysql-pipeline-patched.yml > mysql-pipeline-final.yml
