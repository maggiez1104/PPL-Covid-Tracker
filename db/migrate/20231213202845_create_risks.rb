class CreateRisks < ActiveRecord::Migration[7.1]
  def change
    create_table :risks do |t|
      t.string :first_name
      t.string :last_name
      t.string :risk

      t.timestamps
    end
  end
end
