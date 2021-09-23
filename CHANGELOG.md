# Changelog

## v2.3.1
- Updated for new build tools install locations. Updated the telemetry serial port in the default config to work with FMU-R v1.

## v2.3.0
- Support added for FMU v2.1

## v2.2.0
- Updated the tools and libs for the Teensy 4.1
- Updated cmake to support upper and lowercase definitions of the "v2-beta" / "V2-Beta" board

## v2.1.0
- Adding support for the FMU-R-V2-Beta board. Use 'cmake .. -DFMU=V2-BETA' to enable.

## v2.0.7
- Adding trim control surface / motor positions in effector dynamics block and subtracing trim pitch / roll angles in navigation filter block. This enables the control laws to work transient free in simulation without effecting flight code.

## v2.0.6
- Added data logging in Simulink to model the flight data logs
- Added unit delays where necessary to break algebraic loops

## v2.0.5
- Cleaning up Simulation base workspace.

## v2.0.4
- Added units to global_defs.h to make it easy to access unit conversions anywhere.

## v2.0.3
- Updated to mavlink v3.1.2, which will re-request mission items that are received out of order, making the transfer much more robust
- Fixed bugs in sending inceptor and effector telemetry data

## v2.0.2
- Updated to sbus v4.0.5, pwm v4.0.4, and effector v6.1.3, which add a check for whether an effector channel has been configured
- Added a check for whether the receiver is in failsafe mode, if it is, then the effector will output the motor and servo failsafe commands

## v2.0.1
- Updated sbus to v4.0.4
- Updated inceptor to v2.2.0

## v2.0.0
- Revamped to use interfaces for IMU, GNSS, pressure, inceptor, and effector
- Added data output
- Implemented much more comprehensive MAV Link implementation
- Updated Simulink / Autocode and pulled into source to keep in sync with flight code better
- Pulled mat converter intp source to keep in sync with flight code better

## v1.1.0
- Added definition (HAVE_PITOT_STATIC) in *hardware_defs.h* to defined whether the aircraft has a pitot-static system or not

## v1.0.8
- Updated to Datalog and global_defs variable names

## v1.0.7
- Added BME280 FMU integrated static pressure sensor

## v1.0.6
- Decreased datalog buffer size to avoid running out of memory

## v1.0.5
- Updated *statistics* library to v2.0.0

## v1.0.4
- Added flight control system and node schematics

## v1.0.3
- Updated version numbers for dependencies

## v1.0.2
- Updated README to provide information about the project
- Added CONTRIBUTING
- Modified *fetch_content* links to use https instead of ssh for public access
- Updated flash_mcu.cmake to use local teensy_loader rather than system for Linux

## v1.0.1
- Updated license to MIT.
- Used git tags on dependencies.

## v1.0.0
- Initial baseline
