require 'sinatra'
require 'postmark'
require 'httparty'

class OpenHAB
  include HTTParty

  base_uri 'https://my.openhab.org'

  def self.update!(new_status)
    self.new(ENV['HAB_EMAIL'], ENV['HAB_PASS']).update_status new_status
  end

  def initialize(user, pass)
    @auth = {username: user, password: pass}
  end

  def get_status
    self.class.get "/rest/items/itm_garage_door/state", basic_auth: @auth
  end

  def update_status(new_status)
    self.class.get "/CMD?itm_garage_door_notifier=#{new_status}", basic_auth: @auth
  end
end

post "/#{ENV['POST_URL']}" do
  request.body.rewind
  postmark_hash = Postmark::Json.decode(request.body.read)
  ruby_hash     = Postmark::Inbound.to_ruby_hash(postmark_hash)

  if ruby_hash[:subject] =~ /closed/
    puts "Door closed! Telling OpenHAB"
    OpenHAB.update! 'OFF'
  elsif ruby_hash[:subject] =~ /opened/
    puts "Door opend! Telling OpenHAB"
    OpenHAB.update! 'ON'
  else
    puts "Error! What happened?"
    puts ruby_hash.inspect
  end
end
