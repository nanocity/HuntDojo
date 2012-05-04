# This file is part of HuntDojo.
#
# HuntDojo is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# HunDojo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with HuntDojo.  If not, see <http://www.gnu.org/licenses/>.

require 'trollop'
require './lib/simulation'

options = Trollop::options do
  opt :preys, "Class to enhanced the poor preys", :short => 'p', :type => String
  opt :hunters, "Class to enhanced the wild hunters", :short => 'h', :type => String
end

Dojo::Simulation.new( options ).show
