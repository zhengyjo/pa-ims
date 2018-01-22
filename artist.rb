require './track.rb'
require 'set'

class Artist
  attr_accessor :name
  attr_accessor :id
  attr_accessor :songs

  def initialize(name)
    @name = name.downcase
    #@initials = initials
    @songs = [].to_set
  end

  def to_s
    "The name of id #{id} is #{name}."
  end

  def add_song(song)
    if(!songs.include?song)
      songs.push(song)
    end
  end

  def list
    for song in self.songs
      puts song.name
    end
  end

end
