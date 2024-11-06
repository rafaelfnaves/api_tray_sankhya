module TrayServices
  class Auth
    def call
      response = fetch_access_token
      hash = JSON.parse(response.body)
      hash['access_token']
    end

    private

    def url
      "#{ENV['API_ADDRESS']}/auth"
    end

    def fetch_access_token
      RestClient.post url_auth, {
        consumer_key: ENV['CONSUMER_KEY'], consumer_secret: ENV['CONSUMER_SECRET'], code: ENV['CODE']
      }
    end
  end
end
