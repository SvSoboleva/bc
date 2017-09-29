FactoryGirl.define do
  factory :book do
    title { "Name_#{rand(100)}" }
    author { "Author_#{rand(100)}" }
    description { "Descr_#{rand(100)}" }
    association :user
    association :section
  end
end