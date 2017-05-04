class AircondGroupsController < ApplicationController
  def create
    ac_grp = AircondGroup.new(set_ac_grp_params)
    ac_grp.save
    @airconds = Aircond.all
    @aircond_groups = AircondGroup.filter_group_view(params[:group_id])
    redirect_to aircond_groups_path
  end

  def show
    @aircond_groups = AircondGroup.includes(:airconds).order(:created_at).all
    @aircond_group = AircondGroup.find(params[:id])
    respond_to do |format|
      format.html
      format.js {
        render json: @aircond_group
      }
    end
  end


  def destroy
    ac_grp = AircondGroup.find(params[:id])
    if ac_grp.delete
      render json:{response:'Group deleted successfully.'}
    else
      render json:{response:'Group not deleted'}
    end
  end

  def index
    @airconds = Aircond.all
    @aircond_groups = AircondGroup.filter_group_view(params[:group_id])
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end


  private

  def set_ac_grp_params
    params.require(:aircond_group).permit(:title)
  end
end
