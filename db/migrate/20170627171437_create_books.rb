class CreateBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :author, null: false
      t.string :book_url
      t.text :description
      t.references :user, foreign_key: true
      t.references :section, foreign_key: true

      t.timestamps
    end
  end
end
