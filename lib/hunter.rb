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
