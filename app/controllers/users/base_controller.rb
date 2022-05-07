class Users::BaseController < ApplicationController
  @@cache = ActiveSupport::Cache::MemoryStore.new(expires_in: 3.minutes)
end
