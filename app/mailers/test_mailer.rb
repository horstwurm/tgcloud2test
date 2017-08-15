class TestMailer < ApplicationMailer
  default from: 'postmaster@mg.mytgcloud.com'
 
  def test_email(user)
    @url  = 'http://example.com/login'
    @user = user
    mail(to: user.email, subject: 'Welcome to My Awesome Site')
  end
end
