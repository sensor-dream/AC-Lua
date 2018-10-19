-- Дефолтный конфигурационный файл

return {

    -- даже если не активный, можно указать, по отдельности, иначе если активный, показывает все
    c_log = {
        active = true,
        info = false,
        warn = false,
        error = false,
    },

    disable_log_chk_mtr_autoteam = true,
    -- сокрытие работы мода, вернее вывода сообщений мода если не авторизирован на сервере
    -- если server.list_name_server_gema find in server.name   то автоматом установиться в true. Запарило изменять при множественном обновлении
    show_mod = false,

    server = {
        --обязательно указываются разные если работают несколько серверов с модами на 1 физическом или виртуальном сервереб также в таблице user базы данный mysql должено присутствовать поле с именем сервера, в данном случае у нас сервер gema в таблице user должно присутствовать count_login_gema, если у вас 2 или более серверо AC работающих на одной базе то все они должны быть указаны в таблице userб например: у вас 4 сервера gema, ctf, lss, vs то в таблице usep должны быть count_login_gema count_login_ctf count_login_lss count_login_vs Названия серверов жедательно в нижнем регистре, хотя автоматом и так в нижний регистр переведет
        -- name = gema or ctf or lss or vs
        -- name = 'rgba',
        name = 'VIOLENCIE',
        --проверка на возможные состаляющие для автоактивации режима гема, если другое название то добавте в список название сервера иначе мод будет в скрытом режиме
        list_name_server_gema = {
            'gema', 'temporary', 'local'
        },
        -- если на сервере ни кого нет то первый игрок войдет, а остальные побреются пока игрок не разблокирует сервер если сможет по доступу ))) или не покинет сервер, тогда автоматом разблокируется ))) шутка для первого игрока )).
        lock = {
            active = false,
            -- DISC -- EOP, CN, MKICK, MBAN, TAGT, BANREFUSE, WRONGPW, SOPLOGINFAIL, MAXCLIENTS, MASTERMODE, AUTOKICK, AUTOBAN, DUP, BADNICK, OVERFLOW, ABUSE, AFK, FFIRE, CHEAT
            reasson = 'MASTERMODE',
            message = '\f3%s \f1player trying to enter a locked server\f2.',
            -- not locked for player
            list = {
                '|VAH|-Vahe', '|VAH|-SDBS', 'SDBS', 
            }
        },

        auto_kick = {
            -- включить проверку на LoL name игрока
            active = true,
            -- сказать всем что поймался и выкинут
            say = true,
            -- DISC -- EOP, CN, MKICK, MBAN, TAGT, BANREFUSE, WRONGPW, SOPLOGINFAIL, MAXCLIENTS, MASTERMODE, AUTOKICK, AUTOBAN, DUP, BADNICK, OVERFLOW, ABUSE, AFK, FFIRE, CHEAT
            disc = 'BADNICK',
            -- лист запрещенных составляющих имени
            list = {
                'unarmed', 'ginah', 'idiot', 'bich','bitch','b!ch','b!tch', 'stef', 'trol', 'scuchka', 'lol', 'l0l', 'l0|', 'lo|', 
                    --'Sveark=MyS=', 
                    'gy_be', 
                    'medusa', 
            },
            message = '\f1Name \f3%s \f1component contains prohibited on this site. It is prohibited by the rules.',

        },

        ip_black = {
            active = true,
            -- DISC -- EOP, CN, MKICK, MBAN, TAGT, BANREFUSE, WRONGPW, SOPLOGINFAIL, MAXCLIENTS, MASTERMODE, AUTOKICK, AUTOBAN, DUP, BADNICK, OVERFLOW, ABUSE, AFK, FFIRE, CHEAT
            -- BAN -- VOTE, AUTO, BLACKLIST, MASTER, --REGISTERED, REFEREE,ROOT,ADMIN
            -- list = { IP, DISCONNECT MESAAGE, BAN FLAG  }--
            list = {
                { '127.0.0.1', 'AUTOKICK', 'AUTO' },
                -- { 'yuor IP', 'NONE', 'NONE' }, to bypass gban. The kernel must be patched
                { '212.164.221.229', 'NONE', 'NONE' }, --Margo
                { '212.164.221.190', 'NONE', 'NONE' }, 
                { '212.20.47.29', 'NONE', 'NONE' }, 
            },
            say = true,
            message = '\f1(\f3!\f1) \f2Player \f3%s \f0IP\f2: \fP%s\f2, banned on this server.'
        },

        -- not afk admins. смотрите и наблюдайте
        afk = {
            active = true,
            list = {
                '|VAH|-Vahe', '|VAH|-SDBS', 'SDBS', 'vahe', 'RETURN', 
                'cast', 'casta', 
                'Ammo', '|VAH|-Ammo', '|VAH|-B[]', 
                 'AA', 'QQ', 'SS', 'DD', 
            }
        },

        -- запрет на скачивание или создание демо игры, ну очень иногда надо
        demo = {
            -- если false то скачиваться не будет да и создаваться и загружатся на сервер тоже, решил обойтись 1 флагом
            get_flag = false
        },

        -- Таймеры показа системных и рекламмных сообщений через определенный промежуток времени
        timer_messages = {
            -- пример 1 таймера сообщения c применением функции
            [1] = {
                active = {
                    -- если название сервера отличается от названий в списке определений серверов то добавте по аналогии
                    -- disable отключает таймер в не зависимости от выбранных ниже
                    disable = true,
                    gema = true,
                    ctf = true,
                    lss = true,
                    vs = true
                },
                -- 300000 = 5 минут 5*60*1000
                period = 300000,
                text = function()
                    name = {
                        gema = '\f9G\f2e\f1m\f0A',
                        ctf = '\f3CTF',
                        lss = '\f0LSS',
                        vs = '\fVVS'
                    }
                    return string.format('%s \f2server \f9VAH \f2clan. \f0Website\f2: \fPvah-clan.github.io\f2 \f0E-mail\f2: \f0Irc\f2: \fPirc.freenode.net \fXchannel\f2: \fP#lut',name[sdbs.flag.SERVER] )
                end
            },
            -- пример 2 таймера сообщения c применением обычной строки
            [2] = {
                active = {
                    -- если название сервера отличается от названий в списке определений серверов то добавте по аналогии
                    -- disable отключает таймер в не зависимости от выбранных ниже
                    disable = true,
                    gema = true,
                    ctf = true,
                    lss = true,
                    vs = true
                },
                -- 480000 = 8 минут 8*60*1000
                period = 480000,
                text = '(\f3!\f2) If you have questions to us, please \f0e-mail\f2: \fPadmin@vah-clan.site \f2or on \f0irc\f2: \fPirc.freenode.net \fXchannel\f2: \fP#vah\f2. More information you will find on the website \fPvah-clan.site'
            },
            -- пример 3 таймера сообщения c применением обычной строки
            [3] = {
                -- если название сервера отличается от названий в списке определений серверов то добавте по аналогии
                active = {
                    -- disable отключает таймер в не зависимости от выбранных ниже
                    disable = true,
                    gema = false,
                    ctf = true,
                    lss = true,
                    vs = true
                },
                -- 420000 = 7 минут 7*60*1000
                period = 420000,
                text = '(\f3!\f2) Password for server of \f9G\f2e\f1m\f0A \f2use \f0gemavah\f2.'
            },
            -- пример 4 таймера сообщения c применением обычной строки
            [4] = {
                active = {
                    -- если название сервера отличается от названий в списке определений серверов то добавте по аналогии
                    -- disable отключает таймер в не зависимости от выбранных ниже
                    disable = true,
                    gema = true,
                    ctf = true,
                    lss = true,
                    vs = true
                },
                -- 600000 = 10 минут 10*60*1000
                period = 600000,
                text = '(\f3!!!\f2) If you want a clan \fXVAH\f2, send a message to \f0admin@vah-clan.site'
            },
            [5] = {
                active = {
                    -- если название сервера отличается от названий в списке определений серверов то добавте по аналогии
                    -- disable отключает таймер в не зависимости от выбранных ниже
                    disable = true,
                    gema = true,
                    ctf = true,
                    lss = true,
                    vs = true
                },
                -- 180000 = 3 минут 3*60*1000
                period = 180000,
                text = '(\f3!!!\f2) Server RETURN for pampering. The LUA scripts provided by SDBS. (\f3!!!\f2)'
            },
            [6] = {
                active = {
                    -- если название сервера отличается от названий в списке определений серверов то добавте по аналогии
                    -- disable отключает таймер в не зависимости от выбранных ниже
                    disable = true,
                    gema = true,
                    ctf = true,
                    lss = true,
                    vs = true
                },
                -- 180000 = 4 минут 4*60*1000
                period = 240000,
                text = '(\f3!!!\f2) https://sensor-dream.ru for contact to SDBS. (\f3!!!\f2)'
            },
            [7] = {
                active = {
                    -- если название сервера отличается от названий в списке определений серверов то добавте по аналогии
                    -- disable отключает таймер в не зависимости от выбранных ниже
                    disable = false,
                    gema = true,
                    ctf = true,
                    lss = true,
                    vs = true
                },
                -- 180000 = 2 минут 2*60*1000
                period = 120000,
                text = '(\f3!!!\f2) The server does not throw, except for the worst. Welcome to the free server. (\f3!!!\f2)'
            },
            [8] = {
                active = {
                    -- если название сервера отличается от названий в списке определений серверов то добавте по аналогии
                    -- disable отключает таймер в не зависимости от выбранных ниже
                    disable = true,
                    gema = true,
                    ctf = true,
                    lss = true,
                    vs = true
                },
                -- 180000 = 6 минут 6*60*1000
                period = 360000,
                text = '(\f3!!!\f2) Support for LUA script terminated, to increase opportunities, please contact SDBS. (\f3!!!\f2)'
            },
        },

        log = {
            -- timestam точка отсчета начала учета статистики
            starting_date_of_creation_of_statistics = 1485470116,
            active = true,
            start = {
                active = true,
            },
            stop = {
                active = true,
            },
            player = {
                active = true,
            },
            map = {
                active = true,
            },
        },

        timer_service = {
            -- таймер сервиса c применением функции отправки емайл о работоспособности сервера msmtp должен быть включен и allert_and_send_to.log_visit.active = true
            [1] = {
                active = {
                    -- если название сервера отличается от названия сервера или названий в списке определений серверов то добавте по аналогии
                    -- disable отключает таймер в не зависимости от выбранных ниже
                    disable = false,
                    gema = true,
                    ctf = true,
                    lss = true,
                    vs = true
                },
                -- 1 hour
                -- period = 3600000,
                -- 21600000 = 6 часов 6*60*60*1000
                -- period = 21600000,
                -- 43200000 = 12 часов 12*60*60*1000
                period = 43200000,
                -- 86400000 = 24 часа 24*60*60*1000
                -- period = 86400000,
                -- 172800000 = 48 часов 48*60*60*1000
                --period = 172800000,
                -- 3 min
                --period = 180000,
                -- 5 min
                -- period = 300000,
                -- 10 min
                -- period = 600000,
                fn = function()
                    if  sdbs.cnf.server.msmtp.allert_and_send_to.log_visit.active then
                            sdbs.sv:server_log_visit_to_msmtp()
                    end
                end
            },
            [2] = {
                active = {
                    -- for me
                    -- если название сервера отличается от названия сервера или названий в списке определений серверов то добавте по аналогии
                    -- disable отключает таймер в не зависимости от выбранных ниже
                    disable = false,
                    gema = true,
                    ctf = true,
                    lss = true,
                    vs = true
                },
                -- 1 hour
                -- period = 3600000,
                -- 21600000 = 6 часов 6*60*60*1000
                -- period = 21600000,
                -- 43200000 = 12 часов 12*60*60*1000
                period = 43200000,
                -- 86400000 = 24 часа 24*60*60*1000
                -- period = 86400000,
                -- 172800000 = 48 часов 48*60*60*1000
                --period = 172800000,
                -- 3 min
                -- period = 180000,
                -- 5 min
                -- period = 300000,
                -- 10 min
                -- period = 600000,
                fn = function()
                    if  sdbs.cnf.server.msmtp.allert_and_send_to.log_visit.active then
                            sdbs.sv:server_log_visit_to_msmtp('a@b.c') 
                    end
                end
            },
        },

        -- ДОЛЖЕН БЫТЬ УСТАНОВЛЕН msmtp ПАКЕТ --
        msmtp = {
            -- если не установлен msmtp то обязательно установить в false
            active = true,
            -- расскоментировать и настроить
            -- server = 'smtp.a.b',
            server = 'smtp.mail.ru',
            port = '25', -- 25, 465, 587
            tls = 'on',
            tls_starttls = 'on',  -- on for port 587 or 25 / off for port 465 and 25
            -- расскоментировать и настроить
            -- from также является и логином
            -- from = 'a@b.c',
            from = '',
            -- расскоментировать и неастроить
            -- password = '',
            password = '',
            -- 'Служебное сообщение |VAH|-%s сервера.' or {'Служебное сообщение |VAH|-%s сервера.', ...}
            subject = {
                'Service message @RETURN@-%s servers',
            },
            -- 'Сообщение отправил игрок: %s Почта: %s, IP адрес: %s' or { 'Сообщение отправил игрок: %s Почта: %s, IP адрес: %s', ... }
            sent_by_the_player = {
                'Message sent to player: %s, Email: %s, IP: %s',
            },
            -- 'Message service of server |VAH|-%s:' or {'Message service of server |VAH|-%s:','Message service of server |VAH|-%s:', ..... }
            sent_by_the_server = 'Message service of server @RETURN@-%s:',

            -- отсылать почту при наступлении определенных событий и кому
            allert_and_send_to = {
                -- собирать статистику о игроках и отправлять на емаил
                log_visit = {
                    active = true,
                    -- расскоментировать одно и них и настроить
                    -- to= {'a@w.w'},
                    -- to= 'a@w.w',
                    -- если пустое поле to = {} или to = '' то все работать будет но на емайл отправляться не будет надо будет руками забирать $stoemail
                    to = {
                        'a@w.w', -- образец
                    },
                    -- какой период времени учитывать, в часах
                    time_period = 24,
                    -- вывести N топовых карт
                    top_map = 5,
                    tracking_player = {
                        --'unarmed', -- образец
                        'cast', 
                        'Sveark=MyS=', 
                    },
                    tracking_clan = {
                        --'unarmed', -- образец
                        '|VAH|', 
                    },
                    tracking_implicit = {
                        --'unarmed', -- образец
                        'cast', 
                    },
                },
                create_of_account = {
                    active = true,
                    -- расскоментировать одно и них и настроить
                    -- to= {'a@w.w'},
                    -- to= 'a@w.w',
                    -- если пустое поле to = {} или to = '' то все работать будет но на емайл отправляться не будет надо будет руками забирать $visitemail
                    to = {
                    },
                    text = {
                        'Player %s has registered in the accounting system.\nUsername: %s\nRole: %s\nIdentifier: %s\nEmail: %s',
                    }
                },
                delete_of_account = {
                    active = true,
                    -- расскоментировать одно и них и настроить
                    -- to= {'a@w.w','a@w.w'},
                    -- to= 'a@w.w,a@w.w',
                    -- если пустое поле to = {} или to = '' то все работать будет но на емайл отправляться не будет надо будет руками забирать $visitemail
                    to = {
                    },
                    text = {
                        'Player %s has deleted account from the accounting system.\nUsername: %s\nIdentifier: %s\nEmail: %s',
                    }
                },
                start_server = {
                    active = false,
                    -- расскоментировать одно и них и настроить
                    -- to= {'a@w.w','a@w.w'},
                    -- to= 'a@w.w,a@w.w',
                    -- если пустое поле to = {} или to = '' то все работать будет но на емайл отправляться не будет надо будет руками забирать $visitemail
                    to = {
                    },
                    text = {
                        '\nThe server is started. Date: %s',
                    },
                },
                stop_server = {
                    active = false,
                    -- расскоментировать одно и них и настроить
                    -- to= {'a@w.w','a@w.w'},
                    -- to= 'a@w.w,a@w.w',
                    -- если пустое поле to = {} или to = '' то все работать будет но на емайл отправляться не будет надо будет руками забирать $visitemail
                    to = {
                    },
                    text = {
                        '\nThe server is stopped. Date: %s',
                    },
                },
            },
            text = {
                disable_activate = '(\f3!\f2)Not active utilites.',
                send_email_ok = 'Send email ok.',
                send_email_no = '(\f3!\f2)Send email error.',
                send_email_no_to = 'Send email error to',
                send_email_no_text = 'Send email error text',
            }
        }
    },

    -- TO DO --
    sock = {
        flag = false,
        library = 'socket.core',
    },

    sql = {
        flag = true,
        library = 'luasql.mysql',
        driver = 'mysql',
        -- расскоментировать и настроить
        -- db_name = '',
        db_name = 'sdbs_ac',  
        -- расскоментировать и настроить
        -- user = '',
        user = '',
        -- расскоментировать и настроить
        -- pwd = '',
        pwd = '',
        host = '127.0.0.1',
        port = '3306',
        DELEMITER_0 = ';71e2a3c8abdf;',

        -- проверка на простой запросов к базе данных, если флаг запроса false то закрыть соединение, если нет то установить флаг в false и проверить на следующий цикл, т.е. соединение будет закрыто через [ connection_idle_time x 2 ]
        connection_idle_time = 5000,
        text = {

            user_add = '\f0Player \f1%s\f0, \f3added\f0. Assigned the role of \f3%s',
            user_add_exists = '\f1The player with the name already exists \f3%s',
            user_del = '\f2Player \f1%s\f2, \f3deleted.',
            user_found = '\f2Player \f1%s\f2, \0found.',
            user_not_found = '\f2Player \f1%s\f2, \f0not found.',
            user_blocked = 'Player %s \f2is blocked \f3!!!',
            access_not_permitted = "Access is \f3not permitted \f2Name: \f1%s",
            access_not_valid = "Not valid flag \f3access \f2to \f1%s",
            user_ok_set_update_pwd = '\f0Password successfully changed',
            user_not_set_update_pwd = '\f3Password could not be changed',
            user_ok_set_update_name = '\f0Name successfully changed. New name = \fP%s',
            user_not_set_update_name = '\f3Name \fP%s \f3could not be changed. \f0Name is use.',
            user_ok_set_update_email = '\f0E-MAIL successfully changed. \f2Update \f3%s \f2email \f0of maps.',
            user_not_set_update_email = '\f3E-MAIL could not be changed',
            user_ok_set_update_role = '\f0Role successfully changed',
            user_not_set_update_role = '\f3Role could not be changed',

            atenntion_create_account = "\f3Get yourself an account !!! \nPoor use other people's accounts !!!",
            atenntion_badly = "\f3Poor use other people's accounts !!!",
            atenntion_badly_login = "\f3Player \f0%s \f3checked using someone else's account !!!",

            user_data_gema_not_valid_cn = '\f3Not valid CN',
            user_data_gema_not_valid_id = '(\f3!\f2) Not correctly set the ID: \f3%s',

            user_data_gema_delete_full = '(\f3!\f2) Deleted full statistics for all maps.',
            user_data_gema_delete_one = '(\f3!\f2) Deleted statistics of  maps \f3%s\f2.',
            user_data_gema_deleted_not = '(\f3!\f2) Not deleted statistics.',

        },

        statistic = {
            text = {
                create_map = 'Player \f0%s\f2. Creates statistic of maps \fP%s',
                not_create_map = 'Player \f0%s\f2. Not create statistic of maps \fP%s',
                not_found_data_map_0 = '\f3Not found \f2statistics',
                not_found_data_map_1 = '\f3Not found \f2the statistics for the map, \fP%s\f2, for player \f0%s',
                not_found_data_map_2 = '\f3Not found \f2the statistics for the map of account, \fP%s\f2, for player \f0%s',
            }
        }
    },

    geo = {
        -- активировать загрузку баз
        active = true,
        -- файл весит ~ 1 Mb
        country = true,
        -- файл весит ~ 17Mb
        city = true,
        -- пути к файлам баз GeoIp
        f_country = 'geo/GeoIP.dat',
        f_city = 'geo/GeoLiteCity.dat',
        iso_say = false,
        country_say = true,
        city_say = true,
        text = {
            iso = '%s \f5%s\f2, ',
            country = '%s \f0%s\f2, ',
            city = '%s \fP%s\f2, ',
            iso_unknown = 'ISO',
            country_unknown = 'Country',
            city_unknown = 'Moon',
        }
    },

    say = {
        text = {

            privat_prefix = '\f9Private message from ',
            color = SAY_TEXT,
            color_name_text_delemiter = SAY_GRAY,

            about = '\n\f2INFORMATION\n\t\fPSITE: \f5vah-clan.site\n\t\fPEMAIL: \f5admin@vah-clan.site\n\t\fPIRC: \f5freenode #vah\n\t\fPWIKI: \f5http://wiki.cubers.net/action/view/VAH_clan\n\t\fPFORUM: \f5http://forum.cubers.net/thread-8744.html',
            about_message = '\n\t\fPEnter \f3$help \fPto see a list of commands',
            key_about = SAY_NTAB..'\fPPress \f3F11 \fPto display full information about the clan. Or enter \f0$about\fP, \f0$shell \fPor \f0$help \fPin console.',

            rules_map = '\n\f0RULES: \f2NO CHEATING, NO HAHBIND, NO VOICE',
            rules_map_gema = '\n\f0RULES: \f2NO KILLING, NO CHEATING, NO HAHBIND, NO VOTE, NO VOICE',
            atention_gema = "\f0Attention \f9G\f2e\f1m\f0A ",
            autoteam = '\fPAutoteam is %s ',
            game_mode = '\f9%s \f2game mode. ',
            load_map = "\n\f2Installed \fP%s \f2playground. %s%s%s",
            welcome_name_map = '\n\f0You are to \fP%s \f2map. ',

            connect_welcome = "\f2FOR SERVER OF FRIENDS, WELCOME YOU %s \f2of %s",
            connect_all = "%s \f2CONNECTED FROM %s",
            connect_all_chk_admin ='%s \f2CONNECTED FROM %s \f4IP: \f3%s',

            disconnect_all = "%s \f2HAS LEFT THE SERVER !!!",
            disconnect_reasson = '\f1Reason for leaving: \f3%s\f1.',

            unloading_message = '\f2(\f3!\f2) Unloading Lua initialized - \fP%s',
            reload_message = '\f3Reload \fPLua module is \f0OK\fP. Please enter \f0$login\fP.',

            rename_message = "\f3!!! \f2Player name changes to %s \f3%s",
            not_rename_message = "\f2Player %s \f2tried to change the name on the \f3%s\f2. It is prohibited by the rules.",

            name_same_message = '\f3%s \fP- this name is already used by a player, present here. It is prohibited by the rules.',
            name_old_same_message = '\f3%s \fP- this name is already used by players who are here. It is prohibited by the rules.',

            role_rename_message = "Player \f3%s \f2tried to become an registered. Follow the rules, too use role.",
            role_rename_kick_message = "\f9Registered can not change the name \f3!!! \f9It is prohibited by the rules.",

            role_change_admin_message_1 = "%s \f2has become the administrator of the game. \f3!!!",
            role_change_admin_message_0 = "%s \f2administrator has become a regular player. \f3!!!",

            role_change_me_message_0 = "You have this role \f3%s !!!",
            role_change_me_message_1 = 'You change of \f0%s',

            chk_commands_fix_message = '\f2Invalid command call, Enter the \f3$HELP \f2to view a list of commands available to you.',
            chk_commands_not_alloved_message = '\f3You do not have rights to view.',

        }
    },

    map = {
        -- листы проверки на gema
        list = {
            implicit = { "gemavah", "blue", 'gema' },
            code = { "g", "3e","m", "a@4" }
        },
        -- Автораспределение игроков на картах
        team = {
            auto = {
                --включить таймер автопроверки autoteam
                chk_tmr = true,
                -- проверка раз в 10 секунд
                chk_tmr_time = 10000,
                --на обычных картах
                map = true,
                -- на картах гема
                gema = false
            },
            -- где включать или отключать аутотеам в зависимости от карты gemf или нет
            -- на остальных режимах карт будет отключен
            mode = {
                TDM = true,
                TSURV = true,
                CTF = true,
                TOSOK = true,
                TKTF = true,
            }
        },
        say = {
            -- только при загрузке или перезагрузки карт но не при connect игрока
            -- Сказать какая карта загружена
            load_map = true,
            -- Сказать что это карта гема
            load_map_gema = true,
            -- Сказать какой режим карты
            load_map_mode = true,
            --сказать о состоянии autoteam когда карта загружена
            autoteam = false,
            -- Сказать правила игры при загрузке карты
            rules_map = true,
            -- Сказать правила игры при загрузке обычной карты
            rules_map_normal = true,
            -- Сказать правила игры при загрузке карты GEMA
            rules_map_gema = true
        },
        -- запуск сервера или загрузка карты в режиме master, w
        mode = {

        }
    },

    vote = {
        active = true,
        accept_private_role = {
            -- если ты админ, root или referee, то твой голос решающий, прикольно когда ты referee или root )
            active = true,
            -- кому такая привелегия
            role = {
                [ROOT] = true,
                [REFEREE] = true,
            },
            -- на что распространяется
            type = {
                [KICK] = true,
                [BAN] = true,
                [MAP] = true,
                [AUTOTEAM] =  true,
                [FORCETEAM] =  true,
                [REMBANS] =  true,
                [SHUFFLETEAMS] =  true,
            }
        },
        gema_server = {
            -- если false то только зарегистрированные могут голосовать
            allow = false,
        },
        -- TO DO --
        -- за какие режимы карт можно голосовать на серверах
       --[[ server_one = {
            --TDM DM SURV TSURV CTF PF LSS OSOK TOSOK HTF TKTF KTF
            -- ctf сервер, название должно быть указано в server.name = 'ctf'
            ctf = {
                active = true,
                allow = {
                    ['CTF'] = true,
                    ['TKTF'] = true,
                    ['TOSOK'] = true,
                },
            },
            -- lss сервер, название должно быть указано в server.name = 'lss'
            lss = {
                active = true,
                allow = {
                    ['TKTF'] = true,
                    ['KTF'] = true,
                    ['HTF'] = true,
                }
            },
            -- gema сервер, название должно быть указано в server.name = 'gema'
            gema = {
                active = true,
                allow = {
                    ['CTF'] = true,
                }
            },
            -- vs сервер, название должно быть указано в server.name = 'vs'
            vs = {
                active = true,
                allow = {
                    ['DM'] = true,
                    ['KTF'] = true,
                    ['OSOK'] = true,
                    ['SURV'] = true,
                    ['TSURV'] = true,
                }
            },
        },]]
    },

    flag = {
        drop = {
            -- флаг возращается на место при сбросе флага игроком
            -- если false то на картах не гема работать не будет. добавка чтобы на не гема сервере постоянно  не отключать при реконфигурации модa (
            ignored_is_gema = false,
            reset = true,
            -- сказать об этом
            say_all = true,
            say_me = true,
            text = {
                all = "\fPPlayer %s \fPflag \f3dropped",
                me = '\fPYou flag \f3dropped'
            }
        },
        lost = {
            -- флаг возращается на место при потере флага игроком (при гибели игрока)
            -- если false то на картах не гема работать не будет. добавка чтобы на не гема сервере постоянно  не отключать при реконфигурации модa (
            ignored_is_gema = false,
            reset = true,
            -- сказать об этом
            say_all = true,
            say_me = true,
            text = {
                all = "\fPPlayer %s \f3loses \fPflag",
                me = '\fPYou \f3loses \fPflag'
            }
        },
        steal = {
            -- если false то на картах не гема работать не будет. добавка чтобы на не гема сервере постоянно  не отключать при реконфигурации модa (
            ignored_is_gema = false,
            -- сказать всем что взял флаг
            say_all = true,
            -- сказать мне что взял флаг
            say_me = true,
            text = {
                all = '\f0I took the flag - %s \f0Player \f3!!!',
                me = '\f0You took the flag \f3!!!'
            }
        },
        score = {
            -- если false то на картах не гема работать не будет. добавка чтобы на не гема сервере постоянно  не отключать при реконфигурации модa (
            ignored_is_gema = false,
            -- сказать всем что донес флаг
            say_all = true,
            -- сказать мне что донес флаг
            say_me = true,
            text = {
                all = '\f0Player %s \f0conveyed to the base of the flag \f3!!!',
                me = '\f0You told flag \f3!!!'
            }
        },
        pickup = {
            -- если false то на картах не гема работать не будет. добавка чтобы на не гема сервере постоянно  не отключать при реконфигурации модa (
            ignored_is_gema = false,
            -- сказать всем что поднял флаг
            say_all = false,
            -- сказать мне что поднял флаг
            say_me = false,
            text = {
                all = '%s \f0player raised the flag \f3!!!',
                me = '\f0You raised the flag \f3!!!'
            }
        }
    },

    gameplay = {
        weapon = {
            -- автоматически ставить пулемет при заходе на гема при логине конесно или старте гема карты если ты залогинен )))
            set_pulemete = true,
        },
        statistic = {
            -- сказать мне статистику при смене карты на новую
            info_change_map_say_me = true,
            -- сказать мне время прохода карты
            score_time_say_me = true,
            -- сказать мне лучшее текущее время прохода карты
            core_time_current_best_say_me = true,
            -- сказать мне предидущее время прохода карты
            score_time_old_say_me = true,
            -- сказать мне предидущее лучшее время прохода карты
            score_time_best_old_say_me = true,
            -- сказать всем мое время прохода карты
            score_time_say_all = true,
            -- сказать всем сколько прошел карт
            score_map_coount_say_all = true,

            text = {
                score_time_me = '\f3Score of time: \f0%s',
                score_time_current_best_me = '\f2Best of time: \f3%s',
                score_time_old_me = '\f2The last score of time: \fP%s',
                score_time_best_me = '\fPYour the best time on the map: \f0%s',
                score_time_best_old_me = '\f2The last best time on the map: \fP%s',
                score_time_all = '\fP(\f3!\fP) \fPPlayer %s \fP, was a map of \f0%s',
                score_map_all = '\fPScore of maps: \f3%s/%s\fP, \f3%s\f0%s.',
                info_change_map_say_me = '\f0Visits maps: \f3%s\f0. Current time: \f3%s\f0. Best time: \f3%s\f0. Count score: \f3%s\f0.',
                info_position_list_best_time = '\f0Position in list at the best time: \f3%s',
                info_visits_gema = '\f0Visits: \f3%s\f0. Score of maps \f9G\f2e\f1m\f0A: \f3%s/%s\f0, \f3%s\f0%s.',
                info_visits_normal = '\f0Visits: \f3%s\f0.',
            }
        }

    },

    shell = {

        -- сделать каждую буковку своим цветом в команде если она отмечена как важная в shell модуле посиция protected 8
        accent_command_colorize = true,
        -- количество вывода комманд чтоб не обрезались при выводе, если 12 то в 1 строке вывода 12 комманд и так далее
        count_command_in_one_string = 10,

        play = {
            text = {
                help = 'Start play music. \f1Format: \f0$play\f2.'
            }
        },

        kick = {
            -- сказать всем что игрок выкинут и кем
            all_say = true,
            -- DISC -- EOP, CN, MKICK, MBAN, TAGT, BANREFUSE, WRONGPW, SOPLOGINFAIL, MAXCLIENTS, MASTERMODE, AUTOKICK, AUTOBAN, DUP, BADNICK, OVERFLOW, ABUSE, AFK, FFIRE, CHEAT
            reasson = 'AUTOKICK',
            text = {
                help = 'Throws a player from the server. \f1Format\f2: \f0$kisk <CN> <FLAG or MESSAGE>\f2. \f0<Flag or MESSAGE> \f2is not necessarily. If \f0<FLAG == 0 > \f2the message will not show who threw, if \f0<FLAG == 1 > \f2is not dependent on whether this option is in the configuration',
                all_message = '\f3%s \f2player, throw-looking \f0%s\f2, with the repeated warnings and violations. \f1%s',
                no_user = 'This user has no \f3!!!',
                ok = 'This player \f3%s \f2kicked \f3!!!',
            }
        },

        ban = {
            -- сказать всем что игрок забанен и кем
            all_say = true,
            -- DISC -- EOP, CN, MKICK, MBAN, TAGT, BANREFUSE, WRONGPW, SOPLOGINFAIL, MAXCLIENTS, MASTERMODE, AUTOKICK, AUTOBAN, DUP, BADNICK, OVERFLOW, ABUSE, AFK, FFIRE, CHEAT
            reasson = 'AUTOBAN',
            text = {
                help = 'Throws a player from the server. \f1Format\f2: \f0$mapban <CN> <FLAG or MESSAGE>\f2. \f0<Flag or MESSAGE> \f2is not necessarily. If \f0<FLAG == 0 > \f2the message will not show who threw, if \f0<FLAG == 1 > \f2is not dependent on whether this option is in the configuration. \f1Format\f2: \f0$ban -r \f2for reset ban list for current maps.',
                all_message = '\f3%s \f2player, ban-looking \f0%s\f2, with the repeated warnings and violations. \f1%s',
                no_user = 'This player has no \f3!!!',
                ok = 'This player \f3%s \f2bannned \f3!!!',
                reset = 'Ban list of current maps is reset \f3!!!',
            }
        },

        go = {
            text = {
                help = 'Start passage map. \f0Atention\f2: \f3auto spawn\f2. \f1Format: \f0$go\f2 spawn and run timer, \f0$go -e \f2to set a constant flag message display say time and run, \f0$go -d \f2to set a constant flag message no display say time and run.',
                not_access = '\f3Player %s \f3limited rights at the moment, for violation of the rules.',
                not_gema = "\fPAttention \f3!!! \fPNot \f9G\f2e\f1m\f0A \fPmap.",
                not_ctf = "\fPAttention \f3!!! \fPNot \f3CTF \fPmode map.",
                set_flag_enable = 'The flag \f1is set \f2the message display time.',
                set_flag_disable = '\f3Cleared \f2flag message display time.',
            }
        },

        stopwatch = {
            -- разрешить использование  секундомера проверки времени прохождения карты. Этот ключ используется как для собственного контроля , так и для заноса времени в систему учета. так что лучше не отключать, хотя он включится при начале прохождении карты через $go. Но напрямую если он не включен то работать не будет
            enable = true,
            --показ времени секундомера прохождения карты через интервал
            period = 3000,
            -- показывать сообщение сколько времени прошло при активации секундомера через period времени, можно отключить потом можно активировать $stopwatch -s $stopwatch -e или дезактивировать $stopwatch -d , если не активно то tmr не создается при активации секундомера
            period_say = false,
            -- сказать мне что секундометр принудительно выключен
            not_enable_say = true,
            -- сказать мне что секундомер на данный момент не активен для периодического отображения времени
            say_not_active = true,
            -- сказать мне что включен секундомер
            active_say = true,
            -- сказать мне что выключен секундомер
            not_active_say = true,
            -- сказать мне контрольное время секундомера
            difftime_say = true,
            -- сказать всем контрольное время секундомера прохождения карты
            difftime_map_say_all = true,

            -- сказать что включено периодическое отображение времени
            say_enable = true,
            -- сказать что выключено периодическое отображение времени
            say_disable = true,

            text = {
                help_0 = 'Stopwatch map aisle. \f0Format\f2: \f1$stopwatch \f2or \f1$sw \f2activate or desactivate, \f1$stopwatch -s \f2or \f1$sw -s \f2enable or disable say time message, \f1$stopwatch -t <SECONDS>  \f2or \f1$sw -t  <SECONDS> \f2set period stopwatch say time message,',
                help_1 = '\f1$stopwatch -e \f2or \f1$sw -e \f2to set a constant flag message display say time and run, if not active, \f1$stopwatch -d \f2or \f1$sw -d \f2to set a constant flag message no display say time and stop stopwatch.',
                set_flag_enable = 'The flag \f1is set \f2the message display time.',
                set_flag_disable = '\f3Cleared \f2flag message display time.',
                not_enable = '\f3Stopwatch forced off',
                not_active = '\f3!!! \f1The stopwatch is not active \f3!!!',
                not_access = '\f3Player %s \f3limited rights at the moment, for violation of the rules.',
                enable = 'Stopwatch is \f0activated',
                already_active = '\f1(\f3!\f1) \f2Stopwatch is already active',
                disable = 'The stopwatch is \f3deactivated',
                difftime = '\f3Passage of time - \f0%s',
                say_enable = 'Show time \f0ON',
                say_disable = 'Show time \f3OFF',
                set_period = 'Set period time = \f0%s',
                message_0 = 'Elapsed time: \f0%s',
            }
        },

        su = {
            -- сказать text.login_attention
            login_atention = true,
            --Разрешить мультилогин
            multiple_login = true, -- пока не включать
            -- сказать дополнительную информациию по карте на которой залогинился ?
            login_gema_ext = true,
            text = {
                help = 'Authorization player different from the player name login. \f1Format: \f0$su <NAME or CN of Player name> <PASSWD> \f2or \f0$su \f2Logout Player of the system account.',
                error_valid = 'Authorization failed \f3!!!',
                error_empty_pwd = 'Empty PASSWORD \f3!!!',

                login_atention = 'Enter the \f1$shell \f2to view the available commands. \f3Attention\f2, including statistics.',
                empty_email = 'Please enter \f3email address\f2. Please see \f0$email -h\f2.',
                already_role = "You are already in the role of \f3%s !!!",
                ATENTION_ADMIN_0 = '\f3For you, the user is created, with the rights of root. Set a password. Log in as the server administrator is not recommended. Come on your user with your password.',
                ATENTION_ADMIN_1 = '\f3You already are registered, change the password or enter with your Account. To come as the server administrator is not recommended.',
                multiple_login = '\f3Attempt \f2user authentication \fP%s\f2. Account \fP%s\f2. \f3Multiple login denied\f2. \nYou`re already logged in \fP%s\f2,, \f2IP: \f3%s\f2 server: \f3%s\f2.',
                error_use_login = 'Ups logout from player %s. \f2Error: \f3%s\f2.',
            }
        },

        map = {
            statistic_limit_out = 3,
            -- показать в выводе общей статистики по карте или картам
            top_best_current_time_say = true,
            top_best_score_say = true,
            top_best_visits_say = true,

            text = {
                help = 'Commands for maps. Use \f0$map <ARG>\f2, \f0$map <ARG> -h or <ARG>h \f2for help.\n\f0List arguments: \fP-top\f0, \fP-i\f0, \fP-nri\f0, \fP-pri\f0, \fP-nr\f0, \fP-pr\f0, \fP-t\f0, \fP-c\f0, \fP-cr\f0, \fP-cg\f0, \fP-crg\f0, \fP-d\f0.',
                time_help = 'System time of server. \f3Acces for role > DEFAULT\f2. \f1Format: \f0$map -t <MINUTE> or $maptime <MINUTE>. \f10 <= MINUTE <= 60',
                time_new = 'Established a time \f9maps \f2= \f0%g',
                time_current = 'Current a time \f9maps \f2= \f0%g',
                count_help = 'Current count maps of server. \f1Format: \f0$map -c\f2.',
                count_text = 'Current count maps of server: \fP%s.',
                count_rot_help = 'Current count maps rotator. \f1Format: \f0$map -cr\f2.',
                count_rot_text = 'Current count maps rotator: \fP%s\f2.',
                count_gema_help = 'Current count \f9G\f2e\f1m\f0A \f2maps of server. \f1Format: \f0$map -cg\f2.',
                count_gema_text = 'Current count \f9G\f2e\f1m\f0A \f2maps of server: \fP%s\f2.',
                count_rot_gema_help = 'Current count \f9G\f2e\f1m\f0A \f2maps rotator. \f1Format: \f0$map -crg\f2.',
                count_rot_gema_text = 'Current count \f9G\f2e\f1m\f0A \f2maps rotator: \fP%s\f2.',

                next_help = 'The choice of the next maps rotator. \f1Format: \f0$infonextmap \f2or \f0$nextmap -i \f2or \f0$map -nri\f2. \f3Acces for role > REGISTERED\f2. \f0$map -nr \f2or \f0$nextmap',
                prev_help = 'The choice of the previous maps rotator. \f1Format: \f0$infoprevmap \f2or \f0$prevmap -i\f2 or \f0$map -pri\f2. \f3Acces for role > REGISTERED\f2. \f0$map -pr or $prevmap',

                info_help_0 = 'Statistics. \f1Format: \f0$mapinfo \f2or \f0$map -i \f2or \f0$mapinfo [<CN> or <PLAYER>] \f2or \f0$map -i [<CN> or <PLAYER>]\f2.',
                info_help_1 = '\f3Delete \f2statistics for current map. \f1Format: \f0$mapinfo -d \f2or \f0$map -d\f2. If \f1Format: \f0$mapinfo -d -all \f2or \f0$map -d -all\f2, delete \f3all \2statistics of maps.',

                delete_help = '\f3Delete \f2statistics for current map. \f1Format: \f0$mapinfodel \f2or \f0$map -d\f2. If \f1Format: \f0$mapinfodel -all \f2or \f0$map -d -all\f2, delete \f3all \2statistics of maps.',

                map_info = 'The %s map \fP%s\f2, \f0%s \f2mode , the time \f5%s\f2.',

                map_info_not_statistic = '\f3Not found \f2statistics',

                access_not_permited = '\f3Access not permitted.',
                not_access = '\f3Player %s \f3limited rights at the moment, for violation of the rules.',
                not_gema = "\fPAttention \f3!!! \fPNot \f9G\f2e\f1m\f0A \fPmap.",
                not_ctf = "\fPAttention \f3!!! \fPNot \f3CTF \fPmode map.",
                no_valid_cn = "NO VALID CN = \f3%s !!!",
                no_valid_name = "NO VALID NAME = \f3%s !!!",

                top_best_help = 'Statistics best time on current of map. \fPFormat: \f0$maptop  \f2or \f0$map -top -best \f2, or  \fPFormat: \f0$maptop <NUMBER>  \f2or \f0$map -top -best <NUMBER>\f2, where \f3<NUMBER> \f2is the number of players in the list. Default <NUMBER = \f3%s\f2>',
                top_gbest_help = 'Global statistics best time on all maps servers. \fPFormat: \f0$gmaptop  \f2or \f0$map -top -gbest \f2, or  \fPFormat: \f0$gmaptop <NUMBER>  \f2or \f0$map -top -gbest <NUMBER>\f2, where \f3<NUMBER> \f2is the number of players in the list. Default <NUMBER = \f3%s\f2>',

                top_best_text = '\f0Player: \f3%s \f0Best: \f3%s',
                top_best_text_cureent_time = '\f0, Current: \f3%s',
                top_best_text_score = '\f0, Score: \f3%s',
                top_best_text_visits = '\f0, Visits: \f3%s',
            },
        },

        whois = {
            include_geo = true,
            country = true,
            iso = true,
            city = true,
            ip = true,
            hidden4octet = true,
            text = {
                help = 'Information about the player. \fPFormat\f2: \f0$whois <CN>\f2, where \f0<CN> \f2is the number of the player on the server.',
                not_player = '(\f3!\f2) The player number was \f3not found\f2.',
                info = 'Information about the player - %s\f2.',
                ip = 'IP\f2:\f3',
                country = 'Country\f2:\f0',
                iso = 'ISO\f2:\f1',
                city = 'City\f2:\f9'
            }
        },

        sudo = {
            text = {
                help_0 = 'Delegation roles. \f1Format\f2: \f0$sudo <CN \f2or \f0PLAYERNAME> [<FLAG>]\f2. <FLAG> = [<admin or ad or '..(tostring(CR_ADMIN))..'>, <root or rot or '..(tostring(CR_ROOT))..'>, <referee or ref or '..(tostring(CR_REFEREE))..'>, <registered or reg or '..(tostring(CR_REGISTERED))..'>, <default or def or '..(tostring(CR_DEFAULT))..' \f3If login the Player, then auto logout.\f2>].',
                help_1 = 'If not \f3<FLAG> \f2then delegation your role. \f3If you admin\f2, \f3your role disabled\f2. If \f0$sudo -i \f2for changed admin role if you as the root. \f0$sudo -p <ADMINPASSWD> \f2for change admin role.',
                already_role = "You are already in the role of \f3%s !!!",
                no_valid_role = 'You specified the \f3wrong role \f2to delegate access level.',
                no_valid_cn = "NO VALID CN = \f3%s !!!",
                no_valid_name = "NO VALID NAME = \f3%s !!!",
                no_valid_pwd = "No valid \f3PASSWORD \f2!!!",
                empty_pwd = "Empty \f3PASSWORD \f2!!!",
                block_access = 'Player \f3%s \f2limited rights at the moment, for violation of the rules.',
                no_root = 'This command is available only for player with \f3root privilege !!!',
                error_delegate_1 = 'Your role is \f3not a priority \f2than \f0%s \f2of the player.',
                delegate_ok = 'You assign role \f0%s \f2for %s \f2installed and checked.',
                delegate_already_role = 'Player %s \f2already uses role \f0%s\f2.',
            }
        },

        uuid = {
            text = {
                help = 'UUID utilites. \fPFormat\f2: \f0$infouuid\f2, for role \f3> \f2referee, \f0$uuid \f2or \f0$uuid <ARGS>\f2. \fPARGS\f2: \f0<CN>\f2, \f0<ACCOUNTNAME>\f2, \f0-empty\f2, \f0-regen \fPall \f2or \f0-regen \fP<CN> \f2or \f0-regen \fP<ACCOUNTNAME>\f2.',
                user_util_chk_empty = 'Check the UUID for the users is successful. \f3%s \f2generated uuid. Update uuid count of maps: \f3%s\f2.',
                user_util_regen = 'Generate uuid for player \f3%s \f2complete. \f0UUID\f2: \fP%s\f2. Update uuid count of maps: \f3%s\f2.',
                user_util_err = 'ERROR: %s',
                your = 'Your uuid: \f0%s\f2.',
                player_uuid = 'Player: \f3%s\f2, uuid: \fP%s',
                not_cn = 'CN: \f3%x \f2not found',
                not_player = 'Player: \f3%s\f2 not found',
                player_uuid_empty = 'Player: \f3%s\f2, uuid is \f3empty',
            }
        },

        email = {
            text = {
                help = 'Shows your e-mail account or change NEW E-MAIL player  account. \f1Format\f2: \f0$email  \f2or \f0$email -c <NEWEMAIL> \f2or  \f0$email -u <NEWEMAIL> for update account (\f3not updtae email in maps statistic !!!\f2) \f2or \f0$email -d \f2 for \f3DELETE \f2email.',
                empty = 'Do you have an \f3empty\f2 e-mail.',
                your = 'Your e-mail: \f0%s\f2.',
            }
        },

        text = {

            role = {
                [CR_DEFAULT] = '\f0normal player',
                [CR_ADMIN] = '\f0It provides for the right to be a god.',
                [CR_REGISTERED] = '\f0It provides additional features. Accounting for the passage of time, eg.',
                [CR_REFEREE] = '\f0It provides advanced process control capabilities of the game.',
                [CR_ROOT] = '\f0full rights to the server.'
            },
            role_help = 'Information about your access to the server, \fPFormat\f2: \f0$role \f2. If your role > REGIDTERED then you can view the roles of other players. \fPFormat\f2: \f0$role <CN> \f2.',
            role_text = 'Your role presently - \f0%s',
            role_for_cn_text = 'Role for CN: %s - \f0%s',
            role_error_cn = '\f3Error \f2CN: \f3%s',
            role_not_access = 'Access is \f3not permitted',

            about_help = '\f1Summary Clan of Frends',

            shell_error = 'Invalid command call, Enter the \f3 $%s -h \f2for reference.',
            not_help = 'NO HELP',

            help_text = '\fPTo display a list of commands, depending of type of access level, type \f0$shell \fPconsole. For more information on individual commands, enter \f0$<command> -h \fPor \f2https://github.com/sensor-dream/luamod/wiki/aCmOdFoRvAh\fP.',
            shell_help = '\f1It displays a list of available commands',
            shell_text = '\fPFor more information on individual commands, enter \f0$<command> -h',

            version_help_0 = '\f1Name: \f5%s\fP, \f1Author: \f0%s\fP, \f1Version: \f5%s\fP.',
            version_help_1 = '\fPSite: \f2%s\fP, \fPEmail: \f2%s\fP.\n\fPDescription: \f3%s\fP.',
            version_help_2 = '\fPCount shell commands. All: \f2%s\fP, \fPShow: \f0%s\fP, \fPHidden: \f3%s\fP.',

            pm_help = "\fPPrivat message. \f2Format: \f0$pm <CN> <TEXT>",
            pm_error_cn = '\fPThis user has no \f3!!!',


            lock_help = 'Blocking input to the server. He works as a switch. There are 2 options. -h <HELP> and -s <STATUS>. Other prametry not required.',
            lock_text_0 = '\f1Server \f3locked',
            lock_text_1 = '\f1Server \f0unlocked',

            useradd_help = 'Adding Player. \f1Format\f2: \f0$useradd <NAME> [<FLAG>] <PASSWORD> <EMAIL>\f2. <FLAG> = [<root or rot or '..(tostring(CR_ROOT))..'>, <referee or ref or '..(tostring(CR_REFEREE))..'>, <registered or reg or '..(tostring(CR_REGISTERED))..'>]',
            useradd_to_login = '\f0Now you can log into your account \f1$login %s\f0. Be sure to change your password, \f3$passwd <newpassword> \f0.',
            useradd_error_email = '(\f3!\f2) Wrong email - \f3%s',

            userdel_help = 'Remove a player. \f1Format\f2: \f0$userdel <NAME>\f2.',

            usermod_help = 'Modification of Player. \f1Format\f2: \f0$usermod <NAME> \f2[\f0-n <NEWNAME> or -p <NEWPASSWORD> or -r <NEWROLE> or -e <EMAIL>\f2]\f0. \f3<NEWROLE> = [<root or rot or '..(tostring(CR_ROOT))..'>, <referee or ref or '..(tostring(CR_REFEREE))..'>, <registered or reg or '..(tostring(CR_REGISTERED))..'>]',

            login_help = 'Authorization player with the same name in the game and in the accounting system. \f1Format\f2: \f0$login <PASSWORD>\f2.',

            logout_help = 'Logout Player of the system account. \f1Format\f2: \f0$logout\f2.',

            exit_help = 'If login use, then auto logout Player of the system account,  and quit game. \f1Format\f2: \f0$exit\f2.',

            reg_help = 'Registration Player in the system account. \f1Format\f2: \f0$reg <PASSWORD> <EMAIL>\f2. <EMAIL> = The control email to restore the account, if not specified, the administrator than not be able to help, but to delete the account.',
            reg_error = '\f3Multiple registration of users from a single playing session is forbidden server rules.',
            reg_error_email = 'Please enter \f3email address\f2. Please see \f0$reg -h\f2.',

            unreg_message = '(\f3!\f2) Please enter \f0$unreg -h \f2or \f0$unregistry -h \f2for help delete account. \f3 Attention, removed and statistics\f2.',
            unregistry_help = 'Removing the player from the accounting system. \f1Format\f2: \f0$unregistry \f2. (\f3!!!\f2) \f3Removing full statistic of player\f2.',
            --' (\f3!!!\f2) \f0If you want to save the statistics\f2, that - \f1Format\f2: \f0$unregistry -s \f2.',
            unregistry_not_permit_change = '\f3No right to delete your account',

            passwd_help = 'Change NEWPASSWORD player account. \f1Format\f2: \f0$passwd <NEWPASSWD>\f2.',

            rename_help = 'Change NEWNAME player account. \f1Format\f2: \f0$rename <NEWNAME>\f2.',

            assign_help = 'Assign a role to another player. \f1Format\f2: \f0$assign <CN>\f2. \f3If you admin, your role disabled\f2.',
            access_help = 'Allows access  unregistered player to the gameplay. \f1Format\f2: \f0$access <CN>\f2.',

            demo_help_0 = '\fPView or set flag download demo file game player. \f2Format\fP: \f0$demo -s \fPshows the status of the flag demo. \f2Format\fP: \f0$demo -on \fPenable download demo. \f2Format: \f0$demo -off \fPdisable download demo.',
            -- demo_help_1 = '\f2Format\fP: \f0$demo \fPswitch to allow or deny, depending on the prohibited or permitted.',
            demo_allowed = 'The downloading of the file is \f0allowed\f2.',
            demo_not_allowed = 'The downloading of file is \f3prohibited\f2.',

            sendmail_help = 'Send messages to the e-mail. \f0Fornat: $sendmail <EMAILADDRESS> <TEXT>',
            sendmail_no_valid = '(\f3!\f2) No valid email \f3%s',

            stoemail_help_0 = 'Sending statistics to the server specified in the account email. \fPFormat\f2: \f0$stoemail \f2or \f0$stoemail <STARTTIME> <PERIOD>\f2. \fPExample\f2: \f0$stoemail \f31 \f10.5 \f2beginning from the current time one hour, for a period equal to half an hour.',
            stoemail_help_1 = 'If typed in command \f0$stoemail \f2without parameters or \f0$stoemail <STARTTIME>\f2, then the period is equal to the moment \f3%s \f2hours.',
            stoemail_text = '\f3See mail\f2: \f0%s',

            mod_help = '\f3Commands for Lua module. \fPFormat: \f0$mod -reload \f2for reload Lua module, \f0$mod -load \f2for load Lua module, \f0$mod -unload \f2for unload Lua module',


        }

    },

    cn = {
        -- использовать расщирение имени когда он что то сообщает кому то или всем
        connect_set_cn_name = true,
        -- format имени игрока когда он что то сообщает кому то или всем
        connect_set_cn_name_format = '(%s) %s%s: ',
        connect_set_default_name_format = '%s%s: ',
        -- у каждого игрока свой цвет имени на весь connect
        connect_set_color_name = true,
        connect_set_colorize_char_name = false,
        -- говорить о бо мне если что
        connect_say = true,
        -- поприветствовать меня
        connect_say_me = true,
        -- сказать всем что я зашел
        connect_say_all = true,
        -- сказать мне абоут
        connect_say_about = true,

        -- только при соннекте игрока при загрузке карт следующих не действуют
        -- Сказать правила игры при загрузке карты
        connect_say_rules_map = true,
        -- Сказать правила игры при загрузке карты GEMA
        connect_say_rules_map_gema = true,
        -- Сказать правила игры при загрузке обычной карты
        connect_say_rules_map_normal = true,
        -- Сказать какая карта загружена
        connect_say_load_map = true,
        -- Сказать что это карта гема
        connect_say_load_map_gema = true,
        --сказать о состоянии autoteam когда карта загружена
        connect_say_autoteam = false,
        -- Сказать какой режим карты
        connect_say_load_map_mode =true,

        -- задержка вывода сообщений при коннекте
        connect_posts_delay = true,
        connect_posts_delay_time  = 1000,

        -- сказать всем чтоя ухожу
        disconnect_say = true,
        -- сказать код выхода
        disconnect_reasson_say = true,
        -- сказать причину выхода если есть
        disconnect_say_message = true,
        -- сказать что сервер перезагружается
        reboot_message_say = true,

        -- разрешить периименование
        rename = true,
        -- сообщить об этом всем
        rename_say = true,
        -- сказать всем что запрещено переименование
        not_rename_say = true,

        -- запретить или разрешить переименование пользователю если он в роли
        -- не включать , возможность смены пароля и удаления другого пользователя
        change_role = false,
        -- сказать всем зарегистрированный юзер нарушил правила но не выкидывая его
        change_role_say = true,
        -- выкинуть зарегистрированного узера при перименовании если он в роли
        change_role_kick = false,
        -- сказать об этом всем что его выкинули
        change_role_kick_say = true,

        -- следить за сменой имени узера, пока он зарегестрированный и убрать привилегию
        -- не отключать , возможность смены пароля и удаления другого пользователя
        rename_chk_role = true,
        -- сообщить что ты не можеш сменить роль, т.к. нарушил правила
        rename_chk_role_say = true,

        -- сказать мне какая у меня теперь роль
        role_change_me_say = true,
        -- сказать всем что админ сменил роль
        role_change_admin_say = true,

        --разрешить одинаковые имена
        name_same = false,
        -- сказать что обнаружены и будут наказаны
        name_same_say = true,
        --разрешить одинаковые имена уже бывшие во время игры у присутствующих игроков
        name_old_same = false,
        -- сказать всем про это
        name_old_same_say = true,

    }

}
