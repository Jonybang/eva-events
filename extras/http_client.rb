class HttpClient
  def self.post_request(url, data)
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    #POST
    response = Net::HTTP.post_form(uri, data)

    #GET
    #uri.query = URI.encode_www_form(data)
    #request = Net::HTTP.get_response(uri)

    #Rails.logger.debug 'Send notification: '
    #Rails.logger.debug data
    Rails.logger.debug response.body
    #Rails.logger.debug '========================='
    return response
  end
  def get_request(url, data={})
    uri = URI(url)
    uri.query = URI.encode_www_form(data)
    Net::HTTP.get_response(uri).body
  end
end