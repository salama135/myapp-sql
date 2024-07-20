class CreateApplicationModels < ActiveRecord::Migration[7.2]
  def change
    create_table :application_models do |t|
      t.string :name
      t.string :token
      t.integer :chats_count

      t.timestamps
    end
  end
end
