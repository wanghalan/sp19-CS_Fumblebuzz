READ ME
HSP Model Fuzzer code by Josephine Lamp

Folder Description:
  Original Model Files
    -Control.m --> generates control params and GUI
    -HspInit.m --> generates original data params and GUI
    -Control.mat, hspinit.mat, hsp_control.mat, hsp_data.mat --> data files used by model
  Model
    -Hsp.mdl --> Simulink model of heart and circulatory system
  Fuzzer
    -fuzzer_hsp.m --> fuzzer for HSP model
  Reference Papers
    -Folder contents --> medical literature reference papers
  Graphs
    -Folder contents --> experimental graphs and pictures

To Run:
  1. Open the Hsp.mdl Model by double clicking on it and starting Simulink
  2. Open the fuzzer (fuzzer_hsp.m).
  3. Set Fuzzing parameters. Key things to set are (starting on Line 35):
      nExperiments = 1; --> number of experiments
      scaleFactor = 1; --> scale factor
      errorThreshold = 5; --> error threshold for scale factor
      contractility = 0;%1=True --> contractility property to check
      resistance = 0;%1=True --> resistance property to check
      unstressed = 0;%1=True --> unstressed blood vol property to check
  4. Run model by compiling and running the fuzzer. The number of bugs for each of the sections will be printed in the console.
      Actual data Output is put in the output folder with the name outi, i being the iteration number.
      You can also open the data log viewer in Simulink to view the output parameter signals.
