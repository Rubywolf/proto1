class AddImageWidthAndHeight < ActiveRecord::Migration
  def self.up
     add_column :pics, :img_width, :integer
     add_column :pics, :img_height, :integer
 end

  def self.down
    remove_column :pics, :img_width, :integer
    remove_column :pics, :img_height, :integer
  end
end
