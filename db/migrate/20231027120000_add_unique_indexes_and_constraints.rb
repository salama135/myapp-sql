class AddUniqueIndexesAndConstraints < ActiveRecord::Migration[7.2]
  def change
    add_index :application_models, :token, unique: true
    add_index :application_models, :name, unique: true
    add_index :chat_models, [:application_model_id, :number], unique: true, name: 'index_chats_on_app_id_and_number'
  end
end
