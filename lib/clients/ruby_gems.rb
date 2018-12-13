require 'json'
require 'rest-client'

class RubyGems
  def get(name)
    url = "https://api.rubygems.org/api/v1/gems/#{name}.json"
    response = RestClient.get url
    JSON.parse(response.body, symbolize_names: true)
  end
end