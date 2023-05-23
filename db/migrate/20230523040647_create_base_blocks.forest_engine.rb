# This migration comes from forest_engine (originally 20170109185414)
class CreateBaseBlocks < ActiveRecord::Migration[5.0]
  def change
    create_table :base_blocks do |t|

      t.timestamps
    end
  end
end
