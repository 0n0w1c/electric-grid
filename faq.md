#### The Why, what does the overhaul of the electric network accomplish?  
The wiring rules are not a challenge per se, but they intentionally modify how the electric poles connect.  
And a significant reason is to limit the number of manual wire disconnections.  
Attempting to build with isolated electric networks, using vanilla wiring, can be [insert word].  
The wiring rules will not prevent electric network short-circuits, but they will help.  


#### About existing blueprints?  
Why I tagged this mod as an Overhaul, the power distribution portion will likely need to be modified.  


#### What is this high voltage and low voltage nonsense?  
Just an attempt to be thematic, it is equally correct to refer to them as: input/output, source/target, production/consumption, etc.  


#### How to connect a power source to the high voltage network?  
Power always flows through a transformator from the high voltage pole to the low voltage pole. A power source is always the "highest voltage".  
This is true, even if the power source you are connecting produces less power than what already exists on the high voltage electric network.  


#### In modding terms, what is a Transformator?  
A transformator is a composite entity, comprised of the following seven base entities:
   * An identity unit, provides the visual representation
   * Two electric poles, providing the electric and circuit network connections
   * An infinity pipe, providing an infinite fluid source
   * A pump, allows the manual, circuit, and logistics enable and disable functions
   * An electric boiler, consumes power from the high voltage power pole to produce a heated fluid
   * A steam engine, which produces power from the heated fluid and provides power to the low voltage network


#### What is the effect on performance?  
A tough question, but let me try.  
This mod will add some load... it must, it adds both code and entities.  

There are two primary areas... the code that runs when events occur (ex. you place an entity) and the code that runs on-tick.  
As much code as possible is assigned to events, minimizing the on-tick code.  
The code that runs when events take place should have little impact, I doubt it can be noticed in normal game play.  
Usually the greater concern is the code that runs on-tick, this code runs at quick intervals throughout the game session.  
This mod uses the on-tick to watch for when the transformators are enabled/disabled via the circuit and logistics networks.  
If the startup setting for the on-tick interval is set to 0, there will be no continuous on-tick code executed.  

So adding a transformator is the same as adding the seven entities. Quick enable/disable adds more.  
I have tested 100 transformators in operation with the on tick interval set to 1, it was not too much on my computer (M2 Mac Mini) and the performance profile was pretty good. Could you build with over 500 transformators? Uh, maybe, maybe not.  I could probably make code adjustments to split the workload. Please contact me if you do run into performance issues. I would want a save to test with, if possible, I am not a megabase engineer.  


#### Why is there on-tick code?  
The transformator's boiler and steam engine have an energy buffer and this buffer scales with the rating. When a transformator is disabled, this buffer will continue to supply power until it is depleted. This can take some time depending on the rating chosen and power consumption. A fully buffered 10 GW transformator with nothing more than an inserter as the consumer, will take a very long time to deplete the buffer. The on-tick code flushes the buffers, so the power-off takes effect quickly.  
The on-tick code is optional, if you are not interested in quick power-off, it can be disabled in the startup settings. 

#### Why can't transformators be placed on Fulgora?  
On Fulgora, the buffers of the internal components act as an over-powered accumulator. In the spirit of intended game-play, they do not belong there.  
