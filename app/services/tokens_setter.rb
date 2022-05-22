class TokensSetter < ActiveInteraction::Base
    include Dry::Monads[:result]

    LENGTH = 24
    interface :object, methods: %i[token reset_token]

    def execute
        if object.update(token: token, reset_token: token)
            Success(object)
        else
            Failure(object.errors)
        end
    end

    private

    def token
        SecureRandom.base64(LENGTH)
    end
end
