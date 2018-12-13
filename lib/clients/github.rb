require 'octokit'

class Github
  class << self
    attr_accessor :api_client
    def api_token=(token)
      @api_client = Octokit::Client.new(access_token: token)
    end
  end

  def initialize(github_url)
    short_handle = github_url.sub(/https?:\/\/github.com\//, '')
    @result = self.class.api_client.repository(short_handle)
  end

  def star_count
    @result[:stargazers_count]
  end

  def last_commit_dt
    @result[:updated_at]
  end

  def license
    @result[:license][:name] rescue nil
  end

  def watcher_count
    @result[:watchers_count]
  end

  def code_size
    @result[:size]
  end

end