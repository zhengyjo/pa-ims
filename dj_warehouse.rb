require 'yaml'
require 'yaml/store'
require './artist.rb'
require './track.rb'

# This is a storage to store all the information.
# Here are the introduction of different attributes:
# artist_info_file : the YAML file to store artist relevant information
# track_info_file : the YAML file to store track relevant information
# directory: a mapping between singer's name (key) and its initials value. It will be stored in artist_info_file
# reverse_directory: A mapping for back-searching between initials(key) and singer's name(value). It will be stored in artist_info_file
# song_list:a mapping between track's name (key) and its track number(value). It will be stored in track_info_file
# reverse_song_list:A mapping for back-searching between track number (key) and its track name(value). It will be stored in track_info_file
# history: Play history list store in track_info_file
# track_num/currentTrackID: list the next available track number

class WareHouse
  attr_accessor :artist_info_file, :track_info_file, :track_num, :directory, :reverse_directory, :song_list,:reverse_song_list,:history, :track_num

  def initialize(artist_info, track_info)
    @artist_info_file = YAML::Store.new(artist_info)
    self.artist_info_file.transaction do
      @directory = self.artist_info_file["directory"]
      @reverse_directory = self.artist_info_file["reverse_directory"]
    end
    @track_info_file = YAML::Store.new(track_info)
    self.track_info_file.transaction do
      @song_list = self.track_info_file["song_list"]
      @reverse_song_list = self.track_info_file["reverse_song_list"]
      @history = self.track_info_file["history"]
      @track_num = self.track_info_file["currentTrackID"].to_i
    end

  end

  def add_artist(person)
    if(!self.reverse_directory.key?(person.name))#Check whether this artist is existing in our storage
      initials = generate_id(person.name)
      person.id = initials
      directory[initials] = person
      reverse_directory[person.name] = initials
      puts "#{person.name} has been added. Artist initial is #{initials}"
    else
      puts "This artist has already existed"
    end
  end

  #If no same initials store in the directory, then the initials of the artist name would be the id
  #Otherwise generate a random number to append to the initials and check whether this new id exists in the storage
  #If existed, repeat the last step.
  def generate_id(name)
    name_arr = name.split;
    id = ""
    for subname in name_arr
      id = id + subname[0,1]
    end
    temp = id
    prng1 = Random.new(1234)
    while(directory.key?(temp))
      temp = id + prng1.rand(100).to_s
    end
    return temp
  end

  def add_song_to_warehouse(song)
    if(!self.reverse_song_list.key?(song.name))#Check whether this song is existing in our storage
      self.song_list[self.track_num] = song
      self.reverse_song_list[song.name] = self.track_num
      puts "#{song.name} has been added. Track number is #{self.track_num}"
      self.track_num = self.track_num + 1
      self.directory[song.singer].add_song(song)
    else
      puts "This song has already existed"
    end
  end

  def add_history(song_name)
    history.push(song_name)
    if(history.length > 3)#only list the last three played song
      history.shift
    end
  end

  #Save the corresponding information to the YAML.
  def put_back
    self.artist_info_file.transaction do
      self.artist_info_file["reverse_directory"] = reverse_directory
      self.artist_info_file["directory"] = directory
    end
    self.track_info_file.transaction do
      self.track_info_file["song_list"] = song_list
      self.track_info_file["reverse_song_list"] = reverse_song_list
      self.track_info_file["history"] = history
      self.track_info_file["currentTrackID"] = track_num.to_s
    end
  end

end
