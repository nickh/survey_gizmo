class MergeRespondentIntoResponse < ActiveRecord::Migration
  # Tricky Railsism: if the model has been removed, we need to define it for the migration
  unless Object.const_defined?('Respondent')
    class Respondent < ActiveRecord::Base ; end
  end

  def self.up
    # Merge the Respondent data into the Responses
    add_column :responses, :email_address, :string
    add_column :responses, :name,          :string
    Respondent.find(:all).each do |respondent|
      responses = Response.find_by_sql(['SELECT * FROM responses WHERE respondent_id=?', respondent.id])
      responses.first.update_attributes(
        :email_address => respondent.email_address,
        :name          => respondent.name
      ) unless responses.empty?
    end

    # Remove Respondents
    drop_table    :respondents
    remove_column :responses, :respondent_id
  end

  def self.down
    create_table :respondents do |t|
      t.string :email_address, :name
    end
    add_column :responses, :respondent_id, :integer

    Response.find(:all).each do |response|
      respondent = Respondent.create(:email_address => response.email_address, :name => response.name)
      response.update_attribute(:respondent_id, respondent)
    end

    remove_column :responses, :email_address
    remove_column :responses, :name
  end
end
