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

require 'gosu'
require './lib/hunter'
require './lib/prey'

module Dojo

  WINDOW_WIDTH = 800
  WINDOW_HEIGHT = 600

  PREYS = 100
  HUNTERS = 5

  P_MAX_ACCEL = 0.8
  P_MAX_VEL = 3

  H_MAX_ACCEL = 0.8
  H_MAX_VEL = 4
  RADIUS = 4

  ACC_DECREASE = 0.9


  class Simulation < Gosu::Window
    
    def initialize( opts = {} )
      super( WINDOW_WIDTH, WINDOW_HEIGHT, false )
     
      defaults = {
        :preys => "",
        :hunters => ""
      }.merge( opts )

      @preys = (1..PREYS).collect do
        Dojo::Prey.new( {
          :bounds => { :width => WINDOW_WIDTH, :height => WINDOW_HEIGHT },
          :position => { :x => Random.rand( WINDOW_WIDTH ), :y => Random.rand( WINDOW_HEIGHT ) },
          :velocity => { :x => Random.rand( P_MAX_VEL ), :y => Random.rand( P_MAX_VEL )},
          :enhance => defaults[:preys],
          :max_velocity => P_MAX_VEL,
          :max_acceleration => P_MAX_ACCEL,
          :acc_decrease => ACC_DECREASE
        })
      end
      
      @hunters = (1..HUNTERS).collect do
        Dojo::Hunter.new( {
          :bounds => { :width =>WINDOW_WIDTH, :height => WINDOW_HEIGHT },
          :position => { :x => Random.rand( WINDOW_WIDTH ), :y => Random.rand( WINDOW_HEIGHT ) },
          :velocity => { :x => Random.rand( H_MAX_VEL ), :y => Random.rand( H_MAX_VEL )},
          :color => 0xffff0000,
          :enhance => defaults[:hunters],
          :max_velocity => H_MAX_VEL,
          :max_acceleration => H_MAX_ACCEL,
          :acc_decrease => ACC_DECREASE,
          :radius => RADIUS
        })
      end

    end

    def update
      (@hunters + @preys).each do |p|
        p.update( @hunters, @preys )
        p.move
      end

      @hunters.each do |h|
        h.eat @preys
      end

      (0..HUNTERS-1).each do |i|
        (i+1..HUNTERS-1).each do |j|
          collision( @hunters[i], @hunters[j] )
        end
      end

      close if @preys.empty?
    end

    def draw
      (@hunters + @preys).each do |p|
        draw_quad( *p.corners )
      end
    end

    def collision(p1, p2)
      return if p1.distance_to( p2 ) > 2 * RADIUS 

      # This math is from http://www.plasmaphysics.org.uk/programs/coll2d_cpp.htm
      # hunters bounce off one another
      x21 = p2.position[:x] - p1.position[:x]
      y21 = p2.position[:y] - p1.position[:y]
      
      vx21 = p2.velocity[:x] - p1.velocity[:x]
      vy21 = p2.velocity[:y] - p1.velocity[:y]
      
      # return if balls are not approaching
      return if vx21*x21 + vy21*y21 >= 0
      
      a = y21 / x21
      dvx2 = -(vx21 + a*vy21)/(1 + a*a)
      advx2 = a*dvx2

      p2.velocity[:x] += dvx2 * 10
      p2.velocity[:y] += advx2 * 10
      
      p1.velocity[:x] -= dvx2 * 10
      p1.velocity[:y] -= advx2 * 10
    end
  end
end
