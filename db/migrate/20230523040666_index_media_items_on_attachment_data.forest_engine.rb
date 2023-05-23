# This migration comes from forest_engine (originally 20210127170153)
class IndexMediaItemsOnAttachmentData < ActiveRecord::Migration[6.0]
  def change
    add_index :media_items, :attachment_data, using: :gin
    add_index :media_items, "(attachment_data->'derivatives')", using: :gin, name: 'index_media_items_on_attachment_data_derivatives'
  end
end
