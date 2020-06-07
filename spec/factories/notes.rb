FactoryBot.define do
  factory :note, class: Note do
    title { 'title one' }
    content { 'content one' }

    association :user, factory: :user
    before :create do |note|
      user = note.user
      user.add_role(:owner, note)
    end
  end
end
