class VersionsController < ApplicationController
  before_action :require_login
  def index

    if is_admin?
      @aircond = Aircond.find(params[:aircond_id])
      @versions = @aircond.versions.reorder('created_at DESC').paginate(:page => params[:page],:per_page => 30)
    else
      flash[:warning] = "You are not authorized."
      redirect_to root_path
    end
  end
end
