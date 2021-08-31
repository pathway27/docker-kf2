class MapList
  attr_accessor :default_maps, :custom_maps, :maps

  def initialize(default_maps: [], custom_maps: [])
    @default_maps = default_maps.map{|m| Map.new(m)}
    @custom_maps = custom_maps.map{|m| Map.new(m)}
    @maps = @default_maps + @custom_maps
  end

  def renderSteamworksIds
    template = %{[OnlineSubsystemSteamworks.KFWorkshopSteamworks]<% for map in maps %><% for id in map.steamworksids %>
ServerSubscribedWorkshopItems=<%= id %><% end %><% end %>}
    return ERB.new(template).result_with_hash(maps: @maps)
  end

  def renderSummaries
    template = %{
<% for map in maps %><%= map.renderSummary %><% end %>
    }
    return ERB.new(template).result_with_hash(maps: @maps)
  end

  def renderMapCycles(maps = @maps)
    template = %{
GameMapCycles=(Maps=(<%= all_map_names.join(",") %>))
    }
    return ERB.new(template).result_with_hash(
	all_map_names: maps.map{|m| "\"#{m.name}\""}
    )
  end

  private

  def map_names(m)
    mapnames = m.reject{|m| m.name == "KF-Default" }.map{|m| "\"#{m.name}\""}
    puts "MapList: #{mapnames}"
    return mapnames
  end
end
