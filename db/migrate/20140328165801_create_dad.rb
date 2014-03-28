class CreateDad < ActiveRecord::Migration
  def change
    create_table :dads do |t|
      t.belongs_to :person
      t.timestamps
    end
  end
end
