#### Electric Grid  
An overhaul of the electric network, engineer an Electric Grid.  

See license.txt for credits to the developers and their work that came before.  
A special thanks to Stringweasel for his work on Fluidic Power, the inspiration.  

*Important notes:*
The electric network overhaul should only be added to a new or early game, it significantly modifies the electric poles.  
If quick on/off via the circuit or logistic networks is not a priority, set "On tick interval" setting to 0 for near zero UPS impact.  
Comments and suggestions are welcome.  

May not be useful or functional on Fulgora (to be determined, possible future development).  
The wiring rules should still be valid. However, the use of transformators, maybe not so much.  

*Adds:*  
Transformator  
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
Medium poles can connect to small and medium poles  
Big poles can connect to big poles, substations, underground substations, and circuit poles  
Huge poles can only connect to huge poles  
Substations and underground substations can only connect to big poles  
Circuit poles can connect to circuit poles and big electric poles  
Transformators can only connect to medium, big and huge poles  

Small poles and substations are for power distribution and collection  
Medium, big and huge poles are for power transmission only  
Substations and underground substations are fast-replaceable  
Circuit poles create copper wire connections for performance considerations, but are hidden

*If Space Age is active, the electric network overhaul requires either the No More Quality, Unquality or No Quality mods.*
*Startup setting to disable the electric network overhaul, effectively transformator only.*

*Transformators can be controlled via the circuit and/or logistic networks.*  

Set the Fluid filter to special fluids to manually enable and disable.  
Selectable power rating (1MW to 10GW) 

Transformators do function as expected if connected in parallel.  
Very similar to [Electric Transformators](https://mods.factorio.com/mod/Electric_Transformators) but a little different.  
Do not place the transformator in the supply area of an electric pole.  

*Limitations:*  
Transformator circuit conditions and copper wiring are not included in blueprints.  

*Known Issues:*  
Using the pipette [Q] always places a 1MW transformator.  
Quality adds a supply area to poles intended to have zero supply area (medium, big and huge).

*Recommended Mod:*  
[No More Quality](https://mods.factorio.com/mod/no-more-quality) - Hides the Quality mechanic, resolves the issue with transmission only poles.  

*Supported Mods:*  
[AAI Industry](https://mods.factorio.com/mod/aai-industry) - Support for the small iron electric pole  
[Cargo Ships](https://mods.factorio.com/mod/cargo-ships) - Support for the floating electric pole  
[No Quality](https://mods.factorio.com/mod/no-quality) - Support for enabling the electric network overhaul  
[Unquality](https://mods.factorio.com/mod/unquality) - Support for enabling the electric network overhaul  
