class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: ENV['HTTP_LOGIN'], password: ENV['HTTP_PASSWORD']
end
