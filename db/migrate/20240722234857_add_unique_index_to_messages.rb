class AddUniqueIndexToMessages < ActiveRecord::Migration[7.2]
  def change
    remove_foreign_key :message_models, :chat_models
    remove_index :message_models, name: "index_message_models_on_chat_model_id"
    add_foreign_key "message_models", "chat_models"
    add_index :message_models, [:chat_model_id, :number], unique: true # Unique index

  end
end
