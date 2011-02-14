class AddSetnameToPics < ActiveRecord::Migration
  def self.up
    add_column :pics, :setname, :string
  end

  def self.down
    remove_column :pics, :setname
  end
end
