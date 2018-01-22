require "minitest/autorun"
require 'o_stream_catcher'
require_relative "dj_manager.rb"


describe Manager do
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

  before do
    artist_info = './artist_test.yml'
    artist_info_check(artist_info)
    track_info = './track_test.yml'
    track_info_check(track_info)
    dj_warehouse = WareHouse.new(artist_info,track_info)
    @dj_manager = Manager.new(dj_warehouse)
    @dj_manager.add("add artist sam smith".split)
    @dj_manager.add("add artist zhou shen".split)
    @dj_manager.add('add track stay with me / ss'.split)
    @dj_manager.add('add track da yu hai tang / zs'.split)
  end

  it "can show help" do
    input = "help"
    result, stdout, stderr = OStreamCatcher.catch do
      @dj_manager.help(input.downcase.split)
    end
    result, stdout2, stderr = OStreamCatcher.catch do
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

    stdout.must_equal stdout2
  end

  it "can add an artist" do
    input = "add artist Mariah Carey"
    @dj_manager.add(input.downcase.split)
    @dj_manager.warehouse.reverse_directory.include?("mariah carey").must_equal true
  end

  it "can add a song" do
    #You  must add the artist first
    input = "add artist Mariah Carey"
    @dj_manager.add(input.downcase.split)
    input = 'add track hero / mc'
    @dj_manager.add(input.downcase.split)
    @dj_manager.warehouse.reverse_song_list.include?("hero").must_equal true
  end

  it "can add different names with same initials " do
    #You  must add the artist first
    input = "add artist Mariah Carey"
    @dj_manager.add(input.downcase.split)
    input = "add artist Matt Canon"
    @dj_manager.add(input.downcase.split)
    mc1 = @dj_manager.warehouse.reverse_directory["mariah carey"]
    mc2 = @dj_manager.warehouse.reverse_directory["matt canon"]
    is_nil_mc1 = mc1.nil?
    is_nil_mc2 = mc2.nil?
    is_nil_mc1.must_equal false
    is_nil_mc2.must_equal false
    diff = (mc1 != mc2)
    diff.must_equal true
  end

  it "can show the information of an artist " do
    input = "info artist ss"
    result, stdout, stderr = OStreamCatcher.catch do
      @dj_manager.info(input.downcase.split)
    end
    correct_words = "The name of id ss is sam smith.\n"
    stdout.must_equal correct_words
  end

  it "can't show the information of an artist not in the warehouse " do
    input = "info artist ww"
    result, stdout, stderr = OStreamCatcher.catch do
      @dj_manager.info(input.downcase.split)
    end
    correct_words = "Invalid artist id.\n"
    stdout.must_equal correct_words
  end

  it "can show the information of a song " do
    input = "info track 0"
    result, stdout, stderr = OStreamCatcher.catch do
      @dj_manager.info(input.downcase.split)
    end
    correct_words = "The name of this track is stay with me. It is sung by ss\n"
    stdout.must_equal correct_words
  end

  it "can't show the information of a song not in the warehouse " do
    input = "info track 100000"
    result, stdout, stderr = OStreamCatcher.catch do
      @dj_manager.info(input.downcase.split)
    end
    correct_words = "Invalid track number.\n"
    stdout.must_equal correct_words
  end

  it "can show the how many tracks are known by a certain artist" do
    input = "count tracks by zs"
    result, stdout, stderr = OStreamCatcher.catch do
      @dj_manager.count(input.downcase.split)
    end
    correct_words = "The number of songs from this artist is 1\n"
    stdout.must_equal correct_words
  end

  it "can show the tracks played by a certain artist" do
    input = "list tracks by zs"
    result, stdout, stderr = OStreamCatcher.catch do
      @dj_manager.list(input.downcase.split)
    end
    correct_words = "The song list of this artist is\nda yu hai tang\n"
    stdout.must_equal correct_words
  end

  it "can play the tracks" do
    input = "play track 0"
    result, stdout, stderr = OStreamCatcher.catch do
      @dj_manager.play(input.downcase.split)
    end
    correct_words = "Now it is playing stay with me.\n"
    stdout.must_equal correct_words
  end

  it "can show the general information" do
    input = "play track 0"
    @dj_manager.play(input.downcase.split)
    input = "play track 1"
    @dj_manager.play(input.downcase.split)
    input = "play track 0"
    @dj_manager.play(input.downcase.split)
    input = "info"
    result, stdout, stderr = OStreamCatcher.catch do
      @dj_manager.info(input.downcase.split)
    end
    correct_words = "The last song(s) played (up to last 3) are #{@dj_manager.warehouse.history}. The total number of track is #{@dj_manager.warehouse.song_list.length}. The total number of singer is #{@dj_manager.warehouse.directory.length}\n"
    stdout.must_equal correct_words
  end

  after do
    File.delete('./artist_test.yml')
    File.delete('./track_test.yml')
  end


end
