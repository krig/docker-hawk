# HA cluster in a container

This repository contains the definition of a Docker container which
contains the Pacemaker/corosync stack, with the crmsh command line
interface and the Hawk web interface as tools for interacting with the
cluster.

Run an instance of the Hawk container on each cluster node.

## Getting the container

Either download it from the Docker Hub:

        docker pull krig/hawk

Or build it from a clone of this repository:

        docker build -t <username>/hawk .

## Running the container

        docker run -d \
            --privileged \
            --net=host -p 7630:7630 \
            -v /sys/fs/cgroup:/sys/fs/cgroup \
            -v /etc/localtime:/etc/localtime:ro \
            -v /run/docker.sock:/run/docker.sock \
            -v /usr/bin/docker:/usr/bin/docker:ro \
            --name hawk hawk

Then (if this is the first cluster node), initialize the cluster:

        docker exec -it hawk bash
        ha-cluster-init

Else join the cluster:

        docker exec -it hawk bash
        ha-cluster-join -c <any-cluster-node>

Hawk will be available at `https://localhost:7630`, and the default
credentials are user: `hacluster`, password: `linux`.

You can then manage docker containers as cluster resources using the
`ocf:heartbeat:docker` resource agent.

## Note on STONITH

For STONITH, you may be able to use the `fence_docker` agent.

Hawk will warn about the lack of STONITH. For testing purposes, you
can disable STONITH with the following command:

        docker exec -it hawk bash
        crm cfg property stonith-enabled=false

## Credits

This container was largely based on the pcs version created by
[@pschiffe](https://github.com/pschiffe/pcs).
