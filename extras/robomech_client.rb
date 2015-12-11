class RobomechClient
  def self.send_sms_to_phones(text, type='visitors')
    #competitions, visitors, exhibitions, excursion
    phones = []
    if type != 'all'
      phones = JSON.parse HttpClient.get_request('http://robomech.ru/get-phones', {type: type})
    elsif type == 'all'
      %w(competitions visitors exhibitions excursion).each do |group|
        phones += JSON.parse(HttpClient.get_request('http://robomech.ru/get-phones', {type: group}))
      end
      phones = phones.uniq
    end
    phones.push('79141779406')

    Rails.logger.debug '[COUNT]SMS to ' + phones.count.to_s + ' phones'

    #post_to_sms_many_numbers(text, phones)

    phones.each do |phone|
      MtsClient.one_number_message(phone, text)
    end
  end
end