%https://www.youtube.com/watch?v=L_-iY99-ePQ
%https://www.mathworks.com/help/simulink/ug/using-the-sim-command.html
%Accessing data: https://www.mathworks.com/matlabcentral/answers/384492-how-to-access-scope-data-when-running-model-with-sim-command
simulation_time = 10000;
numExperiments = 10;

ERP_Sweep= linspace(250,460,numExperiments);
Tcond_Sweep= linspace(120,200,numExperiments);
RRP_Sweep= linspace(50,100,numExperiments);
Rest_Sweep= linspace(280,340,numExperiments);

Rest_Sweep= Rest_Sweep(randperm(length(Rest_Sweep)));
ERP_Sweep= ERP_Sweep(randperm(length(ERP_Sweep)));
Tcond_Sweep= Tcond_Sweep(randperm(length(Tcond_Sweep)));
RRP_Sweep= RRP_Sweep(randperm(length(RRP_Sweep)));

for i= numExperiments:-1:1
    in(i)=Simulink.SimulationInput('NPNwithVVI_2018a'); %name of project
    in(i)=in(i).setBlockParameter('NPNwithVVI_2018a/NodeLongERP1/Rest_def','Value',num2str(Rest_Sweep(i)));
    in(i)=in(i).setBlockParameter('NPNwithVVI_2018a/NodeLongERP1/ERP_def','Value',num2str(ERP_Sweep(i)));
    in(i)=in(i).setBlockParameter('NPNwithVVI_2018a/AtoV Path/Tcond_def','Value',num2str(Tcond_Sweep(i)));
    in(i)=in(i).setBlockParameter('NPNwithVVI_2018a/NodeLongERP1/RRP_def','Value',num2str(RRP_Sweep(i)));

end

out= parsim(in);

% A2V delay
a2v = zeros(numExperiments, simulation_time);
count = 0;
graph =1;
maxdelta = 0; 
mindelta = 2000;

for i=1: numExperiments
    Vnode = out(i).logsout{1}.Values.Data;
    SAnode = out(i).logsout{2}.Values.Data;

    index = 1;
    cur_s = 1;
    cur_v = 1;

    while index < simulation_time

        cur_flag = 0;

        if SAnode(index) == 1
            cur_s = index;
        end

        if Vnode(index) == 1 && index > cur_s && cur_s ~= 0
            cur_v = index;

            delta = cur_v - cur_s;

            if delta > 200 || delta < 50
                cur_flag = 1;
                cur_s=0;
                count = count+1;
            else
                cur_s = 0;
                cur_v = 0;
            end
            a2v(i, index) = delta;
        end


        index = index + 1;


    end

end

count

maxdelta

mindelta

if graph
    figure(1)
    hold on

    for i=1:numExperiments
    plot(1:simulation_time, a2v(i,:), 'o', 'DisplayName', ['experiment ' num2str(i)]);
    end
    legend('show');
    plot(1:simulation_time, ones(1, simulation_time)*50, '--r', 'DisplayName', 'Lower Bound');
    plot(1:simulation_time, ones(1, simulation_time)*200, '--r', 'DisplayName', 'Lower Bound');

    axis([0, simulation_time, 10,350]);
    xlabel('Simulation time');
    ylabel('Violation');
    title(['Violations of A2V Delay']);
    drawnow;
end

legend('show');
axis([0, simulation_time, -0.2,1.2]);
xlabel('Simulation time');
ylabel('Violation');
title(['Violations of A2V Delay']);
drawnow;

%Simulink.sdi.view;
