class CreateGraphics < ActiveRecord::Migration[5.2]
  def change
    create_table :graphics do |t|
      t.string :name, null: false
      t.references :user, foreign_key: true
      t.timestamp :deleted_at
      t.string :privacy
      t.text :alt_text

      t.timestamps
    end
  end
end
