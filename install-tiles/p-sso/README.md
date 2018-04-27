# Single Sign-On Installation Pipeline

This pipeline and associated tasks installs and configures the Single Sign-On tile.

## Usage

Assuming you are in the root of the repository you can use the below commands to install the SSO tile. 

NOTE: Preexisting param files exist for the dagobah.yml and devstar.yml environments in the root/params directory.

Devstar
```
$ cat pipeline.yml | yaml-patch -o install-sso/pipeline-patch.yml > sso-pipeline.yml
$ fly -t sandbox set-pipeline -p install-sso-tile -c sso-pipeline.yml -l install-sso/params.yml -l params/common.yml -l params/devstar.yml
```
Dagobah
```
$ cat pipeline.yml | yaml-patch -o install-sso/pipeline-patch.yml > sso-pipeline.yml
$ fly -t sandbox set-pipeline -p install-sso-tile -c sso-pipeline.yml -l install-sso/params.yml -l params/common.yml -l params/dagobah.yml
```

Once the pipeline is fly'd up to Concourse we can un-pause the pipeline and kick off a run.

## Known-Issues
The pipeline will fail when run a second time. To resolve remove and un-stage the tile. 
