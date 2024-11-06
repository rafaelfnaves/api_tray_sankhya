module TrayServices
  class GetCustomer
    attr_reader :customer_id

    def initialize(customer_id)
      @customer_id = customer_id
    end

    def call
      fetch_customer
    end

    private

    def access_token
      TrayServices::Auth.call
    end

    def url
      "#{ENV['API_ADDRESS']}/customers/#{customer_id}?access_token=#{access_token}"
    end

    def fetch_customer
      response = RestClient.get url
      hash = JSON.parse(response.body)
      hash['Customer']
    end
  end
end
