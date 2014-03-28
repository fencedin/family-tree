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

  @@ancestors = []

  def Person.clear
    @@ancestors = []
  end

  def ancestry(person, generation)
    mother = Person.find(person.parents[0].mom_id)
    if mother != nil
      @@ancestors << mother
    else
      @@ancestors << Person.create(name: "Unknown Mother")
    end
    father = Person.find(person.parents[0].dad_id)
    if father != nil
      @@ancestors << father
    else
      @@ancestors << Person.create(name: "Unknown Father")
    end
    if generation > 1
      mother.ancestry(mother, generation-1)
      father.ancestry(father, generation-1)
    else
      @@ancestors
    end
  end

private

  def make_marriage_reciprocal
    if spouse_id_changed?
      spouse.update(:spouse_id => id)
    end
  end
end
