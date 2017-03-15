require 'rest-client' #this is required to use restclient
require 'json'
require 'pry'

#helper methods - defining methods
def find_character(character, characters_hash)
  characters_hash.find do |star_wars_character|
    star_wars_character["name"].downcase == character.downcase
  end
end #returns one hash

def films_for_a_character(character_hash) #character_hash for a single character's description
  if character_hash
    character_hash["films"]
  else
    puts "This character doesn't exist"
  end
end

def species_for_a_character(character_hash)
  character_hash["species"].map do |single_species|
    JSON.parse( RestClient.get( single_species ) )
  end
end

def homeworld_for_a_character(character_hash)
  JSON.parse( RestClient.get( character_hash["homeworld"] ) )
end

def characters
  all_characters = RestClient.get('http://www.swapi.co/api/people/') #retrieves and turn into string
  characters_hash = JSON.parse(all_characters) #converts data into hash, then
  characters_hash = characters_hash["results"]
end

def characters_names( characters )
  characters.map do |character|
    character["name"]
  end
end

#project methods
def get_character_movies_from_api(character)
  #make the web request
  all_characters = RestClient.get('http://www.swapi.co/api/people/') #retrieves and turn into string
  characters_hash = JSON.parse(all_characters) #converts data into hash, then
  characters_hash = characters_hash["results"] #shows only relevant data required in results
  # characters_hash = JSON.parse(all_characters)["results"] - in one line

  # iterate over the character hash to find the collection of `films` for the given
  #   `character`
  character_hash = find_character(character, characters_hash) #setting film_array to hash
  film_array = films_for_a_character(character_hash) #finding film value associated to that film key
  if film_array.is_a?( Array )
    film_array.map do |url|
      JSON.parse(RestClient.get(url))
    end
  end
end

  # collect those film API urls, make a web request to each URL to get the info
  #  for that film

  # return value of this method should be collection of info about each film.
  #  i.e. an array of hashes in which each hash reps a given film

  # this collection will be the argument given to `parse_character_movies`
  #  and that method will do some nice presentation stuff: puts out a list
  #  of movies by title. play around with puts out other info about a given film.
def parse_character_movies(films_array)
  # some iteration magic and puts out the movies in a nice list
  if films_array.is_a?(Array)
    films_array.each do |film|
      puts film["title"]
    end
  end
end

def show_character_movies(character)
  films_hash = get_character_movies_from_api(character)
  parse_character_movies(films_hash)
end

## BONUS
# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?

class SWCharacter
  def initialize( name='Storm Trooper' )
    @name = name
    if characters_names( characters ).include?( @name )
      character = find_character( @name, characters )

      @height = character["height"] + " cm"
      @mass = character["mass"] + " kg"
      @gender = character["gender"]
      @birth_year = character["birth_year"]
      @home_world = homeworld_for_a_character( character )["name"]
      @films = get_character_movies_from_api( @name )
      @species_array = species_for_a_character( character )
      @species = @species_array.map do |single_species|
        single_species["name"]
      end.join(" and ")
    end
  end

  attr_reader :name
  attr_accessor :height, :mass, :gender, :films, :species, :birth_year, :home_world


  def the_force
    puts 'May the force be with you'
  end
end

def create_new( name )
  character = SWCharacter.new( name )
end
