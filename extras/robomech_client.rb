class RobomechClient
  def self.send_sms_to_phones(text, type='visitors')
    #competitions, visitors, exhibitions, excursion
    phones = JSON.parse HttpClient.get_request('http://robomech.ru/get-phones', {type: type})
    phones.push('79141779406')

    #post_to_sms_many_numbers(text, phones)

    phones.each do |phone|
      MtsClient.one_number_message(phone, text)
    end
  end
end