get '/' do
  # Look in app/views/index.erb
  erb :index
end

post '/color' do
  #Create and return a JSON object with the random cell and color given below.
  cell= rand(1..9)
  color= "#" + "%06x" % (rand * 0xffffff)
  #The % method on String uses the string as a format specification for the argument. "%06x" means: format a number as hex, 6 characters (digits in this case) wide, 0 padded.
  content_type :json
  {cell: cell, color: color}.to_json
end