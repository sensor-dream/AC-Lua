Добавление скрипта в автозагрузку:
update-rc.d имя_скрипта_в_initd defaults
(или, начиная с Debian Squeeze)
insserv имя_скрипта_вinitd
Удаление скрипта из автозагрузки:
update-rc.d -f имя_скрипта_в_initd remove
(или, начиная с Debian Squeeze)
insserv -r имя_скрипта_вinitd