#### Electric Grid  
An overhaul of the electric network, engineer an Electric Grid.  

See license.txt for credits to the developers and their work that came before.  
A special thanks to Stringweasel for his work on Fluidic Power, the inspiration.  

*Important notes:*
This mod should only be added to a new or early game, it significantly modifies the electric poles.  
If quick on/off via the circuit or logistic networks is not a priority, set "On tick interval" setting to 0 for near zero UPS impact.  
Comments and suggestions are welcome.  

May not be useful or functional on Fulgora (to be determined, possible future development).  
The wiring rules should still be valid. However, the use of transformators, maybe not so much.  

*Adds:*  
Transformator  
Huge electric pole  
Underground substation  

*Removes:*  
Power switch  

*Changes:*  
Small poles are the new medium poles  
Medium, big and huge poles have no supply area and are lighted  

*Wiring rules:*  
Small poles can connect to small and medium poles  
Medium poles can connect to small and medium poles  
Big poles can connect to big poles, substations, and underground substations  
Huge poles can only connect to huge poles  
Substations and underground substations can only connect to big poles  
Transformators can only connect to medium, big and huge poles  

Small poles and substations are for power distribution and collection  
Medium, big and huge poles are for power transmission only  
Substations and underground substations are fast-replaceable  

*Transformators can be controlled via the circuit and/or logistic networks.*  

Set the Fluid filter to special fluids to manually enable and disable.  
Selectable power rating (1MW to 10GW) 

Transformators do function as expected if connected in parallel.  
Very similair to [Electric Transformators](https://mods.factorio.com/mod/Electric_Transformators) but a little different.  
Do not place the transformator in the supply area of an electric pole.  

*Limitations:*
Underground substations do not place properly while dragging, use substations and fast-replace or upgrade planner.  
*Quality adds a supply area to poles intended to have zero supply area (medium, big and huge).*  
Hopefully future API development and/or my knowledge will allow for a better solution.  

*Recommended Mods:*
[No Quality](https://mods.factorio.com/mod/no-quality) - Removes Quality which resolves the issue with transmission only poles. 
[ConnectionBox](https://mods.factorio.com/mod/ConnectionBox) - For visible circuit wires in areas using underground substations. 

*Supported Mods:*
[AAI Industry](https://mods.factorio.com/mod/aai-industry) - Support for the small iron electric pole. 
