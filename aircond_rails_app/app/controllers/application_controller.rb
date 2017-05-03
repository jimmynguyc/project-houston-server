class ApplicationController < ActionController::Base
  include Clearance::Controller
  include ApplicationHelper
  protect_from_forgery with: :exception
  before_action :set_current_time

  def set_current_time
    @current_time= Time.zone.now
  end
end
