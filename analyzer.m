clc;
clear;
close all;

fund_consts;
device_params



%Eg =(0.01:0.1:5)*q;
Eg = 1.42*q;




RowLength = length(Eg);
ColumnLength = 1;

DeviceEfficiency = zeros(RowLength,ColumnLength);
Voc = zeros(RowLength,ColumnLength);
Jsc = zeros(RowLength,ColumnLength);
FF = zeros(RowLength,ColumnLength);
Vop = zeros(RowLength,ColumnLength);
Jop = zeros(RowLength,ColumnLength);
ExternalPLQE = zeros(RowLength,ColumnLength);
InternalPLQE = zeros(RowLength,ColumnLength);
Nonradiative_loss = zeros(RowLength,ColumnLength);
Mirror_loss = zeros(RowLength,ColumnLength);
Radiative_escape = zeros(RowLength,ColumnLength);
B = zeros(RowLength,ColumnLength);
n = zeros(RowLength,ColumnLength);
p = zeros(RowLength,ColumnLength);
%Pin = zeros(RowLength,ColumnLength);


for i =1:RowLength
    i
    
    [DeviceEfficiency(i),Voc(i),Jsc(i),FF(i),Vop(i),Jop(i)]...
    = PV_JV(Eg(i));
   
end




set(0, 'DefaultAxesFontSize',16)
set(0, 'defaultfigurecolor',[1 1 1]);
MyGridWidth = 1.2;
MyLineWidth = 1.5;

figure
plot(Eg/q,DeviceEfficiency*100,'--ob','LineWidth',MyLineWidth,'MarkerFaceColor','b');
%hold on
%plot(Ts,etaexpFTIRcorrected*100,'or','LineWidth',MyLineWidth,'MarkerFaceColor','r');
xlabel('BandGap (eV)')
ylabel('Solar cell efficiency (%)')
grid on
set(gca,'LineWidth',MyGridWidth)


