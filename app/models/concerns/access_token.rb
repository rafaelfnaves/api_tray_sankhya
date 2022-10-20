module AccessToken
  extend ActiveSupport::Concern

  def access_token
    url_auth = "#{ENV['API_ADDRESS']}/auth"
    response = RestClient.post url_auth, {consumer_key: ENV['CONSUMER_KEY'], consumer_secret: ENV['CONSUMER_SECRET'], code: ENV['CODE']}
    hash = JSON.parse(response.body)
    hash["access_token"]
  end
  
end