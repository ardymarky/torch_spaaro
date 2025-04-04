/*
* Brian R Taylor
* brian.taylor@bolderflight.com
* 
* Copyright (c) 2022 Bolder Flight Systems Inc
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the “Software”), to
* deal in the Software without restriction, including without limitation the
* rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
* sell copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
* IN THE SOFTWARE.
*/

#include "global_defs.h"
#include "flight/sensors.h"
#include "flight/msg.h"
#include "drivers/fmu.h"
#include "drivers/analog.h"
#if defined(__FMU_R_V2__) || defined(__FMU_R_MINI_V1__)
#include "drivers/power-module.h"
#endif
#include "drivers/spaaro-lis3mdl.h"
#include "drivers/spaaro-ams5915.h"
#include "drivers/spaaro-ublox.h"
#include "drivers/spaaro-ainstein-usd1.h"
#include "drivers/spaaro-sbus.h"
#include "drivers/spaaro-ercf.h"
#include "drivers/spaaro-tfmini.h"

namespace {
/* External mag */
SpaaroLis3mdl ext_mag;
/* External pressure transducer */
SpaaroAms5915 ext_pres1(&I2C_BUS);
SpaaroAms5915 ext_pres2(&I2C_BUS);
SpaaroAms5915 ext_pres3(&I2C_BUS);
SpaaroAms5915 ext_pres4(&I2C_BUS);
/* External GNSS receivers */
#if defined(__FMU_R_V1__)
SpaaroUbx ext_gnss1(&GNSS_UART);
#elif defined(__FMU_R_V2__) || defined(__FMU_R_V2_BETA__)
// SpaaroUbx ext_gnss1(&GNSS1_UART);
// SpaaroUbx ext_gnss2(&GNSS2_UART);
#elif defined(__FMU_R_MINI_V1__)
// SpaaroUbx ext_gnss1(&GNSS1_UART);
// SpaaroUbx ext_gnss2(&GNSS2_UART);

#endif
#if defined(__FMU_R_MINI_V1__)
SpaaroTFMini tfmini(&GNSS1_UART);
SpaaroTFMini tfmini2(&GNSS2_UART);
SpaaroERCF ercf(&AUX_UART);
// SpaaroAinsteinUsd1 rad_alt(&SBUS_UART);
#endif
SpaaroSbus incept(&SBUS_UART);
/* Sensor calibration */
elapsedMillis t_ms;
inline constexpr int32_t CAL_TIME_MS = 5000;
}  // namespace

void SensorsInit(const SensorConfig &cfg) {
  MsgInfo("Initializing sensors...");
  // incept.Init();
  FmuInit(cfg.fmu);
  ext_mag.Init(cfg.ext_mag);
  ext_pres1.Init(cfg.ext_pres1);
  ext_pres2.Init(cfg.ext_pres2);
  ext_pres3.Init(cfg.ext_pres3);
  ext_pres4.Init(cfg.ext_pres4);
  #if defined(__FMU_R_V2__) || defined(__FMU_R_V2_BETA__) || \
        defined(__FMU_R_MINI_V1__)
  // ext_gnss1.Init(cfg.ext_gnss1);
  // ext_gnss2.Init(cfg.ext_gnss2);
  // rad_alt.Init(cfg.rad_alt);
  tfmini.Init(cfg.tfmini);
  tfmini2.Init(cfg.tfmini2);
  ercf.Init(cfg.ercf);
  #endif
  #if defined(__FMU_R_V2__) || defined(__FMU_R_MINI_V1__)
  PowerModuleInit(cfg.power_module);
  #endif
  MsgInfo("done.\n");
}

void SensorsCal() {
  MsgInfo("Calibrating sensors...");
  t_ms = 0;
  while (t_ms < CAL_TIME_MS) {
    FmuCal();
    ext_pres1.Cal();
    ext_pres2.Cal();
    ext_pres3.Cal();
    ext_pres4.Cal();
  }
  MsgInfo("done.\n");
}

void SensorsRead(SensorData * const data) {
  if (!data) {return;}
  // incept.Read(&data->inceptor);
  FmuRead(&data->fmu_imu, &data->fmu_mag, &data->fmu_static_pres);
  AnalogRead(&data->analog);
  
  ext_mag.Read(&data->ext_mag);
  ext_pres1.Read(&data->ext_pres1);
  ext_pres2.Read(&data->ext_pres2);
  ext_pres3.Read(&data->ext_pres3);
  ext_pres4.Read(&data->ext_pres4);
  
  #if defined(__FMU_R_V1__)
  ext_gnss1.Read(&data->ext_gnss1);
  #elif defined(__FMU_R_V2__) || defined(__FMU_R_V2_BETA__) || \
        defined(__FMU_R_MINI_V1__)
  // ext_gnss1.Read(&data->ext_gnss1);
  // ext_gnss2.Read(&data->ext_gnss2);

  data->ext_gnss1.fix = 3;
  data->ext_gnss1.num_sats = 10;
  data->ext_gnss1.lat_rad = 0.0f;
  data->ext_gnss1.lon_rad = 0.0f;
  data->ext_gnss1.alt_wgs84_m = 0.0f;
  
  tfmini.Read(&data->tfmini);
  tfmini2.Read(&data->tfmini2);
  ercf.Read(&data->ercf);
  #endif
  #if defined(__FMU_R_V2__) || defined(__FMU_R_MINI_V1__)
  PowerModuleRead(&data->power_module);
  #endif
}
