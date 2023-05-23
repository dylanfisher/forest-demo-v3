# This migration comes from forest_engine (originally 20180415034427)
class AddRedirectToPages < ActiveRecord::Migration[5.1]
  def change
    add_column :pages, :redirect, :string
  end
end
