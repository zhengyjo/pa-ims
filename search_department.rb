require './artist.rb'
require './track.rb'
require './dj_warehouse.rb'

#Search function
class SearchDepartment
  attr_accessor :warehouse

  def initialize(warehouse)
    @warehouse = warehouse
  end

  def search(input_arr)
    tracks = warehouse.reverse_song_list#Retrieve the songname - track number list from warehouse
    artists = warehouse.reverse_directory#Retrieve the artist_name - initial map from warehouse
    if(input_arr[1] == 'artist')
      search_gen(input_arr,artists)
    elsif(input_arr[1] == 'track')
      search_gen(input_arr,tracks)
    else
      puts "invalid search information. Please specify."
    end
  end

  #If you are searching an artist, it will return an id
  #If you are searching a track, it will return a track number
  def search_gen(input_arr,artists)
    len = input_arr.count
    singer_name = input_arr[2,len - 1] * " "
    if(artists.key?(singer_name))
      puts artists[singer_name]
    else
      puts "Invalid artist name."
    end
  end

end
