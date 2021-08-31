require 'erb'
require 'yaml'

require './Map.rb'
require './MapList.rb'

class KFConfig
  KF_CONFIG_PREFIX = "#{ENV['HOME']}/kf2server/KFGame/Config/"
  #KF_CONFIG_PREFIX = "./LinuxServer-"
  KF_GAME	   = "LinuxServer-KFGame.ini"
  KF_ENGINE	   = "LinuxServer-KFEngine.ini"

  def initialize
    # Get the official map list then add any custom ones to the end of the array
    #@custom_maps = YAML.load_file "/home/steam/game.yml"
    @custom_maps = YAML.load_file "../game.yml"
    # TODO: Use folders in kf2server/KFGame/BrewedPC/Maps
    @default_maps = YAML.load_file "DefaultMaps.yml"
    puts "Found #{@custom_maps["custommaps"].length} custom map configs"

    @maplist = MapList.new(default_maps: @default_maps, custom_maps: @custom_maps["custommaps"])
  end

  def generate
    IO.write("#{KF_CONFIG_PREFIX}#{KF_GAME}", renderConfig(KF_GAME))
    puts "KFCONFIG: Wrote #{KF_CONFIG_PREFIX}#{KF_GAME} Successfully!"
    IO.write("#{KF_CONFIG_PREFIX}#{KF_ENGINE}", renderConfig(KF_ENGINE))
    puts "KFCONFIG: Wrote #{KF_CONFIG_PREFIX}#{KF_ENGINE} Successfully!"
    puts "KFCONFIG: Wrote Server Config Successfully!"
  end

  private

  def renderConfig(filename)
    template = File.read "#{filename}.erb"
    ERB.new(template).result_with_hash(maplist: @maplist)
  end
end

KFConfig.new.generate
