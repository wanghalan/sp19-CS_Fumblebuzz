%Scale Bugs

%scale vs total bugs using errorthresh 5
% scale = [0.1 0.5 0.9 1 1.001 1.01 1.1 2 5 10 20 50 100 500 ];
% bugs = [52331 7013 62493 0 26359 60635 58567 62872 52602 4984 1670 1583 1579 1551];
% figure
% scale = [0.1 0.5 0.9 1 1.001 1.01 1.1 2 5];
% bugs = [52331 7013 62493 0 26359 60635 58567 62872 52602];
% plot(scale, bugs, '-o', 'LineWidth', 1.5)
% xlabel('Scale Factor', 'fontsize', 16)
% ylabel('Number of Total Bugs Found', 'fontsize', 16)
% title('Scale Factor vs Number of Bugs Found', 'fontsize', 16)

%Error threshold vs total bugs using 2x scale
% figure
% error = [0 0.5 1 5 10 20 50 100 500];
% bugs = [146196 140123 125821 62872 52486 39578 34206 31119 21134];
% plot(error, bugs, '-o', 'LineWidth', 1.5)
% xlabel('Error Threshold (in Units)', 'fontsize', 16)
% ylabel('Total Number of Bugs Found', 'fontsize', 16)
% title('Error Threshold vs Total Number of Bugs Found for Scale 2', 'fontsize', 16)

%Scale Bugs by Type
% figure
% labels = categorical({'Fcs', 'Emaxlv', 'Emaxrv', 'Psa', 'Pmaxlv', 'Rep', 'Pmaxrv', 'Rsp', 'Stop', 'Fes', 'T', 'Fev', 'Vuev', 'Vusv', 'Phi'})
% y = [4611 7439; 0 0; 0 0; 8363 8123; 8961 7327; 0 0; 7804 8777; 0 0; 0 0; 2192 8177; 0 0; 0 1895; 13318 10567; 13318 10567; 0 0]
% bar(labels, y)
% legend('Scale Factor 1.1', 'Scale Factor 2', 'fontsize', 16)
% xlabel('Output Variable', 'fontsize', 16)
% ylabel('Number of Bugs Found', 'fontsize', 16)
% title('Total Number of Bugs by Output Variable', 'fontsize', 16)


