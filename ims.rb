require './dj_manager.rb'
require './dj_warehouse.rb'
require 'yaml/store'

#put that into a driver class
class IMS
  attr_accessor :dj_manager

  def initialize()
    artist_info = './artist_info.yml'
    track_info = './track_info.yml'
    artist_info_check(artist_info)
    track_info_check(track_info)
    dj_warehouse = WareHouse.new(artist_info,track_info)
    @dj_manager = Manager.new(dj_warehouse)
  end

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

  def start
    prompt = '>'
    print prompt
    input = $stdin.gets.chomp.downcase
    keywords = ["add","info","help","list","count","play"]

    while input != 'exit'
      keyword = input.split[0]
      if keywords.include? keyword
        self.dj_manager.public_send(keyword, input.downcase.split)
        dj_manager.store_back
      else
        puts "ERROR"
      end
      print prompt
      input = $stdin.gets.chomp.downcase
    end
    puts "save state and exit"
    dj_manager.store_back
  end

  ims = IMS.new
  ims.start

end
