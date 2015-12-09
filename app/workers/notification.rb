class Notification
  include Sidekiq::Worker
  def perform
    response = push_all_request({title: 'Заголовок', text: 'Тестовое сообщение'})
  end

  private

  def push_all_request(data)
    post_request('https://pushall.ru/api.php', {
        type: 'broadcast',
        id: '845',
        key: 'be1acda5e707166d57930063e647cc7a',
        title: data[:title],
        text: data[:text]})
  end
  def post_request(url, data)
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    #http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'application/json'})
    request.body = data.to_json

    Rails.logger.debug 'Send notification: '
    Rails.logger.debug data
    Rails.logger.debug http.request(request)
  end
end
