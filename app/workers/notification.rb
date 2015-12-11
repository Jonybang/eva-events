class Notification
  include Sidekiq::Worker
  def perform
    #post_to_sms_many_numbers('Сервис рассылки СМС "Робомех 2015" работает отлично!',
    #                        %w(79141779406 79147756745 79098535667 79242039725 79244080473 79622281551 79990852644))

    # On fire uncomment lines below
    # %w(79141779406 79141591070 79147710401 79145480304 79242039725).each do |phone|
    #   post_to_sms_one_number('Тестовое сообщение для группы. Рандомное число: ' + Random.rand(999).to_s, phone)
    # end

    # post_request('https://api.telegram.org/bot158767104:AAGP2dDFWEB6dnIlAuFRJJhIvSaQEsBnTsw/setWebhook',
    #              {url:'https://evaevents.ru/'})

    #check_events_and_send_noty 1
    #send_to_telegram('Проверка телеграмма. Рандомное число: ' + Random.rand(999).to_s)
    #send_sms_to_robomech_phones('Друзья, пройдя по ссылке https://evaevents.ru/robomech вы можете увидеть расписание мепроприятия и распланироаать свой день.', 'visitors')
    telegram_thread = Thread.new {
      #TelegramClient.send_message('138160592', 'Проверка телеграмма. Рандомное число: ' + Random.rand(999).to_s)
    }
    sms_thread = Thread.new {
      #MtsClient.one_number_message('79141779406', 'Проверка телеграмма. Рандомное число: ' + Random.rand(999).to_s)
    }
    telegram_thread.join
    sms_thread.join
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

  def get_request(url, data={})
    uri = URI(url)
    uri.query = URI.encode_www_form(data)
    Net::HTTP.get_response(uri).body
  end

  def send_sms_to_robomech_phones(text, type='visitors')
    phones = JSON.parse get_request('http://robomech.ru/get-phones', {type: type})
    phones.push('79141779406')

    #post_to_sms_many_numbers(text, phones)

    phones.each do |phone|
      MtsClient.one_number_message(phone, text)
    end
  end
  def check_events_and_send_noty(forum_id=1)
    forum = Forum.find forum_id
    forum.events.each do |event|

      if event.time_to_begin > 0 && event.time_to_begin > 6.minute && event.time_to_begin < 16.minute
        Rails.logger.debug '[ОПОВЕЩЕНИЕ] О событии ' + event.name + ', до него осталось ' + (event.time_to_begin/60).to_s + ' минут'
        text = 'Время начала: ' + event.local_time('begin') + ' Время окончания: ' + event.local_time('end') + ' Площадка: ' + event.room.full_name
        push_all_request(event.name + ' скоро начнется!', text)
        MtsClient.one_number_message('79141779406', event.name + ' скоро начнется! ' + text)
      elsif event.time_to_begin > 0
        Rails.logger.debug '[ОЖИДАНИЕ] До события ' + event.name + ' еще ' + (event.time_to_begin/60).to_s + ' минут'
      else
        Rails.logger.debug '[ПРОШЛО] Событие ' + event.name + ' ' + (event.time_to_begin/60).to_s + ' минут назад'
      end
    end
  end
end
