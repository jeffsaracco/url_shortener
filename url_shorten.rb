require 'sinatra'
require 'haml'
set :haml, :format => :html5

get '/' do
  haml :index
end

post '/new' do
  new_url = []
  6.times do 
    new_url << ('A'..'Z').to_a.sample
  end
  "Your new URL is #{new_url.join} which redirects to #{params["url"]}"
end
