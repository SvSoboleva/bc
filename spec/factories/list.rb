FactoryGirl.define do
  factory :list do
    name { "List_#{rand(100)}" }
    association :user
 end
end