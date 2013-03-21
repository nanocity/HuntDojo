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

require './lib/particle'

module Dojo

  class Hunter
    include Dojo::Particle

    def update( hunters, preys )
      prey = self.closest( preys ).first

      modulus = 1
      direction = self.angle_to( prey )

      accelerate( modulus , direction )
    end

  end

end
