module CodeAuthenticator
    TOKEN_LENGTH = 4
    class << self
        def generate
            TOKEN_LENGTH.times.map{rand(10)}.join
        end

        def check(code, other_code)
            code == other_code
        end
    end
end
