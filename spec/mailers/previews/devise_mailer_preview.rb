module Devise
  class MailerPreview < ActionMailer::Preview
    def reset_password_instructions
      DeviseCustomMailer.reset_password_instructions(User.first, 'faketoken')
    end
  end
end
