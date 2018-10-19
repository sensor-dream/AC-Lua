-- комманды

return {

    commands = {

        -- params: { admin allow, root allow, referee allow, registered allow, aviable allow, command not execute, wisible in list, colorize char }

        -- AVIABLE --

        ['~about'] = '',['!about'] = '',['@about'] = '',['#about'] = '',['%about'] = '',['^about'] = '',
        ["$about"] = {
            protected = { true, true, true, true, true, false, true },
            name = 'about',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                if #args > 0 and self.parent.fn:trim(args[1]) == '-h' then self.parent.say:me(cn,self.parent.cnf.shell.text[self.name..'_help']) return true end
                self.parent.say:me(cn, self.parent.cnf.say.text.about)
                if self.parent.gm.map:is_gema_map() then
                    self.parent.say:me(cn, self.parent.cnf.say.text.rules_map_gema)
                else
                    self.parent.say:me(cn, self.parent.cnf.say.text.rules_map)
                end
                    self.parent.say:me(cn, self.parent.cnf.say.text.key_about)
            end
        },

        ['~help'] = '',['!help'] = '',['@help'] = '',['#help'] = '',['%help'] = '',['^help'] = '',
        ["$help"] = {
            protected = { true, true, true, true, true, false, true },
            name = 'help',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                self.parent.say:me(cn,self.parent.cnf.shell.text[self.name..'_text'])
            end
        },

        ['~version'] = '',['!version'] = '',['@version'] = '',['#version'] = '',['%version'] = '',['^version'] = '',
        ["$version"] = {
            protected = { true, true, true, true, true, false, true },
            name = 'version',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                self.parent.say:me(cn,string.format(self.parent.cnf.shell.text[self.name..'_help_0'],PLUGIN_NAME, PLUGIN_AUTHOR, PLUGIN_VERSION))
                self.parent.say:me(cn,string.format(self.parent.cnf.shell.text[self.name..'_help_1'], PLUGIN_SITE, PLUGIN_EMAIL, PLUGIN_DESCRIPTION))
                self.parent.say:me(cn,string.format(self.parent.cnf.shell.text[self.name..'_help_2'], self.shell.count.fool, self.shell.count.show, self.shell.count.hidden))
            end
        },

        ['~shell'] = '',['!shell'] = '',['@shell'] = '',['#shell'] = '',['%shell'] = '',['^shell'] = '',
        ["$shell"] = {
            protected = { true, true, true, true, true, false, true, true },
            name = 'shell',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                if #args >=1 and self.parent.fn:trim(args[1]) == '-h' then self.parent.say:me(cn,self.parent.cnf.shell.text[self.name..'_help']) return true end
                self.parent.say:me(cn,self.parent.cnf.shell.text[self.name..'_text'])
                local r,p = self.parent.cn:get_role_cn(cn), ''

                local function print_shell(tab,p)
                    local l,c,i  = {{}},1,1
                    for _,v in ipairs(tab) do
                        if i > self.parent.cnf.shell.count_command_in_one_string then
                            c = c + 1
                            l[c] = {}
                            i = 1
                        end
                        table.insert(l[c],v)
                        i = i + 1
                    end
                    i = 1
                    for k,v in ipairs(l) do
                        if k > 1 then
                            self.parent.say:me(cn,table.concat(v,' \f4| '))
                        else
                            self.parent.say:me(cn,string.format('%s%s',p or '',table.concat(v,' \f4| ')))
                        end
                    end
                end

                if r == CR_ADMIN then r = CR_ROOT + 1 end
                if r > CR_DEFAULT then
                    for k,v in ipairs(self.shell.list) do
                        --if r >= k then self.parent.say:me(cn,'\f0+> \f2'..v:sub(0,#v-7)) else self.parent.say:me(cn,'\f3-> '..v:sub(0,#v-7)) end
                        if r >= k then
                            p = '\f0+> '
                        else
                            p = '\f3-> '
                        end
                        print_shell(v,p)
                    end
                else
                    print_shell(self.shell.list[CR_ADMIN])
                end
            end
        },

        ['pm'] = '',['~pm'] = '',['!pm'] = '',['@pm'] = '',['#pm'] = '',['%pm'] = '',['^pm'] = '',
        ["$pm"] = {
            protected = { true, true, true, true, true, false, true },
            name = 'pm',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                if #args >= 1 then
                    if args[1] == '-h' then self.parent.say:me(cn,self.parent.cnf.shell.text[self.name..'_help']) return true end
                    local tcn, text = tonumber(args[1]), table.concat(args, " ", 2)
                    if not isconnected(tcn) or not self.parent.cn:chk_cn(tcn) then self.parent.say:me(cn,self.parent.cnf.shell.text[self.name..'_error_cn']) return true end
                    local dcn = self.parent.cn.data_cn[cn]
                    local name = self.parent.cn.data[dcn].name
                    local c_name = self.parent.cn.data[dcn].c_name
                    text = string.format('%s%s',self.parent.cnf.say.text.color,text)
                    if self.parent.cnf.cn.connect_set_cn_name then
                        name = string.format(self.parent.cnf.cn.connect_set_cn_name_format,tostring(cn),name,self.parent.cnf.say.text.color_name_text_delemiter)
                    else
                        name = string.format(self.parent.cnf.cn.connect_set_default_name_format,name,self.parent.cnf.say.text.color_name_text_delemiter)
                    end
                    self.parent.say:to(cn,tcn,string.format('%s%s%s',self.parent.cnf.say.text.privat_prefix,c_name,name))
                    self.parent.say:to(cn,tcn,self.parent.fn:format_say_text_out(text))
                    return
                end
                self.parent.say:me(cn,string.format(self.parent.cnf.shell.text.shell_error,self.name)) return
            end
        },

        ['~role'] = '',['!role'] = '',['@role'] = '',['#role'] = '',['%role'] = '',['^role'] = '',
        ["$role"] = {
            protected = { true, true, true, true, true, false, true  },
            name= 'role',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                local dcn = self.parent.cn:get_dcn(cn)
                if #args == 0 and dcn ~= nil then self.parent.say:me(cn,string.format(self.parent.cnf.shell.text[self.name..'_text'],self.parent.cnf.shell.text.role[self.parent.cn.data[dcn].role])) return end
                if #args == 1 then
                    if args[1] == '-h' then self.parent.say:me(cn,self.parent.cnf.shell.text[self.name..'_help']) return end
                    if tonumber(args[1])~= nil then
                        if self.parent.cn:chk_private_role(cn) then
                            local cdcn = self.parent.cn:get_dcn(tonumber(args[1]))
                            if cdcn == nil then self.parent.say:me(cn,string.format(self.parent.cnf.shell.text[self.name..'_error_cn'],args[1])) return end
                            self.parent.say:me(cn,string.format(self.parent.cnf.shell.text[self.name..'_for_cn_text'],args[1],self.parent.cn:get_role(self.parent.cn.data[cdcn].role))) return
                        end
                        self.parent.say:me(cn,self.parent.cnf.shell.text[self.name..'_not_access']) return
                    end
                end
                self.parent.say:me(cn,string.format(self.parent.cnf.shell.text.shell_error,self.name))
            end
        },

        ['`login'] = '', ['~login'] = '', ['!login'] = '',['@login'] = '',['#login'] = '',['%login'] = '',['^login'] = '',['&login'] = '', ['1login'] = '',['2login'] = '',['3login'] = '',['4login'] = '',['5login'] = '',['6login'] = '',['7login'] = '',['login'] = '',['t$login'] = '',
        ["$login"] = {
            protected = { true, true, true, true, true, false, true, true  },
            name= 'login',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                if #args >= 1 then
                    if args[1] == '-h' then self.parent.say:me(cn,self.parent.cnf.shell.text[self.name..'_help']) return end
                    self.shell.commands['$su']:cfn(cn,{ cn, args[1] })
                    return

                end
                self.parent.say:me(cn,string.format(self.parent.cnf.shell.text.shell_error,self.name)) return
            end
        },

        ['reg'] = '',['~reg'] = '',['!reg'] = '',['@reg'] = '',['#reg'] = '',['%reg'] = '',['^reg'] = '',
        ["$reg"] = {
            protected = { true, true, true, true, true, false, true, true  },
            name= 'reg',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                if #args >= 1 then
                    local dcn = self.parent.cn:get_dcn(cn)
                    if args[1] == '-h' then self.parent.say:me(cn,self.parent.cnf.shell.text[self.name..'_help']) return end
                    if self.parent.cn.data[dcn].access then
                        if args[2] == nil then
                            self.parent.say:me(cn,self.parent.cnf.shell.text[self.name..'_error_email'])
                            return
                        end
                        if self.shell.commands['$useradd']:cfn(cn,{self.parent.cn.data[dcn].name, REGISTERED, args[1],args[2]}) then
                            self.shell.commands['$login']:cfn(cn,{args[1]})
                        end
                    else
                        self.parent.say:me(cn,self.parent.cnf.shell.text[self.name..'_error'])
                    end
                    return
                end
                self.parent.say:me(cn,string.format(self.parent.cnf.shell.text.shell_error,self.name)) return
            end
        },

        ['~exit'] = '',['!exit'] = '',['@exit'] = '',['#exit'] = '',['%exit'] = '',['^exit'] = '',
        ["$exit"] = {
            protected = { true, true, true, true, true, false, true  },
            name= 'exit',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                if #args >= 1 then
                    if args[1] == '-h' then self.parent.say:me(cn,self.parent.cnf.shell.text[self.name..'_help']) return end
                end
                self.parent.cn:force_disconnect(cn,self.parent.cn:get_d_reasson('NONE'))
            end
        },

        ['~map'] = '',['!map'] = '',['@map'] = '',['#map'] = '',['%map'] = '',['^map'] = '',
        ["$map"] = {
            protected = { true, true, true, true, true, false , true },
            name = 'map',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                if #args >= 1 then
                    local dcn, cnf = self.parent.cn.data_cn[cn], self.parent.cnf.shell[self.name]
                    local text = cnf.text
                    if args[1] == '-h' then self.parent.say:me(cn,text['help']) return end
                    if ((args[1] == '-th') or (args[1] == '-t' and (args[2] ~= nil and args[2] == '-h'))) then self.parent.say:me(cn,text['time_help']) return end
                    if ((args[1] == '-ch') or (args[1] == '-c' and (args[2] ~= nil and args[2] == '-h'))) then self.parent.say:me(cn,text['count_help']) return end
                    if ((args[1] == '-crh') or (args[1] == '-cr' and (args[2] ~= nil and args[2] == '-h'))) then self.parent.say:me(cn,text['count_rot_help']) return end
                    if ((args[1] == '-cgh') or (args[1] == '-cg' and (args[2] ~= nil and args[2] == '-h'))) then self.parent.say:me(cn,text['count_gema_help']) return end
                    if ((args[1] == '-crgh') or (args[1] == '-crg' and (args[2] ~= nil and args[2] == '-h'))) then self.parent.say:me(cn,text['count_rot_gema_help']) return end
                    if ((args[1] == '-nrh') or (args[1] == '-nr' and (args[2] ~= nil and args[2] == '-h'))) then self.parent.say:me(cn,text['next_help']) return end
                    if ((args[1] == '-nrih') or (args[1] == '-nri' and (args[2] ~= nil and args[2] == '-h'))) then self.parent.say:me(cn,text['next_help']) return end
                    if ((args[1] == '-prh') or (args[1] == '-pr' and (args[2] ~= nil and args[2] == '-h'))) then self.parent.say:me(cn,text['prev_help']) return end
                    if ((args[1] == '-prih') or (args[1] == '-pri' and (args[2] ~= nil and args[2] == '-h'))) then self.parent.say:me(cn,text['prev_help']) return end
                    if ((args[1] == '-ih') or (args[1] == '-i' and (args[2] ~= nil and args[2] == '-h'))) then self.parent.say:me(cn,text['info_help_0']) return end
                    if ((args[1] == '-dh') or (args[1] == '-d' and (args[2] ~= nil and args[2] == '-h'))) then self
                        .parent.say:me(cn,text['info_help_1']) return end
                    if ((args[1] == '-toph') or (args[1] == '-top' and (args[2] ~= nil and args[2] == '-h'))) then
                        self.parent.say:me(cn,string.format(text['top_best_help'],cnf.statistic_limit_out))
                        self.parent.say:me(cn,string.format(text['top_gbest_help'],cnf.statistic_limit_out))
                        return
                    end
                    if (args[1] == '-top' and ( args[2] ~= nil and ( args[2] == '-besth' or ( args[2] == '-best' and (args[3] ~= nil and args[3] == '-h') ) ) ) ) then
                        self.parent.say:me(cn,string.format(text['top_best_help'],cnf.statistic_limit_out))
                        return
                    end
                    if (args[1] == '-top' and ( args[2] ~= nil and ( args[2] == '-gbesth' or ( args[2] == '-gbest' and (args[3] ~= nil and args[3] == '-h') ) ) ) ) then
                        self.parent.say:me(cn,string.format(text['top_gbest_help'],cnf.statistic_limit_out))
                        return
                    end
                    if args[1] == '-t' then
                        if args[2] ~= nil then
                            args[2] = tonumber(args[2])
                            if args[2] ~= nil and args[2] >= 0 and args[2] <= 60  and ( isadmin(cn) or self.parent.cn:get_role_cn(cn) > self.parent.cn:get_role(DEFAULT) ) then
                                --settimeleftmillis(1)
                                settimeleft(args[2])
                                self.parent.say:me(cn,string.format(text['time_new'],args[2]))
                                return
                            else
                                self.parent.say:me(cn,text['access_not_permited']) return
                            end
                        else
                            self.parent.say:me(cn,string.format(text['time_current'],gettimeleft()))
                            return
                        end
                    end
                    if args[1] == '-nr' or args[1] == '-nri' or args[1] == '-pr' or args[1] == '-pri' then
                        local wholemaprot = getwholemaprot()
                        local countwholemaprot = #wholemaprot
                        local name,mode,time = nil, nil, nil
                        for k,v in ipairs(wholemaprot) do
                            if v.map == self.parent.gm.map.name then
                                if args[1] == '-nr' or args[1] == '-nri' then
                                    if wholemaprot[k+1] ~= nil then
                                        name,mode,time = wholemaprot[k+1].map, wholemaprot[k+1].mode, wholemaprot[k+1].time
                                    else
                                        name,mode,time = wholemaprot[1].map, wholemaprot[1].mode, wholemaprot[1].time
                                    end
                                end
                                if args[1] == '-pr' or args[1] == '-pri' then
                                    if wholemaprot[k-1] ~= nil then
                                        name,mode,time = wholemaprot[k-1].map, wholemaprot[k-1].mode, wholemaprot[k-1].time break
                                    else
                                        name,mode,time = wholemaprot[countwholemaprot].map, wholemaprot[countwholemaprot].mode, wholemaprot[countwholemaprot].time
                                    end
                                end
                                break
                            elseif k == countwholemaprot and v.map ~= self.parent.gm.map.name then
                                name,mode,time = wholemaprot[1].map, wholemaprot[1].mode, wholemaprot[1].time
                            end
                        end
                        if args[1] == '-nri' then
                            self.parent.say:me(cn,string.format(text['map_info'],'next',name,self.parent.gm.mode:get(mode),tostring(time)))
                            return
                        end
                        if args[1] == '-pri' then
                            self.parent.say:me(cn,string.format(text['map_info'],'previous',name,self.parent.gm.mode:get(mode),tostring(time)))
                            return
                        end
                        if ( isadmin(cn) or self.parent.cn:get_role_cn(cn) > self.parent.cn:get_role(REGISTERED) ) and ( args[1] == '-nr' or args[1] == '-pr' ) then
                            changemap(name,mode,time)
                            self.parent.gm.map:on_map_change(name,mode)
                        else
                            self.parent.say:me(cn,text['access_not_permited'])
                        end
                        return
                    end
                    if args[1] == '-c' and args[2] == nil then
                        self.parent.say:me(cn,string.format(text['count_text'],tostring(self.parent.gm.map:get_cmaps())))
                        return
                    end
                    if args[1] == '-cg' and args[2] == nil then
                        self.parent.say:me(cn,string.format(text['count_gema_text'],tostring(self.parent.gm.map:get_cgmaps())))
                        return
                    end
                    if args[1] == '-cr' and args[2] == nil then
                        self.parent.say:me(cn,string.format(text['count_rot_text'],tostring(self.parent.gm.map:get_crmaps())))
                        return
                    end
                    if args[1] == '-crg' and args[2] == nil then
                        self.parent.say:me(cn,string.format(text['count_rot_gema_text'],tostring(self.parent.gm.map:get_crgmaps())))
                        return
                    end
                    if ( args[1] == '-d' and args[2] == nil )  or ( args[1] == '-d' and args[2] ~= nil and args[2]== '-all') then
                        if self.parent.cn:get_role_cn(cn) > self.parent.cn:get_role(DEFAULT) then
                            if self.parent.gm.map:is_gema_map() and self.parent.sv:is_gema() then
                                if self.parent.gm.map:is_ctf_map() then
                                    local dcn = self.parent.cn:get_dcn(cn)
                                    if dcn ~= nil then
                                        local f,r,d = nil,nil,true
                                        if args[2] ~= nil and args[2]== '-all' then d = nil end
                                        f,r =  self.parent.sql:delete_user_data_gema(self.parent.cn.data[dcn].account.uuid,d)
                                        self.parent.cn:reset_staistic_map(cn,1)
                                        --self.parent.cn:change_staistic_map(cn)
                                        self.parent.say:me(cn,r) return
                                    end
                                else
                                    self.parent.say:me(cn,text['not_ctf'])
                                end
                            else
                                self.parent.say:me(cn,text['not_gema'])
                            end
                            return
                        else
                            self.parent.say:me(cn,text['access_not_permited'])
                        end
                        return
                    end
                    if args[1] == '-i' then
                        if self.parent.cn:get_role_cn(cn) > self.parent.cn:get_role(DEFAULT) then
                            if self.parent.gm.map:is_gema_map() and self.parent.sv:is_gema() then
                                if self.parent.gm.map:is_ctf_map() then
                                    local f,data =nil, self.parent.cn.data[dcn].account
                                    if args[2] ~= nil then
                                        local dcn = self.parent.cn:get_dcn(tonumber(args[2]))
                                        if dcn ~= nil then
                                            if self.parent.cn.data[dcn].account.uuid ~= '' then
                                                data = self.parent.cn.data[dcn].account
                                            else
                                                f,data = self.shell.commands['$userdata']:cfn(cn,{'-i',self.parent.cn.data[dcn].name})
                                                if not f then
                                                    self.parent.say:me(cn,data) return
                                                end
                                            end
                                        else
                                            f,data = self.shell.commands['$userdata']:cfn(cn,{'-i',args[2]})
                                            if not f then
                                                self.parent.say:me(cn,data) return
                                            end
                                        end
                                    end
                                    self.parent.say:me(cn,string.format(self.parent.cnf.gameplay.statistic.text.info_visits_gema,data.count,data.score_of_maps,self.parent.gm.map:get_cgmaps(),self.parent.fn:math_round(((data.score_of_maps*100)/self.parent.gm.map:get_cgmaps()),3),'%'))
                                    if type(data.statistic_map) == 'string' then self.parent.say:me(cn,data.statistic_map) return end
                                    self.parent.say:me(cn,string.format(self.parent.cnf.gameplay.statistic.text.info_change_map_say_me,data.statistic_map.count,self.parent.fn:format_stopwatch_time(self.parent.fn:get_sec_ms_time(data.statistic_map.time_score)),self.parent.fn:format_stopwatch_time(self.parent.fn:get_sec_ms_time(data.statistic_map.time_score_best)),data.statistic_map.count_score))

                                    f  = self.parent.sql:get_user_data_gema_info_position_list_best_time(self.parent.cn.data[dcn].account.uuid,self.parent.gm.map.name)
                                    if f > 0 then
                                        self.parent.say:me(cn,string.format(self.parent.cnf.gameplay.statistic.text.info_position_list_best_time,f))
                                    end
                                else
                                    self.parent.say:me(cn,text['not_ctf'])
                                end
                            else
                                self.parent.say:me(cn,text['not_gema'])
                            end
                            return
                        else
                            self.parent.say:me(cn,text['access_not_permited'])
                        end
                        return
                    end
                    if args[1] == '-top' then
                        if self.parent.cn:get_role_cn(cn) > self.parent.cn:get_role(DEFAULT) then
                            if self.parent.gm.map:is_gema_map() and self.parent.sv:is_gema() then
                                if self.parent.gm.map:is_ctf_map() then
                                    local dcn = self.parent.cn:get_dcn(cn)
                                    if dcn ~= nil then
                                        local f,r,g = nil,nil,false
                                        if args[2] ~= nil and ( args[2]== '-best' or args[2]== '-gbest' ) then
                                            if tonumber(args[3])~=nil and tonumber(args[3]) > 0 then args[3] = tonumber(args[3]) else args[3]= cnf.statistic_limit_out end
                                            --[[if args[2]== '-best' then
                                                f,r =  self.parent.sql:get_map_top({['uuid'] = self.parent.cn.data[dcn].account.uuid,['best']=true,limit=args[3]})
                                            end]]
                                            if args[2]== '-best' then
                                                f,r =  self.parent.sql:get_map_top({best=true,map=self.parent.gm.map.name,limit=args[3]})
                                                -- r = `name`,`map`,`uuid`,`count`,`count_score`,`time_score`,`time_score_best`
                                                -- r.name == name_registered т.е. кто зарегестрировался а не текущее имя игрока или пользователя в системе
                                                --Name: %s, Best time: %s, Current time: %s, Score: %s, Visits: %s
                                            end
                                            if f then
                                                local otext,cgm = nil, self.parent.gm.map:get_cgmaps()

                                                for _,vv in ipairs(r) do
                                                    otext = string.format(text['top_best_text'],vv.name,self.parent.fn:format_stopwatch_time(self.parent.fn:get_sec_ms_time(vv.time_score_best)))
                                                    if cnf.top_best_current_time_say then otext = otext..string.format(text['top_best_text_cureent_time'],self.parent.fn:format_stopwatch_time(self.parent.fn:get_sec_ms_time(vv.time_score))) end
                                                    if cnf.top_best_score_say then
                                                       otext = otext..string.format(text['top_best_text_score'],vv.count_score--[[,cgm,self.parent.fn:math_round(((vv.count_score*100)/cgm),3),'%']])
                                                    end
                                                    if cnf.top_best_visits_say then otext = otext..string.format(text['top_best_text_visits'],vv.count) end

                                                    self.parent.say:me(cn,otext)

                                                end
                                                return
                                            else
                                                self.parent.say:me(cn,text['map_info_not_statistic'])
                                                return
                                            end
                                        end
                                    end
                                else
                                    self.parent.say:me(cn,text['not_ctf'])
                                    return
                                end
                            else
                                self.parent.say:me(cn,text['not_gema'])
                                return
                            end
                        else
                            self.parent.say:me(cn,text['access_not_permited'])
                            return
                        end
                    end
                end
                self.parent.say:me(cn,string.format(self.parent.cnf.shell.text.shell_error,self.name))
            end
        },

        ['~infoprevmap'] = '',['!infoprevmap'] = '',['@infoprevmap'] = '',['#infoprevmap'] = '',['%infoprevmap'] = '',['^infoprevmap'] = '',
        ["$infoprevmap"] = {
            protected = { true, true, true, true, true, false, true },
            name = 'infoprevmap',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                if #args == 1 and args[1] == '-h' then self.shell.commands['$map']:cfn(cn,{ '-pr', args[1] }) return end
                if #args == 0 then self.shell.commands['$map']:cfn(cn,{ '-pri' }) return end
                self.shell.commands['$map']:cfn(cn,{})
            end
        },

        ['~infonextmap'] = '',['!infonextmap'] = '',['@infonextmap'] = '',['#infonextmap'] = '',['%infonextmap'] = '',['^infonextmap'] = '',
        ["$infonextmap"] = {
            protected = { true, true, true, true, true, false, true },
            name = 'infonextmap',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                if #args == 1 and args[1] == '-h' then self.shell.commands['$map']:cfn(cn,{ '-nr', args[1] }) return end
                if #args == 0 then self.shell.commands['$map']:cfn(cn,{ '-nri' }) return end
                self.shell.commands['$map']:cfn(cn,{})
            end
        },

        ['~prevmap'] = '',['!prevmap'] = '',['@prevmap'] = '',['#prevmap'] = '',['%prevmap'] = '',['^prevmap'] = '',
        ["$prevmap"] = {
            protected = { true, true, true, true, true, false, true },
            name = 'prevmap',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                if #args == 1 and args[1] == '-h' then self.shell.commands['$map']:cfn(cn,{ '-pr', args[1] }) return end
                if #args == 1 and args[1] == '-i' then self.shell.commands['$map']:cfn(cn,{ '-pri' }) return end
                if #args == 0 then self.shell.commands['$map']:cfn(cn,{ '-pr' }) return end
                self.shell.commands['$map']:cfn(cn,{})
            end
        },

        ['~nextmap'] = '',['!nextmap'] = '',['@nextmap'] = '',['#nextmap'] = '',['%nextmap'] = '',['^nextmap'] = '',
        ["$nextmap"] = {
            protected = { true, true, true, true, true, false, true },
            name = 'nextmap',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                if #args == 1 and args[1] == '-h' then self.shell.commands['$map']:cfn(cn,{ '-nr', args[1] }) return end
                if #args == 1 and args[1] == '-i' then self.shell.commands['$map']:cfn(cn,{ '-nri' }) return end
                if #args == 0 then self.shell.commands['$map']:cfn(cn,{ '-nr' }) return end
                self.shell.commands['$map']:cfn(cn,{})
            end
        },

        ['~maptime'] = '',['!maptime'] = '',['@maptime'] = '',['#maptime'] = '',['%maptime'] = '',['^maptime'] = '',
        ["$maptime"] = {
            protected = { true, true, true, true, true, false, true },
            name = 'maptime',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                if #args == 0 then self.shell.commands['$map']:cfn(cn,{ '-t' }) return end
                if #args == 1 and ( tonumber(args[1]) ~= nil or args[1] == '-h' ) then self.shell.commands['$map']:cfn(cn,{ '-t', args[1] }) return end
                self.shell.commands['$map']:cfn(cn,{})
            end
        },

        ['`su'] = '', ['~su'] = '', ['!su'] = '',['@su'] = '',['#su'] = '',['%su'] = '',['^su'] = '',['&su'] = '', ['1su'] = '',['2su'] = '',['3su'] = '',['4su'] = '',['5su'] = '',['6su'] = '',['7su'] = '',['su'] = '',['t$su'] = '',
        ["$su"] = {
            protected = { true, true, true, true, true, false, true  },
            name = 'su',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                local dcn, cnf = self.parent.cn:get_dcn(cn), self.parent.cnf.shell[self.name]
                local text = cnf.text
                if #args == 0 then
                    if self.parent.cn.data[dcn].stopwatch.active_flag then
                        --self.parent.cn:tmr_disable_stopwatch(cn)
                        self.shell.commands['$stopwatch']:cfn(cn,{})
                    end
                    if  self.parent.cn.data[dcn].login then
                        self.parent.cn.data[dcn].login = false
                        self.parent.log:w(string.format("The player uses the name of the authorization: %s",self.parent.cn:use_login(cn)),cn)
                        local f,e = self.parent.sql:logout(self.parent.cn:use_login(cn))
                        if not f then self.parent.say:me(cn,string.format(text['error_use_login'],self.parent.cn:use_login(cn),e)) end
                        -- self.parent.cn:use_uuid(cn,'')
                        -- self.parent.cn:use_email(cn, '')
                        -- self.parent.cn:use_score_of_maps(cn,0)
                        -- self.parent.cn:use_login(cn,'',0)
                        self.parent.cn:reset_account(cn)
                        -- self.parent.gm.weapon:reset_set_pulemete(cn)
                    end
                    if self.parent.cn.data[dcn].role > 0 then
                        callhandler('onPlayerRoleChange',cn, self.parent.cn:get_role(DEFAULT))
                    end
                else
                    if #args >= 1 then
                        local name = args[1]
                        if name == '-h' then self.parent.say:me(cn,text['help']) return end

                        if self.parent.cn.data[dcn].access == true and self.parent.cn.data[dcn].role == self.parent.cn:get_role(DEFAULT) and not self.parent.cn.data[dcn].login then

                            if tonumber(name) ~= nil then
                                args[1] = self.parent.cn:get_name(tonumber(name))
                                if args[1] ~= NOT_PLAYER then name = args[1] end
                            end

                            if args[2] == nil or args[2] == '' then self.parent.say:me(cn,text['error_empty_pwd']) return end

                            local pwd, player_name = self.parent.fn:trim(args[2]), self.parent.cn:get_name(cn)

                            local f, access, number_login, uuid, email = self.parent.sql:login(name, player_name, pwd, self.parent.cn.data[dcn].ip,self.parent.cn.data[dcn].server)

                            if  not f then
                                local passwords = getadminpwds()
                                for _, password in pairs(passwords) do
                                    if pwd == password then
                                        f = self.parent.sql:chk_user(name)
                                        if not f then
                                            f, access = self.shell.commands['$useradd']:cfn(cn,{name, ROOT, '', ''})
                                            self.parent.say:me(cn,text['ATENTION_ADMIN_0'])
                                        else
                                            self.parent.say:me(cn,text['ATENTION_ADMIN_1'])
                                        end
                                        if f then
                                            f, access, number_login, uuid, email  = self.parent.sql:login(name, player_name, pwd, self.parent.cn.data[dcn].ip,self.parent.cn.data[dcn].server,true)
                                        end
                                        if type(access) == 'number' then access = self.parent.cn:get_role(ADMIN) end
                                        break
                                    end
                                end
                            end

                            if f and self.parent.cn.data[dcn].access then
                                if email == '' then self.parent.say:me(cn,text['empty_email']) end
                                self.parent.cn:reset_account(cn)
                                self.parent.cn.data[dcn].login = true
                                self.parent.cn:use_uuid(cn,uuid)
                                self.parent.cn:use_email(cn,email)
                                self.parent.cn:use_login(cn,name,number_login)
                                self.parent.log:w(string.format("The player uses the name of the authorization: %s",self.parent.cn:use_login(cn)),cn)
                                if cnf.login_atention then self.parent.say:me(cn,text['login_atention']) end
                                callhandler('onPlayerRoleChange',cn, access)

                                -- get GEMA DATA FOR USER ACCOUNT --

                                if self.parent.gm.map:is_gema_map() and self.parent.sv:is_gema() and self.parent.gm.map:is_ctf_map() then

                                    -- self.parent.gm.weapon:set_pulemete(cn)

                                    f, access = self.parent.sql:user_data_gema(cn)
                                    if f then
                                        if access~= nil and type(access) == 'string' then
                                            self.parent.say:me(cn,access)
                                            self.parent.cn.data[dcn].account.statistic_map.map = self.parent.gm.map.name
                                            self.parent.cn.data[dcn].account.statistic_map.count = 1
                                        else
                                            self.parent.cn.data[dcn].account.statistic_map = access
                                        end
                                    else
                                        self.parent.say:me(cn,access)
                                    end

                                    -- ПРИВЕТСВИЕ ПРИ ЛОГИНЕ GEMA
                                    local score_of_maps = self.parent.cn:use_score_of_maps(cn,self.parent.sql:user_data_gema_score(cn))
                                    self.parent.say:me(cn,string.format(self.parent.cnf.gameplay.statistic.text.info_visits_gema,number_login,score_of_maps,self.parent.gm.map:get_cgmaps(),self.parent.fn:math_round(((score_of_maps*100)/self.parent.gm.map:get_cgmaps()),3),'%'))

                                    if cnf.login_gema_ext then
                                        self.parent.say:me(cn,string.format(self.parent.cnf.gameplay.statistic.text.info_change_map_say_me,self.parent.cn.data[dcn].account.statistic_map.count,self.parent.fn:format_stopwatch_time(self.parent.fn:get_sec_ms_time(self.parent.cn.data[dcn].account.statistic_map.time_score)),self.parent.fn:format_stopwatch_time(self.parent.fn:get_sec_ms_time(self.parent.cn.data[dcn].account.statistic_map.time_score_best)),self.parent.cn.data[dcn].account.statistic_map.count_score))
                                        f, access  = self.parent.sql:get_user_data_gema_info_position_list_best_time(uuid,self.parent.gm.map.name)
                                        if f > 0 then
                                            self.parent.say:me(cn,string.format(self.parent.cnf.gameplay.statistic.text.info_position_list_best_time,f))
                                        end
                                    end
                                    -- ПРИВЕТСВИЕ ПРИ ЛОГИНЕ GEMA
                                else
                                    -- ПРИВЕТСВИЕ ПРИ ЛОГИНЕ
                                    self.parent.say:me(cn,string.format(self.parent.cnf.gameplay.statistic.text.info_visits_normal,number_login))
                                    -- ПРИВЕТСВИЕ ПРИ ЛОГИНЕ
                                end

                            else
                                self.parent.say:me(cn,text['error_valid'])
                                self.parent.say:me(cn,access)
                            end
                        else
                            self.parent.say:me(cn,string.format(text['already_role'],self.parent.cn:get_role(self.parent.cn.data[dcn].role)))
                        end
                    end
                end
                return PLUGIN_BLOCK
            end
        },

        ['`sudo'] = '', ['~sudo'] = '', ['!sudo'] = '',['@sudo'] = '',['#sudo'] = '',['%sudo'] = '',['^sudo'] = '',['&sudo'] = '', ['1sudo'] = '',['2sudo'] = '',['3sudo'] = '',['4sudo'] = '',['5sudo'] = '',['6sudo'] = '',['7sudo'] = '',['sudo'] = '',['t$sudo'] = '',
        ["$sudo"] = {
            protected = { true, true, true, true, true, false, true },
            name = 'sudo',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                local dcn, cnf = self.parent.cn:get_dcn(cn), self.parent.cnf.shell[self.name]
                local text, role = cnf.text, self.parent.cn:get_role_cn(cn)
                local def,root,ad = self.parent.cn:get_role(DEFAULT),self.parent.cn:get_role(ROOT),self.parent.cn:get_role(ADMIN)
                if self.parent.cn.data[dcn].access == true then

                    if #args == 0 and self.parent.cn.data[dcn].old_role ~= nil and self.parent.cn.data[dcn].old_role > def and self.parent.cn.data[dcn].role == ad and isadmin(cn) then
                        callhandler('onPlayerRoleChange',cn,self.parent.cn.data[dcn].old_role)
                        return
                    elseif #args == 0 and isadmin(cn) then
                        self.shell.commands['$logout']:cfn(cn,{})
                        return
                    end

                    if #args >= 1 then

                        local tcn = args[1]

                        if tcn == '-h' then
                            self.parent.say:me(cn,text['help_0'])
                            self.parent.say:me(cn,text['help_1'])
                            return
                        end

                        if tcn == '-i' or tcn == '-p' then
                            if role == ad then
                                self.parent.say:me(cn,string.format(text['already_role'],self.parent.cn:get_role(ad)))
                                return
                            end

                            if tcn == '-i' then
                                if role == root then
                                    callhandler('onPlayerRoleChange',cn, ad)
                                    return
                                else
                                    self.parent.say:me(cn,text['no_root'])
                                    return
                                end
                            end

                            if tcn == '-p' then

                                if args[2] == nil then self.parent.say:me(cn,text['empty_pwd']) return end

                                local passwords = getadminpwds()
                                for _, password in pairs(passwords) do
                                    if args[2] == password then
                                        args[2] = true
                                        callhandler('onPlayerRoleChange',cn, ad)
                                        break
                                    end
                                end
                                if args[2] ~= true then self.parent.say:me(cn,text['no_valid_pwd']) end
                                return
                            end
                        end

                        local tname = tcn
                        tcn = tonumber(tcn)

                        if tcn == nil then
                            tcn = self.parent.cn:get_cn(tname)
                            if tcn == nil then self.parent.say:me(cn,string.format(text['no_valid_name'],tname)) return end
                        end

                        if not self.parent.cn:chk_cn(tcn) or not isconnected(tcn) then self.parent.say:me(cn,string.format(text['no_valid_cn'],tcn)) return end


                        if self.parent.cn.data[self.parent.cn.data_cn[tcn]].access == true then


                            local trole = self.parent.cn:get_role_cn(tcn)

                            if args[2] == nil then
                                args[2] = role
                            else
                                args[2] = self.parent.cn:get_role(args[2])
                                if args[2] == nil then
                                    self.parent.say:me(cn,text['no_valid_role'])
                                    self.parent.say:me(cn,string.format(self.parent.cnf.shell.text.shell_error,self.name))
                                    return
                                end
                            end

                            if args[2] == trole then
                                self.parent.say:me(cn,string.format(text['delegate_already_role'],self.parent.cn:get_cname(tcn),self.parent.cn:get_role(trole)))
                                return
                            end

                            if role == ad or role == root  then
                                callhandler('onPlayerRoleChange',tcn,args[2])
                                self.parent.say:me(cn,string.format(text['delegate_ok'],self.parent.cn:get_role(self.parent.cn:get_role_cn(tcn)),self.parent.cn:get_cname(tcn)))
                                return
                            end

                            if trole ~= ad and args[2] ~= ad and role >= args[2] and role > trole then
                                callhandler('onPlayerRoleChange',tcn, args[2])
                                self.parent.say:me(cn,string.format(text['delegate_ok'],self.parent.cn:get_role(args[2]),self.parent.cn:get_cname(tcn)))
                                 return
                            end

                            self.parent.say:me(cn,string.format(text['error_delegate_1'],self.parent.cn:get_cname(tcn)))

                        else
                            self.parent.say:me(cn,string.format(text['block_access'],self.parent.cn:get_cname(tcn))) return
                        end

                    end
                else
                    self.parent.say:me(cn,string.format(text['block_access'],self.parent.cn:get_cname(cn)))
                end
                self.parent.say:me(cn,string.format(self.parent.cnf.shell.text.shell_error,self.name)) return
            end
        },

        ['~whois'] = '',['!whois'] = '',['@whois'] = '',['#whois'] = '',['%whois'] = '',['^whois'] = '',
        ["$whois"] = {
            protected = { true, true, true, true, true, false, true },
            name = 'whois',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                if #args > 0 then
                    local dcn, cnf = self.parent.cn:get_dcn(cn), self.parent.cnf.shell[self.name]
                    local text,info = cnf.text, cnf.text.info
                    if args[1] == '-h' then self.parent.say:me(cn,text['help']) return true end
                    args[1] = tonumber(args[1])
                    if args[1] ~= nil then
                        args[1] = self.parent.cn:get_dcn(args[1])
                        if args[1] ~= nil then
                            info = string.format(info,self.parent.cn.data[args[1]].c_name..self.parent.cn.data[args[1]].name)
                            if cnf.include_geo then
                                if cnf.country then info = string.format('%s %s %s\f2.',info,text.country,self.parent.cn.data[args[1]].country) end
                                if cnf.iso then info = string.format('%s %s %s\f2.',info, text.iso, self.parent.cn.data[args[1]].iso) end
                                if cnf.city then info = string.format('%s %s %s\f2.',info, text.city, self.parent.cn.data[args[1]].city) end
                            end
                            if cnf.ip then
                                if cnf.hidden4octet and self.parent.cn.data[dcn].role ~= self.parent.cn:get_role(ADMIN) and self.parent.cn.data[dcn].role < self.parent.cn:get_role(REFEREE) then
                                    info = string.format('%s %s %s\f2.',info, text.ip, self.parent.fn:private_ip(self.parent.cn.data[args[1]].ip))
                                else
                                    info = string.format('%s %s %s\f2.',info, text.ip, self.parent.cn.data[args[1]].ip)
                                end
                            end
                            self.parent.say:me(cn,info)
                            return
                        end
                    end
                    self.parent.say:me(cn,text['not_player'])
                end
                self.parent.say:me(cn,string.format(self.parent.cnf.shell.text.shell_error,self.name)) return
            end
        },

        -- REGISTERED --

        ['~mapinfo'] = '',['!mapinfo'] = '',['@mapinfo'] = '',['#mapinfo'] = '',['%mapinfo'] = '',['^mapinfo'] = '',
        ["$mapinfo"] = {
            protected = { true, true, true, true, false, false, true , true},
            name = 'mapinfo',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                if #args == 0 then self.shell.commands['$map']:cfn(cn,{ '-i' }) return end
                if #args == 1 and args[1] == '-h' then
                    self.shell.commands['$map']:cfn(cn,{ '-i', '-h' })
                    self.shell.commands['$map']:cfn(cn,{ '-d', '-h' })
                    return
                end
                if #args == 1 and args[1] == '-d'  then self.shell.commands['$map']:cfn(cn,{ '-d' }) return end
                if #args == 2 and args[1] == '-d' and args[2] == '-all'  then self.shell.commands['$map']:cfn(cn,{'-d','-all' }) return end
                if #args == 1 then self.shell.commands['$map']:cfn(cn,{ '-i', args[1] }) return end
                self.shell.commands['$map']:cfn(cn,{'-ERROR'})
            end
        },

        ['~maptop'] = '',['!maptop'] = '',['@maptop'] = '',['#maptop'] = '',['%maptop'] = '',['^maptop'] = '',
        ["$maptop"] = {
            protected = { true, true, true, true, false, false, true,true },
            name = 'maptop',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                if #args == 0 then self.shell.commands['$map']:cfn(cn,{'-top','-best'}) return end
                if #args == 1 then
                    if tonumber(args[1]) ~= nil then self.shell.commands['$map']:cfn(cn,{'-top','-best',args[1]}) return end
                    if args[1] == '-h' then self.shell.commands['$map']:cfn(cn,{'-top','-best','-h'}) return end
                end
                self.shell.commands['$map']:cfn(cn,{'-ERROR'})
            end
        },

        ['~infouuid'] = '',['!infouuid'] = '',['@infouuid'] = '',['#infouuid'] = '',['%infouuid'] = '',['^infouuid'] = '',
        ["$infouuid"] = {
            protected = { true, true, true, true, false, false, true },
            name = 'infouuid',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                if #args == 1 and args[1] == '-h' then self.shell.commands['$uuid']:cfn(cn,{ '-h' }) return end
                if #args == 0 then self.shell.commands['$uuid']:cfn(cn,{}) return end
                self.shell.commands['$uuid']:cfn(cn,{'-error'})
            end
        },


        ['~go'] = '',['!go'] = '',['@go'] = '',['#go'] = '',['%go'] = '',['^go'] = '',
        ["$go"] = {
            protected = { true, true, true, true, false, false, true },
            name = 'go',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                local dcn = self.parent.cn.data_cn[cn]
                local text = self.parent.cnf.shell[self.name].text
                local name = self.parent.cn.data[dcn].name
                local c_name = self.parent.cn.data[dcn].c_name

                if self.parent.cn.data[dcn].access == true --[[and self.parent.cn.data[dcn].login == true]] then

                    if self.parent.gm.map:is_gema_map() and self.parent.sv:is_gema() then
                        if self.parent.gm.map:is_ctf_map() then

                            if #args >= 1 then
                                if args[1] == '-h' then self.parent.say:me(cn,text['help']) return end
                                if args[1] == '-e' then
                                    if not self.parent.cn.data[dcn].stopwatch.period_say then
                                        self.parent.cn.data[dcn].stopwatch.period_say = true
                                        self.parent.say:me(cn,text['set_flag_enable'])
                                    end
                                end
                                if args[1] == '-d' then
                                    if self.parent.cn.data[dcn].stopwatch.period_say then
                                        self.parent.cn.data[dcn].stopwatch.period_say = false
                                        self.parent.say:me(cn,text['set_flag_disable'])
                                    end
                                end
                            end

                            if self.parent.cn.data[dcn].flag.action ~= nil and self.parent.cn.data[dcn].flag.action == self.parent.gm.flag:get('STEAL')  and self.parent.cn.data[dcn].flag.n ~= nil then
                                flagaction(cn,self.parent.gm.flag:get('RESET'),self.parent.cn.data[dcn].flag.n)
                            end
                            sendspawn(cn)
                            flashonradar(cn)

                            local enable_stopwatch = self.parent.cn.data[dcn].stopwatch.enable
                            self.parent.cn.data[dcn].stopwatch.enable = true

                            if not self.parent.cn.data[dcn].stopwatch.active_flag then
                                self.shell.commands['$stopwatch']:cfn(cn,{})
                            else
                                local difftime_say = self.parent.cn.data[dcn].stopwatch.difftime_say
                                self.parent.cn.data[dcn].stopwatch.difftime_say = false
                                self.shell.commands['$stopwatch']:cfn(cn,{})
                                self.shell.commands['$stopwatch']:cfn(cn,{})
                                self.parent.cn.data[dcn].stopwatch.difftime_say = difftime_say
                            end
                            self.parent.cn.data[dcn].stopwatch.enable = enable_stopwatch

                            self.parent.cn.data[dcn].flag.statistic_gema_flag = true
                        else
                            self.parent.say:me(cn,text['not_ctf'])
                        end
                    else
                        self.parent.say:me(cn,text['not_gema'])
                    end
                    return
                else
                    self.parent.say:me(cn,string.format(text['not_access'],c_name..name)) return
                end
                self.parent.say:me(cn,string.format(self.parent.cnf.shell.text.shell_error,self.name)) return
            end
        },

        ['~sw'] = '',['!sw'] = '',['@sw'] = '',['#sw'] = '',['%sw'] = '',['^sw'] = '',
        ["$sw"] = {
            protected = { true, true, true, true, false, false, true  },
            name= 'sw',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                self.shell.commands['$stopwatch']:cfn(cn,args or {})
            end
        },

        ['~stopwatch'] = '',['!stopwatch'] = '',['@stopwatch'] = '',['#stopwatch'] = '',['%stopwatch'] = '',['^stopwatch'] = '',
        ["$stopwatch"] = {
            protected = { true, true, true, true, false, false, false  },
            name= 'stopwatch',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                local dcn, cnf = self.parent.cn.data_cn[cn], self.parent.cnf.shell[self.name]
                local text = cnf.text
                if self.parent.cn.data[dcn].access == true  or self.parent.cn.data[dcn].stopwatch.active_flag then
                    if #args >= 1 then
                        if args[1] == '-h' then
                            self.parent.say:me(cn,text['help_0'])
                            self.parent.say:me(cn,text['help_1'])
                            return
                        end
                        if args[1] == '-e' then
                            if not self.parent.cn.data[dcn].stopwatch.period_say then
                                self.parent.cn.data[dcn].stopwatch.period_say = true
                                self.parent.say:me(cn,text['set_flag_enable'])
                            end
                            if self.parent.cn.data[dcn].stopwatch.active_flag then
                                local enable_stopwatch = self.parent.cn.data[dcn].stopwatch.enable
                                self.parent.cn.data[dcn].stopwatch.enable = true
                                if self.parent.cn.data[dcn].stopwatch.n ~= nil then
                                    self.parent.cn:tmr_disable_stopwatch(cn)
                                    self.parent.cn:tmr_enable_stopwatch(cn)
                                    self.parent.say:me(cn,text['already_active'])
                                else
                                    self.parent.cn:tmr_enable_stopwatch(cn)
                                end
                                self.parent.cn.data[dcn].stopwatch.enable = enable_stopwatch
                            else
                                self.shell.commands['$stopwatch']:cfn(cn,{})
                            end
                            return
                        end
                        if args[1] == '-d' then
                            if self.parent.cn.data[dcn].stopwatch.active_flag then
                                if self.parent.cn.data[dcn].stopwatch.period_say then
                                    self.parent.cn.data[dcn].stopwatch.period_say = false
                                    self.parent.say:me(cn,text['set_flag_disable'])
                                end
                                self.shell.commands['$stopwatch']:cfn(cn,{})
                            else
                                if cnf.say_not_active then self.parent.say:me(cn,text['not_active']) end
                            end
                            return
                        end
                        if args[1] == '-t' then
                            if args[2] ~= nil then
                                local period = tonumber(self.parent.fn:trim(args[2]))
                                if period ~= nil and period > 0 and self.parent.cn.data[dcn].stopwatch.period ~= period then
                                    self.parent.cn.data[dcn].stopwatch.period = period * 1000
                                    self.parent.say:me(cn,string.format(text['set_period'],tostring(period)))
                                    if self.parent.cn.data[dcn].stopwatch.n ~= nil then
                                        local enable_stopwatch = self.parent.cn.data[dcn].stopwatch.enable
                                        self.parent.cn.data[dcn].stopwatch.enable = true
                                        local period_say = self.parent.cn.data[dcn].stopwatch.period_say
                                        self.parent.cn.data[dcn].stopwatch.period_say = true
                                        self.parent.cn:tmr_disable_stopwatch(cn)
                                        self.parent.cn:tmr_enable_stopwatch(cn)
                                        self.parent.cn.data[dcn].stopwatch.period_say = period_say
                                        self.parent.cn.data[dcn].stopwatch.enable = enable_stopwatch
                                        self.parent.say:me(cn,text['already_active'])
                                    end
                                end
                                return
                            end
                            self.parent.say:me(cn,string.format(self.parent.cnf.shell.text.shell_error,self.name)) return
                        end
                        if args[1] == '-s' then
                            if self.parent.cn.data[dcn].stopwatch.active_flag then

                                if self.parent.cn.data[dcn].stopwatch.n == nil then
                                    local enable_stopwatch = self.parent.cn.data[dcn].stopwatch.enable
                                    self.parent.cn.data[dcn].stopwatch.enable = true

                                    local period_say = self.parent.cn.data[dcn].stopwatch.period_say
                                    self.parent.cn.data[dcn].stopwatch.period_say = true

                                    self.parent.cn:tmr_enable_stopwatch(cn)

                                    self.parent.cn.data[dcn].stopwatch.period_say = period_say

                                    self.parent.cn.data[dcn].stopwatch.enable = enable_stopwatch
                                    if cnf.say_enable then self.parent.say:me(cn,text['say_enable']) end
                                else
                                    self.parent.cn:tmr_disable_stopwatch(cn)
                                    if cnf.say_disable then self.parent.say:me(cn,text['say_disable']) end
                                end
                            else
                                if cnf.say_not_active then self.parent.say:me(cn,text['not_active']) end
                            end
                            return
                        end
                    end
                    if self.parent.cn.data[dcn].stopwatch.enable or self.parent.cn.data[dcn].stopwatch.active_flag then

                        if not self.parent.cn.data[dcn].stopwatch.active_flag then

                            self.parent.log:w('Activate stopwatch for CN: '..tostring(cn),cn )
                            --self.parent.cn.data[dcn].stopwatch.start_time = os.time()
                            self.parent.cn.data[dcn].stopwatch.start_time = getsvtick()
                            self.parent.cn.data[dcn].stopwatch.stop_time = 0
                            self.parent.cn.data[dcn].stopwatch.diff_time = 0

                            self.parent.cn.data[dcn].stopwatch.active_flag = true

                            if cnf.active_say then self.parent.say:me(cn,text['enable']) end

                            self.parent.cn:tmr_enable_stopwatch(cn)

                            self.parent.cn.data[dcn].flag.statistic_gema_flag = false

                        elseif self.parent.cn.data[dcn].stopwatch.active_flag then

                            self.parent.log:w('Deactivate stopwatch for CN: '..tostring(cn),cn )
                            self.parent.cn.data[dcn].stopwatch.active_flag = false

                            if cnf.not_active_say then self.parent.say:me(cn,text['disable']) end

                            self.parent.cn:tmr_disable_stopwatch(cn)

                            if self.parent.cn.data[dcn].stopwatch.start_time ~= nil then
                                --self.parent.cn.data[dcn].stopwatch.stop_time = os.time()
                                self.parent.cn.data[dcn].stopwatch.stop_time = getsvtick()
                                --self.parent.cn.data[dcn].stopwatch.diff_time = os.difftime(self.parent.cn.data[dcn].stopwatch.stop_time, self.parent.cn.data[dcn].stopwatch.start_time)
                                self.parent.cn.data[dcn].stopwatch.diff_time = self.parent.cn.data[dcn].stopwatch.stop_time - self.parent.cn.data[dcn].stopwatch.start_time

                                --self.parent.cn.data[dcn].stopwatch.diff_time_modf.sec, self.parent.cn.data[dcn].stopwatch.diff_time_modf.msec = math.modf(self.parent.cn.data[dcn].stopwatch.diff_time/1000)
                                --self.parent.cn.data[dcn].stopwatch.diff_time_modf.msec = math.floor(self.parent.cn.data[dcn].stopwatch.diff_time_modf.msec*1000)

                                if self.parent.cn.data[dcn].stopwatch.difftime_say and not self.parent.cn.data[dcn].flag.statistic_gema_flag then
                                    self.parent.say:me(cn,string.format(text['difftime'],self.parent.fn:format_stopwatch_time(self.parent.fn:get_sec_ms_time(self.parent.cn.data[dcn].stopwatch.diff_time))))
                                end

                                --self.parent.cn.data[dcn].stopwatch.start_time = 0
                            end

                            self.parent.cn.data[dcn].flag.statistic_gema_flag = false
                        end
                        return
                    else
                        if cnf.not_enable_say then self.parent.say:me(cn,text['not_enable']) end
                        return
                    end
                else
                    self.parent.say:me(cn,string.format(text['not_access'],c_name..name))
                end
                self.parent.say:me(cn,string.format(self.parent.cnf.shell.text.shell_error,self.name)) return
            end
        },

        ['~logout'] = '',['!logout'] = '',['@logout'] = '',['#logout'] = '',['%logout'] = '',['^logout'] = '',
        ["$logout"] = {
            protected = { true, true, true, true, false, false, true  },
            name= 'logout',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                if #args == 0 then
                    self.shell.commands['$su']:cfn(cn,{})
                    return
                end
                if #args >= 1 then
                    if args[1] == '-h' then self.parent.say:me(cn,self.parent.cnf.shell.text[self.name..'_help']) return end
                end
                self.parent.say:me(cn,string.format(self.parent.cnf.shell.text.shell_error,self.name)) return
            end
        },

        ['~unreg'] = '',['!unreg'] = '',['@unreg'] = '',['#unreg'] = '',['%unreg'] = '',['^unreg'] = '',
        ["$unreg"] = {
            protected = { true, true, true, true, false, false , true },
            name= 'unreg',
            cfn = function (self,cn, args)
                if #args > 0 then self.shell.commands['$unregistry']:cfn(cn,{'-h'}) return end
                self.parent.say:me(cn,self.parent.cnf.shell.text[self.name..'_message'])  return
            end
        },

        ['~unregistry'] = '',['!unregistry'] = '',['@unregistry'] = '',['#unregistry'] = '',['%unregistry'] = '',['^unregistry'] = '',
        ["$unregistry"] = {
            protected = { true, true, true, true, false, false , false },
            name= 'unregistry',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                local login, flag = '', '-d'
                if #args == 1 then
                    if args[1] == '-h' then self.parent.say:me(cn,self.parent.cnf.shell.text[self.name..'_help']) return end
                    --if args[1] == '-s' then flag = '-s' end
                    args[1] = nil
                end
                if #args == 0 then
                    if self.parent.cn.data[self.parent.cn.data_cn[cn]].access and self.parent.cn.data[self.parent.cn.data_cn[cn]].login and self.parent.cn:get_role_cn(cn) > 0 then
                        login = self.parent.cn:use_login(cn)
                        self.shell.commands['$su']:cfn(cn,{})
                        self.shell.commands['$userdel']:cfn(cn,{login,flag})
                        return
                    end
                    self.parent.say:me(cn,self.parent.cnf.shell.text.unregistry_not_permit_change) return
                end
                self.parent.say:me(cn,string.format(self.parent.cnf.shell.text.shell_error,self.name)) return
            end
        },

        ['~passwd'] = '',['!passwd'] = '',['@passwd'] = '',['#passwd'] = '',['%passwd'] = '',['^passwd'] = '',
        ["$passwd"] = {
            protected = { true, true, true, true, false, false , true },
            name= 'passwd',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                if #args >= 1 then
                    if args[1] == '-h' then self.parent.say:me(cn,self.parent.cnf.shell.text[self.name..'_help']) return end
                    self.shell.commands['$usermod']:cfn(cn,{self.parent.cn:use_login(cn),'-p',args[1]}) return
                end
                self.parent.say:me(cn,string.format(self.parent.cnf.shell.text.shell_error,self.name)) return
            end
        },

        ['~rename'] = '',['!rename'] = '',['@rename'] = '',['#rename'] = '',['%rename'] = '',['^rename'] = '',
        ["$rename"] = {
            protected = { true, true, true, true, false, false , true },
            name= 'rename',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                if #args >= 1 then
                    if args[1] == '-h' then self.parent.say:me(cn,self.parent.cnf.shell.text[self.name..'_help']) return end
                    self.shell.commands['$usermod']:cfn(cn,{self.parent.cn:use_login(cn),'-n',args[1]})
                    return
                end
                self.parent.say:me(cn,string.format(self.parent.cnf.shell.text.shell_error,self.name)) return
            end
        },

        ['~email'] = '',['!email'] = '',['@email'] = '',['#email'] = '',['%email'] = '',['^checkword'] = '',
        ["$email"] = {
            protected = { true, true, true, true, false, false , true },
            name= 'email',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                local dcn, cnf = self.parent.cn.data_cn[cn], self.parent.cnf.shell[self.name]
                local text = cnf.text
                if #args == 0 then
                    local email = self.parent.cn:use_email(cn)
                    if email == '' then
                        self.parent.say:me(cn,text['empty']) return
                    end
                    self.parent.say:me(cn,string.format(text['your'],email)) return
                elseif #args >= 1 then
                    if args[1] == '-h' then self.parent.say:me(cn,text['help']) return end
                    if args[1] == '-d' then
                        self.shell.commands['$usermod']:cfn(cn,{self.parent.cn:use_login(cn),'-e','',1}) return
                    end
                    if args[1] == '-u' then
                        self.shell.commands['$usermod']:cfn(cn,{self.parent.cn:use_login(cn),'-e',args[2]}) return
                    end
                    if args[1] == '-c' and (args[2]~=nil or args[2]~= '') then
                        self.shell.commands['$usermod']:cfn(cn,{self.parent.cn:use_login(cn),'-e',args[2],1}) return
                    end
                end
                self.parent.say:me(cn,string.format(self.parent.cnf.shell.text.shell_error,self.name)) return
            end
        },

        ['~access'] = '',['!access'] = '',['@access'] = '',['#access'] = '',['%access'] = '',['^access'] = '',
        ["$access"] = {
            protected = { true, true, true, true, false, false, true  },
            name= 'access',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                if #args >= 1 then
                    if args[1] == '-h' then self.parent.say:me(cn,self.parent.cnf.shell.text[self.name..'_help']) return end
                    self.shell.commands['$sudo']:cfn(cn,{args[1],"REGISTERED"})
                    return
                end
                self.parent.say:me(cn,string.format(self.parent.cnf.shell.text.shell_error,self.name)) return
            end
        },

        ['~assign'] = '',['!assign'] = '',['@assign'] = '',['#assign'] = '',['%assign'] = '',['^assign'] = '',
        ["$assign"] = {
            protected = { true, true, true, true, false, false , true, true },
            name= 'assign',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                if #args >= 1 then
                    if args[1] == '-h' then self.parent.say:me(cn,self.parent.cnf.shell.text[self.name..'_help']) return end
                    self.shell.commands['$sudo']:cfn(cn,{args[1]})
                    return
                end
                self.parent.say:me(cn,string.format(self.parent.cnf.shell.text.shell_error,self.name)) return
            end
        },

        ['~sendmail'] = '',['!sendmail'] = '',['@sendmail'] = '',['#sendmail'] = '',['%sendmail'] = '',['^userdata'] = '',
        ["$sendmail"] = {
            protected = { true, true, true, true, false, false, true, true },
            name= 'sendmail',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                if #args >= 1 then
                    if args[1] == '-h' then self.parent.say:me(cn,self.parent.cnf.shell.text.sendmail_help) return end
                    if #args >= 2 then
                        local mail = table.remove(args,1)
                        if self.parent.fn:find_SPECL(mail) or  not self.parent.fn:chk_EMAIL(mail) then
                            self.parent.say:me(cn,string.format(self.parent.cnf.shell.text.sendmail_no_valid,mail))
                            return
                        end
                        self.parent.sv:sendmail(mail, table.concat(args,' '),cn)
                        return
                    end
                end
                self.parent.say:me(cn,string.format(self.parent.cnf.shell.text.shell_error,self.name))
            end
        },

        --REFEREE --

        ['~kick'] = '',['!kick'] = '',['@kick'] = '',['#kick'] = '',['%kick'] = '',['^kick'] = '',
        ["$kick"] = {
            protected = { true, true, true, false, false, false, true  },
            name = 'kick',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                local cnf = self.parent.cnf.shell[self.name]
                local text = cnf.text
                if #args >= 1 then
                    if args[1] == '-h' then self.parent.say:me(cn,text['help']) return end
                    args[1] = tonumber(args[1])
                    if args[1] ~= nil then
                        if self.parent.cn:chk_cn(args[1]) then
                            local name = self.parent.cn:get_name(args[1])
                            self.parent.log:w(string.format("Kick OK Name: %s", name,cn))
                            self.parent.cn.d_force.cn = args[1]
                            self.parent.cn.d_force.reasson = self.parent.cn:get_d_reasson(cnf.reasson)
                            if ( tonumber(args[2]) ~= nil and tonumber(args[2]) == 1 ) or ( ( cnf.all_say and args[2] == nil ) or ( cnf.all_say and  tonumber(args[2]) ~= nil and tonumber(args[2]) == 1 ) ) then
                                local cs = 2
                                if tonumber(args[2]) ~= nil then cs = 3 end
                                self.parent.cn.d_force.message = string.format(cnf.text.all_message,self.parent.cn:get_name(cn), name, table.concat(args, " ", cs ))
                            end
                            self.parent.cn:force_disconnect(self.parent.cn.d_force.cn,self.parent.cn.d_force.reasson, self.parent.cn.d_force.message )
                            self.parent.say:me(cn,string.format(text.ok,name))
                            return
                        else
                            self.parent.say:me(cn,cnf.text.no_user) return
                        end
                    end
                end
                self.parent.say:me(cn,string.format(self.parent.cnf.shell.text.shell_error,self.name)) return
            end
        },

        ['~mapban'] = '',['!mapban'] = '',['@mapban'] = '',['#mapban'] = '',['%mapban'] = '',['^mapban'] = '',
        ["$mapban"] = {
            protected = { true, true, true, false, false, false, true  },
            name = 'ban',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                local cnf = self.parent.cnf.shell[self.name]
                local text = cnf.text
                if #args >= 1 then
                    if args[1] == '-h' then self.parent.say:me(cn,text['help']) return end
                    if args[1] == '-r' then
                        self.parent.gm.ban:reset()
                        self.parent.say:me(cn,text['reset'])
                        return
                    end
                    args[1] = tonumber(args[1])
                    if args[1] ~= nil then
                        if not self.parent.cn:chk_cn(args[1]) then
                            self.parent.say:me(cn,text.no_user) return
                        end
                        local flag = true
                        local ip = self.parent.cn:get_ip(args[1])
                        local name = self.parent.cn:get_name(args[1])
                        for _,v in ipairs(self.parent.gm.ban.list) do
                            if name == v.name then flag = false break end
                            if ip == v.ip then flag = false break end
                        end
                        if flag then
                            table.insert(self.parent.gm.ban.list,{name=name,ip=ip,reasson=cnf.reasson})
                            self.parent.log:w(string.format("Ban OK Name: %s", name,cn))
                            self.parent.cn.d_force.cn = args[1]
                            self.parent.cn.d_force.reasson = self.parent.cn:get_d_reasson(cnf.reasson)
                            if ( tonumber(args[2]) ~= nil and tonumber(args[2]) == 1 ) or ( ( cnf.all_say and args[2] == nil ) or ( cnf.all_say and  tonumber(args[2]) ~= nil and tonumber(args[2]) == 1 ) ) then
                                local cs = 2
                                if tonumber(args[2]) ~= nil then cs = 3 end
                                self.parent.cn.d_force.message = string.format(cnf.text.all_message,self.parent.cn:get_name(cn), name, table.concat(args, " ", cs ))
                            end
                            self.parent.cn:force_disconnect(self.parent.cn.d_force.cn,self.parent.cn.d_force.reasson, self.parent.cn.d_force.message )
                            self.parent.say:me(cn,string.format(text.ok,name))
                        end
                        return
                    end
                end
                self.parent.say:me(cn,string.format(self.parent.cnf.shell.text.shell_error,self.name)) return
            end
        },

        ['~lock'] = '',['!lock'] = '',['@lock'] = '',['#lock'] = '',['%lock'] = '',['^lock'] = '',
        ["$lock"] = {
            protected = { true, true, true, false, false, false , true },
            name = 'lock',
            cfn = function (self,cn, args)
                function s(self,cn)
                    if self.parent.cnf.server.lock.active then
                        self.parent.say:me(cn,self.parent.cnf.shell.text[self.name..'_text_0'])
                        self.parent.say:allexme(cn,self.parent.cnf.shell.text[self.name..'_text_0'])
                    else
                        self.parent.say:me(cn,self.parent.cnf.shell.text[self.name..'_text_1'])
                        self.parent.say:allexme(cn,self.parent.cnf.shell.text[self.name..'_text_1'])
                    end
                end
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                if #args >= 1 then
                    if args[1] == '-h' then self.parent.say:me(cn,self.parent.cnf.shell.text[self.name..'_help']) return end
                    if args[1] == '-s' then s(self,cn) return end
                    self.parent.say:me(cn,string.format(self.parent.cnf.shell.text.shell_error,self.name))
                    return
                end
                self.parent.cnf.server.lock.active = not self.parent.cnf.server.lock.active
                s(self,cn)
                self.parent.log:i("LOCK STATUS "..tostring(self.parent.cnf.server.lock.active),cn)
                return
            end
        },

        -- ROOT --


        ['~useradd'] = '',['!useradd'] = '',['@useradd'] = '',['#useradd'] = '',['%useradd'] = '',['^useradd'] = '',
        ["$useradd"] = {
            protected = { true, true, false, false, false, false , true },
            name= 'useradd',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                if #args >= 1 then
                    if args[1] == '-h' then self.parent.say:me(cn,self.parent.cnf.shell.text[self.name..'_help']) return end
                    if args[2] == nil or args[3] == nil then self.parent.say:me(cn,string.format(self.parent.cnf.shell.text.shell_error,self.name)) return end
                    if args[4] ~= nil and ( self.parent.fn:find_SPECL(args[4]) or not self.parent.fn:chk_EMAIL(args[4]) ) then
                        self.parent.say:me(cn,string.format(self.parent.cnf.shell.text[self.name..'_error_email'],args[4]))
                        return
                    end
                    local f,r, u = self.parent.sql:useradd(args[1],self.parent.cn:get_role(args[2]),args[3],(args[4] or ''))
                    if f then
                        if self.parent.cnf.server.msmtp~=nil and self.parent.cnf.server.msmtp.active and self.parent.cnf.server.msmtp.allert_and_send_to.create_of_account.active then
                            local email, text = {}, {}

                            if type(self.parent.cnf.server.msmtp.allert_and_send_to.create_of_account.to) == 'string' then
                                table.insert(email,self.parent.cnf.server.msmtp.allert_and_send_to.create_of_account.to)
                            else
                                for _,v in ipairs(self.parent.cnf.server.msmtp.allert_and_send_to.create_of_account.to) do
                                    table.insert(email,v)
                                end
                            end

                            if args[4] == nil or args[4] == '' or args[4] == NOT_EMAIL then
                                 args[4] = NOT_EMAIL
                            else
                                table.insert(email,args[4])
                            end
                            if type(self.parent.cnf.server.msmtp.allert_and_send_to.create_of_account.text) == 'string' then
                                    table.insert(text,self.parent.cnf.server.msmtp.allert_and_send_to.create_of_account.text)
                            else
                                for _,v in ipairs(self.parent.cnf.server.msmtp.allert_and_send_to.create_of_account.text) do
                                    table.insert(text,v)
                                end
                            end
                            for k,v in ipairs(text) do
                                text[k] = string.format(v,self.parent.cn:get_name(cn),args[1],self.parent.cn:get_role(self.parent.cn:get_role(args[2])),u,args[4])
                            end

                            self.parent.sv:sendmail(email,text)
                        end
                    end
                    local tcn = self.parent.cn:get_cn(args[1])
                    if tcn ~= nil then
                        if tcn ~= cn then
                            self.parent.say:to(cn,tcn,r)
                            if f then self.parent.say:to(cn,tcn,string.format(self.parent.cnf.shell.text[self.name..'_to_login'],args[3])) end
                        end
                    end
                    self.parent.say:me(cn,r)
                    return f
                end
                self.parent.say:me(cn,string.format(self.parent.cnf.shell.text.shell_error,self.name)) return
            end
        },

        ['~userdel'] = '',['!userdel'] = '',['@userdel'] = '',['#userdel'] = '',['%userdel'] = '',['^userdel'] = '',
        ["$userdel"] = {
            protected = { true, true, false, false, false, false , true },
            name= 'userdel',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                if #args >=1 then
                    if args[1] == '-h' then self.parent.say:me(cn,self.parent.cnf.shell.text[self.name..'_help']) return end
                    local f,r,u,m = self.parent.sql:userdel(args[1])
                    local c = self.parent.cn:get_cn(args[1])
                    if c ~= nil then
                        self.shell.commands['$su']:cfn(c,{})
                        if cn ~= c then self.parent.say:to(cn,c,r) end
                    end
                    if f then
                        if args[2] ~= nil and args[2] == '-d' and u ~= nil then
                            local f,r = self.parent.sql:delete_user_data_gema(u)
                            self.parent.say:me(cn,r)
                        end
                        if self.parent.cnf.server.msmtp~=nil and self.parent.cnf.server.msmtp.active and self.parent.cnf.server.msmtp.allert_and_send_to.delete_of_account.active then
                            local email, text = {}, {}

                            if type(self.parent.cnf.server.msmtp.allert_and_send_to.delete_of_account.to) == 'string' then
                                table.insert(email,self.parent.cnf.server.msmtp.allert_and_send_to.delete_of_account.to)
                            else
                                for _,v in ipairs(self.parent.cnf.server.msmtp.allert_and_send_to.delete_of_account.to) do
                                    table.insert(email,v)
                                end
                            end

                            if m == nil or m == '' or m == NOT_EMAIL then
                                 m = NOT_EMAIL
                            else
                                table.insert(email,m)
                            end

                            if type(self.parent.cnf.server.msmtp.allert_and_send_to.delete_of_account.text) == 'string' then
                                    table.insert(text,self.parent.cnf.server.msmtp.allert_and_send_to.delete_of_account.text)
                            else
                                for _,v in ipairs(self.parent.cnf.server.msmtp.allert_and_send_to.delete_of_account.text) do
                                    table.insert(text,v)
                                end
                            end
                            for k,v in ipairs(text) do
                                text[k] = string.format(v,self.parent.cn:get_name(cn),args[1],u,m)
                            end

                            self.parent.sv:sendmail(email,text)
                        end
                    end
                    self.parent.say:me(cn,r)
                    return f
                end
                self.parent.say:me(cn,string.format(self.parent.cnf.shell.text.shell_error,self.name)) return
            end
        },

        ['~usermod'] = '',['!usermod'] = '',['@usermod'] = '',['#usermod'] = '',['%usermod'] = '',['^usermod'] = '',
        ["$usermod"] = {
            protected = { true, true, false, false, false, false , true },
            name= 'usermod',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                if args[1] == '-h' then self.parent.say:me(cn,self.parent.cnf.shell.text[self.name..'_help']) return end
                local f,r = false, 'ERROR'
                if #args >= 3 then
                    if args[2] == '-n' then f,r = self.parent.sql:u_name(args[1],args[3]) end
                    if args[2] == '-p' then f,r = self.parent.sql:u_passwd(args[1],args[3]) end
                    if args[2] == '-e' then f,r = self.parent.sql:u_email(args[1],args[3],args[4]) end
                    if args[2] == '-r' then f,r = self.parent.sql:u_role(args[1],self.parent.cn:get_role(args[3])) end
                    if f  then
                        for k,v in ipairs(self.parent.cn.data) do
                            if self.parent.cn:use_login(v.cn) == args[1] and v.login == true then
                                --print (v.use_login..' '..tostring(v.cn))
                                if args[2] == '-n' then self.parent.cn:use_login(v.cn,args[3]) end
                                if args[2] == '-e' then self.parent.cn:use_email(v.cn,args[3]) end
                                if v.cn ~= cn then
                                    self.parent.say:to(cn,v.cn,'$'..self.name..' by '..self.parent.cn:get_name(cn))
                                    self.parent.say:to(cn,v.cn,r)
                                end
                            end
                        end
                    end
                    self.parent.say:me(cn,r)
                    return f
                end
                self.parent.say:me(cn,string.format(self.parent.cnf.shell.text.shell_error,self.name)) return
            end
        },

        ['~mod'] = '',['!mod'] = '',['@mod'] = '',['#mod'] = '',['%mod'] = '',['^mod'] = '',
        ["$mod"] = {
            protected = { true, true, false, false, false, false, true  },
            name= 'mod',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                if #args >= 1 then
                    if args[1] == '-h' then self.parent.say:me(cn,self.parent.cnf.shell.text[self.name..'_help']) return end
                    if args[1] == '-reload' then
                        return PLUGIN_RELOAD_BLOCK
                    end
                    if args[1] == '-load' then
                        return PLUGIN_LOAD_BLOCK
                    end
                    if args[1] == '-unload' then
                        return PLUGIN_UNLOAD_BLOCK
                    end
                end
                self.parent.say:me(cn,string.format(self.parent.cnf.shell.text.shell_error,self.name)) return
            end
        },

        ['~demo'] = '',['!demo'] = '',['@demo'] = '',['#demo'] = '',['%demo'] = '',['^demo'] = '',
        ["$demo"] = {
            protected = { true, true, false, false, false, false, true, true  },
            name= 'demo',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                if #args >= 1 then
                    if args[1] == '-h' then
                        self.parent.say:me(cn,self.parent.cnf.shell.text[self.name..'_help_0'])
                        --self.parent.say:me(cn,self.parent.cnf.shell.text[self.name..'_help_1'])
                        return
                    end
                    if args[1] == '-s' then
                        if flag_getdemo() == true then
                            self.parent.say:me(cn,self.parent.cnf.shell.text[self.name..'_allowed'])
                        else
                            self.parent.say:me(cn,self.parent.cnf.shell.text[self.name..'_not_allowed'])
                        end
                        return
                    end
                    if args[1] == '-on' then
                        flag_getdemo(true)
                        self.parent.say:me(cn,self.parent.cnf.shell.text[self.name..'_allowed'])
                        return
                    end
                    if args[1] == '-off' then
                        flag_getdemo(false)
                        self.parent.say:me(cn,self.parent.cnf.shell.text[self.name..'_not_allowed'])
                        return
                    end
                    self.parent.say:me(cn,string.format(self.parent.cnf.shell.text.shell_error,self.name)) return
                end
                --[[]
                if flag_getdemo() then
                    flag_getdemo(false)
                    self.parent.say:me(cn,self.parent.cnf.shell.text[self.name..'_not_allowed'])
                else
                    flag_getdemo(true)
                    self.parent.say:me(cn,self.parent.cnf.shell.text[self.name..'_allowed'])
                end
                ]]
                return
            end
        },

        ['~stoemail'] = '',['!stoemail'] = '',['@stoemail'] = '',['#stoemail'] = '',['%stoemail'] = '',['^stoemail'] = '',
        ["$stoemail"] = {
            protected = { true, true, false, false, false, false, true,true  },
            name= 'stoemail',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                local email = self.parent.cn:use_email(cn)
                if #args == 0 then
                    self.parent.sv:server_log_visit_to_msmtp(email)
                    self.parent.say:me(cn,string.format(self.parent.cnf.shell.text[self.name..'_text'],email))
                    return
                end
                if #args >= 1 then
                    if args[1] == '-h' then
                        self.parent.say:me(cn,self.parent.cnf.shell.text[self.name..'_help_0'])
                        self.parent.say:me(cn,string.format(self.parent.cnf.shell.text[self.name..'_help_1'],tostring(self.parent.cnf.server.msmtp.allert_and_send_to.log_visit.time_period)))
                        return
                    end
                    if args[1] ~= nil or ( args[1] ~=nil and args[2] ~= nil ) then
                        self.parent.sv:server_log_visit_to_msmtp(email,nil,args[1],args[2])
                        self.parent.say:me(cn,string.format(self.parent.cnf.shell.text[self.name..'_text'],email))
                        return
                    end
                end
                self.parent.say:me(cn,string.format(self.parent.cnf.shell.text.shell_error,self.name))
            end
        },

        -- UTILITES --

        ['~uuid'] = '',['!uuid'] = '',['@uuid'] = '',['#uuid'] = '',['%uuid'] = '',['^uuid'] = '',
        ["$uuid"] = {
            protected = { true, true, false, false, false, false, true  },
            name= 'uuid',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                local dcn, cnf = self.parent.cn:get_dcn(cn), self.parent.cnf.shell[self.name]
                local text,f,r,u,n,cm = cnf.text,false,NOT_GENERATE,NOT_GENERATE,NOT_PLAYER,NOT_GENERATE
                if #args >= 1 then
                    if args[1] == '-error' then self.parent.say:me(cn,string.format(self.parent.cnf.shell.text.shell_error,self.name)) return end
                    if args[1] == '-h' then self.parent.say:me(cn,text['help']) return end
                    if args[1] == '-empty' then
                        f,r,u,n,cm = self.parent.sql:uuid_user_util()
                        if f then
                            self.parent.say:me(cn,string.format(text['user_util_chk_empty'],tostring(r),cm)) return
                        else
                            self.parent.say:me(cn,string.format(text['user_util_err'],tostring(r)))
                        end
                        return
                    end
                    if args[1] == '-regen' then
                        if tonumber(args[2])~=nil then args[2] = self.parent.cn:get_name(tonumber(args[2])) end
                        if args[2]~=nil and args[2]~=NOT_PLAYER then
                            if args[2] == 'all' then
                                f,r,u,n,cm = self.parent.sql:uuid_user_util(true)
                            else
                                f,r,u,n,cm = self.parent.sql:uuid_user_util(args[2])
                            end
                        else
                            self.parent.say:me(cn,string.format(text['user_util_err'],tostring(r))) return
                        end
                        if f then
                            self.parent.say:me(cn,string.format(text['user_util_chk_empty'],tostring(r),cm))
                            if u~= NOT_GENERATE then self.parent.say:me(cn,string.format(text['user_util_regen'],n,u,cm)) end
                        else
                            self.parent.say:me(cn,string.format(text['user_util_err'],tostring(r)))
                        end
                        return
                    end

                    if tonumber(args[1])~=nil then
                        args[1] = tonumber(args[1])
                        if self.parent.cn:chk_cn(args[1]) then
                            if self.parent.cn:chk_login(args[1]) then
                                self.parent.say:me(cn,string.format(text['player_uuid'],self.parent.cn:get_cname(args[1]),self.parent.cn:use_uuid(args[1])))
                                return
                            else
                                f,r,u,n,cm = self.parent.sql:uuid_user_util(self.parent.cn:get_name(args[1]),false)
                            end
                        else
                            self.parent.say:me(cn,string.format(text['not_cn'],args[1]))
                            return
                        end
                    elseif args[1]~=NOT_PLAYER then
                        f,r,u,n,cm = self.parent.sql:uuid_user_util(args[1],false)
                    end

                    if f then
                        if u~= NOT_GENERATE then
                            self.parent.say:me(cn,string.format(text['player_uuid'],n,u))
                        else
                            self.parent.say:me(cn,string.format(text['player_uuid_empty'],n))
                        end
                    else
                        if tonumber(r) and r==0 then
                            self.parent.say:me(cn,string.format(text['not_player'],n)) return
                        end
                        self.parent.say:me(cn,string.format(text['user_util_err'],tostring(r)))
                    end
                    return

                end

                if #args == 0 then
                    u = self.parent.cn:use_uuid(cn)
                    if u == '' then u = '\f3EMPTY' end
                    self.parent.say:me(cn,string.format(text['your'],u))
                    return
                end
            end
        },

        -- ADMIN !!! --
        ['~userdata'] = '',['!userdata'] = '',['@userdata'] = '',['#userdata'] = '',['%userdata'] = '',['^userdata'] = '',
        ["$userdata"] = {
            protected = { true, false, false, false, false, false, true  },
            name= 'userdata',
            cfn = function (self,cn, args)
                self.parent.log:i("used "..self.name..' '..table.concat(args,' '),cn)
                if #args >=1 then
                    if args[1] == '-h' then self.parent.say:me(cn,self.parent.cnf.shell.text.not_help) return end
                    if args[1] == '-i' then
                        local f,d = self.parent.sql:get_user_account_data(args[2])
                        if not f then return false, d end
                        d.count = d['count_login_'..self.parent.flag.SERVER]
                        d.score_of_maps = self.parent.sql:get_user_data_gema_score(d.uuid)
                        local df,dg = self.parent.sql:user_data_gema(d.uuid,d.name)
                        if not df then return false, dg end
                        d.statistic_map = dg
                        return true, d
                    end
                end
                self.parent.say:me(cn,string.format(self.parent.cnf.shell.text.shell_error,self.name))
            end
        },

    },

    init = function(self,obj)
        self.parent = obj
        self.list = {[CR_ADMIN] = {}, [CR_REGISTERED] = {}, [CR_REFEREE] = {}, [CR_ROOT] = {}, [(CR_ROOT+1)] = {}}
        self.count = {
            fool = 0,
            show = 0,
            hidden = 0
        }
        for k,_ in pairs(self.commands) do
            if  string.byte(k,1) == string.byte("$",1) then
                self.commands[k].parent = self.parent
                self.commands[k].shell = self
                if self.commands[k].protected[1] then self.count.fool = self.count.fool + 1 end
                if self.commands[k].protected[7] then self.count.show = self.count.show + 1 end
                if not self.commands[k].protected[7] then self.count.hidden = self.count.hidden + 1 end
                if self.commands[k].protected[7] then
                    local cmd = k
                    if self.parent.cnf.shell.accent_command_colorize and self.commands[k].protected[8] ~=nil and self.commands[k].protected[8]  then
                        cmd = string.format('%s%s',cmd,'!')
                    end
                    if self.commands[k].protected[5] then
                        --self.list[CR_ADMIN] = string.format('\f2%s|%s', cmd, self.list[CR_ADMIN])
                        table.insert(self.list[CR_ADMIN], string.format('\f2%s', cmd))
                    elseif self.commands[k].protected[4] then
                        --self.list[CR_REGISTERED] = string.format('\f0%s|%s', cmd, self.list[CR_REGISTERED])
                        table.insert(self.list[CR_REGISTERED],string.format('\f0%s', cmd))
                    elseif self.commands[k].protected[3] then
                        --self.list[CR_REFEREE] = string.format('\f1%s|%s', cmd, self.list[CR_REFEREE])
                        table.insert(self.list[CR_REFEREE], string.format('\f1%s', cmd))
                    elseif self.commands[k].protected[2] then
                        --self.list[CR_ROOT] = string.format('\f9%s|%s', cmd,self.list[CR_ROOT])
                        table.insert(self.list[CR_ROOT], string.format('\f9%s', cmd))
                    elseif self.commands[k].protected[1] then
                        --self.list[(CR_ROOT+1)] = string.format('\f3%s|%s', cmd, self.list[(CR_ROOT+1)])
                        table.insert(self.list[CR_ROOT+1], string.format('\f3%s', cmd))
                    end
                end
            end
        end

        for k,v in ipairs(self.list) do
            --v = self.parent.fn:split(v:sub(0,#v-1),'|')
            table.sort(v,function(a,b)
                if string.byte(a,4) < string.byte(b,4) then return true else return false end
            end)
            --self.list[k] = table.concat(v,' \f4| ')
            self.list[k] = v
        end
        if self.parent.cnf.shell.accent_command_colorize then
            for k,v in ipairs(self.list) do
                --v = self.parent.fn:split(v,' \f4| ')
                for kk,vv in ipairs(v) do
                    if string.sub(vv,#vv) == '!' then
                        vv = vv:sub(3,#vv-1)
                        vv = self.parent.fn:random_color_char_string(vv, { from = 2, to = nil, [1] = SAY_NORMAL})
                    end
                    v[kk] = vv
                end
                --self.list[k] = table.concat(v," \f4| ")
                self.list[k] = v
            end
        end

        self.parent.log:i('Module shell init is OK')
    end
}
