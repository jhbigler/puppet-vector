#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
module_dir=`dirname $SCRIPT_DIR`
container_id=''

##Rocky Linux
rocky_tag='rocky_test:latest'
rocky_dir="${SCRIPT_DIR}/RockyLinux"

build_rocky_container() {
    docker build -t "${rocky_tag}" "${rocky_dir}/"
}
run_rocky_container() {
    echo "Starting the rocky linux container"
    container_id=`docker run --privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:rw --cgroupns=host -v ${module_dir}:/etc/puppetlabs/code/modules/vector:z -d ${rocky_tag}`
}
stop_rocky_container() {
    docker stop $container_id
    container_id=''
}
remove_rocky_container() {
    docker rm "${rocky_tag}"
}
run_rocky_test() {
    echo ""
    echo ""
    echo "Running the test for ${1}"
    run_rocky_container
    docker exec ${container_id} /usr/local/sbin/test_manifest.sh $1
    if [ "$?" == "0" ]; then
        echo "Test passed!"
    else
        echo "Test failed!"
    fi
    stop_rocky_container
    container_id=''
}

build_rocky_container
run_rocky_test test1.pp
run_rocky_test test2.pp
run_rocky_test test3.pp

ubuntu_tag='ubuntu_test:latest'
ubuntu_dir="${SCRIPT_DIR}/Ubuntu"
build_ubuntu_container() {
    docker build -t "${ubuntu_tag}" "${ubuntu_dir}/"
}
run_ubuntu_test() {
    docker run -v "${module_dir}:/etc/puppetlabs/code/modules/vector:z" -it "${rocky_tag}" /usr/local/sbin/test_manifest.sh $1
}

build_ubuntu_container
run_ubuntu_test test1.pp
run_ubuntu_test test2.pp
run_ubuntu_test test3.pp