%https://www.youtube.com/watch?v=L_-iY99-ePQ
%https://www.mathworks.com/help/simulink/ug/using-the-sim-command.html
%Accessing data: https://www.mathworks.com/matlabcentral/answers/384492-how-to-access-scope-data-when-running-model-with-sim-command

clear

numExperiments = 5;

%1000-(460+200+100) = 340
%600-(250+120+50) = 280
ERP_Sweep= linspace(250,460,numExperiments);
Tcond_Sweep= linspace(120,200,numExperiments);
RRP_Sweep= linspace(50,100,numExperiments);
Rest_Sweep= linspace(280,340,numExperiments);

Rest_Sweep= Rest_Sweep(randperm(length(Rest_Sweep)));
ERP_Sweep= ERP_Sweep(randperm(length(ERP_Sweep)));
Tcond_Sweep= Tcond_Sweep(randperm(length(Tcond_Sweep)));
RRP_Sweep= RRP_Sweep(randperm(length(RRP_Sweep)));

for i= numExperiments:-1:1
    in(i)=Simulink.SimulationInput('NPNwithVVI'); %name of project
    in(i)=in(i).setBlockParameter('NPNwithVVI/NodeLongERP1/Rest_def','Value',num2str(Rest_Sweep(i)));
    in(i)=in(i).setBlockParameter('NPNwithVVI/NodeLongERP1/ERP_def','Value',num2str(ERP_Sweep(i)));
    in(i)=in(i).setBlockParameter('NPNwithVVI/AtoV Path/Tcond_def','Value',num2str(Tcond_Sweep(i)));
    in(i)=in(i).setBlockParameter('NPNwithVVI/NodeLongERP1/RRP_def','Value',num2str(RRP_Sweep(i)));
end

out= parsim(in);

%5 colors map
map = [
0 1 0;
0 0.5 0;
0 0 1;
0 0 0.5;
1 1 0;
0.5 0.5 0;
1 0 1;
0.5 0 0.5;
0 1 1;
0 0.5 0.5;
];
set(groot,'defaultAxesColorOrder',map);
lower_bound = 50;
upper_bound = 100;
graph = 1; %1 to produce graphs, 0 to not produce graphs
for simulation=1:numExperiments
  NodeLongERP = out(simulation).logsout{1}.Values.data; % VA
  NodeLongERP1 = out(simulation).logsout{2}.Values.data; % SA

  bpmSA = [];
  bpmVA = [];
  avg_bpmVA = (nnz(NodeLongERP)/2)/length(NodeLongERP)*(60000);
  avg_bpmSA = (nnz(NodeLongERP1)/2)/length(NodeLongERP1)*(60000);
  interval = 2*1000; %1 second = 1000 ms
  step = interval/4;
  for i = 1:step:length(NodeLongERP)-interval
    beats = nnz(NodeLongERP(i:i+interval))/2;
    bpm_temp = beats/interval*(60000);
    bpmVA = [bpmVA bpm_temp];
    beats = nnz(NodeLongERP1(i:i+interval))/2;
    bpm_temp = beats/interval*(60000);
    bpmSA = [bpmSA bpm_temp];
  end

  if avg_bpmVA < lower_bound || avg_bpmSA < lower_bound
    display([num2str(i),' Critical Failure: Average heartbeat too low'])
  elseif avg_bpmVA > upper_bound || avg_bpmSA > upper_bound
    display([num2str(i),' Critical Failure: Average heartbeat too high'])
  elseif nnz(bpmVA<lower_bound) > 0 || nnz(bpmSA<lower_bound) > 0
    display([num2str(i),' Warning: heartrate temporarily too low'])
  elseif nnz(bpmVA>upper_bound) > 0 || nnz(bpmSA>upper_bound) > 0
    display([num2str(i),' Warning: heartrate temporarily too high'])
  end

  if graph ~= 0 && simulation <= 5 %No more than 5 graphs just in case
    if simulation ~= 1
      figure();
    end
    hold on
    plot(1:length(bpmVA),bpmVA,'-')
    plot([1 length(bpmVA)],[avg_bpmVA avg_bpmVA],'--')
    plot(1:length(bpmSA),bpmSA,'-')
    plot([1 length(bpmSA)],[avg_bpmSA avg_bpmSA],'--')

    plot([1 length(bpmVA)],[lower_bound lower_bound],'-r')
    plot([1 length(bpmVA)],[upper_bound upper_bound],'-r')
    axis([0 length(bpmVA)+2 lower_bound-10 upper_bound+10]);
    hold off
  end
end

%Simulink.sdi.view;

