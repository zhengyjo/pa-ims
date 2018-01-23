require './dj_manager.rb'
require './dj_warehouse.rb'
require 'yaml/store'

#Driver/loop class, with attritube of the manager to handle client request
class IMS
  attr_accessor :dj_manager

  def initialize()
    artist_info = './artist_info.yml'
    track_info = './track_info.yml'
    artist_info_check(artist_info)#YAML file check
    track_info_check(track_info)#YAML file check
    dj_warehouse = WareHouse.new(artist_info,track_info)
    @dj_manager = Manager.new(dj_warehouse)
  end

  #Since my design requires the yaml file has a specific format
  #if the the artist YAML does not exist, I will create one
  def artist_info_check(artist_info)
    if(!File.exists?(artist_info))
      File.new(artist_info,'w+')
      store_a = YAML::Store.new(artist_info)
      store_a.transaction do
        store_a["directory"] = {}
        store_a["reverse_directory"] = {}
      end
    end
  end

  #Similar, Since my design requires the yaml file has a specific format
  #if the the artist YAML does not exist, I will create one
  def track_info_check(track_info)
    if(!File.exists?(track_info))
      File.new(track_info,'w+')
      store = YAML::Store.new(track_info)
      store.transaction do
        store["history"] = []
        store["song_list"] = {}
        store["reverse_song_list"] = {}
      end
    end
  end

  #This is the loop function
  def start
    prompt = '>'
    print prompt
    input = $stdin.gets.chomp.downcase
    keywords = ["add","info","help","list","count","play","search"]

    while input != 'exit'
      keyword = input.split[0]
      if keywords.include? keyword
        self.dj_manager.public_send(keyword, input.downcase.split)#Use keywords and public sends to not to use too many if
        #dj_manager.store_back
      else
        puts "ERROR"
      end
      print prompt
      input = $stdin.gets.chomp.downcase
    end
    puts "save state and exit"
    dj_manager.store_back #When exits, save the state
  end

  ims = IMS.new
  ims.start

end
