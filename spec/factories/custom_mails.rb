FactoryBot.define do
  factory :custom_mail do
    body { "MyText" }
    mailable { nil }
  end
end
