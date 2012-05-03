module NotReallyAnImprovement
  
  def update( hunters, preys )
    hunter = self.closest( hunters ).first
    
    modulus = 1
    direction = self.angle_to( hunter )
    
    accelerate( modulus , -1 * direction )
  end

end
