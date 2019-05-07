%https://www.youtube.com/watch?v=L_-iY99-ePQ
%https://www.mathworks.com/help/simulink/ug/using-the-sim-command.html
%Accessing data: https://www.mathworks.com/matlabcentral/answers/384492-how-to-access-scope-data-when-running-model-with-sim-command

clear

numExperiments = 100;

%normal values
% ERP_Sweep= linspace(250,460,numExperiments);
% Tcond_Sweep= linspace(120,200,numExperiments);
% RRP_Sweep= linspace(50,100,numExperiments);
% Rest_Sweep= linspace(280,340,numExperiments);
% LRI_Sweep= linspace(1100,1300, numExperiments);

%20 % range increase
ERP_Sweep= linspace(250-42,460+42,numExperiments);
Tcond_Sweep= linspace(120-16,200+16,numExperiments);
RRP_Sweep= linspace(50-10,100+10,numExperiments);
Rest_Sweep= linspace(280-12,340+12,numExperiments);
LRI_Sweep= linspace(1100-40,1300+40, numExperiments);

% %100 % range increase
% ERP_Sweep= linspace(250-210,460+210,numExperiments);
% Tcond_Sweep= linspace(120-80,200+80,numExperiments);
% RRP_Sweep= linspace(50-50,100+50,numExperiments);
% Rest_Sweep= linspace(280-60,340+60,numExperiments);
% LRI_Sweep= linspace(1100-200,1300+200, numExperiments);

Rest_Sweep= Rest_Sweep(randperm(length(Rest_Sweep)));
ERP_Sweep= ERP_Sweep(randperm(length(ERP_Sweep)));
Tcond_Sweep= Tcond_Sweep(randperm(length(Tcond_Sweep)));
RRP_Sweep= RRP_Sweep(randperm(length(RRP_Sweep)));
LRI_Sweep= LRI_Sweep(randperm(length(LRI_Sweep)));

for i= numExperiments:-1:1
    in(i)=Simulink.SimulationInput('NPNwithVVI'); %name of project
    in(i)=in(i).setBlockParameter('NPNwithVVI/NodeLongERP1/Rest_def','Value',num2str(Rest_Sweep(i)));
    in(i)=in(i).setBlockParameter('NPNwithVVI/NodeLongERP1/ERP_def','Value',num2str(ERP_Sweep(i)));
    in(i)=in(i).setBlockParameter('NPNwithVVI/AtoV Path/Tcond_def','Value',num2str(Tcond_Sweep(i)));
    in(i)=in(i).setBlockParameter('NPNwithVVI/NodeLongERP1/RRP_def','Value',num2str(RRP_Sweep(i)));
    in(i)=in(i).setBlockParameter('NPNwithVVI/LRI_def','Value',num2str(LRI_Sweep(i)));    
end

out= parsim(in);

for simulation=1:numExperiments
    SA_series = out(simulation).logsout{1}.Values.data; % VA
    VA_series = out(simulation).logsout{2}.Values.data;
    VPace_series = out(simulation).logsout{3}.Values.data; 
    
    %csvwrite(strcat(num2str(simulation),'_SA.csv'), SA_series);
    csvwrite(strcat(num2str(simulation),'_VA.csv'), VA_series);
    csvwrite(strcat(num2str(simulation),'_VP.csv'), VPace_series);
end
%jsonencode(SA_series);

%One can tell if a rhythm hijack has occured, if between two VPace signals,
%there are more than on SA signal. A signal is a contiguous set of 1s, and
%the space is the zero in between.


%So 1) is to get the windows between VA pulses, and 2)is to get the number
%of signals between each pulse, and 3) is to calculate the number of
%contiguous pulses within each window



