class AddResponses < ActiveRecord::Migration
  def self.up
    create_table :responses do |t|
      t.integer :responder_id
    end
    rename_column :answers, :responder_id, :response_id
    add_index :answers, :response_id, {:name => 'answers_response_index'}
    add_index :responders, :email_address, {:name => 'responders_email_address_index'}
  end

  def self.down
    remove_index :responders, {:name => 'responders_email_address_index'}
    remove_index :answers, {:name => 'answers_response_index'}
    rename_column :answers, :response_id, :responder_id
    drop_table :responses
  end
end
