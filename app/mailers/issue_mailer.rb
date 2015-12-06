class IssueMailer < ApplicationMailer
  default from: 'jonybange@gmail.com'

  def support_email(issue)
    @issue = issue
    mail(to: 'jonybange@gmail.com', subject: '[EvaEvents] - Новое сообщение с формы на сайте', from: @issue.email)
  end
end
