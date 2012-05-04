require './lib/assets'

module Dojo
  module Particle

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
        :max_velocity => 0.0,
        :max_acceleration => 0.0,
        :acc_decrease => 0.0,
        :radius => 2.0,
        :enhance => ""
      }.merge( opts )

      @bounds = defaults[:bounds]
      @position = defaults[:position]
      @velocity = defaults[:velocity]
      @color = defaults[:color] 
      @max_velocity = defaults[:max_velocity]
      @max_acceleration = defaults[:max_acceleration]
      @acc_decrease = defaults[:acc_decrease]
      @radius = defaults[:radius]

      load_enhance( defaults[:enhance] )  
    end

    def accelerate( modulus, direction )
      # Convert direction from grades to radians
      direction = Math::PI * direction / 180

      acx = Math.cos( direction ) * modulus
      acy = Math.sin( direction ) * modulus

      @velocity[:x] += [ acx.abs, @max_acceleration ].min * ( acx <=> 0 )
      @velocity[:y] += [ acy.abs, @max_acceleration ].min * ( acy <=> 0 )

      @velocity[:x] = [ @velocity[:x].abs, @max_velocity ].min * ( @velocity[:x] <=> 0 )   
      @velocity[:y] = [ @velocity[:y].abs, @max_velocity ].min * ( @velocity[:y] <=> 0 )   
    end

    def move
      @velocity[:x] *= @acc_decrease
      @velocity[:y] *= @acc_decrease
      
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
         @position[:x] - @radius, @position[:y] - @radius, @color,
         @position[:x] + @radius, @position[:y] - @radius, @color,
         @position[:x] + @radius, @position[:y] + @radius, @color, 
         @position[:x] - @radius, @position[:y] + @radius, @color
      ] 
    end

    def update( hunters = [], preys=[] )
      raise NotImplementedError, "This method has to be implemented in child classes"
    end

    def eat( particles )
      particles.each do |p|
        particles.delete( p ) if self.distance_to( p ) < @radius
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
