class StarlinksController < ApplicationController
  before_action :set_spacex_data_manager_service

  def closest_satellites
    # TODO: Validate that the received value will be possible to parse into float values, if not returns an error
    latitude = starlinks_finder_params[:latitude].to_f
    longitude = starlinks_finder_params[:longitude].to_f
    satellites_amount = starlinks_finder_params[:satellites_amount].to_i

    closest_satellites = @spacex_data_manager.get_closest_satellites(latitude, longitude, satellites_amount)
    render json: closest_satellites, status: :ok
  end

  private

  def set_spacex_data_manager_service
    @spacex_data_manager = SpacexDataManagerService.new
  end

  def starlinks_finder_params
    params.permit(:latitude, :longitude, :satellites_amount)
  end
end
