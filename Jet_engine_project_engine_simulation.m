% Specify the video file path
%videoFile = 'C:\Matlab\engine_animation.mp4';
writerObj = VideoWriter(videoFile, 'MPEG-4');
% Specify the video file path (change to a directory where you have write permissions)
videoFile = 'D:\My Drive\Matlab\engine_animation.mp4'; % Change this path

% Constants and Parameters (Replace with Wren 75 data)
throttle_setting = 0.5; % Throttle setting (0 to 1)
engine_rpm = 20000; % Initial engine RPM (replace with realistic initial value)
propeller_diameter = 0.2; % Propeller diameter in meters
air_density = 1.225; % Air density in kg/m^3 (standard conditions)
ambient_temperature = 298.15; % Ambient temperature in Kelvin (25°C)

% Engine Performance Data (Replace with Wren 75 data)
engine_rpm_data = [10000, 15000, 20000, 25000]; % RPM
thrust_data = [10, 15, 18, 20]; % Thrust in Newtons

% Fuel Parameters (Replace with Wren 75 data)
fuel_density = 800; % Fuel density in kg/m^3
fuel_flow_rate = 0.02; % Initial fuel flow rate in kg/s

% Time parameters
t_start = 0;
t_end = 600; % Simulation time in seconds
dt = 0.01; % Time step

% Initialize arrays to store simulation data
time = t_start:dt:t_end;
engine_speed = zeros(size(time));
thrust = zeros(size(time));
fuel_consumption = zeros(size(time));
temperature = zeros(size(time));

% Create a VideoWriter object for animation
open(writerObj);

% Set the figure size explicitly to match a frame size that's a multiple of 2
figure('Position', [0, 0, 1892, 976]);

% Initialize variables for SFC and fuel consumption per rotation
sfc = zeros(size(time));
fuel_per_rotation = zeros(size(time));

% Initialize a flag to check if 1 minute has passed
one_minute_passed = false;

% Simulation loop
for i = 1:length(time)
    % Calculate engine RPM based on throttle setting using a non-linear equation
    engine_rpm = calculateEngineRPM(throttle_setting, engine_rpm);
    
    % Lookup thrust from engine RPM data (you should have real data here)
    current_thrust = interp1(engine_rpm_data, thrust_data, engine_rpm, 'linear', 'extrap');
    
    % Calculate fuel consumption based on a non-linear model (replace with actual calculation)
    current_fuel = calculateFuelConsumption(engine_rpm, throttle_setting);
    
    % Update fuel flow rate based on consumption
    fuel_flow_rate = current_fuel;
    
    % Store data for plotting
    engine_speed(i) = engine_rpm;
    thrust(i) = current_thrust;
    fuel_consumption(i) = current_fuel;
    temperature(i) = ambient_temperature; % Temperature rise not considered here
    
    % Calculate Specific Fuel Consumption (SFC) at this time step
    sfc(i) = current_fuel / current_thrust * 3600; % kg/N/hr
    
    % Calculate fuel consumption per rotation
    if i > 1
        engine_speed_diff = engine_speed(i) - engine_speed(i-1);
        fuel_per_rotation(i) = fuel_per_rotation(i-1) + (current_fuel * engine_speed_diff * dt);
    else
        engine_speed_diff = 0; % Set to 0 for the first step
        fuel_per_rotation(i) = 0;
    end
    
    % Capture the current frame for animation
    frame = getframe(gcf);
    writeVideo(writerObj, frame);
    
    % Add this line to display the animation during simulation
    drawnow;
    
    % Pause briefly for animation smoothness (adjust as needed)
    pause(0.01);
    
    % Check if 1 minute (60 seconds) has elapsed
    if time(i) >= 60
        one_minute_passed = true;
    end
    
    % Break out of the loop if more than 1 minute has passed
    if one_minute_passed && time(i) >= 61
        break;
    end
    
end

% Close the video writer after the animation is complete
close(writerObj);

% Display the final graphs after 1 minute
figure;
subplot(6, 1, 1);
plot(time, engine_speed);
title('Engine RPM vs. Time');
xlabel('Time (s)');
ylabel('Engine RPM');

subplot(6, 1, 2);
plot(time, thrust);
title('Thrust vs. Time');
xlabel('Time (s)');
ylabel('Thrust (N)');

subplot(6, 1, 3);
plot(time, fuel_consumption);
title('Fuel Consumption vs. Time');
xlabel('Time (s)');
ylabel('Fuel Consumption (kg/s)');

subplot(6, 1, 4);
plot(time, temperature);
title('Engine Temperature vs. Time');
xlabel('Time (s)');
ylabel('Temperature (K)');

subplot(6, 1, 5);
plot(time, sfc);
title('Specific Fuel Consumption (SFC) vs. Time');
xlabel('Time (s)');
ylabel('SFC (kg/N/hr)');

subplot(6, 1, 6);
plot(time, fuel_per_rotation);
title('Fuel Consumption per Engine Rotation');
xlabel('Time (s)');
ylabel('Fuel Consumption per Rotation (kg)');

% Non-linear engine RPM calculation based on throttle setting
function engine_rpm = calculateEngineRPM(throttle_setting, current_rpm)
    % Replace with a non-linear RPM calculation
    % based on Wren 75 engine data and physics.
    % Example placeholder: engine_rpm = current_rpm + (throttle_setting * 100);
    engine_rpm = current_rpm + (throttle_setting * 100); % A simplified example
end

% Non-linear fuel consumption calculation based on engine RPM and throttle setting
function current_fuel = calculateFuelConsumption(engine_rpm, throttle_setting)
    % Replace with a non-linear fuel consumption calculation
    % based on Wren 75 engine data and physics.
    % Example placeholder: current_fuel = throttle_setting * engine_rpm * 0.0001;
    current_fuel = throttle_setting * engine_rpm * 0.0001; % A simplified example
end
