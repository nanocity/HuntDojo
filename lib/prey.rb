require './lib/particle'

module Dojo
  
  class Prey
    include Dojo::Particle
  
    def update( hunters, preys )

      modulus = Random.rand( 5 )
      direction = Random.rand( 360 )

      accelerate( modulus, direction )
    end

  end

end
