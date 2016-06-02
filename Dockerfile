FROM opensuse:42.1

MAINTAINER Kristoffer Gronlund <kgronlund@suse.com>

ENV container=docker

RUN zypper -n --gpg-auto-import-keys ar -C obs://network:ha-clustering:Factory/openSUSE_Leap_42.1 network:ha-clustering:Factory && \
    zypper -n --gpg-auto-import-keys ref && \
    zypper -n --gpg-auto-import-keys in -l dbus-1 net-tools fence-agents ha-cluster-bootstrap && \
    systemctl enable hawk

LABEL RUN /usr/bin/docker run -d \$OPT1 --privileged --net=host -p 7630:7630 -v /sys/fs/cgroup:/sys/fs/cgroup -v /etc/localtime:/etc/localtime:ro -v /run/docker.sock:/run/docker.sock -v /usr/bin/docker:/usr/bin/docker:ro --name \$NAME \$IMAGE \$OPT2 \$OPT3

EXPOSE 7630

CMD ["/usr/lib/systemd/systemd", "--system"]
