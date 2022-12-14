require 'net/http'
require 'haversine'

class SpacexDataManagerService
  BASE_URL = 'https://api.spacexdata.com/v4'

  # TODO: Test class initialization verifying if the options have the expected value and structure
  def initialize
    @query_options = {
      :query => {
        :latitude => { :$ne => nil },
        :longitude => { :$ne => nil }
      },
      :options => { :limit => 0 }
    }
  end

  # TODO: Test method will return a number mocking the HTTP request and verify the parameters
  def get_starlinks_that_have_location_counter
    uri = URI "#{BASE_URL}/starlink/query"

    response = Net::HTTP.post uri, @query_options.to_json, { 'content-type' => 'application/json' }
    response = JSON.parse response.body
    response['totalDocs']
  end

  # TODO: Test if the method will send the expected params to the HTTP request mocking the HTTP object
  def get_starlinks_data
    starlinks_with_location_counter = self.get_starlinks_that_have_location_counter
    @query_options[:options][:limit] = starlinks_with_location_counter
    @query_options[:options][:select] = ["latitude", "longitude", "id"]

    uri = URI "#{BASE_URL}/starlink/query"
    response = Net::HTTP.post uri, @query_options.to_json, { 'content-type' => 'application/json' }
    response = JSON.parse response.body
  end

  # TODO: Test if the methof will return a list with satellites data ordered by the closest from the location given
  def order_by_closest_satellites(latitude, longitude)
    user_location = [latitude, longitude]
    starlinks = self.get_starlinks_data['docs']

    starlinks.sort do |first_satellite, second_satellite|
      first_satellite_location = [first_satellite['latitude'], first_satellite['longitude']]
      second_satellite_location = [second_satellite['latitude'], second_satellite['longitude']]

      distance_from_first_satellite = Haversine.distance(user_location, first_satellite_location).to_miles
      distance_from_second_satellite = Haversine.distance(user_location, second_satellite_location).to_miles

      distance_from_first_satellite <=> distance_from_second_satellite
    end
  end

  # TODO: Test if the method will split the array returned from order_by_closest_satellites
  # using the received satellites amount
  def get_closest_satellites(latitude, longitude, satellites_amount)
    ordered_closest_sattelites = self.order_by_closest_satellites(latitude, longitude)
    ordered_closest_sattelites.first satellites_amount
  end
end