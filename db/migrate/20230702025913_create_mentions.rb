class CreateMentions < ActiveRecord::Migration[7.0]
  def change
    create_table :mentions do |t|
      t.references :mentioning, foreign_key: { to_table: :reports }
      t.references :mentioned, foreign_key: { to_table: :reports }
      t.index [:mentioning_id, :mentioned_id], unique: true
      t.timestamps
    end
  end
end
