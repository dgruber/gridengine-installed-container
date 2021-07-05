#!/bin/bash

# expected that /opt/sge mounts a persistent storage

echo "source /opt/sge/default/common/settings.sh" >> /root/.bashrc

if [ -d /opt/sge/default/common ]; then
  echo "Grid Engine is already installed"
  echo "Starting daemons"
  /opt/sge/default/common/sgemaster
  /opt/sge/default/common/sgeexecd
  exit 0
fi

echo "Grind Engine is not installed in /opt/sge. Starting installation"

# qmon is required for the installer
touch /opt/sge/bin/lx-amd64/qmon

cd /opt/sge-helper
cp auto_install_template /opt/sge
cp install.sh /opt/sge
cd /opt/sge

# install qmaster and execd from scratch when container starts
cat ./auto_install_template | sed -e 's:docker:$HOSTNAME:g' > ./template_host
./inst_sge -m -x -auto ./template_host

# make sure installation is in path and libraries can be accessed
source /opt/sge/default/common/settings.sh
export LD_LIBRARY_PATH=$SGE_ROOT/lib/lx-amd64

# enable that root can submit jobs
qconf -sconf | sed -e 's:100:0:g' > global
qconf -Mconf ./global

# reduce scheduler reaction time to 1 second - and scheduling interval from
# 2 min. to 1 sec.
qconf -ssconf | sed -e 's:4:1:g' | sed -e 's:2\:0:0\:1:g' > schedconf
qconf -Msconf ./schedconf

# process 10 jobs at once per node
qconf -rattr queue slots 10 all.q 

