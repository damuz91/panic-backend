class CreateRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :requests do |t|
      t.references :user, null: false, foreign_key: true
      t.string :os
      t.string :request_type

      t.timestamps
    end
  end
end
