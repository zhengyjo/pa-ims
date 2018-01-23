require './track.rb'
require 'set'

#Artist object
class Artist
  attr_accessor :name
  attr_accessor :id
  attr_accessor :songs

  def initialize(name)
    @name = name.downcase
    #@initials = initials
    @songs = [].to_set #This is a set, in case we have repetition.
  end

  def to_s
    "The name of id #{id} is #{name}."
  end

  # Add songs to the corresponding artist.
  def add_song(song)
    if(!songs.include?song)
      songs.add(song)
    end
  end

  #It will be used in the list function in the manager
  def list
    for song in self.songs
      puts song.name
    end
  end

end
