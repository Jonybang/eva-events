class Notification
  include Sidekiq::Worker
  def perform
    #response = push_all_request({title: 'Робомех рулит!', text: 'Робомех действительно рулит. Рандомное число: ' + Random.rand(999).to_s})
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
    http.use_ssl = true

    #POST
    response = Net::HTTP.post_form(uri, data)

    #GET
    #uri.query = URI.encode_www_form(data)
    #request = Net::HTTP.get_response(uri)

    Rails.logger.debug 'Send notification: '
    Rails.logger.debug data
    Rails.logger.debug response.body
    Rails.logger.debug '========================='
  end
end
