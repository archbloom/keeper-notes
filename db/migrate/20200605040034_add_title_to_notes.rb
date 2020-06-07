class AddTitleToNotes < ActiveRecord::Migration[5.0]
  def change
    add_column :notes, :title, :string
  end
end
