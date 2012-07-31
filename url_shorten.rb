require 'sinatra'
require 'sqlite3'

class ShortenedURL
  def initialize(destination_url)
    @destination_url = destination_url
    @shortened_url = generate_url
    @db = SQLite3::Database.new('url.db')
  end

  def save
    @db.execute("insert into urls values (?, ?)", @destination_url, @shortened_url)
  end

  def shortened
    @shortened_url
  end

  def destination
    @destination_url
  end
  #list of urls generated so far
  #find by shortened url

  def self.find_by_shortened_url(short_url)
    #fill me in
    #and what the hell is self
    #I should return an instance of ShortenedURL
  end

  private

  def generate_url
    new_url = []
    6.times do
      new_url << ('A'..'Z').to_a.sample
    end
    new_url.join
  end
end

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
  new_url = ShortenedURL.new(params[:url])
  new_url.save
  "Your new URL is #{new_url.shortened} which redirects to #{new_url.destination}"
end

get '/:short_url' do |url|
  redirect ShortenedURL.find_by_shortened_url(url).destination
end
