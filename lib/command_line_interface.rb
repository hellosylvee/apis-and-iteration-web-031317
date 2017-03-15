require_relative 'api_communicator'
def welcome
  # puts out a welcome message here!
  puts "Welcome to the Star Wars API browser"
end

def get_character_from_user
  puts "please enter a character"
  # use gets to capture the user's input. This method should return that input, downcased.
  response = gets.chomp
end

def get_character_info_type_from_user
  puts "What do you want to know?"
  puts "  -height
  -mass
  -gender
  -birth-year
  -home-world
  -films
  -species
  -back"
  response = gets.chomp.downcase
end

def help
  puts ask-character
end

def run
  response = ''
  welcome
  until response == 'quit' do
    info_type= ''
    response = get_character_from_user
    if response != 'quit'
      while info_type != 'back' do
        character = create_new( response )
        info_type = get_character_info_type_from_user
        case info_type
          when 'height'
            puts "#{response} is #{character.height} tall"
          when 'mass'
            puts "#{response} weighs #{character.mass}"
          when 'gender'
            puts "#{response} is #{character.gender}"
          when 'birth-year'
            puts "#{response} was born on #{character.birth_year}"
          when 'home-world'
            puts "#{response} is from #{character.home_world}"
          when 'films'
            parse_character_movies( character.films )
          when 'species'
            puts "#{response} is a #{character.species}"
        end
      end
    end
  end
end

run
