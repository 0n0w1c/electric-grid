#### The Why, what does the Overhaul of the electric network accomplish?  
The wiring rules aren’t meant to be restrictive, but intentionally guide how electric poles connect.  
A key goal is to reduce the need for manual wire disconnections.  
Building isolated electric networks using vanilla wiring can be tedious and error-prone.  
While these rules won't entirely prevent electric network short-circuits, they make them less likely.  


#### A mini How-to?  
When playing with the Overhaul active, a basic goal might be to design a network of huge electric poles.
This network, which is to span the factory, can be considered the electric network main bus.  
Connect a power source (nuclear, steam or solar power facility) to a Transformator's high voltage pole.  
Ideally, the Transformator rating is set to be a little lower than the maximum power of the source.  
Then connect the Transformator's low voltage pole, supplying the main bus. The main bus, is then considered *high voltage*.  

Transformators are then placed, splitting-off power from the main bus by connecting a huge pole to the Transformator's high voltage pole.  
The huge electric poles also work to electrically separate the electric networks of the city blocks.  
Then connect the Transformator's low voltage pole to a network of medium or big electric poles in each city block or factory.  
Ideally, the Transformator(s) rating should be a little higher than maximum consumption, splitting-off only as much as needed.  

Finally, connect the medium or big power poles to a network of small electric poles or substations, distributing power to your builds.  
Ultimately it is the player's vision and goals for how to use the Transformators, with or without the Overhaul active.  
Do keep in mind that Transformators work as expected when connected in serial or parallel.  


#### About existing blueprints?  
Why I tagged this mod as an Overhaul, the power distribution portion will likely need to be modified.  


#### What is this high voltage and low voltage nonsense?  
Just an attempt to be thematic, it is equally correct to refer to them as: input/output, source/target, production/consumption, etc.  


#### What are the four different selectable sections of the Transformator?  
The two on either end are electric poles, to which you connect copper wires, but not across them. Circuit wires can cross.  
There are two middle sections. The pump, which connects the Transformator to the circuit and/or logistics network, or can be disabled.  
The final section allows you change the electrical rating, how much electricity is allowed to pass through, from pole to pole.  
This is also the section to right-click and hold to pickup the Transformator.


#### How to connect a power source to the high voltage network?  
Power always flows through a Transformator from the high voltage pole to the low voltage pole. A power source is always the "highest voltage".  
This is true, even if the power source you are connecting produces less power than what already exists on the high voltage electric network.  


#### How to connect a Transformator to a circuit network?  
While the electric poles of the Transformator will carry circuit signals as any electric pole, they do *not* connect the Transformator to the circuit network.  
To connect the Transformator, a circuit wire must be connected the internal pump, which is located near the yellow plug.  


#### In modding terms, what is a Transformator?  
A Transformator is a composite entity, comprised of the following seven base entities:
   * An identity unit, provides the visual representation
   * Two electric poles, providing the electric and circuit network connections
   * An infinity pipe, providing an infinite fluid source
   * A pump, allows the manual, circuit, and logistics enable and disable functions
   * An electric boiler, consumes power from the high voltage power pole to produce a heated fluid
   * A steam engine, which produces power from the heated fluid and provides power to the low voltage network


#### What is the effect on performance?  
A tough question, but let me try.  
This mod will add some load... it must, it adds both code and entities.  

There are two primary areas... the code that runs when events occur (ex. you place an entity) and the code that runs on_nth_tick.  
As much code as possible is assigned to events, minimizing the on_nth_tick code.  
The code that runs when events take place should have little impact, I doubt it can be noticed in normal game play.  
Usually the greater concern is the code that runs on_nth_tick, this code runs at quick intervals throughout the game session.  
This mod uses the on_nth_tick to watch for when the Transformators are enabled/disabled via the circuit and logistics networks.  

So adding a Transformator is the same as adding the seven entities. Quick enable/disable adds more.  
I have tested 100 Transformators in operation with the on tick interval set to 1, it was not too much on my computer (M1 Mac Mini) and the performance profile was pretty good. Could you build with over 500 Transformators? Uh, maybe, maybe not.  I could probably make code adjustments to split the workload. Please contact me if you do run into performance issues. I would want a save to test with, if possible, I am not a megabase engineer.  


#### Why is there on_nth_tick code?  
The Transformator's boiler and steam engine have an energy buffer and this buffer scales with the rating. When a Transformator is disabled, this buffer will continue to supply power until it is depleted. This can take some time depending on the rating chosen and power consumption. A fully buffered 10 GW Transformator with nothing more than an inserter as the consumer, will take a very long time to deplete the buffer. The on_nth_tick code flushes the buffers, so the power-off takes effect quickly.   
When the underground substations are placed, the on_nth_tick is used to replace the displayer entity with the actual underground substation. This allows the underground substation to the placed via pole dragging, like other electric poles.  

#### Why can't Transformators be placed on Fulgora?  
On Fulgora, the buffers of the internal components act as an over-powered accumulator. In the spirit of intended game-play, they do not belong there.  
