return {

    text_log = function(self,flag,text,cn)
        local flag, text, name, ip = (flag or self.LOG_INFO),(text or "SYSTEM"), "SYSTEM", "SYSTEM"
        if isconnected(cn) then
            name = getname(cn) or "NOT_NAME"
            ip = getip(cn) or "NOT_IP"
            logline(flag,string.format("SDBS: Player %s CN %s says: %s. Their IP is: %s",name:gsub("%%", "%%%%"),cn, text:gsub("%%", "  %%%%") ,ip))
        else
            logline(flag,string.format("SDBS: Player %s says: %s.",name:gsub("%%", "%%%%"), text:gsub("%%", "  %%%%") ))
        end
    end,
    buff = {},
    --save in buffer
    set_buff = function(self, flag, text,cn )
        table.insert(self.buff, { flag = flag, text = text, cn = cn } )
    end,
    -- info
    ib = function (self,text, cn) if self.parent.flag.C_LOG or self.parent.flag.C_LOG_info then self:set_buff(LOG_INFO, text, cn) end end,
    --warning
    wb = function (self,text, cn) if self.parent.flag.C_LOG or self.parent.flag.C_LOG_warn then self:set_buff(LOG_WARN, text, cn) end end,
    --error
    eb = function (self,text, cn) if self.parent.flag.C_LOG or self.parent.flag.C_LOG_error then self:set_buff(LOG_ERR, text, cn) end end,
    --flush buff
    fb = function(self)
        if self.parent.C_LOG then
            if #self.buff > 0 then
                for _,v in ipairs(self.buff) do
                    self:text_log(v.flag,v.text, v.cn)
                end
                self.buff = nil
                self.buff = {}
            end
        end
    end,
    -- info
    i = function (self,text, cn) if self.parent.flag.C_LOG or self.parent.flag.C_LOG_info then self:text_log(LOG_INFO,text,cn) end end,
    --warning
    w = function (self,text, cn) if self.parent.flag.C_LOG or self.parent.flag.C_LOG_warn then self:text_log(LOG_WARN, text, cn) end end,
    --error
    e = function (self,text, cn) if self.parent.flag.C_LOG or self.parent.flag.C_LOG_error then self:text_log(LOG_ERR, text, cn) end end,

    init = function(self,obj)
        self.parent = obj
	    if self.parent.flag.C_LOG then self:i('Module log init OK') end
    end
}