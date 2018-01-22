require './artist.rb'
require './track.rb'
require './dj_warehouse.rb'

class InfoDepartment
  attr_accessor :warehouse

  def initialize(warehouse)
    @warehouse = warehouse
  end

  def info(input_arr)
    if(input_arr.length != 1 && input_arr.length != 3)
      puts "Invalid info statement. Please refer to the help"
    elsif
      history = warehouse.get_history_list
      tracks = warehouse.get_track_list
      artists = warehouse.get_artist_list
      if(input_arr.length == 1)
        puts "The last song(s) played (up to last 3) are #{history}. The total number of track is #{tracks.length}. The total number of singer is #{artists.length}"
      elsif(input_arr[1] == 'track')
        info_song(input_arr,tracks)
      elsif(input_arr[1] == 'artist')
        info_artist(input_arr,artists)
      end
    end
  end

  def info_song(input_arr,tracks)
    if(input_arr[2].to_i < tracks.length && input_arr[2].to_i >= 0)
      puts tracks[input_arr[2].to_i]
    else
      puts "Invalid track number."
    end
  end

  def info_artist(input_arr,artist)
    if(artist.key?(input_arr[2]))
      puts artist[input_arr[2]]
    else
      puts "Invalid artist id."
    end
  end

end
