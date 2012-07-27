require 'sinatra'

get '/new' do
  "<html>
    <body>
      <form action='/new' method='POST'>
        <input type='url' name='url' placeholder='Enter URL here'>
        <input type='submit' value='GO'>
      </form>
    </body>
  </html>"
end

post '/new' do
  new_url = []
  6.times do 
    new_url << ('A'..'Z').to_a.sample
  end
  "Your new URL is #{new_url.join} which redirects to #{params["url"]}"
end
