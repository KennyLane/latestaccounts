class AddNomcodeToNomtrans < ActiveRecord::Migration
  def change
    add_column :nomtrans, :nomcode, :string
  end
end
