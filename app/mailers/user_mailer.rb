class UserMailer < ApplicationMailer
  default from: 'postmaster@mg.mytgcloud.com'

  add_template_helper(EmailHelper)
 
  def welcome_email(user)
    @url  = 'https://myTGCloud.herokuapp.com'
    @url = $appurl
    @user = user
    mail(to: user.email, subject: (I18n.t :welcometo))
    #mail(to: "wurmhorst63@gmail.com", subject: 'Welcome to My Awesome Site')
  end
end
