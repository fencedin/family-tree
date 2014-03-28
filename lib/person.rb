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
    mother = nil
    begin
      Person.find(person.parents[0]).name != nil
      mother = Person.find(person.parents[0].mom_id)
      @@ancestors << mother
    rescue
      @@ancestors << Person.create(name: "Unknown Mother")
    end

    father = nil
    begin
    Person.find(person.parents[0]).name != nil
      father = Person.find(person.parents[0].dad_id)
      @@ancestors << father
    rescue
      @@ancestors << Person.create(name: "Unknown Father")
    end

    begin
      if generation > 1
        mother.ancestry(mother, generation-1)
        father.ancestry(father, generation-1)
      else
        @@ancestors
      end
    rescue
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
