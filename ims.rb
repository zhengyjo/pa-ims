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
        store_a["reverseDirectory"] = {}
      end
    end
  end

  def track_info_check(track_info)
    if(!File.exists?(track_info))
      File.new(track_info,'w+')
      store = YAML::Store.new(track_info)
      store.transaction do
        store["history"] = []
        store["songlist"] = {}
        store["reverseSonglist"] = {}
      end
    end
  end

  def start
    prompt = 'ims>'
    print prompt
    input = $stdin.gets.chomp.downcase

    while input != 'exit'
      if(input.split[0] != 'info' && input.split[0] != 'help' && input.split[0] != 'add'&& input.split[0] != 'play' && input.split[0] != 'count' && input.split[0] != 'list')
        puts "Invalid statement. Please try again!"
      else
        #puts"#{dj_manager.class}"
        self.dj_manager.process(input)
      end
      print prompt
      input = $stdin.gets.chomp.downcase
    end
    dj_manager.store_back
  end

  ims = IMS.new
  ims.start

end
