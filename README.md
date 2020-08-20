<a href="http://autolabproject.com">
  <img src="http://svgshare.com/i/2Mf.svg" width="380px" height="100px">
</a>

Tango
======

Tango is a standalone RESTful Web service that runs and manages jobs. A job is a set of files that must satisfy the following constraints:

1. There must be exactly one `Makefile` that runs the job.
2. The output for the job should be printed to stdout. 

Example jobs are provided for the user to peruse in `clients/`. Tango has a [REST API](https://github.com/autolab/Tango/wiki/Tango-REST-API) which is used for job submission.

Upon receiving a job, Tango will copy all of the job's input files into a VM, run `make`, and copy the resulting output back to the host machine. Tango jobs are run in pre-configured VMs. Support for various Virtual Machine Management Systems (VMMSs) like KVM, Docker, or Amazon EC2 can be added by implementing a high level [VMMS API](https://github.com/autolab/Tango/wiki/Tango-VMMS-API) that Tango provides.

A brief overview of the Tango respository:

* `tango.py` - Main tango server
* `jobQueue.py` - Manages the job queue
* `jobManager.py` - Assigns jobs to free VMs
* `worker.py` - Shepherds a job through its execution
* `preallocator.py` - Manages pools of VMs
* `vmms/` - VMMS library implementations
* `restful-tango/` - HTTP server layer on the main Tango

Tango was developed as a distributed grading system for [Autolab](https://github.com/autolab/Autolab) at Carnegie Mellon University and has been extensively used for autograding programming assignments in CMU courses.

## Using Dockerised (distDocker variation) Tango

1. `ssh` into the server host
2. Pull tango docker image
3. Pull sample submission and grading image
4. Set up a dedicated user for autograding
    + create new user, e.g. `autograde`
    + add this user to docker group
    + `ssh-keygen` to generate ssh keys
    + `ssh-copy-id` to set up password-less access
    + create a dedicated directory as data channel between tango and graders
5. Set up config files
    + `DOCKER_VOLUME_PATH`
    + `DOCKER_HOST_USER`
    + `HOST_ALIAS`
    + `DOCKER_HOST_DOCKER_PATH`
    + make sure ssh from container to host works
6. Start the container **with proper volume mapping**
    + `config.py`
    + `id_rsa`
    + command is `docker run -p 8610:8610 -v /path/to/config.py:/opt/TangoService/Tango/config.py -v /path/to/id_rsa:/opt/TangoService/Tango/vmms/id_rsa tango`
7. Verify the system works. Given sample grading image `gcc` and sample submission, this can be done in one of the following to ways:
    + Execute a shell into the container, run `python /opt/TangoService/Tango/clients/tango-cli.py -P 8610 -k test -l assessment1 --runJob /path/to/submission --image gcc`
    + **TODO**: write some `curl` based test to verify the contains works properly

## Using Tango

Please feel free to use Tango at your school/organization. If you run into any problems with the steps below, you can reach the core developers at `autolab-dev@andrew.cmu.edu` and we would be happy to help.

1. [Follow the steps to set up Tango](https://autolab.github.io/docs/tango/).
2. [Read the documentation for the REST API](https://autolab.github.io/docs/tango-rest/).
3. [Read the documentation for the VMMS API](https://autolab.github.io/docs/tango-vmms/).
4. [Test whether Tango is set up properly and can process jobs](https://autolab.github.io/docs/tango-cli/).

## Python 2 Support
Tango now runs on Python 3. However, there is a legacy branch [master-python2](https://github.com/autolab/Tango/tree/master-python2) which is a snapshot of the last Python 2 Tango commit for legacy reasons. You are strongly encouraged to upgrade to the current Python 3 version of Tango if you are still on the Python 2 version, as future enhancements and bug fixes will be focused on the current master. 

We will not be backporting new features from `master` to `master-python2`.

## Contributing to Tango

1. [Fork the Tango repository](https://github.com/autolab/Tango).
2. Create a local clone of the forked repo.
3. Make a branch for your feature and start committing changes.
3. Create a pull request (PR).
4. Address any comments by updating the PR and wait for it to be accepted.
5. Once your PR is accepted, a reviewer will ask you to squash the commits on your branch into one well-worded commit.
6. Squash your commits into one and push to your branch on your forked repo. 
7. A reviewer will fetch from your repo, rebase your commit, and push to Tango.
 
Please see [the git linear development guide](https://github.com/edx/edx-platform/wiki/How-to-Rebase-a-Pull-Request) for a more in-depth explanation of the version control model that we use.  

## License

Tango is released under the [Apache License 2.0](http://opensource.org/licenses/Apache-2.0). 
