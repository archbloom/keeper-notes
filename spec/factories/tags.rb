FactoryBot.define do
  factory :tag, class: Tag do
    name { "tag_#{rand(0..100)}" }
  end
end
