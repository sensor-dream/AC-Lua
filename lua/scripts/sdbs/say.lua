return {


    out = function(self,cn,text,excn)
        local text = string.format('%s%s',self.parent.cnf.say.text.color,text)
        clientprint(cn,text,excn)
    end,

    to = function(self,cn,tcn,text)
        if self.parent.cnf.show_mod or self.parent.cn:chk_show_mod(cn) or self.parent.cn:chk_show_mod(tcn) then self:out(tcn,text) end
    end,
    me = function(self,cn,text)
        if self.parent.cnf.show_mod or self.parent.cn:chk_show_mod(cn) then self:out(cn,text) end
    end,
    allex = function(self,excn,text)
        if self.parent.cnf.show_mod then self:out(-1,text,excn) end
    end,
    allexme = function(self,cn,text)
        if self.parent.cnf.show_mod then self:out(-1,text,cn) end
    end,
    all = function(self,text,cn)
        cn = cn or -1
        if self.parent.cnf.show_mod then self:out(cn,text) end
    end,

    smg = function(self,text,cn)
        cn = cn or -1
        self:out(cn,text)
    end,

    init = function(self,obj)
        self.parent = obj
       --self.parent = setmetatable( {}, { __index = obj } )
        --self.parent = setmetatable( {}, { __index = obj, __newindex = obj } )
        self.parent.log:i('Module say init OK')
    end
}