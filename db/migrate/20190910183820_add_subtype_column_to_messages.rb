class AddSubtypeColumnToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :subtype, :string
  end
end
