-- wait functions

--(int actor_cn)
function onPlayerPreconnect (cn)
    local ret = sdbs.cn:on_preconnect(cn)
    if ret == PLUGIN_BLOCK then return PLUGIN_BLOCK end
    return
end
--(int actor_cn)
function onPlayerConnect(cn)
    local ret = sdbs.cn:on_connect(cn)
    sdbs.sv:on_player_connect()
    if ret == PLUGIN_BLOCK then return PLUGIN_BLOCK end
    return
end
--(int actor_cn, int reason)
function onPlayerDisconnect(cn,reasson)
    sdbs.cn:on_disconnect(cn,reasson)
    sdbs.sv:on_player_disconnect()
    --return PLUGIN_BLOCK
    return
end
--(int actor_cn, string new_name)
-- Смена имени игроком
function onPlayerNameChange(cn, newname)
    local ret = sdbs.cn:on_rename(cn,newname)
    if ret == PLUGIN_BLOCK then return PLUGIN_BLOCK end
    return
end

--(int actor_cn, int new_role, string hash, bool player_is_connecting)
function onPlayerRoleChangeTry(cn, new_role, hash, isconnect)
end
--(int actor_cn, int new_role, string hash, int adminpwd_line, bool player_is_connecting)
function onPlayerRoleChange(cn, new_role, hash, pwd, isconnect)
    local ret = sdbs.cn:on_role_change(cn, new_role, hash, pwd, isconnect)
    if ret == PLUGIN_BLOCK then return PLUGIN_BLOCK end
    return
end
--(int target_cn, int actor_cn, bool gib, int gun)
-- Смерть игрока
function onPlayerDeath(tcn,cn,gib,gun)

end
--(int actor_cn, int target_cn, int damage, int actor_gun, bool gib)
-- Повреждение игрока
function onPlayerDamage(cn ,tcn, damage, gun, gib)
end
-- = int (vote error); (int actor_cn, int type, string text, int number, int vote_error)
-- голосование игроком
function onPlayerCallVote(cn, type_vote,text, number, vote_error)
    if sdbs.gm.vote:call_one_role_gema_server(cn) == PLUGIN_BLOCK then
        return PLUGIN_BLOCK
    end
    sdbs.gm.vote:init_list(cn, type_vote,text, number, vote_error)
    --sdbs.gm.vote:server_one(cn, type_vote,text, number, vote_error)
end
-- int actor_cn, int vote
function onPlayerVote(cn, vote)
    sdbs.gm.vote:vote_priveleges(cn,vote)
end
-- (int result, int owner_cn, int type, string text, int number)
function onVoteEnd(result,cn,type,text,number)

end
-- int result, int owner_cn, int type, string text, int number
function onVoteEndAfter(result, owner_cn, type, text, number)
end
--(int actor_cn, int sound)
--Игрок что то сказал в консоль
function onPlayerSayVoice(cn, sound)
end
-- (int sender_cn, string text, bool team, type = SV_TEXT, SV_TEXTME, SV_TEAMTEXT, SV_TEAMTEXTME, SV_TEXTPRIVATE)
function onPlayerSayText(cn,text,team,mtype)
    return sdbs.cn:on_say_text(cn,text,team,mtype)
end
--(int actor_cn, int action, int flag)
-- Действия с флагом
function onFlagAction(cn, action, flag)
    sdbs.gm.flag:on_flag_action(cn, action, flag)
    return
end
-- (string map_name, int game_mode)
-- Активация карты
function onMapChange(name, mode)
    sdbs.gm.map:on_map_change(name,mode)
    return
end
function onMapEnd()
    sdbs.gm.map:on_map_end()
    return
end
-- (int actor_cn, int new_weapon)
function onPlayerWeaponChange(cn,weapon)
    sdbs.cn:on_player_weapon_change(cn,weapon)
end

-- int actor_cn, int new_team, int forceteam_reason
function onPlayerTeamChange(actor_cn, new_team, forceteam_reason)
    --if sdbs.cn:on_spectate(actor_cn,new_team) then return PLUGIN_BLOCK end
    return sdbs.cn:on_player_team_change(actor_cn,new_team,forceteam_reason)
end
-- (int actor_cn, string hostname, int host, string host, bool is_connecting)
function onGetBanType(cn, name, hostname, ihost, shost,connecting)
    sdbs.log:w(string.format("Player N: %s | Name: %s | CHK ban HOSTNAME: %s | CHK ban IHOST: %s | CHK ban SHOST: %s | Connecting = %s",cn, name, hostname, ihost,shost, connecting))
    return sdbs.cn:get_ban_type(cn, name, hostname, ihost, shost,connecting)
end
function onChkGBan(shost)
    sdbs.log:w(string.format("CHK GBan SHOST: %s ",shost))
    return sdbs.cn:chk_gban(shost)
end
function onChkAfk(name)
    sdbs.log:w(string.format("HNL CHK Afk NAME: %s ",name))
    return sdbs.cn:chk_afk(name)
end
-- (string extension, int sender_cn, string argument)
function onExtension(ext,cn,arg)
end
-- (int sender_cn, int channel, int type)
--function onServerProcess(cn, chan, type )
    --if chan~= 0 and type ~= 45 and type ~= 47 then sdbs.log:e(tostring(chan)..' '..tostring(type) ) end
--end

sdbs.log:i('Module handlers init OK')
