{*******************************************************}
{                                                       }
{       MiTeC System Information Component              }
{               Lan Manager API                         }
{           version 8.6 for Delphi 5,6,7                }
{                                                       }
{       Copyright © 1997,2004 Michal Mutl               }
{                                                       }
{*******************************************************}

{$INCLUDE MITEC_DEF.INC}

unit MiTeC_NetAPI32;

interface

uses
  Windows, SysUtils;

const
  NERR_SUCCESS = 0;
  NETERR_INCLUDED = 2102;    // The workstation driver is not installed.
  NERR_UnknownServer = 2103;    // The server could not be located.
  NERR_ShareMem = 2104; //An internal error occurred. The network cannot access a shared memory segment.
  NERR_NoNetworkResource = 2105;    // A network resource shortage occurred .
  NERR_RemoteOnly = 2106;    // This operation is not supported on workstations.
  NERR_DevNotRedirected = 2107;    // The device is not connected.
  NERR_ServerNotStarted = 2114;    // The Server service is not started.
  NERR_ItemNotFound = 2115;    // The queue is empty.
  NERR_UnknownDevDir = 2116;    // The device or directory does not exist.
  NERR_RedirectedPath = 2117;    // The operation is invalid on a redirected resource.
  NERR_DuplicateShare = 2118;    // The name has already been shared.
  NERR_NoRoom = 2119;    // The server is currently out of the requested resource.
  NERR_TooManyItems = 2121;    // Requested addition of items exceeds the maximum allowed.
  NERR_InvalidMaxUsers = 2122;    // The Peer service supports only two simultaneous users.
  NERR_BufTooSmall = 2123;    // The API return buffer is too small.
  NERR_RemoteErr = 2127;    // A remote API error occurred.
  NERR_LanmanIniError = 2131;    // An error occurred when opening or reading the configuration file.
  NERR_NetworkError = 2136;    // A general network error occurred.
  NERR_WkstaInconsistentState = 2137;  // The Workstation service is in an inconsistent state. Restart the computer before restarting the Workstation service.
  NERR_WkstaNotStarted = 2138;    // The Workstation service has not been started.
  NERR_BrowserNotStarted = 2139;    // The requested information is not available.
  NERR_InternalError = 2140;    // An internal Windows NT error occurred.
  NERR_BadTransactConfig = 2141;    // The server is not configured for transactions.
  NERR_InvalidAPI = 2142;    // The requested API is not supported on the remote server.
  NERR_BadEventName = 2143;    // The event name is invalid.
  NERR_DupNameReboot = 2144;  // The computer name already exists on the network. Change it and restart the computer.
  NERR_CfgCompNotFound = 2146;    // The specified component could not be found in the configuration information.
  NERR_CfgParamNotFound = 2147;    // The specified parameter could not be found in the configuration information.
  NERR_LineTooLong = 2149;    // A line in the configuration file is too long.
  NERR_QNotFound = 2150;    // The printer does not exist.
  NERR_JobNotFound = 2151;    // The print job does not exist.
  NERR_DestNotFound = 2152;    // The printer destination cannot be found.
  NERR_DestExists = 2153;    // The printer destination already exists.
  NERR_QExists = 2154;    // The printer queue already exists.
  NERR_QNoRoom = 2155;    // No more printers can be added.
  NERR_JobNoRoom = 2156;    // No more print jobs can be added.
  NERR_DestNoRoom = 2157;    // No more printer destinations can be added.
  NERR_DestIdle = 2158;    // This printer destination is idle and cannot accept control operations.
  NERR_DestInvalidOp = 2159;    // This printer destination request contains an invalid control function.
  NERR_ProcNoRespond = 2160;    // The print processor is not responding.
  NERR_SpoolerNotLoaded = 2161;    // The spooler is not running.
  NERR_DestInvalidState = 2162;    // This operation cannot be performed on the print destination in its current state.
  NERR_QInvalidState = 2163;    // This operation cannot be performed on the printer queue in its current state.
  NERR_JobInvalidState = 2164;    // This operation cannot be performed on the print job in its current state.
  NERR_SpoolNoMemory = 2165;    // A spooler memory allocation failure occurred.
  NERR_DriverNotFound = 2166;    // The device driver does not exist.
  NERR_DataTypeInvalid = 2167;    // The data type is not supported by the print processor.
  NERR_ProcNotFound = 2168;    // The print processor is not installed.
  NERR_ServiceTableLocked = 2180;    // The service database is locked.
  NERR_ServiceTableFull = 2181;    // The service table is full.
  NERR_ServiceInstalled = 2182;    // The requested service has already been started.
  NERR_ServiceEntryLocked = 2183;    // The service does not respond to control actions.
  NERR_ServiceNotInstalled = 2184;    // The service has not been started.
  NERR_BadServiceName = 2185;    // The service name is invalid.
  NERR_ServiceCtlTimeout = 2186;    // The service is not responding to the control function.
  NERR_ServiceCtlBusy = 2187;    // The service control is busy.
  NERR_BadServiceProgName = 2188;    // The configuration file contains an invalid service program name.
  NERR_ServiceNotCtrl = 2189;    // The service could not be controlled in its present state.
  NERR_ServiceKillProc = 2190;    // The service ended abnormally.
  NERR_ServiceCtlNotValid = 2191;    // The requested pause or stop is not valid for this service.
  NERR_NotInDispatchTbl = 2192;    // The service control dispatcher could not find the service name in the dispatch table.
  NERR_BadControlRecv = 2193;    // The service control dispatcher pipe read failed.
  NERR_ServiceNotStarting = 2194;    // A thread for the new service could not be created.
  NERR_AlreadyLoggedOn = 2200;    // This workstation is already logged on to the local-area network.
  NERR_NotLoggedOn = 2201;    // The workstation is not logged on to the local-area network.
  NERR_BadUsername = 2202;    // The user name or group name parameter is invalid.
  NERR_BadPassword = 2203;    // The password parameter is invalid.
  NERR_UnableToAddName_W = 2204;    // @W The logon processor did not add the message alias.
  NERR_UnableToAddName_F = 2205;    // The logon processor did not add the message alias.
  NERR_UnableToDelName_W = 2206;    // @W The logoff processor did not delete the message alias.
  NERR_UnableToDelName_F = 2207;    // The logoff processor did not delete the message alias.
  NERR_LogonsPaused = 2209;    // Network logons are paused.
  NERR_LogonServerConflict = 2210;    // A centralized logon-server conflict occurred.
  NERR_LogonNoUserPath = 2211;    // The server is configured without a valid user path.
  NERR_LogonScriptError = 2212;    // An error occurred while loading or running the logon script.
  NERR_StandaloneLogon = 2214;    // The logon server was not specified. Your computer will be logged on as STANDALONE.
  NERR_LogonServerNotFound = 2215;    // The logon server could not be found.
  NERR_LogonDomainExists = 2216;    // There is already a logon domain for this computer.
  NERR_NonValidatedLogon = 2217;    // The logon server could not validate the logon.
  NERR_ACFNotFound = 2219;    // The security database could not be found.
  NERR_GroupNotFound = 2220;    // The group name could not be found.
  NERR_UserNotFound = 2221;    // The user name could not be found.
  NERR_ResourceNotFound = 2222;    // The resource name could not be found.
  NERR_GroupExists = 2223;    // The group already exists.
  NERR_UserExists = 2224;    // The user account already exists.
  NERR_ResourceExists = 2225;    // The resource permission list already exists.
  NERR_NotPrimary = 2226;    // This operation is only allowed on the primary domain controller of the domain.
  NERR_ACFNotLoaded = 2227;    // The security database has not been started.
  NERR_ACFNoRoom = 2228;    // There are too many names in the user accounts database.
  NERR_ACFFileIOFail = 2229;    // A disk I/O failure occurred.
  NERR_ACFTooManyLists = 2230;    // The limit of 64 entries per resource was exceeded.
  NERR_UserLogon = 2231;    // Deleting a user with a session is not allowed.
  NERR_ACFNoParent = 2232;    // The parent directory could not be located.
  NERR_CanNotGrowSegment = 2233;    // Unable to add to the security database session cache segment.
  NERR_SpeGroupOp = 2234;    // This operation is not allowed on this special group.
  NERR_NotInCache = 2235;    // This user is not cached in user accounts database session cache.
  NERR_UserInGroup = 2236;    // The user already belongs to this group.
  NERR_UserNotInGroup = 2237;    // The user does not belong to this group.
  NERR_AccountUndefined = 2238;    // This user account is undefined.
  NERR_AccountExpired = 2239;    // This user account has expired.
  NERR_InvalidWorkstation = 2240;    // The user is not allowed to log on from this workstation.
  NERR_InvalidLogonHours = 2241;    // The user is not allowed to log on at this time.
  NERR_PasswordExpired = 2242;    // The password of this user has expired.
  NERR_PasswordCantChange = 2243;    // The password of this user cannot change.
  NERR_PasswordHistConflict = 2244;    // This password cannot be used now.
  NERR_PasswordTooShort = 2245;    // The password is shorter than required.
  NERR_PasswordTooRecent = 2246;    // The password of this user is too recent to change.
  NERR_InvalidDatabase = 2247;    // The security database is corrupted.
  NERR_DatabaseUpToDate = 2248;    // No updates are necessary to this replicant network/local security database.
  NERR_SyncRequired = 2249;    // This replicant database is outdated; synchronization is required.
  NERR_UseNotFound = 2250;    // The network connection could not be found.
  NERR_BadAsgType = 2251;    // This asg_type is invalid.
  NERR_DeviceIsShared = 2252;    // This device is currently being shared.
  NERR_NoComputerName = 2270;   // The computer name could not be added as a message alias. The name may already exist on the network.
  NERR_MsgAlreadyStarted = 2271;    // The Messenger service is already started.
  NERR_MsgInitFailed = 2272;    // The Messenger service failed to start.
  NERR_NameNotFound = 2273;    // The message alias could not be found on the network.
  NERR_AlreadyForwarded = 2274;    // This message alias has already been forwarded.
  NERR_AddForwarded = 2275;    // This message alias has been added but is still forwarded.
  NERR_AlreadyExists = 2276;    // This message alias already exists locally.
  NERR_TooManyNames = 2277;    // The maximum number of added message aliases has been exceeded.
  NERR_DelComputerName = 2278;    // The computer name could not be deleted.
  NERR_LocalForward = 2279;    // Messages cannot be forwarded back to the same workstation.
  NERR_GrpMsgProcessor = 2280;    // An error occurred in the domain message processor.
  NERR_PausedRemote = 2281;    // The message was sent, but the recipient has paused the Messenger service.
  NERR_BadReceive = 2282;    // The message was sent but not received.
  NERR_NameInUse = 2283;   // The message alias is currently in use. Try again later.
  NERR_MsgNotStarted = 2284;    // The Messenger service has not been started.
  NERR_NotLocalName = 2285;    // The name is not on the local computer.
  NERR_NoForwardName = 2286;    // The forwarded message alias could not be found on the network.
  NERR_RemoteFull = 2287;    // The message alias table on the remote station is full.
  NERR_NameNotForwarded = 2288;    // Messages for this alias are not currently being forwarded.
  NERR_TruncatedBroadcast = 2289;    // The broadcast message was truncated.
  NERR_InvalidDevice = 2294;    // This is an invalid device name.
  NERR_WriteFault = 2295;    // A write fault occurred.
  NERR_DuplicateName = 2297;    // A duplicate message alias exists on the network.
  NERR_DeleteLater = 2298;    // @W This message alias will be deleted later.
  NERR_IncompleteDel = 2299;    // The message alias was not successfully deleted from all networks.
  NERR_MultipleNets = 2300;    // This operation is not supported on computers with multiple networks.
  NERR_NetNameNotFound = 2310;    // This shared resource does not exist.
  NERR_DeviceNotShared = 2311;    // This device is not shared.
  NERR_ClientNameNotFound = 2312;    // A session does not exist with that computer name.
  NERR_FileIdNotFound = 2314;    // There is not an open file with that identification number.
  NERR_ExecFailure = 2315;    // A failure occurred when executing a remote administration command.
  NERR_TmpFile = 2316;    // A failure occurred when opening a remote temporary file.
  NERR_TooMuchData = 2317;    // The data returned from a remote administration command has been truncated to 64K.
  NERR_DeviceShareConflict = 2318;    // This device cannot be shared as both a spooled and a non-spooled resource.
  NERR_BrowserTableIncomplete = 2319;    // The information in the list of servers may be incorrect.
  NERR_NotLocalDomain = 2320;    // The computer is not active in this domain.
  NERR_IsDfsShare = 2321;    // The share must be removed from the Distributed File System before it can be deleted.
  NERR_DevInvalidOpCode = 2331;    // The operation is invalid for this device.
  NERR_DevNotFound = 2332;    // This device cannot be shared.
  NERR_DevNotOpen = 2333;    // This device was not open.
  NERR_BadQueueDevString = 2334;    // This device name list is invalid.
  NERR_BadQueuePriority = 2335;    // The queue priority is invalid.
  NERR_NoCommDevs = 2337;    // There are no shared communication devices.
  NERR_QueueNotFound = 2338;    // The queue you specified does not exist.
  NERR_BadDevString = 2340;    // This list of devices is invalid.
  NERR_BadDev = 2341;    // The requested device is invalid.
  NERR_InUseBySpooler = 2342;    // This device is already in use by the spooler.
  NERR_CommDevInUse = 2343;    // This device is already in use as a communication device.
  NERR_InvalidComputer = 2351;    // This computer name is invalid.
  NERR_MaxLenExceeded = 2354;    // The string and prefix specified are too long.
  NERR_BadComponent = 2356;    // This path component is invalid.
  NERR_CantType = 2357;    // Could not determine the type of input.
  NERR_TooManyEntries = 2362;    // The buffer for types is not big enough.
  NERR_ProfileFileTooBig = 2370;    // Profile files cannot exceed 64K.
  NERR_ProfileOffset = 2371;    // The start offset is out of range.
  NERR_ProfileCleanup = 2372;    // The system cannot delete current connections to network resources.
  NERR_ProfileUnknownCmd = 2373;    // The system was unable to parse the command line in this file.
  NERR_ProfileLoadErr = 2374;    // An error occurred while loading the profile file.
  NERR_ProfileSaveErr = 2375;    // @W Errors occurred while saving the profile file. The profile was partially saved.
  NERR_LogOverflow = 2377;    // Log file %1 is full.
  NERR_LogFileChanged = 2378;    // This log file has changed between reads.
  NERR_LogFileCorrupt = 2379;    // Log file %1 is corrupt.
  NERR_SourceIsDir = 2380;    // The source path cannot be a directory.
  NERR_BadSource = 2381;    // The source path is illegal.
  NERR_BadDest = 2382;    // The destination path is illegal.
  NERR_DifferentServers = 2383;    // The source and destination paths are on different servers.
  NERR_RunSrvPaused = 2385;    // The Run server you requested is paused.
  NERR_ErrCommRunSrv = 2389;    // An error occurred when communicating with a Run server.
  NERR_ErrorExecingGhost = 2391;    // An error occurred when starting a background process.
  NERR_ShareNotFound = 2392;    // The shared resource you are connected to could not be found.
  NERR_InvalidLana = 2400;    // The LAN adapter number is invalid.
  NERR_OpenFiles = 2401;    // There are open files on the connection.
  NERR_ActiveConns = 2402;    // Active connections still exist.
  NERR_BadPasswordCore = 2403;    // This share name or password is invalid.
  NERR_DevInUse = 2404;    // The device is being accessed by an active process.
  NERR_LocalDrive = 2405;    // The drive letter is in use locally.
  NERR_AlertExists = 2430;    // The specified client is already registered for the specified event.
  NERR_TooManyAlerts = 2431;    // The alert table is full.
  NERR_NoSuchAlert = 2432;    // An invalid or nonexistent alert name was raised.
  NERR_BadRecipient = 2433;    // The alert recipient is invalid.
  NERR_AcctLimitExceeded = 2434;    //A user's session with this server has been deleted
  NERR_InvalidLogSeek = 2440;    // The log file does not contain the requested record number.
  NERR_BadUasConfig = 2450;    // The user accounts database is not configured correctly.
  NERR_InvalidUASOp = 2451;    // This operation is not permitted when the Netlogon service is running.
  NERR_LastAdmin = 2452;    // This operation is not allowed on the last administrative account.
  NERR_DCNotFound = 2453;    // Could not find domain controller for this domain.
  NERR_LogonTrackingError = 2454;    // Could not set logon information for this user.
  NERR_NetlogonNotStarted = 2455;    // The Netlogon service has not been started.
  NERR_CanNotGrowUASFile = 2456;    // Unable to add to the user accounts database.
  NERR_TimeDiffAtDC = 2457;    // This server's clock is not synchronized with the primary domain controller's clock.
  NERR_PasswordMismatch = 2458;    // A password mismatch has been detected.
  NERR_NoSuchServer = 2460;    // The server identification does not specify a valid server.
  NERR_NoSuchSession = 2461;    // The session identification does not specify a valid session.
  NERR_NoSuchConnection = 2462;    // The connection identification does not specify a valid connection.
  NERR_TooManyServers = 2463;    // There is no space for another entry in the table of available servers.
  NERR_TooManySessions = 2464;    // The server has reached the maximum number of sessions it supports.
  NERR_TooManyConnections = 2465;    // The server has reached the maximum number of connections it supports.
  NERR_TooManyFiles = 2466;    // The server cannot open more files because it has reached its maximum number.
  NERR_NoAlternateServers = 2467;    // There are no alternate servers registered on this server.
  NERR_TryDownLevel = 2470;    // Try down-level (remote admin protocol) version of API instead.
  NERR_UPSDriverNotStarted = 2480;    // The UPS driver could not be accessed by the UPS service.
  NERR_UPSInvalidConfig = 2481;    // The UPS service is not configured correctly.
  NERR_UPSInvalidCommPort = 2482;    // The UPS service could not access the specified Comm Port.
  NERR_UPSSignalAsserted = 2483;  // The UPS indicated a line fail or low battery situation. Service not started.
  NERR_UPSShutdownFailed = 2484;    // The UPS service failed to perform a system shut down.
  NERR_BadDosRetCode = 2500;    //The program below returned an MS-DOS error code:
  NERR_ProgNeedsExtraMem = 2501;    //The program below needs more memory:
  NERR_BadDosFunction = 2502;    //The program below called an unsupported MS-DOS function:
  NERR_RemoteBootFailed = 2503;    // The workstation failed to boot.
  NERR_BadFileCheckSum = 2504;    // The file below is corrupt.
  NERR_NoRplBootSystem = 2505;    // No loader is specified in the boot-block definition file.
  NERR_RplLoadrNetBiosErr = 2506;    // NetBIOS returned an error: The NCB and SMB are dumped above.
  NERR_RplLoadrDiskErr = 2507;    // A disk I/O error occurred.
  NERR_ImageParamErr = 2508;    // Image parameter substitution failed.
  NERR_TooManyImageParams = 2509;    // Too many image parameters cross disk sector boundaries.
  NERR_NonDosFloppyUsed = 2510;    // The image was not generated from an MS-DOS diskette formatted with /S.
  NERR_RplBootRestart = 2511;    // Remote boot will be restarted later.
  NERR_RplSrvrCallFailed = 2512;    // The call to the Remoteboot server failed.
  NERR_CantConnectRplSrvr = 2513;    // Cannot connect to the Remoteboot server.
  NERR_CantOpenImageFile = 2514;    // Cannot open image file on the Remoteboot server.
  NERR_CallingRplSrvr = 2515;    // Connecting to the Remoteboot server..
  NERR_StartingRplBoot = 2516;    // Connecting to the Remoteboot server..
  NERR_RplBootServiceTerm = 2517;    // Remote boot service was stopped; check the error log for the cause of the problem.
  NERR_RplBootStartFailed = 2518;    // Remote boot startup failed; check the error log for the cause of the problem.
  NERR_RPL_CONNECTED = 2519;    // A second connection to a Remoteboot resource is not allowed.
  NERR_BrowserConfiguredToNotRun = 2550;    // The browser service was configured with MaintainServerList=No.
  NERR_RplNoAdaptersStarted = 2610;    // Service failed to start since none of the network adapters started with this service.
  NERR_RplBadRegistry = 2611;    // Service failed to start due to bad startup information in the registry.
  NERR_RplBadDatabase = 2612;    // Service failed to start because its database is absent or corrupt.
  NERR_RplRplfilesShare = 2613;    // Service failed to start because RPLFILES share is absent.
  NERR_RplNotRplServer = 2614;    // Service failed to start because RPLUSER group is absent.
  NERR_RplCannotEnum = 2615;    // Cannot enumerate service records.
  NERR_RplWkstaInfoCorrupted = 2616;    // Workstation record information has been corrupted.
  NERR_RplWkstaNotFound = 2617;    // Workstation record was not found.
  NERR_RplWkstaNameUnavailable = 2618;    // Workstation name is in use by some other workstation.
  NERR_RplProfileInfoCorrupted = 2619;    // Profile record information has been corrupted.
  NERR_RplProfileNotFound = 2620;    // Profile record was not found.
  NERR_RplProfileNameUnavailable = 2621;    // Profile name is in use by some other profile.
  NERR_RplProfileNotEmpty = 2622;    // There are workstations using this profile.
  NERR_RplConfigInfoCorrupted = 2623;    // Configuration record information has been corrupted.
  NERR_RplConfigNotFound = 2624;    // Configuration record was not found.
  NERR_RplAdapterInfoCorrupted = 2625;    // Adapter id record information has been corrupted.
  NERR_RplInternal = 2626;    // An internal service error has occurred.
  NERR_RplVendorInfoCorrupted = 2627;    // Vendor id record information has been corrupted.
  NERR_RplBootInfoCorrupted = 2628;    // Boot block record information has been corrupted.
  NERR_RplWkstaNeedsUserAcct = 2629;    // The user account for this workstation record is missing.
  NERR_RplNeedsRPLUSERAcct = 2630;    // The RPLUSER local group could not be found.
  NERR_RplBootNotFound = 2631;    // Boot block record was not found.
  NERR_RplIncompatibleProfile = 2632;    // Chosen profile is incompatible with this workstation.
  NERR_RplAdapterNameUnavailable = 2633;    // Chosen network adapter id is in use by some other workstation.
  NERR_RplConfigNotEmpty = 2634;    // There are profiles using this configuration.
  NERR_RplBootInUse = 2635;    // There are workstations, profiles, or configurations using this boot block.
  NERR_RplBackupDatabase = 2636;    // Service failed to backup Remoteboot database.
  NERR_RplAdapterNotFound = 2637;    // Adapter record was not found.
  NERR_RplVendorNotFound = 2638;    // Vendor record was not found.
  NERR_RplVendorNameUnavailable = 2639;    // Vendor name is in use by some other vendor record.
  NERR_RplBootNameUnavailable = 2640;    // (boot name, vendor id) is in use by some other boot block record.
  NERR_RplConfigNameUnavailable = 2641;    // Configuration name is in use by some other configuration.
  NERR_DfsInternalCorruption = 2660;    //The internal database maintained by the Dfs service is corrupt
  NERR_DfsVolumeDataCorrupt = 2661;    //One of the records in the internal Dfs database is corrupt
  NERR_DfsNoSuchVolume = 2662;    //There is no volume whose entry path matches the input Entry Path
  NERR_DfsVolumeAlreadyExists = 2663;    //A volume with the given name already exists
  NERR_DfsAlreadyShared = 2664;    //The server share specified is already shared in the Dfs
  NERR_DfsNoSuchShare = 2665;    //The indicated server share does not support the indicated Dfs volume
  NERR_DfsNotALeafVolume = 2666;    //The operation is not valid on a non-leaf volume
  NERR_DfsLeafVolume = 2667;    //The operation is not valid on a leaf volume
  NERR_DfsVolumeHasMultipleServers = 2668;    //The operation is ambiguous because the volume has multiple servers
  NERR_DfsCantCreateJunctionPoint = 2669;    //Unable to create a junction point
  NERR_DfsServerNotDfsAware = 2670;    //The server is not Dfs Aware
  NERR_DfsBadRenamePath = 2671;    //The specified rename target path is invalid
  NERR_DfsVolumeIsOffline = 2672;    //The specified Dfs volume is offline
  NERR_DfsNoSuchServer = 2673;    //The specified server is not a server for this volume
  NERR_DfsCyclicalName = 2674;    //A cycle in the Dfs name was detected
  NERR_DfsNotSupportedInServerDfs = 2675;    //The operation is not supported on a server-based Dfs
  NERR_DfsInternalError = 2690;    //Dfs internal error
  NERR_SetupAlreadyJoined = 2691;    // This machine is already joined to a domain.
  NERR_SetupNotJoined = 2692;    // This machine is not currently joined to a domain.
  NERR_SetupDomainController = 2693;    // This machine is a domain controller and cannot be unjoined from a domain.
  NERR_InvalidWeekDays    = 2000;
  NERR_InvalidMonthDays   = 2001;

  SV_TYPE_WORKSTATION       = $00000001;  // All LAN Manager workstations
  SV_TYPE_SERVER            = $00000002;  // All LAN Manager servers
  SV_TYPE_SQLSERVER         = $00000004; // Any server running with Microsoft SQL Server
  SV_TYPE_DOMAIN_CTRL       = $00000008; // Primary domain controller
  SV_TYPE_DOMAIN_BAKCTRL    = $00000010; // Backup domain controller
  SV_TYPE_TIMESOURCE        = $00000020; // Server running the Timesource service
  SV_TYPE_AFP               = $00000040; // Apple File Protocol servers
  SV_TYPE_NOVELL            = $00000080; // Novell servers
  SV_TYPE_DOMAIN_MEMBER     = $00000100; // LAN Manager 2.x Domain Member
  SV_TYPE_LOCAL_LIST_ONLY   = $40000000; //Servers maintained by the browser
  SV_TYPE_PRINT             = $00000200; //Server sharing print queue
  SV_TYPE_DIALIN            = $00000400; // Server running dial-in service
  SV_TYPE_XENIX_SERVER      = $00000800; // Xenix server
  SV_TYPE_MFPN              = $00004000; // Microsoft File and Print for Netware
  SV_TYPE_NT                = $00001000; // Windows NT (either Workstation or Server)
  SV_TYPE_WFW               = $00002000; // Server running Windows for Workgroups
  SV_TYPE_SERVER_NT         = $00008000; // Windows NT non-DC server
  SV_TYPE_POTENTIAL_BROWSER = $00010000; // Server that can run the Browser service
  SV_TYPE_BACKUP_BROWSER    = $00020000; // Server running a Browser service as backup
  SV_TYPE_MASTER_BROWSER    = $00040000; // Server running the master Browser service
  SV_TYPE_DOMAIN_MASTER     = $00080000; // Server running the domain master Browser
  SV_TYPE_DOMAIN_ENUM       = $80000000; // Primary Domain
  SV_TYPE_WINDOWS           = $00400000; // Windows 95 or later
  SV_TYPE_ALL               = $FFFFFFFF; //All servers

  FILTER_TEMP_DUPLICATE_ACCOUNT     =  $0001;
  FILTER_NORMAL_ACCOUNT             =  $0002;
  FILTER_PROXY_ACCOUNT              =  $0004;
  FILTER_INTERDOMAIN_TRUST_ACCOUNT  =  $0008;
  FILTER_WORKSTATION_TRUST_ACCOUNT  =  $0010;
  FILTER_SERVER_TRUST_ACCOUNT       =  $0020;

  LM20_NNLEN = 12;
  SHPWLEN = 8;

  STYPE_DISKTREE = 0;
  STYPE_PRINTQ   = 1;
  STYPE_DEVICE   = 2;
  STYPE_IPC      = 3;

  STYPE_SPECIAL  = $80000000;

  ACCESS_NONE   = $00;
  ACCESS_READ   = $01;
  ACCESS_WRITE  = $02;
  ACCESS_CREATE = $04;
  ACCESS_EXEC   = $08;
  ACCESS_DELETE = $10;
  ACCESS_ATRIB  = $20;
  ACCESS_PERM   = $40;
  ACCESS_ALL    = ACCESS_READ or ACCESS_WRITE or
                  ACCESS_CREATE or ACCESS_EXEC or
                  ACCESS_DELETE or ACCESS_ATRIB or
                  ACCESS_PERM;

  LG_INCLUDE_INDIRECT = $0001;

  SESS_GUEST        = $00000001;
  SESS_NOENCRYPTION = $00000002;

  PERM_FILE_READ   =   $1;
  PERM_FILE_WRITE  =   $2;
  PERM_FILE_CREATE =   $4;

  JOB_RUN_PERIODICALLY   = $01;    //  set if EVERY
  JOB_EXEC_ERROR         = $02;    //  set if error
  JOB_RUNS_TODAY         = $04;    //  set if today
  JOB_ADD_CURRENT_DATE   = $08;    // set if to add current date
  JOB_NONINTERACTIVE     = $10;    // set for noninteractive
  JOB_INPUT_FLAGS        = JOB_RUN_PERIODICALLY or JOB_ADD_CURRENT_DATE or JOB_NONINTERACTIVE;
  JOB_OUTPUT_FLAGS       = JOB_RUN_PERIODICALLY or JOB_EXEC_ERROR or JOB_RUNS_TODAY or JOB_NONINTERACTIVE;
  MAX_PREFERRED_LENGTH   = -1;

  UF_SCRIPT              = $0001;
  UF_ACCOUNTDISABLE      = $0002;
  UF_HOMEDIR_REQUIRED    = $0008;
  UF_LOCKOUT             = $0010;
  UF_PASSWD_NOTREQD      = $0020;
  UF_PASSWD_CANT_CHANGE  = $0040;

  UF_TEMP_DUPLICATE_ACCOUNT      = $0100;
  UF_NORMAL_ACCOUNT              = $0200;
  UF_INTERDOMAIN_TRUST_ACCOUNT   = $0800;
  UF_WORKSTATION_TRUST_ACCOUNT   = $1000;
  UF_SERVER_TRUST_ACCOUNT        = $2000;

  UF_MACHINE_ACCOUNT_MASK = UF_INTERDOMAIN_TRUST_ACCOUNT or
                            UF_WORKSTATION_TRUST_ACCOUNT or
                            UF_SERVER_TRUST_ACCOUNT;

  UF_ACCOUNT_TYPE_MASK = UF_TEMP_DUPLICATE_ACCOUNT or
                         UF_NORMAL_ACCOUNT or
                         UF_INTERDOMAIN_TRUST_ACCOUNT or
                         UF_WORKSTATION_TRUST_ACCOUNT or
                         UF_SERVER_TRUST_ACCOUNT;

  UF_DONT_EXPIRE_PASSWD = $10000;
  UF_MNS_LOGON_ACCOUNT  = $20000;


  UF_SETTABLE_BITS = UF_SCRIPT or
                     UF_ACCOUNTDISABLE or
                     UF_LOCKOUT or
                     UF_HOMEDIR_REQUIRED or
                     UF_PASSWD_NOTREQD or
                     UF_PASSWD_CANT_CHANGE or
                     UF_ACCOUNT_TYPE_MASK or
                     UF_DONT_EXPIRE_PASSWD or
                     UF_MNS_LOGON_ACCOUNT;

type
  NET_API_STATUS = DWORD;

  _NET_DISPLAY_USER = record
    usri1_name: LPWSTR;
    usri1_comment: LPWSTR;
    usri1_flags: DWORD;
    usri1_full_name: LPWSTR;
    usri1_user_id: DWORD;
    usri1_next_index: DWORD;
  end;

  PNET_DISPLAY_USER = ^NET_DISPLAY_USER;
  NET_DISPLAY_USER = _NET_DISPLAY_USER;

  _NET_DISPLAY_MACHINE = record
    usri2_name: LPWSTR;
    usri2_comment: LPWSTR;
    usri2_flags: DWORD;
    usri2_user_id: DWORD;
    usri2_next_index: DWORD;
  end;

  PNET_DISPLAY_MACHINE = ^NET_DISPLAY_MACHINE;
  NET_DISPLAY_MACHINE = _NET_DISPLAY_MACHINE;

  _NET_DISPLAY_GROUP = record
    grpi3_name: LPWSTR;
    grpi3_comment: LPWSTR;
    grpi3_group_id: DWORD;
    grpi3_attributes: DWORD;
    grpi3_next_index: DWORD;
  end;

  PNET_DISPLAY_GROUP = ^NET_DISPLAY_GROUP;
  NET_DISPLAY_GROUP = _NET_DISPLAY_GROUP;

  _STAT_WORKSTATION_0 = record
    stw0_start: DWORD;
    stw0_numNCB_r: DWORD;
    stw0_numNCB_s: DWORD;
    stw0_numNCB_a: DWORD;
    stw0_fiNCB_r: DWORD;
    stw0_fiNCB_s: DWORD;
    stw0_fiNCB_a: DWORD;
    stw0_fcNCB_r: DWORD;
    stw0_fcNCB_s: DWORD;
    stw0_fcNCB_a: DWORD;
    stw0_sesstart: DWORD;
    stw0_sessfailcon: DWORD;
    stw0_sessbroke: DWORD;
    stw0_uses: DWORD;
    stw0_usefail: DWORD;
    stw0_autorec: DWORD;
    stw0_bytessent_r_lo: DWORD;
    stw0_bytessent_r_hi: DWORD;
    stw0_bytesrcvd_r_lo: DWORD;
    stw0_bytesrcvd_r_hi: DWORD;
    stw0_bytessent_s_lo: DWORD;
    stw0_bytessent_s_hi: DWORD;
    stw0_bytesrcvd_s_lo: DWORD;
    stw0_bytesrcvd_s_hi: DWORD;
    stw0_bytessent_a_lo: DWORD;
    stw0_bytessent_a_hi: DWORD;
    stw0_bytesrcvd_a_lo: DWORD;
    stw0_bytesrcvd_a_hi: DWORD;
    stw0_reqbufneed: DWORD;
    stw0_bigbufneed: DWORD;
  end;

  PSTAT_WORKSTATION_0 = ^STAT_WORKSTATION_0;
  STAT_WORKSTATION_0 = _STAT_WORKSTATION_0;

  _STAT_SERVER_0 = record
    sts0_start: DWORD;
    sts0_fopens: DWORD;
    sts0_devopens: DWORD;
    sts0_jobsqueued: DWORD;
    sts0_sopens: DWORD;
    sts0_stimedout: DWORD;
    sts0_serrorout: DWORD;
    sts0_pwerrors: DWORD;
    sts0_permerrors: DWORD;
    sts0_syserrors: DWORD;
    sts0_bytessent_low: DWORD;
    sts0_bytessent_high: DWORD;
    sts0_bytesrcvd_low: DWORD;
    sts0_bytesrcvd_high: DWORD;
    sts0_avresponse: DWORD;
    sts0_reqbufneed: DWORD;
    sts0_bigbufneed: DWORD;
  end;

  PSTAT_SERVER_0 = ^STAT_SERVER_0;
  STAT_SERVER_0 = _STAT_SERVER_0;

  _SERVER_TRANSPORT_INFO_1 = record
    svti1_numberofvcs: DWORD;
    svti1_transportname: LPSTR;
    svti1_transportaddress: PBYTE;
    svti1_transportaddresslength: DWORD;
    svti1_networkaddress: LPSTR;
    svti1_domain: LPSTR;
  end;

  PSERVER_TRANSPORT_INFO_1 = ^SERVER_TRANSPORT_INFO_1;
  SERVER_TRANSPORT_INFO_1 = _SERVER_TRANSPORT_INFO_1;

  _WKSTA_TRANSPORT_INFO_0 = record
    wkti0_quality_of_service: DWORD;
    wkti0_number_of_vcs: DWORD;
    wkti0_transport_name: LPWSTR;
    wkti0_transport_address: LPWSTR;
    wkti0_wan_ish: BOOL;
  end;

  PWKSTA_TRANSPORT_INFO_0 = ^WKSTA_TRANSPORT_INFO_0;
  WKSTA_TRANSPORT_INFO_0 = _WKSTA_TRANSPORT_INFO_0;

  _WKSTA_USER_INFO_0 = record
      wkui0_username :LPWSTR;
  end;

  PWKSTA_USER_INFO_0 = ^WKSTA_USER_INFO_0;
  WKSTA_USER_INFO_0 = ^_WKSTA_USER_INFO_0;

  _WKSTA_USER_INFO_1 = record
      wkui1_username :LPWSTR;
      wkui1_logon_domain :LPWSTR;
      wkui1_oth_domains :LPWSTR;
      wkui1_logon_server :LPWSTR;
  end;

  PWKSTA_USER_INFO_1 = ^WKSTA_USER_INFO_1;
  WKSTA_USER_INFO_1 = ^_WKSTA_USER_INFO_1;

  _WKSTA_INFO_100 = record
     wksi100_platform_id : DWORD;
     wksi100_computername : LPWSTR;
     wksi100_langroup : LPWSTR;
     wksi100_ver_major : DWORD;
     wksi100_ver_minor : DWORD;
  end;

  PWKSTA_INFO_100 = ^WKSTA_INFO_100;
  WKSTA_INFO_100 = _WKSTA_INFO_100;


  _SERVER_INFO_100 = record
     sv100_platform_id : DWORD;
     sv100_name : LPWSTR;
  end;

  PSERVER_INFO_100 = ^SERVER_INFO_100;
  SERVER_INFO_100 = _SERVER_INFO_100;

  _SERVER_INFO_101 = record
    sv101_platform_id :DWORD;
    sv101_name :LPWSTR;
    sv101_version_major :DWORD;
    sv101_version_minor :DWORD;
    sv101_type :DWORD;
    sv101_comment :LPWSTR;
  end;

  PSERVER_INFO_101 = ^SERVER_INFO_101;
  SERVER_INFO_101 = ^_SERVER_INFO_101;

  _USER_INFO_11 = record
    usri11_name: LPWSTR;
    usri11_comment: LPWSTR;
    usri11_usr_comment: LPWSTR;
    usri11_full_name: LPWSTR;
    usri11_priv: DWORD;
    usri11_auth_flags: DWORD;
    usri11_password_age: DWORD;
    usri11_home_dir: LPWSTR;
    usri11_parms: LPWSTR;
    usri11_last_logon: DWORD;
    usri11_last_logoff: DWORD;
    usri11_bad_pw_count: DWORD;
    usri11_num_logons: DWORD;
    usri11_logon_server: LPWSTR;
    usri11_country_code: DWORD;
    usri11_workstations: LPWSTR;
    usri11_max_storage: DWORD;
    usri11_units_per_week: DWORD;
    usri11_logon_hours: PBYTE;
    usri11_code_page: DWORD;
  end;

  PUSER_INFO_11 = ^USER_INFO_11;
  USER_INFO_11 = _USER_INFO_11;

  _GROUP_USERS_INFO_0 = record
     grui0_name: LPWSTR;
   end;

   PGROUP_USERS_INFO_0 = ^GROUP_USERS_INFO_0;
   GROUP_USERS_INFO_0 = _GROUP_USERS_INFO_0;

  _GROUP_INFO_2 = record
    grpi2_name: LPWSTR;
    grpi2_comment: LPWSTR;
    grpi2_group_id: DWORD;
    grpi2_attributes: DWORD;
  end;

  PGROUP_INFO_2 = ^GROUP_INFO_2;
  GROUP_INFO_2 = _GROUP_INFO_2;

  _LOCALGROUP_INFO_0 = record
    lgrpi1_name: LPWSTR;
  end;

  PLOCALGROUP_INFO_0 = ^LOCALGROUP_INFO_0;
  LOCALGROUP_INFO_0 = _LOCALGROUP_INFO_0;

  _LOCALGROUP_INFO_1 = record
    lgrpi1_name: LPWSTR;
    lgrpi1_comment: LPWSTR;
  end;

  PLOCALGROUP_INFO_1 = ^LOCALGROUP_INFO_1;
  LOCALGROUP_INFO_1 = _LOCALGROUP_INFO_1;

  _LOCALGROUP_USERS_INFO_0 = record
     lgrui0_name: LPWSTR;
  end;

  PLOCALGROUP_USERS_INFO_0 = ^LOCALGROUP_USERS_INFO_0;
  LOCALGROUP_USERS_INFO_0 = _LOCALGROUP_USERS_INFO_0;

  _LOCALGROUP_MEMBERS_INFO_3 = record
    lgrmi3_domainandname: LPWSTR;
  end;

  PLOCALGROUP_MEMBERS_INFO_3 = ^LOCALGROUP_MEMBERS_INFO_3;
  LOCALGROUP_MEMBERS_INFO_3 = _LOCALGROUP_MEMBERS_INFO_3;

  _SHARE_INFO_502 = record
    shi502_netname: LPWSTR;
    shi502_type: DWORD;
    shi502_remark: LPWSTR;
    shi502_permissions: DWORD;
    shi502_max_uses: DWORD;
    shi502_current_uses: DWORD;
    shi502_path: LPWSTR;
    shi502_passwd: LPWSTR;
    shi502_reserved: DWORD;
    shi502_security_descriptor: PSECURITY_DESCRIPTOR;
  end;

  PSHARE_INFO_502 = ^SHARE_INFO_502;
  SHARE_INFO_502 = _SHARE_INFO_502;


  _FILE_INFO_3 = record
    fi3_id: DWORD;
    fi3_permissions: DWORD;
    fi3_num_locks: DWORD;
    fi3_pathname: LPWSTR;
    fi3_username: LPWSTR;
  end;

  PFILE_INFO_3 = ^FILE_INFO_3;
  FILE_INFO_3 = _FILE_INFO_3;

  _SESSION_INFO_502 = record
    sesi502_cname: LPWSTR;
    sesi502_username: LPWSTR;
    sesi502_num_opens: DWORD;
    sesi502_time: DWORD;
    sesi502_idle_time: DWORD;
    sesi502_user_flags: DWORD;
    sesi502_cltype_name: LPWSTR;
    sesi502_transport: LPWSTR;
  end;

  PSESSION_INFO_502 = ^SESSION_INFO_502;
  SESSION_INFO_502 = _SESSION_INFO_502;

  _CONNECTION_INFO_1 = record
    coni1_id: DWORD;
    coni1_type: DWORD;
    coni1_num_opens: DWORD;
    coni1_num_users: DWORD;
    coni1_time: DWORD;
    coni1_username: LPWSTR;
    coni1_netname: LPWSTR;
  end;

  PCONNECTION_INFO_1 = ^CONNECTION_INFO_1;
  CONNECTION_INFO_1 = _CONNECTION_INFO_1;

  _AT_ENUM = record
    JobId: DWORD;
    JobTime: DWORD;
    DaysOfMonth: DWORD;
    DaysOfWeek: byte;
    flags: byte;
    Command: LPWSTR;
  end;

  PAT_ENUM = ^AT_ENUM;
  AT_ENUM = _AT_ENUM;

  _AT_INFO = record
    JobTime: DWORD;
    DaysOfMonth: DWORD;
    DaysOfWeek: byte;
    flags: byte;
    Command: LPWSTR;
  end;

  PAT_INFO = ^AT_INFO;
  AT_INFO = _AT_INFO;

function InitNETAPI: Boolean;
procedure FreeNETAPI;

type
  TNetQueryDisplayInformation = function(ServerName: LPCWSTR; Level: DWORD;
                                    Index: DWORD; EntriesRequested: DWORD;
                                    PrefMaxLen: DWORD;
                                    var ReturnedEntryCount: DWORD;
                                    var SortedBuffer: Pointer): NET_API_STATUS; stdcall;

  TNetStatisticsGet = function (ServerName: LPWSTR; Service: LPWSTR; Level: DWORD;
                          Options: DWORD; var BufPtr: Pointer): NET_API_STATUS; stdcall;

  TNetWkstaGetInfo = function(ServerName: LPWSTR; Level: DWORD;
                         var Bufptr: Pointer): NET_API_STATUS; stdcall;

  TNetWkstaUserEnum = function(ServerName: LPWSTR; Level: DWORD;
                          var BufPtr: Pointer; PrefMaxLen: DWORD;
                          var EntriesRead: DWORD;
                          var TotalEntries: DWORD;
                          var ResumeHandle: DWORD): NET_API_STATUS; stdcall;

  TNetWkstaUserGetInfo = function(Reserved: LPWSTR; Level: DWORD;
                             var BufPtr: Pointer): NET_API_STATUS; stdcall;

  TNetWkstaTransportEnum = function(ServerName: LPWSTR; Level: DWORD;
                          var BufPtr: Pointer; PrefMaxLen: DWORD;
                          var EntriesRead: DWORD;
                          var TotalEntries: DWORD;
                          var ResumeHandle: DWORD): NET_API_STATUS; stdcall;

  TNetServerTransportEnum = function(ServerName: LPWSTR; Level: DWORD;
                          var BufPtr: Pointer; PrefMaxLen: DWORD;
                          var EntriesRead: DWORD;
                          var TotalEntries: DWORD;
                          var ResumeHandle: DWORD): NET_API_STATUS; stdcall;

  TNetUserEnum = function(ServerName: LPWSTR; Level: DWORD; Filter: DWORD;
                     var Bufptr: Pointer; PrefMaxLen: DWORD;
                     var EntriesRead: DWORD;
                     var TotalEntries: DWORD;
                     var ResumeHandle: DWORD): NET_API_STATUS; stdcall;

  TNetUserGetInfo = function (ServerName: LPWSTR; UserName: LPWSTR;  Level: DWORD;
                        var Bufptr: Pointer): NET_API_STATUS; stdcall;

  TNetUserGetGroups = function(ServerName: LPWSTR; UserName: LPCWSTR; Level: DWORD;
                          var BufPtr: Pointer; PrefMaxLen: DWORD;
                          var EntriesRead: DWORD;
                          var TotalEntries: DWORD): NET_API_STATUS; stdcall;

  TNetUserGetLocalGroups = function(ServerName: LPWSTR; UserName: LPCWSTR;
                          Level: DWORD; Flags: DWORD;
                          var BufPtr: Pointer; PrefMaxLen: DWORD;
                          var EntriesRead: DWORD;
                          var TotalEntries: DWORD): NET_API_STATUS; stdcall;

  TNetGroupEnum = function(ServerName: LPWSTR; Level: DWORD;
                           var BufPtr: Pointer; PrefMaxLen: DWORD;
                           var EntriesRead: DWORD;
                           var TotalEntries: DWORD;
                           var ResumeHandle: DWORD): NET_API_STATUS; stdcall;

  TNetLocalGroupEnum = function(ServerName: LPWSTR; Level: DWORD;
                           var BufPtr: Pointer; PrefMaxLen: DWORD;
                           var EntriesRead: DWORD;
                           var TotalEntries: DWORD;
                           var ResumeHandle: DWORD): NET_API_STATUS; stdcall;

  TNetGroupGetUsers = function(ServerName: LPWSTR; GroupName: LPCWSTR; Level: DWORD;
                          var BufPtr: Pointer; PrefMaxLen: DWORD;
                          var EntriesRead: DWORD;
                          var TotalEntries: DWORD;
                          var ResumeHandle: DWORD): NET_API_STATUS; stdcall;

  TNetLocalGroupGetMembers = function(ServerName: LPWSTR; GroupName: LPCWSTR; Level: DWORD;
                          var BufPtr: Pointer; PrefMaxLen: DWORD;
                          var EntriesRead: DWORD;
                          var TotalEntries: DWORD;
                          var ResumeHandle: DWORD): NET_API_STATUS; stdcall;

  TNetServerEnum = function (ServerName: LPWSTR; Level: DWORD;
                       var Bufptr: Pointer; PrefMaxLen: DWORD;
                       var EntriesRead: DWORD;
                       var TotalEntries: DWORD;  ServerType: DWORD;  Domain: LPWSTR;
                       var ResumeHandle: DWORD): NET_API_STATUS; stdcall;

  TNetShareEnum = function(ServerName: LPWSTR; Level: DWORD;
                      var BufPtr: Pointer; PrefMaxLength: DWORD;
                      var EntriesRead: DWORD;
                      var TotalEntries: DWORD;
                      var ResumeHandle: DWORD): NET_API_STATUS; stdcall;

  TNetShareDel = function(ServerName: LPWSTR; NetName: LPWSTR; Reserved: DWORD): NET_API_STATUS; stdcall;

  TNetSessionEnum = function(ServerName: LPWSTR; UncClientName: LPWSTR; UserName: LPWSTR;
                      Level: DWORD;
                      var BufPtr: Pointer; PrefMaxLength: DWORD;
                      var EntriesRead: DWORD;
                      var TotalEntries: DWORD;
                      var ResumeHandle: DWORD): NET_API_STATUS; stdcall;

  TNetSessionDel = function(ServerName: LPWSTR; UncClientName: LPWSTR; Username: LPWSTR): NET_API_STATUS; stdcall;

  TNetConnectionEnum = function(ServerName: LPWSTR; Qualifier: LPWSTR;
                      Level: DWORD;
                      var BufPtr: Pointer; PrefMaxLength: DWORD;
                      var EntriesRead: DWORD;
                      var TotalEntries: DWORD;
                      var ResumeHandle: DWORD): NET_API_STATUS; stdcall;

  TNetFileEnum = function(ServerName: LPWSTR; BasePath: LPWSTR; UserName: LPWSTR;
                      Level: DWORD;
                      var BufPtr: Pointer; PrefMaxLength: DWORD;
                      var EntriesRead: DWORD;
                      var TotalEntries: DWORD;
                      var ResumeHandle: DWORD): NET_API_STATUS; stdcall;

  TNetFileClose = function(ServerName: LPWSTR; FileID: DWORD): NET_API_STATUS; stdcall;

  TNetScheduleJobAdd = function(ServerName : LPWSTR;
                           Buffer : pointer;
                           var JobID : DWORD) : NET_API_STATUS; stdcall;
  TNetScheduleJobDel = function(ServerName : LPWSTR;
                           MinJobID,
                           MaxJobID : DWORD) : NET_API_STATUS; stdcall;
  TNetScheduleJobEnum = function(ServerName : LPWSTR;
                             var buffer : pointer;
                             PrefMaximumLength : DWORD;
                             var EntriesRead :DWord;
                             var TotalEntries :DWord;
                             var ResumeHandle : DWord) : NET_API_STATUS; stdcall;
  TNetScheduleJobGetInfo = function(ServerName : LPWSTR;
                               JobId : DWORD;
                               var buffer : pointer) : NET_API_STATUS; stdcall;

  TNetApiBufferFree = function (buffer: Pointer): NET_API_STATUS; stdcall;

  TNetApiBufferReallocate = function(OldBuffer : Pointer;
                                NewByteCount : DWORD;
                                var NewBuffer : Pointer) : NET_API_STATUS; stdcall;
  TNetApiBufferSize = function(buffer : Pointer;
                          var byteCount : DWORD) : NET_API_STATUS; stdcall;

var
  NetQueryDisplayInformation: TNetQueryDisplayInformation = nil;
  NetStatisticsGet: TNetStatisticsGet = nil;
  NetWkstaGetInfo: TNetWkstaGetInfo = nil;
  NetWkstaUserEnum: TNetWkstaUserEnum = nil;
  NetWkstaUserGetInfo: TNetWkstaUserGetInfo = nil;
  NetServerTransportEnum: TNetServerTransportEnum = nil;
  NetWkstaTransportEnum: TNetWkstaTransportEnum = nil;
  NetServerEnum: TNetServerEnum = nil;
  NetUserEnum: TNetUserEnum = nil;
  NetUserGetInfo: TNetUserGetInfo = nil;
  NetUserGetGroups: TNetUserGetGroups = nil;
  NetUserGetLocalGroups: TNetUserGetLocalGroups = nil;
  NetGroupEnum: TNetGroupEnum = nil;
  NetLocalGroupEnum: TNetLocalGroupEnum = nil;
  NetGroupGetUsers: TNetGroupGetUsers = nil;
  NetLocalGroupGetMembers: TNetLocalGroupGetMembers = nil;
  NetShareEnum: TNetShareEnum = nil;
  NetShareDel: TNetShareDel = nil;
  NetSessionEnum: TNetSessionEnum = nil;
  NetSessionDel: TNetSessionDel = nil;
  NetConnectionEnum: TNetConnectionEnum = nil;
  NetFileEnum: TNetFileEnum = nil;
  NetFileClose: TNetFileClose = nil;
  NetApiBufferFree: TNetApiBufferFree = nil;
  NetApiBufferReallocate: TNetApiBufferReallocate = nil;
  NetApiBufferSize: TNetApiBufferSize = nil;
  NetScheduleJobEnum: TNetScheduleJobEnum = nil;
  NetScheduleJobDel: TNetScheduleJobDel = nil;
  NetScheduleJobAdd: TNetScheduleJobAdd = nil;
  NetScheduleJobGetInfo: TNetScheduleJobGetInfo = nil;


implementation

const
  NETAPI_DLL = 'netapi32.dll';

var
  NETAPIHandle: THandle;

function InitNETAPI: Boolean;
begin
  NETAPIHandle:=GetModuleHandle(NETAPI_DLL);
  if NETAPIHandle=0 then
    NETAPIHandle:=loadlibrary(NETAPI_DLL);
  if NETAPIHandle<>0 then begin
    @NetQueryDisplayInformation:=GetProcAddress(NETAPIHandle,PChar('NetQueryDisplayInformation'));
    @NetStatisticsGet:=GetProcAddress(NETAPIHandle,PChar('NetStatisticsGet'));
    @NetWkstaGetInfo:=GetProcAddress(NETAPIHandle,PChar('NetWkstaGetInfo'));
    @NetWkstaUserGetInfo:=GetProcAddress(NETAPIHandle,PChar('NetWkstaUserGetInfo'));
    @NetUserEnum:=GetProcAddress(NETAPIHandle,PChar('NetUserEnum'));
    @NetWkstaUserEnum:=GetProcAddress(NETAPIHandle,PChar('NetWkstaUserEnum'));
    @NetWkstaTransportEnum:=GetProcAddress(NETAPIHandle,PChar('NetWkstaTransportEnum'));
    @NetServerTransportEnum:=GetProcAddress(NETAPIHandle,PChar('NetServerTransportEnum'));
    @NetUserGetInfo:=GetProcAddress(NETAPIHandle,PChar('NetUserGetInfo'));
    @NetUserGetGroups:=GetProcAddress(NETAPIHandle,PChar('NetUserGetGroups'));
    @NetUserGetLocalGroups:=GetProcAddress(NETAPIHandle,PChar('NetUserGetLocalGroups'));
    @NetGroupEnum:=GetProcAddress(NETAPIHandle,PChar('NetGroupEnum'));
    @NetLocalGroupEnum:=GetProcAddress(NETAPIHandle,PChar('NetLocalGroupEnum'));
    @NetGroupGetUsers:=GetProcAddress(NETAPIHandle,PChar('NetGroupGetUsers'));
    @NetLocalGroupGetMembers:=GetProcAddress(NETAPIHandle,PChar('NetLocalGroupGetMembers'));
    @NetServerEnum:=GetProcAddress(NETAPIHandle,PChar('NetServerEnum'));
    @NetShareEnum:=GetProcAddress(NETAPIHandle,PChar('NetShareEnum'));
    @NetShareDel:=GetProcAddress(NETAPIHandle,PChar('NetShareDel'));
    @NetSessionEnum:=GetProcAddress(NETAPIHandle,PChar('NetSessionEnum'));
    @NetSessionDel:=GetProcAddress(NETAPIHandle,PChar('NetSessionDel'));
    @NetConnectionEnum:=GetProcAddress(NETAPIHandle,PChar('NetConnectionEnum'));
    @NetFileEnum:=GetProcAddress(NETAPIHandle,PChar('NetFileEnum'));
    @NetFileClose:=GetProcAddress(NETAPIHandle,PChar('NetFileClose'));
    @NetApiBufferFree:=GetProcAddress(NETAPIHandle,PChar('NetApiBufferFree'));
    @NetApiBufferReallocate:=GetProcAddress(NETAPIHandle,PChar('NetApiBufferReallocate'));
    @NetApiBufferSize:=GetProcAddress(NETAPIHandle,PChar('NetApiBufferSize'));
    @NetScheduleJobEnum:=GetProcAddress(NETAPIHandle,PChar('NetScheduleJobEnum'));
    @NetScheduleJobDel:=GetProcAddress(NETAPIHandle,PChar('NetScheduleJobDel'));
    @NetScheduleJobAdd:=GetProcAddress(NETAPIHandle,PChar('NetScheduleJobAdd'));
    @NetScheduleJobGetInfo:=GetProcAddress(NETAPIHandle,PChar('NetScheduleJobGetInfo'));
  end;
  result:=(NETAPIHandle<>0) and Assigned(NetWkstaGetInfo);
end;

procedure FreeNETAPI;
begin
  if NetAPIHandle<>0 then begin
    if not FreeLibrary(NetAPIHandle) then
      Exception.Create('Unload Error: '+NetAPI_DLL+' ('+inttohex(getmodulehandle(NetAPI_DLL),8)+')')
    else
      NetAPIHandle:=0;
  end;
end;


initialization
finalization
  FreeNETAPI;
end.
