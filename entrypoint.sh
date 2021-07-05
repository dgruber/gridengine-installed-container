#!/bin/bash

# install grid engine or start grid engine when installed
cd /opt/sge-helper
./install.sh

source /opt/sge/default/common/settings.sh

exec "$@"
