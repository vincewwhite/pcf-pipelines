#!/bin/bash

cat ../install-tile-pipeline.yml | yaml-patch -o pipeline-patch.yml > crunchy-postgres-pipeline-patched.yml

fly format-pipeline -c crunchy-postgres-pipeline-patched.yml > crunchy-postgres-pipeline-final.yml
