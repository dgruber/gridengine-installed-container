# gridengine-installed-container

Just a container image for testing Grid Engine.

Same as github.com/dgruber/gridengine-docker but uses a
existing sge installation if one is in the mounted
/opt/sge-install directory.

With changes from /opt/sge to /opt/sge-install it works
also without changes on Kubernetes using PV/PVC.

```
./build.sh

docker volume create sge

docker run -h master -v sge:/opt/sge-install -it drmaa/gridengine-installed:latest /bin/bash

# qsub -b y /bin/sleep 123
# qstat
# ...

```

