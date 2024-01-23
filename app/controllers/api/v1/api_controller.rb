module Api::V1
  class ApiController < ApplicationController
    include ActionController::HttpAuthentication::Basic::ControllerMethods
    # Require username and password for all actions
    http_basic_authenticate_with name: ENV['AUTHENTICATE_NAME'], password: ENV['AUTHENTICATE_PASSWORD']
  end
end