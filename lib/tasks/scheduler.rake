cities = {
      tokyo: [35.688533, 139.735107],
      newyork: [40.796138, -73.966827],
      saupaulo: [-23.556434, -46.649323],
      seoul: [37.570705, 126.970367],
      mexico: [19.429039, -99.136505],
      osaka: [34.694344, 135.501251],
      manila: [14.601193, 120.981445],
      mumbai: [19.077693, 72.876434],
      jakarta: [-6.206773, 106.840668],
      kolkata: [22.578510, 88.358917],
      delhi: [28.642389, 77.217407],
      cairo: [30.043538, 31.237907],
      losangeles: [34.052659, -118.243103],
      buenosaires: [-34.603259, -58.384094],
      riodejaneiro: [-22.897683, -43.211975],
      moscow: [55.756486, 37.644653],
      shanghai: [31.236289, 121.536255],
      karachi: [24.846877, 67.033768],
      paris: [48.861553, 2.346268],
      nagoya: [35.182788, 136.909904],
      istanbul: [41.008921, 28.968887],
      beijing: [39.905523, 116.405640],
      chicago: [41.878754, -87.635193],
      london: [51.513016, -0.122223],
      shenzhen: [22.543001, 114.066925],
      miami: [25.788763, -80.220108],
      sanfrancisco: [37.776142, -122.422028],
      seattle: [47.605237, -122.327957],
      roma: [41.891033, 12.477722],
      madrid: [40.421860, -3.710632],
      barcelona: [41.390204, 2.178040],
      berlin: [52.527919, 13.406067],
      montreal: [45.510197, -73.553467],
      santiago: [-33.468108, -70.669556],
      boston: [42.355452, -71.057358]
    }

def retrieve_tweets(city, lat, lng, hash_tag, count) 
  geocode = lat.to_s + "," + lng.to_s + ",400km"
  uri = URI("https://api.twitter.com/1.1/search/tweets.json")
  params = {"q" => hash_tag, "result_type" => "recent", "count" => count.to_s , "geocode" => geocode} 
  twitter_token = Rails.env.development? ? TWITTER_BEARER_TOKEN : ENV['TWITTER_BEARER_TOKEN']
  headers = {"Authorization" => "Bearer " + twitter_token}
  
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  req = Net::HTTP::Get.new(uri.path)
  req.set_form_data(params)
  puts "Request: #{uri.path+ '?' + req.body}"
  req = Net::HTTP::Get.new( uri.path+ '?' + req.body , headers)
  http.request(req)  
end

def parse_tweets(res, key)
  nbr_saved_tweets = 0
  JSON.parse(res.body)["statuses"].each do |tweet|
    shout = nil
    
    if tweet.has_key?("coordinates") && !tweet["coordinates"].nil? && tweet["geo"].has_key?("coordinates")
      shout = Shout.create(description: tweet["text"], lat: tweet["coordinates"]["coordinates"][1].to_f, lng: tweet["coordinates"]["coordinates"][0].to_f, display_name: tweet["user"]["name"], source: "twitter", created_at: Time.zone.parse(tweet["created_at"]))  
      puts "Success: #{key}: #{tweet["text"]}"
      nbr_saved_tweets += 1
    end
  end

  nbr_saved_tweets
end

namespace :twitter do
  #Example: rake twitter:retrieve_all_cities_with_nbr\[200\]
  desc "Retrieve specified number of recent tweets for each city"
  task :retrieve_all_cities_with_nbr, [:nbr] => :environment do |t,args|
    require 'net/https'

    nbr_saved_tweets = 0

    cities.each do |key, value|
      res = retrieve_tweets(key, value[0], value[1], "#local", args.nbr.to_i / 2)
      nbr_saved_tweets += parse_tweets(res, key)
      res = retrieve_tweets(key, value[0], value[1], "##{key}", args.nbr.to_i / 2)
      nbr_saved_tweets += parse_tweets(res, key)
    end

    puts "Nbr of saved tweets: #{nbr_saved_tweets}"  
  end

  #Example: rake twitter:display_with_city_and_nbr\['paris',1\]
  desc "Display specified number of tweets in the specified city"
  task :display_with_city_and_nbr, [:city, :nbr] =>:environment do |t,args|
    require 'net/https'

    res = retrieve_tweets(args.city.to_sym, cities[args.city.to_sym][0], cities[args.city.to_sym][1], "#bombing", args.nbr.to_i)
    puts "#{res.body}"
  end

  #Example: rake twitter:display_with_city_and_nbr\['paris', 'hashtag', 1\]
  desc "Display specified number of tweets in the specified city with specified hashtag"
  task :display_with_city_and_hashtag_and_nbr, [:city, :hashtag, :nbr] =>:environment do |t,args|
    require 'net/https'
    res = retrieve_tweets(args.city.to_sym, cities[args.city.to_sym][0], cities[args.city.to_sym][2], "#" + args.hashtag, args.nbr.to_i)
    puts "#{res.body}"
  end
end

namespace :awake do
  #Example: rake awake:keep_server_awake
  desc "Send request to the server to keep him awake"
  task :keep_server_awake => :environment do
    require 'net/http'

    uri = URI("http://street-shout.herokuapp.com/global_feed_shouts.json")
    params = {"page" => "1"} 
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Get.new(uri.path)
    req.set_form_data(params)
    req = Net::HTTP::Get.new( uri.path+ '?' + req.body , {})
    res = http.request(req)

    uri = URI("http://dev-street-shout.herokuapp.com/global_feed_shouts.json")
    params = {"page" => "1"} 
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Get.new(uri.path)
    req.set_form_data(params)
    req = Net::HTTP::Get.new( uri.path+ '?' + req.body , {})
    res = http.request(req)  
  end
end

namespace :scheduled_shouts do
  #Example: rake schedule_shouts:send_scheduled_shouts
  desc "Send shouts that have been scheduled in the last 10 minutes"
  task :send_scheduled_shouts => :environment do
    scheduledShouts = ScheduledShout.where("scheduled_time <= :now AND scheduled_time >= :four_hours_ago", {:now => Time.now, :four_hours_ago => Time.now - 4.hours})

    scheduledShouts.each do |scheduledShout|
      image_url = scheduledShout.avatar ? scheduledShout.avatar.url(:square) : nil;
      Shout.create(lat: scheduledShout.lat,
                    lng: scheduledShout.lng,
                    description: scheduledShout.description,
                    display_name: scheduledShout.display_name,
                    image: scheduledShout.avatar.url(:square),
                    source: "scheduled")

      scheduledShout.delete
    end  
  end
end