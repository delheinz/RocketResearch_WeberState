file = SyncTest41920247;
time = file(:,1);
supply_pressure = file(:,5)*72.5;
chamber_pressure = file(:,6)*100;
massflow = (file(:,7)*62430)-243.6;
thrust_file = DatafileThrustCBAM;
%temp_file = DataFileTempCBAM;
%secondfile = DataFileThrustWoodenNozzleFirstTest;  
%time_1 = secondfile(:,1);
thrust = (resample(thrust_file(:,2),4380, 6083)-12.5)*30;
%temp = resample(temp_file(:,2),3420, 4320);
%temp = temp_file(:,2);
%final = [time(:), supply_pressure(:), chamber_pressure(:), massflow(:), thrust(:),temp(:)];
figure; plot(time,supply_pressure,time,chamber_pressure,time, massflow,time,thrust)
%writematrix(final,'DataFile_CBAM_042024.xlsx')
%figure;plot(time(7000:9420,1), supply_pressure(7000:9420,1), time(7000:9420,1), chamber_pressure(7000:9420,1), time(7000:9420,1), massflow(7000:9420,1),time(7000:9420,1), thrust(7000:9420,1))
%figure; 
%plot(time, supply_pressure,time, chamber_pressure,time, (massflow*62430)-243.6, time, thrust)
% 175910, 3400 for psi collection
%% breaks sections, I can run specific sections
second_file = DataFilePSICBAMNozzle;    
figure; plot(t,second_file)
%%
file = SequenceVoltTestSineWave;
time = file(:,1);
supply_pressure = file(:,2)*100;
chamber_pressure = file(:,3)*72.5;
massflow = (file(:,4)*62430)-243.6;
massflow2 = file(:,3);
thrust = file(:,5);
temperature = file(:,6);
volt = file(:,7)*10;
final = [time(:), supply_pressure(:), chamber_pressure(:), massflow(:), thrust(:)];
%writematrix(final, 'Graphite_CBAM_5_16_2024_5.28 PM.xlsx')
figure;plot(time,volt,time, massflow)
%%
file = SequenceVoltTest2SecDelay51820244;
A = zeros(1,107040);
n = -50:20;
K = transpose(A);
for j = 1:107040
   K(j+36773-33199) = K(j) + 18;
end
time = file(:,1);
begin = find(time==4.58192);
ending = find(time==54.6);
supply_pressure = file(:,2)*100;
chamber_pressure = file(:,3)*72.5;
volumetricflow = (file(:,4)*62430)-248.6;
volflow_meterperhour = volumetricflow*60/1000;
massflow2 = file(:,3);
thrust = file(:,5);
temperature = file(:,6);
volt = file(:,7)*10;
degree = file(:,7)*18;
%final = [time(:), supply_pressure(:), chamber_pressure(:), massflow(:), thrust(:)];
%writematrix(final, 'Graphite_CBAM_5_16_2024_5.28 PM.xlsx')
%figure;plot(time,supply_pressure,time,volt,time, massflow)
figure;plot(time(begin:ending,1),volt(begin:ending,1),time(begin:ending,1),volflow_meterperhour(begin:ending,1),time(begin:ending,1),degree(begin:ending,1),time,volumetricflow)
%%
file = StepInputTest61520243;
time = file(:,1);
chamber_pressure = file(:,2)*72.5;
chamber_pressure=chamber_pressure(2455:12666);
massflow = file(:,3);
massflow = massflow(2455:19738)*200;
volts = file(:,4);
volts=volts(2455:19738);
%chamberClean=chamber_pressure(1:8556);
%sampletime=time(1:8556);
%thrust = file(:,5);
%tt=timetable(chamber_pressure,'RowTimes',minutes(0.000560/60*(1:size(time,1))));
%head(tt,2)
%datatest = iddata(tt,[],0.000560);
%np=2;

%sys = tfest(tt);
%tfest()
figure;
hold on
plot(chamber_pressure,'r')
hold on
plot(volts,'b')
hold on
plot(massflow,'g')

