class Person < ActiveRecord::Base
  validates :name, presence: true

  after_save :make_marriage_reciprocal

  has_many :moms
  has_many :dads
  has_many :parents

  def spouse
    if spouse_id.nil?
      nil
    else
      Person.find(spouse_id)
    end
  end

# private

  def make_marriage_reciprocal
    if spouse_id_changed?
      spouse.update(:spouse_id => id)
    end
  end

  def mom(kid)
    Person.find(kid.parents[0].mom_id)
  end

  def dad(kid)
    Person.find(kid.parents[0].dad_id)
  end
end
