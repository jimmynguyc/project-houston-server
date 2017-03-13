class ApplicationController < ActionController::Base
  include Clearance::Controller
  include ApplicationHelper
  protect_from_forgery with: :exception
end
