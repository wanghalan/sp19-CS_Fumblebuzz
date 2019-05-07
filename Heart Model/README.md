# 190409_Fumblebuzz

### Simulink Heart Model
---
#Folder Description
---
	- references --> [CPS course reference material](https://linklab-uva.github.io/modeling_cps/)
	- NPNwithVVI.slx --> Heart model with pace maker attached to the VA node
	- a2vsense.m --> Matlab code that identifies when there is too much delay between Asense and Vsense
	- brachy-tachy.m --> Matlab code that calculates the heart rate using a sliding window and identifies when the heart rate is too high or too low
	- rhythmHijack.m --> Matlab code that extracts VA signal and VPace signals and outputs them to CSVs
	- rhythmHijack/
		- signal_checker.py --> extracts csvs in a folder and then generates graphs for single runs or for combined runs, exporting the calculated rhythm hijack signals, va and vpace signals into a json format
		- default.json --> fuzzing with normal ranges result
		- 20.json --> fuzzing with +-20% ranges result
		- 100.json --> fuzzing with +-100% ranges result

#To Run:
---
	- Rhythm hijack code:
		1. Double click and open NPNwithVVI.slx
		2. Open rhythmHijack.m
		3. Choose to comment whichever section you want, labeled normal, 20%, and 100% in the code
		4. Move the exported CSV into "rhythm_hijack/"
		5. Run "python signal_checker.py", changing the output identifier on line 122
	- Heartrate detection:
		1. Open the NPNwithVVI.slx in Simulink
                2. Run the script brachy-tachy.m in Matlab
                3. The variable graph can be set to 0 for no graphs and 1 for graphs
	- AtoV detection:
		1. Open the NPNwithVVI.slx in Simulink
                2. Run the script a2vsense.m in Matlab
                3. The variable graph can be set to 0 for no graphs and 1 for graphs
