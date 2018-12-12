require 'sinatra/base'
require 'sinatra/namespace'
require 'active_record'
require 'pry'

db_config       = YAML::load(File.open('config/database.yml'))
ActiveRecord::Base.establish_connection(db_config)

require './lib/models/library'
require './lib/models/repo'
require './lib/models/app'
require './lib/models/internal_library'
require './lib/models/use'
require './lib/models/sanctioned_library'

class Jewelers < Sinatra::Base
  set :public_folder, 'public'
  register Sinatra::Namespace

  namespace '/api/v1' do
    before do
      content_type 'application/json'
    end

    get '/repos' do
      App.includes(:libraries).all.map { |app|
        {
          id: app.id,
          name: app.name,
          gitlab_url: app.gitlab_url,
          libraries: app.libraries,
          passed: app.libraries.all?(&:sanctioned)
        }
      }.to_json
    end
  end

  get "/" do
    redirect '/index.html'
  end
end

