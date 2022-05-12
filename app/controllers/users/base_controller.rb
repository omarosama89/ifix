class Users::BaseController < ApplicationController
  protect_from_forgery with: :null_session

  @@cache = ActiveSupport::Cache::MemoryStore.new(expires_in: 3.minutes)

  def current_user
    # @current_user ||= User.find_by(id: )
  end
end
