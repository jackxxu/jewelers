require 'sinatra/base'
require 'sinatra/namespace'

class App < Sinatra::Base
  set :public_folder, 'public'
  register Sinatra::Namespace

  namespace '/api/v1' do
    before do
      content_type 'application/json'
    end

    get '/repos' do
      [
        {
          name: 'repo1',
          url: 'https://www.google.com'
        },
        {
          name: 'repo2',
          url: 'https://www.yahoo.com'
        }
      ].to_json
    end
  end

  get "/" do
    redirect '/index.html'
  end
end

