require 'bundler/setup'
Bundler.require(:default)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def menu
  puts 'Welcome to the family tree!'
  puts 'What would you like to do?'

  loop do
    puts "Press [a] to add a family member."
    puts "      [l] to list out the family members."
    puts "      [m] to add who someone is married to."
    puts "      [s] to see who someone is married to."
    puts "      [k] to add a kid to 2 people."
    puts "      [p] to see a persons parents."
    puts "      [x] to exit."
    choice = gets.chomp

    case choice
    when 'a'
      add_person
    when 'l'
      list
    when 'm'
      add_marriage
    when 's'
      show_marriage
    when 'k'
      add_kid
    when 'p'
      show_parents
    when 'x'
      exit
    end
  end
end

def add_person
  puts 'What is the name of the family member?'
  name = gets.chomp
  Person.create(:name => name)
  puts name + " was added to the family tree.\n\n"
end

def add_marriage
  list
  puts 'What is the number of the first spouse?'
  spouse1 = Person.find(gets.chomp)
  puts 'What is the number of the second spouse?'
  spouse2 = Person.find(gets.chomp)
  spouse1.update(:spouse_id => spouse2.id)
  puts spouse1.name + " is now married to " + spouse2.name + ".\n\n"
end

def list
  puts 'Here are all your relatives:'
  people = Person.all
  people.each do |person|
    puts person.id.to_s + " " + person.name
  end
  puts "\n\n"
end

def show_marriage
  list
  puts "Enter the number of the relative and I'll show you who they're married to."
  person = Person.find(gets.chomp)
  spouse = Person.find(person.spouse_id)
  puts person.name + " is married to " + spouse.name + ".\n\n"
end

def add_kid
  list
  puts "What is the number of kid?"
  kid = Person.find(gets.chomp)
  puts "What is the number of the mom?"
  mom = Person.find(gets.chomp)
  puts "What is the number of the dad?"
  dad = Person.find(gets.chomp)
  Mom.create(person_id: mom.id)
  Dad.create(person_id: dad.id)
  Parent.create(mom_id: mom.id, dad_id: dad.id, person_id: kid.id)
  puts "#{kid.name} now has the parents: #{mom.name} and #{dad.name}\n\n"
end

def show_parents
  list
  puts "Enter the number of the relative you want to see the parents of."
  kid = Person.find(gets.chomp)
  mom = kid.mom(kid)
  dad = kid.dad(kid)
  puts "#{kid.name} has the parents: #{mom.name} and #{dad.name}\n\n"
end


def clear
  system "clear && printf '\e[3J'"
end
clear
menu
