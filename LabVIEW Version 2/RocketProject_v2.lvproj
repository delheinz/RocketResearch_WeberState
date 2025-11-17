<?xml version='1.0' encoding='UTF-8'?>
<Project Type="Project" LVVersion="25008000">
	<Property Name="NI.LV.All.SaveVersion" Type="Str">25.0</Property>
	<Property Name="NI.LV.All.SourceOnly" Type="Bool">true</Property>
	<Item Name="My Computer" Type="My Computer">
		<Property Name="server.app.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.control.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.tcp.enabled" Type="Bool">false</Property>
		<Property Name="server.tcp.port" Type="Int">0</Property>
		<Property Name="server.tcp.serviceName" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.tcp.serviceName.default" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.vi.callsEnabled" Type="Bool">true</Property>
		<Property Name="server.vi.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="specify.custom.address" Type="Bool">false</Property>
		<Item Name="Data Collection" Type="Folder">
			<Item Name="NI 9237_Config.vi" Type="VI" URL="../NI 9237_Config.vi"/>
			<Item Name="NI_9210_Config.vi" Type="VI" URL="../NI_9210_Config.vi"/>
			<Item Name="NI_9219_Config.vi" Type="VI" URL="../NI_9219_Config.vi"/>
			<Item Name="NI_9252_Config.vi" Type="VI" URL="../NI_9252_Config.vi"/>
		</Item>
		<Item Name="Module Operation" Type="Folder">
			<Item Name="Command_AnalogOutput_v2.vi" Type="VI" URL="../Command_AnalogOutput_v2.vi"/>
			<Item Name="NI9210_TemperatureInputs_v2.vi" Type="VI" URL="../NI9210_TemperatureInputs_v2.vi"/>
			<Item Name="NI9237_ForceInputs_v2.vi" Type="VI" URL="../NI9237_ForceInputs_v2.vi"/>
			<Item Name="NI9252_AnalogInputWaveforms_v2.vi" Type="VI" URL="../NI9252_AnalogInputWaveforms_v2.vi"/>
		</Item>
		<Item Name="Rocket Operation" Type="Folder">
			<Item Name="MainVI.vi" Type="VI" URL="../MainVI.vi"/>
		</Item>
		<Item Name="Toolboxes" Type="Folder">
			<Item Name="Logging_2.vi" Type="VI" URL="../../../Rocket Research/1. Rocket Research Project/LabView/Logging_2.vi"/>
			<Item Name="MassFlowRate_ExpFactor.vi" Type="VI" URL="../MassFlowRate_ExpFactor.vi"/>
			<Item Name="Rename_signals.vi" Type="VI" URL="../Rename_signals.vi"/>
			<Item Name="Signal Routing.vi" Type="VI" URL="../../../Rocket Research/1. Rocket Research Project/LabView/Signal Routing.vi"/>
			<Item Name="Volumetric Flow Rate Calculation.vi" Type="VI" URL="../Volumetric Flow Rate Calculation.vi"/>
		</Item>
		<Item Name="PID_auto.vi" Type="VI" URL="../PID_auto.vi"/>
		<Item Name="Dependencies" Type="Dependencies"/>
		<Item Name="Build Specifications" Type="Build"/>
	</Item>
</Project>
