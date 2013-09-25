FactoryGirl.define do
  factory :user do
    email { random_email }
  end
end
