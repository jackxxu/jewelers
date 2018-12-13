require 'rest-client'
require 'gemnasium/parser'
require 'yaml'

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

  def has_gemfilelock?(repo_url)
    url = "#{repo_url}/raw/master/Gemfile.lock"
    file_exists?(url)
  end

  def has_gemfile?(repo_url)
    url = "#{repo_url}/raw/master/Gemfile"
    file_exists?(url)
  end

  def sanctioned_gems(gems_yml_path)
    resp = RestClient.get "#{@url}/#{gems_yml_path}", 'PRIVATE-TOKEN' => @token
    YAML.load(resp.body).keys
  end

  private
    def file_exists?(url)
      RestClient.get url, 'PRIVATE-TOKEN' => @token
      true
    rescue RestClient::ExceptionWithResponse => err
      false
    end

end