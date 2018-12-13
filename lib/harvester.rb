require 'dotenv'
require 'active_record'
require 'pry'
require './lib/models/library'
require './lib/models/repo'
require './lib/models/use'
require './lib/models/internal_library'
require './lib/models/app'
require './lib/models/sanctioned_library'
require './lib/clients/gitlab'
require './lib/clients/github'
require './lib/clients/ruby_gems'

GITHUB_URL_REGEX = /https?:\/\/github.com\/[^\s\/]+\/[^\s\/]+$/
CUSTOM_URLS = {
  'pg' => 'https://github.com/ged/ruby-pg',
  'hflr' => 'https://github.com/mnpopcenter/hflr',
  'erubis' => 'https://github.com/kwatch/erubis',
  'rubocop' => 'https://github.com/rubocop-hq/rubocop',
  'sidekiq' => 'https://github.com/mperham/sidekiq',
  'fastercsv' => 'https://github.com/JEG2/faster_csv',
  'activesupport' => 'https://github.com/rails/rails',
  'activerecord' => 'https://github.com/rails/rails'
}

def github_url(rubygems_hash)
  rubygems_hash.find { |key, value|
    key.to_s.end_with?('_uri') &&
    value =~ GITHUB_URL_REGEX
  }&.fetch(1)
end

Dotenv.load('jewelers.env')

db_config       = YAML::load(File.open('config/database.yml'))
ActiveRecord::Base.establish_connection(db_config)

gitlab = Gitlab.new(ENV['gitlab_url'], ENV['gitlab_token'])
rubygems = RubyGems.new
Github.api_token = ENV['github_token']

gitlab_repos = gitlab.repos('realtime-pts')
repo_names = gitlab_repos.map { |x| x[:name] }

sanctioned_list = SanctionedLibrary.all.map(&:name)

gitlab_repos.each do |repo_hash|
  repo = Repo.
    find_or_initialize_by(gitlab_id: repo_hash[:id]) do |r|
      r.gitlab_url = repo_hash[:web_url]
      r.name = repo_hash[:name]
      r.type = repo_type(r)
  end

  repo.libraries = []

  gitlab.gems(repo.gitlab_url)
        .reject { |x| repo_names.include?(x) ||
                      repo_names.include?(x.gsub('-', '_')) ||
                      repo_names.include?(x.gsub('_', '-')) ||
                      x == 'hashtran' } # gems
        .each do |name|
          gem = Library.find_or_initialize_by(name: name) do |lib|
            rubygems_hash = rubygems.get(name)
            lib.github_url = github_url(rubygems_hash) || CUSTOM_URLS[name]
            lib.authors = rubygems_hash[:authors]
            lib.description = rubygems_hash[:info]
            lib.downloads = rubygems_hash[:downloads]

            if lib.github_url
              github_repo = Github.new(lib.github_url)
              lib.star_count = github_repo.star_count
              lib.last_commit_dt = github_repo.last_commit_dt
              lib.license = github_repo.license
              lib.watcher_count = github_repo.watcher_count
              lib.code_size = github_repo.code_size
            end
            lib.sanctioned = sanctioned_list.include?(lib.name)
          end

          repo.libraries << gem
        end
end
