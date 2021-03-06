class Company
  include Neo4j::ActiveNode

  property :name, type: String
  property :uid, type: Integer
	property :market_cap, type: Float

  has_n(:competitors).to("Company")
  has_n(:news)

  validates_uniqueness_of :uid

  def graph_json
    hash = Hash.new

    # Create nodes array.
    nodesArray = []
    nodesArray << {"name" => self.name, "group" => 1}

    competitors_limit = [self.competitors.count, 4].min # Max 5 competitors
    self.competitors.to_a[0..competitors_limit].each do |c|
      nodesArray << {"name" => c.name, "group" => 2}
    end
    hash['nodes'] = nodesArray

    # Links
    linksArray = []
    self.competitors.to_a[0..competitors_limit].each_with_index do |c, i|
      linksArray << {"source" => 0, "target" => (i + 1), "value" => 1}
    end
    hash['links'] = linksArray
    hash
  end

end
