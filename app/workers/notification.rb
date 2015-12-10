class Notification
  include Sidekiq::Worker
  def perform
    #post_to_sms_many_numbers('Сервис рассылки СМС "Робомех 2015" работает отлично!',
    #                        %w(79141779406 79147756745 79098535667 79242039725 79244080473 79622281551 79990852644))

    # On fire uncomment lines below
    # %w(79141779406 79141591070 79147710401 79145480304 79242039725).each do |phone|
    #   post_to_sms_one_number('Тестовое сообщение для группы. Рандомное число: ' + Random.rand(999).to_s, phone)
    # end

    #check_events_and_send_noty 1
    send_to_telegram('Проверка телеграмма. Рандомное число: ' + Random.rand(999).to_s)
  end

  private

  def push_all_request(title, text='')
    response = post_request('https://pushall.ru/api.php', {
        type: 'broadcast',
        id: '845',
        key: 'be1acda5e707166d57930063e647cc7a',
        title: title,
        text: text})
    error = JSON.parse(response.body)[:error]
    if error == 'not so fast'
      Timeout::timeout(10.seconds) { push_all_request(title, text) }
    end
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

  def post_to_sms_one_number(text, phone)
    require 'digest/md5'

    xml = Builder::XmlMarkup.new
    xml.instruct! :xml, :version=>'1.0', :encoding=>'UTF-8'

    xml.soap :Envelope, 'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
                        'xmlns:xsd' => 'http://www.w3.org/2001/XMLSchema',
                        'xmlns:soap' => 'http://schemas.xmlsoap.org/soap/envelope/' do
      xml.soap :Body do
        xml.SendMessage 'xmlns' => 'http://mcommunicator.ru/M2M' do |message|
          message.msid(phone)
          message.message(text)
          #message.naming('Робомех 2015')
          message.login('79141591070')
          message.password(Digest::MD5.hexdigest('123456'))
        end
      end
    end

    post_xml_to_mts('/m2m/m2m_api.asmx', xml)
  end

  def post_to_sms_many_numbers(text, phones)
    require 'digest/md5'

    xml = Builder::XmlMarkup.new
    xml.instruct! :xml, :version=>'1.0', :encoding=>'UTF-8'

    xml.soap :Envelope, 'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
             'xmlns:xsd' => 'http://www.w3.org/2001/XMLSchema',
             'xmlns:soap' => 'http://schemas.xmlsoap.org/soap/envelope/' do
      xml.soap :Body do
        xml.SendMessages 'xmlns' => 'http://mcommunicator.ru/M2M' do |message|
          xml.msids do |msid|
            phones.each do |phone|
              msid.string phone
            end
          end
          message.message(text)
          #message.naming('Робомех 2015')
          message.login('79141591070')
          message.password(Digest::MD5.hexdigest('123456'))
        end
      end
    end

    post_xml_to_mts('/m2m/m2m_api.asmx', xml)
  end

  def post_xml_to_mts(uri_str, xml)
    uri = URI('http://mcommunicator.ru')

    Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      xml_target = xml.target!
      response = http.post(uri_str, xml_target.encode('utf-8'), initheader = {'Content-Type' =>'text/xml;charset=utf-8'})

      Rails.logger.debug 'Send sms: '
      Rails.logger.debug xml_target
      Rails.logger.debug response.body
      Rails.logger.debug '========================='
    end
  end

  def send_to_telegram(text)
    post_request('https://api.telegram.org/bot158767104:AAGP2dDFWEB6dnIlAuFRJJhIvSaQEsBnTsw/sendMessage',
                 {chat_id:'138160592', text: text})
  end

  def send_sms_to_robomech_phones(text, type='visitors')
    phones = JSON.parse get_request('http://robomech.ru/get-phones', {type: type})
    phones.push('79141779406')

    post_to_sms_many_numbers(text, phones)

    # phones.each do |phone|
    #   post_to_sms_one_number(text, phone)
    # end
  end
  def check_events_and_send_noty(forum_id=1)
    forum = Forum.find forum_id
    forum.events.each do |event|

      if event.time_to_begin > 0 && event.time_to_begin > 6.minute && event.time_to_begin < 16.minute
        Rails.logger.debug '[ОПОВЕЩЕНИЕ] О событии ' + event.name + ', до него осталось ' + (event.time_to_begin/60).to_s + ' минут'
        text = 'Время начала: ' + event.local_time('begin') + ' Время окончания: ' + event.local_time('end') + ' Площадка: ' + event.room.full_name
        push_all_request(event.name + ' скоро начнется!', text)
        post_to_sms_one_number(event.name + ' скоро начнется! ' + text, '79141779406')
      elsif event.time_to_begin > 0
        Rails.logger.debug '[ОЖИДАНИЕ] До события ' + event.name + ' еще ' + (event.time_to_begin/60).to_s + ' минут'
      else
        Rails.logger.debug '[ПРОШЛО] Событие ' + event.name + ' ' + (event.time_to_begin/60).to_s + ' минут назад'
      end
    end
  end
end
