class PushAllClient
  def self.send_message(title, text='')
    response = HttpClient.post_request('https://pushall.ru/api.php', {
        type: 'broadcast',
        id: '845',
        key: 'be1acda5e707166d57930063e647cc7a',
        title: title,
        text: text})
    error = JSON.parse(response.body)[:error]
    if error == 'not so fast'
      Timeout::timeout(10.seconds) { self.send_message(title, text) }
    end
  end

end