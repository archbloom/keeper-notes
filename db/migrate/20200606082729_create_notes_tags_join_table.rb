class CreateNotesTagsJoinTable < ActiveRecord::Migration[5.0]
  def change
    create_join_table :notes, :tags
  end
end
