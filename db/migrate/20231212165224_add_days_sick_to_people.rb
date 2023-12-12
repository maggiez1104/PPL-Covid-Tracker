class AddDaysSickToPeople < ActiveRecord::Migration[7.1]
  def change
    add_column :people, :days_sick, :integer
  end
end
