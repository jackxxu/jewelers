require 'rest-client'
require 'gemnasium/parser'

class Gitlab
  def initialize(url, token)
    @url = url
    @token = token
  end

  def repos(search)
    [].tap do |result|
      1000.times do |i|
        url = "#{@url}/api/v3/projects?simple=yes&search=#{search}&page=#{i}&per_page=1000"
        response = RestClient.get url, 'PRIVATE-TOKEN' => @token
        response_hash = JSON.parse(response.body, symbolize_names: true)
        break if response_hash.empty?
        result << response_hash
      end
    end.flatten
  end

  def gems(repo_url)
    gemfile_url = "#{repo_url}/raw/master/Gemfile"
    resp = RestClient.get gemfile_url, 'PRIVATE-TOKEN' => @token
    parsed = Gemnasium::Parser::Gemfile.new(resp.body)
    parsed.dependencies
          .select { |x| x.groups.include?(:default) }
          .map(&:name)
  rescue RestClient::NotFound
    []
  end
end