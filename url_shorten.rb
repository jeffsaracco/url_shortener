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
  new_url = 6.times.map { ('A'..'Z').to_a.sample }.join
  db.execute "insert into urls values ( ?, ?, 0, ? )", params["url"], new_url, Time.now.to_i
  redirect to('/')
end

get '/clear' do
  db.execute "delete from urls;"
  redirect to('/')
end

# TODO
# - when generating url, check if it exists, if so regenerate until it doesnt exist
# - path to accept url
# - 404 path
# - if found, increase count and redirect
# - if not found, redirect to 404
