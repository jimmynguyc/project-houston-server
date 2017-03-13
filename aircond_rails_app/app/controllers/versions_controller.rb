class VersionsController < ApplicationController
  def index
    @aircond = Aircond.find(params[:aircond_id])
    @versions = @aircond.versions
  end

  def show
    @aircond = Aircond.find(params[:aircond_id])
    @versions = @aircond.versions[params[:id]-1]
  end
end
