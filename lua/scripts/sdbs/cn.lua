return {

    l_ban = {
            --number
        [BAN_NONE] = NONE,
        [BAN_VOTE] = VOTE,
        [BAN_AUTO] = AUTO,
        [BAN_BLACKLIST] = BLACKLIST,
        [BAN_MASTER] = MASTER,
        [BAN_REGISTERED] = REGISTERED,
        [BAN_REFEREE] = REFEREE,
        [BAN_ROOT] = ROOT,
        [BAN_ADMIN] = ADMIN,
            --string
        [NONE] = BAN_NONE,
        [VOTE] = BAN_VOTE,
        [AUTO] = BAN_AUTO,
        [BLACKLIST] = BAN_BLACKLIST,
        [MASTER] = BAN_MASTER,
        [REGISTERED] = BAN_REGISTERED,
        [REFEREE] = BAN_REFEREE,
        [ROOT] = BAN_ROOT,
        [ADMIN] = BAN_ADMIN
    },
    get_l_ban = function(self,ban)
        if self.l_ban[ban] ~= nil then
            return self.l_ban[ban]
        end
        return nil
    end,

    d_reasson = {
            --number
        [DISC_NONE] = NONE,
        [DISC_EOP] = EOP,
        [DISC_CN] = CN,
        [DISC_MKICK] = MKICK,
        [DISC_MBAN] = MBAN,
        [DISC_TAGT] = TAGT,
        [DISC_BANREFUSE] = BANREFUSE,
        [DISC_WRONGPW] = WRONGPW,
        [DISC_SOPLOGINFAIL] = SOPLOGINFAIL,
        [DISC_MAXCLIENTS] = MAXCLIENTS,
        [DISC_MASTERMODE] = MASTERMODE,
        [DISC_AUTOKICK] = AUTOKICK,
        [DISC_AUTOBAN] = AUTOBAN,
        [DISC_DUP] = DUP,
        [DISC_BADNICK] = BADNICK,
        [DISC_OVERFLOW] = OVERFLOW,
        [DISC_ABUSE] = ABUSE,
        [DISC_AFK] = AFK,
        [DISC_FFIRE] = FFIRE,
        [DISC_CHEAT] = CHEAT,
            --string
        [NONE] = DISC_NONE,
        [EOP] = DISC_EOP,
        [CN] = DISC_CN,
        [MKICK] = DISC_MKICK,
        [MBAN] = DISC_MBAN,
        [TAGT] = DISC_TAGT,
        [BANREFUSE] = DISC_BANREFUSE,
        [WRONGPW] = DISC_WRONGPW,
        [SOPLOGINFAIL] = DISC_SOPLOGINFAIL,
        [MAXCLIENTS] = DISC_MAXCLIENTS,
        [MASTERMODE] = DISC_MASTERMODE,
        [AUTOKICK] = DISC_AUTOKICK,
        [AUTOBAN] = DISC_AUTOBAN,
        [DUP] = DISC_DUP,
        [BADNICK] = DISC_BADNICK,
        [OVERFLOW] = DISC_OVERFLOW,
        [ABUSE] = DISC_ABUSE,
        [AFK] = DISC_AFK,
        [FFIRE] = DISC_FFIRE,
        [CHEAT] = DISC_CHEAT
    },
    get_d_reasson = function(self,reasson)
        if self.d_reasson[reasson] ~= nil then
            return self.d_reasson[reasson]
        end
        return nil
    end,

    d_force = {
        cn = nil,
        reasson = nil,
        message = nil,
        root_message = nil
    },

    roles = {
            --clientroles
        [CR_ADMIN] = ADMIN,
        [CR_DEFAULT] = DEFAULT,
        [CR_ROOT] = ROOT,
        [CR_REFEREE] = REFEREE,
        [CR_REGISTERED] = REGISTERED,
        [ADMIN] = CR_ADMIN,
        [DEFAULT] = CR_DEFAULT,
        [ROOT] = CR_ROOT,
        [REFEREE] = CR_REFEREE,
        [REGISTERED] = CR_REGISTERED,
        [AD] = CR_ADMIN,
        [DEF] = CR_DEFAULT,
        [ROT] = CR_ROOT,
        [REF] = CR_REFEREE,
        [REG] = CR_REGISTERED
    },
    get_role = function(self,role)
        if type(role) == 'string' then
            if  tonumber(role) == nil then role = string.upper(role) else role = self:get_role(tonumber(role)) end
        end
        if self.roles[role] ~= nil then
            return self.roles[role]
        end
        return nil
    end,

    c_team = {
        [TEAM_CLA] = CLA,
        [TEAM_RVSF] = RVSF,
        [TEAM_CLA_SPECT] = CLA_SPECT,
        [TEAM_RVSF_SPECT] = RVSF_SPECT,
        [TEAM_SPECT] = SPECT,
        [TEAM_NUM] = NUM,
        [TEAM_ANYACTIVE] = ANYACTIVE,
        [CLA] = TEAM_CLA,
        [RVSF] = TEAM_RVSF,
        [CLA_SPECT] = TEAM_CLA_SPECT,
        [RVSF_SPECT] = TEAM_RVSF_SPECT,
        [SPECT] = TEAM_SPECT,
        [NUM] = TEAM_NUM,
        [ANYACTIVE] = TEAM_ANYACTIVE
    },

    get_c_team = function(self,team)
        if self.c_team[team] ~= nil then
            return self.c_team[team]
        end
        return nil
    end,

    data = {},
    data_cn = {},

    chk_cn = function(self,cn)
        if self.data_cn[cn] ~= nil and self.data[self.data_cn[cn]] ~= nil and self.data[self.data_cn[cn]].cn == cn then
            return true
        end
        return false
    end,

    chk_login = function(self,cn)
        if self.data_cn[cn] ~= nil and self.data[self.data_cn[cn]] ~= nil and self.data[self.data_cn[cn]].login == true then
            return true
        end
        return false
    end,

    chk_admin = function(self,cn)
        if self:chk_cn(cn) and ( self.data[self.data_cn[cn]].role == self:get_role(ADMIN) or isadmin(cn)) then return true end
        return false
    end,
    chk_registered = function(self,cn)
        if self:chk_cn(cn) and self.data[self.data_cn[cn]].role == self:get_role(REGISTERED) then return true end
        return false
    end,
    chk_referee = function(self,cn)
        if self:chk_cn(cn) and self.data[self.data_cn[cn]].role == self:get_role(REFEREE) then return true end
        return false
    end,
    chk_root = function(self,cn)
        if self:chk_cn(cn) and self.data[self.data_cn[cn]].role == self:get_role(ROOT) then return true end
        return false
    end,
    chk_role = function(self,cn)
        if self:chk_cn(cn) and ( self.data[self.data_cn[cn]].role ~= self:get_role(DEFAULT) or isadmin(cn) ) then return true end
        return false
    end,
    chk_fool_role = function(self,cn)
        if self:chk_cn(cn) and ( self.data[self.data_cn[cn]].role == self:get_role(ADMIN) or self.data[self.data_cn[cn]].role == self:get_role(ROOT) or isadmin(cn)) then return true end
        return false
    end,
    chk_private_role = function(self,cn)
        if self:chk_cn(cn) and ( self.data[self.data_cn[cn]].role == self:get_role(ADMIN) or self.data[self.data_cn[cn]].role == self:get_role(ROOT) or self.data[self.data_cn[cn]].role == self:get_role(REFEREE) or isadmin(cn)) then return true end
        return false
    end,
    chk_show_mod = function(self,cn)
        if self:chk_cn(cn) and self.data[self.data_cn[cn]].show_mod == true then
            return true
        end
        return false
    end,

    set_role = function(self,cn,role)
        if self:chk_cn(cn) then
            local dcn = self.data_cn[cn]
            if type(role) == 'string' then role = self:get_role(role) end
            if role ~= nil then
                if self:get_role(role) ~= DEFAULT then
                    self.data[dcn].show_mod = true
                    self.data[dcn].old_role = self.data[dcn].role
                else
                    self.data[dcn].show_mod = false
                    self.data[dcn].old_role = role
                end
                self.data[dcn].role = role
                setrole(cn,role,false)
                if self.data[dcn].login and self.data[dcn].role > 0 then self.parent.sql:u_use_role(self.data[dcn].account.name,self.data[dcn].role) end
            end
        end
    end,

    get_role_cn = function(self,cn)
        if self:chk_cn(cn) then return self.data[self.data_cn[cn]].role end
        return nil
    end,

    get_old_role_cn = function(self,cn)
        if self:chk_cn(cn) then return self.data[self.data_cn[cn]].old_role end
        return nil
    end,

    get_name = function(self,cn)
        if self:chk_cn(cn) then
            return self.data[self.data_cn[cn]].name
        end
        return NOT_PLAYER
    end,

    get_ip = function(self,cn)
        if self:chk_cn(cn) then
            return self.data[self.data_cn[cn]].ip
        end
        return NOT_IP
    end,

    get_cname = function(self,cn)
        if self:chk_cn(cn) then
            return self.data[self.data_cn[cn]].c_name..self.data[self.data_cn[cn]].name
        end
        return NOT_PLAYER
    end,

    get_admin = function(self)
        for _,v in ipairs(self.data) do
            if self:chk_admin(v.cn) then return v.cn end
        end
        return nil
    end,

    get_fool_role_cn = function(self)
        local frcn = {}
        for _,v in ipairs(self.data) do
            if self:chk_fool_role(v.cn) then table.insert(frcn,v.cn) end
        end
        if #frcn == 0 then return nil
        else return frcn end
    end,

    get_private_role_cn = function(self)
        local frcn = {}
        for _,v in ipairs(self.data) do
            if self:chk_private_role(v.cn) then table.insert(frcn,v.cn) end
        end
        if #frcn == 0 then return nil
        else return frcn end
    end,

    get_cn = function(self,name)
        for _,v in ipairs(self.data) do
            if v.name == name then
                return v.cn
            end
        end
        return nil
    end,

    get_dcn = function(self,cn)
        if self:chk_cn(cn) then return self.data_cn[cn] end
        return nil
    end,

    get_priv = function(self,cn)
        return getpriv(cn)
    end,

    get_multipriv = function(self,cn)
        return getmultipriv(cn)
    end,

    use_score_of_maps = function(self,cn,score)
        if not self:chk_cn(cn) then return 0 end
        if score ~= nil then
            self.data[self.data_cn[cn]].account.score_of_maps = score
        else
            self.data[self.data_cn[cn]].account.score_of_maps = self.data[self.data_cn[cn]].account.score_of_maps + 1
        end
        return self.data[self.data_cn[cn]].account.score_of_maps

    end,

    use_uuid = function(self,cn,uuid)
        if not self:chk_cn(cn) then return '' end
        if uuid ~= nil then
            self.data[self.data_cn[cn]].account.uuid = uuid
        end
        return self.data[self.data_cn[cn]].account.uuid

    end,

    use_email = function(self,cn,email)
        if not self:chk_cn(cn) then return '' end
        if email ~= nil then
            self.data[self.data_cn[cn]].account.email = email
        end
        return self.data[self.data_cn[cn]].account.email

    end,

    use_login = function(self,cn,name,count)
        if not self:chk_cn(cn) then return '' end
        if name ~= nil then
            self.data[self.data_cn[cn]].account.name = name
            self:use_name_login(cn,name)
        end
        if count ~= nil then
            self.data[self.data_cn[cn]].account.count = count
        end
        return self.data[self.data_cn[cn]].account.name, self.data[self.data_cn[cn]].account.count

    end,

    use_name_login = function(self,cn,name)
        if not self:chk_cn(cn) then return '' end
        if name ~= nil then
            return usenamelogin(cn,name)
        else
            return usenamelogin(cn)
        end
    end,

    get_chk_data_cn = function(self,cn)
        if self:chk_cn(cn)  then
            self.parent.log:i('get_chk_data_cn',cn)
            self.parent.log:i(string.format('TABLE DATA_CN - CN: %s DCN: %s | TABLE DATA - Name: %s CN: %s DCN: %s | Role: %s status: %s | Show_mod: %s',cn,self.data_cn[cn],self.data[self.data_cn[cn]].name, self.data[self.data_cn[cn]].cn, self.data[self.data_cn[cn]].dcn, self:get_role(self.data[self.data_cn[cn]].role), tostring(self:chk_role(cn)), tostring(self:chk_show_mod(cn))))
        else
            self.parent.log:i('get_chk_data_cn in DATA',cn)
            for _,v in pairs(self.data) do
                self.parent.log:i(string.format('TABLE DATA_CN - CN: %s DCN: %s | TABLE DATA - Name: %s CN: %s DCN: %s | Role: %s status: %s | Show_mod: %s',v.cn,self.data_cn[v.cn],v.name, v.cn, v.dcn, self:get_role(v.role), tostring(self:chk_role(v.cn)), tostring(self:chk_show_mod(v.cn))))
            end
            self.parent.log:i('get_chk_data_cn in DATA_CN',cn)
            for i = 0, maxclient() -1 do
                if self.data_cn[i] ~= nil then
                    self.parent.log:i(string.format('TABLE DATA_CN - CN: %s DCN: %s | TABLE DATA - Name: %s CN: %s DCN: %s | Role: %s status: %s | Show_mod: %s',i,self.data_cn[i],self.data[self.data_cn[i]].name, self.data[self.data_cn[i]].cn, self.data[self.data_cn[i]].dcn, self:get_role(self.data[self.data_cn[i]].role), tostring(self:chk_role(i)), tostring(self:chk_show_mod(i))))
                end
            end
        end
    end,

    chk_role_status = function(self,cn)
        if self:chk_cn(cn) then
            self.parent.log:i(string.format('Player cn: %s, Role : %s, status: %s, Show_mod: %s',tostring(self.data[cn].cn),self:get_role(self.data[self.data_cn[cn]].role), tostring(self:chk_role(cn)), tostring(self:chk_show_mod(cn))))
            self.parent.log:i(string.format('Player cn: %s, Priv : %s, MultiPriv : %s, status: %s, Show_mod: %s',tostring(self.data[cn].cn),self:get_priv(cn),self:get_multipriv(cn), tostring(self:chk_role(cn)), tostring(self:chk_show_mod(cn))))
        else
            for _,v in ipairs(self.data) do
                self.parent.log:i(string.format('Player cn: %s, Role : %s, status: %s, Show_mod: %s',tostring(v.cn),self:get_role(v.role), tostring(self:chk_role(v.cn)), tostring(self:chk_show_mod(v.cn))))
                self.parent.log:i(string.format('Player cn: %s, Priv : %s, MultiPriv : %s, status: %s, Show_mod: %s',tostring(v.cn),self:get_priv(v.cn),self:get_multipriv(v.cn), tostring(self:chk_role(v.cn)), tostring(self:chk_show_mod(v.cn))))
            end
        end
    end,

    auto_kick_name = function(self,cn,name)
        sdbs.log:i('Check kick_name_list', cn)
        if self.parent.cnf.server.auto_kick.active then
            for _,v in ipairs(self.parent.cnf.server.auto_kick.list) do
                if self:get_d_reasson(self.parent.cnf.server.auto_kick.disc)~= nil and name:find(v) then
                    self.parent.log:w("Find name in kick_name_list OK",cn)
                    self.d_force.cn = cn
                    self.d_force.reasson = self:get_d_reasson(self.parent.cnf.server.auto_kick.disc)
                    if self.parent.cnf.server.auto_kick.say then
                        self.d_force.message = string.format(self.parent.cnf.server.auto_kick.message,name)
                    end
                    --self:force_disconnect()
                    return true
                end
            end
        end
        return false
    end,

    chk_same_and_old_same_name = function (self,cn,name)
        if #self.data > 0 and ( not self.parent.cnf.cn.name_same or not self.parent.cnf.cn.name_old_same ) then
            --self.parent.log:w("Name search ")
            for k,v in ipairs(self.data) do
                if cn ~= v.cn and k == v.dcn then
                    if not self.parent.cnf.cn.name_same then
                        --self.parent.log:w("Name search ".. v.name)
                        if string.lower(v.name) == string.lower(name) then
                            self.parent.log:w(string.format("Find name: %s in name list players = true",name),cn)
                            self.d_force.cn = cn
                            self.d_force.reasson = self:get_d_reasson('DUP')
                            if self.parent.cnf.cn.name_same_say then
                                self.d_force.message = string.format(self.parent.cnf.say.text.name_same_message,name)
                            end
                            return true
                        end
                    end
                    if not self.parent.cnf.cn.name_old_same then
                        if #v.oldname > 0 then
                            for _,vv in ipairs(v.oldname) do
                                -- self.parent.log:w("Oldname search "..vv..' name '..v.name,cn)
                                if string.lower(vv) == string.lower(name) then
                                    self.parent.log:w(string.format("Find name: %s in old name list players = true",name),cn)
                                    self.d_force.n = cn
                                    self.d_force.reasson = self:get_d_reasson('DUP')
                                    if self.parent.cnf.cn.name_old_same_say then
                                        self.d_force.message = string.format(self.parent.cnf.say.text.name_old_same_message,name)
                                    end
                                    return true
                                end
                            end
                        end
                    end
                end
            end
        end
        return false
        -- PLUGIN_BLOCK
    end,

    chk_ban_game = function(self,cn,name,ip)
        self.parent.log:i('chk_ban_game ...',cn)
        local flag, name, ip, reasson = false, name, ip, nil
        if #self.parent.gm.ban.list > 0 then
            for _,v in ipairs(self.parent.gm.ban.list) do
                if string.lower(name) == string.lower(v.name) then flag = true reasson = v.reasson break end
                if ip == v.ip then flag = true reasson = v.reasson break end
            end
            if flag then
                self.parent.log:w("chk_ban_game OK",cn)
                self.d_force.cn = cn
                self.d_force.reasson = self:get_d_reasson(reasson)
                --self:force_disconnect()
                return true
            end
        end
    end,

    on_preconnect = function(self,cn)
        sdbs.log:i('Preconnect...', cn)
        if isconnected(cn) then
            local name = getname(cn)
            local ip = self.parent.fn:reverse_ip(getrealip(cn))
            self.parent.log:i('Preconnect OK',cn)

            if self:chk_ban_game(cn,name,ip) then
                return  PLUGIN_BLOCK
            end

            if self:auto_kick_name(cn,name) then
                return  PLUGIN_BLOCK
            end
            if self:chk_same_and_old_same_name(cn,name) then
                return  PLUGIN_BLOCK
            end

            if self.parent.cnf.server.lock.active and #self.data > 0 then
                self.parent.log:w(string.format("Player: %s connect in server. Flag lock_server: %s",name,tostring(self.parent.cnf.server.lock.active)),cn)
                for _,v in ipairs(self.parent.cnf.server.lock.list) do
                    if name == v then
                        self.parent.log:w(string.format('NAME %s is on list Lock. NOT Lock',name ))
                        return true
                    end
                end
                self.d_force.cn = cn
                self.d_force.reasson = self:get_d_reasson(self.parent.cnf.server.lock.reasson)
                if self.parent.cnf.cn.name_same_say then
                    self.d_force.message = string.format(self.parent.cnf.server.lock.message,name)
                end
                return  PLUGIN_BLOCK
            end

            --[[if self:get_ban_type(cn) ~= PLUGIN_BLOCK then
                return  PLUGIN_BLOCK
            end]]

        else
            sdbs.log:w('Preconnect NO', cn)
            --return PLUGIN_BLOCK
            return
        end
    end,

    chk_gban = function(self,shost)
        if self.parent.cnf.server.ip_black.active then
            local shost = self.parent.fn:reverse_ip(shost)
            self.parent.log:w(string.format('CHK IP = %s on this msserver...',shost ))
            for _,v in ipairs(self.parent.cnf.server.ip_black.list) do
                if shost == v[1] then
                    self.parent.log:w(string.format('IP %s banned on this msserver',shost ))
                    if self:get_l_ban(v[2])~=nil and self:get_l_ban(v[3])~=nil and v[3] == 'NONE' then return false else return PLUGIN_BLOCK end
                end
            end
            return PLUGIN_BLOCK
        end
    end,

    -- (int actor_cn, string hostname, int host, string host, bool is_connecting)
    get_ban_type = function(self,cn, name, hostname, ihost, shost,connecting)
        if self.parent.cnf.server.ip_black.active then
            local shost = self.parent.fn:reverse_ip(shost)
            self.parent.log:w(string.format('Player %s, CHK IP = %s on this server...',name,shost ))
            for _,v in ipairs(self.parent.cnf.server.ip_black.list) do
                if shost == v[1] then
                    self.parent.log:w(string.format('Player %s, banned on this server | Ban type: %s | Disc reasson: %s',name, v[3], v[2] ))
                    if self:get_l_ban(v[2])~=nil and self:get_l_ban(v[3])~=nil and v[3] == 'NONE' then return self:get_l_ban(v[3]) end
                    self.d_force.cn = cn
                    self.d_force.reasson = self:get_d_reasson(v[2])
                    if self.parent.cnf.server.ip_black.say then
                        self.d_force.message = string.format(self.parent.cnf.server.ip_black.message,name, self.parent.fn:private_ip(shost))
                    end

                    self.d_force.root_message = string.format(self.parent.cnf.server.ip_black.message,name,shost)

                    --self:force_disconnect()
                    --return self:get_l_ban(v[3])
                end
            end
            return PLUGIN_BLOCK
        end
    end,

    chk_afk = function(self,name)
        if self.parent.cnf.server.afk.active then
            self.parent.log:w(string.format('CHK AFK = %s on this msserver...',name ))
            for _,v in ipairs(self.parent.cnf.server.afk.list) do
                if name == v then
                    self.parent.log:w(string.format('NAME %s is on list AFK. NOT Afk',name ))
                    return true
                end
            end
            return PLUGIN_BLOCK
        end
    end,

    tmr_enable_stopwatch = function(self,cn)

        self.data[self.data_cn[cn]].stopwatch.fn = function()
            local cn = cn
            sdbs.log:w('Player: '..sdbs.cn.data[sdbs.cn.data_cn[cn]].name..' CHECK tmr_stopwatch N = '..tostring(sdbs.cn.data[sdbs.cn.data_cn[cn]].stopwatch.n) )

            local sec,msec = math.modf((getsvtick() - sdbs.cn.data[sdbs.cn.data_cn[cn]].stopwatch.start_time)/1000)
            msec = math.floor(msec*1000)
            --sdbs.say:me(cn, string.format(sdbs.cnf.shell.stopwatch.text.message_0, sdbs.fn:format_stopwatch_time(sec,msec)))
            sdbs.say:me(cn, string.format(sdbs.cnf.shell.stopwatch.text.message_0, sdbs.fn:format_stopwatch_time(sec)))
        end

        if self.data[self.data_cn[cn]].stopwatch.enable and self.data[self.data_cn[cn]].stopwatch.period_say then
            if self.data[self.data_cn[cn]].stopwatch.n == nil then
                self.data[self.data_cn[cn]].stopwatch.n = TMR_STOPWATCH + tonumber(cn)
                tmr.create(self.data[self.data_cn[cn]].stopwatch.n, self.data[self.data_cn[cn]].stopwatch.period, self.data[self.data_cn[cn]].stopwatch.fn )
                self.parent.log:w('Player: '..self.data[self.data_cn[cn]].name..' CREATE tmr_stopwatch N = '..tostring(self.data[self.data_cn[cn]].stopwatch.n) )
            end
        end
    end,

    tmr_disable_stopwatch = function(self,cn)
        --if self.parent.cnf.cn.tmr_stopwatch_enable and self.parent.cnf.cn.tmr_stopwatch_say then
            if self.data[self.data_cn[cn]].stopwatch.n ~= nil then
                tmr.remove(self.data[self.data_cn[cn]].stopwatch.n)
                self.data[self.data_cn[cn]].stopwatch.n = nil
                self.data[self.data_cn[cn]].stopwatch.fn = nil
                self.parent.log:w('Player: '..self.data[self.data_cn[cn]].name..' REMOVE tmr_stopwatch N = '..tostring(TMR_STOPWATCH + tonumber(cn)) )
            end
        --end
    end,

    reset_staistic_map = function(self,cn,reset)
        local reset =  {
                reset_map = reset or 0,
                map = '',
                count = 0,
                count_score = 0,
                time_score = 0,
                time_score_old = 0,
                time_score_best = 0,
                time_score_best_old = 0,
                use_map_date = 0,
            }
        if cn ~= nil then
            local dcn =self:get_dcn(cn)
            if dcn ~= nil then
                self.data[dcn].account.statistic_map = reset
            end
        end
        return reset
    end,

    change_staistic_map = function(self,cn)
        local f, access = self.parent.sql:user_data_gema(cn)
            if f then
                if access~= nil and type(access) == 'string' then
                self.parent.say:me(cn,access)
                self.parent.cn.data[self.parent.cn.data_cn[cn]].account.statistic_map.map = self.parent.gm.map.name
                self.parent.cn.data[self.parent.cn.data_cn[cn]].account.statistic_map.count = 1
            else
                self.parent.cn.data[self.parent.cn.data_cn[cn]].account.statistic_map = access
            end
        else
            self.parent.say:me(cn,access)
        end
    end,

    reset_account = function(self,cn)

        local reset, dcn =  {
            name = '',
            uuid = '',
            email = '',
            count = 0,
            score_of_maps = 0,
            statistic_map = self:reset_staistic_map()
        }, self:get_dcn(cn)

        if dcn ~= nil then
            self:use_name_login(cn,'')
            self.data[dcn].account = reset
        end
        return reset
    end,

    add_cn = function(self,cn)
        self.parent.log:i('AddCn...',cn)
        if self.data_cn[cn] == nil then
            --if cn == 1 then setip(1,'212.20.45.40') end
            local name = getname(cn)
            local ip = self.parent.fn:reverse_ip(getrealip(cn))
            table.insert(self.data, {
                cn = cn,
                dcn = nil,
                name = name,
                c_name = SAY_INFO,
                oldname = {},
                count_rename = 0,
                count_old_name = 0,
                ip = ip,
                country = '',
                iso = '',
                city = '',
                geo = '',
                role = nil,
                old_role =nil,
                server = '',
                login = false,
                account = self:reset_account(),
                access = true,
                show_mod = false,
                gun = getweapon(cn),
                old_gun = self.parent.gm.weapon:get_gun(NUM),
                tmr_connect = {
                    n = nil,
                    fn = nil
                },
                stopwatch = {
                    n = nil,
                    fn = nil,
                    enable = false,
                    period = 5000,
                    period_say = false,
                    difftime_say = true,
                    start_time = 0,
                    stop_time = 0,
                    diff_time = 0,
                    active_flag = false,
                },
                flag = {
                    n = nil,
                    action = nil,
                    statistic_gema_flag = false
                },
                team = nil,
                spectate_to_go = false
            })

            local dcn = #self.data
            self.data_cn[cn] = dcn
            self.data[dcn].dcn = dcn
            self.data[dcn].team = getteam(cn)

            if self:get_multipriv(cn) ~= nil and self:get_multipriv(cn) > self:get_role(DEFAULT) then
                self.data[dcn].account.name = self:use_name_login(cn)
                local f,r = false,''
                if self.data[dcn].account.name ~= r then
                    f,r = self.parent.sql:get_user_account_data(self.data[dcn].account.name)
                end
                if not f or type(r) == 'string' then
                    self:set_role(cn,DEFAULT)
                else
                    self.data[dcn].login = true
                    self.data[dcn].show_mod = true
                    self:set_role(cn,self:get_multipriv(cn))
                    self.data[dcn].account.uuid = r.uuid
                    self.data[dcn].account.email = r.email
                    self.data[dcn].account.count = r['count_login_'..self.parent.flag.SERVER]
                    if self.parent.gm.map:is_gema_map() and self.parent.flag.SERVER == 'gema' and self.parent.gm.map:is_ctf_map() then
                        local f, d = self.parent.sql:user_data_gema(cn,true)
                        if f then
                            if d~= nil and type(d) == 'string' then
                                self.parent.say:me(cn,d)
                                self.parent.cn.data[dcn].account.statistic_map.map = self.parent.gm.map.name
                                self.parent.cn.data[dcn].account.statistic_map.count = 1
                            else
                                self.parent.cn.data[dcn].account.statistic_map = d
                            end
                        else
                            f, d = self.parent.sql:user_data_gema(cn)
                            if d~= nil and type(d) == 'string' then
                                self.parent.say:me(cn,d)
                                self.parent.cn.data[dcn].account.statistic_map.map = self.parent.gm.map.name
                                self.parent.cn.data[dcn].account.statistic_map.count = 1
                            else
                                self.parent.cn.data[dcn].account.statistic_map = d
                            end
                        end
                        self:use_score_of_maps(cn,self.parent.sql:user_data_gema_score(cn))
                        r = nil
                    end
                end
            else
                self.data[dcn].role = self:get_role(DEFAULT)
                self.data[dcn].old_role = self:get_role(DEFAULT)
            end

            self.data[dcn].stopwatch.enable = self.parent.cnf.shell.stopwatch.enable
            self.data[dcn].stopwatch.period = self.parent.cnf.shell.stopwatch.period
            self.data[dcn].stopwatch.period_say = self.parent.cnf.shell.stopwatch.period_say
            self.data[dcn].stopwatch.difftime_say = self.parent.cnf.shell.stopwatch.difftime_say

            if self.parent.cnf.cn.connect_set_color_name then
                self.data[dcn].c_name = self.parent.fn:random_color_cn()
            end

            local c_name = self.data[dcn].c_name

            self.data[dcn].server = self.parent.flag.SERVER

            if self.parent.cnf.geo.active then
                if self.parent.flag.geo_country then
                    self.data[dcn].country = geoip.ip_to_country(ip)
                    if self.data[dcn].country == 'unknown' then self.data[dcn].country = self.parent.cnf.geo.text.country_unknown end
                    self.data[dcn].iso = geoip.ip_to_country_code(ip)
                    if self.data[dcn].iso == 'n/a' then self.data[dcn].iso = self.parent.cnf.geo.text.iso_unknown end
                    if self.parent.cnf.geo.iso_say then
                        self.data[dcn].geo = string.format(self.parent.cnf.geo.text.iso, self.data[dcn].geo,self.data[dcn].iso)
                    end
                    if self.parent.cnf.geo.country_say then
                        self.data[dcn].geo = string.format(self.parent.cnf.geo.text.country, self.data[dcn].geo,self.data[dcn].country)
                    end
                end
                if self.parent.flag.geo_city then
                    self.data[dcn].city = geoip.ip_to_city(ip)
                    if self.data[dcn].city == '' then self.data[dcn].city = self.parent.cnf.geo.text.city_unknown end
                    if self.parent.cnf.geo.city_say then
                        self.data[dcn].geo = string.format(self.parent.cnf.geo.text.city, self.data[dcn].geo,self.data[dcn].city)
                    end
                end
            end

            if #self.data[dcn].geo > 0 then self.data[dcn].geo = self.data[dcn].geo:sub(0,#self.data[dcn].geo-2) end

            if self.parent.cnf.cn.connect_say then

                if self.parent.cnf.cn.connect_say_all then
                    for _,v in ipairs(self.data) do
                        if v.cn ~= cn and isconnected(v.cn) then
                            local show_mod = v.show_mod
                            v.show_mod = true
                            if self:chk_role(v.cn) and not self:chk_registered(v.cn) then
                                self.parent.say:to(cn,v.cn,string.format(self.parent.cnf.say.text.connect_all_chk_admin,c_name..self.data[dcn].name,self.data[dcn].geo,self.data[dcn].ip))
                            else
                                self.parent.say:to(cn,v.cn,string.format(self.parent.cnf.say.text.connect_all,c_name..self.data[dcn].name,self.data[dcn].geo))
                            end
                            v.show_mod = show_mod
                        end
                    end
                end

                if self.parent.cnf.cn.connect_say_me then

                    local key_about, map, gema, mode, autoteam  = '', '', '','',''

                    if self.parent.cnf.cn.connect_say_load_map then

                        map =string.format(self.parent.cnf.say.text.welcome_name_map, self.parent.gm.map.name)

                        if self.parent.cnf.cn.connect_say_load_map_gema and self.parent.gm.map:is_gema_map() then
                            gema = self.parent.cnf.say.text.atention_gema
                        end

                        if self.parent.cnf.cn.connect_say_autoteam then
                            if getautoteam() then
                                if self.parent.gm.map:is_gema_map() then
                                    autoteam = string.format(self.parent.cnf.say.text.autoteam, SAY_ENABLED_3)
                                else
                                    autoteam = string.format(self.parent.cnf.say.text.autoteam, SAY_ENABLED_0)
                                end
                            else
                                if self.parent.gm.map:is_gema_map() then
                                    autoteam = string.format(self.parent.cnf.say.text.autoteam, SAY_DISABLED_0)
                                else
                                    autoteam = string.format(self.parent.cnf.say.text.autoteam, SAY_DISABLED_3)
                                end
                            end
                        elseif self.parent.gm.map:is_gema_map() then
                            if getautoteam() then autoteam = string.format(self.parent.cnf.say.text.autoteam, SAY_ENABLED_3) end
                        end

                        if self.parent.cnf.cn.connect_say_load_map_mode then
                            mode = string.format(self.parent.cnf.say.text.game_mode, self.parent.gm.map.mode_str)
                        end
                    end

                    if self.parent.cnf.cn.connect_say_about or ( self.parent.cnf.cn.connect_say_rules_map and (self.parent.cnf.cn.connect_say_rules_map_gema or self.parent.cnf.cn.connect_say_rules_map_normal) ) then
                        key_about =  self.parent.cnf.say.text.key_about
                    end


                    self.data[dcn].tmr_connect.fn = function ()

                        local cn, dcn, c_name, name, key_about,map,mode,gema,autoteam = cn, dcn, c_name, name, key_about,map,mode,gema,autoteam

                        sdbs.log:w('RUN TMR tmr_connect_say_fn: cn '..tostring(cn)..' dcn: '..tostring(dcn))

                        if sdbs.cnf.cn.connect_say_about then
                            sdbs.say:me(cn, string.format('%s%s', sdbs.cnf.say.text.about, sdbs.cnf.say.text.about_message ))
                        end

                        if sdbs.cnf.cn.connect_say_rules_map then
                            if sdbs.gm.map:is_gema_map() and sdbs.cnf.cn.connect_say_rules_map_gema then
                                sdbs.say:me(cn, sdbs.cnf.say.text.rules_map_gema)
                            elseif not sdbs.gm.map:is_gema_map() and sdbs.cnf.cn.connect_say_rules_map_normal then
                                sdbs.say:me(cn, sdbs.cnf.say.text.rules_map)
                            end
                        end

                        sdbs.say:me(cn, string.format("%s%s%s%s",map,mode,gema,autoteam))

                        local show_mod = sdbs.cn.data[dcn].show_mod
                        sdbs.cn.data[dcn].show_mod = true

                        sdbs.say:me(cn, string.format(sdbs.cnf.say.text.connect_welcome,c_name..name,sdbs.cn.data[dcn].geo))

                        sdbs.cn.data[dcn].show_mod = show_mod
                        sdbs.say:me(cn, string.format("%s",key_about))

                        if sdbs.cn.data[dcn].tmr_connect.n ~= nil then
                            tmr.remove(sdbs.cn.data[dcn].tmr_connect.n)
                            sdbs.log:w('REMOVE TMR tmr_connect_say_fn N - '..tostring(sdbs.cn.data[dcn].tmr_connect.n),cn)
                            sdbs.cn.data[dcn].tmr_connect.n = nil
                        end
                        sdbs.cn.data[dcn].tmr_connect.fn = nil
                        --sdbs.cn.data[dcn].tmr_connect = nil
                    end

                    if self.parent.cnf.cn.connect_posts_delay and not flag_reloadmod() then
                        if  self.data[dcn].tmr_connect.n == nil then
                            self.data[dcn].tmr_connect.n = TMR_CONNECT_SAY + tonumber(cn)
                            tmr.create(self.data[dcn].tmr_connect.n,self.parent.cnf.cn.connect_posts_delay_time,sdbs.cn.data[dcn].tmr_connect.fn)
                            self.parent.log:w('CREATE TMR tmr_connect_say_fn N - '..tostring(self.data[dcn].tmr_connect.n),cn)
                        end
                    else
                         if not flag_reloadmod() then self.data[dcn].tmr_connect_say_fn() end
                    end
                    if flag_reloadmod() and not self.data[dcn].login then self.parent.say:me(cn, self.parent.cnf.say.text.reload_message) end

                end
            end

            self.parent.log:w('AddCn OK',cn)
            return true
        else
            self.parent.log:i('Not add data cn, cn ~= nil AddCn NO',cn)
            return false
        end
    end,

    on_connect = function(self,cn)
        sdbs.log:i('Connect...', cn)
        if isconnected(cn) then

            if self.d_force.cn ~= nil and self.d_force.cn == cn then
                self.parent.log:w('Connect NO. disconnect reasson: '..(self:get_d_reasson(self.d_force.reasson)),cn)
                self:force_disconnect(self.d_force.cn,self.d_force.reasson, self.d_force.message )
                return
                -- PLUGIN_BLOCK
            end
            -- FIX TMR_CONNECT NOT REMOVE OLD CN TMR
            self.parent.log:i('TMR_CONNECT FORCE REMOVE pre add cn',i)
            for i = TMR_CONNECT_SAY, (TMR_CONNECT_SAY + maxclient() -1) do
                tmr.remove(i)
            end

            self:add_cn(cn)
            self.parent.log:i('Connect OK',cn)
            if self.parent.flag.C_LOG then self:get_chk_data_cn() end

            self:server_log_visit_player_update(cn)

            return true
        else
            if self.parent.flag.C_LOG then self:get_chk_data_cn() end
            self.parent.log:w('Connect NO',cn)
            return false
        end
    end,

    force_disconnect = function(self,cn,reasson,message)
        self.parent.log:w('Force_disconnect',cn)
        if isconnected(cn) then
            callhandler('onPlayerDisconnect',cn,reasson)
            disconnect(cn,reasson)
            delclient(cn)
            --reloadas(cn)
            return true
        end
        return false
        -- PLUGIN_BLOCK
    end,

    remove_cn = function(self,cn,name)
        self.parent.log:i('RemoveCn....',cn)
        if self:chk_cn(cn) then

            -- if self.data[self.data_cn[cn]].tmr_connect ~= nil and self.data[self.data_cn[cn]].tmr_connect.n ~= nil then
            --     tmr.remove(self.data[self.data_cn[cn]].tmr_connect.n)
            -- end

            --if self.data[self.data_cn[cn]].tmr_stopwatch_active_flag then
                --self.parent.shell.commands['$stopwatch']:cfn(cn,{})
                --self:tmr_disable_stopwatch(cn)
            --end

            if not flag_reloadmod() then self.parent.shell.commands['$logout']:cfn(cn,{}) end
            --self.parent.shell.commands['$logout']:cfn(cn,{})

            for k,v in ipairs(self.data) do
                if cn == v.cn then
                    table.remove(self.data,k)
                    self.data_cn[cn] = nil
                    break
                end
            end
            for k,v in ipairs(self.data) do
                for i = 0, maxclient() - 1 do
                    if self.data_cn[i] ~= nil and i == v.cn then
                        self.data_cn[i] = k
                        self.data[k].dcn = k
                    end
                end
            end
            self.parent.log:i('RemoveCn OK',cn)
        else
            self.parent.log:w('Not is CN for remove data cn. RemoveCn NO',cn)
        end
    end,

    on_disconnect = function(self,cn,reasson)
        self.parent.log:i('Disconnect...',cn)
        if isconnected(cn) then
            self.parent.log:i('Disconnect is CN ok ...',cn)
            if self.parent.cnf.cn.disconnect_say then
                local name = nil
                if self:chk_cn(cn) then
                    name = self.data[self.data_cn[cn]].c_name..self.data[self.data_cn[cn]].name
                else
                    name = '\f3'..getname(cn) or 'NOT_NAME'
                end

                local say_disconnect = string.format(self.parent.cnf.say.text.disconnect_all,name)

                if self.parent.cnf.cn.disconnect_reasson_say then
                    say_disconnect = string.format('%s %s',say_disconnect, self.parent.cnf.say.text.disconnect_reasson )
                    local reasson = reasson
                    if reasson == -1 or reasson == nil or self:get_d_reasson(reasson) == 'NONE' or self:get_d_reasson(reasson) == 'unknown' then
                        if flag_reloadmod() then
                           reasson = 'RELOADMOD'
                        else
                           reasson = 'DISCONNECT'
                        end
                    else
                        reasson = self:get_d_reasson(reasson)
                    end
                    say_disconnect = string.format(say_disconnect, reasson )
                end

                local frcn = self:get_fool_role_cn()

                if frcn ~= nil and self.d_force.root_message ~= nil then
                    for _,v in ipairs(frcn) do
                        self.parent.say:me(v,string.format('%s \n%s',say_disconnect ,self.d_force.root_message))
                    end
                end

                if self.parent.cnf.cn.disconnect_say_message then
                    if self.d_force.message ~= nil then
                        say_disconnect = string.format('%s \n%s',say_disconnect ,self.d_force.message)
                    end
                end

                if frcn ~= nil and  self.d_force.root_message ~= nil then
                    for _,v in ipairs(self.data) do
                        if v.role < self:get_role(ROOT) and v.role ~= self:get_role(ADMIN) then
                            self.parent.say:me(v.cn,say_disconnect)
                        end
                    end
                else
                    self.parent.say:all(say_disconnect)
                end

            end

            -- FIX TMR_CONNECT NOT REMOVE OLD CN TMR
            self.parent.log:i('TMR_CONNECT FORCE REMOVE pre remove cn',i)
            for i = TMR_CONNECT_SAY, (TMR_CONNECT_SAY + maxclient() -1) do
                tmr.remove(i)
            end

            self:remove_cn(cn)

            if self.d_force.cn ~= nil then
                self.d_force.cn = nil
                self.d_force.reasson = nil
                self.d_force.message = nil
                self.d_force.root_message = nil
            end

            if self.parent.cnf.server.lock.active and #self.data == 0 then self.parent.cnf.server.lock.active = false  end

            self.parent.log:w('Disconnect OK',cn)
            if self.parent.flag.C_LOG then self:get_chk_data_cn() end
        else
            self.parent.log:w('Disconnect NO',cn)
            --if self.parent.flag.C_LOG then self:get_chk_data_cn() end
        end
        return true
    end,

    on_rename = function(self,cn,newname)
        self.parent.log:i('Rename...',cn)
        if self:chk_cn(cn) then
            local dcn = self.data_cn[cn]
            local c_name = self.data[dcn].c_name
            self.parent.log:i('Check rename...',cn)

            if self:auto_kick_name(cn,newname) then
                self:force_disconnect(self.d_force.cn,self.d_force.reasson,self.d_force.message)
                return--PLUGIN_BLOCK
            end

            if self.parent.cnf.cn.rename_chk_role and self:chk_role(cn) then
                self.parent.log:i('Check rename role. OK',cn)
                if self.parent.cnf.cn.rename_chk_role_say then self.parent.say:me(cn, string.format(self.parent.cnf.say.text.role_rename_message, c_name..self.data[dcn].name)) end
                --callhandler('onPlayerRoleChange',cn, self:get_role(DEFAULT))
                if self.data[dcn].access then self.data[dcn].access = false end
                self.parent.shell.commands['$logout']:cfn(cn,{})
                --return PLUGIN_BLOCK
            end

            if not self.parent.cnf.cn.rename then
                self.parent.log:w('Check rename. KICK OK',cn)
                self.d_force.cn = cn
                self.d_force.reasson = self:get_d_reasson('AUTOKICK')
                if self.parent.cnf.cn.not_rename_say then
                    self.d_force.message = string.format(self.parent.cnf.say.text.not_rename_message,c_name..self.data[dcn].name,newname)
                end
                self:force_disconnect(self.d_force.cn,self.d_force.reasson,self.d_force.message)
                return PLUGIN_BLOCK
                -- PLUGIN_BLOCK
            else
                if self.data[dcn].access then self.data[dcn].access = false end
            end

            if self:chk_same_and_old_same_name(cn,newname) then
                self:force_disconnect(cn,self.d_force.reasson,self.d_force.message)
                return  PLUGIN_BLOCK
            end

            for k,v in ipairs(self.data[dcn].oldname) do
                if v == self.data[dcn].name then
                    table.remove(self.data[dcn].oldname, k)
                end
            end
            table.insert(self.data[dcn].oldname,self.data[dcn].name)
            self.data[dcn].count_old_name = #self.data[dcn].oldname

            self.data[dcn].count_rename = self.data[dcn].count_rename + 1
            self.parent.log:w("Rename: ".. self.data[dcn].name..' to '..newname..' Count rename: '..self.data[dcn].count_rename.." Count OldName: "..self.data[dcn].count_old_name,cn)
            if self.parent.cnf.cn.rename_say then
                self.parent.say:allexme(cn,string.format(self.parent.cnf.say.text.rename_message,c_name..self.data[dcn].name,c_name..newname))
            end
            self.data[dcn].name = newname
            self.parent.log:i('Rename OK',cn)
        end
        return true
    end,

    on_role_change = function(self,cn, new_role, hash, pwd, isconnect)

        --print(cn) print(new_role) print(hash) print(pwd) print(isconnect)
        self.parent.log:i('Role change...',cn)
        if self:chk_cn(cn) then
            --self.parent.log:w(string.format('Change args: cn: %s, new_role: %s, hash: %s, pwd: %s, isconnect: %s',tostring(cn),self:get_role(new_role),tostring(hash),tostring(pwd),tostring(isconnect)),cn)

            local dcn = self.data_cn[cn]
            local name = self.data[dcn].name
            local c_name = self.data[dcn].c_name

            if not self.parent.cnf.cn.change_role and #self.data[dcn].oldname > 0 then
                if self.parent.cnf.cn.change_role_kick then
                    self.parent.log:w('Check role rename in role change. KICK OK',cn)
                    self.d_force.cn = cn
                    self.d_force.reasson = self:get_d_reasson('AUTOKICK')
                    if self.parent.cnf.cn.change_role_kick_say then
                        self.d_force.message = self.parent.cnf.say.text.role_rename_kick_message
                    end
                    self:force_disconnect(self.d_force.cn,self.d_force.reasson,self.d_force.message)
                    --return PLUGIN_BLOC
                else
                    if self.parent.cnf.cn.change_role_say then self.parent.say:me(cn, string.format(self.parent.cnf.say.text.role_rename_message, c_name..name)) end

                    if self:chk_admin(cn) and self.parent.cnf.cn.role_change_admin_say then self.parent.say:allexme(cn,string.format(self.parent.cnf.say.text.admin_role_change_admin_message_0,c_name..name)) end

                    if self.data[dcn].access then self.data[dcn].access = false end
                    --setrole(cn,self:get_role(DEFAULT),false)
                    self:set_role(cn, DEFAULT)

                    self.parent.shell.commands['$logout']:cfn(cn,{})

                    if self.parent.flag.C_LOG then self:chk_role_status() end
                    --return PLUGIN_BLOC
                end
            else
                if ( pwd == nil and has == nil ) or ( isconnect~=nil and isconnect ) then
                    if  new_role ~= self.data[dcn].role then
                        if new_role == self:get_role(ADMIN) then

                            if not isadmin(cn) then
                                local admin = self:get_admin()
                                if admin ~= nil then callhandler('onPlayerRoleChange',admin,self:get_role(DEFAULT)) end

                                    --setrole(cn,new_role,false)
                                    self:set_role(cn,ADMIN)
                                    if self.parent.cnf.cn.role_change_admin_say then self.parent.say:allexme(cn,string.format(self.parent.cnf.say.text.role_change_admin_message_1,c_name..name)) end
                            end

                        elseif  new_role == self:get_role(DEFAULT) then
                            if pwd == nil and has == nil then
                                if isadmin(cn) and self.parent.cnf.cn.role_change_admin_say then
                                    self.parent.say:allexme(cn,string.format(self.parent.cnf.say.text.role_change_admin_message_0,c_name..name))
                                end
                                --setrole(cn,new_role,false)
                                self:set_role(cn,DEFAULT)
                                self.parent.shell.commands['$logout']:cfn(cn,{})
                            end
                        else

                            if isadmin(cn) then
                                if self.parent.cnf.cn.role_change_admin_say then self.parent.say:allexme(cn,string.format(self.parent.cnf.say.text.role_change_admin_message_0,c_name..name)) end
                                --setrole(cn,self:get_role(DEFAULT),false)
                                self:set_role(cn,DEFAULT)
                            end

                            if new_role == self:get_role(ROOT) then
                                --setrole(cn,new_role,false)
                                self:set_role(cn, ROOT)

                            elseif new_role == self:get_role(REFEREE) then
                                --setrole(cn,new_role,false)
                                self:set_role(cn, REFEREE)

                            elseif new_role == self:get_role(REGISTERED) then
                                --setrole(cn,new_role,false)
                                self:set_role(cn, REGISTERED)
                            else
                                self.parent.shell.commands['$logout']:cfn(cn,{})
                            end

                        end

                        if self.parent.cnf.cn.role_change_me_say then self.parent.say:me(cn,string.format(self.parent.cnf.say.text.role_change_me_message_1,self:get_role(self.data[dcn].role))) end

                        if self.parent.flag.C_LOG then self:chk_role_status() end
                    else
                        self.parent.say:me(cn,string.format(self.parent.cnf.say.text.role_change_me_message_0,self:get_role(self.data[dcn].role) ) )
                    end
                end
            end

            self.parent.log:w(string.format('Role change OK. Role: %s, id_role: %g',self:get_role(self.data[dcn].role),tostring(self.data[dcn].role)),cn)
        else
            self.parent.log:w('Role change NO. not cn',cn)
        end
        --return true
        return PLUGIN_BLOCK
    end,

    -- CMD CHK COMMAND

    on_say_text = function (self,cn,text,team,mtype)
        if mtype == SV_TEXT then
            if not isconnected(cn) or not self:chk_cn(cn) then  return true end

            local dcn = self.data_cn[cn]
            local name = self.data[dcn].name
            local c_name = self.data[dcn].c_name

            --local show_mod = self.data[dcn].show_mod
            --self.data[dcn].show_mod = true

            local data = self.parent.fn:split(text, ' ')
            local command,args = string.lower(table.remove(data,1)), {}
            for _,v in ipairs(data) do
                if v~=nil and v~='' then
                    table.insert(args,v)
                end
            end

            if self.parent.shell.commands[command] ~= nil then

                if string.byte(command,1) ~= string.byte("$",1) then
                    self.parent.say:me(cn,self.parent.cnf.say.text.chk_commands_fix_message)
                    return PLUGIN_BLOCK
                end

                local shell = self.parent.shell.commands[command]

                if ( self:chk_admin(cn) and shell.protected[1]) or ( self:chk_root(cn) and shell.protected[2]) or ( self:chk_referee(cn) and shell.protected[3] ) or ( self:chk_registered(cn) and shell.protected[4] ) or shell.protected[5] then
                    if shell.protected[6] then return PLUGIN_BLOCK end
                    local ret = shell:cfn(cn, args)
                    if ret == PLUGIN_RELOAD_BLOCK or ret == PLUGIN_LOAD_BLOCK or ret == PLUGIN_UNLOAD_BLOCK or ret == PLUGIN_BLOCK then
                        return ret
                    else
                        return PLUGIN_BLOCK
                    end
                else
                    self.parent.say:me(cn,self.parent.cnf.say.text.chk_commands_not_alloved_message)
                    return PLUGIN_BLOCK
                end

            elseif string.byte(command,1) == string.byte("$",1) then
                self.parent.say:me(cn,self.parent.cnf.say.text.chk_commands_fix_message)
                return PLUGIN_BLOCK
            end

            --self.data[dcn].show_mod = show_mod

            if self.parent.cnf.show_mod then

                text = string.format('%s%s',self.parent.cnf.say.text.color,text)

                if self.parent.cnf.cn.connect_set_cn_name then
                    --name = string.format(self.parent.cnf.cn.connect_set_cn_name_format,tostring(cn),name)
                    name = string.format(self.parent.cnf.cn.connect_set_cn_name_format,tostring(cn),name,self.parent.cnf.say.text.color_name_text_delemiter)
                else
                    --name = string.format(self.parent.cnf.cn.connect_set_default_name_format,name)
                    name = string.format(self.parent.cnf.cn.connect_set_default_name_format,name,self.parent.cnf.say.text.color_name_text_delemiter)
                end
                text = string.format('%s%s%s',c_name,name,text)
                self.parent.say:allexme(cn,self.parent.fn:format_say_text_out(text))
                --self.parent.say:allexme(cn,text)
                return PLUGIN_BLOCK
            end
        end
        return true
    end,

    on_player_team_change = function(self,cn,new_team,forceteam_reason)
        if self:chk_cn(cn) then
            local dcn = self:get_dcn(cn)
            self.data[dcn].team = new_team
            if self:get_c_team('SPECT') == new_team or self:get_c_team('CLA_SPECT') == new_team or self:get_c_team('RVSF_SPECT') == new_team then
                if self.data[dcn].stopwatch.active_flag then
                    local difftime_say = self.data[dcn].stopwatch.difftime_say
                    self.data[dcn].stopwatch.difftime_say = false
                    self.parent.shell.commands['$sw']:cfn(cn,{})
                    self.data[dcn].stopwatch.difftime_say = difftime_say
                end
                if self.parent.gm.map:is_gema_map() and self.parent.sv:is_gema() and self.parent.gm.map:is_ctf_map() and self:chk_role(cn) then
                    self.data[dcn].spectate_to_go = true
                end
                return
            end
            if ( self:get_c_team('RVSF') == new_team and self.data[dcn].spectate_to_go ) or ( self:get_c_team('CLA') == new_team and self.data[dcn].spectate_to_go ) then
                self.data[dcn].spectate_to_go = false
                self.parent.shell.commands['$go']:cfn(cn,{})
                return
            end
        end
    end,

    on_player_weapon_change = function(self,cn,weapon)
        local dcn = self:get_dcn(cn)
        if dcn ~= nil then
            self.data[dcn].old_gun = self.data[dcn].gun
            self.data[dcn].gun = weapon
        end
    end,

    server_log_visit_player_update = function(self,cn)

        if self.parent.cnf.server.log.active and self.parent.cnf.server.log.player.active then
            self.parent.sql:server_log_visit_player_update(self.parent.flag.SERVER,self:get_name(cn),self:get_ip(cn))
        end

    end,

    init = function(self,obj)
        self.parent = obj
        --self.parent = setmetatable( {}, { __index = obj } )
        --self.parent = setmetatable( {}, { __index = obj, __newindex = obj } )
        self.parent.log:w('Module cn init OK')
    end

}
