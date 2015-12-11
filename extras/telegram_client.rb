class TelegramClient
  def self.send_message(chat_id, text)
    send_request('sendMessage', {chat_id: chat_id, text: text})
  end
  def self.send_request(command, data)
    token = '158767104:AAGP2dDFWEB6dnIlAuFRJJhIvSaQEsBnTsw'
    post_request('https://api.telegram.org/bot' + token + '/' + command, data)
  end

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
end