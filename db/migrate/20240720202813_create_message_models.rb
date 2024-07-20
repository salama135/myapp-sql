class CreateMessageModels < ActiveRecord::Migration[7.2]
  def change
    create_table :message_models do |t|
      t.references :chat_model, null: false, foreign_key: true
      t.integer :number
      t.text :body

      t.timestamps
    end
  end
end
