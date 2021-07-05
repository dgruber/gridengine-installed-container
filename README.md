# gridengine-installed-container

Just a container image for testing Grid Engine.

Same as github.com/dgruber/gridengine-docker but uses a
existing sge installation if one is in the mounted
/opt/sge directory.

```
./build.sh

docker volume create sge

docker run -h master -v sge:/opt/sge -it drmaa/gridengine-installed:latest /bin/bash

# qsub -b y /bin/sleep 123
# qstat
# ...

```

