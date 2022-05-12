module CodeAuthenticator
    TOKEN_LENGTH = 4
    class << self
        def generate
            TOKEN_LENGTH.times.map{rand(10)}.join
        end

        def check(code, cached_code)
            code == cached_code
        end
    end
end
