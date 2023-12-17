class AddPasswordToPeople < ActiveRecord::Migration[7.1]
  def change
    add_column :people, :password, :string
  end
end
