FactoryBot.define do
  factory :user, class: User do
    name { 'user one' }
    email { "userone#{rand(0..100)}@example.com" }
    password { 'test@123' }
  end
end
