# SUSE-QA-tools

## openQA

There are two scripts to deploy an complete environment in your local machine using containers: deploy.sh and prepare.sh

### openQA/deployer.sh

Creates the openQA service tha includes the webUI and a worker in 4 steps
1. **prepare**: Creates the directory structure and creates the network
  ```deployer.sh prepare```
2. **db**: Creates the container with the data base (postgresql)
  ```deployer.sh db```
3. **webui**: Creates the container with the webUI
  ```deployer.sh webui```
5. (Manual) Access to the webUI to get your key/secret API token
6. **worker**: Creates the container with the worker
   ```deployer.sh --key <your_key> --secret <your_secret> worker```
  
#### Run a test
First you must copy to data/tests your test suites. But maybe you want to use openQA/SUSE/prepare.sh script

Once this is done, you can use the scripts there are in the webUI container to launch testing jobs. e.g.

```
docker exec -ti openqa_webui /usr/share/openqa/script/clone_job.pl --apikey 1234567890ABCDEF --apisecret 1234567890ABCDEF https://openqa.opensuse.org/tests/1629804
```

#### Multiple openQA instances
By default is going to create containers with the prefix "openqa_" and each instance has it own network "openqa_net". But this prefix could be changed using the flag --prefix, therefore more than one instance could be created on a local machine. Also you will need to set a different port for the webUI (see next point)

#### Changing the webUI port
The webUI has the port 80 by default, but maybe this port is already in use. With the flag --port can be changed

#### Recreating the openQA instance
Sometimes could be interesting recreate a step forcing to destroy everything we have previously in this step. Then use the flag --force

#### Using your own images
By default this script uses the openQA images build by SUSE. But imagine you are an openQA developer, then you have your own openQA project and you are testing the code itself. Then with --webui-image and --worker-image can select your local images or other repositories images 

### openQA/SUSE/prepare.sh

This allows to prepare the openQA instance done by openQA/deployer.sh to execute openSUSE tests, openQA tests,... 

#### Prepare the worker

Install some packages in the worker

```prepare.sh prepare_worker```


#### Install tests suites

Install a test suite with its needles in the directory of data/tests

```prepare.sh --test opensuse install_test```

Actual tests available by the script:
* opensuse