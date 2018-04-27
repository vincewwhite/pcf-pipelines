# Crunchy Installation Pipeline

This pipeline and associated tasks install and configure the Crunchy Postgres tile.

## Usage

Edit the params.yml located in this directory with any environment specific parameters for this tile install. In most cases, opsman_domain_or_ip_address is the only param that should have to change.

With the required pipeline parameters filled in we need to generate the actual tile pipeline from the pipeline.yml at the root of the repo and the pipeline-patch.yml ops file. Once generated we can fly up the pipeline. In the below example we're targeting a Concourse instance/team named sandbox and creating a pipeline named `install-crunchy-tile`.

Devstar: 
```
$ cat pipeline.yml | yaml-patch -o install-crunchy/pipeline-patch.yml > sso-pipeline.yml
$ fly -t sandbox set-pipline -p install-crunchy-tile -c install-crunchy/sso-pipeline.yml -l params.yml -l common.yml -l devstar.yml
```
Dagobah:
```
$ cat pipeline.yml | yaml-patch -o install-crunchy/pipeline-patch.yml > sso-pipeline.yml
$ fly -t sandbox set-pipline -p install-crunchy-tile -c install-crunchy/sso-pipeline.yml -l params.yml -l common.yml -l dagobah.yml
```
Once the pipeline is fly'd up to Concourse we can unpause the pipeline and kick off a run.

Note:
Pipeline will fail if executed after having already been uploaded.
