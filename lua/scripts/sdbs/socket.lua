return {

    active = false,
    library = nil,

    init = function(self,obj)
        self.parent = obj
        if self.parent.cnf.sock.flag then
            -- self.driver = include(self.parent.cnf.sql.driver)
            self.parent.log:w('Load ... library SOCKET '..self.parent.cnf.sock.library)
            local callResult, result = pcall(require, self.parent.cnf.sock.library)
            if callResult then
                self.parent.sock.library = result
                self.active = true
                self.parent.log:w('Load library SOCKET '..self.parent.cnf.sock.library..' complete')
            else
                self.parent.log:w(result)
            end

            print(self:bind('127.0.0.1','8080'))

        else
            self.parent.log:w('SOCKET is disabled of CNF.')
        end
    end,

    connect = function (self, a, p, la, lp)
        local s, e, r = self.library.tcp(), nil
        if not s then return nil, e end
        if la then
            r, e = s:bind(la, lp, -1)
            if not r then return nil, e end
        end
        r, e = s:connect(a, p)
        if not r then return nil, e end
        return s
    end,

    bind = function (self, h, p, blog)
        local s, e, r = self.library.tcp(), nil
        if not s then return nil, e end
        s:setoption("reuseaddr", true)
        r, e = s:bind(h, p)
        if not r then return nil, e end
        r, e = s:listen(blog)
        if not r then return nil, e end
        return s
    end

}