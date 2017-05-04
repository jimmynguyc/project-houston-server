class AircondGroupsController < ApplicationController
  def index
    @aircond_groups = AircondGroup.order(:create_at).all
  end

  def create
    ac_grp = AircondGroup.new(set_ac_grp_params)
    ac_grp.save
    @airconds = Aircond.all
    @aircond_groups = AircondGroup.filter_group_view(params[:group_id])
    redirect_to aircond_groups_path
  end

  def show
    @aircond_group = AircondGroup.find(params[:id])
    render json: @aircond_group
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
