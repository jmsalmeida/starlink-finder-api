require 'net/http'

class SpacexDataManagerService
  BASE_URL = 'https://api.spacexdata.com/v4'

  def initialize
    @query_options = {
      :query => {
        :latitude => { :$ne => nil },
        :longitude => { :$ne => nil }
      },
      :options => { :limit => 0 }
    }
  end

  def get_starlinks_that_have_location_counter
    uri = URI "#{BASE_URL}/starlink/query"

    response = Net::HTTP.post uri, @query_options.to_json, { 'content-type' => 'application/json' }
    response = JSON.parse response.body
    response['totalDocs']
  end

  def get_starlinks_data
    starlinks_with_location_counter = self.get_starlinks_that_have_location_counter
    @query_options[:options][:limit] = starlinks_with_location_counter
    @query_options[:options][:select] = ["latitude", "longitude", "id"]

    uri = URI "#{BASE_URL}/starlink/query"
    response = Net::HTTP.post uri, @query_options.to_json, { 'content-type' => 'application/json' }
    response = JSON.parse response.body
  end
end