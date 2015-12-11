class TelegramClient
  def self.send_message(chat_id, text)
    send_request('sendMessage', {chat_id: chat_id, text: text})
  end
  def self.send_request(command, data)
    token = '158767104:AAGP2dDFWEB6dnIlAuFRJJhIvSaQEsBnTsw'
    HttpClient.post_request('https://api.telegram.org/bot' + token + '/' + command, data)
  end
end