class CreatePeople < ActiveRecord::Migration[7.1]
  def change
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.boolean :sick
      t.date :date_exposed
      t.date :date_logged

      t.timestamps
    end
  end
end
