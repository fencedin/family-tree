class Parent < ActiveRecord::Base
  belongs_to :mom
  belongs_to :dad
  belongs_to :person
end
