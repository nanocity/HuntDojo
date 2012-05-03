require 'trollop'
require './lib/simulation'

options = Trollop::options do
  opt :preys, "Class to enhanced the poor preys", :short => 'p', :type => String
  opt :hunters, "Class to enhanced the wild hunters", :short => 'h', :type => String
end

Dojo::Simulation.new( options ).show
