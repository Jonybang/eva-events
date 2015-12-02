class Notification
  include Sidekiq::Worker
  def perform(name)
    response = push_all_request({title: 'Заголовок', text: 'Тестовое сообщение'})
  end

  private

  def push_all_request(data)
    post_request('https://pushall.ru/api.php', {
        type: 'self',
        id: '10507',
        key: '0c1c4e330c1a464b3562a68715ffdfee',
        title: data[:title],
        text: data[:text]})
  end
  def post_request(url, data)
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    #http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path, {:Content-Type =>'application/json'})
    request.body = data.to_json

    http.request(request)
  end
end