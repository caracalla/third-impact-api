class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.text :content,    null: false
      t.string :title,    null: false
      t.references :user, index: true, foreign_key: true

      t.timestamps
    end
  end
end
