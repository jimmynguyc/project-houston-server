class AircondGroupsController < ApplicationController
  def create
    ac_grp = AircondGroup.new(set_ac_grp_params)
    ac_grp.save
    @airconds = Aircond.all
    @current_time= Time.zone.now
    @aircond_groups = AircondGroup.all
    @column_grid_length =AircondGroup.column_grid_length
    render :dashboard
  end

  def update
    
  end

  def destroy
    ac_grp = AircondGroup.find(params[:id])
    if ac_grp.delete
      render json:{response:'Group deleted successfully.'}
    else
      render json:{response:'Group not deleted'}
    end
  end

  def ac_grp_dashboard
    @airconds = Aircond.all
    @current_time= Time.zone.now
    @aircond_groups = AircondGroup.all
    @column_grid_length =AircondGroup.column_grid_length
    render :dashboard
  end


  private

  def set_ac_grp_params
    params.require(:aircond_group).permit(:title)
  end
end
