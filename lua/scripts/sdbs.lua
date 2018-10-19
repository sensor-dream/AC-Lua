PLUGIN_NAME = "aCmOdFoRvAh"
PLUGIN_AUTHOR = "SDBS (sensor-dream)"
PLUGIN_VERSION = "1.1.0"
PLUGIN_SITE = "https://github.com/sensor-dream/luamod"
PLUGIN_EMAIL = "sensor-dream@sensor-dream.ru"
PLUGIN_DESCRIPTION = "Is provided as is. Use at your own risk. The author for the use of this code is not responsible"

-- права должны быть admin или root:
-- /serverextension lua::reload

-- права должны быть admin или root:
-- /serverextension lua::unload

-- права должны быть admin:
-- /serverextension lua::load

sdbs = {
    path = "lua/scripts/sdbs/",
    cpath = "lua/extra/"
}

package.path = sdbs.path.."?.lua;"
package.cpath = sdbs.cpath.."?.so;"

-- Пишет в stdout, для отладки токо
sdbs.flag = {
    SERVER = '',
    C_LOG = true,
    C_LOG_info = true,
    C_LOG_warn = true,
    C_LOG_error = true,
    geo_country = false,
    geo_city = false,
}

sdbs.fn = require('constants')
sdbs.fn = require('fn')
sdbs.fn:init(sdbs)
sdbs.fn:load('log')

local callResult, result = pcall(require, 'cnf')
if callResult then sdbs.cnf = result sdbs.log:i('Module cnf init OK') else
    sdbs.log:w(result)
    --sdbs.log:w("Restore default configuration")
    --sdbs.fn:copy_file(sdbs.path.."def/cnf.lua",sdbs.path.."cnf.lua")
    --sdbs.log:w("Load default configuration")
    --sdbs.fn:load('cnf')
end

sdbs.fn:load('say')
sdbs.fn:load('sql')
sdbs.fn:load('sock','socket')
sdbs.fn:load('gm','game')
sdbs.fn:load('cn')
sdbs.fn:load('shell')
sdbs.fn:load('sv', 'server')

if sdbs.cnf.geo.active then
    if sdbs.cnf.geo.country then
        sdbs.flag.geo_country = geoip.load_geoip_database(sdbs.path..sdbs.cnf.geo.f_country)
        if sdbs.flag.geo_country then sdbs.log:i("Activate GeoIP Country + CC") else sdbs.log:w("Not activate GeoIP Country + CC") end
    end
    if sdbs.cnf.geo.city then
        sdbs.flag.geo_city = geoip.load_geocity_database(sdbs.path..sdbs.cnf.geo.f_city)
        if sdbs.flag.geo_city then sdbs.log:i("Activate GeoIP City") else sdbs.log:w("Not activate GeoIP City") end
    end
end

require('handlers')


function onInit()
    sdbs.flag.C_LOG_info = sdbs.cnf.c_log.info
    sdbs.flag.C_LOG_warn = sdbs.cnf.c_log.warn
    sdbs.flag.C_LOG_error = sdbs.cnf.c_log.error
    if sdbs.cnf.server.name == nil or sdbs.cnf.server.name == '' then sdbs.cnf.server.name = 'gema' end
    sdbs.flag.SERVER = sdbs.cnf.server.name:lower()
    if sdbs.sv:is_gema() then sdbs.cnf.show_mod = true end
    sdbs.sv:start_server()
    sdbs.sv:start_timer_service()
    sdbs.cnf.map.say.load_map = false
    setautoteam(false)
    callhandler('onMapChange', getmapname(), getgamemode())
    sdbs.cnf.map.say.load_map = true
    sdbs.log:w("Map autoteam is  "..tostring(getautoteam()))
    flag_getdemo(sdbs.cnf.server.demo.get_flag)
    if flag_reloadmod() then
        sdbs.log:w('Reinit Player...')
        for cn = 0,  maxclient() -1 do
            if isconnected(cn) then
                --callhandler('onPlayerPreconnect', cn)
                callhandler('onPlayerConnect', cn)
            end
        end
        sdbs.log:w('Reinit '..tostring(#sdbs.cn.data)..' Players')
        flag_reloadmod(false)
    end
    sdbs.log:w("Init mod "..PLUGIN_NAME..' OK')
    sdbs.flag.C_LOG = sdbs.cnf.c_log.active
end

function onDestroy(cn)
    sdbs.flag.C_LOG = true
    if flag_reloadmod() then
        if sdbs.cn:chk_cn(cn) then
            sdbs.say:all(string.format(sdbs.cnf.say.text.unloading_message,sdbs.cn.data[sdbs.cn.data_cn[cn]].c_name..sdbs.cn.data[sdbs.cn.data_cn[cn]].name))
        else
            sdbs.say:all(string.format(sdbs.cnf.say.text.unloading_message,'SYSTEM'))
        end
    end
    sdbs.log:w("Destroy mod "..PLUGIN_NAME..'...')
    sdbs.gm.map:on_map_end()
    for cn = 0, maxclient() - 1 do
        if isconnected(i) then
            callhandler('onPlayerDisconnect', cn, DISC_NONE)
            --sdbs.cn:on_disconnect(i)
        end
    end
    sdbs.cn.data = nil;
    sdbs.cn.data_cn = nil;
    sdbs.sv:stop_timer_service()
    sdbs.sv:stop_server()
    sdbs.sql:destroy()
    sdbs.log:i("Destroy mod "..PLUGIN_NAME..' OK')
end
