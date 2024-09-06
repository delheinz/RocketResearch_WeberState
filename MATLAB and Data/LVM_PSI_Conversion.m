file = PIDControlTest72520245;
time = file(:,1);
supply_pressure = file(:,2)*110;
second_pressure = file(:,3)*110;
chamber_pressure = file(:,4)*110;
vol_flow = file(:,5)*200;
thrust = file(:,6);
temp = file(:,7);
outputvolt=file(:,8);
%temp_file = DataFileTempCBAM;
%secondfile = DataFileThrustWoodenNozzleFirstTest;  
%time_1 = secondfile(:,1);
%temp = resample(temp_file(:,2),3420, 4320);
%temp = temp_file(:,2);
slope=(100-20)/(5.067-1.0134);
figure; plot(vol_flow);
[x1,y1] = ginput;
[x2,y2] = ginput;
time1=time(x1:x2);
supply_pressure1=supply_pressure(x1:x2);
chamber_pressure1=chamber_pressure(x1:x2);
second_pressure1=second_pressure(x1:x2);
vol_flow1=vol_flow(x1:x2);
%vol_flow1=((-1*log(1 - vol_flow(x1:x2)/780))*0.265)+0.295;
temp1=temp(x1:x2);
outputvolt1=outputvolt(x1:x2);
%%
figure;plot(time1,chamber_pressure1,'Color',[0 0 1])
hold on
plot(time1, second_pressure1)
hold on
plot(time1,second_pressure1-chamber_pressure1)
%%
file2= Filterthrust;
thrust = file2(:,1);
thrust1=thrust(x1:x2);
figure;plot(thrust1)
%%
% conversion to mass flow ....

kelvin = (temp1-32)/1.8 + 273.15;
lpm = (vol_flow1 .* (kelvin/273.15));
factor = 14.504 ./ supply_pressure1;
lpm1=lpm .* factor;
lpm1=lpm1 * 1/(60*1000);
density=supply_pressure1*6894.76*32/8314.344;
frac_kel= 1 ./kelvin;
new_dens=density .* frac_kel;
mass_flow = new_dens .* lpm1;
figure;plot(mass_flow)
%#write to excel
%final = [time1(:), supply_pressure1(:),second_transducer1(:), chamber_pressure1(:), vol_flow1(:), thrust1(:),temp1(:),outputvolt1(:)];
%writematrix(final,'PIDControlTest_07_25_2024.xlsx')
%%
figure;plot(mass_flow)
%%
time2 = linspace(0,(25636-1)*0.000560,25636);
time2 = transpose(time2);
a=0*ones(1271,1);
setpoint=14*ones(25636-1271,1);
calc=[a;setpoint];
%%
figure;
p2=plot(time2,calc,'LineWidth',1,'Color',[0 0 0],'LineStyle','--');
hold on;
yyaxis left
ylabel('Mass Flow Rate [g/s]')
bx=gca;
bx.YColor = [0 0 1];
p1 = plot(time2,mass_flow*1000,'LineWidth',1.8,'Color',[0 0 1]);
xlabel('Time [s]')
title('Process Variables vs Time')

hold on;
yyaxis right
p3=plot(time2,chamber_pressure1,'LineWidth',1.5,'Color',[1 0 0]);
ylabel('Chamber Pressure [PSI]','Color',[1 0 0])
ax = gca;
ax.YColor = [1 0 0];


legend([p2,p1,p3],{'Set-point',"Mass Flow m_x","Chamber Pressure P_C"})
%%
figure;p4=plot(time2,thrust1-12.5,'LineWidth',1,'Color',[0.4660 0.6740 0.1880],'LineStyle','-');
legend(p4,"Thrust F")
xlabel('Time [s]')
ylabel('Thrust [lb]')


%%
hold on;
p2 = plot(time1,outputvolt1*255,'LineWidth',1.5,'Color',[1 0 0]);
legend([p2,p1],{'Chamber Pressure P_C','Volumetric Flow SLM'})

%%
figure; plot(time1,vol_flow1,time1,second_pressure1);
%figure;plot(time1,chamber_pressure1,time1,outputvolt1*50)
%%
(log(1-599/780)*.265)+0.295
%%
data1 = tdmsread("checkingtime.tdms");
%%
figure;plot(massflow)
[x1,y1] = ginput;
[x2,y2] = ginput;
extracteddata_out=massflow(x1:x2);
extracteddata_in=outputvolt(x1:x2);
figure;plot(extracteddata_out)
%%
figure;plot(outputvolt)
%figure;plot(time(7000:9420,1), supply_pressure(7000:9420,1), time(7000:9420,1), chamber_pressure(7000:9420,1), time(7000:9420,1), massflow(7000:9420,1),time(7000:9420,1), thrust(7000:9420,1))
%figure; 
%plot(time, supply_pressure,time, chamber_pressure,time, (massflow*62430)-243.6, time, thrust)
% 175910, 3400 for psi collection
%%
figure;plot(time,supply_pressure,time,massflow)
%% Data Analysis of Multiple Sets
file = ValveCurve62320246;
input15 = StepInput15; 
input18 = StepInput18;
input19 = StepInput19;
input20 = StepInput20;
input25 = StepInputHalfMax;
input50 = StepInputMax;
file2 = ValveCurveCloseToOpen62320247;
p=100;
col=3;
flow_15 = input15(:,col)*p;
flow_18 = input18(:,col)*p;
flow_19 = input19(:,col)*p;
flow_20 = input20(:,col)*p;
flow_25 = input25(:,col)*p;
flow_50 = input50(:,col)*p;
vol_flow_Seq = file2(:,col)*p;
%%
time1=input50(:,1);
impact=input50(:,6);
response=input50(:,3)*100;
figure;plot(impact,'r')
[x1,y1] = ginput;
[x2,y2] = ginput;
time2=time(x1:x2);
impactresp = response(x1:x2);
figure;
plot(time2,impactresp)
%% Plotting multiple sets
hold on
plot(flow_18,'g')
[x3,y3] = ginput;
[x4,y4] = ginput;
hold on
plot(flow_19,'black')
[x5,y5] = ginput;
[x6,y6] = ginput;
hold on
plot(flow_20,'b')
[x7,y7] = ginput;
[x8,y8] = ginput;
hold on
plot(flow_25,'magenta')
[x9,y9] = ginput;
[x10,y10] = ginput;
plot(flow_50,'cyan')
[x11,y11] = ginput;
[x12,y12] = ginput;
plot(vol_flow_Seq)
[x13,y13] = ginput;
[x14,y14] = ginput;

figure;plot(flow_15(x1:x2),'r')
hold on
plot(flow_18(x3:x4),'g')
hold on
plot(flow_19(x5:x6),'black')
hold on
plot(flow_20(x7:x8),'b')
hold on
plot(flow_25(x9:x10),'magenta')
hold on
plot(flow_50(x11:x12),'cyan')

hold on
plot(vol_flow_Seq(x13:x14))
legend('27','32.4','34.2','36','45','90')
%%
figure;plot(MVT_2,volt_input(x15:x16))
%% Data Analysis of unique dataset
file2 = ValveCurveCloseToOpen62320247Copy;
vol_flow=file2(:,5)*200;
volt_input=file2(:,6);
figure;plot(vol_flow)
[x15,y15]=ginput;
[x16,y16]=ginput;
slope=(100-20)/(5.067-1.0134);
MVT_2=volt_input(x15:x16)*slope/100;
output_flow=vol_flow(x15:x16);
figure;
plot(MVT_2,output_flow)
%[x17,y17]=ginput;
%% Trying to use computational tools to find the best fit, work in progress
initialParam = [0.3665,0.1,2890];
options = optimoptions('lsqcurvefit','Display','iter');
[fitparams,resnorm] = lsqcurvefit(@ExponentialFit,initialParam,MVT_2,output_pressure,[],[],options);
disp('Fitted Param: ');
disp(fitparams);
figure;plot(MVT_2,output_pressure)
hold on
xFit = linspace(min(MVT_2),max(MVT_2),100);
yFit = ExponentialFit(fitparams,xFit);
plot(xFit,yFit)
%% #####################################################
% Use this to play with Curve Fit Parameters
initialParam = [0.315,0.195,35000];
yaxis = ExponentialFit(initialParam,MVT_2); %Specify what you want as the independent variable in the second parameter
B=find(yaxis>0.5); % Will find all the indexes where output is greater than 0.5
figure;plot(MVT_2(B),yaxis(B)/36,'black') %Plots all the values based on the index condition
hold on
plot(MVT_2,output_flow)
%% Trying to interpolate data into the model curve. Work in progress.
xaxis = output_pressure;
x_unique=unique(xaxis);
yaxis = ExponentialFit([0.3665,0.1,2700],x_unique);
xi=0:0.01:1;
yi = interp1(x_unique,yaxis,xi,'spline');
figure;
plot(xi,yi/36)
%%
file = ChamberPressureRig30PSI81920248;
%file2=firlteredthrustStepInput;
time = file(:,1);
supply_pressure = file(:,2)*110;
chamber_pressure = file(:,3)*110;
vol_flow = file(:,4)*200;
temp = file(:,5);
outputvolt=file(:,6);
%temp_file = DataFileTempCBAM;
%secondfile = DataFileThrustWoodenNozzleFirstTest;  
%time_1 = secondfile(:,1);
%temp = resample(temp_file(:,2),3420, 4320);
%temp = temp_file(:,2);
slope=(100-20)/(5.067-1.0134);
figure; plot(chamber_pressure);
[x1,y1] = ginput;
[x2,y2] = ginput;
time1=time(x1:x2);
supply_pressure1=supply_pressure(x1:x2);
chamber_pressure1=chamber_pressure(x1:x2);
vol_flow1=vol_flow(x1:x2);
%vol_flow1=((-1*log(1 - vol_flow(x1:x2)/780))*0.265)+0.295;
temp1=temp(x1:x2);
outputvolt1=outputvolt(x1:x2);
%#write to excel
%final = [time1(:), supply_pressure1(:),second_transducer1(:), chamber_pressure1(:), vol_flow1(:), thrust1(:),temp1(:),outputvolt1(:)];
%writematrix(final,'PIDControlTest_07_25_2024.xlsx')
%%
figure;
p1 = plot(time1,chamber_pressure1,'LineWidth',1.8,'Color',[0 0 1]);
xlabel('Time [s]')
title('Open-Loop Test')


yyaxis left
ylabel('Chamber Pressure [PSI]')

yyaxis right
ylabel('Thrust [lb]')
hold on;
p2=plot(time1,outputvolt1+0.5,'LineWidth',1,'Color',[1 0 0],'LineStyle','--');
ax = gca;
ax.YColor = [0.4660 0.6740 0.1880];
hold on;
p3=plot(time1,thrust1-12,'Color',[0.4660 0.6740 0.1880],'LineStyle','-','LineWidth',1.8);

legend([p1,p2,p3],{"P_C","Commanded V_o","Thrust F"})

