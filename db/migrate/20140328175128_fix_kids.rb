class FixKids < ActiveRecord::Migration
  def change

    rename_table :kids, :parents

  end
end
