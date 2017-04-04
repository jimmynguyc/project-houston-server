class VersionsController < ApplicationController
  before_action :require_login
  def index

    if is_admin?
      @aircond = Aircond.find(params[:aircond_id])
      @versions = @aircond.versions.paginate(:page => params[:page],:pera_page => 30).order('created_at DESC')
    else
      flash[:warning] = "You are not authorized."
      redirect_to root_path
    end
  end
end
