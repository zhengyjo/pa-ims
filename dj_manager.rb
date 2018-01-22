require './artist.rb'
require './track.rb'
require './dj_warehouse.rb'
require './add_department.rb'
require './info_department.rb'

class Manager
  attr_accessor :warehouse

  def initialize(warehouse)
    @warehouse = warehouse
  end

  def add(input_arr)
    add_dept = AddDepartment.new(self.warehouse)
    add_dept.add(input_arr)
  end

  def info(input_arr)
    info_dept = InfoDepartment.new(self.warehouse)
    info_dept.info(input_arr)
  end

  def help(input_arr)
      if(input_arr.length > 1)
        puts "Help does not have parameter(s)."
      else
        puts %q{
        Help - display a simple help screen. This is a text message, multi line, that explains the available commands. Sort of like this list.
        Exit - save state and exit. The effect of this is that when the app is run again, it is back to exactly where it was when you exited. What this amounts to is basically to make sure the tracks and artists and their info have all been saved.
        Info - display a high level summary of the state. At minimum, the last 3 tracks played, and a count of the total number of tracks and the total number of artists. You can elaborate if you want.
        Info track - Display info about a certain track by number. e.g. info track 13
        Info artist - Display info about a certain artist, by id. e.g. info artist jo
        Add Artist - Adds a new artist to storage and assign an artist id. Default artist id is the initials of the artist. If this is ambiguous then another id is automatically assigned and displayed. e.g. add artist john osborne
        Add Track - Add a new track to storage. add track watching the sky turn green / jo
        Play Track - Record that an existing track was played at the current time, e.g. play track 13.
        Count tracks - Display how many tracks are known by a certain artist, e.g. count tracks by jo
        List tracks - Display the tracks played by a certain artist, e.g. list tracks by jo
        }
      end
  end

  def play(input_arr)
    history = warehouse.get_history_list
    tracks = warehouse.get_track_list
    if(input_arr.length > 3 || input_arr[1] != 'track' || input_arr[2].to_i >= tracks.length || input_arr[2].to_i < 0)
      puts "Invalid play statement. Please refer Help"
    else
      puts "Now it is playing #{tracks[input_arr[2].to_i].name}."
      warehouse.add_history(tracks[input_arr[2].to_i].name)
    end
  end

  def count(input_arr)
    if(input_arr.length > 4 || input_arr[1] != 'tracks' || input_arr[2] != 'by')
      puts "Invalid count statement. Please refer Help"
    else
      artists = warehouse.get_artist_list
      initials = input_arr[3]
      if(artists.key?(initials))
        puts "The number of songs from this artist is #{artists[initials].songs.length}"
      else
        puts "Invalid id of artist"
      end
    end
  end

  def list(input_arr)
    if(input_arr.length > 4 || input_arr[1] != 'tracks' || input_arr[2] != 'by')
      puts "Invalid list statement. Please refer Help"
    else
      artists = warehouse.get_artist_list
      initials = input_arr[3]
      if(artists.key?(initials))
        puts "The song list of this artist is"
        artists[initials].list
      else
        puts "Invalid id of artist"
      end
    end
  end

  def store_back()
    self.warehouse.put_back
  end

end
