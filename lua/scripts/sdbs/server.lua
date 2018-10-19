return {

    timer_messages_fn = {},
    timer_messages_flag_active = false,

    start_timer_messages = function(self)
        if self.cnf.timer_messages ~= nil and #self.cnf.timer_messages > 0 then
            for i = TMR_SERVER_MESSAGES, ( TMR_SERVER_MESSAGES + (#self.cnf.timer_messages-1) ) do
                if self.cnf.timer_messages[i-TMR_SERVER_MESSAGES+1].active['disable'] == false and self.cnf.timer_messages[i-TMR_SERVER_MESSAGES+1].active[self.parent.flag.SERVER] ~= nil and self.cnf.timer_messages[i-TMR_SERVER_MESSAGES+1].active[self.parent.flag.SERVER] == true then
                    if self.timer_messages_fn[i] == nil then
                        self.timer_messages_fn[i] = function()
                            local num_func = i
                            if type(sdbs.cnf.server.timer_messages[num_func-TMR_SERVER_MESSAGES+1].text) == 'string' then
                                sdbs.say:smg(sdbs.cnf.server.timer_messages[num_func-TMR_SERVER_MESSAGES+1].text)
                            elseif type(sdbs.cnf.server.timer_messages[num_func-TMR_SERVER_MESSAGES+1].text) == 'function' then
                                local smg = sdbs.cnf.server.timer_messages[num_func-TMR_SERVER_MESSAGES+1].text()
                                if smg~= nil then sdbs.say:smg(smg) end
                            end
                        end
                        tmr.create(i,self.cnf.timer_messages[i-TMR_SERVER_MESSAGES+1].period,self.timer_messages_fn[i])
                        self.parent.log:w('Activate server timer messages TMR: '..tostring(i))
                    end
                end
            end
            self.timer_messages_flag_active = true
        end
    end,

    stop_timer_messages = function(self)
        if self.cnf.timer_messages ~= nil and #self.cnf.timer_messages > 0 then
            for i = TMR_SERVER_MESSAGES, ( TMR_SERVER_MESSAGES + (#self.cnf.timer_messages-1) ) do
                if self.cnf.timer_messages[i-TMR_SERVER_MESSAGES+1].active['disable'] == false and self.cnf.timer_messages[i-TMR_SERVER_MESSAGES+1].active[self.parent.flag.SERVER] ~= nil and self.cnf.timer_messages[i-TMR_SERVER_MESSAGES+1].active[self.parent.flag.SERVER] == true and self.timer_messages_fn[i] ~= nil then
                    tmr.remove(i)
                    self.timer_messages_fn[i] = nil
                    self.parent.log:w('Deactivate server timer messages TMR: '..tostring(i))
                end
            end
            self.timer_messages_flag_active = false
        end
    end,

    on_player_connect = function(self)
        if #self.parent.cn.data > 0 and self.timer_messages_flag_active == false then
            self:start_timer_messages()
        end
    end,

    on_player_disconnect = function(self,cn)
        if #self.parent.cn.data == 0 and self.timer_messages_flag_active == true then
            self:stop_timer_messages()
        end
    end,

    is_linux = function(self)
    end,

    is_gema = function(self)
        for _,v  in ipairs(self.parent.cnf.server.list_name_server_gema) do
            if self.parent.flag.SERVER:find(v) then
                return true
            end
        end
        return false
    end,

    sendmail = function(self,email,text,cn)
        if self.cnf.msmtp.active then
            local PLAYER, SUBJECT, MESSAGE, BODY, COMMAND, dcn ,email,text= {}, {}, '', '', '',nil,email,text

            if type(email) == 'string' then
                email = self.parent.fn:split(email,',')
                for k,v in ipairs(email) do
                    email[k] = self.parent.fn:trim(v)
                end
            end

            local temail = {}
            for k,v in ipairs(email) do
                if v ~= NOT_EMAIL or v ~= '' then
                    table.insert(temail,v)
                end
            end

            email = nil

            if #temail == 0 then
                self.parent.log:w(self.cnf.msmtp.text['send_email_no_to'])
                if cn ~= nil then  self.parent.say:me(cn,self.cnf.msmtp.text['send_email_no']) end
                return
            end

            if type(text) ~= 'string' and type(text) == 'table' then
                text = table.concat(text,'')
            end

            --text = string.gsub(text,'|','\\|')
            --text = self.parent.fn:escape_SPECL(text)

            if type(text) ~= 'string' then
                self.parent.log:w(self.cnf.msmtp.text['send_email_no_text'])
                if cn ~= nil then  self.parent.say:me(cn,self.cnf.msmtp.text['send_email_no']) end
                return
            end

            if type(self.cnf.msmtp.subject) == 'string' then
                table.insert(SUBJECT,self.cnf.msmtp.subject)
            else
                for _,v in ipairs(self.cnf.msmtp.subject) do
                    table.insert(SUBJECT,v)
                end
            end

            for k,v in ipairs(SUBJECT) do
                SUBJECT[k] = string.format(v,string.upper(self.parent.flag.SERVER))
            end
            SUBJECT = table.concat(SUBJECT, ', ')

            if cn ~=nil then
                dcn = self.parent.cn:get_dcn(cn)
                if self.parent.cn.data[dcn].account.email == '' then self.parent.cn.data[dcn].account.email = NOT_EMAIL end
                if type(self.cnf.msmtp.sent_by_the_player) == 'string' then
                    table.insert(PLAYER,self.cnf.msmtp.sent_by_the_player)
                else
                    for _,v in ipairs(self.cnf.msmtp.sent_by_the_player) do
                        table.insert(PLAYER,v)
                    end
                end
                for k,v in ipairs(PLAYER) do
                    PLAYER[k] = string.format(v,self.parent.cn.data[dcn].name,self.parent.cn.data[dcn].account.email,self.parent.cn.data[dcn].ip)
                end
            else
                if type(self.cnf.msmtp.sent_by_the_server) == 'string' then
                    table.insert(PLAYER,self.cnf.msmtp.sent_by_the_server)
                else
                    for _,v in ipairs(self.cnf.msmtp.sent_by_the_server) do
                        table.insert(PLAYER,v)
                    end
                end
                for k,v in ipairs(PLAYER) do
                    PLAYER[k] = string.format(v,string.upper(self.parent.flag.SERVER))
                end
            end

            PLAYER = table.concat(PLAYER, '\n')

            BODY = string.format('%s\n%s\n\n\n%s\nauthor: %s\n%s\n%s',PLAYER,text,PLUGIN_NAME..' '..PLUGIN_VERSION,PLUGIN_AUTHOR,PLUGIN_SITE,PLUGIN_EMAIL)

            for _,vemail in ipairs(temail) do
                MESSAGE = string.format('"Date: %s\nFrom: %s\nTo: %s\nSubject: %s\nContent-Type: text/plain; charset=UTF-8\n\n%s"',os.date(),self.cnf.msmtp.from,vemail,SUBJECT,BODY)


                COMMAND = string.format("echo '%s' | /usr/bin/msmtp --host=%s --port=%s --tls=%s --tls-certcheck=off --tls-starttls=%s --auth=login --user=%s --passwordeval=\"echo %s\" -f %s %s > /dev/null &",MESSAGE,self.cnf.msmtp.server,self.cnf.msmtp.port,self.cnf.msmtp.tls,self.cnf.msmtp.tls_starttls,self.cnf.msmtp.from,self.cnf.msmtp.password,self.cnf.msmtp.from,vemail)

                if os.execute(COMMAND)  then
                    self.parent.log:w(self.cnf.msmtp.text['send_email_ok'])
                    if cn ~= nil then self.parent.say:me(cn,self.cnf.msmtp.text['send_email_ok']) end
                else
                    self.parent.log:w(self.cnf.msmtp.text['send_email_no'])
                    if cn ~= nil then self.parent.say:me(cn,self.cnf.msmtp.text['send_email_no']) end
                end
            end
        else
            if cn ~= nil then self.parent.say.me(cn,self.cnf.msmtp.text['disable_activate']) end
        end
    end,

    timer_service_fn = {},

    start_timer_service = function(self)
        if self.cnf.timer_service ~= nil and #self.cnf.timer_service > 0 then
            for i = TMR_SERVER_SERVICE, ( TMR_SERVER_SERVICE + (#self.cnf.timer_service-1) ) do
                if self.cnf.timer_service[i-TMR_SERVER_SERVICE+1].active['disable'] == false and self.cnf.timer_service[i-TMR_SERVER_SERVICE+1].active[self.parent.flag.SERVER] ~= nil and self.cnf.timer_service[i-TMR_SERVER_SERVICE+1].active[self.parent.flag.SERVER] == true then
                    if self.timer_service_fn[i] == nil and type(self.cnf.timer_service[i-TMR_SERVER_SERVICE+1].fn) == 'function' then
                        self.timer_service_fn[i] = function()
                            local num_func = i
                            if type(sdbs.cnf.server.timer_service[num_func-TMR_SERVER_SERVICE+1].fn) == 'function' then
                                sdbs.cnf.server.timer_service[num_func-TMR_SERVER_SERVICE+1].fn()
                            end
                        end
                        tmr.create(i,self.cnf.timer_service[i-TMR_SERVER_SERVICE+1].period,self.timer_service_fn[i])
                        self.parent.log:w('Activate server timer service TMR: '..tostring(i))
                    end
                end
            end
        end
    end,

    stop_timer_service = function(self)
        if self.cnf.timer_service ~= nil and #self.cnf.timer_service > 0 then
            for i = TMR_SERVER_SERVICE, ( TMR_SERVER_SERVICE + (#self.cnf.timer_service-1) ) do
                if self.cnf.timer_service[i-TMR_SERVER_SERVICE+1].active['disable'] == false and self.cnf.timer_service[i-TMR_SERVER_SERVICE+1].active[self.parent.flag.SERVER] ~= nil and self.cnf.timer_service[i-TMR_SERVER_SERVICE+1].active[self.parent.flag.SERVER] == true and self.timer_service_fn[i]~=nil then
                    tmr.remove(i)
                    self.timer_service_fn[i] = nil
                    self.parent.log:w('Deactivate server timer service TMR: '..tostring(i))
                end
            end
        end
    end,

    start_server = function(self)
        if self.cnf.log.active and self.cnf.log.start.active then
            self.parent.sql:server_log_start_update(self.parent.flag.SERVER)
        end
        if self.cnf.msmtp.active and self.cnf.msmtp.allert_and_send_to.start_server.active then
            local text = {}
            for _,v in ipairs(self.cnf.msmtp.allert_and_send_to.start_server.text) do
                table.insert(text,string.format(v,os.date('%d-%m-%Y %X')))
            end
            self:sendmail(self.cnf.msmtp.allert_and_send_to.start_server.to,text)
        end
    end,

    stop_server = function(self)
        if self.cnf.log.active and self.cnf.log.stop.active then
            self.parent.sql:server_log_stop_update(self.parent.flag.SERVER)
        end
        if self.cnf.msmtp.active and self.cnf.msmtp.allert_and_send_to.stop_server.active then
            local text = {}
            for _,v in ipairs(self.cnf.msmtp.allert_and_send_to.stop_server.text) do
                table.insert(text,string.format(v,os.date('%d-%m-%Y %X')))
            end
            self:sendmail(self.cnf.msmtp.allert_and_send_to.stop_server.to,text)
        end
    end,

    server_log_visit_to_msmtp = function(self,aemail,atext,timestamp_start,timestamp_end)
        if  self.cnf.msmtp.active then
            local text = {}

            table.insert(text,string.format('\nStarting date for statistics: %s',os.date('%d-%m-%Y %X',self.cnf.log.starting_date_of_creation_of_statistics)))

            local f,r = self.parent.sql:server_log_get(self.parent.flag.SERVER)
            if f then
                table.insert(text,string.format('\n\nThe server started: %s',os.date('%d-%m-%Y %X',r.timestamp_start)))
                table.insert(text,string.format('\nThe number of calls to the server: %s',tostring(r.count_connect_player)))
                table.insert(text,string.format('\nThe number of played maps: %s',tostring(r.count_change_map)))
            end
            f,r = nil,nil

            table.insert(text,string.format('\nThe number of maps on the server:\n\tJust: %s. Gema: %s. In the rotator: %s. Gema in the rotator: %s.',self.parent.gm.map:get_cmaps(),self.parent.gm.map:get_cgmaps(),self.parent.gm.map:get_crmaps(),self.parent.gm.map:get_crgmaps()))

            local f,r = self.parent.sql:server_log_change_map_get_list(self.parent.flag.SERVER,self.cnf.msmtp.allert_and_send_to.log_visit.top_map)
            if f then
                table.insert(text,string.format('\nTop %s popular maps ( Name / Played ) :',#r))
                for _,v in ipairs(r) do
                    table.insert(text,string.format('\n\t%s / %s',v.map,v.count_change))
                end
            end
            f,r = nil,nil

            local ts,te = 0,0

            if timestamp_start ~= nil and tonumber(timestamp_start) ~= nil then
                ts = os.time() - ( tonumber(timestamp_start)*60*60 )
            else
                ts = os.time()
            end

            if timestamp_end ~= nil and tonumber(timestamp_end) ~= nil then
                te = ts - ( tonumber(timestamp_end) * 60 * 60 )
            else
                te = ts - ( self.cnf.msmtp.allert_and_send_to.log_visit.time_period * 60 * 60 )
            end

            f,r = self.parent.sql:server_log_visit_player_get_list(self.parent.flag.SERVER,ts,te)
            ts,te = nil,nil

            if f then
                local tracking_implicit,tracking_player, tracking_clan, players_called,key = {},{},{},{},#r

                while #r > 0 do
                        for _,v in ipairs(self.cnf.msmtp.allert_and_send_to.log_visit.tracking_implicit) do
                            if #r >= 1 and string.find(string.lower(r[key].player),v) then
                                table.insert(tracking_implicit,table.remove(r,key))
                                key = key - 1
                            end
                        end
                        for _,v in ipairs(self.cnf.msmtp.allert_and_send_to.log_visit.tracking_player) do
                            if #r >= 1 and v == r[key].player then
                                table.insert(tracking_player,table.remove(r,key))
                                key = key - 1
                            end
                        end
                        for _,v in ipairs(self.cnf.msmtp.allert_and_send_to.log_visit.tracking_clan) do
                            if #r >= 1 and string.find(r[key].player,v) then
                                table.insert(tracking_clan,table.remove(r,key))
                                key = key - 1
                            end
                        end
                        if #r >= 1 then table.insert(players_called,table.remove(r,key)) end
                        key = key - 1
                end

                if #tracking_implicit > 0 then
                    table.insert(text,string.format('\n\nTracked implicit players visited: %s',tostring(#tracking_implicit)))
                    table.insert(text,'\n\t( Player / Hits / IP / OLD IP / date )')
                    for _,v in ipairs(tracking_implicit) do
                        if v.old_ip_1 == '' then v.old_ip_1 =v.ip end
                        table.insert(text,string.format('\n\t%s / %s / %s / %s / %s',v.player,v.count_visit,v.ip,v.old_ip_1,os.date('%d-%m-%Y %X',v.timestamp_connect)))
                    end
                end

                if #tracking_player > 0 then
                    table.insert(text,string.format('\n\nTracked players visited: %s',tostring(#tracking_player)))
                    table.insert(text,'\n\t( Player / Hits / IP / OLD IP / date )')
                    for _,v in ipairs(tracking_player) do
                        if v.old_ip_1 == '' then v.old_ip_1 =v.ip end
                        table.insert(text,string.format('\n\t%s / %s / %s / %s / %s',v.player,v.count_visit,v.ip,v.old_ip_1,os.date('%d-%m-%Y %X',v.timestamp_connect)))
                    end
                end

                if #tracking_clan > 0 then
                    table.insert(text,string.format('\n\nTracked a clan of players visited: %s',tostring(#tracking_clan)))
                    table.insert(text,'\n\t( Player / Hits / IP / OLD IP / date )')
                    for _,v in ipairs(tracking_clan) do
                        if v.old_ip_1 == '' then v.old_ip_1 =v.ip end
                        table.insert(text,string.format('\n\t%s / %s / %s / %s / %s',v.player,v.count_visit,v.ip,v.old_ip_1,os.date('%d-%m-%Y %X',v.timestamp_connect)))
                    end
                end

                if #players_called > 0 then
                    table.insert(text,string.format('\n\nPlayers called for: %s',tostring(#players_called)))
                    table.insert(text,'\n\t( Player / Hits / IP / OLD IP / date )')
                    for _,v in ipairs(players_called) do
                        if v.old_ip_1 == '' then v.old_ip_1 =v.ip end
                        table.insert(text,string.format('\n\t%s / %s / %s / %s / %s',v.player,v.count_visit,v.ip,v.old_ip_1,os.date('%d-%m-%Y %X',v.timestamp_connect)))
                    end
                end

            end
            f,r,tracking_player, tracking_clan,tracking_implicit, players_called, key  = nil,nil,nil,nil,nil,nil,nil

            local email = aemail or self.cnf.msmtp.allert_and_send_to.log_visit.to
            if type(email) == 'string' then
                local e = {}
                table.insert(e,email)
                email = e
            end
            if atext ~=nil then
                if type(atext) == 'string' then table.insert(text,atext) else
                    for _,v in ipairs(atext) do
                        table.insert(text,v)
                    end
                end
            end

            self.parent.log:w(string.format('%s%s','send email: ', table.concat(email,',')))
            self:sendmail(email,text)
            email,text,e = nil,nil,nil

        end
    end,

    init = function(self,obj)
        self.parent = obj
        self.cnf = self.parent.cnf.server
        self.parent.log:w('Module SERVER init OK')
    end
}
