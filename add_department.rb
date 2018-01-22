require './artist.rb'
require './track.rb'
require './dj_warehouse.rb'

class AddDepartment
  attr_accessor :warehouse

  def initialize(warehouse)
    @warehouse = warehouse
  end

  def add(input_arr)
    if(input_arr[1] == 'artist')
      add_artist(input_arr)
    elsif(input_arr[1] == 'track')
      add_song(input_arr)
    end
  end

  def add_artist(input_arr)
    len = input_arr.count
    singer_name = input_arr[2,len - 1] * " "
    singer = Artist.new(singer_name)
    warehouse.add_artist(singer)
  end

  def add_song(input_arr)
    sep = input_arr.index('/')
    if(sep != nil)
      song_name = input_arr[2,sep - 2] * " "
      len = input_arr.count
      singer_name = input_arr[sep + 1,len - sep - 1] * ""
      song = Track.new(song_name,singer_name)
      self.warehouse.add_song_to_warehouse(song)
    else
      puts "Invalid statement of adding track. Please use \'/\'"
    end
  end
  
end
