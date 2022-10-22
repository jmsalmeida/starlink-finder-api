class StarlinksController < ApplicationController
  before_action :set_spacex_data_manager_service

  def index
    @starlinks = @spacex_data_manager.get_starlinks_data
    render json: @starlinks, status: :ok
  end

  private

  def set_spacex_data_manager_service
    @spacex_data_manager = SpacexDataManagerService.new
  end
end
