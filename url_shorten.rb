require 'sinatra'
require 'haml'
require 'sqlite3'
require 'pry'

db = SQLite3::Database.new "urls.db"
rows = db.execute <<-SQL
  create table if not exists urls (
    href varchar(200),
    shortened varchar(200),
    clicks int,
    created_at int
  );
SQL



set :haml, :format => :html5

get '/' do
  @urls = db.execute( "select * from urls" )
  haml :index
end

post '/new' do
  new_url = generate_url

  while(db.execute( "select * from urls where shortened = ?", new_url ).count > 0) do
    new_url = generate_url
  end

  db.execute "insert into urls values ( ?, ?, 0, ? )", params["url"], new_url, Time.now.to_i

  redirect to('/')
end

get '/clear' do
  db.execute "delete from urls;"
  redirect to('/')
end

get '/:shortened' do
  url = db.execute( "select * from urls where shortened = ?", params[:shortened] )
  if(url.count > 0)
    db.execute("update urls set clicks = ? where shortened = ?", url.first[2] + 1, params[:shortened])
    redirect to(url.first[0])
  else
    raise Sinatra::NotFound
  end
end

not_found do
  haml :not_found
end

def generate_url
  6.times.map { ('A'..'Z').to_a.sample }.join
end
