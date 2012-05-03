require './lib/assets'

module Dojo
  module Particle

    ACC_DECREASE = 0.9
    ACC_MAXIMUM = 1.0
    VEL_MAXIMUM = 5.0
    
    attr_reader :position
    attr_reader :velocity

    attr_reader :color
  
    def initialize( opts = {} )
      extend Assets 

      defaults = {
        :bounds => { :width => 10000, :height => 10000 },
        :position => { :x => 0, :y => 0 },
        :velocity => { :x => 0, :y => 0 },
        :color => 0xffffffff,
        :enhance => ""
      }.merge( opts )

      @bounds = defaults[:bounds]
      @position = defaults[:position]
      @velocity = defaults[:velocity]
      @color = defaults[:color] 

      load_enhance( defaults[:enhance] )  
    end

    def accelerate( modulus, direction )
      # Convert direction from grades to radians
      direction = Math::PI * direction / 180

      vx_offset = modulus * Math.cos( direction )
      vy_offset = modulus * Math.sin( direction )

      @velocity[:x] += ( vx_offset >= 0 ? [ vx_offset, ACC_MAXIMUM ].min : [ vx_offset, ACC_MAXIMUM * -1 ].max ) 
      @velocity[:y] += ( vy_offset >= 0 ? [ vy_offset, ACC_MAXIMUM ].min : [ vy_offset, ACC_MAXIMUM * -1 ].max ) 

      @velocity[:x] = ( @velocity[:x] >= 0 ? [ @velocity[:x], VEL_MAXIMUM ].min : [ @velocity[:x], VEL_MAXIMUM * -1 ].max )   
      @velocity[:y] = ( @velocity[:y] >= 0 ? [ @velocity[:y], VEL_MAXIMUM ].min : [ @velocity[:y], VEL_MAXIMUM * -1 ].max )   
    end

    def move
      @velocity[:x] *= ACC_DECREASE
      @velocity[:y] *= ACC_DECREASE
      
      # Move particle according to its velocity
      @position[:x] += @velocity[:x]
      @position[:y] += @velocity[:y]

      # Walls collisions
      if @position[:x] < 0 then
        @position[:x] = @position[:x].abs
        @velocity[:x] *= -1 
      end
      
      if @position[:y] < 0 then
        @position[:y] = @position[:y].abs
        @velocity[:y] *= -1 
      end

      if @position[:x] > @bounds[:width] then
        @position[:x] = @bounds[:width] - ( @position[:x] - @bounds[:width] )
        @velocity[:x] *= -1
      end
      
      if @position[:y] > @bounds[:height] then
        @position[:y] = @bounds[:height] - ( @position[:y] - @bounds[:height] )
        @velocity[:y] *= -1
      end
    end

    def corners
      [ 
         @position[:x] - 2, @position[:y] - 2, @color,
         @position[:x] + 2, @position[:y] - 2, @color,
         @position[:x] + 2, @position[:y] + 2, @color, 
         @position[:x] - 2, @position[:y] + 2, @color
      ] 
    end

    def update( hunters = [], preys=[] )
      raise NotImplementedError, "This method has to be implemented in child classes"
    end

    def eat( particles )
      particles.each do |p|
        particles.delete( p ) if self.distance_to( p ) < 2
      end
    end

    private

    def load_enhance( mod )
      if mod and !mod.empty? then
        Dir[ './enhances/*.rb' ].each { |file| require file }
        extend Object.const_get( mod )
      end
    end

  end

end
