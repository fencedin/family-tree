require 'spec_helper'

describe Person do
  before do
    Person.clear
  end

  it { should validate_presence_of :name }
  it { should have_many :moms }
  it { should have_many :dads }
  it { should have_many :parents }

  context '#spouse' do
    it 'returns the person with their spouse_id' do
      earl = Person.create(:name => 'Earl')
      steve = Person.create(:name => 'Steve')
      steve.update(:spouse_id => earl.id)
      steve.spouse.should eq earl
    end

    it "is nil if they aren't married" do
      earl = Person.create(:name => 'Earl')
      earl.spouse.should be_nil
    end
  end

  it "updates the spouse's id when it's spouse_id is changed" do
    earl = Person.create(:name => 'Earl')
    steve = Person.create(:name => 'Steve')
    steve.update(:spouse_id => earl.id)
    earl.reload
    earl.spouse_id.should eq steve.id
  end

  context '#ancestors' do
    it 'returns the mother and father objects given a person' do
      kid = Person.create(name: 'bob')
      mom = Person.create(name: 'june')
      dad = Person.create(name: 'ward')
      Mom.create(person_id: mom.id)
      Dad.create(person_id: dad.id)
      Parent.create(mom_id: mom.id, dad_id: dad.id, person_id: kid.id)
      kid.ancestry(kid, 1).should eq [mom, dad]
    end

    it 'returns the mother of the mother and father of the father objects given a person' do
      kid = Person.create(name: 'bob')
      mom = Person.create(name: 'june')
      dad = Person.create(name: 'ward')
      gmom = Person.create(name: 'sally')
      gdad = Person.create(name: 'jack')
      gdmom = Person.create(name: 'jean')
      gddad = Person.create(name: 'billy')
      Mom.create(person_id: mom.id)
      Dad.create(person_id: dad.id)
      Mom.create(person_id: gmom.id)
      Dad.create(person_id: gdad.id)
      Mom.create(person_id: gdmom.id)
      Dad.create(person_id: gddad.id)
      Parent.create(mom_id: mom.id, dad_id: dad.id, person_id: kid.id)
      Parent.create(mom_id: gmom.id, dad_id: gdad.id, person_id: mom.id)
      # Parent.create(mom_id: gdmom.id, dad_id: gddad.id, person_id: dad.id)
      array = kid.ancestry(kid, 2)
      array[5].name.should eq "Unknown Father"
    end
  end
end
