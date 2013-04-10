namespace :twitter do
  desc "Retrieve recent tweets"
  task :retrieve => :environment do
    require 'net/https'

    nbr_tweets = 0
    nbr_saved_tweets = 0

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
      santiago: [-33.468108, -70.669556]
    }

    cities.each do |key, value|
      geocode = value[0].to_s + "," + value[1].to_s + ",30km"
      uri = URI("https://api.twitter.com/1.1/search/tweets.json")
      params = {"result_type" => "recent", "count" => "100" , "geocode" => geocode} 
      twitter_token = Rails.env.development? ? TWITTER_BEARER_TOKEN : ENV['TWITTER_BEARER_TOKEN']
      headers = {"Authorization" => "Bearer " + twitter_token}
      
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      req = Net::HTTP::Get.new(uri.path)
      req.set_form_data(params)
      req = Net::HTTP::Get.new( uri.path+ '?' + req.body , headers)
      res = http.request(req)

      JSON.parse(res.body)["statuses"].each do |tweet|
        nbr_tweets += 1
        shout = nil
        if tweet.has_key?("geo") && !tweet["geo"].nil? && tweet["geo"].has_key?("coordinates")
          shout = Shout.create(description: tweet["text"], lat: tweet["coordinates"]["coordinates"][0].to_f, lng: tweet["geo"]["coordinates"][1].to_f, display_name: tweet["user"]["name"], source: "twitter")  
          puts "Success: #{key}"
          nbr_saved_tweets += 1
        elsif tweet.has_key?("coordinates") && !tweet["coordinates"].nil? && tweet["geo"].has_key?("coordinates")
          shout = Shout.create(description: tweet["text"], lat: tweet["coordinates"]["coordinates"][1].to_f, lng: tweet["coordinates"]["coordinates"][0].to_f, display_name: tweet["user"]["name"], source: "twitter")  
          puts "Success: #{key}"
          nbr_saved_tweets += 1
        end
      end
    end

    puts "Nbr of tweets: #{nbr_tweets}"
    puts "Nbr of saved tweets: #{nbr_saved_tweets}"
  end
end