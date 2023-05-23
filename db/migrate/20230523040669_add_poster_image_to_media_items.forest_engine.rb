# This migration comes from forest_engine (originally 20220330211120)
class AddPosterImageToMediaItems < ActiveRecord::Migration[6.0]
  def change
    add_reference :media_items, :poster_image, null: true, foreign_key: { to_table: :media_items }
  end
end
