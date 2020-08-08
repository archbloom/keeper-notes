#
# Cotroller to perform CRUD operation Note
#
class NotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_note, only: %i[show edit update destroy share check_access]
  before_action :tags, only: %i[new edit show]
  before_action :check_access, only: %i[edit update show]
  respond_to :html, :json

  require 'json'

  #
  # GET index
  #   params: id: note_id
  # @return [Hash] { notes: {}, shared_notes: {} }
  #
  def index
    @notes = current_user.notes
    @shared_notes = Note.with_roles(%i[collaborator reader], current_user).distinct
    respond_with(notes: @notes, shared_notes: @shared_notes)
  end

  #
  # GET show
  #   params: { id: note_id }
  # @return [Hash] { notes: {}, shared_notes: {} }
  #
  def show
    @users = User.all
    @note_tags = @note.tags.pluck(:name)
    respond_with(note: @note, users: @users)
  end

  #
  # POST create
  #   params: { note: { title: 'new note', content: 'new note content' }, tags: ['new','note'] }
  # @return [Hash] Note object
  #
  def create
    @note = Note.new(note_params)
    @note.user = current_user
    @note.add_tags(params[:tags])
    if @note.save
      current_user.add_role :owner, @note
      flash[:notice] = 'Note created successfully.'
    else
      flash[:alert] = @note.errors
    end
    respond_with @note
  end

  def new
    @note = Note.new
  end

  def edit
    @note_tags = @note.tags.pluck(:name)
  end

  #
  # When Sharing the object with access
  #   To share with reader access
  #     params: { id: note_id, user: user_id, reader: true, commit: 'Share' }
  #   To share with collaborator access
  #     params: { id: note_id, user: user_id, collaborator: true, commit: 'Share' }
  # When Revoking the object access
  #   To revoke reader access
  #     params: { id: note_id, user: user_id, commit: 'Revoke' }
  #   To revoke collaborator access
  #     params: { id: note_id, user: user_id, collaborator: true, commit: 'Revoke' }
  # @return [Hash] Note object
  #
  def share
    user = User.where(id: params[:user]).first
    respond_with @note, alert: 'User not found' unless user
    respond_with @note, alert: 'You can not share or revoke the access' unless current_user.has_role?(:owner, @note)
    if params[:commit] == 'Share'
      user.add_role :reader, @note if params[:reader]
      user.add_role :collaborator, @note if params[:collaborator]
      respond_with @note, notice: "Note shared with User #{user.name}"
    elsif params[:commit] == 'Revoke'
      user.remove_role :reader, @note if params[:reader].nil?
      user.remove_role :collaborator, @note if params[:collaborator].nil?
      respond_with @note, notice: 'Sharing revoked'
    end
  end

  #
  # POST create
  #   params: { note: { title: 'new note', content: 'new note content' }, tags: ['new','note'], remove_tags: ['old'] }
  # @return [Hash] Note object
  #
  def update
    @note.add_tags(params[:tags]) if params[:tags].present?
    @note.remove_tags(params[:remove_tags]) if params[:remove_tags].present?
    if @note.update(note_params)
      flash[:notice] = 'Note updated successfully.'
    else
      flash[:alert] = @note.errors
    end
    respond_with @note
  end

  #
  # DELECT destroy
  #   params: { id: note_id }
  #
  # @return [204] No content
  #
  def destroy
    if current_user.has_role?(:owner, @note)
      @note.destroy
      flash[:notice] = 'Note deleted successfully.'
    else
      flash[:alert] = 'You can not delete the note.'
    end
    respond_with @note
  end

  private

  def note_params
    params.require(:note).permit(:title, :content, :user_id)
  end

  def set_note
    @note = Note.where(id: params[:id]).first
    redirect_to home_index_path, alert: 'Note does not exists.' unless @note
  end

  def tags
    @tags = Tag.all
    @note_tags = []
  end

  def check_access
    unless current_user.has_role?(:reader, @note) || current_user.has_role?(:owner, @note) || current_user.has_role?(:collaborator, @note)
      redirect_to home_index_path, alert: 'You have no access for the Note.'
    end
  end
end
