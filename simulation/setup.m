% Configures and trims simulation
%
% Brian R Taylor
% brian.taylor@bolderflight.com
% 
% Copyright (c) 2021 Bolder Flight Systems
%

%% Cleanup
bdclose all;
close all;
clear all;
clc;

%% Configure
run('./config');

%% Add paths
addpath(genpath('aircraft'));
addpath(genpath('data'));
addpath(genpath('matlab'));
addpath(genpath('models'));
addpath(genpath('vms')); 

%% Specify root folders for autocode and cache
% clear all cached code
cacheBase = sprintf('../flight_code/build_%s', lower(vehicle));
cacheFolder = [cacheBase '/slprj'];
codeGenFolder = '../flight_code/autocode';
if exist(cacheBase, 'dir')
    rmdir(cacheBase, 's');
end
if exist(codeGenFolder, 'dir')
    rmdir(codeGenFolder, 's');
end
Simulink.fileGenControl('set', ...
    'CacheFolder', cacheFolder, ...
    'CodeGenFolder', codeGenFolder, ...
    'CodeGenFolderStructure', ...
    Simulink.filegen.CodeGenFolderStructure.ModelSpecific, ...
    'createDir', true);

%% Setup aircraft
run(strcat('./aircraft/', vehicle));

%% Setup FMU
%% Setup the flight management unit
if strcmpi(fmu_version, "MINI")
    Fmu.version = 4;
    Fmu.NUM_AIN = 8;
    frameRate_hz = 200;
    Telem.NUM_FLIGHT_PLAN_POINTS = 500;
    Telem.NUM_FENCE_POINTS = 100;
    Telem.NUM_RALLY_POINTS = 10;
    load('./data/fmu_mini_bus_all_sensors.mat');
else
    Fmu.version = 1;
    Fmu.NUM_AIN = 2;
    frameRate_hz = 50;
    Telem.NUM_FLIGHT_PLAN_POINTS = 100;
    Telem.NUM_FENCE_POINTS = 50;
    Telem.NUM_RALLY_POINTS = 10;
    load('./data/fmu_v1_bus_defs.mat');
end
framePeriod_s = 1/frameRate_hz;

%% Trim
% trim();

%% Create flight plan, fence, and rally point structs
% Flight plan
for i = 1:Telem.NUM_FLIGHT_PLAN_POINTS
    Telem.FlightPlan(i).autocontinue = boolean(0);
    Telem.FlightPlan(i).frame = uint8(0);
    Telem.FlightPlan(i).cmd = uint16(0);
    Telem.FlightPlan(i).param1 = single(0);
    Telem.FlightPlan(i).param2 = single(0);
    Telem.FlightPlan(i).param3 = single(0);
    Telem.FlightPlan(i).param4 = single(0);
    Telem.FlightPlan(i).x = int32(0);
    Telem.FlightPlan(i).y = int32(0);
    Telem.FlightPlan(i).z = single(0);
end
% Fence
for i = 1:Telem.NUM_FENCE_POINTS
    Telem.Fence(i).autocontinue = boolean(0);
    Telem.Fence(i).frame = uint8(0);
    Telem.Fence(i).cmd = uint16(0);
    Telem.Fence(i).param1 = single(0);
    Telem.Fence(i).param2 = single(0);
    Telem.Fence(i).param3 = single(0);
    Telem.Fence(i).param4 = single(0);
    Telem.Fence(i).x = int32(0);
    Telem.Fence(i).y = int32(0);
    Telem.Fence(i).z = single(0);
end
% Rally points
for i = 1:Telem.NUM_RALLY_POINTS
    Telem.Rally(i).autocontinue = boolean(0);
    Telem.Rally(i).frame = uint8(0);
    Telem.Rally(i).cmd = uint16(0);
    Telem.Rally(i).param1 = single(0);
    Telem.Rally(i).param2 = single(0);
    Telem.Rally(i).param3 = single(0);
    Telem.Rally(i).param4 = single(0);
    Telem.Rally(i).x = int32(0);
    Telem.Rally(i).y = int32(0);
    Telem.Rally(i).z = single(0);
end

%% Select sim
if (vms_only)
    if strcmp(vehicle,'lambu')
        lambu();

    elseif strcmp(vehicle,'torch')

        torch_pos_x_tuner(); % Change this
        

    end
else
    if any(strcmp(vehicle, {'super', 'malt', 'lambu'}))
        multirotor_sim();
    elseif any(strcmpi(vehicle, {'ale'}))
        ground_sim();
    elseif any(strcmpi(vehicle, {'session_v0'}))
        quadplane_sim();
    end
end
% double_integrator_sim();



%auto autocode
% vms_file = 'torch_pos_x_tuner';
% load_system(vms_file);
% cs = getActiveConfigSet(vms_file);
% set_param(cs, 'Toolchain', 'MinGW64 | gmake (64-bit Windows)'); % Adjust toolchain as needed
% set_param(vms_file, 'GenerateReport', 'off');
% set_param(vms_file, 'GenCodeOnly', 'on'); 
% slbuild(vms_file);


%% Cleanup
clear vehicle fh_vehicle op_point op_report op_spec opt i;
