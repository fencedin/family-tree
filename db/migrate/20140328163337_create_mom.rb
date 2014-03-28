class CreateMom < ActiveRecord::Migration
  def change
    create_table :moms do |t|
      t.belongs_to :person
      t.timestamps
    end
  end
end
