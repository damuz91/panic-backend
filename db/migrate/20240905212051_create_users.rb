class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :store_user_id
      t.string :name
      t.boolean :is_premium, default: false

      t.timestamps
    end
  end
end
