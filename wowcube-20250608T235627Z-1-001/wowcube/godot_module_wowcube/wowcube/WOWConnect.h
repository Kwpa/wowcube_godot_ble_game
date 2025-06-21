/* Copyright Statement:
 *
 * (C) 2021-2023  Cubios Inc. All rights reserved.
 */

#pragma once
#include <string>

#ifdef WOWCONNECTMANAGED_EXPORTS
#define WOWCONNECTMANAGED_API __declspec(dllexport)
#else
#define WOWCONNECTMANAGED_API __declspec(dllimport)
#endif

/// <summary>
/// Log levels
/// </summary>
typedef enum
{
	Info = 0,
	Error = 1
} wowconnect_log_level_t;

/// <summary>
/// WOWCube device descriptor
/// </summary>
typedef struct
{
	char Name[256];
	char Id[256];
	bool IsConnected;
} wowconnect_device_t;

/// <summary>
/// Library delegates
/// </summary>

/// <summary>
/// Library log delegate. Gets called when the library outputs textual data for logging
/// </summary>
typedef void(*log_delegate_t)(wowconnect_log_level_t, const char*);

/// <summary>
/// Device detection delegate. Gets called when the library finds new WOWCube device
/// </summary>
typedef void(*device_detected_delegate_t)(wowconnect_device_t);

/// <summary>
/// Incoming data callback delegate. Gets called when the library receives data from WOWCube device
/// </summary>
typedef void(*message_received_delegate_t)(wowconnect_device_t device, unsigned char, unsigned char*, int);

/// <summary>
/// Returns library version
/// </summary>
extern "C" WOWCONNECTMANAGED_API const char* wowonnect_get_version();

// /// <summary>
// /// Returns emulator support status
// /// </summary>
// extern "C" WOWCONNECTMANAGED_API const bool wowconnect_get_emulator_support();

// /// <summary>
// /// Sets emulator support status
// /// </summary>
// extern "C" WOWCONNECTMANAGED_API const void wowconnect_set_emulator_support(bool value);

/// <summary>
/// Returns last error code
/// </summary>
extern "C" WOWCONNECTMANAGED_API const int wowconnect_get_last_error();

/// <summary>
/// Returns last error description
/// </summary>
extern "C" WOWCONNECTMANAGED_API const char* wowconnect_get_last_error_description();

/// <summary>
/// Opens and initializes the library
/// </summary>
/// <returns>true if success, otherwise false</returns>
extern "C" WOWCONNECTMANAGED_API bool wowconnect_open(device_detected_delegate_t ddt, message_received_delegate_t mrd, log_delegate_t ld);

/// <summary>
/// Opens communication channel with WOWCube device
/// </summary>
/// <param name="device">Device descriptor</param>
/// <param name="cubeappUUID">Cubeapp UUID</param>
/// <returns></returns>
extern "C" WOWCONNECTMANAGED_API bool wowconnect_open_device(wowconnect_device_t device, const char* cubeappUUID);

/// <summary>
/// Closes communication channel with WOWCube device
/// </summary>
/// <param name="device">Device descriptor</param>
/// <returns></returns>
extern "C" WOWCONNECTMANAGED_API void wowconnect_close_device(wowconnect_device_t device);

/// <summary>
/// Writes data to WOWCube device
/// </summary>
/// <param name="device">Device descriptor</param>
/// <param name="data">Data payload</param>
/// <param name="dataSize">Data payload size</param>
/// <returns></returns>
extern "C" WOWCONNECTMANAGED_API bool wowconnect_write_to_device(wowconnect_device_t device, const unsigned char* data, int dataSize);
