#job = Sidekiq::Cron::Job.create(name: 'Notifications about Events', cron: '*/10 * * * *', class: 'Notification')

class AuthConstraint
  def self.admin?(request)
    cookie = request.cookie_jar
    cookie[:user_id] && User.find(cookie[:user_id]).is_admin?
  end
end