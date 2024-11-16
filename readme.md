#### Electric Grid  
A work in progress, but should be reasonbly playable.
An overhaul of the electric network, engineer an Electric Grid.

See license.txt for credits to the developers and their work that came before.  
A special thanks to Stringweasel for his work on Fluidic Power, the inspiration.  

Important notes:
This is a work in progress, in the proof of concept stage, but believed to be reasonably playable.  
This mod should only be added to a new or early game, it significantly modifies the electric poles.  
Comments and suggestions welcome.  

May not be useful or functional on Fulgora (to be determined, possible future development).  
The wiring rules should still be valid. However, the use of transformators, maybe not so much.  

Adds:  
Transformators - [Ctrl] + [Left] to select the power rating (1MW to 10GW)  
Huge electric pole (lighted)  
Underground substations  

Removes:  
Power switch

Changes:  
Small poles are the new medium poles  
Medium, big and huge poles have no supply area, used for power transmission only  

New wiring rules:  
Small poles can connect to small and medium poles  
Medium poles can connect to small and medium poles  
Big poles can connect to big poles, substations and underground substations  
Huge poles can connect to huge poles  
Substations and underground substations can only connect to big poles  
Transformators can only connect to medium, big and huge poles  

Small poles and substations are for power distribution and collection  
Medium, big and huge poles are for power transmission only  

Transformators can be controlled via the circuit and/or logistic networks.  
Transformators do function as expected if connected in parallel.  
Very similair to [Electric Transformators](https://mods.factorio.com/mod/Electric_Transformators) but a little different.  
Do not place the transformator in the supply area of an electric pole.  

Objective:  
Build an electric network infrastructure that more closely follows the Factorio way:  
Build a main power grid using huge poles, to operate similar to a main bus.  
Transformators separate the high voltage main bus from low voltage distribution, think splitters.  
Medium, big and huge poles transmit power, function similar to that of belts.  
And small poles and substations function as the inserters.  
