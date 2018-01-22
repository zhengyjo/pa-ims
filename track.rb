class Track
  attr_accessor :name
  attr_accessor :singer

  def initialize(name,singer)
    @name = name
    @singer = singer
  end

  def to_s
    "The name of this track is #{name}. It is sung by #{singer}"
  end

end
