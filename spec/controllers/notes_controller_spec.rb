require 'spec_helper'

describe NotesController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  before :each do
    request.env["HTTP_ACCEPT"] = 'application/json'
    sign_in user
  end

  context 'GET index' do
    it 'should list all the notes' do
      get :index
      expect(JSON(response.body).keys).to eq ["notes", "shared_notes"]
    end
  end

  context 'GET show' do
    it 'Should return the object' do
      note = FactoryBot.create(:note)
      user.add_role(:owner, note)
      get :show, id: note.id
      expect(JSON(response.body).keys).to eq ["note", "users"]
    end
  end

  context 'POST create' do
    it 'should create note with correct params and tags' do
      post :create, note: { title: 'new note', content: 'new note content' }, tags: ['new','note']
      note = JSON(response.body).with_indifferent_access
      expect(note[:title]).to eq 'new note'
      expect(note[:content]).to eq 'new note content'
      note = Note.find note[:id]
      expect(user.has_role?(:owner, note)).to be true
      expect(note.tags.pluck(:name)).to eq ['new','note']
    end
  end

  context 'PUT update' do
    it 'should update the note - add tags' do
      note = FactoryBot.create(:note)
      note.user = user
      user.add_role(:owner, note)
      note.save
      put :update, id: note.id, note: { title: 'new title', content: 'new note content' }, tags: ['new','note']
      expect(note.reload.content).to eq 'new note content'
      expect(note.reload.title).to eq 'new title'
      expect(note.tags.pluck(:name)).to eq ['new','note']
    end

    it 'should update the note - remove tags' do
      note = FactoryBot.create(:note)
      note.user = user
      user.add_role(:owner, note)
      note.save
      put :update, id: note.id, note: { title: 'new title', content: 'new note content' }, tags: ['new','note']
      expect(note.reload.content).to eq 'new note content'
      expect(note.reload.title).to eq 'new title'
      expect(note.tags.pluck(:name)).to eq ['new','note']

      put :update, id: note.id, note: { title: 'new title', content: 'new note content' }, tags: ['note'], remove_tags: ['new']
      expect(note.tags.pluck(:name)).to eq ['note']
    end
  end

  context 'DELETE destroy' do
    it 'should delete the object' do
      note = FactoryBot.create(:note)
      note.user = user
      user.add_role(:owner, note)
      note.save

      expect { delete :destroy, id: note.id }.to change(Note, :count).by(-1)
      expect(response).to be_successful
    end
  end

  context 'POST Share or Reovoke access for the note' do
    it 'should share the note as reader' do
      user2 = FactoryBot.create(:user)
      note = FactoryBot.create(:note)
      note.user = user
      user.add_role(:owner, note)
      note.save

      post :share, id: note.id, user: user2.id, reader: true, commit: 'Share'
      expect(user2.has_role?(:reader, note)).to be true
    end

    it 'should share the note as collaborator' do
      user2 = FactoryBot.create(:user)
      note = FactoryBot.create(:note)
      note.user = user
      user.add_role(:owner, note)
      note.save

      post :share, id: note.id, user: user2.id, collaborator: true, commit: 'Share'
      expect(user2.has_role?(:collaborator, note)).to be true
    end

    it 'should revoke the reader access of the note' do
      user2 = FactoryBot.create(:user)
      note = FactoryBot.create(:note)
      note.user = user
      user.add_role(:owner, note)
      note.save

      post :share, id: note.id, user: user2.id, reader: true, commit: 'Share'
      expect(user2.has_role?(:reader, note)).to be true
      user2.reload
      note.reload
      post :share, id: note.id, user: user2.id, commit: 'Revoke'
      expect(user2.has_role?(:reader, note)).to be false
    end

    it 'should revoke the collaborator access of the note' do
      user2 = FactoryBot.create(:user)
      note = FactoryBot.create(:note)
      note.user = user
      user.add_role(:owner, note)
      note.save

      post :share, id: note.id, user: user2.id, collaborator: true, commit: 'Share'
      expect(user2.has_role?(:collaborator, note)).to be true
      user2.reload
      note.reload
      post :share, id: note.id, user: user2.id, commit: 'Revoke'
      expect(user2.has_role?(:collaborator, note)).to be false
    end
  end

end