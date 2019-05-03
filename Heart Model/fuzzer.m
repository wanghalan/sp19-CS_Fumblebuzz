%https://www.youtube.com/watch?v=L_-iY99-ePQ
%https://www.mathworks.com/help/simulink/ug/using-the-sim-command.html
%Accessing data: https://www.mathworks.com/matlabcentral/answers/384492-how-to-access-scope-data-when-running-model-with-sim-command

Cf_Sweep= linspace(0,30,5);
Cf_Sweep2= linspace(0,30,5);
numExperiments= length(Cf_Sweep);

Cf_Sweep= Cf_Sweep(randperm(length(Cf_Sweep)));
Cf_Sweep2= Cf_Sweep2(randperm(length(Cf_Sweep2)));

%data=[];
for i= numExperiments:-1:1
    in(i)=Simulink.SimulationInput('NPNwithVVI'); %name of project
    in(i)=in(i).setBlockParameter('NPNwithVVI/NodeLongERP1/Rest_def','Value',num2str(Cf_Sweep(i)));
    %in(i)=in(i).setBlockParameter('NPNwithVVI.slx/NodeLongERP1/ERP_def','MaskValues',{num2str(Cf_Sweep2(i))});
    
    %This below doesn't get information out during run time
    %test= get_param('NPNwithVVI/NodeLongERP1/Rest_def','Value');
    %disp(test);
    %save_system('NPNwithVVI');    
end

out= parsim(in);

NodeLongERP = out(1).logsout{1}.Values;
NodeLongERP1 = out(1).logsout{2}.Values;

%NodeLongERP.data

% variable1 = ( beats in interval / interval length )
% convert variable1 to beats/minute

%for i=out
%  i.logsout
%end

%Simulink.sdi.view;

