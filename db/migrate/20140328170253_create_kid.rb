class CreateKid < ActiveRecord::Migration
  def change
    create_table :kids do |t|
      t.belongs_to :mom
      t.belongs_to :dad
      t.belongs_to :person
      t.timestamps
    end
  end
end
