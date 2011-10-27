class UserMailer < ActionMailer::Base
  default :from => "letheapp@gmail.com"
  def welcome_email(user)
    @user = user
    @url  = "http://lethe.heroku.com/"
    mail(:to => user.email, :subject => "Welcome to Lethe!")
  end
end
