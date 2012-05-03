# HuntDojo

A programming practical exercise to be run as a Dojo.

It is based on Daniel Phelps [code](http://www.libgosu.org/cgi-bin/mwf/topic_show.pl?tid=272) 
using Ruby and Gosu library.

The game consists on a few hunters trying to devour a lot of preys.

Those creatures, hunters and preys, are represented by dots on a window. At
first, preys only move randomly across the screen and hunters chase the 
closest prey; being the target of the dojo to programm smarter classes that 
make preys to live more time or hunters to eat all preys faster. Hunters
eat the preys if the move close enough to each other.

The creatures behavior is controlled by a method called `update`. That
is the method we should overwrite to make our preys or hunters more clever.
In `update` method we can check for our position, distance to other
creatures, etc; and we can set an acceleration from our actual position
letting preys escape for hunters or hunter to chase preys.

In addition to hunter and preys classes, we can add 'utils' or 'helpers' 
methods that can be used by creatures later, so we could program a method
that calculates how close we are to a wall or the direction that we should 
take to escape from hunters.

Where to program the behavior and how to apply it is discussed in next section.

# Usage

## Adding helper methods

We can add new helper methods in `lib/assets.rb` file like these:

    module Assets

      def distance_to( particle )
        Math.sqrt( 
          (self.position[:x] - particle.position[:x]) ** 2 + 
          (self.position[:y] - particle.position[:y]) ** 2 
        )
      end

      def distance_to_closest_wall()
        ...
      end

    end

Any method defined in `lib/assets.rb` is available for preys and hunters 
classes.

## Redefining the creature behavior

First, we have to choose one type of creature, preys or hunters (just to know
what we want to achieve). Once we know what improvement are we going to program,
we create a new file under `enhances/` directory (the name is not important as 
it ends in '.rb').

Next step is to create a new module inside the file, named as we want, and inside
that module we overwrite the method `update( hunters, preys )`. For example, if
we choose preys to enhance their behavior we can do this:

    module NotReallyAnImprovement
      
      def update( hunters, preys )
        hunter = self.closest( hunters ).first
      
        modulus = 1
        direction = self.angle_to( hunter )
      
        accelerate( modulus , -1 * direction )
      end

    end

That make our preys accelerate in opposite direction of closest hunter as fast 
as they can. So, if we want to try this behavior we do the following:

    ruby main.rb --preys NotReallyAnImprovement 

This command loads the game using our recently created module to modify the 
preys behavior. We could use the short option `-p` to do the same, or use
`--hunters` or `-h` to change the hunters behavior.

Sadly, once we run the game, we see that this code is not a good example of 
improvement as it make the preys life shorter but it illustrates well how 
the creatures behavior is modified.

# TODO

Things to accomplish to be functional

* Hunters collisions
* Successives simulation in order to calculate average lifetime
* Avoid infite loops by setting maximum lifetime for hunters if they don't eat
* Put some informational text on the screen

# Advice

    Every morning in Africa, a Gazelle wakes up and knows that it must
    run faster than the fastest Lion that day, or it will be killed and eaten.
    Every morning in Africa, a Lion wakes up and knows that it must run
    faster than the slowest Gazelle that day, or it will starve to death. It
    doesn't matter if you are a lion or a gazelle: when the sun comes up,
    you'd better be running.
