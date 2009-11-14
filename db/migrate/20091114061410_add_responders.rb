class AddResponders < ActiveRecord::Migration
  def self.up
    create_table :responders do |t|
      t.string :email_address, :name
    end
  end

  def self.down
    drop_table :responders
  end
end
