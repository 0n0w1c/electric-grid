Electric Grid  
A Factorio 2.0 overhaul mod to bring more structure to the electric network.  
See the license.txt file for credits to the developers that came before me.  

This is a work in progress, still in the proof of concept stage, but believed to be reasonably playable.  

May not be useful or functional on Fulgora (to be determined, possible future development).  
I think the wiring rules should still be valid, however, the use of transformators, maybe not so much.  

Adds:  
Transformators (ctrl + left-click to select power rating)  
Huge electric pole (lighted)  
Underground substation  

Removes:  
Power switch  

Changes:  
Small poles are the new medium poles  
Medium, big and huge poles have no supply area, for tranmission only  

New wiring rules:  
Small poles can connect to small and medium poles  
Medium poles can connect to small and medium poles  
Big poles can connect to big poles, substations and undergound substations  
Huge poles can connect to huge poles  
Substations and underground substations can only connect to big poles  
Transformators can only connect to medium, big and huge poles  

Small poles and substations are for both power distribution and collection  
Medium, big and huge poles are for power distribution only  

Objective:  
Build an electric infrastructure that more closely resembles real world:
Build main power grid using huge poles, to operate similar to a main bus.  
Transformators separate the high voltage main bus from low voltage distribution, think splitters.  
Small poles and substations function as the belts and inserters.  
