require 'rails_helper'

describe Note, type: :model do
  let(:note) { FactoryBot.create(:note) }
  let(:user) { FactoryBot.create(:user) }
  context 'Basic validations' do
    it 'should have title and content' do
      expect(note.title).not_to be_nil
      expect(note.content).not_to be_nil
    end

    it 'should have user and user should be owner' do
      expect(note.user).not_to be_nil
      expect(note.user.has_role?(:owner, note)).to be true
    end
  end

  context 'Sharing' do
    it 'Can be shared with others as Read only access' do
      user.add_role(:reader, note)
      expect(user.has_role?(:owner, note)).to be false
      expect(user.has_role?(:collaborator, note)).to be false
      expect(user.has_role?(:reader, note)).to be true
    end

    it 'Can be shared with others as Read and Update only access' do
      user.add_role(:collaborator, note)
      expect(user.has_role?(:owner, note)).to be false
      expect(user.has_role?(:reader, note)).to be false
      expect(user.has_role?(:collaborator, note)).to be true
    end
  end

  context 'Tagging' do
    it 'Can be tagged' do
      tag = FactoryBot.create(:tag)
      note.add_tags(tag.name.split(','))
      expect(tag.notes.include?(note)).to be true
      expect(note.tags.include?(tag)).to be true
    end

    it 'Tags can be removed' do
      tag = FactoryBot.create(:tag)
      note.add_tags(tag.name.split(','))
      note.remove_tags(tag.name.split(','))
      expect(tag.notes.include?(note)).to be false
      expect(note.tags.include?(tag)).to be false
    end
  end
end