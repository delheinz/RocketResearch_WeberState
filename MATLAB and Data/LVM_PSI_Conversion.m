file = ManualTesting600SLM830PSI71620245;
time = file(:,1);
supply_pressure = file(:,2)*110;
second_transducer = file(:,3)*110;
massflow = file(:,4)*200;
temp = file(:,5);
outputvolt=file(:,6)*100;
%temp_file = DataFileTempCBAM;
%secondfile = DataFileThrustWoodenNozzleFirstTest;  
%time_1 = secondfile(:,1);
%temp = resample(temp_file(:,2),3420, 4320);
%temp = temp_file(:,2);
%final = [time(:), supply_pressure(:), chamber_pressure(:), massflow(:), thrust(:),temp(:)];
figure; plot(time,massflow,time,supply_pressure,time,second_transducer,time,outputvolt);
%%
figure;plot(massflow)
[x1,y1] = ginput;
[x2,y2] = ginput;
extracteddata_out=massflow(x1:x2);
extracteddata_in=outputvolt(x1:x2);
figure;plot(extracteddata_out)
%%
figure;plot(outputvolt)
%writematrix(final,'DataFile_CBAM_042024.xlsx')
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
mass=unnamed(:,1);
cross =unnamed(:,2);
figure;plot(mass,cross)