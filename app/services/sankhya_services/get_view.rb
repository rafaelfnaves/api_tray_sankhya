module SankhyaServices
  class GetView
    attr_reader :view_name

    def initialize(view_name)
      @view_name = view_name
    end

    def call
      response = fetch_view
      hash = Hash.from_xml(response.body)
      hash.dig('serviceResponse', 'responseBody', 'records', 'record')
    rescue StandardError => e
      puts "[ERROR] view_snk. Error message: #{e.message}"
    end

    private

    def url
      ENV['VIEW_URL_SNK']
    end

    def body
      "
        <serviceRequest serviceName='CRUDServiceProvider.loadView'> <requestBody>
        <query viewName= '#{view_name}'>
        </query>
        </requestBody> </serviceRequest>
      "
    end

    def session_id
      Auth.jsessionid!()
    end

    def fetch_view
      RestClient::Request.execute(
        method: :post,
        url:,
        payload: body,
        headers: { content_type: 'text/xml;charset=ISO-8859-1', cookie: "JSESSIONID=#{session_id}" }
      )
    end
  end
end
