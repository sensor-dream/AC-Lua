-- функции общего назначения

return {

    split = function(self,p,d)
        local t, ll
        t={}
        ll=0
        if(#p == 1) then return {p} end
        while true do
            l=string.find(p,d,ll,true)
            if l~=nil then
                table.insert(t, string.sub(p,ll,l -1))
                ll=l+string.len(d)
            else
                table.insert(t, string.sub(p,ll))
                break
            end
        end
        return t
    end,

    slice = function(self,array, S, E)
        local result = {}
        local length = #array
        S = S or 1
        E = E or length
        if E < 0 then
            E = length + E + 1
        elseif E > length then
            E = length
        end
        if S < 1 or S > length then
            return {}
        end
        local i = 1
        for j = S, E do
            result[i] = array[j]
            i = i + 1
        end
        return result
    end,

    -- ({ ['pattern'] = 'replacement' [, n] })
    str_replace = function(self,str,arg)
        for k,v in pairs(arg) do
            --print(k..' = "'..v..'"')
            str = string.gsub(str,k,v)
        end
        return str
    end,

    ltrim = function(self, s) -- remove leading whitespaces
        return (s:gsub("^%s*", ""))
    end,

    trim = function(self, s) --remove leading and trailing whitespace
        return (s:gsub("^%s*(.-)%s*$", "%1"))
    end,

    rtrim = function(self, s) --remove trailing whitespace
        local n = #s
        while n > 0 and s:find("^%s", n) do n = n - 1 end
        return s:sub(1, n)
    end,

    compare = function(self, str1, str2)
      return (str1 == str2)
    end,

    icompare = function(self, str1, str2)
      return (string.toupper(str1) == string.toupper(str2))
    end,

    reverse_number = function(self, num)
      local str = tostring(num) -- преобразуем число в строку
      str = string.reverse(str) -- переворачиваем строку
      return tonumber(str) -- преобразуем обратно в число и возвращаем
    end,

    reverse_list = function(self,list)
        for i=1, math.floor(#list / 2) do
            list[i], list[#list - i + 1] = list[#list - i + 1], list[i]
        end
        return list or {}
    end,

    split_reverse_ip = function(self,ip)
        return self:reverse_list(self:split(sip,"."))
    end,

    reverse_ip = function(self,sip)
        local sip = self:reverse_list(self:split(sip,"."))
        return table.concat(sip,".")
    end,

    private_ip = function(self,sip)
        local pip,sip = '', self:split(sip,".")
        for i = 1, #sip -1 do
            pip = pip..sip[i]..'.'
        end
        return pip..'X'
    end,


    shuffle =function (self, t)
        local n,nf = #t, #t --___ME__ fixed this function so it doesn't always start with the same map every time you reload the server, I just like my random to be random
        while n > 0 do
            local k = math.random(nf)
            t[n], t[k] = t[k], t[n]
            n = n - 1
        end
        return t
    end,
    -- проверка, что переменная это число, строка или булевский тип)
    is_valid_type = function (self,value_type)
        return "number" == value_type or
                "boolean" == value_type or
                "string" == value_type
    end,

    isbool = function(self,val)
        return "boolean" == type(val)
    end,

    isnum = function(self,val)
        return "number" == type(val)
    end,

    isstr = function(self,val)
        return "string" == type(val)
    end,

    -- конвертация переменной в строку
    value_to_str = function (self,value)
        local value_type = type(value)
        if "number" == value_type or "boolean" == value_type then
            result = tostring(value)
        else  -- assume it is a string
            result = string.format("%q", value)
        end
        return result
    end,

    backup_file = function(self, file)
        os.execute("cp --backup=t "..file.." "..file..".back")
    end,

    copy_file = function(self, from,to)
        os.execute("cp "..from.." "..to)
    end,

    random_color = function (self)
        return C_CODES[math.random(1, #C_CODES)]
    end,

    random_color_cn = function (self)
        C_CN_CODES = self:shuffle(C_CN_CODES)
        return C_CN_CODES[math.random(#C_CN_CODES)]
    end,

    -- 0 < 17
    random_color_fix = function (self)
        return self:random_color_cn()
    end,

    random_color_char_string = function (self,text,arg)
        local t = ''
        if type(arg) ~= 'table' then arg = {} end
        arg.from, arg.to = arg.from or 1, arg.to or #text
        if arg.from < 1 then arg.from = 1 end
        if arg.from > #text-1 then arg.from = #text-1 end
        if arg.to < 2 and arg.from > 1 then arg.to = arg.from +1 end
        if arg.to > #text then arg.to = #text end
        for i = 1, #text do
            if arg[i] ~= nil then
                t = string.format('%s%s%s',arg[i],t,string.sub(text,i,i-#text-1))
            elseif i >= arg.from and i <= arg.to then
                if arg[i] ~= nil then
                    t = string.format('%s%s%s',arg[i],t,string.sub(text,i,i-#text-1))
                else
                    t = string.format('%s%s%s',t,self:random_color_cn(),string.sub(text,i,i-#text-1))
                end
            else
                t = string.format('%s%s',t,string.sub(text,i,i-#text-1))
            end
        end
        return t
    end,

    format_say_text_out = function(self,text)
        return string.gsub(string.gsub(string.gsub(string.gsub(text,"\\f","\f"),'\\F','\f'),'\\n','\n'),'\\t',SAY_TAB)
    end,

    get_sec_ms_time = function(self,time)
        local sec, msec = math.modf(time/1000)
        msec = math.floor(msec*1000)
        return sec,msec
    end,

    format_stopwatch_time = function(self,sec,msec)
        if sec == nil then return '' end
        local sec,msec = sec,msec
        local date = os.date('!*t',sec)
        if msec ~= nil then msec = ' '..tostring(msec)..'ms' else msec = '' end
        if date.sec < 10 then date.sec = '0'..tostring(date.sec)..'s' else date.sec = tostring(date.sec)..'s' end
        if date.min > 0 then
            if date.min < 10 then date.min = '0'..tostring(date.min)..'m ' else date.min = tostring(date.min)..'m ' end
        else
            date.min = ''
        end
        if date.hour > 0 then
            if date.hour < 10 then date.hour = '0'..tostring(date.hour)..'h' else date.hour = tostring(date.hour)..'h' end
        else
            date.hour = ''
        end
        if date.day > 1 then date.day = tostring(date.day-1)..'d ' else date.day = '' end
        return date.day..date.hour..date.min..date.sec..msec
    end,

    -- (дополняет библиотеку math) ОКРУГЛЯЕТ ЧИСЛО ДО УКАЗАННОЙ ТОЧНОСТИ
    math_round = function(self,num, idp)
        local mult = 10^(idp or 0)
        return math.floor(num * mult + 0.5) / mult
    end,

    -- https://gist.github.com/jrus/3197011
    --type nil - fool uuid, 8 - 8 chars, 4 - 4 chars, 12 - 12 chars
    uuid = function(self,t)
        --math.randomseed(os.time())
        local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
        template = string.gsub(template, '[xy]', function (c)
            local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
            return string.format('%x', v)
        end)
        if t == nil then return template end
        template = self:split(template,'-')
        t = tonumber(t)
        if t ~= nil and t == 8 then return template[1] end
        if t ~= nil and t == 4 then return template[2] end
        if t ~= nil and t == 12 then return template[5] end
    end,

    find_SPECL = function (self,str)
        for _,v in ipairs(L_SPECL) do
            if string.find(str,v,1,true) ~= nil then
                return true
            end
        end
        return false
    end,

    chk_EMAIL = function (self,str)
        str = string.reverse(str)
        local e = string.find(str,L_chk_EMAIL[1],1,true)
        local p = string.find(str,L_chk_EMAIL[2],1,true)
        if p ~= nil and e ~= nil and p > 2 and p+1 < e then
            if string.find(str,L_chk_EMAIL[1],e+1,true) == nil then
                return true
            end
        end
        return false
    end,
--[[
    escape_SPECL = function (self,str)
        for _,v in ipairs(L_SPECL) do
            if string.find(str,v)~=nil then
                str = string.gsub(str,v,'\\'..v)
            end
        end
        return str
    end,
]]
--[[
    colorize_text = function (self,text)
      for i = 1, #C_CODES do
        text = text:gsub(CC_LOOKUP[i], C_CODES[i])
      end
      return text
    end,
]]
    -- ( string name, string path )
    load = function(self,name,path)
        path = path or name
        self.parent[name] = require(path)
        if self.parent[name].init ~= nil then
            self.parent[name]:init(self.parent)
        else
            if self.parent.C_LOG  then logline(2,string.format('SDBS: Player SYSTEM says: Module %s init OK',name)) end
        end
    end,


    init = function(self,obj)
       self.parent = obj
        --self.parent = setmetatable( {}, { __index = obj } )
        --self.parent = setmetatable( {}, { __index = obj, __newindex = obj } )
       if self.parent.flag.C_LOG then logline(2,'SDBS: Player SYSTEM says: Module function init OK') end
    end

}
