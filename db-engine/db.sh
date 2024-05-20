#!/bin/bash

# ------------------------------------------ DEFINE
DB_SERVICE_START="start"
DB_SERVICE_STOP="stop"
DB_SERVICE_RESTART="restart"
DB_SERVICE_DELETE="delete"

DB_C_RESET='\033[0m'
DB_C_RED='\033[0;31m'
DB_C_GREEN='\033[0;32m'
DB_C_BLUE='\033[0;34m'
DB_C_YELLOW='\033[1;33m'
DB_C_CYAN='\033[0;36m'
DB_C_PURPLE='\033[1;35m'

# println echos string
function println() {
  echo -e "$1"
}

# errorln echos i red color
function errorln() {
  println "${DB_C_RED}${1}${DB_C_RESET}"
}

# successln echos in green color
function successln() {
  println "${DB_C_GREEN}${1}${DB_C_RESET}"
}

# infoln echos in blue color
function infoln() {
  #println "${DB_C_BLUE}${1}${DB_C_RESET}"
  println "${DB_C_CYAN}${1}${DB_C_RESET}"
}

# warnln echos in yellow color
function warnln() {
  println "${DB_C_YELLOW}${1}${DB_C_RESET}"
}

# fatalln echos in red color and exits with fail status
function fatalln() {
  errorln "$1"
  exit 1
}

# ------------------------------------------ HELP
function db_help() {
  println "Usage: "
  println "  db.sh <service> [flags]"
  println "    ${DB_C_PURPLE}service:${DB_C_RESET}"
  println "      \033[0;32mstart\033[0m   - start   db service"
  println "      \033[0;32mstop\033[0m    - stop    db service"
  println "      \033[0;32mrestart\033[0m - restart db service"
  println "      \033[0;32mdelete\033[0m  - delete  db service and delete source's files"
  println
  println "    ${DB_C_PURPLE}flags:${DB_C_RESET}"
  println "    \033[0;32m-h\033[0m - Print this message"
  println
  println " ${DB_C_PURPLE}Examples:${DB_C_RESET}"
  println " "
  println "   db.sh start"
  println "   db.sh stop"
  println "   db.sh restart"
  println "   db.sh delete"
  println
}

# ------------------------------------------ SERVICE
function service_db_start() {
  echo "--------------------------Run: service_db_start--------------------------"
  # export-env
  check_home_dir

  # upload db service
  docker-compose -f ./docker/docker-compose.yaml up -d
}

function service_db_stop() {
  echo "--------------------------Run: service_db_stop--------------------------"
  # export-env
  check_home_dir

  # stop db service
  docker-compose -f ./docker/docker-compose.yaml stop
}

function service_db_restart() {
  echo "--------------------------Run: service_db_restart--------------------------"
  # export-env
  check_home_dir

  # restart db service
  docker-compose -f ./docker/docker-compose.yaml restart
}

function service_db_delete() {
  echo "--------------------------Run: service_db_delete--------------------------"
  # export-env
  check_home_dir

  # stop db service
  docker-compose -f ./docker/docker-compose.yaml stop

  # clear container data
  docker container prune -f
  docker volume prune -f

  # delete resources files
  rm -rf ./data/mysql-data/*
  rm -rf ./data/pgsql-data/*
  rm -rf ./data/redis-data/*
}

function check_home_dir() {
  export IPFS_DEPLOY=/node-data/ipfs-deploy
}

function service_operate_result() {
  local op=${1}
  successln "\n${op} db service successful..."
}

# ------------------------------------------ COMMAND
## parse top mode
if [[ $# -lt 1 ]]; then
  db_help
  exit 1
fi

# parse subcommand
if [[ $# -ge 1 ]]; then
  key="$1"
  if [[ ${key} == ${DB_SERVICE_START} ]]; then
    export SERVICE_MODE=${DB_SERVICE_START}
    shift
  elif [[ ${key} == ${DB_SERVICE_STOP} ]]; then
    export SERVICE_MODE=${DB_SERVICE_STOP}
    shift
  elif [[ ${key} == ${DB_SERVICE_RESTART} ]]; then
    export SERVICE_MODE=${DB_SERVICE_RESTART}
    shift
  elif [[ ${key} == ${DB_SERVICE_DELETE} ]]; then
    export SERVICE_MODE=${DB_SERVICE_DELETE}
    shift
  fi
fi

while [[ $# -ge 1 ]]; do
  key="$1"
  case ${key} in
  -h)
    db_help
    exit 0
    ;;
  esac
  shift
done

#------------------------------------MAINNET
if [ ${SERVICE_MODE} == ${DB_SERVICE_START} ]; then
  service_db_start
  service_operate_result ${SERVICE_MODE}
elif [ ${SERVICE_MODE} == ${DB_SERVICE_STOP} ]; then
  service_db_stop
  service_operate_result ${SERVICE_MODE}
elif [ ${SERVICE_MODE} == ${DB_SERVICE_RESTART} ]; then
  service_db_restart
  service_operate_result ${SERVICE_MODE}
elif [ ${SERVICE_MODE} == ${DB_SERVICE_DELETE} ]; then
  service_db_delete
  service_operate_result ${SERVICE_MODE}
else
  db_help
  exit 1
fi
