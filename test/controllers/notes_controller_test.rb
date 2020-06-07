require 'test_helper'

class NotesControllerTest < ActionDispatch::IntegrationTest
  include SignInHelper
  include Devise::Test::IntegrationHelpers
  setup do
    @note = notes(:one)
    @user = @note.user
    sign_in @user
  end

  # test "should get index" do
  #   get notes_url, :format => :json
  #   assert_response :success
  #   assert_equal(JSON(response.body).class, Hash)
  # end

  # test "should get new" do
  #   get new_note_url, :format => :json
  #   assert_response :success
  # end

  test "should create note" do
    assert_difference('Note.count') do
      post notes_url, params: { note: { content: @note.content, user_id: @note.user_id } }, :format => :json
    end

    assert_redirected_to note_url(Note.last)
  end

  # test "should show note" do
  #   get note_url(@note)
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get edit_note_url(@note)
  #   assert_response :success
  # end

  # test "should update note" do
  #   put note_url(@note), params: { note: { content: @note.content, user_id: @note.user_id } }
  #   assert_redirected_to note_url(@note)
  # end

  # test "should destroy note" do
  #   assert_difference('Note.count', -1) do
  #     delete note_url(@note)
  #   end

  #   assert_redirected_to notes_url
  # end
end
