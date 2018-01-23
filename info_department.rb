require './artist.rb'
require './track.rb'
require './dj_warehouse.rb'

#Info function
class InfoDepartment
  attr_accessor :warehouse

  def initialize(warehouse)
    @warehouse = warehouse
  end

  def info(input_arr)
    if(input_arr.length != 1 && input_arr.length != 3) #Only "info", "info artist <initials>", and "info track <track_num> can work"
      puts "Invalid info statement. Please refer to the help"
    elsif
      if(input_arr.length == 1)#General information
        puts "The last song(s) played (up to last 3) are #{warehouse.history}. The total number of track is #{warehouse.song_list.length}. The total number of singer is #{warehouse.directory.length}"
      elsif(input_arr[1] == 'track')#track information
        info_song(input_arr,warehouse.song_list)
      elsif(input_arr[1] == 'artist')#artist information
        info_artist(input_arr,warehouse.directory)
      else
        puts "invalid info information. Please specify."
      end
    end
  end

  def info_song(input_arr,tracks)
    if(input_arr[2].to_i < tracks.length && input_arr[2].to_i >= 0)#check whether the number is valid
      puts tracks[input_arr[2].to_i]
    else
      puts "Invalid track number."
    end
  end

  def info_artist(input_arr,artist)
    if(artist.key?(input_arr[2]))#check whether the initial is valid
      puts artist[input_arr[2]]
    else
      puts "Invalid artist id."
    end
  end

end
