class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.references :request, null: false, foreign_key: true
      t.string :message
      t.string :destination
      t.string :message_type
      t.string :status
      t.string :name

      t.timestamps
    end
  end
end
