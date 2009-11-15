class ResponderIsAReservedWord < ActiveRecord::Migration
  def self.up
    rename_table :responders, :respondents
    rename_column :responses, :responder_id, :respondent_id
  end

  def self.down
    rename_column :responses, :respondent_id, :responder_id
    rename_table :respondents, :responders
  end
end
