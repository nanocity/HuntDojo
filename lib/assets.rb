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

module Assets

  def distance_to( particle )
    Math.sqrt(
      (self.position[:x] - particle.position[:x]) ** 2 +
      (self.position[:y] - particle.position[:y]) ** 2
    )
  end

  def angle_to( particle )
    rad = Math.atan2(
      particle.position[:y] - self.position[:y],
      particle.position[:x] - self.position[:x]
    )

    # Convert to grades
    rad * 180 / Math::PI
  end

  def closest( particles )
    min_dist = particles.collect do |p|
      self.distance_to( p )
    end.min

    particles.select do |p|
      self.distance_to( p ) == min_dist
    end
  end

end
