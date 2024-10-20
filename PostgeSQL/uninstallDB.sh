#!/bin/bash
BASEDIR=$(dirname $(realpath "$0"))
echo "DB '3D-vis' uninstallation (Удаление базы данных'):"
sudo -u postgres -H -- psql -f $BASEDIR/deleteAll.sql
exit