return {

    library = nil,
    driver = nil,
    db = nil,
    -- флаг активации таймера проверки
    tmr_connection_idle_time = false,
    -- флаг активности запросов к базе
    flag_query = false,

    init = function(self,obj)
        self.parent = obj
        if self.parent.cnf.sql.flag then
            -- self.driver = include(self.parent.cnf.sql.driver)
            self.parent.log:w('Load ... library MYSQL '..self.parent.cnf.sql.library)
            local callResult, result = pcall(require, self.parent.cnf.sql.library)
            if callResult then
                self.parent.sql.library = result
                self.parent.log:w('Load library MYSQL '..self.parent.cnf.sql.library..' complete')
                if self:init_driver() then
                    if self:c_db() then
                        self:d_db()
                    end
                end
            else
                self.parent.log:w(result)
            end
            self.parent.log:w("Activate driver "..self.parent.cnf.sql.driver)

        else
            self.parent.log:w('Not active driver '..self.parent.cnf.sql.driver..'. Disabled. ')
        end
    end,

    connection_idle_time = function()
        if sdbs.sql.flag_query then
            -- флаг активности запросов к базе
            sdbs.sql.flag_query = false
            sdbs.log:i('MYSQL TMR set flag flag_query = false')
        else
            sdbs.sql.d_db(sdbs.sql)
        end

    end,

    tmr_create_connection_idle_time = function(self)
        if not self.tmr_connection_idle_time then
            tmr.create(TMR_MYSQL_CONNECTOR,self.parent.cnf.sql.connection_idle_time,self.connection_idle_time)
            -- флаг активации таймера проверки
            self.tmr_connection_idle_time = true
            self.parent.log:i('MYSQL TMR CREATE connection_idle_time')
        end
    end,

    tmr_remove_connection_idle_time = function(self)
        if self.tmr_connection_idle_time then
            tmr.remove(TMR_MYSQL_CONNECTOR)
            -- флаг активации таймера проверки
            self.tmr_connection_idle_time = false
            self.parent.log:i('MYSQL TMR REMOVE connection_idle_time')
        end
    end,

    c_db = function(self)
        if type(self.db) ~= 'userdata' and self.driver then
            self.db = assert(self.driver:connect(self.parent.cnf.sql.db_name, self.parent.cnf.sql.user, self.parent.cnf.sql.pwd, self.parent.cnf.host, self.parent.cnf.sql.port))
            if self.db then self.parent.log:w('Connect db OK. DB: '..self.parent.cnf.sql.db_name)
                self:tmr_remove_connection_idle_time()
                self:tmr_create_connection_idle_time()
                return true
            end
        else
            self.parent.log:w('Connection already established '..self.parent.cnf.sql.db_name) return true
        end
        self.parent.log:w('Connect db NO. DB: '..self.parent.cnf.sql.db_name) return false
    end,

    d_db = function(self)
        if type(self.db) == 'userdata' then
            self.db:close()
            self.db = nil
            self.parent.log:w('Close connect db OK. DB: '..self.parent.cnf.sql.db_name)
            self:tmr_remove_connection_idle_time()
            return true
        end
        self.parent.log:w('Close connect db ERROR. Not connect. DB: '..self.parent.cnf.sql.db_name)
    end,

    init_driver = function(self)
        if self.driver == nil then
            self.driver = assert(self.library[self.parent.cnf.sql.driver]())
            if self.driver then self.parent.log:w('Init driver '..self.parent.cnf.sql.driver..' complete') return true end
        end
        self.parent.log:w('Init driver '..self.parent.cnf.sql.driver..' error') return false
    end,

    close_driver = function(self)
        if type(self.driver) == 'userdata' then
            self.driver:close()
            self.driver = nil
            self.parent.log:w('Close driver '..self.parent.cnf.sql.driver..' complete') return true
        end
        self.parent.log:w('Close driver '..self.parent.cnf.sql.driver..' error') return false
    end,

    destroy = function(self)
        self:d_db()
        self:close_driver()
        --self.library = nil
        self.parent.log:w("Deactivate driver MYSQL ")
    end,

    query = function(self,data)
        if type(self.driver) ~= 'userdata' then self.parent.log:w("No activate driver MYSQL ") return false end
        if not self:c_db() then return false end
        -- флаг активности запросов к базе
        if not self.flag_query then self.flag_query = true end
        return pcall(assert,self.db:execute(data))
    end,

    chk_user = function(self, name)
        self.parent.log:i(string.format("Find player name: %s in DB.", name))
        local f, c =  self:query(string.format('SELECT `name`,`uuid`,`email` FROM `user` WHERE BINARY `user`.`name` = \'%s\'', name ))
        if f then
            local r = c:fetch({})
            c:close()
            if r ~= nil then
                self.parent.log:i(string.format("Player FOUND. Name: %s", name))
                return  true, string.format(self.parent.cnf.sql.text.user_found,name), r[2],r[3]
            else
                self.parent.log:w(string.format("Player NOT FOUND. Name: %s", name))
                return  false, string.format(self.parent.cnf.sql.text.user_not_found,name)
            end
        else
            return false, self.parent.log:e(c)
        end
    end,

    uuid_user_util = function(self, search, flag )
        self.parent.log:i("Check UUID utilites from user ..")

        local f, c, reg = false,nil,false

        if self.parent.fn:isstr(search) then
            reg = true
            f, c =  self:query(string.format('SELECT `name`, `uuid` FROM `user` WHERE BINARY `user`.`name` = \'%s\'',search))
            if flag ~= nil and flag == false then
                if f then
                    local r = c:fetch({})
                    c:close()
                    if r ~= nil then
                        if r[2] == '' then
                            return true, 1, NOT_GENERATE, search
                        end
                        return true, 1, r[2], search
                    else
                        self.parent.log:e(string.format("UUID utilites. Player NOT found. Name: %s", search))
                        return false, 0, NOT_GENERATE, search
                    end
                else
                    self.parent.log:e(c)
                    return false, c, NOT_GENERATE, search
                end
            end
        else
            if self.parent.fn:isbool(search) and search == true  then reg = true end
            f, c =  self:query('SELECT `name`, `uuid` FROM `user`')
        end
        if f then
            local r,count_update,count_map_update_one_uuid,count_map_update,uuid,cn = c:fetch({}),0,0,0, '',nil
            while r do
                if r[2] == '' or reg then
                    uuid = self.parent.fn:uuid()
                    name = r[1]
                    ff, cc = self:query(string.format('UPDATE `user` SET `user`.`uuid` = \'%s\' WHERE BINARY `user`.`name` = \'%s\';', uuid, name ) )
                    if ff then
                        count_update = count_update + 1
                        self.parent.cn:use_uuid(self.parent.cn:get_cn(name),uuid)
                        ff, count_map_update_one_uuid = self:u_uuid_user_data_gema(r[2],uuid,true)
                        count_map_update = count_map_update + count_map_update_one_uuid
                        self.parent.log:w(string.format("Update UUID ok from user: %s, uuid: %s, Map count UPDATE",name,uuid,count_map_update))
                    else
                        self.parent.log:e(string.format("Update UUID no from user: %s, ERROR: %s",name,cc))
                    end
                end
                r = c:fetch(r)
            end
            c:close()
            if count_update == 1 then
                return true, count_update, uuid, name, count_map_update
            else
                return true, count_update, NOT_GENERATE,NOT_GENERATE, count_map_update
            end

        else
            if c~= nil then self.parent.log:e(tostring(c)) end
            return false, c
        end
    end,

    logout = function(self,name)
        --if self:chk_user(name) then
        self.parent.log:i(string.format("Find use account: %s for logout", name))
        local f, c =  self:query(string.format('SELECT `active` FROM `user` WHERE BINARY `user`.`name` = \'%s\'', name ))
        if f then
            local r = c:fetch ({},'a')
            c:close()
            if r ~= nil then
                if tonumber(r.active) > 0 then
                    self:query(string.format('UPDATE `user` SET `user`.`date_logout`= now(), `user`.`active` = %s WHERE BINARY `user`.`name` = \'%s\';', 0, name ) )
                    self.parent.log:i("Update timestamp  LOGOUT OK") return true, 'Update timestamp ok'
                end
                self.parent.log:i("User "..name.." not active") return true
            end
        end
        self.parent.log:e(string.format("Find use account for update timestamp LOGOUT NO, ERR: %s", c))
        return false, '\f3'..tostring(c)
    end,

    login = function(self, name, player_name, passwd, ip, server, admin)
        self.parent.log:i(string.format("Find player name: %s for login.", name))
        local count_login = ('count_login_%s'):format(self.parent.flag.SERVER)
        local f, c =  self:query(string.format('SELECT `pwd`,`access`,`%s`,`active`, `uuid`, `email`,`ip`,`player_name`,`server`, `disable_account` FROM `user` WHERE BINARY `user`.`name` = \'%s\'',count_login , name ))
        --[[
        if not f and (tostring(c)):find('count_login') then
            f, c =  self:query(string.format('ALTER TABLE `user` ADD `%s` BIGINT NOT NULL DEFAULT \'0\' AFTER `count_login_vs`;',count_login))
        end
        ]]
        if f then
            local r = c:fetch ({},'a')
            c:close()
            if r ~= nil then
                self.parent.log:i(string.format("Player found. Name: %s", name))

                r.active = tonumber(r.active)

                if r.active > 0 and not self.parent.cnf.shell.su.multiple_login then
                    self.parent.log:w(string.format("Attempt user authentication %s for multiple account %s.", player_name, name))
                    return false, string.format(self.parent.cnf.shell.su.text.multiple_login, player_name, name, r.player_name, r.ip, r.server), 0, '',''
                end

                if  passwd == tostring(r.pwd) or (admin~=nil and admin==true) then
                    self.parent.log:w(string.format("Access is allowed Name: %s", name))
                    local cn = self.parent.cn:get_cn(player_name)
                    local dcn = self.parent.cn:get_dcn(cn)
                    if tonumber(r.disable_account) == 1 then
                        self.parent.log:w(string.format("Player %s is blocked", name))
                        return false, string.format(self.parent.cnf.sql.text.user_blocked, name),0, '','',''
                    end
                    if name ~= player_name then
                        if self:chk_user(player_name) then
                            self.parent.say:me(cn,self.parent.cnf.sql.text.atenntion_badly)
                        else
                            self.parent.say:me(cn,self.parent.cnf.sql.text.atenntion_create_account)
                        end
                    end

                    r[count_login] = tonumber(r[count_login]) + 1

                    f, c =  self:query(string.format('UPDATE `user` SET `user`.`use_access`= %s, `user`.`ip`= \'%s\', `user`.`%s` = %s, `user`.`date_login`= now(), `user`.`active` = %s, `user`.`player_name` = \'%s\', `user`.`server` = \'%s\' WHERE BINARY `user`.`name` = \'%s\';',tonumber(r.access), ip,count_login,r[count_login], 1, player_name, self.parent.flag.SERVER, name ))
                    if f then
                        self.parent.log:i("Update timestamp LOGIN OK")
                    else
                        self.parent.log:e(string.format("Update timestamp LOGIN NO ERR: %s", c))
                        return false, '\f3'..tostring(c),0, '','',''
                    end
                    self.parent.log:i(string.format("Login istablished: %s", name))
                    return true, tonumber(r.access), r[count_login], r.uuid, r.email, tonumber(r.score_of_maps)
                else
                    self.parent.log:i(string.format("Access is not permitted Name: %s", name))
                    return false, string.format(self.parent.cnf.sql.text.access_not_permitted, name),0, '','',''
                end
            else
                self.parent.log:e(string.format("Player NOT found. Name: %s", name))
                return  false, string.format(self.parent.cnf.sql.text.user_not_found,name),0, '','',''
            end
        else
            self.parent.log:e(string.format("Player NOT find. Name: %s MESS: %s", name,c))
            return false, '\f3'..tostring(c),0, '','',''
        end
    end,

    get_user_account_data = function(self, name)
        local f, c =  self:query(string.format('SELECT * FROM `user` WHERE BINARY `user`.`name` = \'%s\'', name ))
        if f then
            local r = c:fetch ({},'a')
            c:close()
            if r ~= nil then
                return true, r
            else
                self.parent.log:e(string.format("Player NOT found. Name: %s", name))
                return  false, string.format(self.parent.cnf.sql.text.user_not_found,name)
            end
        else
            self.parent.log:e(string.format("Player NOT find. Name: %s MESS: %s", name,c))
            return false, '\f3'..tostring(c)
        end
    end,

    u_role = function(self,name, role)
        if role == 1 or role == 0 or role == nil then
            self.parent.log:i(string.format("Player not update. Role BAD for Name: %s", name))
            return  false, string.format(self.parent.cnf.sql.text.access_not_valid, name)
        end
        local f, r = self:chk_user(name)
        if f then
            f, r =  self:query(string.format('UPDATE `user` SET `user`.`access`= %s WHERE BINARY `name` = \'%s\';', tonumber(role), name ))
            if f then self.parent.log:i("Update ROLE OK") return  true, self.parent.cnf.sql.text.user_ok_set_update_role
            else self.parent.log:e(string.format("Update ROLE NO ERR: %s", r))
                return false, self.parent.cnf.sql.text.user_not_set_update_role end
        else
            return false, r
        end
    end,

    u_name = function(self,name, newname)
        local f, r = self:chk_user(name)
        if f then
            f, r =  self:query(string.format('UPDATE `user` SET `user`.`name`= \'%s\' WHERE BINARY `name` = \'%s\';', newname, name ))
            if f then self.parent.log:i("Update NAME OK") return  true, string.format(self.parent.cnf.sql.text.user_ok_set_update_name,newname)
            else self.parent.log:e(string.format("Update NAME NO ERR: %s", r))
                return false, string.format(self.parent.cnf.sql.text.user_not_set_update_name,newname) end
        else
            return false, r
        end
    end,

    u_passwd = function(self,name,passwd)
        local f, r = self:chk_user(name)
        if f then
            f, r =  self:query(string.format('UPDATE `user` SET `user`.`pwd`= \'%s\' WHERE BINARY `name` = \'%s\';', passwd, name ))
            if f then self.parent.log:i("Update PASSWORD OK") return  true, self.parent.cnf.sql.text.user_ok_set_update_pwd
            else self.parent.log:e(string.format("Update PASSWORD NO ERR: %s", r))
                return false, self.parent.cnf.sql.text.user_not_set_update_pwd end
        else
            return false, r
        end
    end,

    u_email = function(self,name,email,flag)
        local f, c = self:query(string.format('SELECT `uuid` FROM `user` WHERE BINARY `user`.`name` = \'%s\';', name ))
        local uuid = nil
        if f then
            local r = c:fetch({})
            c:close()
            if r~= nil then uuid = r[1] end
            f, r =  self:query(string.format('UPDATE `user` SET `user`.`email`= \'%s\' WHERE BINARY `name` = \'%s\';', email, name ))
            if f then
                self.parent.log:i("Update email OK")
                if uuid~= nil then
                    f,r = self:u_email_user_data_gema(uuid,email,flag)
                end
                return  true, string.format(self.parent.cnf.sql.text.user_ok_set_update_email,r)
            else self.parent.log:e(string.format("Update email NO ERR: %s", r))
                return false, self.parent.cnf.sql.text.user_not_set_update_email end
        else
            return false, c
        end
    end,

    u_use_role = function(self,name, role)
        local f, r = self:chk_user(name)
        if f then
            f, r =  self:query(string.format('UPDATE `user` SET `user`.`use_access`= %s WHERE BINARY `name` = \'%s\';', tonumber(role), name ))
            if f then self.parent.log:i("Update USED_ROLE OK") return  true, self.parent.cnf.sql.text.user_ok_set_update_role
            else self.parent.log:e(string.format("Update USED_ROLE NO ERR: %s", r))
                return false, self.parent.cnf.sql.text.user_not_set_update_role end
        else
            return false, r
        end
    end,

    useradd = function(self,name,access,pwd,email)
        self.parent.log:w(string.format("Create player name: %s in DB", name))
        if access == nil or access < self.parent.cn:get_role(REGISTERED) or access > self.parent.cn:get_role(ROOT)  then
            self.parent.log:i(string.format("Player not create. Role BAD for Name: %s", name))
            return  false, string.format(self.parent.cnf.sql.text.access_not_valid, name)
        end
        local uuid = self.parent.fn:uuid()
        local f, r =  self:query(string.format('INSERT INTO `user`(  `name`, `name_registered`, `uuid`, `access`, `pwd`, `email` ) VALUES ( \'%s\', \'%s\', \'%s\', %s, \'%s\' ,\'%s\');', name, name, uuid, access, pwd, email ))
        if f then
            self.parent.log:i(string.format("Player create. Name: %s", name))
            return  true, string.format(self.parent.cnf.sql.text.user_add,name,self.parent.cn:get_role(access)),uuid
        else
            self.parent.log:e(string.format("Player NOT create. Name: %s MESS: %s", name,r))
            return  false, string.format(self.parent.cnf.sql.text.user_add_exists,name), '\f3'..tostring(r)
        end
    end,

    userdel = function(self,name)
        local f, r, uuid,mail =  self:chk_user(name)
        if f then
            f, r =  self:query(string.format('DELETE FROM `user` WHERE BINARY `user`.`name` = \'%s\'', name))
            if f then self.parent.log:i(string.format("Player deleted. Name: %s", name))
                return  true, string.format(self.parent.cnf.sql.text.user_del,name),uuid,mail
            else self.parent.log:e(string.format("Player NOT deleted. Name: %s MESS: %s", name,r))
                    return false, '\f3'..tostring(r),uuid end
        else
            return false, r,uuid
        end
    end,


    u_uuid_user_data_gema = function(self,uuid,newuuid,flag)
        self.parent.log:i("Update uuid of maps, function u_uuid_user_data_gema")
        local err, f,c,count = nil,nil, nil,0
        f, c = self:query(string.format('SELECT `uuid`, `map` FROM `user_data_gema` WHERE `user_data_gema`.`uuid` = \'%s\';', uuid ))
        if f then
            local r = c:fetch({},"a")
            while r do
                if r.uuid == '' or (flag~=nil and flag==true) then err = self:query(string.format('UPDATE `user_data_gema` SET `user_data_gema`.`uuid`= \'%s\' WHERE `user_data_gema`.`uuid` = \'%s\' AND `user_data_gema`.`map` = \'%s\';', newuuid, r.uuid , r.map )) end
                if err then count = count + 1 end
                r = c:fetch (r,'a')
            end
            c:close()
            c = string.format("Update %s uuid of maps, function u_uuid_user_data_gema",count)
        end
        if c~= nil then self.parent.log:e(tostring(c)) end
        return f, count
    end,

    u_email_user_data_gema = function(self,uuid,email,flag)
        self.parent.log:i("Update email of maps, function u_email_user_data_gema")
        local err, f,c,count = nil, nil, nil,0
        f, c = self:query(string.format('SELECT `email`,`uuid`, `map` FROM `user_data_gema` WHERE `user_data_gema`.`uuid` = \'%s\';', uuid ))
        if f then
            local r = c:fetch({},"a")
            while r do
                if r.email == '' or (flag~=nil and tonumber(flag)>0) then err = self:query(string.format('UPDATE `user_data_gema` SET `user_data_gema`.`email`= \'%s\' WHERE `user_data_gema`.`uuid` = \'%s\' AND `user_data_gema`.`map` = \'%s\';', email, r.uuid , r.map )) end
                if err then count = count + 1 end
                r = c:fetch (r,'a')
            end
            c:close()
            c = string.format("Update %s email of maps, function u_email_user_data_gema", count)
        end
        if c~= nil then self.parent.log:e(tostring(c)) end
        return f, count
    end,

    get_user_data_gema_info_position_list_best_time = function(self,uuid,map)
        local f, c = self:query(string.format('SELECT `uuid`,`time_score_best`,`count_score` FROM `user_data_gema` WHERE `map` = \'%s\' AND `time_score_best` ORDER BY `time_score_best` ASC;', map))
        local count,flag = 0, false
        if f then
            local r = c:fetch ({},"a")
            while r do
                count = count + 1
                if uuid ~= r.uuid then
                    r = c:fetch (r,'a')
                else
                    flag = true
                    r = nil
                end
            end
            c:close()
            if flag then return count,nil else return 0,nil end
        end
        return count,c
    end,

    get_user_data_gema_score = function(self,uuid)
        local f, c = self:query(string.format('SELECT `map`,`count_score` FROM `user_data_gema` WHERE `user_data_gema`.`uuid` = \'%s\' ORDER BY `user_data_gema`.`count_score`;', uuid))
        local count,smaps = 0, getservermaps()
        if f then
            local r = c:fetch ({},"a")
            while r do
                for _,v in ipairs(smaps) do
                    if v == r.map then
                        if tonumber(r.count_score) >= 1 then count = count + 1 end
                    end
                end
                r = c:fetch (r,'a')
            end
            c:close()
            return count,nil
        end
        return count,c
    end,

    user_data_gema_score = function(self,cn,time_score)
        --if self:chk_user(name) then
        self.parent.log:i(string.format("Use score of maps: %s, function user_data_gema_score", self.parent.gm.map.name))
        local dcn,uuid, err, f,c,count = nil,'','',nil, nil,0

        if cn ~= nil and tonumber(cn) ~= nil then
            dcn = self.parent.cn:get_dcn(cn)
            if dcn == nil then
                self.parent.log:e(self.parent.cnf.sql.text.user_data_gema_not_valid_cn)
                return false, self.parent.cnf.sql.text.user_data_gema_not_valid_cn
            end
            uuid = self.parent.cn.data[dcn].account.uuid
        elseif cn ~= nil and type(cn) == 'string' then
            uuid = cn
        else
            return false, string.format(self.parent.cnf.sql.text.user_data_gema_not_valid_id,cn)
        end

        if time_score == nil then
            count,c = self:get_user_data_gema_score(uuid)
            if c~=nil then err = c else
                err = string.format(self.parent.cnf.sql.statistic.text.not_found_data_map_2, self.parent.gm.map.name, self.parent.cn.data[dcn].account.name)
            end
        else
            f, c = self:query(string.format('SELECT `count_score`, `time_score`, `time_score_old`, `time_score_best_old`, `time_score_best` FROM `user_data_gema` WHERE `user_data_gema`.`uuid` = \'%s\' AND `user_data_gema`.`map` = \'%s\';', uuid, self.parent.gm.map.name ))
            if f then
                local r = c:fetch ({},"a")
                c:close()
                if r~= nil then
                    r.count_score = tonumber(r.count_score) + 1
                    if time_score < tonumber(r.time_score_best) or tonumber(r.time_score_best) == 0  then
                        r.time_score_best_old = tonumber(r.time_score_best)
                        r.time_score_best = time_score
                    end
                    r.time_score_old = tonumber(r.time_score)
                    r.time_score = time_score
                    f,c = self:query(string.format('UPDATE `user_data_gema` SET `user_data_gema`.`count_score`= %s, `user_data_gema`.`time_score_old` = %s, `user_data_gema`.`time_score_best_old`= %s, `user_data_gema`.`time_score`= %s, `user_data_gema`.`time_score_best`=%s WHERE `user_data_gema`.`uuid` = \'%s\' AND `user_data_gema`.`map` = \'%s\';', r.count_score,r.time_score_old, r.time_score_best_old,r.time_score,r.time_score_best, uuid, self.parent.gm.map.name ))
                    if f then
                          return r.count_score,r
                    end
                end
            end
            if dcn ~= nil then
                c= string.format('Function user_data_gema_score. Not found the statistics for the map of account, %s, for player %s',self.parent.gm.map.name, self.parent.cn.data[dcn].account.name)
                err = string.format(self.parent.cnf.sql.statistic.text.not_found_data_map_2, self.parent.gm.map.name, self.parent.cn.data[dcn].account.name)
            else
                c = 'Function user_data_gema_score. Not found the statistics for the map',self
                err = self.parent.cnf.sql.statistic.text.not_found_data_map_0
            end
        end
        if c~= nil then self.parent.log:e(tostring(c)) end
        return count, err
    end,

    user_data_gema = function(self,cn,flag)
        self.parent.log:i("Get user data map gema or create if not exists, function user_data_gema")
        local dcn, err, uuid ,c= nil, '', '',nil
        if cn ~= nil and tonumber(cn) ~= nil then
            dcn = self.parent.cn:get_dcn(cn)
            if dcn == nil then
                self.parent.log:e(self.parent.cnf.sql.text.user_data_gema_not_valid_cn)
                return false, self.parent.cnf.sql.text.user_data_gema_not_valid_cn
            end
            uuid = self.parent.cn.data[dcn].account.uuid
        elseif cn ~= nil and type(cn) == 'string' then
            uuid = cn
            if flag ~= nil then flag = true end
        else
            return false, string.format(self.parent.cnf.sql.text.user_data_gema_not_valid_id,cn)
        end

        local f, c =  self:query(string.format('SELECT  `uuid`,`map`, `count`, `count_score`, `time_score`, `time_score_old`, `time_score_best`, `time_score_best_old`, `use_map_date`  FROM `user_data_gema` WHERE `user_data_gema`.`uuid` = \'%s\' AND `user_data_gema`.`map` = \'%s\';', uuid, self.parent.gm.map.name))
        if f then
            local r,data = c:fetch ({},"a"), nil
            c:close()
            if r == nil and flag == nil and dcn ~= nil then
                self.parent.log:e(string.format("Player not found statistic the map %s Palyer: %s ", self.parent.gm.map.name, self.parent.cn.data[dcn].account.name))
                f,c = self:query(string.format('INSERT INTO `user_data_gema`(`name`,`email`,`uuid`,`map`, `count`) VALUES ( \'%s\', \'%s\', \'%s\',\'%s\', %s);', self.parent.cn.data[dcn].account.name, self.parent.cn.data[dcn].account.email, self.parent.cn.data[dcn].account.uuid, self.parent.gm.map.name, 1 ))
                if f then
                    self.parent.log:w(string.format("Player create statistic map. Player: %s Name: %s", self.parent.cn.data[dcn].account.name,self.parent.gm.map.name ))
                    return  true, string.format(self.parent.cnf.sql.statistic.text.create_map,self.parent.cn.data[dcn].account.name,self.parent.gm.map.name)
                else
                    self.parent.log:e(string.format("Player not create statistic map. Palyer: %s Name: %s MESS: %s", self.parent.cn.data[dcn].account.name,self.parent.gm.map.name,c))
                   return  false,string.format(self.parent.cnf.sql.statistic.text.not_create_map,self.parent.cn.data[dcn].account.name,self.parent.gm.map.name)
                end
            else
                if flag == nil and dcn ~= nil then
                    r.count = r.count +1
                    f,c = self:query(string.format('UPDATE `user_data_gema` SET `user_data_gema`.`name`= \'%s\', `user_data_gema`.`count`= %s WHERE `user_data_gema`.`uuid` = \'%s\' AND `user_data_gema`.`map` = \'%s\';',self.parent.cn.data[dcn].account.name, r.count, r.uuid , r.map ))
                end
                data = r
            end
            if data == nil then
                if flag ~= nil and type(flag) == 'string' then
                    self.parent.log:e(string.format('Function user_data_gema. Not found the statistics for the map, %s, for player %s',self.parent.gm.map.name, flag))
                    return false, string.format(self.parent.cnf.sql.statistic.text.not_found_data_map_1,self.parent.gm.map.name, flag)
                elseif dcn ~= nil then
                    self.parent.log:e(string.format('Function user_data_gema. Not found the statistics for the map of account, %s, for player %s',self.parent.gm.map.name, self.parent.cn.data[dcn].account.name))
                    return false, string.format(self.parent.cnf.sql.statistic.text.not_found_data_map_2, self.parent.gm.map.name, self.parent.cn.data[dcn].account.name)
                else
                    self.parent.log:e('Function user_data_gema. Not found the statistics for the map',self)
                    return false, self.parent.cnf.sql.statistic.text.not_found_data_map_0
                end
            end
            return true, data
        end
        if c~= nil then self.parent.log:e(tostring(c)) end
        return false, c
    end,

    delete_user_data_gema = function(self,cn,flag)
        self.parent.log:i("Get user data map gema or create if not exists, function user_data_gema")
        local dcn, err, uuid ,c= nil, '', '',nil
        if cn ~= nil and tonumber(cn) ~= nil then
            dcn = self.parent.cn:get_dcn(cn)
            if dcn == nil then
                self.parent.log:e(self.parent.cnf.sql.text.user_data_gema_not_valid_cn)
                return false, self.parent.cnf.sql.text.user_data_gema_not_valid_cn
            end
            uuid = self.parent.cn.data[dcn].account.uuid
        elseif cn ~= nil and type(cn) == 'string' then
            uuid = cn
            if flag ~= nil then flag = true end
        else
            return false, string.format(self.parent.cnf.sql.text.user_data_gema_not_valid_id,cn)
        end
        local f, c =  nil,nil
        if flag == nil then
            f,c = self:query(string.format('DELETE FROM `user_data_gema` WHERE `uuid` = \'%s\';', uuid))
            if f then return true, self.parent.cnf.sql.text.user_data_gema_delete_full end
        else
            f,c = self:query(string.format('DELETE FROM `user_data_gema` WHERE `user_data_gema`.`uuid` = \'%s\' AND `user_data_gema`.`map` = \'%s\';', uuid, self.parent.gm.map.name))
            if f then return true, string.format(self.parent.cnf.sql.text.user_data_gema_delete_one,self.parent.gm.map.name)  end
        end
        if c~= nil then self.parent.log:e(tostring(c)) end
        return false, self.parent.cnf.sql.text.user_data_gema_deleted_not
    end,

    get_map_top = function(self,data)
        if data~=nil and type(data)=='table' then
            local f,ff,c,cc, r,o = nil,nil,nil,nil,{},{}
            if data.best~=nil and data.best then
                f,c =self:query(string.format('SELECT `name`,`map`,`uuid`,`count`,`count_score`,`time_score`,`time_score_best` FROM `user_data_gema` WHERE `map` = \'%s\' AND `time_score_best` ORDER BY `time_score_best` ASC LIMIT %s;',data.map,data.limit))
            end
            if f then
                r = c:fetch ({},"a")
                while r do
                    ff,cc =self:query(string.format('SELECT `name_registered` FROM `user` WHERE `user`.`uuid` = \'%s\';',r.uuid))
                    if ff then
                        rr = cc:fetch ({})
                        cc:close()
                        if rr~= nil then
                            r.name = rr[1]
                            table.insert(o,{})
                            for k,v in pairs(r) do
                                o[#o][k] = v
                            end
                        end
                    end
                    r = c:fetch (r,'a')
                end
                c:close()
            end
            if o~=nil and #o > 0 then return true, o else return false,self.parent.cnf.sql.statistic.text.not_found_data_map_0 end
        end
    end,

    server_log_start_update = function(self,server)

        local timestamp = os.time()

        local f, c = self:query(string.format('SELECT * FROM `server_log` WHERE `server_log`.`server` = \'%s\';', server))
        if f then
            local r = c:fetch ({},"a")
            c:close()
            if r == nil then
                f, c = self:query(string.format('INSERT INTO `server_log` (`server`,`count_start`,`timestamp_start`) VALUES ( \'%s\', %s, %s);', server,1,timestamp))
            r = {
                server = server,
                count_start = 1,
                timestamp_start = timestamp,
                count_stop = 0,
                timestamp_stop = 0,
                count_change_map = 0,
                count_connect_player = 0
            }
            else
                r.count_start = tonumber(r.count_start) + 1
                f, c = self:query(string.format('UPDATE `server_log` SET `server_log`.`count_start`= %s, `server_log`.`timestamp_start`= %s WHERE `server_log`.`server`= \'%s\';',r.count_start,timestamp,server ))
            end
        end
        if not f then
            return false,c
        end
        return true, r
    end,

    server_log_stop_update = function(self,server)

        local timestamp = os.time()

        local f, c = self:query(string.format('SELECT * FROM `server_log` WHERE `server_log`.`server` = \'%s\';', server))
        if f then
            local r = c:fetch ({},"a")
            c:close()
            if r ~= nil then
                r.count_stop = tonumber(r.count_stop) + 1
                f, c = self:query(string.format('UPDATE `server_log` SET `server_log`.`count_stop`= %s, `server_log`.`timestamp_stop`= %s WHERE `server_log`.`server`= \'%s\';',r.count_stop,timestamp,server ))
            end
        end
        if not f then
            return false,c
        end
        return true, r
    end,

    server_log_get = function(self,server)
        local f, c = self:query(string.format('SELECT * FROM `server_log` WHERE `server_log`.`server` = \'%s\';', server))
        if f then
            local r = c:fetch ({},"a")
            c:close()
            if r~= nil then
                return true,r
            end
        end
        return false,c
    end,

    server_log_change_map_update = function(self,server,map)

        local timestamp = os.time()

        local f, c = self:query(string.format('SELECT * FROM `server_log` WHERE `server_log`.`server` = \'%s\';', server))
        local r = {
            map = nil,
            server = nil
        }

        if f then
            r.server = c:fetch ({},"a")
            c:close()
            if r.server ~= nil then
                r.server.count_change_map = tonumber(r.server.count_change_map) + 1
                f, c = self:query(string.format('UPDATE `server_log` SET `server_log`.`count_change_map`= %s WHERE `server_log`.`server`= \'%s\';',r.server.count_change_map,server ))
            end
        end

        f, c = self:query(string.format('SELECT * FROM `server_log_change_map` WHERE `server_log_change_map`.`server` = \'%s\' AND BINARY `server_log_change_map`.`map` = \'%s\';',server,map))
        if f then
            r.map = c:fetch ({},"a")
            c:close()
            if r.map == nil then
                f, c = self:query(string.format('INSERT INTO `server_log_change_map` (`map`,`server`,`count_change`) VALUES ( \'%s\', \'%s\', %s);', map,server,1))
            r.map = {
                map = map,
                server = server,
                count_change = 1,
            }
            else
                r.map.count_change = tonumber(r.map.count_change) + 1
                f, c = self:query(string.format('UPDATE `server_log_change_map` SET `server_log_change_map`.`count_change`= %s WHERE `server_log_change_map`.`server`= \'%s\' AND `server_log_change_map`.`map`= \'%s\';',r.map.count_change,server,map ))
            end
        end
        if not f then
            return false,c
        end
        return true, r
    end,

    server_log_change_map_get_list = function(self,server,limit)
        local f, c = self:query(string.format('SELECT `map`,`count_change` FROM `server_log_change_map` WHERE `server` = \'%s\' ORDER BY `count_change` DESC LIMIT %s;', server,limit))
        if f then
            local o = {}
            local r = c:fetch ({},"a")
            while r do
                table.insert(o,{})
                for k,v in pairs(r) do
                    o[#o][k] = v
                end
                r = c:fetch (r,"a")
            end
            c:close()
            if #o > 0 then return true,o end
        end
        return false,c
    end,

    server_log_visit_player_update = function(self,server,player,ip)

        local timestamp = os.time()

        local f, c = self:query(string.format('SELECT * FROM `server_log` WHERE `server_log`.`server` = \'%s\';', server))
        local r = {
            player = nil,
            server = nil
        }

        if f then
            r.server = c:fetch ({},"a")
            c:close()
            if r.server ~= nil then
                r.server.count_connect_player = tonumber(r.server.count_connect_player) + 1
                f, c = self:query(string.format('UPDATE `server_log` SET `server_log`.`count_connect_player`= %s WHERE `server_log`.`server`= \'%s\';',r.server.count_connect_player,server ))
            end
        end

        f, c = self:query(string.format('SELECT * FROM `server_log_visit_player` WHERE `server_log_visit_player`.`server` = \'%s\' AND BINARY `server_log_visit_player`.`player` = \'%s\';',server, player))
        if f then
            r.player = c:fetch ({},"a")
            c:close()
            if r.player == nil then
                f, c = self:query(string.format('INSERT INTO `server_log_visit_player` (`player`,`server`,`ip`,`count_visit`,`timestamp_connect`) VALUES ( \'%s\', \'%s\', \'%s\', %s,%s);', player,server,ip,1,timestamp))
            r.player = {
                player = player,
                ip = ip,
                old_ip_1 = '0.0.0.0',
                old_ip_2 = '0.0.0.0',
                old_ip_3 = '0.0.0.0',
                old_ip_4 = '0.0.0.0',
                old_ip_5 = '0.0.0.0',
                server = server,
                count_visit = 1,
                timestamp_connect  = timestamp,
            }
            else
                r.player.count_visit = tonumber(r.player.count_visit) + 1
                r.player.old_ip_5 = r.player.old_ip_4
                r.player.old_ip_4 = r.player.old_ip_3
                r.player.old_ip_3 = r.player.old_ip_2
                r.player.old_ip_2 = r.player.old_ip_1
                r.player.old_ip_1 = r.player.ip
                r.player.ip = ip
                f, c = self:query(string.format('UPDATE `server_log_visit_player` SET `server_log_visit_player`.`ip`= \'%s\',`server_log_visit_player`.`old_ip_1`= \'%s\',`server_log_visit_player`.`old_ip_2`= \'%s\',`server_log_visit_player`.`old_ip_3`= \'%s\',`server_log_visit_player`.`old_ip_4`= \'%s\',`server_log_visit_player`.`old_ip_5`= \'%s\',`server_log_visit_player`.`count_visit`= %s,`server_log_visit_player`.`timestamp_connect`= %s  WHERE `server_log_visit_player`.`server`= \'%s\' AND BINARY `server_log_visit_player`.`player`= \'%s\';',ip,r.player.old_ip_1,r.player.old_ip_2,r.player.old_ip_3,r.player.old_ip_4,r.player.old_ip_5,r.player.count_visit,timestamp,server,player ))
            end
        end
        if not f then
            return false,c
        end
        return true, r
    end,

    server_log_visit_player_get_list = function(self,server,timestamp_start,timestamp_end)
        local f, c = self:query(string.format('SELECT * FROM `server_log_visit_player` WHERE `server`=\'%s\' AND `timestamp_connect` <= %s AND `timestamp_connect` >= %s ORDER BY `timestamp_connect` DESC;',server,timestamp_start,timestamp_end))
        if f then
            local o = {}
            local r = c:fetch ({},"a")
            while r do
                table.insert(o,{})
                for k,v in pairs(r) do
                    o[#o][k] = v
                end
                r = c:fetch (r,"a")
            end
            c:close()
            if #o > 0 then return true,o end
        end
        return false,c
    end,
}