FROM centos:centos7

RUN groupadd sge
RUN useradd sge -g sge -b /home

RUN yum --enablerepo=extras install -y epel-release && yum clean all
# centos 7 requires copr
RUN yum update -y && yum install -y 'dnf-command(config-manager)' db4-utils yum-plugin-copr && yum clean all

# kudos to loveshack
RUN yum copr enable -y loveshack/SGE

RUN yum install -y hwloc gridengine gridengine-execd gridengine-qmaster gridengine-devel && yum clean all && mkdir -p /opt/sge-helper
COPY auto_install_template /opt/sge-helper

# must be provided as external volume
ENV SGE_ROOT=/opt/sge-install
ENV LD_LIBRARY_PATH $SGE_ROOT/lib/lx-amd64

COPY install.sh /opt/sge-helper/install.sh
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
