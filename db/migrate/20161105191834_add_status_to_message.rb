class AddStatusToMessage < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :status, :char
  end
end
