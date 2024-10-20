#!/bin/bash
BASEDIR=$(dirname $(realpath "$0"))
echo "DB '3D-vis' installation (Установка базы данных'):"
echo "creating user (Создание пользователя БД) ..."
sudo -u postgres -H -- psql -f $BASEDIR/createUser.sql
echo "creating Database (Создание базы данных) ..."
sudo -u postgres -H -- psql -f $BASEDIR/createDataBase.sql
echo "creating schema 'Model' (Создание схемы данных 'Модель') ..."
sudo -u postgres -H -- psql -f $BASEDIR/Model/createSchema_classifiersmodel.sql
echo "creating schema 'Editor' (Создание схемы данных 'Редактор') ..."
sudo -u postgres -H -- psql -f $BASEDIR/Editor/createSchema_classifierseditor.sql
echo "creating schema 'EditorExperiment' (Создание схемы данных СПО) ..."
sudo -u postgres -H -- psql -f $BASEDIR/EditorExperiment/createSchema_classifiersexperimenteditor.sql
read -p "Заполнить базу данных тестовыми данными (y/n)? " answer
case $answer in
y | Y)
  echo "Inserting test example (запись тестовых данных) ..."
  sudo -u postgres -H -- psql -f $BASEDIR/Model/createModelTest.sql
  sudo -u postgres -H -- psql -f $BASEDIR/Editor/createEditorTest.sql
  sudo -u postgres -H -- psql -f $BASEDIR/EditorExperiment/createEditorExperimentTest.sql;;
n | N)
  echo "it's done";;
esac
exit