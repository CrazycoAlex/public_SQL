Для работы с PostgreSQL в ОС "AstraLinuxSE 1.6" следует:
1. Задать пароль пользователю postgres
2. Зайти в консоль под пользователем postgres (su postgres)
3. Запустить psql.

Для системного пользователя user:
1. Создать роль пользователя psql -U postgres -c "CREATE ROLE user LOGIN CREATEDB PASSWORD 'password';"
2. Создать БД системного пользователя (createdb)

Для работы с пользователями без меток:
В файле /etc/parsec/mswitch.conf, параметр zero_if_notfound установить в yes.

Установка БД в консоли с использованием psql: выполнить скрипт installDB.sh