class CreateChatModels < ActiveRecord::Migration[7.2]
  def change
    create_table :chat_models do |t|
      t.references :application_model, null: false, foreign_key: true
      t.integer :number
      t.integer :messages_count

      t.timestamps
    end
  end
end
