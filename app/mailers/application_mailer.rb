# ApplicationMailer is the base mailer class for your Rails application.
# It provides common functionality and settings for all other mailers.
class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"
end
