# Cloud Tools Image - Automated build repository

## Description

This repository contains a Dockerfile that will build a **Ubuntu Bionic** (18.04) image with handy cloud management tools for **Amazon Web Services** and **Oracle Cloud Infrastructure**.

**Important** to know is that this image is generated by a serverless compute unit instance (AWS Lambda function triggered by CloudWatch) whenever a new version of **Terraform** is released. **Packer**, **Ansible**, or even **Go** versions can be set by updating `internal/store.json` file manually by a new commit on master branch.

## Software included

Cloud tools and SDKs:
* Terraform **(0.11.12)**
* Packer **(1.3.5)**
* Ansible **(v2.7.1)**
* AWS [CLI](https://aws.amazon.com/cli/) and Python [SDK - boto3](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html)
* OCI [CLI](https://docs.cloud.oracle.com/iaas/tools/oci-cli/latest/oci_cli_docs/) and Python [SDK](https://oracle-cloud-infrastructure-python-sdk.readthedocs.io/en/latest/)

Development tools:
* build-essential package containing gcc, g++, make **(latest in Bionic)**
* Python **(v3.6)**
* Go **(go1.11.2)**
* Git, Subversion and some editors like vim, nano, mcedit

Environment:
* Bash with nice prompt coloring
* Bash proxy management function (**proxy**) and terraform OCI environment variables setup function (**setup_terraform_environ**)

**Attention**: Please have a look on the **Dockerfile** in order to see full list of software tools installed.

## Configuring shell proxy
For configuring shell proxy you have to create the following files in your **$HOME** and run `proxy` built in command:
* .HTTP_PROXY (one liner file containing something like `http://www.yourproxy.com:80`)
* .HTTPS_PROXY (one liner file containing something like `https://www.yourproxy.com:443`)
* .NO_PROXY  (one liner file containing something like `127.0.0.1,10.0.0.1`)
* .http_proxy (have a look above)
* .https_proxy (have a look above)
* .no_proxy (have a look above)

Beware that the content of those files will be exported to the shell variable having the same name like the file name. So pay attention with spaces after comma, or things that will mess up with shell `export` command.

Proxy command is defined in **$HOME/.bashrc**. `proxy on` will enable shell proxy if above mentioned files are existing. `proxy off` will `unset` the proxy environment variables.

For the lazy people, the following code snippet will help you to easily create the proxy files mentioned above:

```
#!/bin/bash

HTTP_PROXY="<fill-here-your-http-proxy>"
HTTPS_PROXY="<fill-here-your-https-proxy>"
NO_PROXY="<fill-here-the-list-of-no-proxy"

echo $HTTP_PROXY > $HOME/.http_proxy
echo $HTTP_PROXY > $HOME/.HTTP_PROXY
echo $HTTPS_PROXY > $HOME/.https_proxy
echo $HTTPS_PROXY > $HOME/.HTTPS_PROXY
echo $NO_PROXY > $HOME/.NO_PROXY
echo $NO_PROXY > $HOME/.no_proxy

```

## Configuring AWS access

The easiest way to configure AWS Cloud access is to run [`aws configure`](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#cli-quick-configuration) which will prompt you for the setup.

Also you can create the configure your **$HOME/.aws/credentials** file as described [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-config-files.html):

## Configuring OCI access

Configuring OCI console is done in a similar way like the AWS one by running [`oci setup config`](https://docs.cloud.oracle.com/iaas/Content/API/SDKDocs/cliinstall.htm). Variables configured in the **$HOME/.oci/config** must be the following in order for the terraform environment to be successfully configured:
* user (with ocid value)
* tenancy (with ocid value)
* compartment (with ocid value)
* fingerprint
* key_file (with key path)
* region

Based on those the following shell environment variables are exported automatically by shell **setup_terraform_environ** built in function:
* TF_VAR_user_ocid (terraform **user_ocid** variable)
* TF_VAR_tenancy_ocid (terraform **tenancy_ocid** variable)
* TF_VAR_compartment_ocid (terraform **compartment_ocid** variable)
* TF_VAR_fingerprint (terraform **fingerprint** variable)
* TF_VAR_private_key_path (terraform **private_key_path** variable)
* TF_VAR_region (terraform **region** variable)

Dockerfile has version 11.
