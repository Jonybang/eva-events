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
    #RobomechClient.send_sms_to_phones('Спасибо, что вы зарегистрировались на экскурсию, ждем вас завтра в назначенное время :)', 'excursion')
    check_events_and_send_noty 2
  end

  private
  def check_events_and_send_noty(forum_id=1)
    forum = Forum.find forum_id
    forum.events.each do |event|

      if event.time_to_begin > 0 && event.time_to_begin > 6.minute && event.time_to_begin < 16.minute
        Rails.logger.debug '[ОПОВЕЩЕНИЕ] О событии ' + event.name + ', до него осталось ' + (event.time_to_begin/60).to_s + ' минут'

        telegram_thread = Thread.new {
          TelegramUser.each do |user|
            TelegramClient.send_message(user.chat_id, event.get_ad('telegram'))
          end
        }
        sms_thread = Thread.new {
          RobomechClient.send_sms_to_phones(event.get_ad, 'all')
        }

        telegram_thread.join
        sms_thread.join
      elsif event.time_to_begin > 0
        Rails.logger.debug '[ОЖИДАНИЕ] До события ' + event.name + ' еще ' + (event.time_to_begin/60).to_s + ' минут'
      else
        Rails.logger.debug '[ПРОШЛО] Событие ' + event.name + ' ' + (event.time_to_begin/60).to_s + ' минут назад'
      end
    end
  end
end
