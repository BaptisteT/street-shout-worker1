namespace :twitter do
  desc "Retrieve recent tweets"
  task :retrieve => :environment do
    require 'net/https'
    uri = URI('https://api.twitter.com/1.1/search/tweets.json')
    params = {"result_type" => "recent", "count" => "10" , "geocode" => "37.753683,-122.418079,3mi"} 
    headers = {"Authorization" => "Bearer " + TWITTER_BEARER_TOKEN}
    
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    req = Net::HTTP::Get.new(uri.path)
    req.set_form_data(params)
    req = Net::HTTP::Get.new( uri.path+ '?' + req.body , headers)
    res = http.request(req)

    puts res.body
  end
end