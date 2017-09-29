FactoryGirl.define do
  factory :user do
    name { "Test_#{rand(100)}" }
    sequence(:email) { |n| "somebody_#{n}@ex.com" }
    is_admin false
    after(:build) { |u| u.password_confirmation = u.password = '123456' }
  end
end