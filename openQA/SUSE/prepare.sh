#!/bin/bash

FORCE=0
PREFIX="openqa"
TEST=""

function show_usage {
  echo "Usage: $0 [options] <action>"
  echo "Actions:"
  echo " - prepare_worker, prepare the worker to work on SUSE tests"
  echo " - install_test, install a test, requires the flag --test"
  echo "Options:"
  echo "-f|--force, destroys and recreate the previous data or container associated to the action"
  echo "--test [test_name], Install automatically a test"
  echo "--prefix [network_name], set a prefix network and container creation (the default is openqa)"
  echo "Avaliable tests:"
  echo "- opensuse"
}

function prepare_worker {
  CONT_NAME="${PREFIX}_worker"

  docker exec -t $CONT_NAME zypper in -y os-autoinst-distri-opensuse-deps
}

function install_test {
  if [ ! -d data/tests ]; then
    echo "data/tests doesn't exist, did you ran \$deploy prepare"
    exit 1
  fi

  pushd .
  cd data/tests || exit 1
  
  case "$TEST" in
    opensuse)
      [ $FORCE ] && rm -rf os-autoinst-distri-opensuse 2>/dev/null
      [ $FORCE ] && rm -rf opensuse 2>/dev/null
      
      git clone git@github.com:os-autoinst/os-autoinst-distri-opensuse.git
      ln -s os-autoinst-distri-opensuse opensuse
      git clone https://github.com/os-autoinst/os-autoinst-needles-opensuse.git
      mv os-autoinst-needles-opensuse/ opensuse/products/opensuse/needles
      ;;
    *)
      echo "Invalid test suit $TEST"
      exit 1
  esac
  
  popd || exit 1
}


[ $# -lt 1 ] && show_usage && exit 1

while [ -n "$1" ];do
  case "$1" in
    -h|--help)
      show_usage
      ;;
    --prefix)
      shift
      PREFIX="$1"
      ;;
    --test)
      shift
      TEST="$1"
      ;;
    -f|--force)
      FORCE=1
      ;;
    prepare_worker | install_test)
      ACTION="$1"
      shift
      ;;
    *)
      echo "Incorrect input provided $1"
      show_usage
      exit 1
  esac
shift
done

case "$ACTION" in
  prepare_worker)
    prepare_worker
    ;;
  install_test)
    install_test
    ;;
  *)
    echo "Invalid action $ACTION"
    show_usage
    exit 1
esac
