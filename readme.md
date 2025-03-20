#### Electric Grid  
An overhaul of the electric network, engineer an Electric Grid.  

See license.txt for credits to the developers and their work that came before.  
A special thanks to Stringweasel for his work on Fluidic Power, the inspiration.  

*The [FAQ](https://mods.factorio.com/mod/electric-grid/faq) contains helpful tips and "too much information".*  

*Important notes:*  
The electric network overhaul should only be added to a new or early game, it significantly modifies the electric poles.  
If quick on/off via the circuit or logistic networks is not a priority, set "On tick interval" setting to 0 for near zero UPS impact.  
Comments and suggestions are welcome.  

*Adds:*  
Transformator  
Small iron electric pole  
Huge electric pole  
Underground substation  
Circuit pole  

*Removes:*  
Power switch  

*Changes:*  
Small poles are the new medium poles  
Medium, big, huge and circuit poles have no supply area and optional lights  

*Wiring rules:*  
Small poles can connect to small and medium poles  
Medium poles can connect to small, medium and big poles  
Big poles can connect to medium and big poles, substations, underground substations and circuit poles  
Huge poles can only connect to huge poles  
Substations and underground substations can only connect to big poles  
Circuit poles can connect to circuit poles and big electric poles  
Transformators can only connect to medium, big and huge poles  

Small poles and substations are for power distribution and collection  
Medium, big and huge poles are for power transmission only  
Substations and underground substations are fast-replaceable  
Circuit poles create copper wire connections for performance considerations, but they are hidden  

Startup setting to disable the electric network overhaul, effectively transformator only.  
Startup settings to modify electric poles, they only take effect if the overhaul is active.  

*Transformators can be controlled via the circuit and/or logistic networks.*  

Set the Fluid filter to special fluids to manually enable and disable.  
Selectable power rating (1MW to 10GW)  

No quality bonus is applied to transformators, placing a higher quality will result in normal quality.  

Transformators do function as expected if connected in parallel.  
Very similar to [Electric Transformators](https://mods.factorio.com/mod/Electric_Transformators) but a little different.  
*Do not place the transformator in the supply area of an electric pole.*  

*Fulgora*
Disrupted by the heavy planetary magnetic field and extreme electrical storms, transformators can not be placed.  
Wiring rules are relaxed, permitting copper wire connections between any of the transmission only poles.  

*Limitations:*  
Transformator circuit conditions and copper wiring are not included in blueprints.  

*Helpful Mods:* 
[Wire Tools](https://mods.factorio.com/mod/WireTools)  - Isolates selected poles into a separate electric network  
[Electric Grid Enforcer](https://mods.factorio.com/mod/noangledcables) - Enforce 90 degree wire angles, as poles are placed  
[Rewire Tool v2](https://mods.factorio.com/mod/rewire-tool-v2) - Enforce 90 degree wire angles, after placement  

*Supported Mods:*  
[AAI Industry](https://mods.factorio.com/mod/aai-industry) - Support for the small iron electric pole  
[Cargo Ships](https://mods.factorio.com/mod/cargo-ships) - Support for the oil-rig pole and floating electric pole  
[James' Electric Trains Plus](https://mods.factorio.com/mod/James-Train-Mod) - Support for electric rails (connect to medium poles)  
[Factorio+](https://mods.factorio.com/mod/factorioplus) - Support for electric poles and electrical distributor  
[Power Overload](https://mods.factorio.com/mod/PowerOverload) - Support for the mechanics and poles  
