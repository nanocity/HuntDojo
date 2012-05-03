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
