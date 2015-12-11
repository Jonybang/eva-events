class TelegramClient
  def self.send_message(chat_id, text)
    Rails.logger.debug 'Send telegram message to ' + chat_id
    send_request('sendMessage', {chat_id: chat_id, text: text})
  end
  def self.send_request(command, data)
    token = '158767104:AAGP2dDFWEB6dnIlAuFRJJhIvSaQEsBnTsw'
    data[:parse_mode] = 'Markdown'
    HttpClient.post_request('https://api.telegram.org/bot' + token + '/' + command, data)
  end
  def self.send_message_to_me(text)
    %w(138160592 80123933).each do |phone|
      send_message(phone, text)
    end
  end
end