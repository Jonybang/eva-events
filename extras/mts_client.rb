class MtsClient
  def self.one_number_message(phone, text)
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

    post_xml('/m2m/m2m_api.asmx', xml)
  end

  def self.many_numbers_message(phones, text)
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

    post_xml('/m2m/m2m_api.asmx', xml)
  end

  def self.post_xml(uri_str, xml)
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