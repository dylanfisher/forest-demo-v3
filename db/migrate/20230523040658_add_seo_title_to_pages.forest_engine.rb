# This migration comes from forest_engine (originally 20190423173909)
class AddSeoTitleToPages < ActiveRecord::Migration[5.0]
  def change
    add_column :pages, :seo_title, :string
  end
end
