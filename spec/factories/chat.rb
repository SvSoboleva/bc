FactoryGirl.define do
  factory :chat do
    name { "Chat_#{rand(100)}" }
  end
end