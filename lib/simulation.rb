require 'gosu'
require './lib/hunter'
require './lib/prey'

module Dojo

  WINDOW_WIDTH = 800
  WINDOW_HEIGHT = 600

  PREYS = 100
  HUNTERS = 5

  class Simulation < Gosu::Window
    
    def initialize( opts = {} )
      super( WINDOW_WIDTH, WINDOW_HEIGHT, false )
     
      defaults = {
        :preys => "",
        :hunters => ""
      }.merge( opts )

      @preys = (1..PREYS).collect do
        Dojo::Prey.new( {
          :bounds => { :width => 800, :height => 600 },
          :position => { :x => Random.rand( 800 ), :y => Random.rand( 600 ) },
          :velocity => { :x => Random.rand( 5 ), :y => Random.rand( 5 )},
          :enhance => defaults[:preys]
        })
      end
      
      @hunters = (1..HUNTERS).collect do
        Dojo::Hunter.new( {
          :bounds => { :width => 800, :height => 600 },
          :position => { :x => Random.rand( 800 ), :y => Random.rand( 600 ) },
          :velocity => { :x => Random.rand( 5 ), :y => Random.rand( 5 )},
          :color => 0xffff0000,
          :enhance => defaults[:hunters]
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

      close if @preys.empty?
    end

    def draw
      (@hunters + @preys).each do |p|
        draw_quad( *p.corners )
      end
    end

  end

end
