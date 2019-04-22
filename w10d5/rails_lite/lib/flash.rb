require 'json'

class Flash
    attr_reader :req, :flash, :messages_now
    def initialize(req)
        @req = req
        @flash = {}
        cookie = req.cookies['_rails_lite_app_flash']
        @messages_now = cookie ? JSON.parse(cookie) : {}
    end

    def []=(key, value)
        @flash[key.to_sym] = value
        
    end

    def store_flash(res)
        cookie = {path: "/" , value: @flash.to_json }
        res.set_cookie("_rails_lite_app_flash", cookie )
    end

    def [](key)
         @messages_now[key.to_sym] || @flash[key.to_sym]
    end

    def now
        @messages_now
    end
end
