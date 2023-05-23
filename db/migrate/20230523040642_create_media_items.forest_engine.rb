# This migration comes from forest_engine (originally 20161219231741)
class CreateMediaItems < ActiveRecord::Migration[5.0]
  def change
    create_table :media_items do |t|
      t.string :title
      t.string :slug
      t.text :caption
      t.string :alternative_text
      t.text :description
      t.text :dimensions

      t.references :attachable, polymorphic: true, index: true

      t.timestamps
    end
    add_index :media_items, :slug, unique: true
  end
end
