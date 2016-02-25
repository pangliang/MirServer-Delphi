{*******************************************************}
{                                                       }
{               MiTeC NT DDK Header                     }
{           version 8.6 for Delphi 5,6,7                }
{                                                       }
{           Copyright © 2003,2004 Michal Mutl           }
{                                                       }
{*******************************************************}

unit MiTeC_NTDDK;

interface

uses Windows, SysUtils;


type UCHAR = Byte;
type USHORT = Word;
type ULONG = LongInt;

type
  CM_RESOURCE_TYPE = integer;


const
  CmResourceTypeNull                   = 0; { ResType_All or ResType_None (0x0000)}
  CmResourceTypePort                   = 1; { ResType_IO (0x0002)}
  CmResourceTypeInterrupt              = 2; { ResType_IRQ (0x0004)}
  CmResourceTypeMemory                 = 3; { ResType_Mem (0x0001)}
  CmResourceTypeDma                    = 4; { ResType_DMA (0x0003)}
  CmResourceTypeDeviceSpecific         = 5; { ResType_ClassSpecific (0xFFFF)}
  CmResourceTypeBusNumber              = 6; { ResType_BusNumber (0x0006)}
  CmResourceTypeMaximum                = 7;
  CmResourceTypeAssignedResource       = 8; { BUGBUG--remove}
  CmResourceTypeSubAllocateFrom        = 9; { BUGBUG--remove}
  CmResourceTypeNonArbitrated          = 128; { Not arbitrated if 0x80 bit set}
  CmResourceTypeConfigData             = 128; { ResType_Reserved (0x8000) }
  CmResourceTypeDevicePrivate          = 129; { ResType_DevicePrivate (0x8001) }
  CmResourceTypePcCardConfig           = 130; { ResType_PcCardConfig (0x8002) }

{ Defines the ShareDisposition in the RESOURCE_DESCRIPTOR }
type
  CM_SHARE_DISPOSITION = (

        CmResourceShareUndetermined,

        CmResourceShareDeviceExclusive,{ Reserved }
        CmResourceShareDriverExclusive);


{ Define the bit masks for Flags common for all CM_RESOURCE_TYPE }

const
  CM_RESOURCE_COMMON_COMPUTE_LENGTH_FROM_DEPENDENTS = $8000;

  CM_RESOURCE_COMMON_NOT_REASSIGNED    = $4000;

  CM_RESOURCE_COMMON_SUBSTRACTIVE      = $2000;


{ Define the bit masks for Flags when type is CmResourceTypeInterrupt }
  CM_RESOURCE_INTERRUPT_LEVEL_SENSITIVE = 0;
  CM_RESOURCE_INTERRUPT_LATCHED        = 1;


{ Define the bit masks for Flags when type is CmResourceTypeMemory }

  CM_RESOURCE_MEMORY_READ_WRITE        = $0000;
  CM_RESOURCE_MEMORY_READ_ONLY         = $0001;

  CM_RESOURCE_MEMORY_WRITE_ONLY        = $0002;

  CM_RESOURCE_MEMORY_PREFETCHABLE      = $0004;


  CM_RESOURCE_MEMORY_COMBINEDWRITE     = $0008;

  CM_RESOURCE_MEMORY_24                = $0010;


{ Define the bit masks for Flags when type is CmResourceTypePort }
  CM_RESOURCE_PORT_MEMORY              = $0000;
  CM_RESOURCE_PORT_IO                  = $0001;


  CM_RESOURCE_PORT_FORWARD_FIRST_256_OF_EACH_1024 = $0002; { BUGBUG--remove }

  CM_RESOURCE_PORT_10_BIT_DECODE       = $0004;
  CM_RESOURCE_PORT_12_BIT_DECODE       = $0008;

  CM_RESOURCE_PORT_16_BIT_DECODE       = $0010;

  CM_RESOURCE_PORT_POSITIVE_DECODE     = $0020;


{ Define the bit masks for Flags when type is CmResourceTypeDma }

  CM_RESOURCE_DMA_8                    = $0000;
  CM_RESOURCE_DMA_16                   = $0001;

  CM_RESOURCE_DMA_32                   = $0002;



{ Define the bit masks for Flags when type is CmResourceTypeBusNumber }
  CM_RESOURCE_BUSNUMBER_SUBALLOCATE_FIRST_VALUE = $0001; { BUGBUG--remove }

{ Define the bit masks for Flags when type is CmResourceTypeSubAllocateFrom }
  CM_RESOURCE_SUBALLOCATEFROM_FIXED_TRANSLATION = $0001; { BUGBUG--remove }

  CM_RESOURCE_SUBALLOCATEFROM_WIRED_TRANSLATION = $0002; { BUGBUG--remove }

type
  PHYSICAL_ADDRESS = LARGE_INTEGER;

  { Range of resources, inclusive.  These are physical, bus relative. }
  { It is known that Port and Memory below have the exact same layout }
  { as Generic. }
  PRDD_Generic = ^RDD_Generic;
  RDD_Generic = record
    Start: PHYSICAL_ADDRESS;
    Length: Cardinal;
  end;

  { Range of port numbers, inclusive. These are physical, bus }
  { relative. The value should be the same as the one passed to }
  { HalTranslateBusAddress(). }
  PRDD_Port = ^RDD_Port;
  RDD_Port = record
    Start: PHYSICAL_ADDRESS;
    Length: Cardinal;
  end;

  { IRQL and vector. Should be same values as were passed to }
  { HalGetInterruptVector(). }
  PRDD_Interrupt = ^RDD_Interrupt;
  RDD_Interrupt =  record
    Level: cardinal;

    Vector: cardinal;

    Affinity: cardinal;

  end;

  { Range of memory addresses, inclusive. These are physical, bus }
  { relative. The value should be the same as the one passed to }
  { HalTranslateBusAddress(). }
  PRDD_Memory = ^RDD_Memory;
  RDD_Memory = record
    Start: PHYSICAL_ADDRESS;
    Length: Cardinal;
  end;

  { Physical DMA channel. }
  PRDD_DMA = ^RDD_DMA;
  RDD_DMA = record
    Channel: cardinal;

    Port: cardinal;

    Reserved1: cardinal;

  end;

  { Device driver private data, usually used to help it figure }
  { what the resource assignments decisions that were made. }
  PRDD_DevicePrivate = ^RDD_DevicePrivate;
  RDD_DevicePrivate = record
    Data: array [0..2] of cardinal;

  end;

  { Bus Number information. }
  PRDD_BusNumber = ^RDD_BusNumber;
  RDD_BusNumber = record
    Start: cardinal;

    Length: cardinal;

    Reserved: cardinal;

  end;

  { Device Specific information defined by the driver. }
  { The DataSize field indicates the size of the data in bytes. The }
  { data is located immediately after the DeviceSpecificData field in }
  { the structure. }
  PRDD_DeviceSpecificData = ^RDD_DeviceSpecificData;
  RDD_DeviceSpecificData = record
    DataSize: cardinal;

    Reserved1: cardinal;

    Reserved2: cardinal;

  end;

  _CM_PARTIAL_RESOURCE_DESCRIPTOR = record
     Typ: Byte;

     ShareDisposition: CM_SHARE_DISPOSITION;

     Flags: smallint;

     case integer of

      0: (Generic: RDD_Generic);
      1: (Port: RDD_Port);
      2: (Interrupt: RDD_Interrupt);

      3: (Memory: RDD_Memory);
      4: (Dma: RDD_DMA);

      5: (DevicePrivate: RDD_DevicePrivate);
      6: (BusNumber: RDD_BusNumber);
      7: (DeviceSpecificData: RDD_DeviceSpecificData);

  end;
  CM_PARTIAL_RESOURCE_DESCRIPTOR = _CM_PARTIAL_RESOURCE_DESCRIPTOR;

  PCM_PARTIAL_RESOURCE_DESCRIPTOR = _CM_PARTIAL_RESOURCE_DESCRIPTOR;

  _CM_PARTIAL_RESOURCE_LIST = record
    Version: USHORT;
    Revision: USHORT;
    Count: ULONG;
    PartialDescriptors: CM_PARTIAL_RESOURCE_DESCRIPTOR;
  end;
  CM_PARTIAL_RESOURCE_LIST = _CM_PARTIAL_RESOURCE_LIST;
  PCM_PARTIAL_RESOURCE_LIST = ^_CM_PARTIAL_RESOURCE_LIST;

{ Define the I/O bus interface types. }
  INTERFACE_TYPE = (
              InterfaceTypeUndefined,           //-1

              Internal,

              Isa,

              Eisa,

              MicroChannel,

              TurboChannel,

              PCIBus,

              VMEBus,

              NuBus,

              PCMCIABus,

              CBus,

              MPIBus,

              MPSABus,

              ProcessorInternal,

              InternalPowerBus,

              PNPISABus,

              PNPBus);

{ Define the DMA transfer widths. }
  DMA_WIDTH = (
              Width8Bits,

              Width16Bits,

              Width32Bits);


{ Define DMA transfer speeds. }

     DMA_SPEED = (
              Compatible,

              TypeA,

              TypeB,

              TypeC);


{ Define types of bus information. }

     BUS_DATA_TYPE = (
              ConfigurationSpaceUndefined,  //-1

              Cmos,

              EisaConfiguration,

              Pos1,

              CbusConfiguration,

              PCIConfiguration,

              VMEConfiguration,

              NuBusConfiguration,

              PCMCIAConfiguration,

              MPIConfiguration,

              MPSAConfiguration,

              PNPISAConfiguration);


  _CM_FULL_RESOURCE_DESCRIPTOR = record
    InterfaceType: INTERFACE_TYPE;
    BusNumber: ULONG;
    PartialResourceList: CM_PARTIAL_RESOURCE_LIST;
  end;
  CM_FULL_RESOURCE_DESCRIPTOR = _CM_FULL_RESOURCE_DESCRIPTOR;
  PCM_FULL_RESOURCE_DESCRIPTOR = ^_CM_FULL_RESOURCE_DESCRIPTOR;

  _CM_RESOURCE_LIST = record
    Count: ULONG;
    List: CM_FULL_RESOURCE_DESCRIPTOR;
  end;
  CM_RESOURCE_LIST = _CM_RESOURCE_LIST;
  PCM_RESOURCE_LIST = ^_CM_RESOURCE_LIST;

{ my implementation of structures above to read from registry }

type
  PResourceListHeader = ^TResourceListHeader;
  TResourceListHeader = record
    Count: DWORD;
  end;

  PFullResourceDescriptorHeader = ^TFullResourceDescriptorHeader;
  TFullResourceDescriptorHeader = record
    InterfaceType: INTERFACE_TYPE;
    BusNumber: DWORD;
  end;

  PPartialResourceListHeader = ^TPartialResourceListHeader;
  TPartialResourceListHeader = record
    Version: WORD;
    Revision: WORD;
    Count: DWORD;
  end;

  PPartialResourceDescriptorHeader = ^TPartialResourceDescriptorHeader;
  TPartialResourceDescriptorHeader = record
    Typ: Byte;
    ShareDisposition: CM_SHARE_DISPOSITION;
    Flags: WORD;
  end;

  TDeviceResources = record
    InterfaceType: INTERFACE_TYPE;
    BusNumber: DWORD;
    Version: WORD;
    Revision: WORD;
    Resources: array of CM_PARTIAL_RESOURCE_DESCRIPTOR;
  end;

procedure ReadDeviceResourcesFromRegistry(AKey: HKEY; Avalue: string; var DeviceResources: TDeviceResources);
procedure BufferToResourceList(Buffer: PChar; DataSize: integer; var DeviceResources: TDeviceResources);


function DeviceResourceTypeStr(AType: DWORD): string;
function DeviceIntfTypeStr(AIntf: INTERFACE_TYPE): string;
function ResourceShareStr(AType: CM_SHARE_DISPOSITION): string;
function InterruptTypeStr(AType: DWORD): string;
function MemoryAccessStr(AType: DWORD): string;
function PortTypeStr(AType: DWORD): string;

implementation

procedure ReadDeviceResourcesFromRegistry;
var
  Data: PChar;
  DataSize, DataType: Integer;
begin
  try
    RegQueryValueEx(AKey,PChar(AValue),nil,PDWORD(@DataType),nil,PDWORD(@DataSize));
    Data:=AllocMem(DataSize);
    try
      RegQueryValueEx(AKey,PChar(AValue),nil,PDWORD(@DataType),PByte(Data),PDWORD(@DataSize));
      BufferToResourceList(Data,DataSize,DeviceResources);
    finally
      Freemem(Data);
    end;
  finally
  end;
end;

procedure BufferToResourceList;
var
  p, ResType: Integer; //_W_ DataType
  prd: CM_PARTIAL_RESOURCE_DESCRIPTOR;
begin
  SetLength(DeviceResources.Resources,0);
  try
      p:=0;
      p:=p+SizeOf(TResourceListHeader);
      DeviceResources.InterfaceType:=INTERFACE_TYPE(Integer(PFullResourceDescriptorHeader(Buffer+p)^.InterfaceType)+1);
      DeviceResources.BusNumber:=PFullResourceDescriptorHeader(Buffer+p)^.BusNumber;
      p:=p+SizeOf(TFullResourceDescriptorHeader);
      DeviceResources.Version:=PPartialResourceListHeader(Buffer+p)^.Version;
      DeviceResources.Revision:=PPartialResourceListHeader(Buffer+p)^.Revision;
      p:=p+sizeof(TPartialResourceListHeader);
      while p<DataSize-sizeof(TPartialResourceListHeader) do begin
        ResType:=PPartialResourceDescriptorHeader(Buffer+p)^.Typ;
        prd.Typ:=ResType;
        prd.ShareDisposition:=PPartialResourceDescriptorHeader(Buffer+p)^.ShareDisposition;
        prd.Flags:=PPartialResourceDescriptorHeader(Buffer+p)^.Flags;
        p:=p+sizeof(TPartialResourceDescriptorHeader);
        case ResType of
          CmResourceTypeNull: begin
            prd.Generic:=PRDD_Generic(Buffer+p)^;
            p:=p+sizeof(RDD_Generic)-4;
          end;
          CmResourceTypePort: begin
            prd.Port:=PRDD_Port(Buffer+p)^;
            p:=p+sizeof(RDD_Port)-4;
          end;
          CmResourceTypeInterrupt: begin
            prd.Interrupt:=PRDD_Interrupt(Buffer+p)^;
            p:=p+sizeof(RDD_Interrupt);
          end;
          CmResourceTypeMemory: begin
            prd.Memory:=PRDD_Memory(Buffer+p)^;
            p:=p+sizeof(RDD_Memory)-4;
          end;
          CmResourceTypeDma: begin
            prd.DMA:=PRDD_DMA(Buffer+p)^;
            p:=p+SizeOf(RDD_DMA);
          end;
          CmResourceTypeDeviceSpecific: begin
            prd.DevicePrivate:=PRDD_DevicePrivate(Buffer+p)^;
            p:=p+sizeof(RDD_DeviceSpecificData);
          end;
          CmResourceTypeBusNumber: begin
            prd.BusNumber:=PRDD_BusNumber(Buffer+p)^;
            p:=p+sizeof(RDD_BusNumber);
          end;
          CmResourceTypeMaximum: begin
            prd.DeviceSpecificData:=PRDD_DeviceSpecificData(Buffer+p)^;
            p:=p+sizeof(RDD_DeviceSpecificData);
          end;
          else
             p:=p+SizeOf(RDD_BusNumber);
        end;
        if ResType in [CmResourceTypeNull..CmResourceTypeMaximum] then begin
          SetLength(DeviceResources.Resources,Length(DeviceResources.Resources)+1);
          DeviceResources.Resources[High(DeviceResources.Resources)]:=prd;
        end;
      end;
  finally
  end;
end;


function DeviceResourceTypeStr;
begin
  case AType of
    CmResourceTypeNull: Result:='None';
    CmResourceTypePort: Result:='Port';
    CmResourceTypeInterrupt: Result:='IRQ';
    CmResourceTypeMemory: Result:='Memory';
    CmResourceTypeDma: Result:='DMA';
    CmResourceTypeDeviceSpecific: Result:='DeviceSpecific';
    CmResourceTypeBusNumber: Result:='BusNumber';
    CmResourceTypeMaximum: Result:='Maximum';
    CmResourceTypeAssignedResource: Result:='AssignedResource';
    CmResourceTypeSubAllocateFrom: Result:='SubAllocateFrom';
    //CmResourceTypeNonArbitrated: Result:='NonArbitrared';
    CmResourceTypeConfigData: Result:='ConfigData';
    CmResourceTypeDevicePrivate: Result:='DevicePrivate';
    CmResourceTypePcCardConfig: Result:='PCCardConfig';
  end;
end;

function DeviceIntfTypeStr;
begin
  case AIntf of
    InterfaceTypeUndefined: Result:='Invalid';
    Internal: Result:='Internal';

    Isa: Result:='ISA';

    Eisa: Result:='EISA';

    MicroChannel: Result:='MCA';

    TurboChannel: Result:='TurboChannel';

    PCIBus: Result:='PCI';

    VMEBus: Result:='VME';

    NuBus: Result:='NuBus';

    PCMCIABus: Result:='PCMCIA';

    CBus: Result:='CBus';

    MPIBus: Result:='MPI';

    MPSABus: Result:='MPSA';

    ProcessorInternal: Result:='ProcessorInternal';

    InternalPowerBus: Result:='InternalPowerBus';

    PNPISABus: Result:='PnP-ISA';

    PNPBus: Result:='PnP';
  end;
end;

function ResourceShareStr;
begin
  case AType of
    CmResourceShareUndetermined: Result:='Undetermined';
    CmResourceShareDeviceExclusive: Result:='Device Exclusive';
    CmResourceShareDriverExclusive: Result:='Driver Exclusive';
    else
      Result:='Shared';
  end;
end;

function InterruptTypeStr;
begin
  case AType of
    CM_RESOURCE_INTERRUPT_LEVEL_SENSITIVE: Result:='Level Sensitive';
    CM_RESOURCE_INTERRUPT_LATCHED: Result:='Latched';
    else
      Result:=Format('0x%x',[AType]);
  end;
end;

function MemoryAccessStr;
begin
  case AType of
    CM_RESOURCE_MEMORY_READ_WRITE: Result:='Read / Write';
    CM_RESOURCE_MEMORY_READ_ONLY: Result:='Read Only';

    CM_RESOURCE_MEMORY_WRITE_ONLY: Result:='Write Only';

    CM_RESOURCE_MEMORY_PREFETCHABLE: Result:='Prefetchable';


    CM_RESOURCE_MEMORY_COMBINEDWRITE: Result:='Combined Write';

    CM_RESOURCE_MEMORY_24: Result:='24';
    else
      Result:=Format('0x%x',[AType]);end;
end;

function PortTypeStr;
begin
  case AType of
    CM_RESOURCE_PORT_MEMORY: Result:='Memory';
    CM_RESOURCE_PORT_IO: Result:='Port';

    CM_RESOURCE_PORT_10_BIT_DECODE: Result:='10-bit decode';

    CM_RESOURCE_PORT_12_BIT_DECODE: Result:='12-bit decode';

    CM_RESOURCE_PORT_16_BIT_DECODE: Result:='16-bit decode';

    CM_RESOURCE_PORT_POSITIVE_DECODE: Result:='Positive decode';
    else
      Result:=Format('0x%x',[AType]);
  end;
end;

end.
