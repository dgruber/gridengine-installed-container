FROM centos:centos7

RUN yum --enablerepo=extras install -y epel-release
RUN yum update -y 
# centos 7 requires copr
RUN yum install -y 'dnf-command(config-manager)' db4-utils yum-plugin-copr

# kudos to loveshack
RUN yum copr enable -y loveshack/SGE

RUN yum install -y hwloc
RUN yum install -y gridengine gridengine-execd gridengine-qmaster gridengine-devel

RUN mkdir -p /opt/sge-helper
ADD auto_install_template /opt/sge-helper

# must be provided as external volume
ENV SGE_ROOT=/opt/sge
ENV LD_LIBRARY_PATH $SGE_ROOT/lib/lx-amd64

ADD install.sh /opt/sge-helper/install.sh

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
