return {


    -- FLAG
    flag = {
        action = {
                --number
            [FA_PICKUP] = PICKUP,
            [FA_STEAL] = STEAL,
            [FA_DROP] = DROP,
            [FA_LOST] = LOST,
            [FA_RETURN] = RETURN,
            [FA_SCORE] = SCORE,
            [FA_RESET] = RESET,
                --string
            [PICKUP] = FA_PICKUP,
            [STEAL] = FA_STEAL,
            [DROP] = FA_DROP,
            [LOST] = FA_LOST,
            [RETURN] = FA_RETURN,
            [SCORE] = FA_SCORE,
            [RESET] = FA_RESET,
        },
        get = function(self,action)
            if self.action[action] ~= nil then
                return self.action[action]
            end
            return nil
        end,

        on_flag_action =  function(self,cn,action,flag)
            if self.parent.parent.cn:chk_cn(cn) then
                local dcn = self.parent.parent.cn.data_cn[cn]
                local c_name = self.parent.parent.cn.data[dcn].c_name
                local name = self.parent.parent.cn.data[dcn].name
                self.fa = {
                    [DROP] = function(self,cn,action,flag)
                        if self.parent.parent.cnf.flag.drop.reset and self.parent.parent.sv:is_gema() and ( self.parent.map:is_gema_map() or self.parent.parent.cnf.flag.drop.ignored_is_gema ) then
                            self.parent.parent.log:i("The flag is DROP",cn)
                            flagaction(cn,self:get(RESET),flag)
                            if self.parent.parent.cnf.flag.drop.say_all then
                                self.parent.parent.say:allexme(cn,string.format(self.parent.parent.cnf.flag.drop.text.all,c_name..name))
                            end
                            if self.parent.parent.cnf.flag.drop.say_me then
                                self.parent.parent.say:me(cn,self.parent.parent.cnf.flag.drop.text.me)
                            end
                            self.parent.parent.cn.data[dcn].flag.statistic_gema_flag = false
                        end
                        self.parent.parent.cn.data[dcn].flag.n = nil
                        self.parent.parent.cn.data[dcn].flag.action = self:get(DROP)
                    end,
                    [LOST] = function(self,cn,action,flag)
                        if self.parent.parent.cnf.flag.lost.reset and self.parent.parent.sv:is_gema() and ( self.parent.map:is_gema_map() or self.parent.parent.cnf.flag.lost.ignored_is_gema ) then
                            self.parent.parent.log:i("The flag is RESET",cn)
                            flagaction(cn,self:get(RESET),flag)
                            if self.parent.parent.cnf.flag.lost.say_all then
                                self.parent.parent.say:allexme(cn,string.format(self.parent.parent.cnf.flag.lost.text.all,c_name..name))
                            end
                            if self.parent.parent.cnf.flag.lost.say_me then
                                self.parent.parent.say:me(cn,self.parent.parent.cnf.flag.lost.text.me)
                            end
                            self.parent.parent.cn.data[dcn].flag.statistic_gema_flag = false
                        end
                        self.parent.parent.cn.data[dcn].flag.n = nil
                        self.parent.parent.cn.data[dcn].flag.action = self:get(LOST)
                    end,
                    [STEAL] = function(self,cn,action,flag)
                        if  self.parent.parent.sv:is_gema() and ( self.parent.map:is_gema_map() or self.parent.parent.cnf.flag.steal.ignored_is_gema ) then
                            self.parent.parent.log:i("The flag is taken",cn)
                            if self.parent.parent.cnf.flag.steal.say_all then
                                self.parent.parent.say:allexme(cn,string.format(self.parent.parent.cnf.flag.steal.text.all,c_name..name))
                            end
                            if self.parent.parent.cnf.flag.steal.say_me then
                                self.parent.parent.say:me(cn,self.parent.parent.cnf.flag.steal.text.me)
                            end
                        end
                        self.parent.parent.cn.data[dcn].flag.n = flag
                        self.parent.parent.cn.data[dcn].flag.action = self:get(STEAL)
                    end,
                    [SCORE] = function(self,cn,action,flag)
                        if  self.parent.parent.sv:is_gema() and self.parent.map:is_ctf_map() and ( self.parent.map:is_gema_map() or self.parent.parent.cnf.flag.score.ignored_is_gema ) then
                            self.parent.parent.log:i("The flag is conveyed to base",cn)
                            if self.parent.parent.cnf.flag.score.say_all then
                                self.parent.parent.say:allexme(cn,string.format(self.parent.parent.cnf.flag.score.text.all,c_name..name))
                            end
                            if self.parent.parent.cnf.flag.score.say_me then
                                self.parent.parent.say:me(cn,self.parent.parent.cnf.flag.score.text.me)
                            end
                            if self.parent.parent.cn.data[dcn].access == true and self.parent.parent.cn.data[dcn].stopwatch.active_flag and self.parent.parent.cn.data[dcn].flag.statistic_gema_flag then

                                self.parent.parent.shell.commands['$stopwatch']:cfn(cn,{})

                                if self.parent.parent.cn.data[dcn].account.statistic_map.reset_map == 1 then
                                    self.parent.parent.cn.data[dcn].account.statistic_map.reset_map = 0
                                    self.parent.parent.cn:change_staistic_map(cn)
                                end

                                local cs, ce = self.parent.parent.sql:user_data_gema_score(cn,self.parent.parent.cn.data[dcn].stopwatch.diff_time)
                                if cs == 0 then
                                    self.parent.parent.say:me(cn,ce)
                                end

                                self.parent.parent.cn.data[dcn].account.statistic_map.count_score = ce.count_score

                                if self.parent.parent.cn.data[dcn].account.statistic_map.count_score == 1 then
                                    self.parent.parent.cn:use_score_of_maps(cn,1)
                                end

                                self.parent.parent.cn.data[dcn].account.statistic_map.time_score_old = ce.time_score_old
                                self.parent.parent.cn.data[dcn].account.statistic_map.time_score_best_old = ce.time_score_best_old
                                self.parent.parent.cn.data[dcn].account.statistic_map.time_score = ce.time_score
                                self.parent.parent.cn.data[dcn].account.statistic_map.time_score_best = ce.time_score_best

                                if self.parent.parent.cnf.gameplay.statistic.score_time_say_me then
                                    local score_time_me = ''
                                    if ce.time_score == ce.time_score_best then
                                        score_time_me = string.format(self.parent.parent.cnf.gameplay.statistic.text.score_time_best_me, self.parent.parent.fn:format_stopwatch_time(self.parent.parent.fn:get_sec_ms_time(ce.time_score)))
                                        if self.parent.parent.cnf.gameplay.statistic.score_time_best_old_say_me and ce.time_score_best_old > 0 then
                                            score_time_me = string.format('%s %s',score_time_me,self.parent.parent.cnf.gameplay.statistic.text.score_time_best_old_me)
                                            score_time_me = string.format(score_time_me,self.parent.parent.fn:format_stopwatch_time(self.parent.parent.fn:get_sec_ms_time(ce.time_score_best_old)))
                                        end
                                    else
                                        score_time_me = string.format(self.parent.parent.cnf.gameplay.statistic.text.score_time_me, self.parent.parent.fn:format_stopwatch_time(self.parent.parent.fn:get_sec_ms_time(ce.time_score)))
                                        if self.parent.parent.cnf.gameplay.statistic.score_time_old_say_me then
                                            score_time_me = string.format('%s %s',score_time_me,self.parent.parent.cnf.gameplay.statistic.text.score_time_old_me)
                                            score_time_me = string.format(score_time_me,self.parent.parent.fn:format_stopwatch_time(self.parent.parent.fn:get_sec_ms_time(ce.time_score_old)))
                                        end
                                        if self.parent.parent.cnf.gameplay.statistic.core_time_current_best_say_me then
                                            score_time_me = string.format('%s %s',score_time_me,self.parent.parent.cnf.gameplay.statistic.text.score_time_current_best_me)
                                            score_time_me = string.format(score_time_me,self.parent.parent.fn:format_stopwatch_time(self.parent.parent.fn:get_sec_ms_time(ce.time_score_best)))
                                        end
                                    end
                                    self.parent.parent.say:me(cn, score_time_me)
                                end

                                if self.parent.parent.cnf.gameplay.statistic.score_time_say_all then
                                    local score_time_all = string.format(self.parent.parent.cnf.gameplay.statistic.text.score_time_all,c_name..name,self.parent.parent.fn:format_stopwatch_time(self.parent.parent.fn:get_sec_ms_time(self.parent.parent.cn.data[dcn].account.statistic_map.time_score)))
                                    if self.parent.parent.cnf.gameplay.statistic.score_map_coount_say_all then
                                        score_time_all = string.format('%s %s',score_time_all, self.parent.parent.cnf.gameplay.statistic.text.score_map_all)
                                        score_time_all = string.format(score_time_all,self.parent.parent.cn.data[dcn].account.score_of_maps,self.parent.map:get_cgmaps(),self.parent.parent.fn:math_round(((self.parent.parent.cn.data[dcn].account.score_of_maps*100)/self.parent.map:get_cgmaps()),3),'%')
                                    end
                                    self.parent.parent.say:allexme(cn,score_time_all)
                                    --self.parent.parent.say:me(cn,score_time_all)
                                end

                            end
                            self.parent.parent.cn.data[dcn].flag.statistic_gema_flag = false
                        end
                        self.parent.parent.cn.data[dcn].flag.n = nil
                        self.parent.parent.cn.data[dcn].flag.action = self:get(SCORE)
                    end,
                    [PICKUP] = function(self,cn,action,flag)
                        if self.parent.parent.sv:is_gema() and ( self.parent.map:is_gema_map() or self.parent.parent.cnf.flag.pickup.ignored_is_gema ) then
                            self.parent.parent.log:i("The flag is raised",cn)
                            if self.parent.parent.cnf.flag.pickup.say_all then
                                self.parent.parent.say:allexme(cn,string.format(self.parent.parent.cnf.flag.pickup.text.all,c_name..name))
                            end
                            if self.parent.parent.cnf.flag.pickup.say_me then
                                self.parent.parent.say:me(cn,self.parent.parent.cnf.flag.pickup.text.me)
                            end
                            self.parent.parent.cn.data[dcn].flag.statistic_gema_flag = false
                        end
                        self.parent.parent.cn.data[dcn].flag.n = flag
                        self.parent.parent.cn.data[dcn].flag.action = self:get(PICKUP)
                    end
                }
                if self.fa[self:get(action)]~= nil then  self.fa[self:get(action)](self,cn,action,flag) end
            end
        end
    },

    -- MODE
    mode = {
        -- GM_DEMO - -1,GM_TDM - 0,GM_COOP - 1,GM_DM - 2,
        -- GM_SURV - 3,GM_TSURV - 4,GM_CTF - 5,GM_PF - 6,
        -- GM_LSS - 9,GM_OSOK - 10,GM_TOSOK - 11,GM_HTF - 13,
        -- GM_TKTF - 14,GM_KTF - 15,GM_NUM - 22
        types = {
                --number
            [GM_DEMO] = DEMO,     -- -1
            [GM_TDM] = TDM,       --0
            [GM_COOP] = COOP,     --1
            [GM_DM] = DM,         --2
            [GM_SURV] = SURV,     --3
            [GM_TSURV] = TSURV,   --4
            [GM_CTF] = CTF,       --5
            [GM_PF] = PF,         --6
            [GM_LSS] = LSS,       --9
            [GM_OSOK] = OSOK,     --10
            [GM_TOSOK] = TOSOK,   --11
            [GM_HTF] = HTF,       --13
            [GM_TKTF] = TKTF,     --14
            [GM_KTF] = KTF,       --15
            [GM_NUM] = NUM,        --22
                --string
            [DEMO] = GM_DEMO,     -- -1
            [TDM] = GM_TDM,       --0
            [COOP] = GM_COOP,     --1
            [DM] = GM_DM,         --2
            [SURV] = GM_SURV,     --3
            [TSURV] = GM_TSURV,   --4
            [CTF] = GM_CTF,       --5
            [PF] = PFGM_PF,       --6
            [LSS] = GM_LSS,       --9
            [OSOK] = GM_OSOK,     --10
            [TOSOK] = GM_TOSOK,   --11
            [HTF] = GM_HTF,       --13
            [TKTF] = GM_TKTF,     --14
            [KTF] = GM_KTF,       --15
            [NUM] = GM_NUM        --22
        },
        get = function(self,mode)
            if self.types[mode] ~= nil then
                return self.types[mode]
            end
            return nil
        end
    },
    -- MAP
    map = {
        count_maps = 0,
        count_rot_maps = 0,
        count_gema_maps = 0,
        count_rot_gema_maps = 0,
        name = nil,
        mode = nil,
        mode_gema = false,
        mode_str = nil,
        tmr_chk_autoteam = false,

        chk_count_maps = function(self)
            local smaps = getservermaps()
            local rmaps = getwholemaprot()
            self.count_maps = 0
            self.count_rot_maps = 0
            self.count_gema_maps = 0
            self.count_rot_gema_maps = 0
            self.count_maps = #smaps
            self.count_rot_maps = #rmaps
            for _,v in ipairs(smaps) do
                if self:chk_gema_map(v) then self.count_gema_maps = self.count_gema_maps + 1 end
            end
            for _,v in ipairs(rmaps) do
                --[[
                    maxplayer 12
                    allowVote 1
                    skiplines 0
                    minplayer 4
                    time 30
                    mode 5
                    map GEMA-Normal02
                ]]
                if self:chk_gema_map(v.map) then self.count_rot_gema_maps = self.count_rot_gema_maps + 1 end
            end
        end,

        get_cmaps = function(self)
            return self.count_maps
        end,

        get_crmaps = function(self)
            return self.count_rot_maps
        end,

        get_cgmaps = function(self)
            return self.count_gema_maps
        end,

        get_crgmaps = function(self)
            return self.count_rot_gema_maps
        end,

        chk_gema_map = function (self, mapname)
            mapname = mapname:lower()
            for _,v in ipairs(self.parent.parent.cnf.map.list.implicit) do
                if mapname:find(v) then
                    return true
                end
            end
            for i = 1, #mapname - #self.parent.parent.cnf.map.list.code + 1 do
                local match = 0
                for j = 1, #self.parent.parent.cnf.map.list.code do
                    for k = 1, #self.parent.parent.cnf.map.list.code[j] do
                        if mapname:sub(i+j-1, i+j-1) == self.parent.parent.cnf.map.list.code[j]:sub(k, k) then
                            match = match + 1
                        end
                    end
                end
                if match == #self.parent.parent.cnf.map.list.code then
                    return true
                end
            end
            return false
        end,

        is_gema_map = function(self)
            return self.mode_gema
        end,

        is_ctf_map = function(self)
            if self.mode_str == CTF then return true else return false end
        end,

        set_info = function(self,name,mode)
            self.name = name or getmapname()
            self.mode = mode or getgamemode()
            self.mode_str = self.parent.mode:get(self.mode)
            self.mode_gema = self:chk_gema_map(self.name)
            self:chk_count_maps()
        end,

        set_auto_team = function(self,name,mode)
            if #self.parent.parent.cn.data == 0 then
                tmr.remove(TMR_CHK_AUTOTEAM)
                self.tmr_chk_autoteam = false
            end
            if self.parent.parent.cnf.map.team.auto.map and self.parent.parent.cnf.map.team.mode[self.mode_str] ~= nil and self.parent.parent.cnf.map.team.mode[self.mode_str] == true then
                if  self:is_gema_map() then
                    if getautoteam() ~=  self.parent.parent.cnf.map.team.auto.gema then
                        setautoteam(self.parent.parent.cnf.map.team.auto.gema)
                        self.parent.parent.log:i("Map SET autoteam "..tostring(getautoteam()))
                    end
                else
                    if getautoteam() ~=  self.parent.parent.cnf.map.team.auto.map then
                        setautoteam(self.parent.parent.cnf.map.team.auto.map)
                        self.parent.parent.log:i("Map SET autoteam "..tostring(getautoteam()))
                    end
                end
            else
                --if getautoteam() then setautoteam(false) end
            end

            -- проверка мтр аутотеам
            if not self.parent.parent.cnf.disable_log_chk_mtr_autoteam then self.parent.parent.log:i("Map tmr chk autoteam ... ") end
        end,

        server_log_change_map_update = function(self,name)
            if self.parent.parent.cnf.server.log.active and self.parent.parent.cnf.server.log.map.active then
                if name ~= nil and name ~= '' then
                    self.parent.parent.sql:server_log_change_map_update(self.parent.parent.flag.SERVER,name)
                end
            end
        end,

        on_map_change = function(self,name,mode)

            self.parent.ban:reset()

            tmr_chk_autoteam = function()
                sdbs.gm.map.set_auto_team(sdbs.gm.map)
            end

            self:set_info(name, mode)
            self.parent.parent.log:i('Map: name '..self.name..' mode  '..self.mode_str..' is gema '..tostring(self.mode_gema)..' preset autoteam '..tostring(getautoteam()) )
            self:set_auto_team(name, mode)

            if #self.parent.parent.cn.data > 0 then self:say(name, mode) end
            -- self:say(name, mode)

            self.parent.parent.log:i("Map postset autoteam "..tostring(getautoteam()))

            for i = 0, maxclient() - 1 do

                if self.parent.parent.cn:chk_cn(i) then

                    self.parent.parent.cn.data[self.parent.parent.cn.data_cn[i]].team = getteam(i)

                    if  self.parent.parent.cn.data[self.parent.parent.cn.data_cn[i]].spectate_to_go then self.parent.parent.cn.data[self.parent.parent.cn.data_cn[i]].spectate_to_go = false end

                    if self.parent.parent.cn.data[self.parent.parent.cn.data_cn[i]].stopwatch.active_flag then
                        local difftime_say = self.parent.parent.cn.data[self.parent.parent.cn.data_cn[i]].stopwatch.difftime_say
                        self.parent.parent.cn.data[self.parent.parent.cn.data_cn[i]].stopwatch.difftime_say = false
                        self.parent.parent.shell.commands['$stopwatch']:cfn(i,{})
                        self.parent.parent.cn.data[self.parent.parent.cn.data_cn[i]].stopwatch.difftime_say = difftime_say
                    end

                    if self:is_gema_map() and self.parent.parent.sv:is_gema() and self:is_ctf_map() and self:is_gema_map() and self.parent.parent.cn:chk_login(i) then


                        --self.parent.weapon:set_pulemete(i)

                        self.parent.parent.cn:change_staistic_map(i)

                        if self.parent.parent.cnf.gameplay.statistic.info_change_map_say_me then
                            self.parent.parent.say:me(i,string.format(self.parent.parent.cnf.gameplay.statistic.text.info_change_map_say_me,self.parent.parent.cn.data[self.parent.parent.cn.data_cn[i]].account.statistic_map.count,self.parent.parent.fn:format_stopwatch_time(self.parent.parent.fn:get_sec_ms_time(self.parent.parent.cn.data[self.parent.parent.cn.data_cn[i]].account.statistic_map.time_score)),self.parent.parent.fn:format_stopwatch_time(self.parent.parent.fn:get_sec_ms_time(self.parent.parent.cn.data[self.parent.parent.cn.data_cn[i]].account.statistic_map.time_score_best)),self.parent.parent.cn.data[self.parent.parent.cn.data_cn[i]].account.statistic_map.count_score))
                        end
                    else
                        --self.parent.weapon:reset_set_pulemete(i)
                    end

                end
            end

            if self.parent.parent.cnf.map.team.auto.chk_tmr then
                if self.tmr_chk_autoteam then
                    tmr.remove(TMR_CHK_AUTOTEAM)
                    self.parent.parent.log:w("Map tmr chk autoteam STOP")
                end
                tmr.create(TMR_CHK_AUTOTEAM,self.parent.parent.cnf.map.team.auto.chk_tmr_time,'tmr_chk_autoteam')
                self.tmr_chk_autoteam = true
                self.parent.parent.log:w("Map tmr chk autoteam START autoteam: ")
            end

            self:server_log_change_map_update(name)
        end,

        on_map_end = function(self)

            for i = 0, maxclient() - 1 do
                if self.parent.parent.cn:chk_cn(i) then

                    if  self.parent.parent.cn.data[self.parent.parent.cn.data_cn[i]].spectate_to_go then self.parent.parent.cn.data[self.parent.parent.cn.data_cn[i]].spectate_to_go = false end

                    if self.parent.parent.cn.data[self.parent.parent.cn.data_cn[i]].stopwatch.active_flag then
                        local difftime_say = self.parent.parent.cn.data[self.parent.parent.cn.data_cn[i]].stopwatch.difftime_say
                        self.parent.parent.cn.data[self.parent.parent.cn.data_cn[i]].stopwatch.difftime_say = false
                        self.parent.parent.shell.commands['$stopwatch']:cfn(i,{})
                        self.parent.parent.cn.data[self.parent.parent.cn.data_cn[i]].stopwatch.difftime_say = difftime_say
                    end
                end
            end
            if self.tmr_chk_autoteam then
                tmr.remove(TMR_CHK_AUTOTEAM)
                self.tmr_chk_autoteam = false
                self.parent.parent.log:w("Map tmr chk autoteam STOP")
            end
        end,

        say = function (self,name,mode)
            if self.parent.parent.cnf.map.say.load_map then

                self.parent.parent.log:i('Changed map '..name..' mode', mode)

                local gema, mode, autoteam  = '', '',''

                if self.parent.parent.cnf.map.say.rules_map then
                    if self:is_gema_map() and self.parent.parent.cnf.map.say.rules_map_gema then
                        self.parent.parent.say:all(self.parent.parent.cnf.say.text.rules_map_gema)
                    elseif not self:is_gema_map() and self.parent.parent.cnf.map.say.rules_map_normal then
                        self.parent.parent.say:all(self.parent.parent.cnf.say.text.rules_map)
                    end
                end

                if self:is_gema_map() then
                    if self.parent.parent.cnf.map.say.load_map_gema then gema = self.parent.parent.cnf.say.text.atention_gema end
                end

                if self.parent.parent.cnf.map.say.load_map_mode then
                    mode = string.format(self.parent.parent.cnf.say.text.game_mode, self.mode_str)
                end

                if self.parent.parent.cnf.map.say.autoteam  then
                    if getautoteam() then
                        if self:is_gema_map() then
                            autoteam = string.format(self.parent.parent.cnf.say.text.autoteam, SAY_ENABLED_3)
                        else
                            autoteam = string.format(self.parent.parent.cnf.say.text.autoteam, SAY_ENABLED_0)
                        end
                    else
                        if self:is_gema_map() then
                            autoteam = string.format(self.parent.parent.cnf.say.text.autoteam, SAY_DISABLED_0)
                        else
                            autoteam = string.format(self.parent.parent.cnf.say.text.autoteam, SAY_DISABLED_3)
                        end
                    end
                elseif self:is_gema_map() then
                    if getautoteam() then autoteam = string.format(self.parent.parent.cnf.say.text.autoteam, SAY_ENABLED_3) end
                end

                self.parent.parent.say:all(string.format(self.parent.parent.cnf.say.text.load_map, self.name,mode,gema,autoteam))
            end
        end,
    },
    -- VOTE
    vote = {

        vote = nil,
        inc_vote = nil,

        -- voteactions
        -- VOTE_NEUTRAL - 0, VOTE_YES - 1, VOTE_NO - 2

        action = {
                --number
            [VOTE_NEUTRAL] = NEUTRAL,         --0
            [VOTE_YES] = YES,                 --1
            [VOTE_NO] = NO,                   --2
                --string
            [NEUTRAL] = VOTE_NEUTRAL,         --0
            [YES] = VOTE_YES,                 --1
            [NO] = VOTE_NO                    --2
        },

        get_action = function(self,action)
            if self.action[action] ~= nil then
                return self.action[action]
            end
            return nil
        end,

        -- votetypes
        -- SA_KICK - 0, SA_BAN - 1, SA_REMBANS - 2, SA_MASTERMODE - 3
        -- SA_AUTOTEAM - 4, SA_FORCETEAM - 5, SA_GIVEADMIN - 6
        -- SA_MAP - 7, SA_RECORDDEMO - 8, SA_STOPDEMO - 9, SA_CLEARDEMOS - 10
        -- SA_SERVERDESC - 11, SA_SHUFFLETEAMS - 12

        types = {
                --number
            [SA_KICK] = KICK,                 --0
            [SA_BAN] = BAN,                   --1
            [SA_REMBANS] = REMBANS,           --2
            [SA_MASTERMODE] = MASTERMODE,     --3
            [SA_AUTOTEAM] = AUTOTEAM,         --4
            [SA_FORCETEAM] = FORCETEAM,       --5
            [SA_GIVEADMIN] = GIVEADMIN,       --6
            [SA_MAP] = MAP,                   --7
            [SA_RECORDDEMO] = RECORDDEMO,     --8
            [SA_STOPDEMO] = STOPDEMO,         --9
            [SA_CLEARDEMOS] = CLEARDEMOS,     --10
            [SA_SERVERDESC] = SERVERDESC,     --11
            [SA_SHUFFLETEAMS] = SHUFFLETEAMS,  --12
                --string
            [KICK] = SA_KICK,                 --0
            [BAN] = SA_BAN,                   --1
            [REMBANS] = SA_REMBANS,           --2
            [MASTERMODE] = SA_MASTERMODE,     --3
            [AUTOTEAM] = SA_AUTOTEAM,         --4
            [FORCETEAM] = SA_FORCETEAM,       --5
            [GIVEADMIN] = SA_GIVEADMIN,       --6
            [MAP] = SA_MAP,                   --7
            [RECORDDEMO] = SA_RECORDDEMO,     --8
            [STOPDEMO] = SA_STOPDEMO ,         --9
            [CLEARDEMOS] = SA_CLEARDEMOS,     --10
            [SERVERDESC] = SA_SERVERDESC,     --11
            [SHUFFLETEAMS] = SA_SHUFFLETEAMS  --12
        },
        get_vote = function(self,vote)
            if self.types[vote] ~= nil then
                self.vote = self.types[vote]
                self.inc_vote = vote
                return self.vote, self.inc_vote
            end
            self.vote = nil
            self.inc_vote = nil
            return nil, nil
        end,

        list = {},

        init_list = function(self,cn, type_vote,text, number, vote_error)
            self.list = self:clear_list()
            self.list.initiator = cn
            table.insert(self.list.yes,cn)
            self.list.type_str ,self.list.type = self:get_vote(type_vote)
            self.list.text = text
            self.list.number = number
            self.list.vote_error = vote_error
        end,

        clear_list = function(self)
            return {
                initiator = -1,
                yes = {},
                no = {},
                type_inc = nil,
                type_str = nil,
                text = nil,
                number = nil,
                error = nil
            }
        end,

        vote_priveleges = function(self,cn,vote)
            if self.list.initiator ~= cn then
                if self.cnf.active and self.cnf.accept_private_role.active then
                    local role = self.parent.parent.cn:get_role(self.parent.parent.cn:get_role_cn(cn))
                    if role ~= nil and self.cnf.accept_private_role.role[role] ~= nil and self.cnf.accept_private_role.role[role] == true then
                        if self.cnf.accept_private_role.type[self.list.type_str] ~= nil and self.cnf.accept_private_role.type[self.list.type_str] == true then
                            if self.list.type_str == KICK or self.list.type_str == BAN then
                                if self:get_action(vote) == YES  then
                                    local ip, name = self.parent.parent.cn:get_ip(self.list.number),self.parent.parent.cn:get_name(self.list.number)
                                    for _,v in ipairs(self.parent.parent.cn.data) do
                                        if ( self:get_action(getvote(v.cn)) ~= YES and self:get_action(getvote(v.cn)) ~= NO ) and v.cn~= self.list.initiator and v.cn ~= cn then
                                            self:get_action(getvote(v.cn))
                                            voteas(v.cn,self:get_action(YES))
                                        end
                                    end
                                    if self.list.type_str == BAN then
                                        local reasson = self.parent.parent.cnf.shell.kick.reasson
                                        self.parent.parent.cnf.shell.kick.reasson = 'M'..self.list.type_str
                                        --print(self.parent.parent.fn:reverse_ip(ip))
                                        --print(ip)
                                        removeban(self.parent.parent.fn:reverse_ip(ip))
                                        --removebans()
                                        local flag = true
                                        for _,v in ipairs(self.parent.ban.list) do
                                            if name == v.name then flag = false break end
                                            if ip == v.ip then flag = false break end
                                        end
                                        if flag then
                                            table.insert(self.parent.ban.list,{name=name,ip=ip,reasson=self.parent.parent.cnf.shell.kick.reasson})
                                        end
                                        self.parent.parent.cnf.shell.kick.reasson = reasson
                                    end
                                else
                                    for _,v in ipairs(self.parent.parent.cn.data) do
                                        if ( self:get_action(getvote(v.cn)) ~= YES and self:get_action(getvote(v.cn)) ~= NO ) and v.cn~= self.list.initiator and v.cn ~= cn then
                                            self:get_action(getvote(v.cn))
                                            voteas(v.cn,self:get_action(NO))
                                        end
                                    end
                                    --voteend(self.list.number)
                                end
                            end
                        end
                    end
                end
            end
        end,

        call_one_role_gema_server = function(self,cn)
            if self.parent.parent.sv:is_gema() and not self.cnf.gema_server.allow and not self.parent.parent.cn:chk_role(cn) then
                return PLUGIN_BLOCK
            end
        end,

        -- TO DO --
        --[[
        server_one = function(self,cn, type_vote,text, number, vote_error)
            local cnf = self.parent.parent.cnf.vote
            if cnf.server_one[self.parent.parent.flag.SERVER].active and
                cnf.server_one[self.parent.parent.flag.SERVER].allow[self:get_vote(type_vote)] then
                self:get_vote(type_vote)
            end
        end,
        ]]

    },

    weapon = {
        l_gun = {
            --number
            [GUN_KNIFE] = KNIFE,
            [GUN_PISTOL] = PISTOL,
            [GUN_CARBINE] = CARBINE,
            [GUN_SHOTGUN] = SHOTGUN,
            [GUN_SUBGUN] = SUBGUN,
            [GUN_SNIPER] = SNIPER,
            [GUN_ASSAULT] = ASSAULT,
            [GUN_CPISTOL] = CPISTOL,
            [GUN_GRENADE] = GRENADE,
            [GUN_AKIMBO] = AKIMBO,
            [NUMGUNS] = NUM,
            --string
            [KNIFE] = GUN_KNIFE,
            [PISTOL] = GUN_PISTOL,
            [CARBINE] = GUN_CARBINE,
            [SHOTGUN] = GUN_SHOTGUN,
            [SUBGUN] = GUN_SUBGUN,
            [SNIPER] = GUN_SNIPER,
            [ASSAULT] = GUN_ASSAULT,
            [CPISTOL] = GUN_CPISTOL,
            [GRENADE] = GUN_GRENADE,
            [AKIMBO] = GUN_AKIMBO,
            [NUM] = NUMGUNS,
        },

        get_gun = function(self,gun)
            if self.l_gun[gun] ~= nil then
                return self.l_gun[gun]
            end
            return nil
        end,
    },

    -- BAN CUREENT MAP name and ip  for include auto insert table [0] = {name= '',ip = ''} --
    ban = {
        list = {},
        reset = function(self)
            self.list = {}
        end,
    },

    init = function(self,obj)
    --[[
        self.parent = setmetatable( {}, { __index = obj } )
        self.flag.parent = setmetatable( {}, { __index = self } )
        self.mode.parent = setmetatable( {}, { __index = self } )
        self.map.parent = setmetatable( {}, { __index = self } )
        self.vote.parent = setmetatable( {}, { __index = self } )
    ]]
        self.parent = obj
        self.flag.parent = self
        self.mode.parent = self
        self.map.parent = self
        self.vote.parent = self
        self.vote.cnf = self.parent.cnf.vote
        self.weapon.parent = self
        self.ban.parent = self
        self.parent.log:w('GAME init OK')
    end
}