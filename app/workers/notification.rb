class Notification
  include Sidekiq::Worker
  def perform
    #response = push_all_request({title: 'Робомех рулит!', text: 'Робомех действительно рулит. Рандомное число: ' + Random.rand(999).to_s})
    #post_to_sms_many_numbers('Тестовое сообщение. Рандомное число: ' + Random.rand(999).to_s,
    #                         %w(79141779406 79141591070 79147710401 79145480304 79242039725))
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
end
