require 'rails_helper'

describe Note, type: :model do
  let(:note) { FactoryBot.create(:note) }
  let(:tag) { FactoryBot.create(:tag) }

  context 'Tagged to note' do
    it 'Tagging' do
      note.add_tags(tag.name.split(','))
      expect(tag.notes.include?(note)).to be true
      expect(note.tags.include?(tag)).to be true
    end

    it 'Removing' do
      tag = FactoryBot.create(:tag)
      note.add_tags(tag.name.split(','))
      note.remove_tags(tag.name.split(','))
      expect(tag.notes.include?(note)).to be false
      expect(note.tags.include?(tag)).to be false
    end
  end
end