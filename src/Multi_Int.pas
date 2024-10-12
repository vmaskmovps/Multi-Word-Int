unit Multi_Int;

(*
Multi-Word-Int by ad1mt (Mark Taylor)

To the extent possible under law, the person who associated CC0 with
Multi-Word-Int has waived all copyright and related or neighboring rights
to adm1t (Mark Taylor).

You should have received a copy of the CC0 legalcode along with this
work.  If not, see <https://creativecommons.org/publicdomain/zero/1.0/>.
*)

// {$MODE DELPHI}
{$MODE OBJFPC}
{$MODESWITCH ADVANCEDRECORDS}
{$MODESWITCH NESTEDCOMMENTS+}

(* USER OPTIONAL DEFINES *)

// This should be changed to 32bit if you wish to override the default/detected setting
// E.g. if your compiler is 64bit but you want to generate code for 32bit integers,
// you would remove the "{$define CPU_64}" and replace it with "{$define CPU_32}"
// In 99.9% of cases, you should leave this to default, unless you have problems
// running the code in a 32bit environment.

{$IFDEF CPU64}
  {$define CPU_64}
{$ELSE}
{$define CPU_32}
{$ENDIF}

// This define is essential to make exceptions work correctly
// for floating-point operations on Intel 32 bit CPU's.
// Do not remove this define.

{$ifdef CPU_32}
{$SAFEFPUEXCEPTIONS ON}
{$endif}

interface

uses
  SysUtils,
  strutils,
  MultiInt.Bool;

const
  version = '4.60.00';

const
  Multi_X2_maxi    = 3;
  Multi_X2_maxi_x2 = 7;
  Multi_X2_size    = Multi_X2_maxi + 1;

  Multi_X3_maxi    = 5;
  Multi_X3_maxi_x2 = 11;
  Multi_X3_size    = Multi_X3_maxi + 1;

  Multi_X4_maxi    = 7;
  Multi_X4_maxi_x2 = 15;
  Multi_X4_size    = Multi_X4_maxi + 1;

const
  INT8_MAX     = 127;
  INT8_MAX_1   = INT8_MAX + 1;
  UINT8_MAX    = 255;
  UINT8_MAX_1  = UINT8_MAX + 1;
  INT16_MAX    = 32767;
  INT16_MAX_1  = INT16_MAX + 1;
  UINT16_MAX   = 65535;
  UINT16_MAX_1 = UINT16_MAX + 1;
  INT32_MAX    = 2147483647;
  INT32_MAX_1  = INT32_MAX + 1;
  UINT32_MAX   = 4294967295;
  UINT32_MAX_1 = UINT32_MAX + 1;
  INT64_MAX    = 9223372036854775807;
  INT64_MAX_1  = INT64_MAX + 1;
  UINT64_MAX   = 18446744073709551615;
  UINT64_MAX_1 = 18446744073709551616;

  SINGLE_TYPE_MAXVAL = '9999999999999999999999999999';
  REAL_TYPE_MAXVAL   =
    '99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999';
  DOUBLE_TYPE_MAXVAL =
    '99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999';

  SINGLE_TYPE_PRECISION_DIGITS = 7;
  REAL_TYPE_PRECISION_DIGITS   = 15;
  DOUBLE_TYPE_PRECISION_DIGITS = 15;

type
  TMultiUInt8  = byte;
  TMultiInt8   = shortint;
  TMultiInt16  = smallint;
  TMultiUInt16 = word;
  TMultiInt32  = longint;
  TMultiUInt32 = longword;
  TMultiInt64  = QWord;
  TMultiUInt64 = int64;

const
  INT_1W_SIZE = {$ifdef CPU_32}16{$else}32{$endif};
  INT_2W_SIZE = {$ifdef CPU_32}32{$else}64{$endif};

  {$ifdef CPU_32}
  INT_4W_SIZE = 64;
  {$endif}

  {$ifdef CPU_32}
  INT_1W_S_MAXINT   = INT16_MAX;
  INT_1W_S_MAXINT_1 = INT16_MAX_1;
  INT_1W_U_MAXINT   = UINT16_MAX;
  INT_1W_U_MAXINT_1 = UINT16_MAX_1;

  INT_2W_S_MAXINT   = INT32_MAX;
  INT_2W_S_MAXINT_1 = INT32_MAX_1;
  INT_2W_U_MAXINT   = UINT32_MAX;
  INT_2W_U_MAXINT_1 = UINT32_MAX_1;
  {$else}
    INT_1W_S_MAXINT   = INT32_MAX;
    INT_1W_S_MAXINT_1 = INT32_MAX_1;
    INT_1W_U_MAXINT   = UINT32_MAX;
    INT_1W_U_MAXINT_1 = UINT32_MAX_1;

    INT_2W_S_MAXINT   = INT64_MAX;
    INT_2W_S_MAXINT_1 = INT64_MAX_1;
    INT_2W_U_MAXINT   = UINT64_MAX;
    INT_2W_U_MAXINT_1 = UINT64_MAX_1;
  {$endif}

  {$ifdef CPU_32}
  INT_4W_S_MAXINT   = INT64_MAX;
  INT_4W_S_MAXINT_1 = INT64_MAX_1;
  INT_4W_U_MAXINT   = UINT64_MAX;
  INT_4W_U_MAXINT_1 = UINT64_MAX_1;
  {$endif}

type
  {$ifdef CPU_32}
  INT_1W_S = TMultiInt16;
  INT_1W_U = TMultiUInt16;
  INT_2W_S = TMultiInt32;
  INT_2W_U = TMultiUInt16;
  {$else}
    INT_1W_S          = TMultiInt32;
    INT_1W_U          = TMultiUInt16;
    INT_2W_S          = TMultiUInt64;
    INT_2W_U          = TMultiInt64;
  {$endif}

  {$ifdef CPU_32}
  INT_4W_S = TMultiUInt64;
  INT_4W_U = TMultiInt64;
  {$endif}

type
  TMultiLeadingZeros = (KeepLeadingZeros, TrimLeadingZeros);
  TMultiBitMode      = (UndefinedBitMode, BitMode32, BitMode64);

  TMultiUBoolState = MultiInt.Bool.TTriBoolState;
  TMultiUBool      = MultiInt.Bool.TTriBool;

  TMultiIntX2 = record
  private
    FHasOverflow: boolean;
    FIsDefined: boolean;
    FIsNegative: TMultiUBool;
    FParts: array[0..Multi_X2_maxi] of INT_1W_U;
  public
    function ToString: ansistring; inline;
    function ToHexString(const LeadingZeroMode: TMultiLeadingZeros =
      TrimLeadingZeros): ansistring; inline;
    function ToBinaryString(const LeadingZeroMode: TMultiLeadingZeros =
      TrimLeadingZeros): ansistring; inline;
    function FromHexString(const AStr: ansistring): TMultiIntX2; inline;
    function FromBinaryString(const AStr: ansistring): TMultiIntX2; inline;

    function HasOverflow: boolean; inline;
    function IsNegative: boolean; inline;
    function IsDefined: boolean; inline;

    class operator := (const A: TMultiIntX2): TMultiUInt8; inline;
    class operator := (const A: TMultiIntX2): TMultiInt8; inline;

    class operator := (const A: TMultiIntX2): INT_1W_U; inline;
    class operator := (const A: TMultiIntX2): INT_1W_S; inline;
    class operator := (const A: TMultiIntX2): INT_2W_U; inline;
    class operator := (const A: TMultiIntX2): INT_2W_S; inline;

    class operator := (const A: INT_2W_S): TMultiIntX2; inline;
    class operator := (const A: INT_2W_U): TMultiIntX2; inline;

    {$ifdef CPU_32}
    class operator := (const A: INT_4W_S): TMultiIntX2; inline;
    class operator := (const A: INT_4W_U): TMultiIntX2; inline;
    {$endif}

    class operator := (const A: ansistring): TMultiIntX2; inline;
    class operator := (const A: TMultiIntX2): ansistring; inline;
    class operator := (const A: single): TMultiIntX2; inline;
    class operator := (const A: real): TMultiIntX2; inline;
    class operator := (const A: double): TMultiIntX2; inline;
    class operator := (const A: TMultiIntX2): single; inline;
    class operator := (const A: TMultiIntX2): real; inline;
    class operator := (const A: TMultiIntX2): double; inline;
    class operator +(const A, B: TMultiIntX2): TMultiIntX2; inline;
    class operator -(const A, B: TMultiIntX2): TMultiIntX2; inline;
    class operator Inc(const A: TMultiIntX2): TMultiIntX2; inline;
    class operator Dec(const A: TMultiIntX2): TMultiIntX2; inline;
    class operator >(const A, B: TMultiIntX2): boolean; inline;
    class operator <(const A, B: TMultiIntX2): boolean; inline;
    class operator =(const A, B: TMultiIntX2): boolean; inline;
    class operator <>(const A, B: TMultiIntX2): boolean; inline;
    class operator *(const A, B: TMultiIntX2): TMultiIntX2; inline;
    class operator div(const A, B: TMultiIntX2): TMultiIntX2; inline;
    class operator mod(const A, B: TMultiIntX2): TMultiIntX2; inline;
    class operator xor(const A, B: TMultiIntX2): TMultiIntX2; inline;
    class operator or(const A, B: TMultiIntX2): TMultiIntX2; inline;
    class operator and(const A, B: TMultiIntX2): TMultiIntX2; inline;
    class operator not(const A: TMultiIntX2): TMultiIntX2; inline;
    class operator -(const A: TMultiIntX2): TMultiIntX2; inline;
    class operator >=(const A, B: TMultiIntX2): boolean; inline;
    class operator <=(const A, B: TMultiIntX2): boolean; inline;
    class operator **(const A: TMultiIntX2; const P: INT_2W_S): TMultiIntX2; inline;
    class operator shr(const A: TMultiIntX2;
      const B: INT_1W_U): TMultiIntX2; inline;
    class operator shl(const A: TMultiIntX2;
      const B: INT_1W_U): TMultiIntX2; inline;
  end;


  TMultiIntX3 = record
  private
    FHasOverflow: boolean;
    FIsDefined: boolean;
    FIsNegative: TMultiUBool;
    FParts: array[0..Multi_X3_maxi] of INT_1W_U;
  public
    function ToString: ansistring; inline;
    function ToHexString(const LeadingZeroMode: TMultiLeadingZeros =
      TrimLeadingZeros): ansistring; inline;
    function ToBinaryString(const LeadingZeroMode: TMultiLeadingZeros =
      TrimLeadingZeros): ansistring; inline;
    function FromHexString(const A: ansistring): TMultiIntX3; inline;
    function FromBinaryString(const A: ansistring): TMultiIntX3; inline;
    function HasOverflow: boolean; inline;
    function IsNegative: boolean; inline;
    function IsDefined: boolean; inline;
    class operator := (const A: TMultiIntX3): TMultiUInt8; inline;
    class operator := (const A: TMultiIntX3): TMultiInt8; inline;
    class operator := (const A: TMultiIntX3): INT_1W_U; inline;
    class operator := (const A: TMultiIntX3): INT_1W_S; inline;
    class operator := (const A: TMultiIntX3): INT_2W_U; inline;
    class operator := (const A: TMultiIntX3): INT_2W_S; inline;
    class operator := (const A: INT_2W_S): TMultiIntX3; inline;
    class operator := (const A: INT_2W_U): TMultiIntX3; inline;
    {$ifdef CPU_32}
    class operator := (const A: INT_4W_S): TMultiIntX3; inline;
    class operator := (const A: INT_4W_U): TMultiIntX3; inline;
    {$endif}
    class operator := (const A: TMultiIntX2): TMultiIntX3; inline;
    class operator := (const A: ansistring): TMultiIntX3; inline;
    class operator := (const A: TMultiIntX3): ansistring; inline;
    class operator := (const A: single): TMultiIntX3; inline;
    class operator := (const A: real): TMultiIntX3; inline;
    class operator := (const A: double): TMultiIntX3; inline;
    class operator := (const A: TMultiIntX3): real; inline;
    class operator := (const A: TMultiIntX3): single; inline;
    class operator := (const A: TMultiIntX3): double; inline;
    class operator +(const A, B: TMultiIntX3): TMultiIntX3; inline;
    class operator -(const A, B: TMultiIntX3): TMultiIntX3; inline;
    class operator Inc(const A: TMultiIntX3): TMultiIntX3; inline;
    class operator Dec(const A: TMultiIntX3): TMultiIntX3; inline;
    class operator >(const A, B: TMultiIntX3): boolean; inline;
    class operator <(const A, B: TMultiIntX3): boolean; inline;
    class operator =(const A, B: TMultiIntX3): boolean; inline;
    class operator <>(const A, B: TMultiIntX3): boolean; inline;
    class operator *(const A, B: TMultiIntX3): TMultiIntX3; inline;
    class operator div(const A, B: TMultiIntX3): TMultiIntX3; inline;
    class operator mod(const A, B: TMultiIntX3): TMultiIntX3; inline;
    class operator xor(const A, B: TMultiIntX3): TMultiIntX3; inline;
    class operator or(const A, B: TMultiIntX3): TMultiIntX3; inline;
    class operator and(const A, B: TMultiIntX3): TMultiIntX3; inline;
    class operator not(const A: TMultiIntX3): TMultiIntX3; inline;
    class operator -(const A: TMultiIntX3): TMultiIntX3; inline;
    class operator >=(const A, B: TMultiIntX3): boolean; inline;
    class operator <=(const A, B: TMultiIntX3): boolean; inline;
    class operator **(const A: TMultiIntX3; const P: INT_2W_S): TMultiIntX3; inline;
    class operator shr(const A: TMultiIntX3;
      const B: INT_1W_U): TMultiIntX3; inline;
    class operator shl(const A: TMultiIntX3;
      const B: INT_1W_U): TMultiIntX3; inline;
  end;


  TMultiIntX4 = record
  private
    FHasOverflow: boolean;
    FIsDefined: boolean;
    FIsNegative: TMultiUBool;
    FParts: array[0..Multi_X4_maxi] of INT_1W_U;
  public
    function ToString: ansistring; inline;
    function ToHexString(const LeadingZeroMode: TMultiLeadingZeros =
      TrimLeadingZeros): ansistring; inline;
    function ToBinaryString(const LeadingZeroMode: TMultiLeadingZeros =
      TrimLeadingZeros): ansistring; inline;
    function FromHexString(const A: ansistring): TMultiIntX4; inline;
    function FromBinaryString(const A: ansistring): TMultiIntX4; inline;
    function HasOverflow: boolean; inline;
    function IsNegative: boolean; inline;
    function IsDefined: boolean; inline;
    class operator := (const A: TMultiIntX4): TMultiUInt8; inline;
    class operator := (const A: TMultiIntX4): TMultiInt8; inline;
    class operator := (const A: TMultiIntX4): INT_1W_U; inline;
    class operator := (const A: TMultiIntX4): INT_1W_S; inline;
    class operator := (const A: TMultiIntX4): INT_2W_U; inline;
    class operator := (const A: TMultiIntX4): INT_2W_S; inline;
    class operator := (const A: INT_2W_S): TMultiIntX4; inline;
    class operator := (const A: INT_2W_U): TMultiIntX4; inline;
    {$ifdef CPU_32}
    class operator := (const A: INT_4W_S): TMultiIntX4; inline;
    class operator := (const A: INT_4W_U): TMultiIntX4; inline;
    {$endif}
    class operator := (const A: TMultiIntX2): TMultiIntX4; inline;
    class operator := (const A: TMultiIntX3): TMultiIntX4; inline;
    class operator := (const A: ansistring): TMultiIntX4; inline;
    class operator := (const A: TMultiIntX4): ansistring; inline;
    class operator := (const A: single): TMultiIntX4; inline;
    class operator := (const A: real): TMultiIntX4; inline;
    class operator := (const A: double): TMultiIntX4; inline;
    class operator := (const A: TMultiIntX4): single; inline;
    class operator := (const A: TMultiIntX4): real; inline;
    class operator := (const A: TMultiIntX4): double; inline;
    class operator +(const A, B: TMultiIntX4): TMultiIntX4; inline;
    class operator -(const A, B: TMultiIntX4): TMultiIntX4; inline;
    class operator Inc(const A: TMultiIntX4): TMultiIntX4; inline;
    class operator Dec(const A: TMultiIntX4): TMultiIntX4; inline;
    class operator >(const A, B: TMultiIntX4): boolean; inline;
    class operator <(const A, B: TMultiIntX4): boolean; inline;
    class operator =(const A, B: TMultiIntX4): boolean; inline;
    class operator <>(const A, B: TMultiIntX4): boolean; inline;
    class operator *(const A, B: TMultiIntX4): TMultiIntX4; inline;
    class operator div(const A, B: TMultiIntX4): TMultiIntX4; inline;
    class operator mod(const A, B: TMultiIntX4): TMultiIntX4; inline;
    class operator xor(const A, B: TMultiIntX4): TMultiIntX4; inline;
    class operator or(const A, B: TMultiIntX4): TMultiIntX4; inline;
    class operator and(const A, B: TMultiIntX4): TMultiIntX4; inline;
    class operator not(const A: TMultiIntX4): TMultiIntX4; inline;
    class operator -(const A: TMultiIntX4): TMultiIntX4; inline;
    class operator >=(const A, B: TMultiIntX4): boolean; inline;
    class operator <=(const A, B: TMultiIntX4): boolean; inline;
    class operator **(const A: TMultiIntX4; const P: INT_2W_S): TMultiIntX4; inline;
    class operator shr(const A: TMultiIntX4;
      const NBits: INT_1W_U): TMultiIntX4; inline;
    class operator shl(const A: TMultiIntX4;
      const NBits: INT_1W_U): TMultiIntX4; inline;
  end;


  TMultiIntXV = record
  private
    FHasOverflow: boolean;
    FIsDefined: boolean;
    FPartsSize: INT_2W_U;
    FIsNegative: TMultiUBool;
    FParts: array of INT_1W_U;
  public
    procedure Initialize; inline;
    function ToString: ansistring; inline;
    function ToHexString(const LeadingZeroMode: TMultiLeadingZeros =
      TrimLeadingZeros): ansistring; inline;
    function ToBinaryString(const LeadingZeroMode: TMultiLeadingZeros =
      TrimLeadingZeros): ansistring; inline;
    function FromHexString(const A: ansistring): TMultiIntXV; inline;
    function FromBinaryString(const A: ansistring): TMultiIntXV; inline;
    function HasOverflow: boolean; inline;
    function IsNegative: boolean; inline;
    function IsDefined: boolean; inline;
    class operator := (const A: TMultiIntXV): TMultiUInt8; inline;
    class operator := (const A: TMultiIntXV): TMultiInt8; inline;
    class operator := (const A: TMultiIntXV): INT_1W_U; inline;
    class operator := (const A: TMultiIntXV): INT_1W_S; inline;
    class operator := (const A: TMultiIntXV): INT_2W_U; inline;
    class operator := (const A: TMultiIntXV): INT_2W_S; inline;
    class operator := (const A: TMultiIntX2): TMultiIntXV; inline;
    class operator := (const A: TMultiIntX3): TMultiIntXV; inline;
    class operator := (const A: TMultiIntX4): TMultiIntXV; inline;
    class operator := (const A: INT_2W_S): TMultiIntXV; inline;
    class operator := (const A: INT_2W_U): TMultiIntXV; inline;
    {$ifdef CPU_32}
    class operator := (const A: INT_4W_S): TMultiIntXV; inline;
    class operator := (const A: INT_4W_U): TMultiIntXV; inline;
    {$endif}
    class operator := (const A: ansistring): TMultiIntXV; inline;
    class operator := (const A: TMultiIntXV): ansistring; inline;
    class operator := (const A: single): TMultiIntXV; inline;
    class operator := (const A: TMultiIntXV): single; inline;
    class operator := (const A: real): TMultiIntXV; inline;
    class operator := (const A: TMultiIntXV): real; inline;
    class operator := (const A: double): TMultiIntXV; inline;
    class operator := (const A: TMultiIntXV): double; inline;
    class operator +(const A, B: TMultiIntXV): TMultiIntXV; inline;
    class operator >(const A, B: TMultiIntXV): boolean; inline;
    class operator <(const A, B: TMultiIntXV): boolean; inline;
    class operator =(const A, B: TMultiIntXV): boolean; inline;
    class operator <>(const A, B: TMultiIntXV): boolean; inline;
    class operator -(const A, B: TMultiIntXV): TMultiIntXV; inline;
    class operator Inc(const A: TMultiIntXV): TMultiIntXV; inline;
    class operator Dec(const A: TMultiIntXV): TMultiIntXV; inline;
    class operator *(const A, B: TMultiIntXV): TMultiIntXV; inline;
    class operator div(const A, B: TMultiIntXV): TMultiIntXV; inline;
    class operator mod(const A, B: TMultiIntXV): TMultiIntXV; inline;
    class operator xor(const A, B: TMultiIntXV): TMultiIntXV; inline;
    class operator or(const A, B: TMultiIntXV): TMultiIntXV; inline;
    class operator and(const A, B: TMultiIntXV): TMultiIntXV; inline;
    class operator not(const A: TMultiIntXV): TMultiIntXV; inline;
    class operator -(const A: TMultiIntXV): TMultiIntXV; inline;
    class operator >=(const A, B: TMultiIntXV): boolean; inline;
    class operator <=(const A, B: TMultiIntXV): boolean; inline;
    class operator **(const A: TMultiIntXV; const P: INT_2W_S): TMultiIntXV; inline;
    class operator shr(const A: TMultiIntXV;
      const NBits: INT_2W_U): TMultiIntXV; inline;
    class operator shl(const A: TMultiIntXV;
      const NBits: INT_2W_U): TMultiIntXV; inline;
  end;

var
  MultiIntEnableExceptions: boolean = True;
  MultiIntError: boolean = False;
  Multi_Int_X2_MAXINT: TMultiIntX2;
  Multi_Int_X3_MAXINT: TMultiIntX3;
  Multi_Int_X4_MAXINT: TMultiIntX4;
  Multi_Int_XV_MAXINT: TMultiIntXV;

procedure Multi_Int_Initialisation(const P_Multi_XV_size: INT_2W_U = 16); inline;
procedure Multi_Int_Set_XV_Limit(const S: INT_2W_U); inline;
procedure Multi_Int_Reset_X2_Last_Divisor; inline;
procedure Multi_Int_Reset_X3_Last_Divisor; inline;
procedure Multi_Int_Reset_X4_Last_Divisor; inline;
procedure Multi_Int_Reset_XV_Last_Divisor; inline;

function Odd(const A: TMultiIntXV): boolean; overload; inline;
function Odd(const A: TMultiIntX4): boolean; overload; inline;
function Odd(const A: TMultiIntX3): boolean; overload; inline;
function Odd(const A: TMultiIntX2): boolean; overload; inline;

function Even(const A: TMultiIntXV): boolean; overload; inline;
function Even(const A: TMultiIntX4): boolean; overload; inline;
function Even(const A: TMultiIntX3): boolean; overload; inline;
function Even(const A: TMultiIntX2): boolean; overload; inline;

function Abs(const A: TMultiIntX2): TMultiIntX2; overload; inline;
function Abs(const A: TMultiIntX3): TMultiIntX3; overload; inline;
function Abs(const A: TMultiIntX4): TMultiIntX4; overload; inline;
function Abs(const A: TMultiIntXV): TMultiIntXV; overload; inline;

function Negative(const A: TMultiIntX2): boolean; overload; inline;
function Negative(const A: TMultiIntX3): boolean; overload; inline;
function Negative(const A: TMultiIntX4): boolean; overload; inline;
function Negative(const A: TMultiIntXV): boolean; overload; inline;

procedure SqRoot(const A: TMultiIntXV; out VR, VREM: TMultiIntXV); overload; inline;
procedure SqRoot(const A: TMultiIntX4; out VR, VREM: TMultiIntX4); overload; inline;
procedure SqRoot(const A: TMultiIntX3; out VR, VREM: TMultiIntX3); overload; inline;
procedure SqRoot(const A: TMultiIntX2; out VR, VREM: TMultiIntX2); overload; inline;

procedure SqRoot(const A: TMultiIntXV; out VR: TMultiIntXV); overload; inline;
procedure SqRoot(const A: TMultiIntX4; out VR: TMultiIntX4); overload; inline;
procedure SqRoot(const A: TMultiIntX3; out VR: TMultiIntX3); overload; inline;
procedure SqRoot(const A: TMultiIntX2; out VR: TMultiIntX2); overload; inline;

function SqRoot(const A: TMultiIntXV): TMultiIntXV; overload; inline;
function SqRoot(const A: TMultiIntX4): TMultiIntX4; overload; inline;
function SqRoot(const A: TMultiIntX3): TMultiIntX3; overload; inline;
function SqRoot(const A: TMultiIntX2): TMultiIntX2; overload; inline;

procedure FromHex(const A: ansistring; out B: TMultiIntX2); overload; inline;
procedure FromHex(const A: ansistring; out B: TMultiIntX3); overload; inline;
procedure FromHex(const A: ansistring; out B: TMultiIntX4); overload; inline;
procedure FromHex(const A: ansistring; out B: TMultiIntXV); overload; inline;

procedure FromBin(const A: ansistring; out mi: TMultiIntX2); overload; inline;
procedure FromBin(const A: ansistring; out mi: TMultiIntX3); overload; inline;
procedure FromBin(const A: ansistring; out mi: TMultiIntX4); overload; inline;
procedure FromBin(const A: ansistring; out mi: TMultiIntXV); overload; inline;

procedure Hex_to_Multi_Int_X2(const A: ansistring; out mi: TMultiIntX2);
  overload; inline;
procedure Hex_to_Multi_Int_X3(const A: ansistring; out mi: TMultiIntX3);
  overload; inline;
procedure Hex_to_Multi_Int_X4(const A: ansistring; out mi: TMultiIntX4);
  overload; inline;
procedure Hex_to_Multi_Int_XV(const A: ansistring; out mi: TMultiIntXV);
  overload; inline;

procedure bin_to_Multi_Int_X2(const A: ansistring; out m: TMultiIntX2);
  overload; inline;
procedure bin_to_Multi_Int_X3(const A: ansistring; out mi: TMultiIntX3);
  overload; inline;
procedure bin_to_Multi_Int_X4(const A: ansistring; out mi: TMultiIntX4);
  overload; inline;
procedure bin_to_Multi_Int_XV(const A: ansistring; out mi: TMultiIntXV);
  overload; inline;

function To_Multi_Int_XV(const A: TMultiIntX4): TMultiIntXV; overload; inline;
function To_Multi_Int_XV(const A: TMultiIntX3): TMultiIntXV; overload; inline;
function To_Multi_Int_XV(const A: TMultiIntX2): TMultiIntXV; overload; inline;

function To_Multi_Int_X4(const A: TMultiIntXV): TMultiIntX4; overload; inline;
function To_Multi_Int_X4(const A: TMultiIntX3): TMultiIntX4; overload; inline;
function To_Multi_Int_X4(const A: TMultiIntX2): TMultiIntX4; overload; inline;

function To_Multi_Int_X3(const A: TMultiIntXV): TMultiIntX3; overload; inline;
function To_Multi_Int_X3(const A: TMultiIntX4): TMultiIntX3; overload; inline;
function To_Multi_Int_X3(const A: TMultiIntX2): TMultiIntX3; overload; inline;

function To_Multi_Int_X2(const A: TMultiIntXV): TMultiIntX2; overload; inline;
function To_Multi_Int_X2(const A: TMultiIntX4): TMultiIntX2; overload; inline;
function To_Multi_Int_X2(const A: TMultiIntX3): TMultiIntX2; overload; inline;


implementation

const
  Multi_X5_max = 8;
  Multi_X5_maxi = 7;
  Multi_X5_max_x2 = 16;
  Multi_X5_size = Multi_X4_maxi + 1;

type

  (* Multi_Int_X5 FOR INTERNAL USE ONLY! *)

  Multi_Int_X5 = record
  private
    M_Value: array[0..Multi_X5_max] of INT_1W_U;
    Negative_flag: TMultiUBool;
    Overflow_flag: boolean;
    Defined_flag: boolean;
  public
    function Negative: boolean;
    class operator := (const A: INT_2W_U): Multi_Int_X5;
    class operator := (const A: TMultiIntX4): Multi_Int_X5;
    class operator >=(const A, B: Multi_Int_X5): boolean;
    class operator >(const A, B: Multi_Int_X5): boolean;
    class operator *(const A, B: Multi_Int_X5): Multi_Int_X5;
    class operator -(const A, B: Multi_Int_X5): Multi_Int_X5;
  end;


  (******************************************)
var

  Multi_Init_Initialisation_done: boolean = False;
  Multi_XV_size: INT_2W_U = 0;
  Multi_XV_limit: INT_2W_U = 0;
  Multi_XV_maxi: INT_2W_U;

  X2_Last_Divisor, X2_Last_Dividend, X2_Last_Quotient, X2_Last_Remainder: TMultiIntX2;

  X3_Last_Divisor, X3_Last_Dividend, X3_Last_Quotient, X3_Last_Remainder: TMultiIntX3;

  X4_Last_Divisor, X4_Last_Dividend, X4_Last_Quotient, X4_Last_Remainder: TMultiIntX4;

  XV_Last_Divisor, XV_Last_Dividend, XV_Last_Quotient, XV_Last_Remainder: TMultiIntXV;

  (******************************************)

procedure ShiftUp_NBits_Multi_Int_X3(var A: TMultiIntX3; NBits: INT_1W_U);
  forward; inline;
procedure ShiftDown_MultiBits_Multi_Int_X3(var A: TMultiIntX3; NBits: INT_1W_U);
  forward; inline;
procedure ShiftUp_NBits_Multi_Int_X4(var A: TMultiIntX4; NBits: INT_1W_U);
  forward; inline;
procedure ShiftDown_MultiBits_Multi_Int_X4(var A: TMultiIntX4; NBits: INT_1W_U);
  forward; inline;
procedure ShiftUp_NBits_Multi_Int_X5(var A: Multi_Int_X5; NBits: INT_1W_U);
  forward; inline;
procedure ShiftDown_MultiBits_Multi_Int_X5(var A: Multi_Int_X5; NBits: INT_1W_U);
  forward; inline;
function To_Multi_Int_X5(const A: TMultiIntX4): Multi_Int_X5; forward; inline;
function Multi_Int_X2_to_X3_multiply(const A, B: TMultiIntX2): TMultiIntX3;
  forward; inline;
function Multi_Int_X3_to_X4_multiply(const A, B: TMultiIntX3): TMultiIntX4;
  forward; inline;
function Multi_Int_X4_to_X5_multiply(const A, B: TMultiIntX4): Multi_Int_X5;
  forward; inline;
function To_Multi_Int_X4(const A: Multi_Int_X5): TMultiIntX4; forward; overload; inline;

function LeadingZeroCount(A: INT_1W_U): INT_1W_U;
var
  n: TMultiInt32;
begin
  if A = 0 then
    {$ifdef CPU_32}
    Exit(16);
    {$else}
    Exit(32);
    {$endif}

  n := 0;

  {$ifdef CPU_32}
  if (A and $FF00) = 0 then
  begin
    Inc(n, 8);
    A := A shl 8;
  end;

  if (A and $F000) = 0 then
  begin
    Inc(n, 4);
    A := A shl 4;
  end;

  if (A and $C000) = 0 then
  begin
    Inc(n, 2);
    A := A shl 2;
  end;

  if (A and $8000) = 0 then
    Inc(n);
  {$else}
   if (A shr 16) = 0 then
    begin
      Inc(n, 16);
      A := A shl 16;
    end;

    if (A shr 24) = 0 then
    begin
      Inc(n, 8);
      A := A shl 8;
    end;

    if (A shr 28) = 0 then
    begin
      Inc(n, 4);
      A := A shl 4;
    end;

    if (A shr 30) = 0 then
    begin
      Inc(n, 2);
      A := A shl 2;
    end;

    if (A shr 31) = 0 then
      Inc(n);
  {$endif}

  Result := n;
end;


{
******************************************
TMultiIntX2
******************************************
}

function ABS_greaterthan_Multi_Int_X2(const A, B: TMultiIntX2): boolean;
var
  i: integer;
begin
  for i := 3 downto 0 do
  begin
    if A.FParts[i] > B.FParts[i] then
      Exit(True);

    if A.FParts[i] < B.FParts[i] then
      Exit(False);
  end;

  Result := False;
end;


(******************************************)
function ABS_lessthan_Multi_Int_X2(const A, B: TMultiIntX2): boolean;
var
  i: integer;
begin
  for i := 3 downto 0 do
  begin
    if A.FParts[i] < B.FParts[i] then
      Exit(True);

    if A.FParts[i] > B.FParts[i] then
      Exit(False);
  end;

  Result := False;
end;


(******************************************)
function ABS_equal_Multi_Int_X2(const A, B: TMultiIntX2): boolean;
var
  i: integer;
begin
  Result := True;

  for i := 3 downto 0 do
    if A.FParts[i] <> B.FParts[i] then
      Exit(False);
end;

(******************************************)
function ABS_notequal_Multi_Int_X2(const A, B: TMultiIntX2): boolean;
begin
  Result := not ABS_equal_Multi_Int_X2(A, B);
end;


(******************************************)
function LeadingZeroCountX2(A: TMultiIntX2): INT_1W_U;
var
  i: integer;
  leadingZerosCount: TMultiInt32;
begin
  leadingZerosCount := 0;

  for i := Multi_X2_maxi downto 0 do
  begin
    if A.FParts[i] <> 0 then
      Exit(leadingZerosCount);

    Inc(leadingZerosCount);
  end;

  Result := leadingZerosCount;
end;


(******************************************)
function LeadingZeroCountMultiBitsX2(const A: TMultiIntX2): INT_1W_U;
var
  leadingZeroParts: INT_1W_U;
begin
  if not A.FIsDefined then
  begin
    Result := 0;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
  end;

  leadingZeroParts := LeadingZeroCountX2(A);

  if leadingZeroParts <= Multi_X2_maxi then
    Result :=
      LeadingZeroCount(A.FParts[Multi_X2_maxi - leadingZeroParts]) +
      (leadingZeroParts * INT_1W_SIZE)
  else
    Result := (leadingZeroParts * INT_1W_SIZE);
end;


(******************************************)
function TMultiIntX2.IsDefined: boolean; inline;
begin
  Result := Self.FIsDefined;
end;


(******************************************)
function TMultiIntX2.HasOverflow: boolean; inline;
begin
  Result := Self.FHasOverflow;
end;


(******************************************)
function Overflow(const A: TMultiIntX2): boolean; overload; inline;
begin
  Result := A.FHasOverflow;
end;


(******************************************)
function TMultiIntX2.IsNegative: boolean; inline;
begin
  Result := Self.FIsNegative;
end;


(******************************************)
function Negative(const A: TMultiIntX2): boolean; overload; inline;
begin
  Result := A.FIsNegative;
end;


(******************************************)
function Abs(const A: TMultiIntX2): TMultiIntX2; overload;
begin
  Result := A;
  Result.FIsNegative := uBoolFalse;

  if not A.FIsDefined then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
  end;
end;


(******************************************)
function Defined(const A: TMultiIntX2): boolean; overload; inline;
begin
  Result := A.FIsDefined;
end;


(******************************************)
function Multi_Int_X2_Odd(const A: TMultiIntX2): boolean; inline;
var
  Mask: INT_1W_U;
begin

  if not A.FIsDefined then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
  end;

  Mask   := $1;
  Result := (A.FParts[0] and Mask) = Mask;
end;


(******************************************)
function Odd(const A: TMultiIntX2): boolean; overload;
begin
  Result := Multi_Int_X2_Odd(A);
end;


(******************************************)
function Multi_Int_X2_Even(const A: TMultiIntX2): boolean; inline;
begin
  Result := not Odd(A);
end;


(******************************************)
function Even(const A: TMultiIntX2): boolean; overload;
begin
  Result := Multi_Int_X2_Even(A);
end;


{$ifdef CPU_64}
procedure ShiftUp_NBits_Multi_Int_X2(var A: TMultiIntX2; NBits: INT_1W_U);
var
  Mask, NBitsCarry: INT_1W_U;
  i: Integer;

  procedure ShiftPart(var Part: INT_1W_U; const N: INT_1W_U); inline;
  begin
    Part := INT_1W_U((Part shl N) and INT_1W_U_MAXINT);
  end;
begin
  if NBits = 0 then
     Exit;

  Mask := $FFFF;
  NBitsCarry := INT_1W_SIZE - NBits;
  ShiftPart(Mask, NBitsCarry);

  if NBits > INT_1W_SIZE then
     raise ERangeError.Create('NBits exceeds the size of a part.');

  for i := 0 to 3 do
    ShiftPart(A.FParts[i], (A.FParts[i] and Mask) shr NBitsCarry);
end;
{$endif}

{$ifdef CPU_32}
(******************************************)
procedure ShiftUp_NBits_Multi_Int_X2(var A: TMultiIntX2; NBits: INT_1W_U);
var
  Mask, NBitsCarry: INT_1W_U;
  i: integer;
  carry_bits_1, carry_bits_2: INT_1W_U;

  procedure ShiftPart(var Part: INT_1W_U; const N: INT_1W_U;
  const CarryBits: INT_1W_U); inline;
  begin
    Part := (Part shl N) or CarryBits;
    Part := INT_1W_U(Part and INT_1W_U_MAXINT);
  end;

begin
  if NBits = 0 then
    Exit;

  Mask := $FFFFFFFF;
  NBitsCarry := INT_1W_SIZE - NBits;
  Mask := (Mask shl NBitsCarry);

  if NBits > INT_1W_SIZE then
    raise ERangeError.Create('NBits exceeds the size of a part.');

  carry_bits_1 := ((A.FParts[0] and Mask) shr NBitsCarry);
  ShiftPart(A.FParts[0], NBits, 0);

  carry_bits_2 := ((A.FParts[1] and Mask) shr NBitsCarry);
  ShiftPart(A.FParts[1], NBits, carry_bits_1);

  carry_bits_1 := ((A.FParts[2] and Mask) shr NBitsCarry);
  ShiftPart(A.FParts[2], NBits, carry_bits_2);

  ShiftPart(A.FParts[3], NBits, carry_bits_1);
end;

{$endif}


(******************************************)
procedure ShiftUp_NWords_Multi_Int_X2(var A: TMultiIntX2; NWords: INT_1W_U);
var
  n: INT_1W_U;
begin
  if NWords <= 0 then
    Exit;

  if NWords > Multi_X2_maxi then
  begin
    A.FParts[0] := 0;
    A.FParts[1] := 0;
    A.FParts[2] := 0;
    A.FParts[3] := 0;
    Exit;
  end;

  for n := 0 to NWords - 1 do
  begin
    A.FParts[3] := A.FParts[2];
    A.FParts[2] := A.FParts[1];
    A.FParts[1] := A.FParts[0];
    A.FParts[0] := 0;
  end;
end;


{******************************************}
procedure ShiftUp_MultiBits_Multi_Int_X2(var A: TMultiIntX2; NBits: INT_1W_U);
var
  WordCount, BitCount: INT_1W_U;
begin
  if not A.FIsDefined then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if NBits = 0 then
    Exit;

  if NBits >= INT_1W_SIZE then
  begin
    WordCount := (NBits div INT_1W_SIZE);
    BitCount  := (NBits mod INT_1W_SIZE);
    ShiftUp_NWords_Multi_Int_X2(A, WordCount);
  end
  else
    BitCount := NBits;

  ShiftUp_NBits_Multi_Int_X2(A, BitCount);
end;


(******************************************)
procedure ShiftDown_NBits_Multi_Int_X2(var A: TMultiIntX2; NBits: INT_1W_U);
var
  CarryBits: array[0..3] of INT_1W_U;
  NBitsCarry, Mask: INT_1W_U;
begin
  if NBits > 0 then
  begin
    {$ifdef CPU_32}
    Mask := $FFFF;
    {$endif}
    {$ifdef CPU_64}
      Mask := $FFFFFFFF;
    {$endif}

    NBitsCarry := INT_1W_SIZE - NBits;
    Mask := (Mask shr NBitsCarry);

    CarryBits[3] := ((A.FParts[3] and Mask) shl NBitsCarry);
    A.FParts[3]  := (A.FParts[3] shr NBits);

    CarryBits[2] := ((A.FParts[2] and Mask) shl NBitsCarry);
    A.FParts[2]  := ((A.FParts[2] shr NBits) or CarryBits[3]);

    CarryBits[1] := ((A.FParts[1] and Mask) shl NBitsCarry);
    A.FParts[1]  := ((A.FParts[1] shr NBits) or CarryBits[2]);

    A.FParts[0] := ((A.FParts[0] shr NBits) or CarryBits[1]);
  end;
end;



(******************************************)
procedure ShiftDown_NWords_Multi_Int_X2(var A: TMultiIntX2; NWords: INT_1W_U);
var
  n: INT_1W_U;
begin
  if NWords <= 0 then
    Exit;

  if NWords > Multi_X2_maxi then
  begin
    A.FParts[0] := 0;
    A.FParts[1] := 0;
    A.FParts[2] := 0;
    A.FParts[3] := 0;
    Exit;
  end;

  for n := 0 to NWords - 1 do
  begin
    A.FParts[3] := A.FParts[2];
    A.FParts[2] := A.FParts[1];
    A.FParts[1] := A.FParts[0];
    A.FParts[0] := 0;
  end;
end;


{******************************************}
procedure ShiftDown_MultiBits_Multi_Int_X2(var A: TMultiIntX2; NBits: INT_1W_U);
var
  WordCount, BitCount: INT_1W_U;
begin
  if not A.FIsDefined then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (NBits >= INT_1W_SIZE) then
  begin
    WordCount := NBits div INT_1W_SIZE;
    BitCount  := NBits mod INT_1W_SIZE;
    ShiftDown_NWords_Multi_Int_X2(A, WordCount);
  end
  else
    BitCount := NBits;

  ShiftDown_NBits_Multi_Int_X2(A, BitCount);
end;


{******************************************}
class operator TMultiIntX2.shl(const A: TMultiIntX2; const B: INT_1W_U): TMultiIntX2;
begin
  Result := A;
  ShiftUp_MultiBits_Multi_Int_X2(Result, B);
end;


{******************************************}
class operator TMultiIntX2.shr(const A: TMultiIntX2; const B: INT_1W_U): TMultiIntX2;
begin
  Result := A;
  ShiftDown_MultiBits_Multi_Int_X2(Result, B);
end;


(******************************************)
class operator TMultiIntX2.<=(const A, B: TMultiIntX2): boolean;
begin
  Result := not (A > B);
end;


(******************************************)
class operator TMultiIntX2.>=(const A, B: TMultiIntX2): boolean;
begin
  Result := not (B > A);
end;


(******************************************)
class operator TMultiIntX2.>(const A, B: TMultiIntX2): boolean;
begin
  Result := (B < A);
end;



(******************************************)
class operator TMultiIntX2.<(const A, B: TMultiIntX2): boolean;
begin
  if not A.FIsDefined or (not B.FIsDefined) or (A.FHasOverflow) or
    (B.FHasOverflow) then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialized variable');
    Result := False;
    Exit;
  end;

  if A.FIsNegative <> B.FIsNegative then
  begin
    Result := A.FIsNegative;
    Exit;
  end;

  if A.FIsNegative then
    Result := ABS_greaterthan_Multi_Int_X2(A, B)
  else
    Result := ABS_lessthan_Multi_Int_X2(A, B);
end;



(******************************************)
class operator TMultiIntX2.=(const A, B: TMultiIntX2): boolean;
begin
  if not A.FIsDefined or (not B.FIsDefined) or (A.FHasOverflow) or
    (B.FHasOverflow) then
  begin
    Result := False;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  Result := True;
  if (A.FIsNegative <> B.FIsNegative) then
    Result := False
  else
    Result := ABS_equal_Multi_Int_X2(A, B);
end;


(******************************************)
class operator TMultiIntX2.<>(const A, B: TMultiIntX2): boolean;
begin
  Result := not (A = B);
end;


(******************************************)
procedure String_to_Multi_Int_X2(const A: ansistring; out m: TMultiIntX2); inline;
var
  i, startIndex, currentIndex, endIndex: INT_2W_U;
  Parts: array[0..Multi_X2_maxi] of INT_2W_U;
  IsNegative, IsZero: boolean;
begin
  MultiIntError := False;

  m.FHasOverflow := False;
  m.FIsDefined := True;
  m.FIsNegative := False;
  IsNegative := False;
  IsZero := False;

  Parts[0] := 0;
  Parts[1] := 0;
  Parts[2] := 0;
  Parts[3] := 0;

  if Length(A) = 0 then
    Exit;

  startIndex := low(ansistring);
  endIndex   := startIndex + INT_2W_U(length(A)) - 1;

  if A[startIndex] = '-' then
  begin
    IsNegative := True;
    Inc(startIndex);
  end;

  currentIndex := startIndex;
  while currentIndex <= endIndex do
  begin
    try
      i := StrToInt(A[currentIndex]);
    except
      on EConvertError do
      begin
        MultiIntError  := True;
        m.FHasOverflow := True;
        m.FIsDefined   := False;
        if MultiIntEnableExceptions then
          raise;
        Exit;
      end;
    end;

    Parts[0] := (Parts[0] * 10) + i;
    Parts[1] := (Parts[1] * 10);
    Parts[2] := (Parts[2] * 10);
    Parts[3] := (Parts[3] * 10);

    if Parts[0] > INT_1W_U_MAXINT then
    begin
      Parts[1] := Parts[1] + (Parts[0] div INT_1W_U_MAXINT_1);
      Parts[0] := (Parts[0] mod INT_1W_U_MAXINT_1);
    end;

    if Parts[1] > INT_1W_U_MAXINT then
    begin
      Parts[2] := Parts[2] + (Parts[1] div INT_1W_U_MAXINT_1);
      Parts[1] := (Parts[1] mod INT_1W_U_MAXINT_1);
    end;

    if Parts[2] > INT_1W_U_MAXINT then
    begin
      Parts[3] := Parts[3] + (Parts[2] div INT_1W_U_MAXINT_1);
      Parts[2] := (Parts[2] mod INT_1W_U_MAXINT_1);
    end;

    if Parts[3] > INT_1W_U_MAXINT then
    begin
      MultiIntError  := True;
      m.FIsDefined   := False;
      m.FHasOverflow := True;
      if MultiIntEnableExceptions then
        raise EIntOverflow.Create('Overflow');

      Exit;
    end;

    Inc(currentIndex);
  end;

  m.FParts[0] := Parts[0];
  m.FParts[1] := Parts[1];
  m.FParts[2] := Parts[2];
  m.FParts[3] := Parts[3];

  if (Parts[0] = 0) and (Parts[1] = 0) and (Parts[2] = 0) and (Parts[3] = 0) then
    IsZero := True;

  m.FIsNegative := IsNegative;
end;


procedure Handle_Uninitialised_Overflow(var Result: TMultiIntX2;
  const IsDefined, HasOverflow: boolean);
begin
  Result.FIsDefined   := IsDefined;
  Result.FHasOverflow := HasOverflow;

  if not IsDefined then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    Exit;
  end;

  if HasOverflow then
  begin
    MultiIntError := True;
    Result.FHasOverflow := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    Exit;
  end;
end;


(******************************************)
function To_Multi_Int_X2(const A: TMultiIntX3): TMultiIntX2;
var
  n: INT_1W_U;
begin
  Handle_Uninitialised_Overflow(Result, A.FIsDefined, A.FHasOverflow);

  if A.FIsDefined then
    for n := 0 to Multi_X2_maxi do
      Result.FParts[n] := A.FParts[n];
end;


(******************************************)
function To_Multi_Int_X2(const A: TMultiIntX4): TMultiIntX2;
var
  n: INT_1W_U;
begin
  Handle_Uninitialised_Overflow(Result, A.FIsDefined, A.FHasOverflow);

  if A.FIsDefined then
    for n := 0 to Multi_X2_maxi do
      Result.FParts[n] := A.FParts[n];
end;


(******************************************)
function To_Multi_Int_X2(const A: TMultiIntXV): TMultiIntX2;
var
  n: INT_2W_U;
begin
  Handle_Uninitialised_Overflow(Result, A.FIsDefined, A.FHasOverflow);

  if A.FIsDefined then
    if Multi_XV_size > Multi_X2_size then
    begin
      for n := 0 to Multi_X2_maxi do
        Result.FParts[n] := A.FParts[n];

      for n := Multi_X2_maxi + 1 to Multi_XV_maxi do
        if A.FParts[n] <> 0 then
        begin
          MultiIntError := True;
          Result.FHasOverflow := True;
          if MultiIntEnableExceptions then
            raise EInterror.Create('Overflow');
          Exit;
        end;
    end
    else
    begin
      for n := 0 to Multi_XV_maxi do
        Result.FParts[n] := A.FParts[n];

      for n := Multi_XV_maxi + 1 to Multi_X2_maxi do
        Result.FParts[n] := 0;
    end;

end;


class operator TMultiIntX2.:=(const A: ansistring): TMultiIntX2;
begin
  String_to_Multi_Int_X2(A, Result);
end;


{$ifdef CPU_32}
(******************************************)
procedure INT_4W_S_to_Multi_Int_X2(const A: INT_4W_S; out m: TMultiIntX2); inline;
var
  v: INT_4W_U;
begin
  m.FHasOverflow := False;
  m.FIsDefined := True;
  v := A;

  m.FParts[0] := INT_1W_U(v mod INT_1W_U_MAXINT_1);
  v := v div INT_1W_U_MAXINT_1;
  m.FParts[1] := INT_1W_U(v mod INT_1W_U_MAXINT_1);
  v := v div INT_1W_U_MAXINT_1;
  m.FParts[2] := INT_1W_U(v mod INT_1W_U_MAXINT_1);
  v := v div INT_1W_U_MAXINT_1;
  m.FParts[3] := v;

  m.FIsNegative := (A < 0);
end;


(******************************************)
class operator TMultiIntX2.:=(const A: INT_4W_S): TMultiIntX2;
begin
  INT_4W_S_to_Multi_Int_X2(A, Result);
end;


(******************************************)
procedure INT_4W_U_to_Multi_Int_X2(const A: INT_4W_U; out m: TMultiIntX2); inline;
var
  v: INT_4W_U;
begin
  m.FHasOverflow := False;
  m.FIsDefined   := True;
  m.FIsNegative  := False;

  v := A;
  m.FParts[0] := INT_1W_U(v mod INT_1W_U_MAXINT_1);
  v := (v div INT_1W_U_MAXINT_1);
  m.FParts[1] := INT_1W_U(v mod INT_1W_U_MAXINT_1);
  v := (v div INT_1W_U_MAXINT_1);
  m.FParts[2] := INT_1W_U(v mod INT_1W_U_MAXINT_1);
  v := (v div INT_1W_U_MAXINT_1);
  m.FParts[3] := v;

end;


(******************************************)
class operator TMultiIntX2.:=(const A: INT_4W_U): TMultiIntX2;
begin
  INT_4W_U_to_Multi_Int_X2(A, Result);
end;
{$endif}


(******************************************)
procedure INT_2W_S_to_Multi_Int_X2(const A: INT_2W_S; out m: TMultiIntX2); inline;
begin
  m.FHasOverflow := False;
  m.FIsDefined   := True;
  m.FParts[2]    := 0;
  m.FParts[3]    := 0;

  m.FIsNegative := (A < 0);

  if m.FIsNegative then
  begin
    m.FParts[0] := (Abs(A) mod INT_1W_U_MAXINT_1);
    m.FParts[1] := (Abs(A) div INT_1W_U_MAXINT_1);
  end
  else
  begin
    m.FParts[0] := (A mod INT_1W_U_MAXINT_1);
    m.FParts[1] := (A div INT_1W_U_MAXINT_1);
  end;
end;


(******************************************)
class operator TMultiIntX2.:=(const A: INT_2W_S): TMultiIntX2;
begin
  INT_2W_S_to_Multi_Int_X2(A, Result);
end;


(******************************************)
procedure INT_2W_U_to_Multi_Int_X2(const A: INT_2W_U; out m: TMultiIntX2); inline;
begin
  m.FHasOverflow := False;
  m.FIsDefined   := True;
  m.FIsNegative  := uBoolFalse;

  m.FParts[0] := (A mod INT_1W_U_MAXINT_1);
  m.FParts[1] := (A div INT_1W_U_MAXINT_1);

  m.FParts[2] := 0;
  m.FParts[3] := 0;
end;


(******************************************)
class operator TMultiIntX2.:=(const A: INT_2W_U): TMultiIntX2;
begin
  INT_2W_U_to_Multi_Int_X2(A, Result);
end;


(******************************************)
// WARNING Float to Multi_Int type conversion loses some precision
class operator TMultiIntX2.:=(const A: single): TMultiIntX2;
var
  Temp: TMultiIntX2;
  FloatRec: TFloatRec;
begin
  MultiIntError := False;

  FloatToDecimal(FloatRec, A, SINGLE_TYPE_PRECISION_DIGITS, 0);

  String_to_Multi_Int_X2(AddCharR('0', AnsiLeftStr(FloatRec.digits,
    (SINGLE_TYPE_PRECISION_DIGITS - 1)), FloatRec.Exponent), Temp);

  if Temp.HasOverflow then
  begin
    MultiIntError      := True;
    Result.FIsDefined  := False;
    Result.FIsNegative := uBoolUndefined;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    Exit;
  end;

  Temp.FIsNegative := FloatRec.Negative;

  Result := Temp;
end;


(******************************************)
// WARNING Float to Multi_Int type conversion loses some precision
class operator TMultiIntX2.:=(const A: real): TMultiIntX2;
var
  Temp: TMultiIntX2;
  FloatRec: TFloatRec;
begin
  MultiIntError := False;

  FloatToDecimal(FloatRec, A, REAL_TYPE_PRECISION_DIGITS, 0);

  String_to_Multi_Int_X2(AddCharR('0', AnsiLeftStr(FloatRec.digits,
    (REAL_TYPE_PRECISION_DIGITS - 1)), FloatRec.Exponent), Temp);

  if Temp.HasOverflow then
  begin
    MultiIntError      := True;
    Result.FIsDefined  := False;
    Result.FIsNegative := uBoolUndefined;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    Exit;
  end;

  Temp.FIsNegative := FloatRec.Negative;

  Result := Temp;
end;


(******************************************)
// WARNING Float to Multi_Int type conversion loses some precision
class operator TMultiIntX2.:=(const A: double): TMultiIntX2;
var
  Temp: TMultiIntX2;
  FloatRec: TFloatRec;
begin
  MultiIntError := False;

  FloatToDecimal(FloatRec, A, DOUBLE_TYPE_PRECISION_DIGITS, 0);

  String_to_Multi_Int_X2(AddCharR('0', AnsiLeftStr(FloatRec.digits,
    (DOUBLE_TYPE_PRECISION_DIGITS - 1)), FloatRec.Exponent), Temp);

  if Temp.HasOverflow then
  begin
    MultiIntError      := True;
    Result.FIsDefined  := False;
    Result.FIsNegative := uBoolUndefined;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    Exit;
  end;

  Temp.FIsNegative := FloatRec.Negative;

  Result := Temp;
end;


(******************************************)
class operator TMultiIntX2.:=(const A: TMultiIntX2): single;
var
  ResultValue, TempValue, Multiplier: single;
  i: INT_1W_U;
  OverflowDetected: boolean;
begin
  if not A.FIsDefined then
  begin
    Result := 0;

    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');

    exit;
  end;

  MultiIntError := False;
  OverflowDetected := False;
  Multiplier := INT_1W_U_MAXINT_1;

  ResultValue := A.FParts[0];

  i := 1;
  while (i <= Multi_X2_maxi) and not MultiIntError do
  begin
    if not OverflowDetected then
    begin
      TempValue := A.FParts[i];
      try
        begin
          TempValue   := TempValue * Multiplier;
          ResultValue := ResultValue + TempValue;
        end
      except
        begin
          MultiIntError := True;
          if MultiIntEnableExceptions then
            raise EIntOverflow.Create('Overflow');
        end;
      end;

      TempValue := INT_1W_U_MAXINT_1;
      try
        Multiplier := (Multiplier * TempValue);
      except
        OverflowDetected := True;
      end;
    end
    else
    if (A.FParts[i] > 0) then
    begin
      MultiIntError := True;
      if MultiIntEnableExceptions then
        raise EIntOverflow.Create('Overflow');
    end;
    Inc(i);
  end;

  if A.FIsNegative then
    ResultValue := -ResultValue;
  Result := ResultValue;
end;


(******************************************)
class operator TMultiIntX2.:=(const A: TMultiIntX2): real;
var
  ResultValue, TempValue, Multiplier: real;
  i: INT_1W_U;
  OverflowDetected: boolean;
begin
  if not A.FIsDefined then
  begin
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  MultiIntError := False;
  OverflowDetected := False;
  Multiplier := INT_1W_U_MAXINT_1;

  ResultValue := A.FParts[0];
  i := 1;
  while (i <= Multi_X2_maxi) and not MultiIntError do
  begin
    if not OverflowDetected then
    begin
      TempValue := A.FParts[i];
      try
        begin
          TempValue   := (TempValue * Multiplier);
          ResultValue := ResultValue + TempValue;
        end
      except
        begin
          MultiIntError := True;
          if MultiIntEnableExceptions then
            raise EIntOverflow.Create('Overflow');
        end;
      end;
      TempValue := INT_1W_U_MAXINT_1;
      try
        Multiplier := Multiplier * TempValue;
      except
        OverflowDetected := True;
      end;
    end
    else
    if (A.FParts[i] > 0) then
    begin
      MultiIntError := True;
      if MultiIntEnableExceptions then
        raise EIntOverflow.Create('Overflow');
    end;
    Inc(i);
  end;

  if A.FIsNegative then
    ResultValue := -ResultValue;

  Result := ResultValue;

end;


(******************************************)
class operator TMultiIntX2.:=(const A: TMultiIntX2): double;
var
  ResultValue, PartValue, Multiplier: double;
  i: INT_1W_U;
  OverflowDetected: boolean;
begin
  if not A.FIsDefined then
  begin
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    Exit;
  end;

  MultiIntError := False;
  OverflowDetected := False;
  Multiplier := INT_1W_U_MAXINT_1;

  ResultValue := A.FParts[0];
  i := 1;

  while (i <= Multi_X2_maxi) and not OverflowDetected do
  begin
    PartValue := A.FParts[i];
    try
      PartValue   := PartValue * Multiplier;
      ResultValue := ResultValue + PartValue;
      Multiplier  := Multiplier * INT_1W_U_MAXINT_1;
    except
      on E: EIntOverflow do
      begin
        MultiIntError := True;
        if MultiIntEnableExceptions then
          raise EIntOverflow.Create('Overflow');
        Exit;
      end;
    end;
    Inc(i);
  end;

  if A.FIsNegative then
    ResultValue := (-ResultValue);

  Result := ResultValue;
end;


{******************************************}
class operator TMultiIntX2.:=(const A: TMultiIntX2): INT_2W_S;
var
  ResultValue: INT_2W_U;
begin
  MultiIntError := False;
  if not A.FIsDefined then
  begin
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  ResultValue := (INT_2W_U(A.FParts[0]) + (INT_2W_U(A.FParts[1]) * INT_1W_U_MAXINT_1));

  if (ResultValue > INT_2W_S_MAXINT) or (A.FParts[2] <> 0) or (A.FParts[3] <> 0) then
  begin
    Result := 0;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    Exit;
  end;

  if A.FIsNegative then
    Result := INT_2W_S(-ResultValue)
  else
    Result := INT_2W_S(ResultValue);
end;


{******************************************}
class operator TMultiIntX2.:=(const A: TMultiIntX2): INT_2W_U;
var
  ResultValue: INT_2W_U;
begin
  MultiIntError := False;
  if not A.FIsDefined then
  begin
    Result := 0;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  ResultValue := (INT_2W_U(A.FParts[1]) shl INT_1W_SIZE);
  ResultValue := (ResultValue or INT_2W_U(A.FParts[0]));

  if (A.FParts[2] <> 0) or (A.FParts[3] <> 0) then
  begin
    Result := 0;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    exit;
  end;
  Result := ResultValue;
end;


{******************************************}
class operator TMultiIntX2.:=(const A: TMultiIntX2): INT_1W_S;
var
  ResultValue: INT_2W_U;
begin
  MultiIntError := False;
  if not A.FIsDefined then
  begin
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  ResultValue := (INT_2W_U(A.FParts[0]) + (INT_2W_U(A.FParts[1]) * INT_1W_U_MAXINT_1));

  if (ResultValue > INT_1W_S_MAXINT) or (A.FParts[2] <> 0) or (A.FParts[3] <> 0) then
  begin
    Result := 0;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    exit;
  end;

  if A.FIsNegative then
    Result := INT_1W_S(-ResultValue)
  else
    Result := INT_1W_S(ResultValue);
end;


{******************************************}
class operator TMultiIntX2.:=(const A: TMultiIntX2): INT_1W_U;
var
  ResultValue: INT_2W_U;
begin
  MultiIntError := False;
  if not A.FIsDefined or (A.FIsNegative = uBoolTrue) then
  begin
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  ResultValue := (A.FParts[0] + (A.FParts[1] * INT_1W_U_MAXINT_1));

  if (ResultValue > INT_1W_U_MAXINT) or (A.FParts[2] <> 0) or (A.FParts[3] <> 0) then
  begin
    Result := 0;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    exit;
  end;

  Result := INT_1W_U(ResultValue);
end;


{******************************************}
class operator TMultiIntX2.:=(const A: TMultiIntX2): TMultiUInt8;
begin
  MultiIntError := False;
  if not A.FIsDefined or (A.FIsNegative = uBoolTrue) then
  begin
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FParts[0] > UINT8_MAX) or (A.FParts[1] <> 0) or (A.FParts[2] <> 0) or
    (A.FParts[3] <> 0) then
  begin
    MultiIntError := True;
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    exit;
  end;

  Result := TMultiUInt8(A.FParts[0]);
end;


{******************************************}
class operator TMultiIntX2.:=(const A: TMultiIntX2): TMultiInt8;
begin
  MultiIntError := False;
  if not A.FIsDefined or (A.FIsNegative = uBoolTrue) then
  begin
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FParts[0] > INT8_MAX) or (A.FParts[1] <> 0) or (A.FParts[2] <> 0) or
    (A.FParts[3] <> 0) then
  begin
    MultiIntError := True;
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    exit;
  end;

  Result := TMultiInt8(A.FParts[0]);
end;


(******************************************)
procedure bin_to_Multi_Int_X2(const A: ansistring; out m: TMultiIntX2); inline;
var
  n, startIndex, i, endIndex: INT_2W_U;
  bit: INT_1W_S;
  Value: array[0..Multi_X2_maxi] of INT_2W_U;
  HasSign, IsZero, AllZero: boolean;
begin
  MultiIntError := False;

  m.FHasOverflow := False;
  m.FIsDefined := True;
  m.FIsNegative := False;
  HasSign := False;
  IsZero  := False;

  n := 0;
  for n := 0 to Multi_X2_maxi do
    Value[n] := 0;

  if Length(A) = 0 then
    Exit;

  startIndex := low(ansistring);
  endIndex   := startIndex + INT_2W_U(length(A)) - 1;
  if (A[startIndex] = '-') then
  begin
    HasSign := True;
    Inc(startIndex);
  end;

  for i := startIndex to endIndex do
  begin
    bit := (Ord(A[i]) - Ord('0'));

    if (bit < 0) or (bit > 1) then
    begin
      MultiIntError  := True;
      m.FHasOverflow := True;
      m.FIsDefined   := False;

      if MultiIntEnableExceptions then
        raise EInterror.Create('Invalid binary digit');
      Exit;
    end;

    Value[0] := (Value[0] * 2) + bit;
    for n := 1 to Multi_X2_maxi do
      Value[n] := (Value[n] * 2);

    for n := 0 to Multi_X2_maxi - 1 do
      if Value[n] > INT_1W_U_MAXINT then
      begin
        Value[n + 1] := Value[n + 1] + (Value[n] div INT_1W_U_MAXINT_1);
        Value[n]     := (Value[n] mod INT_1W_U_MAXINT_1);
      end;

    if Value[n] > INT_1W_U_MAXINT then
    begin
      m.FIsDefined   := False;
      m.FHasOverflow := True;
      MultiIntError  := True;

      if MultiIntEnableExceptions then
        raise EIntOverflow.Create('Overflow');

      Exit;
    end;
  end;

  AllZero := True;
  for n := 0 to Multi_X2_maxi do
  begin
    m.FParts[n] := Value[n];
    if Value[n] <> 0 then
      AllZero := False;
  end;
  if AllZero then
    IsZero := True;

  if IsZero then
    m.FIsNegative := uBoolFalse
  else if HasSign then
    m.FIsNegative := uBoolTrue
  else
    m.FIsNegative := uBoolFalse;
end;


(******************************************)
procedure FromBin(const A: ansistring; out mi: TMultiIntX2); overload;
begin
  Bin_to_Multi_Int_X2(A, mi);
end;


(******************************************)
function TMultiIntX2.FromBinaryString(const AStr: ansistring): TMultiIntX2;
begin
  bin_to_Multi_Int_X2(AStr, Result);
end;


(******************************************)
procedure Multi_Int_X2_to_bin(const A: TMultiIntX2; out B: ansistring;
  LeadingZeroMode: TMultiLeadingZeros); inline;
var
  s: ansistring = '';
  n: INT_1W_S;
begin
  if not A.FIsDefined then
  begin
    B := 'UNDEFINED';
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow) then
  begin
    B := 'OVERFLOW';
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    exit;
  end;

  n := INT_1W_SIZE div 4;
  s := '';

  s := IntToBin(A.FParts[3], n) + IntToBin(A.FParts[2], n) +
    IntToBin(A.FParts[1], n) + IntToBin(A.FParts[0], n);

  if LeadingZeroMode = TrimLeadingZeros then
    RemoveLeadingChars(s, ['0']);

  if A.FIsNegative = uBoolTrue then
    s := '-' + s;

  if (s = '') then
    s := '0';

  B := s;
end;


(******************************************)
function TMultiIntX2.ToBinaryString(
  const LeadingZeroMode: TMultiLeadingZeros): ansistring;
begin
  Multi_Int_X2_to_bin(Self, Result, LeadingZeroMode);
end;


(******************************************)
procedure Multi_Int_X2_to_hex(const A: TMultiIntX2; out B: ansistring;
  LeadingZeroMode: TMultiLeadingZeros); inline;
var
  s: ansistring = '';
  n: TMultiUInt16;
begin
  if not A.FIsDefined then
  begin
    B := 'UNDEFINED';
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    Exit;
  end;

  if A.FHasOverflow then
  begin
    B := 'OVERFLOW';
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    Exit;
  end;

  n := INT_1W_SIZE div 4;
  s := IntToHex(A.FParts[3], n) + IntToHex(A.FParts[2], n) +
    IntToHex(A.FParts[1], n) + IntToHex(A.FParts[0], n);

  if LeadingZeroMode = TrimLeadingZeros then
    RemoveLeadingChars(s, ['0']);

  if A.FIsNegative = uBoolTrue then
    s := '-' + s;

  if s = '' then
    s := '0';

  B := s;
end;


(******************************************)
function TMultiIntX2.ToHexString(const LeadingZeroMode: TMultiLeadingZeros): ansistring;
begin
  Multi_Int_X2_to_hex(Self, Result, LeadingZeroMode);
end;


(******************************************)
procedure hex_to_Multi_Int_X2(const A: ansistring; out mi: TMultiIntX2); inline;
var
  n, i, b, c, e: INT_2W_U;
  M_Val: array[0..Multi_X2_maxi] of INT_2W_U;
  Signeg, Zeroneg, M_Val_All_Zero: boolean;
begin
  MultiIntError := False;

  mi.FHasOverflow := False;
  mi.FIsDefined := True;
  mi.FIsNegative := False;
  Signeg  := False;
  Zeroneg := False;

  n := 0;
  while (n <= Multi_X2_maxi) do
  begin
    M_Val[n] := 0;
    Inc(n);
  end;

  if (length(A) > 0) then
  begin
    b := low(ansistring);
    e := b + INT_2W_U(length(A)) - 1;
    if (A[b] = '-') then
    begin
      Signeg := True;
      Inc(b);
    end;

    c := b;
    while (c <= e) do
    begin
      try
        i := Hex2Dec(A[c]);
      except
        on EConvertError do
        begin
          MultiIntError   := True;
          mi.FIsDefined   := False;
          mi.FHasOverflow := True;
          if MultiIntEnableExceptions then
            raise;
        end;
      end;
      if mi.FIsDefined = False then
        Exit;

      M_Val[0] := (M_Val[0] * 16) + i;
      n := 1;
      while (n <= Multi_X2_maxi) do
      begin
        M_Val[n] := (M_Val[n] * 16);
        Inc(n);
      end;

      n := 0;
      while (n < Multi_X2_maxi) do
      begin
        if M_Val[n] > INT_1W_U_MAXINT then
        begin
          M_Val[n + 1] := M_Val[n + 1] + (M_Val[n] div INT_1W_U_MAXINT_1);
          M_Val[n]     := (M_Val[n] mod INT_1W_U_MAXINT_1);
        end;

        Inc(n);
      end;

      if M_Val[n] > INT_1W_U_MAXINT then
      begin
        MultiIntError   := True;
        mi.FIsDefined   := False;
        mi.FHasOverflow := True;
        if MultiIntEnableExceptions then
          raise EIntOverflow.Create('Overflow');
        Exit;
      end;
      Inc(c);
    end;
  end;

  M_Val_All_Zero := True;
  n := 0;
  while (n <= Multi_X2_maxi) do
  begin
    mi.FParts[n] := M_Val[n];
    if M_Val[n] > 0 then
      M_Val_All_Zero := False;
    Inc(n);
  end;
  if M_Val_All_Zero then
    Zeroneg := True;

  if Zeroneg then
    mi.FIsNegative := uBoolFalse
  else if Signeg then
    mi.FIsNegative := uBoolTrue
  else
    mi.FIsNegative := uBoolFalse;

end;


(******************************************)
procedure FromHex(const A: ansistring; out B: TMultiIntX2); overload;
begin
  hex_to_Multi_Int_X2(A, B);
end;


(******************************************)
function TMultiIntX2.FromHexString(const AStr: ansistring): TMultiIntX2;
begin
  hex_to_Multi_Int_X2(AStr, Result);
end;


(******************************************)
procedure Multi_Int_X2_to_String(const A: TMultiIntX2; out B: ansistring); inline;
var
  s: ansistring = '';
  M_Val: array[0..Multi_X2_maxi] of INT_2W_U;
begin
  if not A.FIsDefined then
  begin
    B := 'UNDEFINED';
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow) then
  begin
    B := 'OVERFLOW';
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    exit;
  end;

  M_Val[0] := A.FParts[0];
  M_Val[1] := A.FParts[1];
  M_Val[2] := A.FParts[2];
  M_Val[3] := A.FParts[3];

  repeat

    M_Val[2] := M_Val[2] + (INT_1W_U_MAXINT_1 * (M_Val[3] mod 10));
    M_Val[3] := (M_Val[3] div 10);

    M_Val[1] := M_Val[1] + (INT_1W_U_MAXINT_1 * (M_Val[2] mod 10));
    M_Val[2] := (M_Val[2] div 10);

    M_Val[0] := M_Val[0] + (INT_1W_U_MAXINT_1 * (M_Val[1] mod 10));
    M_Val[1] := (M_Val[1] div 10);

    s := IntToStr(M_Val[0] mod 10) + s;
    M_Val[0] := (M_Val[0] div 10);

  until (0 = 0) and (M_Val[0] = 0) and (M_Val[1] = 0) and (M_Val[2] = 0) and
    (M_Val[3] = 0);

  if (A.FIsNegative = uBoolTrue) then
    s := '-' + s;

  B := s;
end;


(******************************************)
function TMultiIntX2.ToString: ansistring;
begin
  Multi_Int_X2_to_String(Self, Result);
end;


(******************************************)
class operator TMultiIntX2.:=(const A: TMultiIntX2): ansistring;
begin
  Multi_Int_X2_to_String(A, Result);
end;


(******************************************)
class operator TMultiIntX2.xor(const A, B: TMultiIntX2): TMultiIntX2;
begin
  if not A.FIsDefined or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow or B.FHasOverflow) then
  begin
    Result := 0;
    Result.FHasOverflow := True;
    Result.FIsDefined := False;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  Result.FParts[0]    := (A.FParts[0] xor B.FParts[0]);
  Result.FParts[1]    := (A.FParts[1] xor B.FParts[1]);
  Result.FParts[2]    := (A.FParts[2] xor B.FParts[2]);
  Result.FParts[3]    := (A.FParts[3] xor B.FParts[3]);
  Result.FIsDefined   := True;
  Result.FHasOverflow := False;

  Result.FIsNegative := uBoolFalse;
  if (A.IsNegative <> B.IsNegative) then
    Result.FIsNegative := uBoolTrue;
end;


(******************************************)
class operator TMultiIntX2.or(const A, B: TMultiIntX2): TMultiIntX2;
begin
  if not A.FIsDefined or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  Result.FParts[0]    := (A.FParts[0] or B.FParts[0]);
  Result.FParts[1]    := (A.FParts[1] or B.FParts[1]);
  Result.FParts[2]    := (A.FParts[2] or B.FParts[2]);
  Result.FParts[3]    := (A.FParts[3] or B.FParts[3]);
  Result.FIsDefined   := True;
  Result.FHasOverflow := False;

  Result.FIsNegative := uBoolFalse;
  if A.IsNegative and B.IsNegative then
    Result.FIsNegative := uBoolTrue;
end;


(******************************************)
class operator TMultiIntX2.and(const A, B: TMultiIntX2): TMultiIntX2;
begin
  if not A.FIsDefined or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  Result.FParts[0]    := (A.FParts[0] and B.FParts[0]);
  Result.FParts[1]    := (A.FParts[1] and B.FParts[1]);
  Result.FParts[2]    := (A.FParts[2] and B.FParts[2]);
  Result.FParts[3]    := (A.FParts[3] and B.FParts[3]);
  Result.FIsDefined   := True;
  Result.FHasOverflow := False;

  Result.FIsNegative := uBoolFalse;
  if A.IsNegative and B.IsNegative then
    Result.FIsNegative := uBoolTrue;
end;


(******************************************)
class operator TMultiIntX2.not(const A: TMultiIntX2): TMultiIntX2;
begin
  if not A.FIsDefined then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  Result.FParts[0]    := (not A.FParts[0]);
  Result.FParts[1]    := (not A.FParts[1]);
  Result.FParts[2]    := (not A.FParts[2]);
  Result.FParts[3]    := (not A.FParts[3]);
  Result.FIsDefined   := True;
  Result.FHasOverflow := False;

  Result.FIsNegative := uBoolTrue;
  if A.IsNegative then
    Result.FIsNegative := uBoolFalse;
end;


(******************************************)
function add_Multi_Int_X2(const A, B: TMultiIntX2): TMultiIntX2;
var
  tv1, tv2: INT_2W_U;
  M_Val: array[0..Multi_X2_maxi] of INT_2W_U;
begin
  Result.FHasOverflow := False;
  Result.FIsDefined   := True;
  Result.FIsNegative  := uBoolUndefined;

  tv1      := A.FParts[0];
  tv2      := B.FParts[0];
  M_Val[0] := (tv1 + tv2);
  if M_Val[0] > INT_1W_U_MAXINT then
  begin
    M_Val[1] := (M_Val[0] div INT_1W_U_MAXINT_1);
    M_Val[0] := (M_Val[0] mod INT_1W_U_MAXINT_1);
  end
  else
    M_Val[1] := 0;

  tv1      := A.FParts[1];
  tv2      := B.FParts[1];
  M_Val[1] := (M_Val[1] + tv1 + tv2);
  if M_Val[1] > INT_1W_U_MAXINT then
  begin
    M_Val[2] := (M_Val[1] div INT_1W_U_MAXINT_1);
    M_Val[1] := (M_Val[1] mod INT_1W_U_MAXINT_1);
  end
  else
    M_Val[2] := 0;

  tv1      := A.FParts[2];
  tv2      := B.FParts[2];
  M_Val[2] := (M_Val[2] + tv1 + tv2);
  if M_Val[2] > INT_1W_U_MAXINT then
  begin
    M_Val[3] := (M_Val[2] div INT_1W_U_MAXINT_1);
    M_Val[2] := (M_Val[2] mod INT_1W_U_MAXINT_1);
  end
  else
    M_Val[3] := 0;

  tv1      := A.FParts[3];
  tv2      := B.FParts[3];
  M_Val[3] := (M_Val[3] + tv1 + tv2);
  if M_Val[3] > INT_1W_U_MAXINT then
  begin
    M_Val[3] := (M_Val[3] mod INT_1W_U_MAXINT_1);
    Result.FIsDefined := False;
    Result.FHasOverflow := True;
  end;

  Result.FParts[0] := M_Val[0];
  Result.FParts[1] := M_Val[1];
  Result.FParts[2] := M_Val[2];
  Result.FParts[3] := M_Val[3];

  if (M_Val[0] = 0) and (M_Val[1] = 0) and (M_Val[2] = 0) and (M_Val[3] = 0) then
    Result.FIsNegative := uBoolFalse;

end;


(******************************************)
function subtract_Multi_Int_X2(const A, B: TMultiIntX2): TMultiIntX2;
var
  M_Val: array[0..Multi_X2_maxi] of INT_2W_S;
begin
  Result.FHasOverflow := False;
  Result.FIsDefined   := True;
  Result.FIsNegative  := uBoolUndefined;

  M_Val[0] := (A.FParts[0] - B.FParts[0]);
  if M_Val[0] < 0 then
  begin
    M_Val[1] := -1;
    M_Val[0] := (M_Val[0] + INT_1W_U_MAXINT_1);
  end
  else
    M_Val[1] := 0;

  M_Val[1] := (A.FParts[1] - B.FParts[1] + M_Val[1]);
  if M_Val[1] < 0 then
  begin
    M_Val[2] := -1;
    M_Val[1] := (M_Val[1] + INT_1W_U_MAXINT_1);
  end
  else
    M_Val[2] := 0;

  M_Val[2] := (A.FParts[2] - B.FParts[2] + M_Val[2]);
  if M_Val[2] < 0 then
  begin
    M_Val[3] := -1;
    M_Val[2] := (M_Val[2] + INT_1W_U_MAXINT_1);
  end
  else
    M_Val[3] := 0;

  M_Val[3] := (A.FParts[3] - B.FParts[3] + M_Val[3]);
  if M_Val[3] < 0 then
  begin
    Result.FIsDefined   := False;
    Result.FHasOverflow := True;
  end;

  Result.FParts[0] := M_Val[0];
  Result.FParts[1] := M_Val[1];
  Result.FParts[2] := M_Val[2];
  Result.FParts[3] := M_Val[3];

  if (M_Val[0] = 0) and (M_Val[1] = 0) and (M_Val[2] = 0) and (M_Val[3] = 0) then
    Result.FIsNegative := uBoolFalse;

end;

(******************************************)
class operator TMultiIntX2.Inc(const A: TMultiIntX2): TMultiIntX2;
var
  Neg: TMultiUBoolState;
  B: TMultiIntX2;
begin
  if not A.FIsDefined then
  begin
    Result := 0;
    Result.FIsDefined := A.FIsDefined;
    Result.FHasOverflow := A.FHasOverflow;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FHasOverflow) then
  begin
    Result := 0;
    MultiIntError := True;
    Result.FIsDefined := A.FIsDefined;
    Result.FHasOverflow := A.FHasOverflow;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  Neg := uBoolUndefined;
  B   := 1;

  if (A.FIsNegative = False) then
  begin
    Result := add_Multi_Int_X2(A, B);
    Neg    := A.FIsNegative;
  end
  else
  if ABS_greaterthan_Multi_Int_X2(A, B) then
  begin
    Result := subtract_Multi_Int_X2(A, B);
    Neg    := uBoolTrue;
  end
  else
  begin
    Result := subtract_Multi_Int_X2(B, A);
    Neg    := uBoolFalse;
  end;

  if (Result.FHasOverflow = True) then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
  end;

  if (Result.FIsNegative = uBoolUndefined) then
    Result.FIsNegative := Neg;
end;


(******************************************)
class operator TMultiIntX2.+(const A, B: TMultiIntX2): TMultiIntX2;
var
  Neg: TMultiUBool;
begin
  if not A.FIsDefined or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FHasOverflow or B.FHasOverflow) then
  begin
    MultiIntError := True;
    Result := 0;
    Result.FHasOverflow := True;
    Result.FIsDefined := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  Neg := uBoolUndefined;

  if (A.FIsNegative = B.FIsNegative) then
  begin
    Result := add_Multi_Int_X2(A, B);
    Neg    := A.FIsNegative;
  end
  else
  if ((A.FIsNegative = False) and (B.FIsNegative = True)) then
  begin
    if ABS_greaterthan_Multi_Int_X2(B, A) then
    begin
      Result := subtract_Multi_Int_X2(B, A);
      Neg    := uBoolTrue;
    end
    else
    begin
      Result := subtract_Multi_Int_X2(A, B);
      Neg    := uBoolFalse;
    end;
  end
  else
  if ABS_greaterthan_Multi_Int_X2(A, B) then
  begin
    Result := subtract_Multi_Int_X2(A, B);
    Neg    := uBoolTrue;
  end
  else
  begin
    Result := subtract_Multi_Int_X2(B, A);
    Neg    := uBoolFalse;
  end;

  if (Result.FHasOverflow = True) then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
  end;

  if (Result.FIsNegative = uBoolUndefined) then
    Result.FIsNegative := Neg;
end;


(******************************************)
class operator TMultiIntX2.Dec(const A: TMultiIntX2): TMultiIntX2;
var
  Neg: TMultiUBoolState;
  B: TMultiIntX2;
begin
  if not A.FIsDefined then
  begin
    Result := 0;
    Result.FIsDefined := A.FIsDefined;
    Result.FHasOverflow := A.FHasOverflow;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FHasOverflow) then
  begin
    MultiIntError := True;
    Result := 0;
    Result.FIsDefined := A.FIsDefined;
    Result.FHasOverflow := A.FHasOverflow;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  Neg := uBoolUndefined;
  B   := 1;

  if (A.FIsNegative = False) then
  begin
    if ABS_greaterthan_Multi_Int_X2(B, A) then
    begin
      Result := subtract_Multi_Int_X2(B, A);
      Neg    := uBoolTrue;
    end
    else
    begin
      Result := subtract_Multi_Int_X2(A, B);
      Neg    := uBoolFalse;
    end;
  end
  else (* A is FIsNegative *)
  begin
    Result := add_Multi_Int_X2(A, B);
    Neg    := uBoolTrue;
  end;

  if (Result.FHasOverflow = True) then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
  end;

  if (Result.FIsNegative = uBoolUndefined) then
    Result.FIsNegative := Neg;
end;


(******************************************)
class operator TMultiIntX2.-(const A, B: TMultiIntX2): TMultiIntX2;
var
  Neg: TMultiUBoolState;
begin
  if not A.FIsDefined or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FHasOverflow or B.FHasOverflow) then
  begin
    MultiIntError := True;
    Result := 0;
    Result.FHasOverflow := True;
    Result.FIsDefined := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  Neg := uBoolUndefined;

  if (A.FIsNegative = B.FIsNegative) then
  begin
    if (A.FIsNegative = True) then
    begin
      if ABS_greaterthan_Multi_Int_X2(A, B) then
      begin
        Result := subtract_Multi_Int_X2(A, B);
        Neg    := uBoolTrue;
      end
      else
      begin
        Result := subtract_Multi_Int_X2(B, A);
        Neg    := uBoolFalse;
      end;
    end
    else  (* if  not FIsNegative then  *)
    begin
      if ABS_greaterthan_Multi_Int_X2(B, A) then
      begin
        Result := subtract_Multi_Int_X2(B, A);
        Neg    := uBoolTrue;
      end
      else
      begin
        Result := subtract_Multi_Int_X2(A, B);
        Neg    := uBoolFalse;
      end;
    end;
  end
  else (* A.FIsNegative <> B.FIsNegative *)
  if (B.FIsNegative = True) then
  begin
    Result := add_Multi_Int_X2(A, B);
    Neg    := uBoolFalse;
  end
  else
  begin
    Result := add_Multi_Int_X2(A, B);
    Neg    := uBoolTrue;
  end;

  if (Result.FHasOverflow = True) then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
  end;

  if (Result.FIsNegative = uBoolUndefined) then
    Result.FIsNegative := Neg;
end;


(******************************************)
class operator TMultiIntX2.-(const A: TMultiIntX2): TMultiIntX2; inline;
begin
  Result := A;
  if (A.FIsNegative = uBoolTrue) then
    Result.FIsNegative := uBoolFalse;
  if (A.FIsNegative = uBoolFalse) then
    Result.FIsNegative := uBoolTrue;
end;


(********************A********************)
procedure multiply_Multi_Int_X2(const A, B: TMultiIntX2; out Result: TMultiIntX2);
label
  999;
var
  M_Val: array[0..Multi_X2_maxi_x2] of INT_2W_U;
  tv1, tv2: INT_2W_U;
  i, j, k, n, jz, iz: INT_1W_S;
  zf, zero_mult: boolean;
begin
  Result := 0;
  Result.FHasOverflow := False;
  Result.FIsDefined := True;
  Result.FIsNegative := uBoolUndefined;

  i := 0;
  repeat
    M_Val[i] := 0;
    Inc(i);
  until (i > Multi_X2_maxi_x2);

  zf := False;
  i  := Multi_X2_maxi;
  jz := -1;
  repeat
    if (B.FParts[i] <> 0) then
    begin
      jz := i;
      zf := True;
    end;
    Dec(i);
  until (i < 0) or (zf);
  if (jz < 0) then
  begin
    Result.FIsNegative := uBoolFalse;
    goto 999;
  end;

  zf := False;
  i  := Multi_X2_maxi;
  iz := -1;
  repeat
    if (A.FParts[i] <> 0) then
    begin
      iz := i;
      zf := True;
    end;
    Dec(i);
  until (i < 0) or (zf);
  if (iz < 0) then
  begin
    Result.FIsNegative := uBoolFalse;
    goto 999;
  end;

  i := 0;
  j := 0;
  repeat
    if (B.FParts[j] <> 0) then
    begin
      zero_mult := True;
      repeat
        if (A.FParts[i] <> 0) then
        begin
          zero_mult := False;
          tv1 := A.FParts[i];
          tv2 := B.FParts[j];
          M_Val[i + j + 1] :=
            (M_Val[i + j + 1] + ((tv1 * tv2) div INT_1W_U_MAXINT_1));
          M_Val[i + j] := (M_Val[i + j] + ((tv1 * tv2) mod INT_1W_U_MAXINT_1));
        end;
        Inc(i);
      until (i > iz);
      if not zero_mult then
      begin
        k := 0;
        repeat
          if (M_Val[k] <> 0) then
          begin
            M_Val[k + 1] := M_Val[k + 1] + (M_Val[k] div INT_1W_U_MAXINT_1);
            M_Val[k]     := (M_Val[k] mod INT_1W_U_MAXINT_1);
          end;
          Inc(k);
        until (k > Multi_X2_maxi);
      end;
      i := 0;
    end;
    Inc(j);
  until (j > jz);

  Result.FIsNegative := uBoolFalse;
  i := 0;
  repeat
    if (M_Val[i] <> 0) then
    begin
      Result.FIsNegative := uBoolUndefined;
      if (i > Multi_X2_maxi) then
        Result.FHasOverflow := True;
    end;
    Inc(i);
  until (i > Multi_X2_maxi_x2) or (Result.FHasOverflow);

  n := 0;
  while (n <= Multi_X2_maxi) do
  begin
    Result.FParts[n] := M_Val[n];
    Inc(n);
  end;

  999: ;
end;


(******************************************)
class operator TMultiIntX2.*(const A, B: TMultiIntX2): TMultiIntX2;
var
  R: TMultiIntX2;
begin
  if not A.FIsDefined or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FHasOverflow or B.FHasOverflow) then
  begin
    Result := 0;
    Result.FHasOverflow := True;
    Result.FIsDefined := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  multiply_Multi_Int_X2(A, B, R);

  if (R.FIsNegative = uBoolUndefined) then
    if (A.FIsNegative = B.FIsNegative) then
      R.FIsNegative := uBoolFalse
    else
      R.FIsNegative := uBoolTrue;

  Result := R;

  if R.FHasOverflow then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
  end;
end;


(********************v3********************)
{ Function exp_by_squaring_iterative(TV, P) }

class operator TMultiIntX2.**(const A: TMultiIntX2; const P: INT_2W_S): TMultiIntX2;
var
  Y, TV, T, R: TMultiIntX2;
  PT: INT_2W_S;
begin
  PT := P;
  TV := A;
  if (PT < 0) then
    R := 0
  else if (PT = 0) then
    R := 1
  else
  begin
    Y := 1;
    while (PT > 1) do
    begin
      if odd(PT) then
      begin
        multiply_Multi_Int_X2(TV, Y, T);
        if (T.FHasOverflow) then
        begin
          MultiIntError := True;
          Result := 0;
          Result.FIsDefined := False;
          Result.FHasOverflow := True;
          if MultiIntEnableExceptions then
            raise EIntOverflow.Create('Overflow');
          exit;
        end;
        if (T.FIsNegative = uBoolUndefined) then
          if (TV.FIsNegative = Y.FIsNegative) then
            T.FIsNegative := uBoolFalse
          else
            T.FIsNegative := uBoolTrue;

        Y  := T;
        PT := PT - 1;
      end;
      multiply_Multi_Int_X2(TV, TV, T);
      if (T.FHasOverflow) then
      begin
        MultiIntError := True;
        Result := 0;
        Result.FIsDefined := False;
        Result.FHasOverflow := True;
        if MultiIntEnableExceptions then
          raise EIntOverflow.Create('Overflow');
        exit;
      end;
      T.FIsNegative := uBoolFalse;

      TV := T;
      PT := (PT div 2);
    end;
    multiply_Multi_Int_X2(TV, Y, R);
    if (R.FHasOverflow) then
    begin
      MultiIntError := True;
      Result := 0;
      Result.FIsDefined := False;
      Result.FHasOverflow := True;
      if MultiIntEnableExceptions then
        raise EIntOverflow.Create('Overflow');
      exit;
    end;
    if (R.FIsNegative = uBoolUndefined) then
      if (TV.FIsNegative = Y.FIsNegative) then
        R.FIsNegative := uBoolFalse
      else
        R.FIsNegative := uBoolTrue;
  end;

  Result := R;
end;


(********************A********************)
procedure intdivide_taylor_warruth_X2(const P_dividend, P_dividor: TMultiIntX2;
  out P_quotient, P_remainder: TMultiIntX2);
label
  AGAIN, 9000, 9999;
var
  dividor, quotient, dividend, next_dividend: TMultiIntX3;

  dividend_i, dividend_i_1, quotient_i, dividor_i, dividor_i_1,
  dividor_non_zero_pos, shiftup_bits_dividor, i: INT_1W_S;

  adjacent_word_dividend, adjacent_word_division, word_division,
  word_dividend, word_carry, next_word_carry: INT_2W_U;

  finished: boolean;
begin
  dividend    := 0;
  next_dividend := 0;
  dividor     := 0;
  quotient    := 0;
  P_quotient  := 0;
  P_remainder := 0;

  if (P_dividor = 0) then
  begin
    P_quotient.FIsDefined := False;
    P_quotient.FHasOverflow := True;
    P_remainder.FIsDefined := False;
    P_remainder.FHasOverflow := True;
    MultiIntError := True;
  end
  else if (P_dividor = P_dividend) then
    P_quotient := 1
  else
  begin
    if (Abs(P_dividor) > Abs(P_dividend)) then
    begin
      P_remainder := P_dividend;
      goto 9000;
    end;

    dividor_non_zero_pos := 0;
    i := Multi_X2_maxi;
    while (i >= 0) do
    begin
      dividor.FParts[i] := P_dividor.FParts[i];
      if (dividor_non_zero_pos = 0) then
        if (dividor.FParts[i] <> 0) then
          dividor_non_zero_pos := i;
      Dec(i);
    end;
    dividor.FIsNegative := False;

    // essential short-cut for single word dividor
    // the later code will fail if this case is not dealt with here

    if (dividor_non_zero_pos = 0) then
    begin
      P_remainder := 0;
      P_quotient := 0;
      word_carry := 0;
      i := Multi_X2_maxi;
      while (i >= 0) do
      begin
        P_quotient.FParts[i] :=
          (((word_carry * INT_2W_U(INT_1W_U_MAXINT_1)) +
          INT_2W_U(P_dividend.FParts[i])) div INT_2W_U(P_dividor.FParts[0]));
        word_carry := (((word_carry * INT_2W_U(INT_1W_U_MAXINT_1)) +
          INT_2W_U(P_dividend.FParts[i])) -
          (INT_2W_U(P_quotient.FParts[i]) * INT_2W_U(P_dividor.FParts[0])));
        Dec(i);
      end;
      P_remainder.FParts[0] := word_carry;
      goto 9000;
    end;

    dividend := P_dividend;
    dividend.FIsNegative := False;

    shiftup_bits_dividor := LeadingZeroCount(dividor.FParts[dividor_non_zero_pos]);
    if (shiftup_bits_dividor > 0) then
    begin
      ShiftUp_NBits_Multi_Int_X3(dividend, shiftup_bits_dividor);
      ShiftUp_NBits_Multi_Int_X3(dividor, shiftup_bits_dividor);
    end;

    next_word_carry := 0;
    word_carry  := 0;
    dividor_i   := dividor_non_zero_pos;
    dividor_i_1 := (dividor_i - 1);
    dividend_i  := (Multi_X2_maxi + 1);
    finished    := False;
    while (not finished) do
      if (dividend_i >= 0) then
      begin
        if (dividend.FParts[dividend_i] = 0) then
          Dec(dividend_i)
        else
        begin
          finished := True;
        end;
      end
      else
        finished := True;
    quotient_i   := (dividend_i - dividor_non_zero_pos);

    while (dividend >= 0) and (quotient_i >= 0) do
    begin
      word_dividend   := ((word_carry * INT_2W_U(INT_1W_U_MAXINT_1)) +
        dividend.FParts[dividend_i]);
      word_division   := (word_dividend div dividor.FParts[dividor_i]);
      next_word_carry := (word_dividend mod dividor.FParts[dividor_i]);

      if (word_division > 0) then
      begin
        dividend_i_1 := (dividend_i - 1);
        if (dividend_i_1 >= 0) then
        begin
          AGAIN:
            adjacent_word_dividend :=
              ((next_word_carry * INT_2W_U(INT_1W_U_MAXINT_1)) +
            dividend.FParts[dividend_i_1]);
          adjacent_word_division   := (dividor.FParts[dividor_i_1] * word_division);
          if (adjacent_word_division > adjacent_word_dividend) or
            (word_division >= INT_1W_U_MAXINT_1) then
          begin
            Dec(word_division);
            next_word_carry := next_word_carry + dividor.FParts[dividor_i];
            if (next_word_carry < INT_1W_U_MAXINT_1) then
              goto AGAIN;
          end;
        end;
        quotient      := 0;
        quotient.FParts[quotient_i] := word_division;
        next_dividend := (dividend - (dividor * quotient));
        if (next_dividend.IsNegative) then
        begin
          Dec(word_division);
          quotient.FParts[quotient_i] := word_division;
          next_dividend := (dividend - (dividor * quotient));
        end;
        P_quotient.FParts[quotient_i] := word_division;
        dividend   := next_dividend;
        word_carry := dividend.FParts[dividend_i];
      end
      else
        word_carry := word_dividend;

      Dec(dividend_i);
      quotient_i := (dividend_i - dividor_non_zero_pos);
    end; { while }

    ShiftDown_MultiBits_Multi_Int_X3(dividend, shiftup_bits_dividor);
    P_remainder := To_Multi_Int_X2(dividend);

    9000:
      if (P_dividend.FIsNegative = True) and (P_remainder > 0) then
        P_remainder.FIsNegative := True;

    if (P_dividend.FIsNegative <> P_dividor.FIsNegative) and (P_quotient > 0) then
      P_quotient.FIsNegative := True;

  end;
  9999: ;
end;


(******************************************)
class operator TMultiIntX2.div(const A, B: TMultiIntX2): TMultiIntX2;
var
  Remainder, Quotient: TMultiIntX2;
begin
  if not A.FIsDefined or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FHasOverflow or B.FHasOverflow) then
  begin
    MultiIntError := True;
    Result := 0;
    Result.FHasOverflow := True;
    Result.FIsDefined := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  // same values as last time

  if (X2_Last_Divisor = B) and (X2_Last_Dividend = A) then
    Result := X2_Last_Quotient
  else  // different values than last time
  begin
    intdivide_taylor_warruth_X2(A, B, Quotient, Remainder);

    X2_Last_Divisor   := B;
    X2_Last_Dividend  := A;
    X2_Last_Quotient  := Quotient;
    X2_Last_Remainder := Remainder;

    Result := Quotient;
  end;

  if (X2_Last_Remainder.FHasOverflow) or (X2_Last_Quotient.FHasOverflow) then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
  end;
end;


(******************************************)
class operator TMultiIntX2.mod(const A, B: TMultiIntX2): TMultiIntX2;
var
  Remainder, Quotient: TMultiIntX2;
begin
  if not A.FIsDefined or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FHasOverflow or B.FHasOverflow) then
  begin
    MultiIntError := True;
    Result := 0;
    Result.FHasOverflow := True;
    Result.FIsDefined := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  // same values as last time

  if (X2_Last_Divisor = B) and (X2_Last_Dividend = A) then
    Result := X2_Last_Remainder
  else  // different values than last time
  begin
    intdivide_taylor_warruth_X2(A, B, Quotient, Remainder);

    X2_Last_Divisor   := B;
    X2_Last_Dividend  := A;
    X2_Last_Quotient  := Quotient;
    X2_Last_Remainder := Remainder;

    Result := Remainder;
  end;

  if (X2_Last_Remainder.FHasOverflow) or (X2_Last_Quotient.FHasOverflow) then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
  end;
end;


(***********B************)
procedure SqRoot(const A: TMultiIntX2; out VR, VREM: TMultiIntX2);
var
  D, D2: INT_2W_S;
  HS, LS: ansistring;
  H, L, C, CC, LPC, Q, R, T: TMultiIntX2;
  finished: boolean;
begin
  if not A.FIsDefined then
  begin
    VR   := 0;
    VR.FIsDefined := False;
    VREM := 0;
    VREM.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow) then
  begin
    VR   := 0;
    VR.FIsDefined := False;
    VREM := 0;
    VREM.FIsDefined := False;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  if (A.FIsNegative = uBoolTrue) then
  begin
    VR   := 0;
    VR.FIsDefined := False;
    VREM := 0;
    VREM.FIsDefined := False;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  if (A >= 100) then
  begin
    D  := length(A.ToString);
    D2 := D div 2;
    if ((D mod 2) = 0) then
    begin
      LS := '1' + AddCharR('0', '', D2 - 1);
      HS := '1' + AddCharR('0', '', D2);
      H  := HS;
      L  := LS;
    end
    else
    begin
      LS := '1' + AddCharR('0', '', D2);
      HS := '1' + AddCharR('0', '', D2 + 1);
      H  := HS;
      L  := LS;
    end;

    T := (H - L);
    ShiftDown_MultiBits_Multi_Int_X2(T, 1);
    C := (L + T);
  end
  else
  begin
    C := (A div 2);
    if (C = 0) then
      C := 1;
  end;

  finished := False;
  LPC      := A;
  repeat
    begin
      // CC:= ((C + (A div C)) div 2);
      intdivide_taylor_warruth_X2(A, C, Q, R);
      CC := (C + Q);
      ShiftDown_MultiBits_Multi_Int_X2(CC, 1);
      if (ABS(C - CC) < 2) then
        if (CC < LPC) then
          LPC := CC
        else if (CC >= LPC) then
          finished := True;
      C := CC;
    end
  until finished;

  VREM := (A - (LPC * LPC));
  VR   := LPC;
  VR.FIsNegative := uBoolFalse;
  VREM.FIsNegative := uBoolFalse;

end;


(*************************)
procedure SqRoot(const A: TMultiIntX2; out VR: TMultiIntX2);
var
  VREM: TMultiIntX2;
begin
  VREM := 0;
  sqroot(A, VR, VREM);
end;


(*************************)
function SqRoot(const A: TMultiIntX2): TMultiIntX2;
var
  VR, VREM: TMultiIntX2;
begin
  VREM := 0;
  sqroot(A, VR, VREM);
  Result := VR;
end;


{
******************************************
TMultiIntX3
******************************************
}

function ABS_greaterthan_Multi_Int_X3(const A, B: TMultiIntX3): boolean;
begin
  if (A.FParts[5] > B.FParts[5]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.FParts[5] < B.FParts[5]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.FParts[4] > B.FParts[4]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.FParts[4] < B.FParts[4]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.FParts[3] > B.FParts[3]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.FParts[3] < B.FParts[3]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.FParts[2] > B.FParts[2]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.FParts[2] < B.FParts[2]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.FParts[1] > B.FParts[1]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.FParts[1] < B.FParts[1]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.FParts[0] > B.FParts[0]) then
  begin
    Result := True;
    exit;
  end
  else
  begin
    Result := False;
    exit;
  end;
end;


(******************************************)
function ABS_lessthan_Multi_Int_X3(const A, B: TMultiIntX3): boolean;
begin
  if (A.FParts[5] < B.FParts[5]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.FParts[5] > B.FParts[5]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.FParts[4] < B.FParts[4]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.FParts[4] > B.FParts[4]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.FParts[3] < B.FParts[3]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.FParts[3] > B.FParts[3]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.FParts[2] < B.FParts[2]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.FParts[2] > B.FParts[2]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.FParts[1] < B.FParts[1]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.FParts[1] > B.FParts[1]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.FParts[0] < B.FParts[0]) then
  begin
    Result := True;
    exit;
  end
  else
  begin
    Result := False;
    exit;
  end;
end;


(******************************************)
function ABS_equal_Multi_Int_X3(const A, B: TMultiIntX3): boolean;
begin
  Result := True;
  if (A.FParts[5] <> B.FParts[5]) then
    Result := False
  else
  if (A.FParts[4] <> B.FParts[4]) then
    Result := False
  else
  if (A.FParts[3] <> B.FParts[3]) then
    Result := False
  else
  if (A.FParts[2] <> B.FParts[2]) then
    Result := False
  else
  if (A.FParts[1] <> B.FParts[1]) then
    Result := False
  else
  if (A.FParts[0] <> B.FParts[0]) then
    Result := False;
end;


(******************************************)
function ABS_notequal_Multi_Int_X3(const A, B: TMultiIntX3): boolean; inline;
begin
  Result := (not ABS_equal_Multi_Int_X3(A, B));
end;


(******************************************)
function TMultiIntX3.HasOverflow: boolean; inline;
begin
  Result := Self.FHasOverflow;
end;


(******************************************)
function TMultiIntX3.IsDefined: boolean; inline;
begin
  Result := Self.FIsDefined;
end;


(******************************************)
function Overflow(const A: TMultiIntX3): boolean; overload; inline;
begin
  Result := A.FHasOverflow;
end;


(******************************************)
function Defined(const A: TMultiIntX3): boolean; overload; inline;
begin
  Result := A.FIsDefined;
end;


(******************************************)
function TMultiIntX3.IsNegative: boolean; inline;
begin
  Result := Self.FIsNegative;
end;


(******************************************)
function Negative(const A: TMultiIntX3): boolean; overload; inline;
begin
  Result := A.FIsNegative;
end;


(******************************************)
function Abs(const A: TMultiIntX3): TMultiIntX3; overload;
begin
  Result := A;
  Result.FIsNegative := uBoolFalse;

  if not A.FIsDefined then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
  end;
end;


(******************************************)
function Multi_Int_X3_Odd(const A: TMultiIntX3): boolean;
var
  bit1_mask: INT_1W_U;
begin

  bit1_mask := $1;

  if ((A.FParts[0] and bit1_mask) = bit1_mask) then
    Result := True
  else
    Result := False;

  if not A.FIsDefined then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
  end;

end;


(******************************************)
function Odd(const A: TMultiIntX3): boolean; overload;
begin
  Result := Multi_Int_X3_Odd(A);
end;


(******************************************)
function Multi_Int_X3_Even(const A: TMultiIntX3): boolean; inline;
var
  bit1_mask: INT_1W_U;
begin

  bit1_mask := $1;

  if ((A.FParts[0] and bit1_mask) = bit1_mask) then
    Result := False
  else
    Result := True;

  if not A.FIsDefined then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
  end;

end;


(******************************************)
function Even(const A: TMultiIntX3): boolean; overload;
begin
  Result := Multi_Int_X3_Even(A);
end;


(******************************************)
function nlz_words_X3(m: TMultiIntX3): INT_1W_U;
var
  i, n: TMultiInt32;
  fini: boolean;
begin
  n    := 0;
  i    := Multi_X3_maxi;
  fini := False;
  repeat
    if (i < 0) then
      fini := True
    else if (m.FParts[i] <> 0) then
      fini := True
    else
    begin
      Inc(n);
      Dec(i);
    end;
  until fini;
  Result := n;
end;


(******************************************)
function nlz_MultiBits_X3(A: TMultiIntX3): INT_1W_U;
var
  w: INT_1W_U;
begin
  if not A.FIsDefined then
  begin
    Result := 0;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
  end;

  w := nlz_words_X3(A);
  if (w <= Multi_X3_maxi) then
    Result :=
      LeadingZeroCount(A.FParts[Multi_X3_maxi - w]) + (w * INT_1W_SIZE)
  else
    Result := (w * INT_1W_SIZE);
end;


{$ifdef CPU_32}
(******************************************)
procedure ShiftUp_NBits_Multi_Int_X3(var A: TMultiIntX3; NBits: INT_1W_U);
var
  carry_bits_1, carry_bits_2, carry_bits_mask, NBits_max, NBits_carry: INT_1W_U;

  procedure INT_1W_U_shl(var A: INT_1W_U; const nbits: INT_1W_U); inline;
  var
    carry_bits_mask_2w: INT_2W_U;
  begin
    carry_bits_mask_2w := A;
    carry_bits_mask_2w := (carry_bits_mask_2w << NBits);
    A := INT_1W_U(carry_bits_mask_2w and INT_1W_U_MAXINT);
  end;

begin
  if NBits > 0 then
  begin

    carry_bits_mask := $FFFF;
    NBits_max   := INT_1W_SIZE;
    NBits_carry := (NBits_max - NBits);
    INT_1W_U_shl(carry_bits_mask, NBits_carry);

    if NBits <= NBits_max then
    begin
      carry_bits_1 := ((A.M_Value[0] and carry_bits_mask) shr NBits_carry);
      INT_1W_U_shl(A.M_Value[0], NBits);

      carry_bits_2 := ((A.M_Value[1] and carry_bits_mask) shr NBits_carry);
      INT_1W_U_shl(A.M_Value[1], NBits);
      A.M_Value[1] := (A.M_Value[1] or carry_bits_1);

      carry_bits_1 := ((A.M_Value[2] and carry_bits_mask) shr NBits_carry);
      INT_1W_U_shl(A.M_Value[2], NBits);
      A.M_Value[2] := (A.M_Value[2] or carry_bits_2);

      carry_bits_2 := ((A.M_Value[3] and carry_bits_mask) shr NBits_carry);
      INT_1W_U_shl(A.M_Value[3], NBits);
      A.M_Value[3] := (A.M_Value[3] or carry_bits_1);

      carry_bits_1 := ((A.M_Value[4] and carry_bits_mask) shr NBits_carry);
      INT_1W_U_shl(A.M_Value[4], NBits);
      A.M_Value[4] := (A.M_Value[4] or carry_bits_2);

      INT_1W_U_shl(A.M_Value[5], NBits);
      A.M_Value[5] := (A.M_Value[5] or carry_bits_1);
    end;
  end;

end;
{$endif}

{$ifdef CPU_64}
(******************************************)
procedure ShiftUp_NBits_Multi_Int_X3(Var A:TMultiIntX3; NBits:INT_1W_U);
var     carry_bits_1,
        carry_bits_2,
        carry_bits_mask,
        NBits_max,
        NBits_carry     :INT_1W_U;
begin
if NBits > 0 then
begin

carry_bits_mask:= $FFFFFFFF;
NBits_max:= INT_1W_SIZE;

NBits_carry:= (NBits_max - NBits);
carry_bits_mask:= (carry_bits_mask << NBits_carry);

if NBits <= NBits_max then
        begin
        carry_bits_1:= ((A.FParts[0] and carry_bits_mask) shr NBits_carry);
        A.FParts[0]:= (A.FParts[0] << NBits);

        carry_bits_2:= ((A.FParts[1] and carry_bits_mask) shr NBits_carry);
        A.FParts[1]:= ((A.FParts[1] << NBits) OR carry_bits_1);

        carry_bits_1:= ((A.FParts[2] and carry_bits_mask) shr NBits_carry);
        A.FParts[2]:= ((A.FParts[2] << NBits) OR carry_bits_2);

        carry_bits_2:= ((A.FParts[3] and carry_bits_mask) shr NBits_carry);
        A.FParts[3]:= ((A.FParts[3] << NBits) OR carry_bits_1);

        carry_bits_1:= ((A.FParts[4] and carry_bits_mask) shr NBits_carry);
        A.FParts[4]:= ((A.FParts[4] << NBits) OR carry_bits_2);

        A.FParts[5]:= ((A.FParts[5] << NBits) OR carry_bits_1);
        end;
end;

end;
{$endif}


(******************************************)
procedure ShiftUp_NWords_Multi_Int_X3(var A: TMultiIntX3; NWords: INT_1W_U);
var
  n: INT_1W_U;
begin
  if (NWords > 0) then
    if (NWords <= Multi_X3_maxi) then
    begin
      n := NWords;
      while (n > 0) do
      begin
        A.FParts[5] := A.FParts[4];
        A.FParts[4] := A.FParts[3];
        A.FParts[3] := A.FParts[2];
        A.FParts[2] := A.FParts[1];
        A.FParts[1] := A.FParts[0];
        A.FParts[0] := 0;
        Dec(n);
      end;
    end
    else
    begin
      A.FParts[0] := 0;
      A.FParts[1] := 0;
      A.FParts[2] := 0;
      A.FParts[3] := 0;
      A.FParts[4] := 0;
      A.FParts[5] := 0;
    end;
end;


(******************************************)
procedure ShiftDown_NWords_Multi_Int_X3(var A: TMultiIntX3; NWords: INT_1W_U);
var
  n: INT_1W_U;
begin
  if (NWords > 0) then
    if (NWords <= Multi_X3_maxi) then
    begin
      n := NWords;
      while (n > 0) do
      begin
        A.FParts[0] := A.FParts[1];
        A.FParts[1] := A.FParts[2];
        A.FParts[2] := A.FParts[3];
        A.FParts[3] := A.FParts[4];
        A.FParts[4] := A.FParts[5];
        A.FParts[5] := 0;
        Dec(n);
      end;
    end
    else
    begin
      A.FParts[0] := 0;
      A.FParts[1] := 0;
      A.FParts[2] := 0;
      A.FParts[3] := 0;
      A.FParts[4] := 0;
      A.FParts[5] := 0;
    end;
end;


{******************************************}
procedure ShiftUp_MultiBits_Multi_Int_X3(var A: TMultiIntX3; NBits: INT_1W_U);
var
  NWords_count, NBits_count: INT_1W_U;
begin
  if not A.FIsDefined then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (NBits > 0) then
  begin
    if (NBits >= INT_1W_SIZE) then
    begin
      NWords_count := (NBits div INT_1W_SIZE);
      NBits_count  := (NBits mod INT_1W_SIZE);
      ShiftUp_NWords_Multi_Int_X3(A, NWords_count);
    end
    else
      NBits_count := NBits;
    ShiftUp_NBits_Multi_Int_X3(A, NBits_count);
  end;
end;


(******************************************)
procedure ShiftDown_NBits_Multi_Int_X3(var A: TMultiIntX3; NBits: INT_1W_U);
var
  carry_bits_1, carry_bits_2, carry_bits_mask, NBits_max, NBits_carry: INT_1W_U;
begin
  if NBits > 0 then
  begin

    {$ifdef CPU_32}
    carry_bits_mask := $FFFF;
    {$endif}
    {$ifdef CPU_64}
carry_bits_mask:= $FFFFFFFF;
    {$endif}

    NBits_max := INT_1W_SIZE;

    NBits_carry     := (NBits_max - NBits);
    carry_bits_mask := (carry_bits_mask shr NBits_carry);

    if NBits <= NBits_max then
    begin

      carry_bits_1 := ((A.FParts[5] and carry_bits_mask) << NBits_carry);
      A.FParts[5]  := (A.FParts[5] shr NBits);

      carry_bits_2 := ((A.FParts[4] and carry_bits_mask) << NBits_carry);
      A.FParts[4]  := ((A.FParts[4] shr NBits) or carry_bits_1);

      carry_bits_1 := ((A.FParts[3] and carry_bits_mask) << NBits_carry);
      A.FParts[3]  := ((A.FParts[3] shr NBits) or carry_bits_2);

      carry_bits_2 := ((A.FParts[2] and carry_bits_mask) << NBits_carry);
      A.FParts[2]  := ((A.FParts[2] shr NBits) or carry_bits_1);

      carry_bits_1 := ((A.FParts[1] and carry_bits_mask) << NBits_carry);
      A.FParts[1]  := ((A.FParts[1] shr NBits) or carry_bits_2);

      A.FParts[0] := ((A.FParts[0] shr NBits) or carry_bits_1);

    end;
  end;

end;


{******************************************}
procedure ShiftDown_MultiBits_Multi_Int_X3(var A: TMultiIntX3; NBits: INT_1W_U);
var
  NWords_count, NBits_count: INT_1W_U;
begin
  if not A.FIsDefined then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (NBits >= INT_1W_SIZE) then
  begin
    NWords_count := (NBits div INT_1W_SIZE);
    NBits_count  := (NBits mod INT_1W_SIZE);
    ShiftDown_NWords_Multi_Int_X3(A, NWords_count);
  end
  else
    NBits_count := NBits;

  ShiftDown_NBits_Multi_Int_X3(A, NBits_count);
end;


{******************************************}
class operator TMultiIntX3.shl(const A: TMultiIntX3; const B: INT_1W_U): TMultiIntX3;
begin
  Result := A;
  ShiftUp_MultiBits_Multi_Int_X3(Result, B);
end;


{******************************************}
class operator TMultiIntX3.shr(const A: TMultiIntX3; const B: INT_1W_U): TMultiIntX3;
begin
  Result := A;
  ShiftDown_MultiBits_Multi_Int_X3(Result, B);
end;


(******************************************)
class operator TMultiIntX3.<=(const A, B: TMultiIntX3): boolean;
begin
  if not A.FIsDefined or (not B.FIsDefined) or (A.FHasOverflow) or
    (B.FHasOverflow) then
  begin
    Result := False;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  Result := False;
  if ((A.FIsNegative = False) and (B.FIsNegative = True)) then
    Result := False
  else
  if ((A.FIsNegative = True) and (B.FIsNegative = False)) then
    Result := True
  else
  if ((A.FIsNegative = False) and (B.FIsNegative = False)) then
    Result := (not ABS_greaterthan_Multi_Int_X3(A, B))
  else
  if ((A.FIsNegative = True) and (B.FIsNegative = True)) then
    Result := (not ABS_lessthan_Multi_Int_X3(A, B));
end;


(******************************************)
class operator TMultiIntX3.>=(const A, B: TMultiIntX3): boolean;
begin
  if not A.FIsDefined or (not B.FIsDefined) or (A.FHasOverflow) or
    (B.FHasOverflow) then
  begin
    Result := False;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  Result := False;
  if ((A.FIsNegative = False) and (B.FIsNegative = True)) then
    Result := True
  else
  if ((A.FIsNegative = True) and (B.FIsNegative = False)) then
    Result := False
  else
  if ((A.FIsNegative = False) and (B.FIsNegative = False)) then
    Result := (not ABS_lessthan_Multi_Int_X3(A, B))
  else
  if ((A.FIsNegative = True) and (B.FIsNegative = True)) then
    Result := (not ABS_greaterthan_Multi_Int_X3(A, B));
end;


(******************************************)
class operator TMultiIntX3.>(const A, B: TMultiIntX3): boolean;
begin
  if not A.FIsDefined or (not B.FIsDefined) or (A.FHasOverflow) or
    (B.FHasOverflow) then
  begin
    Result := False;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  Result := False;
  if ((A.FIsNegative = False) and (B.FIsNegative = True)) then
    Result := True
  else
  if ((A.FIsNegative = True) and (B.FIsNegative = False)) then
    Result := False
  else
  if ((A.FIsNegative = False) and (B.FIsNegative = False)) then
    Result := ABS_greaterthan_Multi_Int_X3(A, B)
  else
  if ((A.FIsNegative = True) and (B.FIsNegative = True)) then
    Result := ABS_lessthan_Multi_Int_X3(A, B);
end;


(******************************************)
class operator TMultiIntX3.<(const A, B: TMultiIntX3): boolean;
begin
  if not A.FIsDefined or (not B.FIsDefined) or (A.FHasOverflow) or
    (B.FHasOverflow) then
  begin
    Result := False;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  Result := False;
  if ((A.FIsNegative = True) and (B.FIsNegative = False)) then
    Result := True
  else
  if ((A.FIsNegative = False) and (B.FIsNegative = False)) then
    Result := ABS_lessthan_Multi_Int_X3(A, B)
  else
  if ((A.FIsNegative = True) and (B.FIsNegative = True)) then
    Result := ABS_greaterthan_Multi_Int_X3(A, B);
end;


(******************************************)
class operator TMultiIntX3.=(const A, B: TMultiIntX3): boolean;
begin
  if not A.FIsDefined or (not B.FIsDefined) or (A.FHasOverflow) or
    (B.FHasOverflow) then
  begin
    Result := False;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  Result := True;
  if (A.FIsNegative <> B.FIsNegative) then
    Result := False
  else
    Result := ABS_equal_Multi_Int_X3(A, B);
end;


(******************************************)
class operator TMultiIntX3.<>(const A, B: TMultiIntX3): boolean;
begin
  if not A.FIsDefined or (not B.FIsDefined) or (A.FHasOverflow) or
    (B.FHasOverflow) then
  begin
    Result := False;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  Result := False;
  if (A.FIsNegative <> B.FIsNegative) then
    Result := True
  else
    Result := (not ABS_equal_Multi_Int_X3(A, B));
end;


(******************************************)
procedure String_to_Multi_Int_X3(const A: ansistring; out mi: TMultiIntX3); inline;
label
  999;
var
  i, b, c, e: INT_2W_U;
  M_Val: array[0..Multi_X3_maxi] of INT_2W_U;
  Signeg, Zeroneg: boolean;
begin
  MultiIntError := False;

  mi.FHasOverflow := False;
  mi.FIsDefined := True;
  mi.FIsNegative := False;
  Signeg  := False;
  Zeroneg := False;

  M_Val[0] := 0;
  M_Val[1] := 0;
  M_Val[2] := 0;
  M_Val[3] := 0;
  M_Val[4] := 0;
  M_Val[5] := 0;

  if (length(A) > 0) then
  begin
    b := low(ansistring);
    e := b + INT_2W_U(length(A)) - 1;
    if (A[b] = '-') then
    begin
      Signeg := True;
      Inc(b);
    end;

    c := b;
    while (c <= e) do
    begin
      try
        i := StrToInt(A[c]);
      except
        on EConvertError do
        begin
          MultiIntError   := True;
          mi.FIsDefined   := False;
          mi.FHasOverflow := True;
          if MultiIntEnableExceptions then
            raise;
        end;
      end;
      if mi.FIsDefined = False then
        goto 999;
      M_Val[0] := (M_Val[0] * 10) + i;
      M_Val[1] := (M_Val[1] * 10);
      M_Val[2] := (M_Val[2] * 10);
      M_Val[3] := (M_Val[3] * 10);
      M_Val[4] := (M_Val[4] * 10);
      M_Val[5] := (M_Val[5] * 10);

      if M_Val[0] > INT_1W_U_MAXINT then
      begin
        M_Val[1] := M_Val[1] + (M_Val[0] div INT_1W_U_MAXINT_1);
        M_Val[0] := (M_Val[0] mod INT_1W_U_MAXINT_1);
      end;

      if M_Val[1] > INT_1W_U_MAXINT then
      begin
        M_Val[2] := M_Val[2] + (M_Val[1] div INT_1W_U_MAXINT_1);
        M_Val[1] := (M_Val[1] mod INT_1W_U_MAXINT_1);
      end;

      if M_Val[2] > INT_1W_U_MAXINT then
      begin
        M_Val[3] := M_Val[3] + (M_Val[2] div INT_1W_U_MAXINT_1);
        M_Val[2] := (M_Val[2] mod INT_1W_U_MAXINT_1);
      end;

      if M_Val[3] > INT_1W_U_MAXINT then
      begin
        M_Val[4] := M_Val[4] + (M_Val[3] div INT_1W_U_MAXINT_1);
        M_Val[3] := (M_Val[3] mod INT_1W_U_MAXINT_1);
      end;

      if M_Val[4] > INT_1W_U_MAXINT then
      begin
        M_Val[5] := M_Val[5] + (M_Val[4] div INT_1W_U_MAXINT_1);
        M_Val[4] := (M_Val[4] mod INT_1W_U_MAXINT_1);
      end;

      if M_Val[5] > INT_1W_U_MAXINT then
      begin
        MultiIntError   := True;
        mi.FIsDefined   := False;
        mi.FHasOverflow := True;
        if MultiIntEnableExceptions then
          raise EIntOverflow.Create('Overflow');
        goto 999;
      end;

      Inc(c);
    end;
  end;

  mi.FParts[0] := M_Val[0];
  mi.FParts[1] := M_Val[1];
  mi.FParts[2] := M_Val[2];
  mi.FParts[3] := M_Val[3];
  mi.FParts[4] := M_Val[4];
  mi.FParts[5] := M_Val[5];

  if (M_Val[0] = 0) and (M_Val[1] = 0) and (M_Val[2] = 0) and
    (M_Val[3] = 0) and (M_Val[4] = 0) and (M_Val[5] = 0) then
    Zeroneg := True;

  if Zeroneg then
    mi.FIsNegative := uBoolFalse
  else if Signeg then
    mi.FIsNegative := uBoolTrue
  else
    mi.FIsNegative := uBoolFalse;

  999: ;
end;


(******************************************)
class operator TMultiIntX3.:=(const A: ansistring): TMultiIntX3;
begin
  String_to_Multi_Int_X3(A, Result);
end;


{$ifdef CPU_32}
(******************************************)
procedure INT_4W_S_to_Multi_Int_X3(const A: INT_4W_S; out mi: TMultiIntX3); inline;
var
  v: INT_4W_U;
begin
  mi.Overflow_flag := False;
  mi.Defined_flag := True;
  v := Abs(A);

  v := A;
  mi.M_Value[0] := INT_1W_U(v mod INT_1W_U_MAXINT_1);
  v := (v div INT_1W_U_MAXINT_1);
  mi.M_Value[1] := INT_1W_U(v mod INT_1W_U_MAXINT_1);
  v := (v div INT_1W_U_MAXINT_1);
  mi.M_Value[2] := INT_1W_U(v mod INT_1W_U_MAXINT_1);
  v := (v div INT_1W_U_MAXINT_1);
  mi.M_Value[3] := v;

  mi.M_Value[4] := 0;
  mi.M_Value[5] := 0;

  if (A < 0) then
    mi.Negative_flag := uBoolTrue
  else
    mi.Negative_flag := uBoolFalse;

end;


(******************************************)
class operator TMultiIntX3.:=(const A: INT_4W_S): TMultiIntX3;
begin
  INT_4W_S_to_Multi_Int_X3(A, Result);
end;


(******************************************)
procedure INT_4W_U_to_Multi_Int_X3(const A: INT_4W_U; out mi: TMultiIntX3); inline;
var
  v: INT_4W_U;
begin
  mi.Overflow_flag := False;
  mi.Defined_flag  := True;
  mi.Negative_flag := uBoolFalse;

  v := A;
  mi.M_Value[0] := INT_1W_U(v mod INT_1W_U_MAXINT_1);
  v := (v div INT_1W_U_MAXINT_1);
  mi.M_Value[1] := INT_1W_U(v mod INT_1W_U_MAXINT_1);
  v := (v div INT_1W_U_MAXINT_1);
  mi.M_Value[2] := INT_1W_U(v mod INT_1W_U_MAXINT_1);
  v := (v div INT_1W_U_MAXINT_1);
  mi.M_Value[3] := v;

  mi.M_Value[4] := 0;
  mi.M_Value[5] := 0;

end;


(******************************************)
class operator TMultiIntX3.:=(const A: INT_4W_U): TMultiIntX3;
begin
  INT_4W_U_to_Multi_Int_X3(A, Result);
end;
{$endif}


(******************************************)
procedure INT_2W_S_to_Multi_Int_X3(const A: INT_2W_S; out mi: TMultiIntX3); inline;
begin
  mi.FHasOverflow := False;
  mi.FIsDefined   := True;
  mi.FParts[2]    := 0;
  mi.FParts[3]    := 0;
  mi.FParts[4]    := 0;
  mi.FParts[5]    := 0;

  if (A < 0) then
  begin
    mi.FIsNegative := uBoolTrue;
    mi.FParts[0]   := (ABS(A) mod INT_1W_U_MAXINT_1);
    mi.FParts[1]   := (ABS(A) div INT_1W_U_MAXINT_1);
  end
  else
  begin
    mi.FIsNegative := uBoolFalse;
    mi.FParts[0]   := (A mod INT_1W_U_MAXINT_1);
    mi.FParts[1]   := (A div INT_1W_U_MAXINT_1);
  end;
end;


(******************************************)
class operator TMultiIntX3.:=(const A: INT_2W_S): TMultiIntX3;
begin
  INT_2W_S_to_Multi_Int_X3(A, Result);
end;


(******************************************)
procedure INT_2W_U_to_Multi_Int_X3(const A: INT_2W_U; out mi: TMultiIntX3); inline;
begin
  mi.FHasOverflow := False;
  mi.FIsDefined   := True;
  mi.FIsNegative  := uBoolFalse;

  mi.FParts[0] := (A mod INT_1W_U_MAXINT_1);
  mi.FParts[1] := (A div INT_1W_U_MAXINT_1);
  mi.FParts[2] := 0;
  mi.FParts[3] := 0;
  mi.FParts[4] := 0;
  mi.FParts[5] := 0;
end;


(******************************************)
class operator TMultiIntX3.:=(const A: INT_2W_U): TMultiIntX3;
begin
  INT_2W_U_to_Multi_Int_X3(A, Result);
end;


(******************************************)
function To_Multi_Int_X3(const A: TMultiIntXV): TMultiIntX3;
label
  OVERFLOW_BRANCH, CLEAN_EXIT;
var
  n: INT_2W_U;
begin
  if (A.FIsDefined = False) then
  begin
    MultiIntError     := True;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FHasOverflow = True) then
    goto OVERFLOW_BRANCH;

  Result.FHasOverflow := A.FHasOverflow;
  Result.FIsDefined   := A.FIsDefined;
  Result.FIsNegative  := A.FIsNegative;

  n := 0;
  if (Multi_XV_size > Multi_X3_size) then
  begin
    while (n <= Multi_X3_maxi) do
    begin
      Result.FParts[n] := A.FParts[n];
      Inc(n);
    end;
    while (n <= Multi_XV_maxi) do
    begin
      if (A.FParts[n] <> 0) then
        goto OVERFLOW_BRANCH;
      Inc(n);
    end;
  end
  else
  begin
    while (n <= Multi_XV_maxi) do
    begin
      Result.FParts[n] := A.FParts[n];
      Inc(n);
    end;
    while (n <= Multi_X3_maxi) do
    begin
      Result.FParts[n] := 0;
      Inc(n);
    end;
  end;

  goto CLEAN_EXIT;

  OVERFLOW_BRANCH:

    MultiIntError     := True;
  Result.FHasOverflow := True;
  if MultiIntEnableExceptions then
    raise EInterror.Create('Overflow');
  exit;

  CLEAN_EXIT: ;

end;


{
var n :INT_1W_U;
begin
Result.Overflow_flag:= A.Overflow_flag;
Result.Defined_flag:= A.Defined_flag;
Result.Negative_flag:= A.Negative_flag;

if  (A.Defined_flag = FALSE)
then
  begin
  if MultiIntEnableExceptions then
    begin
    Raise EInterror.create('Uninitialised variable');
    end;
  Result.Defined_flag:= FALSE;
  exit;
  end;

if  (A.Overflow_flag = TRUE)
then
  begin
  MultiIntError:= TRUE;
  Result.Overflow_flag:= TRUE;
  if MultiIntEnableExceptions then
    begin
    Raise EInterror.create('Overflow');
    end;
  exit;
  end;

n:= 0;
while (n <= Multi_X3_maxi) do
  begin
  Result.M_Value[n]:= A.M_Value[n];
  inc(n);
  end;
end;
}


(******************************************)
function To_Multi_Int_X3(const A: TMultiIntX4): TMultiIntX3;
var
  n: INT_1W_U;
begin
  Result.FHasOverflow := A.FHasOverflow;
  Result.FIsDefined   := A.FIsDefined;
  Result.FIsNegative  := A.FIsNegative;

  if (A.FIsDefined = False) then
  begin
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FHasOverflow = True) or (A > Multi_Int_X3_MAXINT) then
  begin
    MultiIntError := True;
    Result.FHasOverflow := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    exit;
  end;

  n := 0;
  while (n <= Multi_X3_maxi) do
  begin
    Result.FParts[n] := A.FParts[n];
    Inc(n);
  end;
end;


(******************************************)
function To_Multi_Int_X3(const A: TMultiIntX2): TMultiIntX3;
var
  n: INT_1W_U;
begin
  Result.FHasOverflow := A.FHasOverflow;
  Result.FIsDefined   := A.FIsDefined;
  Result.FIsNegative  := A.FIsNegative;

  if (A.FIsDefined = False) then
  begin
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    Result.FIsDefined := False;
    exit;
  end;

  if (A.FHasOverflow = True) then
  begin
    MultiIntError := True;
    Result.FHasOverflow := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    exit;
  end;

  n := 0;
  while (n <= Multi_X2_maxi) do
  begin
    Result.FParts[n] := A.FParts[n];
    Inc(n);
  end;

  while (n <= Multi_X3_maxi) do
  begin
    Result.FParts[n] := 0;
    Inc(n);
  end;
end;


(******************************************)
procedure Multi_Int_X2_to_Multi_Int_X3(const A: TMultiIntX2;
  out MI: TMultiIntX3); inline;
var
  n: INT_1W_U;
begin
  MI.FHasOverflow := A.FHasOverflow;
  MI.FIsDefined   := A.FIsDefined;
  MI.FIsNegative  := A.FIsNegative;

  if (A.FIsDefined = False) then
  begin
    MultiIntError := True;
    MI.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FHasOverflow = True) then
  begin
    MultiIntError   := True;
    MI.FHasOverflow := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    exit;
  end;

  n := 0;
  while (n <= Multi_X2_maxi) do
  begin
    MI.FParts[n] := A.FParts[n];
    Inc(n);
  end;

  while (n <= Multi_X3_maxi) do
  begin
    MI.FParts[n] := 0;
    Inc(n);
  end;
end;


(******************************************)
class operator TMultiIntX3.:=(const A: TMultiIntX2): TMultiIntX3;
begin
  Multi_Int_X2_to_Multi_Int_X3(A, Result);
end;


(******************************************)
// WARNING Float to Multi_Int type conversion loses some precision
class operator TMultiIntX3.:=(const A: single): TMultiIntX3;
var
  R: TMultiIntX3;
  R_FLOATREC: TFloatRec;
begin
  MultiIntError := False;

  FloatToDecimal(R_FLOATREC, A, SINGLE_TYPE_PRECISION_DIGITS, 0);
  String_to_Multi_Int_X3(AddCharR('0', AnsiLeftStr(R_FLOATREC.digits,
    (SINGLE_TYPE_PRECISION_DIGITS - 1)), R_FLOATREC.Exponent), R);

  if (R.HasOverflow) then
  begin
    MultiIntError      := True;
    Result.FIsDefined  := False;
    Result.FIsNegative := uBoolUndefined;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  if (R_FLOATREC.Negative) then
    R.FIsNegative := True;
  Result := R;
end;


(******************************************)
// WARNING Float to Multi_Int type conversion loses some precision
class operator TMultiIntX3.:=(const A: real): TMultiIntX3;
var
  R: TMultiIntX3;
  R_FLOATREC: TFloatRec;
begin
  MultiIntError := False;

  FloatToDecimal(R_FLOATREC, A, REAL_TYPE_PRECISION_DIGITS, 0);
  String_to_Multi_Int_X3(AddCharR('0', AnsiLeftStr(R_FLOATREC.digits,
    (REAL_TYPE_PRECISION_DIGITS - 1)), R_FLOATREC.Exponent), R);

  if (R.HasOverflow) then
  begin
    MultiIntError      := True;
    Result.FIsDefined  := False;
    Result.FIsNegative := uBoolUndefined;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  if (R_FLOATREC.Negative) then
    R.FIsNegative := True;
  Result := R;
end;


(******************************************)
// WARNING Float to Multi_Int type conversion loses some precision
class operator TMultiIntX3.:=(const A: double): TMultiIntX3;
var
  R: TMultiIntX3;
  R_FLOATREC: TFloatRec;
begin
  MultiIntError := False;

  FloatToDecimal(R_FLOATREC, A, DOUBLE_TYPE_PRECISION_DIGITS, 0);
  String_to_Multi_Int_X3(AddCharR('0', AnsiLeftStr(R_FLOATREC.digits,
    (DOUBLE_TYPE_PRECISION_DIGITS - 1)), R_FLOATREC.Exponent), R);

  if (R.HasOverflow) then
  begin
    MultiIntError      := True;
    Result.FIsDefined  := False;
    Result.FIsNegative := uBoolUndefined;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  if (R_FLOATREC.Negative) then
    R.FIsNegative := True;
  Result := R;
end;


(******************************************)
class operator TMultiIntX3.:=(const A: TMultiIntX3): single;
var
  R, V, M: single;
  i: INT_1W_U;
  finished: boolean;
begin
  if not A.FIsDefined then
  begin
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  MultiIntError := False;
  finished := False;
  M := INT_1W_U_MAXINT_1;

  R := A.FParts[0];
  i := 1;
  while (i <= Multi_X3_maxi) and (not MultiIntError) do
  begin
    if (not finished) then
    begin
      V := A.FParts[i];
      try
        begin
          V := (V * M);
          R := R + V;
        end
      except
        begin
          MultiIntError := True;
          if MultiIntEnableExceptions then
            raise EIntOverflow.Create('Overflow');
        end;
      end;
      V := INT_1W_U_MAXINT_1;
      try
        M := (M * V);
      except
        finished := True;
      end;
    end
    else
    if (A.FParts[i] > 0) then
    begin
      MultiIntError := True;
      if MultiIntEnableExceptions then
        raise EIntOverflow.Create('Overflow');
    end;
    Inc(i);
  end;

  if A.FIsNegative then
    R    := (-R);
  Result := R;
end;


(******************************************)
class operator TMultiIntX3.:=(const A: TMultiIntX3): real;
var
  R, V, M: real;
  i: INT_1W_U;
  finished: boolean;
begin
  if not A.FIsDefined then
  begin
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  MultiIntError := False;
  finished := False;
  M := INT_1W_U_MAXINT_1;

  R := A.FParts[0];
  i := 1;
  while (i <= Multi_X3_maxi) and (not MultiIntError) do
  begin
    if (not finished) then
    begin
      V := A.FParts[i];
      try
        begin
          V := (V * M);
          R := R + V;
        end
      except
        begin
          MultiIntError := True;
          if MultiIntEnableExceptions then
            raise EIntOverflow.Create('Overflow');
        end;
      end;
      V := INT_1W_U_MAXINT_1;
      try
        M := (M * V);
      except
        finished := True;
      end;
    end
    else
    if (A.FParts[i] > 0) then
    begin
      MultiIntError := True;
      if MultiIntEnableExceptions then
        raise EIntOverflow.Create('Overflow');
    end;
    Inc(i);
  end;

  if A.FIsNegative then
    R    := (-R);
  Result := R;
end;


(******************************************)
class operator TMultiIntX3.:=(const A: TMultiIntX3): double;
var
  R, V, M: double;
  i: INT_1W_U;
  finished: boolean;
begin
  if not A.FIsDefined then
  begin
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  MultiIntError := False;
  finished := False;
  M := INT_1W_U_MAXINT_1;

  R := A.FParts[0];
  i := 1;
  while (i <= Multi_X3_maxi) and (not MultiIntError) do
  begin
    if (not finished) then
    begin
      V := A.FParts[i];
      try
        begin
          V := (V * M);
          R := R + V;
        end
      except
        begin
          MultiIntError := True;
          if MultiIntEnableExceptions then
            raise EIntOverflow.Create('Overflow');
        end;
      end;
      V := INT_1W_U_MAXINT_1;
      try
        M := (M * V);
      except
        finished := True;
      end;
    end
    else
    if (A.FParts[i] > 0) then
    begin
      MultiIntError := True;
      if MultiIntEnableExceptions then
        raise EIntOverflow.Create('Overflow');
    end;
    Inc(i);
  end;

  if A.FIsNegative then
    R    := (-R);
  Result := R;
end;


(******************************************)
class operator TMultiIntX3.:=(const A: TMultiIntX3): INT_2W_S;
var
  R: INT_2W_U;
begin
  MultiIntError := False;
  if not A.FIsDefined then
  begin
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  R := (INT_2W_U(A.FParts[0]) + (INT_2W_U(A.FParts[1]) * INT_1W_U_MAXINT_1));

  if (R > INT_2W_S_MAXINT) or (A.FParts[2] <> 0) or (A.FParts[3] <> 0) or
    (A.FParts[4] <> 0) or (A.FParts[5] <> 0) then
  begin
    Result := 0;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    exit;
  end;

  if A.FIsNegative then
    Result := INT_2W_S(-R)
  else
    Result := INT_2W_S(R);
end;


(******************************************)
class operator TMultiIntX3.:=(const A: TMultiIntX3): INT_2W_U;
var
  R: INT_2W_U;
begin
  MultiIntError := False;
  if not A.FIsDefined then
  begin
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  R := (INT_2W_U(A.FParts[1]) << INT_1W_SIZE);
  R := (R or INT_2W_U(A.FParts[0]));

  if (A.FParts[2] <> 0) or (A.FParts[3] <> 0) or (A.FParts[4] <> 0) or
    (A.FParts[5] <> 0) then
  begin
    Result := 0;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    exit;
  end;
  Result := R;
end;


(******************************************)
class operator TMultiIntX3.:=(const A: TMultiIntX3): INT_1W_S;
var
  R: INT_2W_U;
begin
  MultiIntError := False;
  if not A.FIsDefined then
  begin
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  R := (INT_2W_U(A.FParts[0]) + (INT_2W_U(A.FParts[1]) * INT_1W_U_MAXINT_1));

  if (R > INT_1W_S_MAXINT) or (A.FParts[2] <> 0) or (A.FParts[3] <> 0) or
    (A.FParts[4] <> 0) or (A.FParts[5] <> 0) then
  begin
    Result := 0;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    exit;
  end;

  if A.FIsNegative then
    Result := INT_1W_S(-R)
  else
    Result := INT_1W_S(R);
end;


(******************************************)
class operator TMultiIntX3.:=(const A: TMultiIntX3): INT_1W_U;
var
  R: INT_2W_U;
begin
  MultiIntError := False;
  if not A.FIsDefined or (A.FIsNegative = uBoolTrue) then
  begin
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  R := (A.FParts[0] + (A.FParts[1] * INT_1W_U_MAXINT_1));

  if (R > INT_1W_U_MAXINT) or (A.FParts[2] <> 0) or (A.FParts[3] <> 0) or
    (A.FParts[4] <> 0) or (A.FParts[5] <> 0) then
  begin
    Result := 0;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    exit;
  end;

  Result := INT_1W_U(R);
end;


{******************************************}
class operator TMultiIntX3.:=(const A: TMultiIntX3): TMultiUInt8;
  (* var  R  :TMultiUInt8; *)
begin
  MultiIntError := False;
  if not A.FIsDefined or (A.FIsNegative = uBoolTrue) then
  begin
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FParts[0] > UINT8_MAX) or (A.FParts[1] <> 0) or (A.FParts[2] <> 0) or
    (A.FParts[3] <> 0) or (A.FParts[4] <> 0) or (A.FParts[5] <> 0) then
  begin
    MultiIntError := True;
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    exit;
  end;

  Result := TMultiUInt8(A.FParts[0]);
end;


{******************************************}
class operator TMultiIntX3.:=(const A: TMultiIntX3): TMultiInt8;
  (* var  R  :TMultiInt8; *)
begin
  MultiIntError := False;
  if not A.FIsDefined or (A.FIsNegative = uBoolTrue) then
  begin
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FParts[0] > INT8_MAX) or (A.FParts[2] <> 0) or (A.FParts[3] <> 0) or
    (A.FParts[4] <> 0) or (A.FParts[5] <> 0) then
  begin
    MultiIntError := True;
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  Result := TMultiInt8(A.FParts[0]);
end;


(******************************************)
procedure bin_to_Multi_Int_X3(const A: ansistring; out mi: TMultiIntX3); inline;
label
  999;
var
  n, b, c, e: INT_2W_U;
  bit: INT_1W_S;
  M_Val: array[0..Multi_X3_maxi] of INT_2W_U;
  Signeg, Zeroneg, M_Val_All_Zero: boolean;
begin
  MultiIntError := False;

  mi.FHasOverflow := False;
  mi.FIsDefined := True;
  mi.FIsNegative := False;
  Signeg  := False;
  Zeroneg := False;

  n := 0;
  while (n <= Multi_X3_maxi) do
  begin
    M_Val[n] := 0;
    Inc(n);
  end;

  if (length(A) > 0) then
  begin
    b := low(ansistring);
    e := b + INT_2W_U(length(A)) - 1;
    if (A[b] = '-') then
    begin
      Signeg := True;
      Inc(b);
    end;

    c := b;
    while (c <= e) do
    begin
      bit := (Ord(A[c]) - Ord('0'));
      if (bit > 1) or (bit < 0) then
      begin
        MultiIntError   := True;
        mi.FIsDefined   := False;
        mi.FHasOverflow := True;
        if MultiIntEnableExceptions then
          raise EInterror.Create('Invalid binary digit');
        goto 999;
      end;

      M_Val[0] := (M_Val[0] * 2) + bit;
      n := 1;
      while (n <= Multi_X3_maxi) do
      begin
        M_Val[n] := (M_Val[n] * 2);
        Inc(n);
      end;

      n := 0;
      while (n < Multi_X3_maxi) do
      begin
        if M_Val[n] > INT_1W_U_MAXINT then
        begin
          M_Val[n + 1] := M_Val[n + 1] + (M_Val[n] div INT_1W_U_MAXINT_1);
          M_Val[n]     := (M_Val[n] mod INT_1W_U_MAXINT_1);
        end;

        Inc(n);
      end;

      if M_Val[n] > INT_1W_U_MAXINT then
      begin
        mi.FIsDefined   := False;
        mi.FHasOverflow := True;
        MultiIntError   := True;
        if MultiIntEnableExceptions then
          raise EIntOverflow.Create('Overflow');
        goto 999;
      end;
      Inc(c);
    end;
  end;

  M_Val_All_Zero := True;
  n := 0;
  while (n <= Multi_X3_maxi) do
  begin
    mi.FParts[n] := M_Val[n];
    if M_Val[n] > 0 then
      M_Val_All_Zero := False;
    Inc(n);
  end;
  if M_Val_All_Zero then
    Zeroneg := True;

  if Zeroneg then
    mi.FIsNegative := uBoolFalse
  else if Signeg then
    mi.FIsNegative := uBoolTrue
  else
    mi.FIsNegative := uBoolFalse;

  999: ;
end;


(******************************************)
procedure FromBin(const A: ansistring; out mi: TMultiIntX3); overload;
begin
  Bin_to_Multi_Int_X3(A, mi);
end;


(******************************************)
function TMultiIntX3.FromBinaryString(const A: ansistring): TMultiIntX3;
begin
  bin_to_Multi_Int_X3(A, Result);
end;


(******************************************)
procedure Multi_Int_X3_to_bin(const A: TMultiIntX3; out B: ansistring;
  LeadingZeroMode: TMultiLeadingZeros); inline;
var
  s: ansistring = '';
  n: INT_1W_S;
begin
  if not A.FIsDefined then
  begin
    B := 'UNDEFINED';
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow) then
  begin
    B := 'OVERFLOW';
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    exit;
  end;

  n := INT_1W_SIZE;
  s := '';

  s := s + IntToBin(A.FParts[5], n) + IntToBin(A.FParts[4], n) +
    IntToBin(A.FParts[3], n) + IntToBin(A.FParts[2], n) +
    IntToBin(A.FParts[1], n) + IntToBin(A.FParts[0], n);

  if (LeadingZeroMode = TrimLeadingZeros) then
    RemoveLeadingChars(s, ['0']);
  if (A.FIsNegative = uBoolTrue) then
    s := '-' + s;
  if (s = '') then
    s := '0';
  B   := s;
end;


(******************************************)
function TMultiIntX3.ToBinaryString(const LeadingZeroMode: TMultiLeadingZeros):
ansistring;
begin
  Multi_Int_X3_to_bin(Self, Result, LeadingZeroMode);
end;


(******************************************)
procedure Multi_Int_X3_to_hex(const A: TMultiIntX3; out B: ansistring;
  LeadingZeroMode: TMultiLeadingZeros); inline;
var
  s: ansistring = '';
  n: TMultiUInt16;
begin
  if not A.FIsDefined then
  begin
    B := 'UNDEFINED';
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow) then
  begin
    MultiIntError := True;
    B := 'OVERFLOW';
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  n := (INT_1W_SIZE div 4);
  s := '';

  s := s + IntToHex(A.FParts[5], n) + IntToHex(A.FParts[4], n) +
    IntToHex(A.FParts[3], n) + IntToHex(A.FParts[2], n) +
    IntToHex(A.FParts[1], n) + IntToHex(A.FParts[0], n);

  if (LeadingZeroMode = TrimLeadingZeros) then
    RemoveLeadingChars(s, ['0']);
  if (A.FIsNegative = uBoolTrue) then
    s := '-' + s;
  if (s = '') then
    s := '0';
  B   := s;
end;


(******************************************)
function TMultiIntX3.ToHexString(const LeadingZeroMode: TMultiLeadingZeros): ansistring;
begin
  Multi_Int_X3_to_hex(Self, Result, LeadingZeroMode);
end;


(******************************************)
procedure hex_to_Multi_Int_X3(const A: ansistring; out mi: TMultiIntX3); inline;
label
  999;
var
  n, i, b, c, e: INT_2W_U;
  M_Val: array[0..Multi_X3_maxi] of INT_2W_U;
  Signeg, Zeroneg, M_Val_All_Zero: boolean;
begin
  MultiIntError := False;

  mi.FHasOverflow := False;
  mi.FIsDefined := True;
  mi.FIsNegative := False;
  Signeg  := False;
  Zeroneg := False;

  n := 0;
  while (n <= Multi_X3_maxi) do
  begin
    M_Val[n] := 0;
    Inc(n);
  end;

  if (length(A) > 0) then
  begin
    b := low(ansistring);
    e := b + INT_2W_U(length(A)) - 1;
    if (A[b] = '-') then
    begin
      Signeg := True;
      Inc(b);
    end;

    c := b;
    while (c <= e) do
    begin
      try
        i := Hex2Dec(A[c]);
      except
        on EConvertError do
        begin
          MultiIntError   := True;
          mi.FIsDefined   := False;
          mi.FHasOverflow := True;
          if MultiIntEnableExceptions then
            raise;
        end;
      end;
      if mi.FIsDefined = False then
        goto 999;

      M_Val[0] := (M_Val[0] * 16) + i;
      n := 1;
      while (n <= Multi_X3_maxi) do
      begin
        M_Val[n] := (M_Val[n] * 16);
        Inc(n);
      end;

      n := 0;
      while (n < Multi_X3_maxi) do
      begin
        if M_Val[n] > INT_1W_U_MAXINT then
        begin
          M_Val[n + 1] := M_Val[n + 1] + (M_Val[n] div INT_1W_U_MAXINT_1);
          M_Val[n]     := (M_Val[n] mod INT_1W_U_MAXINT_1);
        end;

        Inc(n);
      end;

      if M_Val[n] > INT_1W_U_MAXINT then
      begin
        MultiIntError   := True;
        mi.FIsDefined   := False;
        mi.FHasOverflow := True;
        if MultiIntEnableExceptions then
          raise EIntOverflow.Create('Overflow');
        goto 999;
      end;
      Inc(c);
    end;
  end;

  M_Val_All_Zero := True;
  n := 0;
  while (n <= Multi_X3_maxi) do
  begin
    mi.FParts[n] := M_Val[n];
    if M_Val[n] > 0 then
      M_Val_All_Zero := False;
    Inc(n);
  end;
  if M_Val_All_Zero then
    Zeroneg := True;

  if Zeroneg then
    mi.FIsNegative := uBoolFalse
  else if Signeg then
    mi.FIsNegative := uBoolTrue
  else
    mi.FIsNegative := uBoolFalse;

  999: ;
end;


(******************************************)
procedure FromHex(const A: ansistring; out B: TMultiIntX3); overload;
begin
  hex_to_Multi_Int_X3(A, B);
end;


(******************************************)
function TMultiIntX3.FromHexString(const A: ansistring): TMultiIntX3;
begin
  hex_to_Multi_Int_X3(A, Result);
end;


(******************************************)
procedure Multi_Int_X3_to_String(const A: TMultiIntX3; out B: ansistring); inline;
var
  s: ansistring = '';
  M_Val: array[0..Multi_X3_maxi] of INT_2W_U;
begin
  if not A.FIsDefined then
  begin
    B := 'UNDEFINED';
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow) then
  begin
    MultiIntError := True;
    B := 'OVERFLOW';
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    exit;
  end;

  M_Val[0] := A.FParts[0];
  M_Val[1] := A.FParts[1];
  M_Val[2] := A.FParts[2];
  M_Val[3] := A.FParts[3];
  M_Val[4] := A.FParts[4];
  M_Val[5] := A.FParts[5];

  repeat

    M_Val[4] := M_Val[4] + (INT_1W_U_MAXINT_1 * (M_Val[5] mod 10));
    M_Val[5] := (M_Val[5] div 10);

    M_Val[3] := M_Val[3] + (INT_1W_U_MAXINT_1 * (M_Val[4] mod 10));
    M_Val[4] := (M_Val[4] div 10);

    M_Val[2] := M_Val[2] + (INT_1W_U_MAXINT_1 * (M_Val[3] mod 10));
    M_Val[3] := (M_Val[3] div 10);

    M_Val[1] := M_Val[1] + (INT_1W_U_MAXINT_1 * (M_Val[2] mod 10));
    M_Val[2] := (M_Val[2] div 10);

    M_Val[0] := M_Val[0] + (INT_1W_U_MAXINT_1 * (M_Val[1] mod 10));
    M_Val[1] := (M_Val[1] div 10);

    s := IntToStr(M_Val[0] mod 10) + s;
    M_Val[0] := (M_Val[0] div 10);

  until (0 = 0) and (M_Val[0] = 0) and (M_Val[1] = 0) and (M_Val[2] = 0) and
    (M_Val[3] = 0) and (M_Val[4] = 0) and (M_Val[5] = 0);

  if (A.FIsNegative = uBoolTrue) then
    s := '-' + s;

  B := s;
end;


(******************************************)
function TMultiIntX3.ToString: ansistring;
begin
  Multi_Int_X3_to_String(Self, Result);
end;


(******************************************)
class operator TMultiIntX3.:=(const A: TMultiIntX3): ansistring;
begin
  Multi_Int_X3_to_String(A, Result);
end;


(******************************************)
class operator TMultiIntX3.xor(const A, B: TMultiIntX3): TMultiIntX3;
begin
  if not A.FIsDefined or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow or B.FHasOverflow) then
  begin
    Result := 0;
    Result.FHasOverflow := True;
    Result.FIsDefined := False;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  Result.FParts[0]    := (A.FParts[0] xor B.FParts[0]);
  Result.FParts[1]    := (A.FParts[1] xor B.FParts[1]);
  Result.FParts[2]    := (A.FParts[2] xor B.FParts[2]);
  Result.FParts[3]    := (A.FParts[3] xor B.FParts[3]);
  Result.FParts[4]    := (A.FParts[4] xor B.FParts[4]);
  Result.FParts[5]    := (A.FParts[5] xor B.FParts[5]);
  Result.FIsDefined   := True;
  Result.FHasOverflow := False;

  Result.FIsNegative := uBoolFalse;
  if (A.IsNegative <> B.IsNegative) then
    Result.FIsNegative := uBoolTrue;
end;


(******************************************)
class operator TMultiIntX3.or(const A, B: TMultiIntX3): TMultiIntX3;
begin
  if not A.FIsDefined or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  Result.FParts[0]    := (A.FParts[0] or B.FParts[0]);
  Result.FParts[1]    := (A.FParts[1] or B.FParts[1]);
  Result.FParts[2]    := (A.FParts[2] or B.FParts[2]);
  Result.FParts[3]    := (A.FParts[3] or B.FParts[3]);
  Result.FParts[4]    := (A.FParts[4] or B.FParts[4]);
  Result.FParts[5]    := (A.FParts[5] or B.FParts[5]);
  Result.FIsDefined   := True;
  Result.FHasOverflow := False;

  Result.FIsNegative := uBoolFalse;
  if A.IsNegative and B.IsNegative then
    Result.FIsNegative := uBoolTrue;
end;


(******************************************)
class operator TMultiIntX3.and(const A, B: TMultiIntX3): TMultiIntX3;
begin
  if not A.FIsDefined or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  Result.FParts[0]    := (A.FParts[0] and B.FParts[0]);
  Result.FParts[1]    := (A.FParts[1] and B.FParts[1]);
  Result.FParts[2]    := (A.FParts[2] and B.FParts[2]);
  Result.FParts[3]    := (A.FParts[3] and B.FParts[3]);
  Result.FParts[4]    := (A.FParts[4] and B.FParts[4]);
  Result.FParts[5]    := (A.FParts[5] and B.FParts[5]);
  Result.FIsDefined   := True;
  Result.FHasOverflow := False;

  Result.FIsNegative := uBoolFalse;
  if A.IsNegative and B.IsNegative then
    Result.FIsNegative := uBoolTrue;
end;


(******************************************)
class operator TMultiIntX3.not(const A: TMultiIntX3): TMultiIntX3;
begin
  if not A.FIsDefined then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  Result.FParts[0]    := (not A.FParts[0]);
  Result.FParts[1]    := (not A.FParts[1]);
  Result.FParts[2]    := (not A.FParts[2]);
  Result.FParts[3]    := (not A.FParts[3]);
  Result.FParts[4]    := (not A.FParts[4]);
  Result.FParts[5]    := (not A.FParts[5]);
  Result.FIsDefined   := True;
  Result.FHasOverflow := False;

  Result.FIsNegative := uBoolTrue;
  if A.IsNegative then
    Result.FIsNegative := uBoolFalse;
end;


(******************************************)
function add_Multi_Int_X3(const A, B: TMultiIntX3): TMultiIntX3;
var
  tv1, tv2: INT_2W_U;
  M_Val: array[0..Multi_X3_maxi] of INT_2W_U;
begin
  Result.FHasOverflow := False;
  Result.FIsDefined   := True;
  Result.FIsNegative  := uBoolUndefined;

  tv1      := A.FParts[0];
  tv2      := B.FParts[0];
  M_Val[0] := (tv1 + tv2);
  if M_Val[0] > INT_1W_U_MAXINT then
  begin
    M_Val[1] := (M_Val[0] div INT_1W_U_MAXINT_1);
    M_Val[0] := (M_Val[0] mod INT_1W_U_MAXINT_1);
  end
  else
    M_Val[1] := 0;

  tv1      := A.FParts[1];
  tv2      := B.FParts[1];
  M_Val[1] := (M_Val[1] + tv1 + tv2);
  if M_Val[1] > INT_1W_U_MAXINT then
  begin
    M_Val[2] := (M_Val[1] div INT_1W_U_MAXINT_1);
    M_Val[1] := (M_Val[1] mod INT_1W_U_MAXINT_1);
  end
  else
    M_Val[2] := 0;

  tv1      := A.FParts[2];
  tv2      := B.FParts[2];
  M_Val[2] := (M_Val[2] + tv1 + tv2);
  if M_Val[2] > INT_1W_U_MAXINT then
  begin
    M_Val[3] := (M_Val[2] div INT_1W_U_MAXINT_1);
    M_Val[2] := (M_Val[2] mod INT_1W_U_MAXINT_1);
  end
  else
    M_Val[3] := 0;

  tv1      := A.FParts[3];
  tv2      := B.FParts[3];
  M_Val[3] := (M_Val[3] + tv1 + tv2);
  if M_Val[3] > INT_1W_U_MAXINT then
  begin
    M_Val[4] := (M_Val[3] div INT_1W_U_MAXINT_1);
    M_Val[3] := (M_Val[3] mod INT_1W_U_MAXINT_1);
  end
  else
    M_Val[4] := 0;

  tv1      := A.FParts[4];
  tv2      := B.FParts[4];
  M_Val[4] := (M_Val[4] + tv1 + tv2);
  if M_Val[4] > INT_1W_U_MAXINT then
  begin
    M_Val[5] := (M_Val[4] div INT_1W_U_MAXINT_1);
    M_Val[4] := (M_Val[4] mod INT_1W_U_MAXINT_1);
  end
  else
    M_Val[5] := 0;

  tv1      := A.FParts[5];
  tv2      := B.FParts[5];
  M_Val[5] := (M_Val[5] + tv1 + tv2);
  if M_Val[5] > INT_1W_U_MAXINT then
  begin
    M_Val[5] := (M_Val[5] mod INT_1W_U_MAXINT_1);
    Result.FIsDefined := False;
    Result.FHasOverflow := True;
  end;

  Result.FParts[0] := M_Val[0];
  Result.FParts[1] := M_Val[1];
  Result.FParts[2] := M_Val[2];
  Result.FParts[3] := M_Val[3];
  Result.FParts[4] := M_Val[4];
  Result.FParts[5] := M_Val[5];

  if (M_Val[0] = 0) and (M_Val[1] = 0) and (M_Val[2] = 0) and
    (M_Val[3] = 0) and (M_Val[4] = 0) and (M_Val[5] = 0) then
    Result.FIsNegative := uBoolFalse;

end;


(******************************************)
function subtract_Multi_Int_X3(const A, B: TMultiIntX3): TMultiIntX3;
var
  M_Val: array[0..Multi_X3_maxi] of INT_2W_S;
begin
  Result.FHasOverflow := False;
  Result.FIsDefined   := True;
  Result.FIsNegative  := uBoolUndefined;

  M_Val[0] := (A.FParts[0] - B.FParts[0]);
  if M_Val[0] < 0 then
  begin
    M_Val[1] := -1;
    M_Val[0] := (M_Val[0] + INT_1W_U_MAXINT_1);
  end
  else
    M_Val[1] := 0;

  M_Val[1] := (A.FParts[1] - B.FParts[1] + M_Val[1]);
  if M_Val[1] < 0 then
  begin
    M_Val[2] := -1;
    M_Val[1] := (M_Val[1] + INT_1W_U_MAXINT_1);
  end
  else
    M_Val[2] := 0;

  M_Val[2] := (A.FParts[2] - B.FParts[2] + M_Val[2]);
  if M_Val[2] < 0 then
  begin
    M_Val[3] := -1;
    M_Val[2] := (M_Val[2] + INT_1W_U_MAXINT_1);
  end
  else
    M_Val[3] := 0;

  M_Val[3] := (A.FParts[3] - B.FParts[3] + M_Val[3]);
  if M_Val[3] < 0 then
  begin
    M_Val[4] := -1;
    M_Val[3] := (M_Val[3] + INT_1W_U_MAXINT_1);
  end
  else
    M_Val[4] := 0;

  M_Val[4] := (A.FParts[4] - B.FParts[4] + M_Val[4]);
  if M_Val[4] < 0 then
  begin
    M_Val[5] := -1;
    M_Val[4] := (M_Val[4] + INT_1W_U_MAXINT_1);
  end
  else
    M_Val[5] := 0;

  M_Val[5] := (A.FParts[5] - B.FParts[5] + M_Val[5]);
  if M_Val[5] < 0 then
  begin
    Result.FIsDefined   := False;
    Result.FHasOverflow := True;
  end;

  Result.FParts[0] := M_Val[0];
  Result.FParts[1] := M_Val[1];
  Result.FParts[2] := M_Val[2];
  Result.FParts[3] := M_Val[3];
  Result.FParts[4] := M_Val[4];
  Result.FParts[5] := M_Val[5];

  if (M_Val[0] = 0) and (M_Val[1] = 0) and (M_Val[2] = 0) and
    (M_Val[3] = 0) and (M_Val[4] = 0) and (M_Val[5] = 0) then
    Result.FIsNegative := uBoolFalse;

end;


(******************************************)
class operator TMultiIntX3.Inc(const A: TMultiIntX3): TMultiIntX3;
var
  Neg: TMultiUBoolState;
  B: TMultiIntX3;
begin
  if not A.FIsDefined then
  begin
    Result := 0;
    Result.FIsDefined := A.FIsDefined;
    Result.FHasOverflow := A.FHasOverflow;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FHasOverflow) then
  begin
    MultiIntError := True;
    Result := 0;
    Result.FIsDefined := A.FIsDefined;
    Result.FHasOverflow := A.FHasOverflow;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  Neg := uBoolUndefined;
  B   := 1;

  if (A.FIsNegative = False) then
  begin
    Result := add_Multi_Int_X3(A, B);
    Neg    := A.FIsNegative;
  end
  else
  if ABS_greaterthan_Multi_Int_X3(A, B) then
  begin
    Result := subtract_Multi_Int_X3(A, B);
    Neg    := uBoolTrue;
  end
  else
  begin
    Result := subtract_Multi_Int_X3(B, A);
    Neg    := uBoolFalse;
  end;

  if (Result.FHasOverflow = True) then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
  end;

  if (Result.FIsNegative = uBoolUndefined) then
    Result.FIsNegative := Neg;
end;


(******************************************)
class operator TMultiIntX3.+(const A, B: TMultiIntX3): TMultiIntX3;
var
  Neg: TMultiUBool;
begin
  if not A.FIsDefined or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FHasOverflow or B.FHasOverflow) then
  begin
    MultiIntError := True;
    Result := 0;
    Result.FHasOverflow := True;
    Result.FIsDefined := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  Neg := uBoolUndefined;

  if (A.FIsNegative = B.FIsNegative) then
  begin
    Result := add_Multi_Int_X3(A, B);
    Neg    := A.FIsNegative;
  end
  else
  if ((A.FIsNegative = False) and (B.FIsNegative = True)) then
  begin
    if ABS_greaterthan_Multi_Int_X3(B, A) then
    begin
      Result := subtract_Multi_Int_X3(B, A);
      Neg    := uBoolTrue;
    end
    else
    begin
      Result := subtract_Multi_Int_X3(A, B);
      Neg    := uBoolFalse;
    end;
  end
  else
  if ABS_greaterthan_Multi_Int_X3(A, B) then
  begin
    Result := subtract_Multi_Int_X3(A, B);
    Neg    := uBoolTrue;
  end
  else
  begin
    Result := subtract_Multi_Int_X3(B, A);
    Neg    := uBoolFalse;
  end;

  if (Result.FHasOverflow = True) then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
  end;

  if (Result.FIsNegative = uBoolUndefined) then
    Result.FIsNegative := Neg;
end;


(******************************************)
class operator TMultiIntX3.Dec(const A: TMultiIntX3): TMultiIntX3;
var
  Neg: TMultiUBoolState;
  B: TMultiIntX3;
begin
  if not A.FIsDefined then
  begin
    Result := 0;
    Result.FIsDefined := A.FIsDefined;
    Result.FHasOverflow := A.FHasOverflow;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FHasOverflow) then
  begin
    Result := 0;
    Result.FIsDefined := A.FIsDefined;
    Result.FHasOverflow := A.FHasOverflow;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  Neg := uBoolUndefined;
  B   := 1;

  if (A.FIsNegative = False) then
  begin
    if ABS_greaterthan_Multi_Int_X3(B, A) then
    begin
      Result := subtract_Multi_Int_X3(B, A);
      Neg    := uBoolTrue;
    end
    else
    begin
      Result := subtract_Multi_Int_X3(A, B);
      Neg    := uBoolFalse;
    end;
  end
  else (* A is FIsNegative *)
  begin
    Result := add_Multi_Int_X3(A, B);
    Neg    := uBoolTrue;
  end;

  if (Result.FHasOverflow = True) then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
  end;

  if (Result.FIsNegative = uBoolUndefined) then
    Result.FIsNegative := Neg;
end;


(******************************************)
class operator TMultiIntX3.-(const A, B: TMultiIntX3): TMultiIntX3;
var
  Neg: TMultiUBoolState;
begin
  if not A.FIsDefined or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FHasOverflow or B.FHasOverflow) then
  begin
    Result := 0;
    Result.FHasOverflow := True;
    Result.FIsDefined := True;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  Neg := uBoolUndefined;

  if (A.FIsNegative = B.FIsNegative) then
  begin
    if (A.FIsNegative = True) then
    begin
      if ABS_greaterthan_Multi_Int_X3(A, B) then
      begin
        Result := subtract_Multi_Int_X3(A, B);
        Neg    := uBoolTrue;
      end
      else
      begin
        Result := subtract_Multi_Int_X3(B, A);
        Neg    := uBoolFalse;
      end;
    end
    else  (* if  not FIsNegative then  *)
    begin
      if ABS_greaterthan_Multi_Int_X3(B, A) then
      begin
        Result := subtract_Multi_Int_X3(B, A);
        Neg    := uBoolTrue;
      end
      else
      begin
        Result := subtract_Multi_Int_X3(A, B);
        Neg    := uBoolFalse;
      end;
    end;
  end
  else (* A.FIsNegative <> B.FIsNegative *)
  if (B.FIsNegative = True) then
  begin
    Result := add_Multi_Int_X3(A, B);
    Neg    := uBoolFalse;
  end
  else
  begin
    Result := add_Multi_Int_X3(A, B);
    Neg    := uBoolTrue;
  end;

  if (Result.FHasOverflow = True) then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
  end;

  if (Result.FIsNegative = uBoolUndefined) then
    Result.FIsNegative := Neg;
end;


(******************************************)
class operator TMultiIntX3.-(const A: TMultiIntX3): TMultiIntX3;
begin
  Result := A;
  if (A.FIsNegative = uBoolTrue) then
    Result.FIsNegative := uBoolFalse;
  if (A.FIsNegative = uBoolFalse) then
    Result.FIsNegative := uBoolTrue;
end;


(*******************v4*********************)
procedure multiply_Multi_Int_X3(const A, B: TMultiIntX3; out Result: TMultiIntX3);
  overload;
label
  999;
var
  M_Val: array[0..Multi_X3_maxi_x2] of INT_2W_U;
  tv1, tv2: INT_2W_U;
  i, j, k, n, jz, iz: INT_1W_S;
  zf, zero_mult: boolean;
begin
  Result := 0;
  Result.FHasOverflow := False;
  Result.FIsDefined := True;
  Result.FIsNegative := uBoolUndefined;

  i := 0;
  repeat
    M_Val[i] := 0;
    Inc(i);
  until (i > Multi_X3_maxi_x2);

  zf := False;
  i  := Multi_X3_maxi;
  jz := -1;
  repeat
    if (B.FParts[i] <> 0) then
    begin
      jz := i;
      zf := True;
    end;
    Dec(i);
  until (i < 0) or (zf);
  if (jz < 0) then
  begin
    Result.FIsNegative := uBoolFalse;
    goto 999;
  end;

  zf := False;
  i  := Multi_X3_maxi;
  iz := -1;
  repeat
    if (A.FParts[i] <> 0) then
    begin
      iz := i;
      zf := True;
    end;
    Dec(i);
  until (i < 0) or (zf);
  if (iz < 0) then
  begin
    Result.FIsNegative := uBoolFalse;
    goto 999;
  end;

  i := 0;
  j := 0;
  repeat
    if (B.FParts[j] <> 0) then
    begin
      zero_mult := True;
      repeat
        if (A.FParts[i] <> 0) then
        begin
          zero_mult := False;
          tv1 := A.FParts[i];
          tv2 := B.FParts[j];
          M_Val[i + j + 1] :=
            (M_Val[i + j + 1] + ((tv1 * tv2) div INT_1W_U_MAXINT_1));
          M_Val[i + j] := (M_Val[i + j] + ((tv1 * tv2) mod INT_1W_U_MAXINT_1));
        end;
        Inc(i);
      until (i > iz);
      if not zero_mult then
      begin
        k := 0;
        repeat
          if (M_Val[k] <> 0) then
          begin
            M_Val[k + 1] := M_Val[k + 1] + (M_Val[k] div INT_1W_U_MAXINT_1);
            M_Val[k]     := (M_Val[k] mod INT_1W_U_MAXINT_1);
          end;
          Inc(k);
        until (k > Multi_X3_maxi);
      end;
      i := 0;
    end;
    Inc(j);
  until (j > jz);

  Result.FIsNegative := uBoolFalse;
  i := 0;
  repeat
    if (M_Val[i] <> 0) then
    begin
      Result.FIsNegative := uBoolUndefined;
      if (i > Multi_X3_maxi) then
        Result.FHasOverflow := True;
    end;
    Inc(i);
  until (i > Multi_X3_maxi_x2) or (Result.FHasOverflow);

  n := 0;
  while (n <= Multi_X3_maxi) do
  begin
    Result.FParts[n] := M_Val[n];
    Inc(n);
  end;

  999: ;
end;


(******************************************)
class operator TMultiIntX3.*(const A, B: TMultiIntX3): TMultiIntX3;
var
  R: TMultiIntX3;
begin
  if not A.FIsDefined or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FHasOverflow or B.FHasOverflow) then
  begin
    Result := 0;
    Result.FHasOverflow := True;
    Result.FIsDefined := True;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  multiply_Multi_Int_X3(A, B, R);

  if (R.FIsNegative = uBoolUndefined) then
    if (A.FIsNegative = B.FIsNegative) then
      R.FIsNegative := uBoolFalse
    else
      R.FIsNegative := uBoolTrue;

  Result := R;

  if (Result.FHasOverflow = True) then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
  end;
end;


(******************************************)
function Multi_Int_X2_to_X3_multiply(const A, B: TMultiIntX2): TMultiIntX3;
var
  R: TMultiIntX3;
begin
  if not A.FIsDefined or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FHasOverflow or B.FHasOverflow) then
  begin
    Result := 0;
    Result.FHasOverflow := True;
    Result.FIsDefined := True;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  multiply_Multi_Int_X3(A, B, R);

  if (R.FIsNegative = uBoolUndefined) then
    if (A.FIsNegative = B.FIsNegative) then
      R.FIsNegative := uBoolFalse
    else
      R.FIsNegative := uBoolTrue;

  Result := R;

  if (Result.FHasOverflow = True) then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
  end;
end;


(********************v3********************)
{ Function exp_by_squaring_iterative(TV, P) }

class operator TMultiIntX3.**(const A: TMultiIntX3; const P: INT_2W_S): TMultiIntX3;
var
  Y, TV, T, R: TMultiIntX3;
  PT: INT_2W_S;
begin
  PT := P;
  TV := A;
  if (PT < 0) then
    R := 0
  else if (PT = 0) then
    R := 1
  else
  begin
    Y := 1;
    while (PT > 1) do
    begin
      if odd(PT) then
      begin
        multiply_Multi_Int_X3(TV, Y, T);
        if (T.FHasOverflow) then
        begin
          Result := 0;
          Result.FIsDefined := False;
          Result.FHasOverflow := True;
          MultiIntError := True;
          if MultiIntEnableExceptions then
            raise EIntOverflow.Create('Overflow');
          exit;
        end;
        if (T.FIsNegative = uBoolUndefined) then
          if (TV.FIsNegative = Y.FIsNegative) then
            T.FIsNegative := uBoolFalse
          else
            T.FIsNegative := uBoolTrue;

        Y  := T;
        PT := PT - 1;
      end;
      multiply_Multi_Int_X3(TV, TV, T);
      if (T.FHasOverflow) then
      begin
        Result := 0;
        Result.FIsDefined := False;
        Result.FHasOverflow := True;
        MultiIntError := True;
        if MultiIntEnableExceptions then
          raise EIntOverflow.Create('Overflow');
        exit;
      end;
      T.FIsNegative := uBoolFalse;

      TV := T;
      PT := (PT div 2);
    end;
    multiply_Multi_Int_X3(TV, Y, R);
    if (R.FHasOverflow) then
    begin
      Result := 0;
      Result.FIsDefined := False;
      Result.FHasOverflow := True;
      MultiIntError := True;
      if MultiIntEnableExceptions then
        raise EIntOverflow.Create('Overflow');
      exit;
    end;
    if (R.FIsNegative = uBoolUndefined) then
      if (TV.FIsNegative = Y.FIsNegative) then
        R.FIsNegative := uBoolFalse
      else
        R.FIsNegative := uBoolTrue;
  end;

  Result := R;
end;


(********************A********************)
procedure intdivide_taylor_warruth_X3(const P_dividend, P_dividor: TMultiIntX3;
  out P_quotient, P_remainder: TMultiIntX3);
label
  AGAIN, 9000, 9999;
var
  dividor, quotient, dividend, next_dividend: TMultiIntX4;

  dividend_i, dividend_i_1, quotient_i, dividor_i, dividor_i_1,
  dividor_non_zero_pos, shiftup_bits_dividor, i: INT_1W_S;

  adjacent_word_dividend, adjacent_word_division, word_division,
  word_dividend, word_carry, next_word_carry: INT_2W_U;

  finished: boolean;
begin
  dividend    := 0;
  next_dividend := 0;
  dividor     := 0;
  quotient    := 0;
  P_quotient  := 0;
  P_remainder := 0;

  if (P_dividor = 0) then
  begin
    P_quotient.FIsDefined := False;
    P_quotient.FHasOverflow := True;
    P_remainder.FIsDefined := False;
    P_remainder.FHasOverflow := True;
    MultiIntError := True;
  end
  else if (P_dividor = P_dividend) then
    P_quotient := 1
  else
  begin
    if (Abs(P_dividor) > Abs(P_dividend)) then
    begin
      P_remainder := P_dividend;
      goto 9000;
    end;

    dividor_non_zero_pos := 0;
    i := Multi_X3_maxi;
    while (i >= 0) do
    begin
      dividor.FParts[i] := P_dividor.FParts[i];
      if (dividor_non_zero_pos = 0) then
        if (dividor.FParts[i] <> 0) then
          dividor_non_zero_pos := i;
      Dec(i);
    end;
    dividor.FIsNegative := False;

    // essential short-cut for single word dividor
    // the later code will fail if this case is not dealt with here

    if (dividor_non_zero_pos = 0) then
    begin
      P_remainder := 0;
      P_quotient := 0;
      word_carry := 0;
      i := Multi_X3_maxi;
      while (i >= 0) do
      begin
        P_quotient.FParts[i] :=
          (((word_carry * INT_2W_U(INT_1W_U_MAXINT_1)) +
          INT_2W_U(P_dividend.FParts[i])) div INT_2W_U(dividor.FParts[0]));
        word_carry := (((word_carry * INT_2W_U(INT_1W_U_MAXINT_1)) +
          INT_2W_U(P_dividend.FParts[i])) -
          (INT_2W_U(P_quotient.FParts[i]) * INT_2W_U(dividor.FParts[0])));
        Dec(i);
      end;
      P_remainder.FParts[0] := word_carry;
      goto 9000;
    end;

    dividend := P_dividend;
    dividend.FIsNegative := False;

    shiftup_bits_dividor := LeadingZeroCount(dividor.FParts[dividor_non_zero_pos]);
    if (shiftup_bits_dividor > 0) then
    begin
      ShiftUp_NBits_Multi_Int_X4(dividend, shiftup_bits_dividor);
      ShiftUp_NBits_Multi_Int_X4(dividor, shiftup_bits_dividor);
    end;

    next_word_carry := 0;
    word_carry  := 0;
    dividor_i   := dividor_non_zero_pos;
    dividor_i_1 := (dividor_i - 1);
    dividend_i  := (Multi_X3_maxi + 1);
    finished    := False;
    while (not finished) do
      if (dividend_i >= 0) then
      begin
        if (dividend.FParts[dividend_i] = 0) then
          Dec(dividend_i)
        else
        begin
          finished := True;
        end;
      end
      else
        finished := True;
    quotient_i   := (dividend_i - dividor_non_zero_pos);

    while (dividend >= 0) and (quotient_i >= 0) do
    begin
      word_dividend   := ((word_carry * INT_2W_U(INT_1W_U_MAXINT_1)) +
        dividend.FParts[dividend_i]);
      word_division   := (word_dividend div dividor.FParts[dividor_i]);
      next_word_carry := (word_dividend mod dividor.FParts[dividor_i]);

      if (word_division > 0) then
      begin
        dividend_i_1 := (dividend_i - 1);
        if (dividend_i_1 >= 0) then
        begin
          AGAIN:
            adjacent_word_dividend :=
              ((next_word_carry * INT_2W_U(INT_1W_U_MAXINT_1)) +
            dividend.FParts[dividend_i_1]);
          adjacent_word_division   := (dividor.FParts[dividor_i_1] * word_division);
          if (adjacent_word_division > adjacent_word_dividend) or
            (word_division >= INT_1W_U_MAXINT_1) then
          begin
            Dec(word_division);
            next_word_carry := next_word_carry + dividor.FParts[dividor_i];
            if (next_word_carry < INT_1W_U_MAXINT_1) then
              goto AGAIN;
          end;
        end;
        quotient      := 0;
        quotient.FParts[quotient_i] := word_division;
        next_dividend := (dividend - (dividor * quotient));
        if (next_dividend.IsNegative) then
        begin
          Dec(word_division);
          quotient.FParts[quotient_i] := word_division;
          next_dividend := (dividend - (dividor * quotient));
        end;
        P_quotient.FParts[quotient_i] := word_division;
        dividend   := next_dividend;
        word_carry := dividend.FParts[dividend_i];
      end
      else
        word_carry := word_dividend;

      Dec(dividend_i);
      quotient_i := (dividend_i - dividor_non_zero_pos);
    end; { while }

    ShiftDown_MultiBits_Multi_Int_X4(dividend, shiftup_bits_dividor);
    P_remainder := To_Multi_Int_X3(dividend);

    9000:
      if (P_dividend.FIsNegative = True) and (P_remainder > 0) then
        P_remainder.FIsNegative := True;

    if (P_dividend.FIsNegative <> P_dividor.FIsNegative) and (P_quotient > 0) then
      P_quotient.FIsNegative := True;

  end;
  9999: ;
end;


(******************************************)
class operator TMultiIntX3.div(const A, B: TMultiIntX3): TMultiIntX3;
var
  Remainder, Quotient: TMultiIntX3;
begin
  if not A.FIsDefined or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FHasOverflow or B.FHasOverflow) then
  begin
    Result := 0;
    Result.FHasOverflow := True;
    Result.FIsDefined := True;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  // same values as last time

  if (X3_Last_Divisor = B) and (X3_Last_Dividend = A) then
    Result := X3_Last_Quotient
  else  // different values than last time
  begin
    intdivide_taylor_warruth_X3(A, B, Quotient, Remainder);

    X3_Last_Divisor   := B;
    X3_Last_Dividend  := A;
    X3_Last_Quotient  := Quotient;
    X3_Last_Remainder := Remainder;

    Result := Quotient;
  end;

  if (X3_Last_Remainder.FHasOverflow) or (X3_Last_Quotient.FHasOverflow) then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
  end;
end;


(******************************************)
class operator TMultiIntX3.mod(const A, B: TMultiIntX3): TMultiIntX3;
var
  Remainder, Quotient: TMultiIntX3;
begin
  if not A.FIsDefined or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FHasOverflow or B.FHasOverflow) then
  begin
    Result := 0;
    Result.FHasOverflow := True;
    Result.FIsDefined := True;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  // same values as last time

  if (X3_Last_Divisor = B) and (X3_Last_Dividend = A) then
    Result := X3_Last_Remainder
  else  // different values than last time
  begin
    intdivide_taylor_warruth_X3(A, B, Quotient, Remainder);

    X3_Last_Divisor   := B;
    X3_Last_Dividend  := A;
    X3_Last_Quotient  := Quotient;
    X3_Last_Remainder := Remainder;

    Result := Remainder;
  end;

  if (X3_Last_Remainder.FHasOverflow) or (X3_Last_Quotient.FHasOverflow) then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
  end;
end;


(***********B************)
procedure SqRoot(const A: TMultiIntX3; out VR, VREM: TMultiIntX3);
var
  D, D2: INT_2W_S;
  HS, LS: ansistring;
  H, L, C, CC, LPC, Q, R, T: TMultiIntX3;
  finished: boolean;
begin
  if not A.FIsDefined then
  begin
    VR   := 0;
    VR.FIsDefined := False;
    VREM := 0;
    VREM.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow) then
  begin
    VR   := 0;
    VR.FIsDefined := False;
    VREM := 0;
    VREM.FIsDefined := False;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  if (A.FIsNegative = uBoolTrue) then
  begin
    VR   := 0;
    VR.FIsDefined := False;
    VREM := 0;
    VREM.FIsDefined := False;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  if (A >= 100) then
  begin
    D  := length(A.ToString);
    D2 := D div 2;
    if ((D mod 2) = 0) then
    begin
      LS := '1' + AddCharR('0', '', D2 - 1);
      HS := '1' + AddCharR('0', '', D2);
      H  := HS;
      L  := LS;
    end
    else
    begin
      LS := '1' + AddCharR('0', '', D2);
      HS := '1' + AddCharR('0', '', D2 + 1);
      H  := HS;
      L  := LS;
    end;

    T := (H - L);
    ShiftDown_MultiBits_Multi_Int_X3(T, 1);
    C := (L + T);
  end
  else
  begin
    C := (A div 2);
    if (C = 0) then
      C := 1;
  end;

  finished := False;
  LPC      := A;
  repeat
    begin
      // CC:= ((C + (A div C)) div 2);
      intdivide_taylor_warruth_X3(A, C, Q, R);
      CC := (C + Q);
      ShiftDown_MultiBits_Multi_Int_X3(CC, 1);
      if (ABS(C - CC) < 2) then
        if (CC < LPC) then
          LPC := CC
        else if (CC >= LPC) then
          finished := True;
      C := CC;
    end
  until finished;

  VREM := (A - (LPC * LPC));
  VR   := LPC;
  VR.FIsNegative := uBoolFalse;
  VREM.FIsNegative := uBoolFalse;

end;


(*************************)
procedure SqRoot(const A: TMultiIntX3; out VR: TMultiIntX3);
var
  VREM: TMultiIntX3;
begin
  VREM := 0;
  sqroot(A, VR, VREM);
end;


(*************************)
function SqRoot(const A: TMultiIntX3): TMultiIntX3;
var
  VR, VREM: TMultiIntX3;
begin
  VREM := 0;
  sqroot(A, VR, VREM);
  Result := VR;
end;


{
******************************************
TMultiIntX4
******************************************
}


(******************************************)
function ABS_greaterthan_Multi_Int_X4(const A, B: TMultiIntX4): boolean;
begin
  if (A.FParts[7] > B.FParts[7]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.FParts[7] < B.FParts[7]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.FParts[6] > B.FParts[6]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.FParts[6] < B.FParts[6]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.FParts[5] > B.FParts[5]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.FParts[5] < B.FParts[5]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.FParts[4] > B.FParts[4]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.FParts[4] < B.FParts[4]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.FParts[3] > B.FParts[3]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.FParts[3] < B.FParts[3]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.FParts[2] > B.FParts[2]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.FParts[2] < B.FParts[2]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.FParts[1] > B.FParts[1]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.FParts[1] < B.FParts[1]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.FParts[0] > B.FParts[0]) then
  begin
    Result := True;
    exit;
  end
  else
  begin
    Result := False;
    exit;
  end;
end;


(******************************************)
function ABS_lessthan_Multi_Int_X4(const A, B: TMultiIntX4): boolean;
begin
  if (A.FParts[7] < B.FParts[7]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.FParts[7] > B.FParts[7]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.FParts[6] < B.FParts[6]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.FParts[6] > B.FParts[6]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.FParts[5] < B.FParts[5]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.FParts[5] > B.FParts[5]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.FParts[4] < B.FParts[4]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.FParts[4] > B.FParts[4]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.FParts[3] < B.FParts[3]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.FParts[3] > B.FParts[3]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.FParts[2] < B.FParts[2]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.FParts[2] > B.FParts[2]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.FParts[1] < B.FParts[1]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.FParts[1] > B.FParts[1]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.FParts[0] < B.FParts[0]) then
  begin
    Result := True;
    exit;
  end
  else
  begin
    Result := False;
    exit;
  end;
end;


(******************************************)
function ABS_equal_Multi_Int_X4(const A, B: TMultiIntX4): boolean;
begin
  Result := True;
  if (A.FParts[0] <> B.FParts[0]) then
    Result := False
  else
  if (A.FParts[1] <> B.FParts[1]) then
    Result := False
  else
  if (A.FParts[2] <> B.FParts[2]) then
    Result := False
  else
  if (A.FParts[3] <> B.FParts[3]) then
    Result := False
  else
  if (A.FParts[4] <> B.FParts[4]) then
    Result := False
  else
  if (A.FParts[5] <> B.FParts[5]) then
    Result := False
  else
  if (A.FParts[6] <> B.FParts[6]) then
    Result := False
  else
  if (A.FParts[7] <> B.FParts[7]) then
    Result := False;
end;


(******************************************)
function ABS_notequal_Multi_Int_X4(const A, B: TMultiIntX4): boolean; inline;
begin
  Result := (not ABS_equal_Multi_Int_X4(A, B));
end;


(******************************************)
function TMultiIntX4.HasOverflow: boolean; inline;
begin
  Result := Self.FHasOverflow;
end;


(******************************************)
function TMultiIntX4.IsDefined: boolean; inline;
begin
  Result := Self.FIsDefined;
end;


(******************************************)
function Overflow(const A: TMultiIntX4): boolean; overload; inline;
begin
  Result := A.FHasOverflow;
end;


(******************************************)
function Defined(const A: TMultiIntX4): boolean; overload; inline;
begin
  Result := A.FIsDefined;
end;


(******************************************)
function TMultiIntX4.IsNegative: boolean; inline;
begin
  Result := Self.FIsNegative;
end;


(******************************************)
function Negative(const A: TMultiIntX4): boolean; overload; inline;
begin
  Result := A.FIsNegative;
end;


(******************************************)
function Abs(const A: TMultiIntX4): TMultiIntX4; overload;
begin
  Result := A;
  Result.FIsNegative := uBoolFalse;

  if not A.FIsDefined then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
  end;
end;


(******************************************)
function Multi_Int_X4_Odd(const A: TMultiIntX4): boolean; inline;
var
  bit1_mask: INT_1W_U;
begin

  bit1_mask := $1;

  if ((A.FParts[0] and bit1_mask) = bit1_mask) then
    Result := True
  else
    Result := False;

  if not A.FIsDefined then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
  end;

end;


(******************************************)
function Odd(const A: TMultiIntX4): boolean; overload;
begin
  Result := Multi_Int_X4_Odd(A);
end;


(******************************************)
function Multi_Int_X4_Even(const A: TMultiIntX4): boolean; inline;
var
  bit1_mask: INT_1W_U;
begin

  bit1_mask := $1;

  if ((A.FParts[0] and bit1_mask) = bit1_mask) then
    Result := False
  else
    Result := True;

  if not A.FIsDefined then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
  end;

end;


(******************************************)
function Even(const A: TMultiIntX4): boolean; overload;
begin
  Result := Multi_Int_X4_Even(A);
end;


(******************************************)
function nlz_words_X4(m: TMultiIntX4): INT_1W_U; // B
var
  i, n: TMultiInt32;
  fini: boolean;
begin
  n    := 0;
  i    := Multi_X4_maxi;
  fini := False;
  repeat
    if (i < 0) then
      fini := True
    else if (m.FParts[i] <> 0) then
      fini := True
    else
    begin
      Inc(n);
      Dec(i);
    end;
  until fini;
  Result := n;
end;


(******************************************)
function nlz_MultiBits_X4(A: TMultiIntX4): INT_1W_U;
var
  w: INT_1W_U;
begin
  if not A.FIsDefined then
  begin
    Result := 0;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
  end;

  w := nlz_words_X4(A);
  if (w <= Multi_X4_maxi) then
    Result :=
      LeadingZeroCount(A.FParts[Multi_X4_maxi - w]) + (w * INT_1W_SIZE)
  else
    Result := (w * INT_1W_SIZE);
end;


{$ifdef CPU_32}
(******************************************)
procedure ShiftUp_NBits_Multi_Int_X4(var A: TMultiIntX4; NBits: INT_1W_U);
var
  carry_bits_1, carry_bits_2, carry_bits_mask, NBits_max, NBits_carry: INT_1W_U;

  procedure INT_1W_U_shl(var A: INT_1W_U; const nbits: INT_1W_U); inline;
  var
    carry_bits_mask_2w: INT_2W_U;
  begin
    carry_bits_mask_2w := A;
    carry_bits_mask_2w := (carry_bits_mask_2w << NBits);
    A := INT_1W_U(carry_bits_mask_2w and INT_1W_U_MAXINT);
  end;

begin
  if NBits > 0 then
  begin

    carry_bits_mask := $FFFF;
    NBits_max   := INT_1W_SIZE;
    NBits_carry := (NBits_max - NBits);
    INT_1W_U_shl(carry_bits_mask, NBits_carry);

    if NBits <= NBits_max then
    begin
      carry_bits_1 := ((A.M_Value[0] and carry_bits_mask) shr NBits_carry);
      INT_1W_U_shl(A.M_Value[0], NBits);

      carry_bits_2 := ((A.M_Value[1] and carry_bits_mask) shr NBits_carry);
      INT_1W_U_shl(A.M_Value[1], NBits);
      A.M_Value[1] := (A.M_Value[1] or carry_bits_1);

      carry_bits_1 := ((A.M_Value[2] and carry_bits_mask) shr NBits_carry);
      INT_1W_U_shl(A.M_Value[2], NBits);
      A.M_Value[2] := (A.M_Value[2] or carry_bits_2);

      carry_bits_2 := ((A.M_Value[3] and carry_bits_mask) shr NBits_carry);
      INT_1W_U_shl(A.M_Value[3], NBits);
      A.M_Value[3] := (A.M_Value[3] or carry_bits_1);

      carry_bits_1 := ((A.M_Value[4] and carry_bits_mask) shr NBits_carry);
      INT_1W_U_shl(A.M_Value[4], NBits);
      A.M_Value[4] := (A.M_Value[4] or carry_bits_2);

      carry_bits_2 := ((A.M_Value[5] and carry_bits_mask) shr NBits_carry);
      INT_1W_U_shl(A.M_Value[5], NBits);
      A.M_Value[5] := (A.M_Value[5] or carry_bits_1);

      carry_bits_1 := ((A.M_Value[6] and carry_bits_mask) shr NBits_carry);
      INT_1W_U_shl(A.M_Value[6], NBits);
      A.M_Value[6] := (A.M_Value[6] or carry_bits_2);

      INT_1W_U_shl(A.M_Value[7], NBits);
      A.M_Value[7] := (A.M_Value[7] or carry_bits_1);
    end;
  end;

end;
{$endif}


{$ifdef CPU_64}

(******************************************)
procedure ShiftUp_NBits_Multi_Int_X4(Var A:TMultiIntX4; NBits:INT_1W_U);
var     carry_bits_1,
        carry_bits_2,
        carry_bits_mask,
        NBits_max,
        NBits_carry     :INT_1W_U;
begin
if NBits > 0 then
begin

carry_bits_mask:= $FFFFFFFF;
NBits_max:= INT_1W_SIZE;
NBits_carry:= (NBits_max - NBits);

carry_bits_mask:= (carry_bits_mask << NBits_carry);

if NBits <= NBits_max then
        begin
        carry_bits_1:= ((A.FParts[0] and carry_bits_mask) shr NBits_carry);
        A.FParts[0]:= (A.FParts[0] << NBits);

        carry_bits_2:= ((A.FParts[1] and carry_bits_mask) shr NBits_carry);
        A.FParts[1]:= ((A.FParts[1] << NBits) OR carry_bits_1);

        carry_bits_1:= ((A.FParts[2] and carry_bits_mask) shr NBits_carry);
        A.FParts[2]:= ((A.FParts[2] << NBits) OR carry_bits_2);

        carry_bits_2:= ((A.FParts[3] and carry_bits_mask) shr NBits_carry);
        A.FParts[3]:= ((A.FParts[3] << NBits) OR carry_bits_1);

        carry_bits_1:= ((A.FParts[4] and carry_bits_mask) shr NBits_carry);
        A.FParts[4]:= ((A.FParts[4] << NBits) OR carry_bits_2);

        carry_bits_2:= ((A.FParts[5] and carry_bits_mask) shr NBits_carry);
        A.FParts[5]:= ((A.FParts[5] << NBits) OR carry_bits_1);

        carry_bits_1:= ((A.FParts[6] and carry_bits_mask) shr NBits_carry);
        A.FParts[6]:= ((A.FParts[6] << NBits) OR carry_bits_2);

        A.FParts[7]:= ((A.FParts[7] << NBits) OR carry_bits_1);
        end;
end;

end;

{$endif}


(******************************************)
procedure ShiftUp_NWords_Multi_Int_X4(var A: TMultiIntX4; NWords: INT_1W_U);
var
  n: INT_1W_U;
begin
  if (NWords > 0) then
    if (NWords <= Multi_X4_maxi) then
    begin
      n := NWords;
      while (n > 0) do
      begin
        A.FParts[7] := A.FParts[6];
        A.FParts[6] := A.FParts[5];
        A.FParts[5] := A.FParts[4];
        A.FParts[4] := A.FParts[3];
        A.FParts[3] := A.FParts[2];
        A.FParts[2] := A.FParts[1];
        A.FParts[1] := A.FParts[0];
        A.FParts[0] := 0;
        Dec(n);
      end;
    end
    else
    begin
      A.FParts[0] := 0;
      A.FParts[1] := 0;
      A.FParts[2] := 0;
      A.FParts[3] := 0;
      A.FParts[4] := 0;
      A.FParts[5] := 0;
      A.FParts[6] := 0;
      A.FParts[7] := 0;
    end;
end;


(******************************************)
procedure ShiftDown_NBits_Multi_Int_X4(var A: TMultiIntX4; NBits: INT_1W_U);
var
  carry_bits_1, carry_bits_2, carry_bits_mask, NBits_max, NBits_carry: INT_1W_U;
begin
  if NBits > 0 then
  begin

    {$ifdef CPU_32}
    carry_bits_mask := $FFFF;
    {$endif}
    {$ifdef CPU_64}
carry_bits_mask:= $FFFFFFFF;
    {$endif}

    NBits_max   := INT_1W_SIZE;
    NBits_carry := (NBits_max - NBits);
    carry_bits_mask := (carry_bits_mask shr NBits_carry);

    if NBits <= NBits_max then
    begin

      carry_bits_1 := ((A.FParts[7] and carry_bits_mask) << NBits_carry);
      A.FParts[7]  := (A.FParts[7] shr NBits);

      carry_bits_2 := ((A.FParts[6] and carry_bits_mask) << NBits_carry);
      A.FParts[6]  := ((A.FParts[6] shr NBits) or carry_bits_1);

      carry_bits_1 := ((A.FParts[5] and carry_bits_mask) << NBits_carry);
      A.FParts[5]  := ((A.FParts[5] shr NBits) or carry_bits_2);

      carry_bits_2 := ((A.FParts[4] and carry_bits_mask) << NBits_carry);
      A.FParts[4]  := ((A.FParts[4] shr NBits) or carry_bits_1);

      carry_bits_1 := ((A.FParts[3] and carry_bits_mask) << NBits_carry);
      A.FParts[3]  := ((A.FParts[3] shr NBits) or carry_bits_2);

      carry_bits_2 := ((A.FParts[2] and carry_bits_mask) << NBits_carry);
      A.FParts[2]  := ((A.FParts[2] shr NBits) or carry_bits_1);

      carry_bits_1 := ((A.FParts[1] and carry_bits_mask) << NBits_carry);
      A.FParts[1]  := ((A.FParts[1] shr NBits) or carry_bits_2);

      A.FParts[0] := ((A.FParts[0] shr NBits) or carry_bits_1);

    end;
  end;

end;


(******************************************)
procedure ShiftDown_NWords_Multi_Int_X4(var A: TMultiIntX4; NWords: INT_1W_U);
var
  n: INT_1W_U;
begin
  if (NWords > 0) then
    if (NWords <= Multi_X4_maxi) then
    begin
      n := NWords;
      while (n > 0) do
      begin
        A.FParts[0] := A.FParts[1];
        A.FParts[1] := A.FParts[2];
        A.FParts[2] := A.FParts[3];
        A.FParts[3] := A.FParts[4];
        A.FParts[4] := A.FParts[5];
        A.FParts[5] := A.FParts[6];
        A.FParts[6] := A.FParts[7];
        A.FParts[7] := 0;
        Dec(n);
      end;
    end
    else
    begin
      A.FParts[0] := 0;
      A.FParts[1] := 0;
      A.FParts[2] := 0;
      A.FParts[3] := 0;
      A.FParts[4] := 0;
      A.FParts[5] := 0;
      A.FParts[6] := 0;
      A.FParts[7] := 0;
    end;
end;


{******************************************}
procedure ShiftUp_MultiBits_Multi_Int_X4(var A: TMultiIntX4; NBits: INT_1W_U);
var
  NWords_count, NBits_count: INT_1W_U;
begin
  if not A.FIsDefined then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (NBits > 0) then
  begin
    if (NBits >= INT_1W_SIZE) then
    begin
      NWords_count := (NBits div INT_1W_SIZE);
      NBits_count  := (NBits mod INT_1W_SIZE);
      ShiftUp_NWords_Multi_Int_X4(A, NWords_count);
    end
    else
      NBits_count := NBits;
    ShiftUp_NBits_Multi_Int_X4(A, NBits_count);
  end;
end;


{******************************************}
procedure ShiftDown_MultiBits_Multi_Int_X4(var A: TMultiIntX4; NBits: INT_1W_U);
var
  NWords_count, NBits_count: INT_1W_U;
begin
  if not A.FIsDefined then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (NBits >= INT_1W_SIZE) then
  begin
    NWords_count := (NBits div INT_1W_SIZE);
    NBits_count  := (NBits mod INT_1W_SIZE);
    ShiftDown_NWords_Multi_Int_X4(A, NWords_count);
  end
  else
    NBits_count := NBits;

  ShiftDown_NBits_Multi_Int_X4(A, NBits_count);
end;


{******************************************}
class operator TMultiIntX4.shl(const A: TMultiIntX4;
  const NBits: INT_1W_U): TMultiIntX4;
begin
  Result := A;
  ShiftUp_MultiBits_Multi_Int_X4(Result, NBits);
end;


{******************************************}
class operator TMultiIntX4.shr(const A: TMultiIntX4;
  const NBits: INT_1W_U): TMultiIntX4;
begin
  Result := A;
  ShiftDown_MultiBits_Multi_Int_X4(Result, NBits);
end;


(******************************************)
class operator TMultiIntX4.<=(const A, B: TMultiIntX4): boolean;
begin
  if not A.FIsDefined or (not B.FIsDefined) or (A.FHasOverflow) or
    (B.FHasOverflow) then
  begin
    Result := False;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  Result := False;
  if ((A.FIsNegative = False) and (B.FIsNegative = True)) then
    Result := False
  else
  if ((A.FIsNegative = True) and (B.FIsNegative = False)) then
    Result := True
  else
  if ((A.FIsNegative = False) and (B.FIsNegative = False)) then
    Result := (not ABS_greaterthan_Multi_Int_X4(A, B))
  else
  if ((A.FIsNegative = True) and (B.FIsNegative = True)) then
    Result := (not ABS_lessthan_Multi_Int_X4(A, B));
end;


(******************************************)
class operator TMultiIntX4.>=(const A, B: TMultiIntX4): boolean;
begin
  if not A.FIsDefined or (not B.FIsDefined) or (A.FHasOverflow) or
    (B.FHasOverflow) then
  begin
    Result := False;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  Result := False;
  if ((A.FIsNegative = False) and (B.FIsNegative = True)) then
    Result := True
  else
  if ((A.FIsNegative = True) and (B.FIsNegative = False)) then
    Result := False
  else
  if ((A.FIsNegative = False) and (B.FIsNegative = False)) then
    Result := (not ABS_lessthan_Multi_Int_X4(A, B))
  else
  if ((A.FIsNegative = True) and (B.FIsNegative = True)) then
    Result := (not ABS_greaterthan_Multi_Int_X4(A, B));
end;


(******************************************)
class operator TMultiIntX4.>(const A, B: TMultiIntX4): boolean;
begin
  if not A.FIsDefined or (not B.FIsDefined) or (A.FHasOverflow) or
    (B.FHasOverflow) then
  begin
    Result := False;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  Result := False;
  if ((A.FIsNegative = False) and (B.FIsNegative = True)) then
    Result := True
  else
  if ((A.FIsNegative = True) and (B.FIsNegative = False)) then
    Result := False
  else
  if ((A.FIsNegative = False) and (B.FIsNegative = False)) then
    Result := ABS_greaterthan_Multi_Int_X4(A, B)
  else
  if ((A.FIsNegative = True) and (B.FIsNegative = True)) then
    Result := ABS_lessthan_Multi_Int_X4(A, B);
end;


(******************************************)
class operator TMultiIntX4.<(const A, B: TMultiIntX4): boolean;
begin
  if not A.FIsDefined or (not B.FIsDefined) or (A.FHasOverflow) or
    (B.FHasOverflow) then
  begin
    Result := False;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  Result := False;
  if ((A.FIsNegative = True) and (B.FIsNegative = False)) then
    Result := True
  else
  if ((A.FIsNegative = False) and (B.FIsNegative = False)) then
    Result := ABS_lessthan_Multi_Int_X4(A, B)
  else
  if ((A.FIsNegative = True) and (B.FIsNegative = True)) then
    Result := ABS_greaterthan_Multi_Int_X4(A, B);
end;


(******************************************)
class operator TMultiIntX4.=(const A, B: TMultiIntX4): boolean;
begin
  if not A.FIsDefined or (not B.FIsDefined) or (A.FHasOverflow) or
    (B.FHasOverflow) then
  begin
    Result := False;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  Result := True;
  if (A.FIsNegative <> B.FIsNegative) then
    Result := False
  else
    Result := ABS_equal_Multi_Int_X4(A, B);
end;


(******************************************)
class operator TMultiIntX4.<>(const A, B: TMultiIntX4): boolean;
begin
  if not A.FIsDefined or (not B.FIsDefined) or (A.FHasOverflow) or
    (B.FHasOverflow) then
  begin
    Result := False;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  Result := False;
  if (A.FIsNegative <> B.FIsNegative) then
    Result := True
  else
    Result := (not ABS_equal_Multi_Int_X4(A, B));
end;


(******************************************)
function To_Multi_Int_X4(const A: TMultiIntXV): TMultiIntX4;
label
  OVERFLOW_BRANCH, CLEAN_EXIT;
var
  n: INT_2W_U;
begin
  if (A.FIsDefined = False) then
  begin
    MultiIntError     := True;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FHasOverflow = True) then
    goto OVERFLOW_BRANCH;

  Result.FHasOverflow := A.FHasOverflow;
  Result.FIsDefined   := A.FIsDefined;
  Result.FIsNegative  := A.FIsNegative;

  n := 0;
  if (Multi_XV_size > Multi_X4_size) then
  begin
    while (n <= Multi_X4_maxi) do
    begin
      Result.FParts[n] := A.FParts[n];
      Inc(n);
    end;
    while (n <= Multi_XV_maxi) do
    begin
      if (A.FParts[n] <> 0) then
        goto OVERFLOW_BRANCH;
      Inc(n);
    end;
  end
  else
  begin
    while (n <= Multi_XV_maxi) do
    begin
      Result.FParts[n] := A.FParts[n];
      Inc(n);
    end;
    while (n <= Multi_X4_maxi) do
    begin
      Result.FParts[n] := 0;
      Inc(n);
    end;
  end;

  goto CLEAN_EXIT;

  OVERFLOW_BRANCH:

    MultiIntError     := True;
  Result.FHasOverflow := True;
  if MultiIntEnableExceptions then
    raise EInterror.Create('Overflow');
  exit;

  CLEAN_EXIT: ;

end;

{
var n :INT_1W_U;
begin
Result.Overflow_flag:= A.Overflow_flag;
Result.Defined_flag:= A.Defined_flag;
Result.Negative_flag:= A.Negative_flag;

if  (A.Defined_flag = FALSE)
then
  begin
  if MultiIntEnableExceptions then
    begin
    Raise EInterror.create('Uninitialised variable');
    end;
  Result.Defined_flag:= FALSE;
  exit;
  end;

if  (A.Overflow_flag = TRUE)
then
  begin
  Result.Overflow_flag:= TRUE;
  MultiIntError:= TRUE;
  if MultiIntEnableExceptions then
    begin
    Raise EInterror.create('Overflow');
    end;
  exit;
  end;

n:= 0;
while (n <= Multi_X4_maxi) do
  begin
  Result.M_Value[n]:= A.M_Value[n];
  inc(n);
  end;
end;
}


(******************************************)
function To_Multi_Int_X4(const A: TMultiIntX3): TMultiIntX4;
var
  n: INT_1W_U;
begin
  Result.FHasOverflow := A.FHasOverflow;
  Result.FIsDefined   := A.FIsDefined;
  Result.FIsNegative  := A.FIsNegative;

  if (A.FIsDefined = False) then
  begin
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    Result.FIsDefined := False;
    exit;
  end;

  if (A.FHasOverflow = True) then
  begin
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    Result.FHasOverflow := True;
    exit;
  end;

  n := 0;
  while (n <= Multi_X3_maxi) do
  begin
    Result.FParts[n] := A.FParts[n];
    Inc(n);
  end;

  while (n <= Multi_X4_maxi) do
  begin
    Result.FParts[n] := 0;
    Inc(n);
  end;
end;


(******************************************)
function To_Multi_Int_X4(const A: TMultiIntX2): TMultiIntX4;
var
  n: INT_1W_U;
begin
  Result.FHasOverflow := A.FHasOverflow;
  Result.FIsDefined   := A.FIsDefined;
  Result.FIsNegative  := A.FIsNegative;

  if (A.FIsDefined = False) then
  begin
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    Result.FIsDefined := False;
    exit;
  end;

  if (A.FHasOverflow = True) then
  begin
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    Result.FHasOverflow := True;
    exit;
  end;

  n := 0;
  while (n <= Multi_X2_maxi) do
  begin
    Result.FParts[n] := A.FParts[n];
    Inc(n);
  end;

  while (n <= Multi_X4_maxi) do
  begin
    Result.FParts[n] := 0;
    Inc(n);
  end;
end;


(******************************************)
procedure Multi_Int_X2_to_Multi_Int_X4(const A: TMultiIntX2;
  out MI: TMultiIntX4); inline;
var
  n: INT_1W_U;
begin
  MI.FHasOverflow := A.FHasOverflow;
  MI.FIsDefined   := A.FIsDefined;
  MI.FIsNegative  := A.FIsNegative;

  if (A.FIsDefined = False) then
  begin
    MultiIntError := True;
    MI.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FHasOverflow = True) then
  begin
    MultiIntError   := True;
    MI.FHasOverflow := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    exit;
  end;

  n := 0;
  while (n <= Multi_X2_maxi) do
  begin
    MI.FParts[n] := A.FParts[n];
    Inc(n);
  end;

  while (n <= Multi_X4_maxi) do
  begin
    MI.FParts[n] := 0;
    Inc(n);
  end;
end;


(******************************************)
class operator TMultiIntX4.:=(const A: TMultiIntX2): TMultiIntX4;
begin
  Multi_Int_X2_to_Multi_Int_X4(A, Result);
end;


(******************************************)
procedure Multi_Int_X3_to_Multi_Int_X4(const A: TMultiIntX3;
  out MI: TMultiIntX4); inline;
var
  n: INT_1W_U;
begin
  MI.FHasOverflow := A.FHasOverflow;
  MI.FIsDefined   := A.FIsDefined;
  MI.FIsNegative  := A.FIsNegative;

  if (A.FIsDefined = False) then
  begin
    MultiIntError := True;
    MI.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FHasOverflow = True) then
  begin
    MultiIntError   := True;
    MI.FHasOverflow := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    exit;
  end;

  n := 0;
  while (n <= Multi_X3_maxi) do
  begin
    MI.FParts[n] := A.FParts[n];
    Inc(n);
  end;

  while (n <= Multi_X4_maxi) do
  begin
    MI.FParts[n] := 0;
    Inc(n);
  end;
end;


(******************************************)
class operator TMultiIntX4.:=(const A: TMultiIntX3): TMultiIntX4;
begin
  Multi_Int_X3_to_Multi_Int_X4(A, Result);
end;


(******************************************)
procedure String_to_Multi_Int_X4(const A: ansistring; out mi: TMultiIntX4); inline;
label
  999;
var
  i, b, c, e: INT_2W_U;
  M_Val: array[0..Multi_X4_maxi] of INT_2W_U;
  Signeg, Zeroneg: boolean;
begin
  MultiIntError := False;

  mi.FHasOverflow := False;
  mi.FIsDefined := True;
  mi.FIsNegative := False;
  Signeg  := False;
  Zeroneg := False;

  M_Val[0] := 0;
  M_Val[1] := 0;
  M_Val[2] := 0;
  M_Val[3] := 0;
  M_Val[4] := 0;
  M_Val[5] := 0;
  M_Val[6] := 0;
  M_Val[7] := 0;

  if (length(A) > 0) then
  begin
    b := low(ansistring);
    e := b + INT_2W_U(length(A)) - 1;
    if (A[b] = '-') then
    begin
      Signeg := True;
      Inc(b);
    end;

    c := b;
    while (c <= e) do
    begin
      try
        i := StrToInt(A[c]);
      except
        on EConvertError do
        begin
          mi.FIsDefined   := False;
          mi.FHasOverflow := True;
          MultiIntError   := True;
          if MultiIntEnableExceptions then
            raise;
        end;
      end;
      if mi.FIsDefined = False then
        goto 999;
      M_Val[0] := (M_Val[0] * 10) + i;
      M_Val[1] := (M_Val[1] * 10);
      M_Val[2] := (M_Val[2] * 10);
      M_Val[3] := (M_Val[3] * 10);
      M_Val[4] := (M_Val[4] * 10);
      M_Val[5] := (M_Val[5] * 10);
      M_Val[6] := (M_Val[6] * 10);
      M_Val[7] := (M_Val[7] * 10);

      if M_Val[0] > INT_1W_U_MAXINT then
      begin
        M_Val[1] := M_Val[1] + (M_Val[0] div INT_1W_U_MAXINT_1);
        M_Val[0] := (M_Val[0] mod INT_1W_U_MAXINT_1);
      end;

      if M_Val[1] > INT_1W_U_MAXINT then
      begin
        M_Val[2] := M_Val[2] + (M_Val[1] div INT_1W_U_MAXINT_1);
        M_Val[1] := (M_Val[1] mod INT_1W_U_MAXINT_1);
      end;

      if M_Val[2] > INT_1W_U_MAXINT then
      begin
        M_Val[3] := M_Val[3] + (M_Val[2] div INT_1W_U_MAXINT_1);
        M_Val[2] := (M_Val[2] mod INT_1W_U_MAXINT_1);
      end;

      if M_Val[3] > INT_1W_U_MAXINT then
      begin
        M_Val[4] := M_Val[4] + (M_Val[3] div INT_1W_U_MAXINT_1);
        M_Val[3] := (M_Val[3] mod INT_1W_U_MAXINT_1);
      end;

      if M_Val[4] > INT_1W_U_MAXINT then
      begin
        M_Val[5] := M_Val[5] + (M_Val[4] div INT_1W_U_MAXINT_1);
        M_Val[4] := (M_Val[4] mod INT_1W_U_MAXINT_1);
      end;

      if M_Val[5] > INT_1W_U_MAXINT then
      begin
        M_Val[6] := M_Val[6] + (M_Val[5] div INT_1W_U_MAXINT_1);
        M_Val[5] := (M_Val[5] mod INT_1W_U_MAXINT_1);
      end;

      if M_Val[6] > INT_1W_U_MAXINT then
      begin
        M_Val[7] := M_Val[7] + (M_Val[6] div INT_1W_U_MAXINT_1);
        M_Val[6] := (M_Val[6] mod INT_1W_U_MAXINT_1);
      end;

      if M_Val[7] > INT_1W_U_MAXINT then
      begin
        mi.FIsDefined   := False;
        mi.FHasOverflow := True;
        MultiIntError   := True;
        if MultiIntEnableExceptions then
          raise EIntOverflow.Create('Overflow');
        goto 999;
      end;
      Inc(c);
    end;
  end;

  mi.FParts[0] := M_Val[0];
  mi.FParts[1] := M_Val[1];
  mi.FParts[2] := M_Val[2];
  mi.FParts[3] := M_Val[3];
  mi.FParts[4] := M_Val[4];
  mi.FParts[5] := M_Val[5];
  mi.FParts[6] := M_Val[6];
  mi.FParts[7] := M_Val[7];

  if (M_Val[0] = 0) and (M_Val[1] = 0) and (M_Val[2] = 0) and
    (M_Val[3] = 0) and (M_Val[4] = 0) and (M_Val[5] = 0) and
    (M_Val[6] = 0) and (M_Val[7] = 0) then
    Zeroneg := True;

  if Zeroneg then
    mi.FIsNegative := uBoolFalse
  else if Signeg then
    mi.FIsNegative := uBoolTrue
  else
    mi.FIsNegative := uBoolFalse;

  999: ;
end;


(******************************************)
class operator TMultiIntX4.:=(const A: ansistring): TMultiIntX4;
begin
  String_to_Multi_Int_X4(A, Result);
end;


{$ifdef CPU_32}
(******************************************)
procedure INT_4W_S_to_Multi_Int_X4(const A: INT_4W_S; out mi: TMultiIntX4); inline;
var
  v: INT_4W_U;
begin
  mi.Overflow_flag := False;
  mi.Defined_flag := True;
  v := Abs(A);

  v := A;
  mi.M_Value[0] := INT_1W_U(v mod INT_1W_U_MAXINT_1);
  v := (v div INT_1W_U_MAXINT_1);
  mi.M_Value[1] := INT_1W_U(v mod INT_1W_U_MAXINT_1);
  v := (v div INT_1W_U_MAXINT_1);
  mi.M_Value[2] := INT_1W_U(v mod INT_1W_U_MAXINT_1);
  v := (v div INT_1W_U_MAXINT_1);
  mi.M_Value[3] := v;

  mi.M_Value[4] := 0;
  mi.M_Value[5] := 0;
  mi.M_Value[6] := 0;
  mi.M_Value[7] := 0;

  if (A < 0) then
    mi.Negative_flag := uBoolTrue
  else
    mi.Negative_flag := uBoolFalse;

end;


(******************************************)
class operator TMultiIntX4.:=(const A: INT_4W_S): TMultiIntX4;
begin
  INT_4W_S_to_Multi_Int_X4(A, Result);
end;


(******************************************)
procedure INT_4W_U_to_Multi_Int_X4(const A: INT_4W_U; out mi: TMultiIntX4); inline;
var
  v: INT_4W_U;
begin
  mi.Overflow_flag := False;
  mi.Defined_flag  := True;
  mi.Negative_flag := uBoolFalse;

  v := A;
  mi.M_Value[0] := INT_1W_U(v mod INT_1W_U_MAXINT_1);
  v := (v div INT_1W_U_MAXINT_1);
  mi.M_Value[1] := INT_1W_U(v mod INT_1W_U_MAXINT_1);
  v := (v div INT_1W_U_MAXINT_1);
  mi.M_Value[2] := INT_1W_U(v mod INT_1W_U_MAXINT_1);
  v := (v div INT_1W_U_MAXINT_1);
  mi.M_Value[3] := v;

  mi.M_Value[4] := 0;
  mi.M_Value[5] := 0;
  mi.M_Value[6] := 0;
  mi.M_Value[7] := 0;
end;


(******************************************)
class operator TMultiIntX4.:=(const A: INT_4W_U): TMultiIntX4;
begin
  INT_4W_U_to_Multi_Int_X4(A, Result);
end;
{$endif}


(******************************************)
procedure INT_2W_S_to_Multi_Int_X4(const A: INT_2W_S; out mi: TMultiIntX4); inline;
begin
  mi.FHasOverflow := False;
  mi.FIsDefined   := True;
  mi.FParts[2]    := 0;
  mi.FParts[3]    := 0;
  mi.FParts[4]    := 0;
  mi.FParts[5]    := 0;
  mi.FParts[6]    := 0;
  mi.FParts[7]    := 0;

  if (A < 0) then
  begin
    mi.FIsNegative := uBoolTrue;
    mi.FParts[0]   := (ABS(A) mod INT_1W_U_MAXINT_1);
    mi.FParts[1]   := (ABS(A) div INT_1W_U_MAXINT_1);
  end
  else
  begin
    mi.FIsNegative := uBoolFalse;
    mi.FParts[0]   := (A mod INT_1W_U_MAXINT_1);
    mi.FParts[1]   := (A div INT_1W_U_MAXINT_1);
  end;
end;


(******************************************)
class operator TMultiIntX4.:=(const A: INT_2W_S): TMultiIntX4;
begin
  INT_2W_S_to_Multi_Int_X4(A, Result);
end;


(******************************************)
procedure INT_2W_U_to_Multi_Int_X4(const A: INT_2W_U; out mi: TMultiIntX4); inline;
begin
  mi.FHasOverflow := False;
  mi.FIsDefined   := True;
  mi.FIsNegative  := uBoolFalse;

  mi.FParts[0] := (A mod INT_1W_U_MAXINT_1);
  mi.FParts[1] := (A div INT_1W_U_MAXINT_1);
  mi.FParts[2] := 0;
  mi.FParts[3] := 0;
  mi.FParts[4] := 0;
  mi.FParts[5] := 0;
  mi.FParts[6] := 0;
  mi.FParts[7] := 0;
end;


(******************************************)
class operator TMultiIntX4.:=(const A: INT_2W_U): TMultiIntX4;
begin
  INT_2W_U_to_Multi_Int_X4(A, Result);
end;


(******************************************)
// WARNING Float to Multi_Int type conversion loses some precision
class operator TMultiIntX4.:=(const A: single): TMultiIntX4;
var
  R: TMultiIntX4;
  R_FLOATREC: TFloatRec;
begin
  MultiIntError := False;

  FloatToDecimal(R_FLOATREC, A, SINGLE_TYPE_PRECISION_DIGITS, 0);
  String_to_Multi_Int_X4(AddCharR('0', AnsiLeftStr(R_FLOATREC.digits,
    (SINGLE_TYPE_PRECISION_DIGITS - 1)), R_FLOATREC.Exponent), R);

  if (R.HasOverflow) then
  begin
    MultiIntError      := True;
    Result.FIsDefined  := False;
    Result.FIsNegative := uBoolUndefined;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  if (R_FLOATREC.Negative) then
    R.FIsNegative := True;
  Result := R;
end;


(******************************************)
// WARNING Float to Multi_Int type conversion loses some precision
class operator TMultiIntX4.:=(const A: real): TMultiIntX4;
var
  R: TMultiIntX4;
  R_FLOATREC: TFloatRec;
begin
  MultiIntError := False;

  FloatToDecimal(R_FLOATREC, A, REAL_TYPE_PRECISION_DIGITS, 0);
  String_to_Multi_Int_X4(AddCharR('0', AnsiLeftStr(R_FLOATREC.digits,
    (REAL_TYPE_PRECISION_DIGITS - 1)), R_FLOATREC.Exponent), R);

  if (R.HasOverflow) then
  begin
    MultiIntError      := True;
    Result.FIsDefined  := False;
    Result.FIsNegative := uBoolUndefined;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  if (R_FLOATREC.Negative) then
    R.FIsNegative := True;
  Result := R;
end;


(******************************************)
// WARNING Float to Multi_Int type conversion loses some precision
class operator TMultiIntX4.:=(const A: double): TMultiIntX4;
var
  R: TMultiIntX4;
  R_FLOATREC: TFloatRec;
begin
  MultiIntError := False;

  FloatToDecimal(R_FLOATREC, A, DOUBLE_TYPE_PRECISION_DIGITS, 0);
  String_to_Multi_Int_X4(AddCharR('0', AnsiLeftStr(R_FLOATREC.digits,
    (DOUBLE_TYPE_PRECISION_DIGITS - 1)), R_FLOATREC.Exponent), R);

  if (R.HasOverflow) then
  begin
    MultiIntError      := True;
    Result.FIsDefined  := False;
    Result.FIsNegative := uBoolUndefined;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  if (R_FLOATREC.Negative) then
    R.FIsNegative := True;
  Result := R;
end;


(******************************************)
// WARNING Float to Multi_Int type conversion loses some precision
class operator TMultiIntX4.:=(const A: TMultiIntX4): single;
var
  R, V, M: single;
  i: INT_1W_U;
  finished: boolean;
begin
  if not A.FIsDefined then
  begin
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  MultiIntError := False;
  finished := False;
  M := INT_1W_U_MAXINT_1;

  R := A.FParts[0];
  i := 1;
  while (i <= Multi_X4_maxi) and (not MultiIntError) do
  begin
    if (not finished) then
    begin
      V := A.FParts[i];
      try
        begin
          V := (V * M);
          R := R + V;
        end
      except
        begin
          MultiIntError := True;
          if MultiIntEnableExceptions then
            raise EIntOverflow.Create('Overflow');
        end;
      end;
      V := INT_1W_U_MAXINT_1;
      try
        M := (M * V);
      except
        finished := True;
      end;
    end
    else
    if (A.FParts[i] > 0) then
    begin
      MultiIntError := True;
      if MultiIntEnableExceptions then
        raise EIntOverflow.Create('Overflow');
    end;
    Inc(i);
  end;

  if A.FIsNegative then
    R    := (-R);
  Result := R;
end;


(******************************************)
class operator TMultiIntX4.:=(const A: TMultiIntX4): real;
var
  R, V, M: real;
  i: INT_1W_U;
  finished: boolean;
begin
  if not A.FIsDefined then
  begin
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  MultiIntError := False;
  finished := False;
  M := INT_1W_U_MAXINT_1;

  R := A.FParts[0];
  i := 1;
  while (i <= Multi_X4_maxi) and (not MultiIntError) do
  begin
    if (not finished) then
    begin
      V := A.FParts[i];
      try
        begin
          V := (V * M);
          R := R + V;
        end
      except
        begin
          MultiIntError := True;
          if MultiIntEnableExceptions then
            raise EIntOverflow.Create('Overflow');
        end;
      end;
      V := INT_1W_U_MAXINT_1;
      try
        M := (M * V);
      except
        finished := True;
      end;
    end
    else
    if (A.FParts[i] > 0) then
    begin
      MultiIntError := True;
      if MultiIntEnableExceptions then
        raise EIntOverflow.Create('Overflow');
    end;
    Inc(i);
  end;

  if A.FIsNegative then
    R    := (-R);
  Result := R;
end;


(******************************************)
class operator TMultiIntX4.:=(const A: TMultiIntX4): double;
var
  R, V, M: double;
  i: INT_1W_U;
  finished: boolean;
begin
  if not A.FIsDefined then
  begin
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  MultiIntError := False;
  finished := False;
  M := INT_1W_U_MAXINT_1;

  R := A.FParts[0];
  i := 1;
  while (i <= Multi_X4_maxi) and (not MultiIntError) do
  begin
    if (not finished) then
    begin
      V := A.FParts[i];
      try
        begin
          V := (V * M);
          R := R + V;
        end
      except
        begin
          MultiIntError := True;
          if MultiIntEnableExceptions then
            raise EIntOverflow.Create('Overflow');
        end;
      end;
      V := INT_1W_U_MAXINT_1;
      try
        M := (M * V);
      except
        finished := True;
      end;
    end
    else
    if (A.FParts[i] > 0) then
    begin
      MultiIntError := True;
      if MultiIntEnableExceptions then
        raise EIntOverflow.Create('Overflow');
    end;
    Inc(i);
  end;

  if A.FIsNegative then
    R    := (-R);
  Result := R;
end;


(******************************************)
class operator TMultiIntX4.:=(const A: TMultiIntX4): INT_2W_S;
var
  R: INT_2W_U;
begin
  if not A.FIsDefined then
  begin
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  R := (INT_2W_U(A.FParts[0]) + (INT_2W_U(A.FParts[1]) * INT_1W_U_MAXINT_1));

  if (R >= INT_2W_S_MAXINT) or (A.FParts[2] <> 0) or (A.FParts[3] <> 0) or
    (A.FParts[4] <> 0) or (A.FParts[5] <> 0) or (A.FParts[6] <> 0) or
    (A.FParts[7] <> 0) then
  begin
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if A.FIsNegative then
    Result := INT_2W_S(-R)
  else
    Result := INT_2W_S(R);
end;


(******************************************)
class operator TMultiIntX4.:=(const A: TMultiIntX4): INT_2W_U;
var
  R: INT_2W_U;
begin
  MultiIntError := False;
  if not A.FIsDefined then
  begin
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  R := (INT_2W_U(A.FParts[1]) << INT_1W_SIZE);
  R := (R or INT_2W_U(A.FParts[0]));

  if (A.FParts[2] <> 0) or (A.FParts[3] <> 0) or (A.FParts[4] <> 0) or
    (A.FParts[5] <> 0) or (A.FParts[6] <> 0) or (A.FParts[7] <> 0) then
  begin
    Result := 0;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    exit;
  end;

  Result := R;
end;


(******************************************)
class operator TMultiIntX4.:=(const A: TMultiIntX4): INT_1W_S;
var
  R: INT_2W_U;
begin
  MultiIntError := False;
  if not A.FIsDefined then
  begin
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  R := (INT_2W_U(A.FParts[0]) + (INT_2W_U(A.FParts[1]) * INT_1W_U_MAXINT_1));

  if (R > INT_1W_S_MAXINT) or (A.FParts[2] <> 0) or (A.FParts[3] <> 0) or
    (A.FParts[4] <> 0) or (A.FParts[5] <> 0) or (A.FParts[6] <> 0) or
    (A.FParts[7] <> 0) then
  begin
    Result := 0;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    exit;
  end;

  if A.FIsNegative then
    Result := INT_1W_S(-R)
  else
    Result := INT_1W_S(R);
end;


(******************************************)
class operator TMultiIntX4.:=(const A: TMultiIntX4): INT_1W_U;
var
  R: INT_2W_U;
begin
  MultiIntError := False;
  if not A.FIsDefined or (A.FIsNegative = uBoolTrue) then
  begin
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  R := (INT_2W_U(A.FParts[0]) + (INT_2W_U(A.FParts[1]) * INT_1W_U_MAXINT_1));

  if (R > INT_1W_U_MAXINT) or (A.FParts[2] <> 0) or (A.FParts[3] <> 0) or
    (A.FParts[4] <> 0) or (A.FParts[5] <> 0) or (A.FParts[6] <> 0) or
    (A.FParts[7] <> 0) then
  begin
    Result := 0;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    exit;
  end;

  Result := INT_1W_U(R);
end;


{******************************************}
class operator TMultiIntX4.:=(const A: TMultiIntX4): TMultiUInt8;
  (* var  R  :TMultiUInt8; *)
begin
  MultiIntError := False;
  if not A.FIsDefined or (A.FIsNegative = uBoolTrue) then
  begin
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FParts[0] > UINT8_MAX) or (A.FParts[1] <> 0) or (A.FParts[2] <> 0) or
    (A.FParts[3] <> 0) or (A.FParts[4] <> 0) or (A.FParts[5] <> 0) or
    (A.FParts[6] <> 0) or (A.FParts[7] <> 0) then
  begin
    MultiIntError := True;
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  Result := TMultiUInt8(A.FParts[0]);
end;


{******************************************}
class operator TMultiIntX4.:=(const A: TMultiIntX4): TMultiInt8;
  (* var  R  :TMultiUInt8; *)
begin
  MultiIntError := False;
  if not A.FIsDefined or (A.FIsNegative = uBoolTrue) then
  begin
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FParts[0] > INT8_MAX) or (A.FParts[1] <> 0) or (A.FParts[2] <> 0) or
    (A.FParts[3] <> 0) or (A.FParts[4] <> 0) or (A.FParts[5] <> 0) or
    (A.FParts[6] <> 0) or (A.FParts[7] <> 0) then
  begin
    MultiIntError := True;
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  Result := TMultiInt8(A.FParts[0]);
end;


(******************************************)
procedure bin_to_Multi_Int_X4(const A: ansistring; out mi: TMultiIntX4); inline;
label
  999;
var
  n, b, c, e: INT_2W_U;
  bit: INT_1W_S;
  M_Val: array[0..Multi_X4_maxi] of INT_2W_U;
  Signeg, Zeroneg, M_Val_All_Zero: boolean;
begin
  MultiIntError := False;

  mi.FHasOverflow := False;
  mi.FIsDefined := True;
  mi.FIsNegative := False;
  Signeg  := False;
  Zeroneg := False;

  n := 0;
  while (n <= Multi_X4_maxi) do
  begin
    M_Val[n] := 0;
    Inc(n);
  end;

  if (length(A) > 0) then
  begin
    b := low(ansistring);
    e := b + INT_2W_U(length(A)) - 1;
    if (A[b] = '-') then
    begin
      Signeg := True;
      Inc(b);
    end;

    c := b;
    while (c <= e) do
    begin
      bit := (Ord(A[c]) - Ord('0'));
      if (bit > 1) or (bit < 0) then
      begin
        MultiIntError   := True;
        mi.FHasOverflow := True;
        mi.FIsDefined   := False;
        if MultiIntEnableExceptions then
          raise EInterror.Create('Invalid binary digit');
        goto 999;
      end;

      M_Val[0] := (M_Val[0] * 2) + bit;
      n := 1;
      while (n <= Multi_X4_maxi) do
      begin
        M_Val[n] := (M_Val[n] * 2);
        Inc(n);
      end;

      n := 0;
      while (n < Multi_X4_maxi) do
      begin
        if M_Val[n] > INT_1W_U_MAXINT then
        begin
          M_Val[n + 1] := M_Val[n + 1] + (M_Val[n] div INT_1W_U_MAXINT_1);
          M_Val[n]     := (M_Val[n] mod INT_1W_U_MAXINT_1);
        end;

        Inc(n);
      end;

      if M_Val[n] > INT_1W_U_MAXINT then
      begin
        mi.FIsDefined   := False;
        mi.FHasOverflow := True;
        MultiIntError   := True;
        if MultiIntEnableExceptions then
          raise EIntOverflow.Create('Overflow');
        goto 999;
      end;
      Inc(c);
    end;
  end;

  M_Val_All_Zero := True;
  n := 0;
  while (n <= Multi_X4_maxi) do
  begin
    mi.FParts[n] := M_Val[n];
    if M_Val[n] > 0 then
      M_Val_All_Zero := False;
    Inc(n);
  end;
  if M_Val_All_Zero then
    Zeroneg := True;

  if Zeroneg then
    mi.FIsNegative := uBoolFalse
  else if Signeg then
    mi.FIsNegative := uBoolTrue
  else
    mi.FIsNegative := uBoolFalse;

  999: ;
end;


(******************************************)
procedure FromBin(const A: ansistring; out mi: TMultiIntX4); overload;
begin
  Bin_to_Multi_Int_X4(A, mi);
end;


(******************************************)
function TMultiIntX4.FromBinaryString(const A: ansistring): TMultiIntX4;
begin
  bin_to_Multi_Int_X4(A, Result);
end;


(******************************************)
procedure Multi_Int_X4_to_bin(const A: TMultiIntX4; out B: ansistring;
  LeadingZeroMode: TMultiLeadingZeros); inline;
var
  s: ansistring = '';
  n: INT_1W_S;
begin
  if not A.FIsDefined then
  begin
    B := 'UNDEFINED';
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow) then
  begin
    B := 'OVERFLOW';
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    exit;
  end;

  n := INT_1W_SIZE;
  s := '';

  s := s + IntToBin(A.FParts[7], n) + IntToBin(A.FParts[6], n) +
    IntToBin(A.FParts[5], n) + IntToBin(A.FParts[4], n) +
    IntToBin(A.FParts[3], n) + IntToBin(A.FParts[2], n) +
    IntToBin(A.FParts[1], n) + IntToBin(A.FParts[0], n);

  if (LeadingZeroMode = TrimLeadingZeros) then
    RemoveLeadingChars(s, ['0']);
  if (A.FIsNegative = uBoolTrue) then
    s := '-' + s;
  if (s = '') then
    s := '0';
  B   := s;
end;


(******************************************)
function TMultiIntX4.ToBinaryString(const LeadingZeroMode: TMultiLeadingZeros):
ansistring;
begin
  Multi_Int_X4_to_bin(Self, Result, LeadingZeroMode);
end;


(******************************************)
procedure hex_to_Multi_Int_X4(const A: ansistring; out mi: TMultiIntX4); inline;
label
  999;
var
  n, i, b, c, e: INT_2W_U;
  M_Val: array[0..Multi_X4_maxi] of INT_2W_U;
  Signeg, Zeroneg, M_Val_All_Zero: boolean;
begin
  MultiIntError := False;

  mi.FHasOverflow := False;
  mi.FIsDefined := True;
  mi.FIsNegative := False;
  Signeg  := False;
  Zeroneg := False;

  n := 0;
  while (n <= Multi_X4_maxi) do
  begin
    M_Val[n] := 0;
    Inc(n);
  end;

  if (length(A) > 0) then
  begin
    b := low(ansistring);
    e := b + INT_2W_U(length(A)) - 1;
    if (A[b] = '-') then
    begin
      Signeg := True;
      Inc(b);
    end;

    c := b;
    while (c <= e) do
    begin
      try
        i := Hex2Dec(A[c]);
      except
        on EConvertError do
        begin
          MultiIntError   := True;
          mi.FHasOverflow := True;
          mi.FIsDefined   := False;
          if MultiIntEnableExceptions then
            raise;
        end;
      end;
      if mi.FIsDefined = False then
        goto 999;

      M_Val[0] := (M_Val[0] * 16) + i;
      n := 1;
      while (n <= Multi_X4_maxi) do
      begin
        M_Val[n] := (M_Val[n] * 16);
        Inc(n);
      end;

      n := 0;
      while (n < Multi_X4_maxi) do
      begin
        if M_Val[n] > INT_1W_U_MAXINT then
        begin
          M_Val[n + 1] := M_Val[n + 1] + (M_Val[n] div INT_1W_U_MAXINT_1);
          M_Val[n]     := (M_Val[n] mod INT_1W_U_MAXINT_1);
        end;

        Inc(n);
      end;

      if M_Val[n] > INT_1W_U_MAXINT then
      begin
        mi.FIsDefined   := False;
        mi.FHasOverflow := True;
        MultiIntError   := True;
        if MultiIntEnableExceptions then
          raise EIntOverflow.Create('Overflow');
        goto 999;
      end;
      Inc(c);
    end;
  end;

  M_Val_All_Zero := True;
  n := 0;
  while (n <= Multi_X4_maxi) do
  begin
    mi.FParts[n] := M_Val[n];
    if M_Val[n] > 0 then
      M_Val_All_Zero := False;
    Inc(n);
  end;
  if M_Val_All_Zero then
    Zeroneg := True;

  if Zeroneg then
    mi.FIsNegative := uBoolFalse
  else if Signeg then
    mi.FIsNegative := uBoolTrue
  else
    mi.FIsNegative := uBoolFalse;

  999: ;
end;


(******************************************)
procedure FromHex(const A: ansistring; out B: TMultiIntX4); overload;
begin
  hex_to_Multi_Int_X4(A, B);
end;


(******************************************)
function TMultiIntX4.FromHexString(const A: ansistring): TMultiIntX4;
begin
  hex_to_Multi_Int_X4(A, Result);
end;


(******************************************)
procedure Multi_Int_X4_to_hex(const A: TMultiIntX4; out B: ansistring;
  LeadingZeroMode: TMultiLeadingZeros); inline;
var
  s: ansistring = '';
  n: TMultiUInt16;
begin
  if not A.FIsDefined then
  begin
    B := 'UNDEFINED';
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow) then
  begin
    B := 'OVERFLOW';
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    exit;
  end;

  n := (INT_1W_SIZE div 4);
  s := '';

  s := s + IntToHex(A.FParts[7], n) + IntToHex(A.FParts[6], n) +
    IntToHex(A.FParts[5], n) + IntToHex(A.FParts[4], n) +
    IntToHex(A.FParts[3], n) + IntToHex(A.FParts[2], n) +
    IntToHex(A.FParts[1], n) + IntToHex(A.FParts[0], n);

  if (LeadingZeroMode = TrimLeadingZeros) then
    RemoveLeadingChars(s, ['0']);
  if (A.FIsNegative = uBoolTrue) then
    s := '-' + s;
  if (s = '') then
    s := '0';
  B   := s;
end;


(******************************************)
function TMultiIntX4.ToHexString(const LeadingZeroMode: TMultiLeadingZeros): ansistring;
begin
  Multi_Int_X4_to_hex(Self, Result, LeadingZeroMode);
end;


(******************************************)
procedure Multi_Int_X4_to_String(const A: TMultiIntX4; out B: ansistring); inline;
var
  s: ansistring = '';
  M_Val: array[0..Multi_X4_maxi] of INT_2W_U;
begin
  if not A.FIsDefined then
  begin
    B := 'UNDEFINED';
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow) then
  begin
    B := 'OVERFLOW';
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  M_Val[0] := A.FParts[0];
  M_Val[1] := A.FParts[1];
  M_Val[2] := A.FParts[2];
  M_Val[3] := A.FParts[3];
  M_Val[4] := A.FParts[4];
  M_Val[5] := A.FParts[5];
  M_Val[6] := A.FParts[6];
  M_Val[7] := A.FParts[7];

  repeat

    M_Val[6] := M_Val[6] + (INT_1W_U_MAXINT_1 * (M_Val[7] mod 10));
    M_Val[7] := (M_Val[7] div 10);

    M_Val[5] := M_Val[5] + (INT_1W_U_MAXINT_1 * (M_Val[6] mod 10));
    M_Val[6] := (M_Val[6] div 10);

    M_Val[4] := M_Val[4] + (INT_1W_U_MAXINT_1 * (M_Val[5] mod 10));
    M_Val[5] := (M_Val[5] div 10);

    M_Val[3] := M_Val[3] + (INT_1W_U_MAXINT_1 * (M_Val[4] mod 10));
    M_Val[4] := (M_Val[4] div 10);

    M_Val[2] := M_Val[2] + (INT_1W_U_MAXINT_1 * (M_Val[3] mod 10));
    M_Val[3] := (M_Val[3] div 10);

    M_Val[1] := M_Val[1] + (INT_1W_U_MAXINT_1 * (M_Val[2] mod 10));
    M_Val[2] := (M_Val[2] div 10);

    M_Val[0] := M_Val[0] + (INT_1W_U_MAXINT_1 * (M_Val[1] mod 10));
    M_Val[1] := (M_Val[1] div 10);

    s := IntToStr(M_Val[0] mod 10) + s;
    M_Val[0] := (M_Val[0] div 10);

  until (0 = 0) and (M_Val[0] = 0) and (M_Val[1] = 0) and (M_Val[2] = 0) and
    (M_Val[3] = 0) and (M_Val[4] = 0) and (M_Val[5] = 0) and
    (M_Val[6] = 0) and (M_Val[7] = 0);

  if (A.FIsNegative = uBoolTrue) then
    s := '-' + s;

  B := s;
end;


(******************************************)
function TMultiIntX4.ToString: ansistring;
begin
  Multi_Int_X4_to_String(Self, Result);
end;


(******************************************)
class operator TMultiIntX4.:=(const A: TMultiIntX4): ansistring;
begin
  Multi_Int_X4_to_String(A, Result);
end;


(******************************************)
class operator TMultiIntX4.xor(const A, B: TMultiIntX4): TMultiIntX4;
begin
  if not A.FIsDefined or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow or B.FHasOverflow) then
  begin
    Result := 0;
    Result.FHasOverflow := True;
    Result.FIsDefined := False;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  Result.FParts[0]    := (A.FParts[0] xor B.FParts[0]);
  Result.FParts[1]    := (A.FParts[1] xor B.FParts[1]);
  Result.FParts[2]    := (A.FParts[2] xor B.FParts[2]);
  Result.FParts[3]    := (A.FParts[3] xor B.FParts[3]);
  Result.FParts[4]    := (A.FParts[4] xor B.FParts[4]);
  Result.FParts[5]    := (A.FParts[5] xor B.FParts[5]);
  Result.FParts[6]    := (A.FParts[6] xor B.FParts[6]);
  Result.FParts[7]    := (A.FParts[7] xor B.FParts[7]);
  Result.FIsDefined   := True;
  Result.FHasOverflow := False;

  Result.FIsNegative := uBoolFalse;
  if (A.IsNegative <> B.IsNegative) then
    Result.FIsNegative := uBoolTrue;
end;


(******************************************)
class operator TMultiIntX4.or(const A, B: TMultiIntX4): TMultiIntX4;
begin
  if not A.FIsDefined or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  Result.FParts[0] := (A.FParts[0] or B.FParts[0]);
  Result.FParts[1] := (A.FParts[1] or B.FParts[1]);
  Result.FParts[2] := (A.FParts[2] or B.FParts[2]);
  Result.FParts[3] := (A.FParts[3] or B.FParts[3]);
  Result.FParts[4] := (A.FParts[4] or B.FParts[4]);
  Result.FParts[5] := (A.FParts[5] or B.FParts[5]);
  Result.FParts[6] := (A.FParts[6] or B.FParts[6]);
  Result.FParts[7] := (A.FParts[7] or B.FParts[7]);

  Result.FIsDefined   := True;
  Result.FHasOverflow := False;

  Result.FIsNegative := uBoolFalse;
  if A.IsNegative and B.IsNegative then
    Result.FIsNegative := uBoolTrue;
end;


(******************************************)
class operator TMultiIntX4.and(const A, B: TMultiIntX4): TMultiIntX4;
begin
  if not A.FIsDefined or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  Result.FParts[0] := (A.FParts[0] and B.FParts[0]);
  Result.FParts[1] := (A.FParts[1] and B.FParts[1]);
  Result.FParts[2] := (A.FParts[2] and B.FParts[2]);
  Result.FParts[3] := (A.FParts[3] and B.FParts[3]);
  Result.FParts[4] := (A.FParts[4] and B.FParts[4]);
  Result.FParts[5] := (A.FParts[5] and B.FParts[5]);
  Result.FParts[6] := (A.FParts[6] and B.FParts[6]);
  Result.FParts[7] := (A.FParts[7] and B.FParts[7]);

  Result.FIsDefined   := True;
  Result.FHasOverflow := False;

  Result.FIsNegative := uBoolFalse;
  if A.IsNegative and B.IsNegative then
    Result.FIsNegative := uBoolTrue;
end;


(******************************************)
class operator TMultiIntX4.not(const A: TMultiIntX4): TMultiIntX4;
begin
  if not A.FIsDefined then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  Result.FParts[0] := (not A.FParts[0]);
  Result.FParts[1] := (not A.FParts[1]);
  Result.FParts[2] := (not A.FParts[2]);
  Result.FParts[3] := (not A.FParts[3]);
  Result.FParts[4] := (not A.FParts[4]);
  Result.FParts[5] := (not A.FParts[5]);
  Result.FParts[6] := (not A.FParts[6]);
  Result.FParts[7] := (not A.FParts[7]);

  Result.FIsDefined   := True;
  Result.FHasOverflow := False;

  Result.FIsNegative := uBoolTrue;
  if A.IsNegative then
    Result.FIsNegative := uBoolFalse;
end;


(******************************************)
function add_Multi_Int_X4(const A, B: TMultiIntX4): TMultiIntX4;
var
  tv1, tv2: INT_2W_U;
  M_Val: array[0..Multi_X4_maxi] of INT_2W_U;
begin
  Result.FHasOverflow := False;
  Result.FIsDefined   := True;
  Result.FIsNegative  := uBoolUndefined;

  tv1      := A.FParts[0];
  tv2      := B.FParts[0];
  M_Val[0] := (tv1 + tv2);
  if M_Val[0] > INT_1W_U_MAXINT then
  begin
    M_Val[1] := (M_Val[0] div INT_1W_U_MAXINT_1);
    M_Val[0] := (M_Val[0] mod INT_1W_U_MAXINT_1);
  end
  else
    M_Val[1] := 0;

  tv1      := A.FParts[1];
  tv2      := B.FParts[1];
  M_Val[1] := (M_Val[1] + tv1 + tv2);
  if M_Val[1] > INT_1W_U_MAXINT then
  begin
    M_Val[2] := (M_Val[1] div INT_1W_U_MAXINT_1);
    M_Val[1] := (M_Val[1] mod INT_1W_U_MAXINT_1);
  end
  else
    M_Val[2] := 0;

  tv1      := A.FParts[2];
  tv2      := B.FParts[2];
  M_Val[2] := (M_Val[2] + tv1 + tv2);
  if M_Val[2] > INT_1W_U_MAXINT then
  begin
    M_Val[3] := (M_Val[2] div INT_1W_U_MAXINT_1);
    M_Val[2] := (M_Val[2] mod INT_1W_U_MAXINT_1);
  end
  else
    M_Val[3] := 0;

  tv1      := A.FParts[3];
  tv2      := B.FParts[3];
  M_Val[3] := (M_Val[3] + tv1 + tv2);
  if M_Val[3] > INT_1W_U_MAXINT then
  begin
    M_Val[4] := (M_Val[3] div INT_1W_U_MAXINT_1);
    M_Val[3] := (M_Val[3] mod INT_1W_U_MAXINT_1);
  end
  else
    M_Val[4] := 0;

  tv1      := A.FParts[4];
  tv2      := B.FParts[4];
  M_Val[4] := (M_Val[4] + tv1 + tv2);
  if M_Val[4] > INT_1W_U_MAXINT then
  begin
    M_Val[5] := (M_Val[4] div INT_1W_U_MAXINT_1);
    M_Val[4] := (M_Val[4] mod INT_1W_U_MAXINT_1);
  end
  else
    M_Val[5] := 0;

  tv1      := A.FParts[5];
  tv2      := B.FParts[5];
  M_Val[5] := (M_Val[5] + tv1 + tv2);
  if M_Val[5] > INT_1W_U_MAXINT then
  begin
    M_Val[6] := (M_Val[5] div INT_1W_U_MAXINT_1);
    M_Val[5] := (M_Val[5] mod INT_1W_U_MAXINT_1);
  end
  else
    M_Val[6] := 0;

  tv1      := A.FParts[6];
  tv2      := B.FParts[6];
  M_Val[6] := (M_Val[6] + tv1 + tv2);
  if M_Val[6] > INT_1W_U_MAXINT then
  begin
    M_Val[7] := (M_Val[6] div INT_1W_U_MAXINT_1);
    M_Val[6] := (M_Val[6] mod INT_1W_U_MAXINT_1);
  end
  else
    M_Val[7] := 0;

  tv1      := A.FParts[7];
  tv2      := B.FParts[7];
  M_Val[7] := (M_Val[7] + tv1 + tv2);
  if M_Val[7] > INT_1W_U_MAXINT then
  begin
    M_Val[7] := (M_Val[7] mod INT_1W_U_MAXINT_1);
    Result.FIsDefined := False;
    Result.FHasOverflow := True;
  end;

  Result.FParts[0] := M_Val[0];
  Result.FParts[1] := M_Val[1];
  Result.FParts[2] := M_Val[2];
  Result.FParts[3] := M_Val[3];
  Result.FParts[4] := M_Val[4];
  Result.FParts[5] := M_Val[5];
  Result.FParts[6] := M_Val[6];
  Result.FParts[7] := M_Val[7];

  if (M_Val[0] = 0) and (M_Val[1] = 0) and (M_Val[2] = 0) and
    (M_Val[3] = 0) and (M_Val[4] = 0) and (M_Val[5] = 0) and
    (M_Val[6] = 0) and (M_Val[7] = 0) then
    Result.FIsNegative := uBoolFalse;

end;


(******************************************)
function subtract_Multi_Int_X4(const A, B: TMultiIntX4): TMultiIntX4;
var
  M_Val: array[0..Multi_X4_maxi] of INT_2W_S;
begin
  Result.FHasOverflow := False;
  Result.FIsDefined   := True;
  Result.FIsNegative  := uBoolUndefined;

  M_Val[0] := (A.FParts[0] - B.FParts[0]);
  if M_Val[0] < 0 then
  begin
    M_Val[1] := -1;
    M_Val[0] := (M_Val[0] + INT_1W_U_MAXINT_1);
  end
  else
    M_Val[1] := 0;

  M_Val[1] := (A.FParts[1] - B.FParts[1] + M_Val[1]);
  if M_Val[1] < 0 then
  begin
    M_Val[2] := -1;
    M_Val[1] := (M_Val[1] + INT_1W_U_MAXINT_1);
  end
  else
    M_Val[2] := 0;

  M_Val[2] := (A.FParts[2] - B.FParts[2] + M_Val[2]);
  if M_Val[2] < 0 then
  begin
    M_Val[3] := -1;
    M_Val[2] := (M_Val[2] + INT_1W_U_MAXINT_1);
  end
  else
    M_Val[3] := 0;

  M_Val[3] := (A.FParts[3] - B.FParts[3] + M_Val[3]);
  if M_Val[3] < 0 then
  begin
    M_Val[4] := -1;
    M_Val[3] := (M_Val[3] + INT_1W_U_MAXINT_1);
  end
  else
    M_Val[4] := 0;

  M_Val[4] := (A.FParts[4] - B.FParts[4] + M_Val[4]);
  if M_Val[4] < 0 then
  begin
    M_Val[5] := -1;
    M_Val[4] := (M_Val[4] + INT_1W_U_MAXINT_1);
  end
  else
    M_Val[5] := 0;

  M_Val[5] := (A.FParts[5] - B.FParts[5] + M_Val[5]);
  if M_Val[5] < 0 then
  begin
    M_Val[6] := -1;
    M_Val[5] := (M_Val[5] + INT_1W_U_MAXINT_1);
  end
  else
    M_Val[6] := 0;

  M_Val[6] := (A.FParts[6] - B.FParts[6] + M_Val[6]);
  if M_Val[6] < 0 then
  begin
    M_Val[7] := -1;
    M_Val[6] := (M_Val[6] + INT_1W_U_MAXINT_1);
  end
  else
    M_Val[7] := 0;

  M_Val[7] := (A.FParts[7] - B.FParts[7] + M_Val[7]);
  if M_Val[7] < 0 then
  begin
    Result.FIsDefined   := False;
    Result.FHasOverflow := True;
  end;

  Result.FParts[0] := M_Val[0];
  Result.FParts[1] := M_Val[1];
  Result.FParts[2] := M_Val[2];
  Result.FParts[3] := M_Val[3];
  Result.FParts[4] := M_Val[4];
  Result.FParts[5] := M_Val[5];
  Result.FParts[6] := M_Val[6];
  Result.FParts[7] := M_Val[7];

  if (M_Val[0] = 0) and (M_Val[1] = 0) and (M_Val[2] = 0) and
    (M_Val[3] = 0) and (M_Val[4] = 0) and (M_Val[5] = 0) and
    (M_Val[6] = 0) and (M_Val[7] = 0) then
    Result.FIsNegative := uBoolFalse;

end;


(******************************************)
class operator TMultiIntX4.Inc(const A: TMultiIntX4): TMultiIntX4;
var
  Neg: TMultiUBoolState;
  B: TMultiIntX4;
begin
  if not A.FIsDefined then
  begin
    Result := 0;
    Result.FIsDefined := A.FIsDefined;
    Result.FHasOverflow := A.FHasOverflow;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FHasOverflow) then
  begin
    Result := 0;
    Result.FIsDefined := A.FIsDefined;
    Result.FHasOverflow := A.FHasOverflow;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  Neg := uBoolUndefined;
  B   := 1;

  if (A.FIsNegative = False) then
  begin
    Result := add_Multi_Int_X4(A, B);
    Neg    := A.FIsNegative;
  end
  else
  if ABS_greaterthan_Multi_Int_X4(A, B) then
  begin
    Result := subtract_Multi_Int_X4(A, B);
    Neg    := uBoolTrue;
  end
  else
  begin
    Result := subtract_Multi_Int_X4(B, A);
    Neg    := uBoolFalse;
  end;

  if (Result.FHasOverflow = True) then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
  end;

  if (Result.FIsNegative = uBoolUndefined) then
    Result.FIsNegative := Neg;
end;


(******************************************)
class operator TMultiIntX4.+(const A, B: TMultiIntX4): TMultiIntX4;
var
  Neg: TMultiUBool;
begin
  if not A.FIsDefined or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FHasOverflow or B.FHasOverflow) then
  begin
    Result := 0;
    Result.FHasOverflow := True;
    Result.FIsDefined := True;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  Neg := uBoolUndefined;

  if (A.FIsNegative = B.FIsNegative) then
  begin
    Result := add_Multi_Int_X4(A, B);
    Neg    := A.FIsNegative;
  end
  else
  if ((A.FIsNegative = False) and (B.FIsNegative = True)) then
  begin
    if ABS_greaterthan_Multi_Int_X4(B, A) then
    begin
      Result := subtract_Multi_Int_X4(B, A);
      Neg    := uBoolTrue;
    end
    else
    begin
      Result := subtract_Multi_Int_X4(A, B);
      Neg    := uBoolFalse;
    end;
  end
  else
  if ABS_greaterthan_Multi_Int_X4(A, B) then
  begin
    Result := subtract_Multi_Int_X4(A, B);
    Neg    := uBoolTrue;
  end
  else
  begin
    Result := subtract_Multi_Int_X4(B, A);
    Neg    := uBoolFalse;
  end;

  if (Result.FHasOverflow = True) then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
  end;

  if (Result.FIsNegative = uBoolUndefined) then
    Result.FIsNegative := Neg;
end;


(******************************************)
class operator TMultiIntX4.-(const A, B: TMultiIntX4): TMultiIntX4;
var
  Neg: TMultiUBoolState;
begin
  if not A.FIsDefined or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FHasOverflow or B.FHasOverflow) then
  begin
    Result := 0;
    Result.FHasOverflow := True;
    Result.FIsDefined := True;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  Neg := uBoolUndefined;

  if (A.FIsNegative = B.FIsNegative) then
  begin
    if (A.FIsNegative = True) then
    begin
      if ABS_greaterthan_Multi_Int_X4(A, B) then
      begin
        Result := subtract_Multi_Int_X4(A, B);
        Neg    := uBoolTrue;
      end
      else
      begin
        Result := subtract_Multi_Int_X4(B, A);
        Neg    := uBoolFalse;
      end;
    end
    else  (* if  not FIsNegative then  *)
    begin
      if ABS_greaterthan_Multi_Int_X4(B, A) then
      begin
        Result := subtract_Multi_Int_X4(B, A);
        Neg    := uBoolTrue;
      end
      else
      begin
        Result := subtract_Multi_Int_X4(A, B);
        Neg    := uBoolFalse;
      end;
    end;
  end
  else (* A.FIsNegative <> B.FIsNegative *)
  if (B.FIsNegative = True) then
  begin
    Result := add_Multi_Int_X4(A, B);
    Neg    := uBoolFalse;
  end
  else
  begin
    Result := add_Multi_Int_X4(A, B);
    Neg    := uBoolTrue;
  end;

  if (Result.FHasOverflow = True) then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
  end;

  if (Result.FIsNegative = uBoolUndefined) then
    Result.FIsNegative := Neg;
end;


(******************************************)
class operator TMultiIntX4.Dec(const A: TMultiIntX4): TMultiIntX4;
var
  Neg: TMultiUBoolState;
  B: TMultiIntX4;
begin
  if not A.FIsDefined then
  begin
    Result := 0;
    Result.FIsDefined := A.FIsDefined;
    Result.FHasOverflow := A.FHasOverflow;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FHasOverflow) then
  begin
    Result := 0;
    Result.FIsDefined := A.FIsDefined;
    Result.FHasOverflow := A.FHasOverflow;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  Neg := uBoolUndefined;
  B   := 1;

  if (A.FIsNegative = False) then
  begin
    if ABS_greaterthan_Multi_Int_X4(B, A) then
    begin
      Result := subtract_Multi_Int_X4(B, A);
      Neg    := uBoolTrue;
    end
    else
    begin
      Result := subtract_Multi_Int_X4(A, B);
      Neg    := uBoolFalse;
    end;
  end
  else (* A is FIsNegative *)
  begin
    Result := add_Multi_Int_X4(A, B);
    Neg    := uBoolTrue;
  end;

  if (Result.FHasOverflow = True) then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
  end;

  if (Result.FIsNegative = uBoolUndefined) then
    Result.FIsNegative := Neg;
end;


(******************************************)
class operator TMultiIntX4.-(const A: TMultiIntX4): TMultiIntX4;
begin
  Result := A;
  if (A.FIsNegative = uBoolTrue) then
    Result.FIsNegative := uBoolFalse;
  if (A.FIsNegative = uBoolFalse) then
    Result.FIsNegative := uBoolTrue;
end;


(*******************v4*********************)
procedure multiply_Multi_Int_X4(const A, B: TMultiIntX4; out Result: TMultiIntX4);
  overload;
label
  999;
var
  M_Val: array[0..Multi_X4_maxi_x2] of INT_2W_U;
  tv1, tv2: INT_2W_U;
  i, j, k, n, jz, iz: INT_1W_S;
  zf, zero_mult: boolean;
begin
  Result := 0;
  Result.FHasOverflow := False;
  Result.FIsDefined := True;
  Result.FIsNegative := uBoolUndefined;

  i := 0;
  repeat
    M_Val[i] := 0;
    Inc(i);
  until (i > Multi_X4_maxi_x2);

  zf := False;
  i  := Multi_X4_maxi;
  jz := -1;
  repeat
    if (B.FParts[i] <> 0) then
    begin
      jz := i;
      zf := True;
    end;
    Dec(i);
  until (i < 0) or (zf);
  if (jz < 0) then
  begin
    Result.FIsNegative := uBoolFalse;
    goto 999;
  end;

  zf := False;
  i  := Multi_X4_maxi;
  iz := -1;
  repeat
    if (A.FParts[i] <> 0) then
    begin
      iz := i;
      zf := True;
    end;
    Dec(i);
  until (i < 0) or (zf);
  if (iz < 0) then
  begin
    Result.FIsNegative := uBoolFalse;
    goto 999;
  end;

  i := 0;
  j := 0;
  repeat
    if (B.FParts[j] <> 0) then
    begin
      zero_mult := True;
      repeat
        if (A.FParts[i] <> 0) then
        begin
          zero_mult := False;
          tv1 := A.FParts[i];
          tv2 := B.FParts[j];
          M_Val[i + j + 1] :=
            (M_Val[i + j + 1] + ((tv1 * tv2) div INT_1W_U_MAXINT_1));
          M_Val[i + j] := (M_Val[i + j] + ((tv1 * tv2) mod INT_1W_U_MAXINT_1));
        end;
        Inc(i);
      until (i > iz);
      if not zero_mult then
      begin
        k := 0;
        repeat
          if (M_Val[k] <> 0) then
          begin
            M_Val[k + 1] := M_Val[k + 1] + (M_Val[k] div INT_1W_U_MAXINT_1);
            M_Val[k]     := (M_Val[k] mod INT_1W_U_MAXINT_1);
          end;
          Inc(k);
        until (k > Multi_X4_maxi);
      end;
      i := 0;
    end;
    Inc(j);
  until (j > jz);

  Result.FIsNegative := uBoolFalse;
  i := 0;
  repeat
    if (M_Val[i] <> 0) then
    begin
      Result.FIsNegative := uBoolUndefined;
      if (i > Multi_X4_maxi) then
        Result.FHasOverflow := True;
    end;
    Inc(i);
  until (i > Multi_X4_maxi_x2) or (Result.FHasOverflow);

  n := 0;
  while (n <= Multi_X4_maxi) do
  begin
    Result.FParts[n] := M_Val[n];
    Inc(n);
  end;

  999: ;
end;


(******************************************)
class operator TMultiIntX4.*(const A, B: TMultiIntX4): TMultiIntX4;
var
  R: TMultiIntX4;
begin
  if not A.FIsDefined or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FHasOverflow or B.FHasOverflow) then
  begin
    Result := 0;
    Result.FHasOverflow := True;
    Result.FIsDefined := True;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  multiply_Multi_Int_X4(A, B, R);

  if (R.FIsNegative = uBoolUndefined) then
    if (A.FIsNegative = B.FIsNegative) then
      R.FIsNegative := uBoolFalse
    else
      R.FIsNegative := uBoolTrue;

  Result := R;

  if (Result.FHasOverflow = True) then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
  end;

end;


(******************************************)
function Multi_Int_X3_to_X4_multiply(const A, B: TMultiIntX3): TMultiIntX4;
var
  R: TMultiIntX4;
begin
  if not A.FIsDefined or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FHasOverflow or B.FHasOverflow) then
  begin
    Result := 0;
    Result.FHasOverflow := True;
    Result.FIsDefined := True;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  multiply_Multi_Int_X4(A, B, R);

  if (R.FIsNegative = uBoolUndefined) then
    if (A.FIsNegative = B.FIsNegative) then
      R.FIsNegative := uBoolFalse
    else
      R.FIsNegative := uBoolTrue;

  Result := R;

  if (Result.FHasOverflow = True) then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
  end;
end;


(********************v3********************)
{ Function exp_by_squaring_iterative(TV, P) }

class operator TMultiIntX4.**(const A: TMultiIntX4; const P: INT_2W_S): TMultiIntX4;
var
  Y, TV, T, R: TMultiIntX4;
  PT: INT_2W_S;
begin
  PT := P;
  TV := A;
  if (PT < 0) then
    R := 0
  else if (PT = 0) then
    R := 1
  else
  begin
    Y := 1;
    while (PT > 1) do
    begin
      if odd(PT) then
      begin
        multiply_Multi_Int_X4(TV, Y, T);
        if (T.FHasOverflow) then
        begin
          Result := 0;
          Result.FIsDefined := False;
          Result.FHasOverflow := True;
          MultiIntError := True;
          if MultiIntEnableExceptions then
            raise EIntOverflow.Create('Overflow');
          exit;
        end;
        if (T.FIsNegative = uBoolUndefined) then
          if (TV.FIsNegative = Y.FIsNegative) then
            T.FIsNegative := uBoolFalse
          else
            T.FIsNegative := uBoolTrue;

        Y  := T;
        PT := PT - 1;
      end;
      multiply_Multi_Int_X4(TV, TV, T);
      if (T.FHasOverflow) then
      begin
        Result := 0;
        Result.FIsDefined := False;
        Result.FHasOverflow := True;
        MultiIntError := True;
        if MultiIntEnableExceptions then
          raise EIntOverflow.Create('Overflow');
        exit;
      end;
      T.FIsNegative := uBoolFalse;

      TV := T;
      PT := (PT div 2);
    end;
    {$WARNINGS OFF}
    {$HINTS OFF}
    multiply_Multi_Int_X4(TV, Y, R);

    if (R.FHasOverflow) then
    begin
      Result := 0;
      Result.FIsDefined := False;
      Result.FHasOverflow := True;
      MultiIntError := True;
      if MultiIntEnableExceptions then
        raise EIntOverflow.Create('Overflow');
      exit;
    end;
    if (R.FIsNegative = uBoolUndefined) then
      if (TV.FIsNegative = Y.FIsNegative) then
        R.FIsNegative := uBoolFalse
      else
        R.FIsNegative := uBoolTrue;
  end;

  Result := R;
end;


(********************A********************)
procedure intdivide_taylor_warruth_X4(const P_dividend, P_dividor: TMultiIntX4;
  out P_quotient, P_remainder: TMultiIntX4);
label
  AGAIN, 9000, 9999;
var
  dividor, quotient, dividend, next_dividend: Multi_Int_X5;

  dividend_i, dividend_i_1, quotient_i, dividor_i, dividor_i_1,
  dividor_non_zero_pos, shiftup_bits_dividor, i: INT_1W_S;

  t_word: INT_1W_U;

  adjacent_word_dividend, adjacent_word_division, word_division,
  word_dividend, word_carry, next_word_carry: INT_2W_U;

  finished: boolean;
begin
  dividend    := 0;
  next_dividend := 0;
  dividor     := 0;
  quotient    := 0;
  P_quotient  := 0;
  P_remainder := 0;

  if (P_dividor = 0) then
  begin
    P_quotient.FIsDefined := False;
    P_quotient.FHasOverflow := True;
    P_remainder.FIsDefined := False;
    P_remainder.FHasOverflow := True;
    MultiIntError := True;
  end
  else if (P_dividor = P_dividend) then
    P_quotient := 1
  else
  begin
    if (Abs(P_dividor) > Abs(P_dividend)) then
    begin
      P_remainder := P_dividend;
      goto 9000;
    end;

    dividor_non_zero_pos := 0;
    i := Multi_X4_maxi;
    while (i >= 0) do
    begin
      t_word := P_dividor.FParts[i];
      dividor.M_Value[i] := t_word;
      if (dividor_non_zero_pos = 0) then
        if (t_word <> 0) then
          dividor_non_zero_pos := i;
      Dec(i);
    end;
    dividor.Negative_flag := False;
    dividend := P_dividend;
    dividend.Negative_flag := False;

    // essential short-cut for single word dividor
    if (dividor_non_zero_pos = 0) then
    begin
      P_remainder := 0;
      P_quotient := 0;
      word_carry := 0;
      i := Multi_X4_maxi;
      while (i >= 0) do
      begin
        P_quotient.FParts[i] :=
          (((word_carry * INT_2W_U(INT_1W_U_MAXINT_1)) +
          INT_2W_U(dividend.M_Value[i])) div INT_2W_U(dividor.M_Value[0]));
        word_carry := (((word_carry * INT_2W_U(INT_1W_U_MAXINT_1)) +
          INT_2W_U(dividend.M_Value[i])) -
          (INT_2W_U(P_quotient.FParts[i]) * INT_2W_U(dividor.M_Value[0])));
        Dec(i);
      end;
      P_remainder.FParts[0] := word_carry;
      goto 9000;
    end;

    shiftup_bits_dividor := LeadingZeroCount(dividor.M_Value[dividor_non_zero_pos]);
    if (shiftup_bits_dividor > 0) then
    begin
      ShiftUp_NBits_Multi_Int_X5(dividend, shiftup_bits_dividor);
      ShiftUp_NBits_Multi_Int_X5(dividor, shiftup_bits_dividor);
    end;

    next_word_carry := 0;
    word_carry  := 0;
    dividor_i   := dividor_non_zero_pos;
    dividor_i_1 := (dividor_i - 1);
    dividend_i  := (Multi_X4_maxi + 1);
    finished    := False;
    while (not finished) do
      if (dividend_i >= 0) then
      begin
        if (dividend.M_Value[dividend_i] = 0) then
          Dec(dividend_i)
        else
        begin
          finished := True;
        end;
      end
      else
        finished := True;
    quotient_i   := (dividend_i - dividor_non_zero_pos);

    while (dividend >= 0) and (quotient_i >= 0) do
    begin
      word_dividend   := ((word_carry * INT_2W_U(INT_1W_U_MAXINT_1)) +
        dividend.M_Value[dividend_i]);
      word_division   := (word_dividend div dividor.M_Value[dividor_i]);
      next_word_carry := (word_dividend mod dividor.M_Value[dividor_i]);

      if (word_division > 0) then
      begin
        dividend_i_1 := (dividend_i - 1);
        if (dividend_i_1 >= 0) then
        begin
          AGAIN:
            adjacent_word_dividend :=
              ((next_word_carry * INT_2W_U(INT_1W_U_MAXINT_1)) +
            dividend.M_Value[dividend_i_1]);
          adjacent_word_division   := (dividor.M_Value[dividor_i_1] * word_division);
          if (adjacent_word_division > adjacent_word_dividend) or
            (word_division >= INT_1W_U_MAXINT_1) then
          begin
            Dec(word_division);
            next_word_carry := next_word_carry + dividor.M_Value[dividor_i];
            if (next_word_carry < INT_1W_U_MAXINT_1) then
              goto AGAIN;
          end;
        end;
        quotient      := 0;
        quotient.M_Value[quotient_i] := word_division;
        next_dividend := (dividend - (dividor * quotient));
        if (next_dividend.Negative) then
        begin
          Dec(word_division);
          quotient.M_Value[quotient_i] := word_division;
          next_dividend := (dividend - (dividor * quotient));
        end;
        P_quotient.FParts[quotient_i] := word_division;
        dividend   := next_dividend;
        word_carry := dividend.M_Value[dividend_i];
      end
      else
        word_carry := word_dividend;

      Dec(dividend_i);
      quotient_i := (dividend_i - dividor_non_zero_pos);
    end; { while }

    ShiftDown_MultiBits_Multi_Int_X5(dividend, shiftup_bits_dividor);
    P_remainder := To_Multi_Int_X4(dividend);

    9000:
      if (P_dividend.FIsNegative = True) and (P_remainder > 0) then
        P_remainder.FIsNegative := True;

    if (P_dividend.FIsNegative <> P_dividor.FIsNegative) and (P_quotient > 0) then
      P_quotient.FIsNegative := True;

  end;
  9999: ;
end;


(******************************************)
class operator TMultiIntX4.div(const A, B: TMultiIntX4): TMultiIntX4;
var
  Remainder, Quotient: TMultiIntX4;
begin
  if not A.FIsDefined or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FHasOverflow or B.FHasOverflow) then
  begin
    Result := 0;
    Result.FHasOverflow := True;
    Result.FIsDefined := True;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  // same values as last time

  if (X4_Last_Divisor = B) and (X4_Last_Dividend = A) then
    Result := X4_Last_Quotient
  else  // different values than last time
  begin
    intdivide_taylor_warruth_X4(A, B, Quotient, Remainder);

    X4_Last_Divisor   := B;
    X4_Last_Dividend  := A;
    X4_Last_Quotient  := Quotient;
    X4_Last_Remainder := Remainder;

    Result := Quotient;
  end;

  if (X4_Last_Remainder.FHasOverflow) or (X4_Last_Quotient.FHasOverflow) then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
  end;
end;


(******************************************)
class operator TMultiIntX4.mod(const A, B: TMultiIntX4): TMultiIntX4;
var
  Remainder, Quotient: TMultiIntX4;
begin
  if not A.FIsDefined or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow or B.FHasOverflow) then
  begin
    Result := 0;
    Result.FHasOverflow := True;
    Result.FIsDefined := True;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  // same values as last time

  if (X4_Last_Divisor = B) and (X4_Last_Dividend = A) then
    Result := X4_Last_Remainder
  else  // different values than last time
  begin
    intdivide_taylor_warruth_X4(A, B, Quotient, Remainder);

    X4_Last_Divisor   := B;
    X4_Last_Dividend  := A;
    X4_Last_Quotient  := Quotient;
    X4_Last_Remainder := Remainder;

    Result := Remainder;
  end;

  if (X4_Last_Remainder.FHasOverflow) or (X4_Last_Quotient.FHasOverflow) then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
  end;
end;


(***********B************)
procedure SqRoot(const A: TMultiIntX4; out VR, VREM: TMultiIntX4);
var
  D, D2: INT_2W_S;
  HS, LS: ansistring;
  H, L, C, CC, LPC, Q, R, T: TMultiIntX4;
  finished: boolean;
begin
  if not A.FIsDefined then
  begin
    VR   := 0;
    VR.FIsDefined := False;
    VREM := 0;
    VREM.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow) then
  begin
    VR   := 0;
    VR.FIsDefined := False;
    VREM := 0;
    VREM.FIsDefined := False;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  if (A.FIsNegative = uBoolTrue) then
  begin
    VR   := 0;
    VR.FIsDefined := False;
    VREM := 0;
    VREM.FIsDefined := False;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  if (A >= 100) then
  begin
    D  := length(A.ToString);
    D2 := D div 2;
    if ((D mod 2) = 0) then
    begin
      LS := '1' + AddCharR('0', '', D2 - 1);
      HS := '1' + AddCharR('0', '', D2);
      H  := HS;
      L  := LS;
    end
    else
    begin
      LS := '1' + AddCharR('0', '', D2);
      HS := '1' + AddCharR('0', '', D2 + 1);
      H  := HS;
      L  := LS;
    end;

    T := (H - L);
    ShiftDown_MultiBits_Multi_Int_X4(T, 1);
    C := (L + T);
  end
  else
  begin
    C := (A div 2);
    if (C = 0) then
      C := 1;
  end;

  finished := False;
  LPC      := A;
  repeat
    begin
      // CC:= ((C + (A div C)) div 2);
      intdivide_taylor_warruth_X4(A, C, Q, R);
      CC := (C + Q);
      ShiftDown_MultiBits_Multi_Int_X4(CC, 1);
      if (ABS(C - CC) < 2) then
        if (CC < LPC) then
          LPC := CC
        else if (CC >= LPC) then
          finished := True;
      C := CC;
    end
  until finished;

  VREM := (A - (LPC * LPC));
  VR   := LPC;
  VR.FIsNegative := uBoolFalse;
  VREM.FIsNegative := uBoolFalse;

end;


(*************************)
procedure SqRoot(const A: TMultiIntX4; out VR: TMultiIntX4);
var
  VREM: TMultiIntX4;
begin
  VREM := 0;
  sqroot(A, VR, VREM);
end;


(*************************)
function SqRoot(const A: TMultiIntX4): TMultiIntX4;
var
  VR, VREM: TMultiIntX4;
begin
  VREM := 0;
  sqroot(A, VR, VREM);
  Result := VR;
end;


{
******************************************
Multi_Int_X5  INTERNAL USE ONLY!
******************************************
}


(******************************************)
function ABS_greaterthan_Multi_Int_X5(const A, B: Multi_Int_X5): boolean;
begin
  if (A.M_Value[8] > B.M_Value[8]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.M_Value[8] < B.M_Value[8]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.M_Value[7] > B.M_Value[7]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.M_Value[7] < B.M_Value[7]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.M_Value[6] > B.M_Value[6]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.M_Value[6] < B.M_Value[6]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.M_Value[5] > B.M_Value[5]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.M_Value[5] < B.M_Value[5]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.M_Value[4] > B.M_Value[4]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.M_Value[4] < B.M_Value[4]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.M_Value[3] > B.M_Value[3]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.M_Value[3] < B.M_Value[3]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.M_Value[2] > B.M_Value[2]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.M_Value[2] < B.M_Value[2]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.M_Value[1] > B.M_Value[1]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.M_Value[1] < B.M_Value[1]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.M_Value[0] > B.M_Value[0]) then
  begin
    Result := True;
    exit;
  end
  else
  begin
    Result := False;
    exit;
  end;
end;


(******************************************)
function ABS_lessthan_Multi_Int_X5(const A, B: Multi_Int_X5): boolean;
begin
  if (A.M_Value[8] < B.M_Value[8]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.M_Value[8] > B.M_Value[8]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.M_Value[7] < B.M_Value[7]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.M_Value[7] > B.M_Value[7]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.M_Value[6] < B.M_Value[6]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.M_Value[6] > B.M_Value[6]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.M_Value[5] < B.M_Value[5]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.M_Value[5] > B.M_Value[5]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.M_Value[4] < B.M_Value[4]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.M_Value[4] > B.M_Value[4]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.M_Value[3] < B.M_Value[3]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.M_Value[3] > B.M_Value[3]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.M_Value[2] < B.M_Value[2]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.M_Value[2] > B.M_Value[2]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.M_Value[1] < B.M_Value[1]) then
  begin
    Result := True;
    exit;
  end
  else
  if (A.M_Value[1] > B.M_Value[1]) then
  begin
    Result := False;
    exit;
  end
  else
  if (A.M_Value[0] < B.M_Value[0]) then
  begin
    Result := True;
    exit;
  end
  else
  begin
    Result := False;
    exit;
  end;
end;


(******************************************)
function Multi_Int_X5.Negative: boolean; inline;
begin
  Result := Self.Negative_flag;
end;


(******************************************)
class operator Multi_Int_X5.>(const A, B: Multi_Int_X5): boolean;
begin
  if (not A.Defined_flag) or (not B.Defined_flag) or (A.Overflow_flag) or
    (B.Overflow_flag) then
  begin
    Result := False;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  Result := False;
  if ((A.Negative_flag = False) and (B.Negative_flag = True)) then
    Result := True
  else
  if ((A.Negative_flag = True) and (B.Negative_flag = False)) then
    Result := False
  else
  if ((A.Negative_flag = False) and (B.Negative_flag = False)) then
    Result := ABS_greaterthan_Multi_Int_X5(A, B)
  else
  if ((A.Negative_flag = True) and (B.Negative_flag = True)) then
    Result := ABS_lessthan_Multi_Int_X5(A, B);
end;


(******************************************)
class operator Multi_Int_X5.>=(const A, B: Multi_Int_X5): boolean;
begin
  if (not A.Defined_flag) or (not B.Defined_flag) or (A.Overflow_flag) or
    (B.Overflow_flag) then
  begin
    Result := False;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  Result := False;
  if ((A.Negative_flag = False) and (B.Negative_flag = True)) then
    Result := True
  else
  if ((A.Negative_flag = True) and (B.Negative_flag = False)) then
    Result := False
  else
  if ((A.Negative_flag = False) and (B.Negative_flag = False)) then
    Result := (not ABS_lessthan_Multi_Int_X5(A, B))
  else
  if ((A.Negative_flag = True) and (B.Negative_flag = True)) then
    Result := (not ABS_greaterthan_Multi_Int_X5(A, B));
end;


{$ifdef CPU_32}
(******************************************)
procedure ShiftUp_NBits_Multi_Int_X5(var A: Multi_Int_X5; NBits: INT_1W_U);
var
  carry_bits_1, carry_bits_2, carry_bits_mask, NBits_max, NBits_carry: INT_1W_U;

  procedure INT_1W_U_shl(var A: INT_1W_U; const nbits: INT_1W_U); inline;
  var
    carry_bits_mask_2w: INT_2W_U;
  begin
    carry_bits_mask_2w := A;
    carry_bits_mask_2w := (carry_bits_mask_2w << NBits);
    A := INT_1W_U(carry_bits_mask_2w and INT_1W_U_MAXINT);
  end;

begin
  if NBits > 0 then
  begin

    carry_bits_mask := $FFFF;
    NBits_max   := INT_1W_SIZE;
    NBits_carry := (NBits_max - NBits);
    INT_1W_U_shl(carry_bits_mask, NBits_carry);

    if NBits <= NBits_max then
    begin
      carry_bits_1 := ((A.M_Value[0] and carry_bits_mask) shr NBits_carry);
      INT_1W_U_shl(A.M_Value[0], NBits);

      carry_bits_2 := ((A.M_Value[1] and carry_bits_mask) shr NBits_carry);
      INT_1W_U_shl(A.M_Value[1], NBits);
      A.M_Value[1] := (A.M_Value[1] or carry_bits_1);

      carry_bits_1 := ((A.M_Value[2] and carry_bits_mask) shr NBits_carry);
      INT_1W_U_shl(A.M_Value[2], NBits);
      A.M_Value[2] := (A.M_Value[2] or carry_bits_2);

      carry_bits_2 := ((A.M_Value[3] and carry_bits_mask) shr NBits_carry);
      INT_1W_U_shl(A.M_Value[3], NBits);
      A.M_Value[3] := (A.M_Value[3] or carry_bits_1);

      carry_bits_1 := ((A.M_Value[4] and carry_bits_mask) shr NBits_carry);
      INT_1W_U_shl(A.M_Value[4], NBits);
      A.M_Value[4] := (A.M_Value[4] or carry_bits_2);

      carry_bits_2 := ((A.M_Value[5] and carry_bits_mask) shr NBits_carry);
      INT_1W_U_shl(A.M_Value[5], NBits);
      A.M_Value[5] := (A.M_Value[5] or carry_bits_1);

      carry_bits_1 := ((A.M_Value[6] and carry_bits_mask) shr NBits_carry);
      INT_1W_U_shl(A.M_Value[6], NBits);
      A.M_Value[6] := (A.M_Value[6] or carry_bits_2);

      carry_bits_2 := ((A.M_Value[7] and carry_bits_mask) shr NBits_carry);
      INT_1W_U_shl(A.M_Value[7], NBits);
      A.M_Value[7] := (A.M_Value[7] or carry_bits_1);

      INT_1W_U_shl(A.M_Value[8], NBits);
      A.M_Value[8] := (A.M_Value[8] or carry_bits_2);
    end;
  end;

end;

{$endif}


{$ifdef CPU_64}
(******************************************)
procedure ShiftUp_NBits_Multi_Int_X5(Var A:Multi_Int_X5; NBits:INT_1W_U);
var     carry_bits_1,
        carry_bits_2,
        carry_bits_mask,
        NBits_max,
        NBits_carry     :INT_1W_U;

begin
if NBits > 0 then
begin

carry_bits_mask:= $FFFFFFFF;
NBits_max:= INT_1W_SIZE;
NBits_carry:= (NBits_max - NBits);
carry_bits_mask:= (carry_bits_mask << NBits_carry);

if NBits <= NBits_max then
        begin
        carry_bits_1:= ((A.M_Value[0] and carry_bits_mask) shr NBits_carry);
        A.M_Value[0]:= (A.M_Value[0] << NBits);

        carry_bits_2:= ((A.M_Value[1] and carry_bits_mask) shr NBits_carry);
        A.M_Value[1]:= ((A.M_Value[1] << NBits) OR carry_bits_1);

        carry_bits_1:= ((A.M_Value[2] and carry_bits_mask) shr NBits_carry);
        A.M_Value[2]:= ((A.M_Value[2] << NBits) OR carry_bits_2);

        carry_bits_2:= ((A.M_Value[3] and carry_bits_mask) shr NBits_carry);
        A.M_Value[3]:= ((A.M_Value[3] << NBits) OR carry_bits_1);

        carry_bits_1:= ((A.M_Value[4] and carry_bits_mask) shr NBits_carry);
        A.M_Value[4]:= ((A.M_Value[4] << NBits) OR carry_bits_2);

        carry_bits_2:= ((A.M_Value[5] and carry_bits_mask) shr NBits_carry);
        A.M_Value[5]:= ((A.M_Value[5] << NBits) OR carry_bits_1);

        carry_bits_1:= ((A.M_Value[6] and carry_bits_mask) shr NBits_carry);
        A.M_Value[6]:= ((A.M_Value[6] << NBits) OR carry_bits_2);

        carry_bits_2:= ((A.M_Value[7] and carry_bits_mask) shr NBits_carry);
        A.M_Value[7]:= ((A.M_Value[7] << NBits) OR carry_bits_1);

        A.M_Value[8]:= ((A.M_Value[8] << NBits) OR carry_bits_2);
        end;
end;

end;

{$endif}


(******************************************)
procedure ShiftDown_NBits_Multi_Int_X5(var A: Multi_Int_X5; NBits: INT_1W_U);
var
  carry_bits_1, carry_bits_2, carry_bits_mask, NBits_max, NBits_carry: INT_1W_U;
begin
  if NBits > 0 then
  begin

    {$ifdef CPU_32}
    carry_bits_mask := $FFFF;
    {$endif}
    {$ifdef CPU_64}
carry_bits_mask:= $FFFFFFFF;
    {$endif}

    NBits_max   := INT_1W_SIZE;
    NBits_carry := (NBits_max - NBits);
    carry_bits_mask := (carry_bits_mask shr NBits_carry);

    if NBits <= NBits_max then
    begin

      carry_bits_2 := ((A.M_Value[8] and carry_bits_mask) << NBits_carry);
      A.M_Value[8] := (A.M_Value[8] shr NBits);

      carry_bits_1 := ((A.M_Value[7] and carry_bits_mask) << NBits_carry);
      A.M_Value[7] := ((A.M_Value[7] shr NBits) or carry_bits_2);

      carry_bits_2 := ((A.M_Value[6] and carry_bits_mask) << NBits_carry);
      A.M_Value[6] := ((A.M_Value[6] shr NBits) or carry_bits_1);

      carry_bits_1 := ((A.M_Value[5] and carry_bits_mask) << NBits_carry);
      A.M_Value[5] := ((A.M_Value[5] shr NBits) or carry_bits_2);

      carry_bits_2 := ((A.M_Value[4] and carry_bits_mask) << NBits_carry);
      A.M_Value[4] := ((A.M_Value[4] shr NBits) or carry_bits_1);

      carry_bits_1 := ((A.M_Value[3] and carry_bits_mask) << NBits_carry);
      A.M_Value[3] := ((A.M_Value[3] shr NBits) or carry_bits_2);

      carry_bits_2 := ((A.M_Value[2] and carry_bits_mask) << NBits_carry);
      A.M_Value[2] := ((A.M_Value[2] shr NBits) or carry_bits_1);

      carry_bits_1 := ((A.M_Value[1] and carry_bits_mask) << NBits_carry);
      A.M_Value[1] := ((A.M_Value[1] shr NBits) or carry_bits_2);

      A.M_Value[0] := ((A.M_Value[0] shr NBits) or carry_bits_1);

    end;
  end;

end;


(******************************************)
procedure ShiftDown_NWords_Multi_Int_X5(var A: Multi_Int_X5; NWords: INT_1W_U);
var
  n: INT_1W_U;
begin
  if (NWords > 0) then
    if (NWords <= Multi_X5_maxi) then
    begin
      n := NWords;
      while (n > 0) do
      begin
        A.M_Value[0] := A.M_Value[1];
        A.M_Value[1] := A.M_Value[2];
        A.M_Value[2] := A.M_Value[3];
        A.M_Value[3] := A.M_Value[4];
        A.M_Value[4] := A.M_Value[5];
        A.M_Value[5] := A.M_Value[6];
        A.M_Value[6] := A.M_Value[7];
        A.M_Value[7] := A.M_Value[8];
        A.M_Value[8] := 0;
        Dec(n);
      end;
    end
    else
    begin
      A.M_Value[0] := 0;
      A.M_Value[1] := 0;
      A.M_Value[2] := 0;
      A.M_Value[3] := 0;
      A.M_Value[4] := 0;
      A.M_Value[5] := 0;
      A.M_Value[6] := 0;
      A.M_Value[7] := 0;
      A.M_Value[8] := 0;
    end;
end;


{******************************************}
procedure ShiftDown_MultiBits_Multi_Int_X5(var A: Multi_Int_X5; NBits: INT_1W_U);
var
  NWords_count, NBits_count: INT_1W_U;
begin
  if (not A.Defined_flag) then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (NBits >= INT_1W_SIZE) then
  begin
    NWords_count := (NBits div INT_1W_SIZE);
    NBits_count  := (NBits mod INT_1W_SIZE);
    ShiftDown_NWords_Multi_Int_X5(A, NWords_count);
  end
  else
    NBits_count := NBits;

  ShiftDown_NBits_Multi_Int_X5(A, NBits_count);
end;


(******************************************)
procedure INT_2W_U_to_Multi_Int_X5(const A: INT_2W_U; out mi: Multi_Int_X5); inline;
begin
  mi.Overflow_flag := False;
  mi.Defined_flag  := True;
  mi.Negative_flag := uBoolFalse;

  mi.M_Value[0] := (A mod INT_1W_U_MAXINT_1);
  mi.M_Value[1] := (A div INT_1W_U_MAXINT_1);
  mi.M_Value[2] := 0;
  mi.M_Value[3] := 0;
  mi.M_Value[4] := 0;
  mi.M_Value[5] := 0;
  mi.M_Value[6] := 0;
  mi.M_Value[7] := 0;
  mi.M_Value[8] := 0;
end;


(******************************************)
class operator Multi_Int_X5.:=(const A: INT_2W_U): Multi_Int_X5;
begin
  INT_2W_U_to_Multi_Int_X5(A, Result);
end;


(******************************************)
procedure Multi_Int_X4_to_Multi_Int_X5(const A: TMultiIntX4;
  var MI: Multi_Int_X5); inline;
var
  n: INT_1W_U;
begin
  MI.Overflow_flag := A.FHasOverflow;
  MI.Defined_flag  := A.FIsDefined;
  MI.Negative_flag := A.FIsNegative;

  if (A.FIsDefined = False) then
  begin
    MultiIntError   := True;
    MI.Defined_flag := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FHasOverflow = True) then
  begin
    MultiIntError    := True;
    MI.Overflow_flag := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    exit;
  end;

  n := 0;
  while (n <= Multi_X4_maxi) do
  begin
    MI.M_Value[n] := A.FParts[n];
    Inc(n);
  end;

  while (n <= Multi_X5_max) do
  begin
    MI.M_Value[n] := 0;
    Inc(n);
  end;
end;


(******************************************)
class operator Multi_Int_X5.:=(const A: TMultiIntX4): Multi_Int_X5;
begin
  Multi_Int_X4_to_Multi_Int_X5(A, Result);
end;


(******************************************)
function To_Multi_Int_X5(const A: TMultiIntX4): Multi_Int_X5;
begin
  Multi_Int_X4_to_Multi_Int_X5(A, Result);
end;


(******************************************)
function To_Multi_Int_X4(const A: Multi_Int_X5): TMultiIntX4; overload;
var
  n: INT_1W_U;
begin
  Result.FHasOverflow := A.Overflow_flag;
  Result.FIsDefined   := A.Defined_flag;
  Result.FIsNegative  := A.Negative_flag;

  if (A.Defined_flag = False) then
  begin
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    Result.FIsDefined := False;
    exit;
  end;

  if (A.Overflow_flag = True) or (A > Multi_Int_X4_MAXINT) then
  begin
    Result.FHasOverflow := True;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    exit;
  end;

  n := 0;
  while (n <= Multi_X4_maxi) do
  begin
    Result.FParts[n] := A.M_Value[n];
    Inc(n);
  end;
end;


(*******************v4*********************)
procedure multiply_Multi_Int_X5(const A, B: Multi_Int_X5;
  out Result: Multi_Int_X5); overload;
label
  999;
var
  M_Val: array[0..Multi_X5_max_x2] of INT_2W_U;
  tv1, tv2: INT_2W_U;
  i, j, k, n, jz, iz: INT_1W_S;
  zf, zero_mult: boolean;
begin
  Result := 0;
  Result.Overflow_flag := False;
  Result.Defined_flag := True;
  Result.Negative_flag := uBoolUndefined;

  i := 0;
  repeat
    M_Val[i] := 0;
    Inc(i);
  until (i > Multi_X5_max_x2);

  zf := False;
  i  := Multi_X5_max;
  jz := -1;
  repeat
    if (B.M_Value[i] <> 0) then
    begin
      jz := i;
      zf := True;
    end;
    Dec(i);
  until (i < 0) or (zf);
  if (jz < 0) then
  begin
    Result.Negative_flag := uBoolFalse;
    goto 999;
  end;

  zf := False;
  i  := Multi_X5_max;
  iz := -1;
  repeat
    if (A.M_Value[i] <> 0) then
    begin
      iz := i;
      zf := True;
    end;
    Dec(i);
  until (i < 0) or (zf);
  if (iz < 0) then
  begin
    Result.Negative_flag := uBoolFalse;
    goto 999;
  end;

  i := 0;
  j := 0;
  repeat
    if (B.M_Value[j] <> 0) then
    begin
      zero_mult := True;
      repeat
        if (A.M_Value[i] <> 0) then
        begin
          zero_mult := False;
          tv1 := A.M_Value[i];
          tv2 := B.M_Value[j];
          M_Val[i + j + 1] :=
            (M_Val[i + j + 1] + ((tv1 * tv2) div INT_1W_U_MAXINT_1));
          M_Val[i + j] := (M_Val[i + j] + ((tv1 * tv2) mod INT_1W_U_MAXINT_1));
        end;
        Inc(i);
      until (i > iz);
      if not zero_mult then
      begin
        k := 0;
        repeat
          if (M_Val[k] <> 0) then
          begin
            M_Val[k + 1] := M_Val[k + 1] + (M_Val[k] div INT_1W_U_MAXINT_1);
            M_Val[k]     := (M_Val[k] mod INT_1W_U_MAXINT_1);
          end;
          Inc(k);
        until (k > Multi_X5_max);
      end;
      i := 0;
    end;
    Inc(j);
  until (j > jz);

  Result.Negative_flag := uBoolFalse;
  i := 0;
  repeat
    if (M_Val[i] <> 0) then
    begin
      Result.Negative_flag := uBoolUndefined;
      if (i > Multi_X5_max) then
        Result.Overflow_flag := True;
    end;
    Inc(i);
  until (i > Multi_X5_max_x2) or (Result.Overflow_flag);

  n := 0;
  while (n <= Multi_X5_max) do
  begin
    Result.M_Value[n] := M_Val[n];
    Inc(n);
  end;

  999: ;
end;


(******************************************)
class operator Multi_Int_X5.*(const A, B: Multi_Int_X5): Multi_Int_X5;
var
  R: Multi_Int_X5;
begin
  if (not A.Defined_flag) or (not B.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.Overflow_flag or B.Overflow_flag) then
  begin
    Result := 0;
    Result.Overflow_flag := True;
    Result.Defined_flag := True;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  multiply_Multi_Int_X5(A, B, R);

  if (R.Negative_flag = uBoolUndefined) then
    if (A.Negative_flag = B.Negative_flag) then
      R.Negative_flag := uBoolFalse
    else
      R.Negative_flag := uBoolTrue;

  Result := R;

  if (Result.Overflow_flag = True) then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
  end;

end;


(******************************************)
function Multi_Int_X4_to_X5_multiply(const A, B: TMultiIntX4): Multi_Int_X5;
var
  R: Multi_Int_X5;
begin
  if not A.FIsDefined or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.Defined_flag := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FHasOverflow or B.FHasOverflow) then
  begin
    Result := 0;
    Result.Overflow_flag := True;
    Result.Defined_flag := True;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  multiply_Multi_Int_X5(A, B, R);

  if (R.Negative_flag = uBoolUndefined) then
    if (A.FIsNegative = B.FIsNegative) then
      R.Negative_flag := uBoolFalse
    else
      R.Negative_flag := uBoolTrue;

  Result := R;

  if (Result.Overflow_flag = True) then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
  end;
end;


(******************************************)
function add_Multi_Int_X5(const A, B: Multi_Int_X5): Multi_Int_X5;
var
  tv1, tv2: INT_2W_U;
  M_Val: array[0..Multi_X5_max] of INT_2W_U;
begin
  Result.Overflow_flag := False;
  Result.Defined_flag  := True;
  Result.Negative_flag := uBoolUndefined;

  tv1      := A.M_Value[0];
  tv2      := B.M_Value[0];
  M_Val[0] := (tv1 + tv2);
  if M_Val[0] > INT_1W_U_MAXINT then
  begin
    M_Val[1] := (M_Val[0] div INT_1W_U_MAXINT_1);
    M_Val[0] := (M_Val[0] mod INT_1W_U_MAXINT_1);
  end
  else
    M_Val[1] := 0;

  tv1      := A.M_Value[1];
  tv2      := B.M_Value[1];
  M_Val[1] := (M_Val[1] + tv1 + tv2);
  if M_Val[1] > INT_1W_U_MAXINT then
  begin
    M_Val[2] := (M_Val[1] div INT_1W_U_MAXINT_1);
    M_Val[1] := (M_Val[1] mod INT_1W_U_MAXINT_1);
  end
  else
    M_Val[2] := 0;

  tv1      := A.M_Value[2];
  tv2      := B.M_Value[2];
  M_Val[2] := (M_Val[2] + tv1 + tv2);
  if M_Val[2] > INT_1W_U_MAXINT then
  begin
    M_Val[3] := (M_Val[2] div INT_1W_U_MAXINT_1);
    M_Val[2] := (M_Val[2] mod INT_1W_U_MAXINT_1);
  end
  else
    M_Val[3] := 0;

  tv1      := A.M_Value[3];
  tv2      := B.M_Value[3];
  M_Val[3] := (M_Val[3] + tv1 + tv2);
  if M_Val[3] > INT_1W_U_MAXINT then
  begin
    M_Val[4] := (M_Val[3] div INT_1W_U_MAXINT_1);
    M_Val[3] := (M_Val[3] mod INT_1W_U_MAXINT_1);
  end
  else
    M_Val[4] := 0;

  tv1      := A.M_Value[4];
  tv2      := B.M_Value[4];
  M_Val[4] := (M_Val[4] + tv1 + tv2);
  if M_Val[4] > INT_1W_U_MAXINT then
  begin
    M_Val[5] := (M_Val[4] div INT_1W_U_MAXINT_1);
    M_Val[4] := (M_Val[4] mod INT_1W_U_MAXINT_1);
  end
  else
    M_Val[5] := 0;

  tv1      := A.M_Value[5];
  tv2      := B.M_Value[5];
  M_Val[5] := (M_Val[5] + tv1 + tv2);
  if M_Val[5] > INT_1W_U_MAXINT then
  begin
    M_Val[6] := (M_Val[5] div INT_1W_U_MAXINT_1);
    M_Val[5] := (M_Val[5] mod INT_1W_U_MAXINT_1);
  end
  else
    M_Val[6] := 0;

  tv1      := A.M_Value[6];
  tv2      := B.M_Value[6];
  M_Val[6] := (M_Val[6] + tv1 + tv2);
  if M_Val[6] > INT_1W_U_MAXINT then
  begin
    M_Val[7] := (M_Val[6] div INT_1W_U_MAXINT_1);
    M_Val[6] := (M_Val[6] mod INT_1W_U_MAXINT_1);
  end
  else
    M_Val[7] := 0;

  tv1      := A.M_Value[7];
  tv2      := B.M_Value[7];
  M_Val[7] := (M_Val[7] + tv1 + tv2);
  if M_Val[7] > INT_1W_U_MAXINT then
  begin
    M_Val[8] := (M_Val[7] div INT_1W_U_MAXINT_1);
    M_Val[7] := (M_Val[7] mod INT_1W_U_MAXINT_1);
  end
  else
    M_Val[8] := 0;

  tv1      := A.M_Value[8];
  tv2      := B.M_Value[8];
  M_Val[8] := (M_Val[8] + tv1 + tv2);
  if M_Val[8] > INT_1W_U_MAXINT then
  begin
    M_Val[8] := (M_Val[8] mod INT_1W_U_MAXINT_1);
    Result.Defined_flag := False;
    Result.Overflow_flag := True;
  end;

  Result.M_Value[0] := M_Val[0];
  Result.M_Value[1] := M_Val[1];
  Result.M_Value[2] := M_Val[2];
  Result.M_Value[3] := M_Val[3];
  Result.M_Value[4] := M_Val[4];
  Result.M_Value[5] := M_Val[5];
  Result.M_Value[6] := M_Val[6];
  Result.M_Value[7] := M_Val[7];
  Result.M_Value[8] := M_Val[8];

  if (M_Val[0] = 0) and (M_Val[1] = 0) and (M_Val[2] = 0) and
    (M_Val[3] = 0) and (M_Val[4] = 0) and (M_Val[5] = 0) and
    (M_Val[6] = 0) and (M_Val[7] = 0) and (M_Val[8] = 0) then
    Result.Negative_flag := uBoolFalse;

end;


(******************************************)
function subtract_Multi_Int_X5(const A, B: Multi_Int_X5): Multi_Int_X5;
var
  M_Val: array[0..Multi_X5_max] of INT_2W_S;
begin
  Result.Overflow_flag := False;
  Result.Defined_flag  := True;
  Result.Negative_flag := uBoolUndefined;

  M_Val[0] := (A.M_Value[0] - B.M_Value[0]);
  if M_Val[0] < 0 then
  begin
    M_Val[1] := -1;
    M_Val[0] := (M_Val[0] + INT_1W_U_MAXINT_1);
  end
  else
    M_Val[1] := 0;

  M_Val[1] := (A.M_Value[1] - B.M_Value[1] + M_Val[1]);
  if M_Val[1] < 0 then
  begin
    M_Val[2] := -1;
    M_Val[1] := (M_Val[1] + INT_1W_U_MAXINT_1);
  end
  else
    M_Val[2] := 0;

  M_Val[2] := (A.M_Value[2] - B.M_Value[2] + M_Val[2]);
  if M_Val[2] < 0 then
  begin
    M_Val[3] := -1;
    M_Val[2] := (M_Val[2] + INT_1W_U_MAXINT_1);
  end
  else
    M_Val[3] := 0;

  M_Val[3] := (A.M_Value[3] - B.M_Value[3] + M_Val[3]);
  if M_Val[3] < 0 then
  begin
    M_Val[4] := -1;
    M_Val[3] := (M_Val[3] + INT_1W_U_MAXINT_1);
  end
  else
    M_Val[4] := 0;

  M_Val[4] := (A.M_Value[4] - B.M_Value[4] + M_Val[4]);
  if M_Val[4] < 0 then
  begin
    M_Val[5] := -1;
    M_Val[4] := (M_Val[4] + INT_1W_U_MAXINT_1);
  end
  else
    M_Val[5] := 0;

  M_Val[5] := (A.M_Value[5] - B.M_Value[5] + M_Val[5]);
  if M_Val[5] < 0 then
  begin
    M_Val[6] := -1;
    M_Val[5] := (M_Val[5] + INT_1W_U_MAXINT_1);
  end
  else
    M_Val[6] := 0;

  M_Val[6] := (A.M_Value[6] - B.M_Value[6] + M_Val[6]);
  if M_Val[6] < 0 then
  begin
    M_Val[7] := -1;
    M_Val[6] := (M_Val[6] + INT_1W_U_MAXINT_1);
  end
  else
    M_Val[7] := 0;

  M_Val[7] := (A.M_Value[7] - B.M_Value[7] + M_Val[7]);
  if M_Val[7] < 0 then
  begin
    M_Val[8] := -1;
    M_Val[7] := (M_Val[7] + INT_1W_U_MAXINT_1);
  end
  else
    M_Val[8] := 0;

  M_Val[8] := (A.M_Value[8] - B.M_Value[8] + M_Val[8]);
  if M_Val[8] < 0 then
  begin
    Result.Defined_flag  := False;
    Result.Overflow_flag := True;
  end;

  Result.M_Value[0] := M_Val[0];
  Result.M_Value[1] := M_Val[1];
  Result.M_Value[2] := M_Val[2];
  Result.M_Value[3] := M_Val[3];
  Result.M_Value[4] := M_Val[4];
  Result.M_Value[5] := M_Val[5];
  Result.M_Value[6] := M_Val[6];
  Result.M_Value[7] := M_Val[7];
  Result.M_Value[8] := M_Val[8];

  if (M_Val[0] = 0) and (M_Val[1] = 0) and (M_Val[2] = 0) and
    (M_Val[3] = 0) and (M_Val[4] = 0) and (M_Val[5] = 0) and
    (M_Val[6] = 0) and (M_Val[7] = 0) and (M_Val[8] = 0) then
    Result.Negative_flag := uBoolFalse;

end;


(******************************************)
class operator Multi_Int_X5.-(const A, B: Multi_Int_X5): Multi_Int_X5;
var
  Neg: TMultiUBoolState;
begin
  if (not A.Defined_flag) or (not B.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.Overflow_flag or B.Overflow_flag) then
  begin
    Result := 0;
    Result.Overflow_flag := True;
    Result.Defined_flag := True;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  Neg := uBoolUndefined;

  if (A.Negative_flag = B.Negative_flag) then
  begin
    if (A.Negative_flag = True) then
    begin
      if ABS_greaterthan_Multi_Int_X5(A, B) then
      begin
        Result := subtract_Multi_Int_X5(A, B);
        Neg    := uBoolTrue;
      end
      else
      begin
        Result := subtract_Multi_Int_X5(B, A);
        Neg    := uBoolFalse;
      end;
    end
    else  (* if  not Negative_flag then  *)
    begin
      if ABS_greaterthan_Multi_Int_X5(B, A) then
      begin
        Result := subtract_Multi_Int_X5(B, A);
        Neg    := uBoolTrue;
      end
      else
      begin
        Result := subtract_Multi_Int_X5(A, B);
        Neg    := uBoolFalse;
      end;
    end;
  end
  else (* A.Negative_flag <> B.Negative_flag *)
  if (B.Negative_flag = True) then
  begin
    Result := add_Multi_Int_X5(A, B);
    Neg    := uBoolFalse;
  end
  else
  begin
    Result := add_Multi_Int_X5(A, B);
    Neg    := uBoolTrue;
  end;

  if (Result.Overflow_flag = True) then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
  end;

  if (Result.Negative_flag = uBoolUndefined) then
    Result.Negative_flag := Neg;
end;


{
******************************************
TMultiIntXV
******************************************
}

(******************************************)
procedure TMultiIntXV.Initialize;
begin
  Self.FIsDefined := False;
  if (not Multi_Init_Initialisation_done) then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Multi_Init_Initialisation has not been called');
    exit;
  end;

  setlength(Self.FParts, Multi_XV_size);
  Self.FPartsSize   := Multi_XV_size;
  Self.FIsNegative  := uBoolFalse;
  Self.FHasOverflow := False;
  Self.FIsDefined   := False;
end;


(********************v3********************)
procedure Multi_Int_Reset_XV_Size(var A: TMultiIntXV; const S: INT_2W_U);
begin
  if (S < 2) then
  begin
    MultiIntError  := True;
    A.FHasOverflow := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Multi_Int_XV Size must be > 1');
    exit;
  end;
  if (S > (Multi_XV_limit)) then
  begin
    MultiIntError  := True;
    A.FHasOverflow := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    exit;
  end;

  setlength(A.FParts, S);
  A.FPartsSize := S;
end;


(******************************************)
procedure Multi_Int_Set_XV_Limit(const S: INT_2W_U);
begin
  if (S >= Multi_XV_size) then
    Multi_XV_limit := S
  else
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Multi_XV_limit must be >= Multi_XV_size');
    exit;
  end;
end;


(******************************************)
procedure Multi_Int_XV_to_Multi_Int_XV(const A: TMultiIntXV; var MI: TMultiIntXV);
var
  n: INT_1W_U;
begin
  MI.Initialize;

  if (A.FIsDefined = False) then
  begin
    MultiIntError := True;
    MI.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FHasOverflow = True) then
  begin
    MultiIntError   := True;
    MI.FHasOverflow := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    exit;
  end;

  if (A.FPartsSize > mi.FPartsSize) then
  begin
    Multi_Int_Reset_XV_Size(MI, A.FPartsSize);
    if (mi.HasOverflow) then
    begin
      MultiIntError := True;
      mi.FIsDefined := False;
      if MultiIntEnableExceptions then
        raise EInterror.Create('Overflow');
      exit;
    end;
  end;

  MI.FHasOverflow := A.FHasOverflow;
  MI.FIsDefined   := A.FIsDefined;
  MI.FIsNegative  := A.FIsNegative;

  n := 0;
  while (n < A.FPartsSize) do
  begin
    MI.FParts[n] := A.FParts[n];
    Inc(n);
  end;

  while (n < MI.FPartsSize) do
  begin
    MI.FParts[n] := 0;
    Inc(n);
  end;
end;


(******************************************)
function ABS_greaterthan_Multi_Int_XV(const A, B: TMultiIntXV): boolean;
var
  i1, i2: INT_2W_S;
begin
  i1 := (A.FPartsSize - 1);
  i2 := (B.FPartsSize - 1);

  while (i1 > i2) do
  begin
    if (A.FParts[i1] > 0) then
    begin
      Result := True;
      exit;
    end;
    Dec(i1);
  end;

  while (i2 > i1) do
  begin
    if (B.FParts[i2] > 0) then
    begin
      Result := False;
      exit;
    end;
    Dec(i2);
  end;

  while (i2 > 0) do
  begin
    if (A.FParts[i2] > B.FParts[i2]) then
    begin
      Result := True;
      exit;
    end
    else
    if (A.FParts[i2] < B.FParts[i2]) then
    begin
      Result := False;
      exit;
    end;
    Dec(i2);
  end;

  if (A.FParts[0] > B.FParts[0]) then
  begin
    Result := True;
    exit;
  end
  else
  begin
    Result := False;
    exit;
  end;

end;


(******************************************)
function ABS_lessthan_Multi_Int_XV(const A, B: TMultiIntXV): boolean;
var
  i1, i2: INT_2W_S;
begin
  i1 := (A.FPartsSize - 1);
  i2 := (B.FPartsSize - 1);

  while (i1 > i2) do
  begin
    if (A.FParts[i1] > 0) then
    begin
      Result := False;
      exit;
    end;
    Dec(i1);
  end;

  while (i2 > i1) do
  begin
    if (B.FParts[i2] > 0) then
    begin
      Result := True;
      exit;
    end;
    Dec(i2);
  end;

  while (i2 > 0) do
  begin
    if (A.FParts[i2] > B.FParts[i2]) then
    begin
      Result := False;
      exit;
    end
    else
    if (A.FParts[i2] < B.FParts[i2]) then
    begin
      Result := True;
      exit;
    end;
    Dec(i2);
  end;

  if (A.FParts[0] < B.FParts[0]) then
  begin
    Result := True;
    exit;
  end
  else
  begin
    Result := False;
    exit;
  end;

end;


(******************************************)
function nlz_words_XV(const V: TMultiIntXV): INT_1W_U; // B
var
  i, n: TMultiInt32;
  fini: boolean;
begin
  n    := 0;
  i    := (V.FPartsSize - 1);
  fini := False;
  repeat
    if (i < 0) then
      fini := True
    else if (V.FParts[i] <> 0) then
      fini := True
    else
    begin
      Inc(n);
      Dec(i);
    end;
  until fini;
  Result := n;
end;


(******************************************)
function nlz_MultiBits_XV(const A: TMultiIntXV): INT_2W_U;
var
  w, R: INT_2W_U;
begin
  if not A.FIsDefined then
  begin
    Result := 0;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
  end;

  w := nlz_words_XV(A);
  if (w < A.FPartsSize) then
  begin
    R      := LeadingZeroCount(A.FParts[A.FPartsSize - w - 1]);
    R      := R + (w * INT_1W_SIZE);
    Result := R;
  end
  else
    Result := (w * INT_1W_SIZE);
end;


(******************************************)
function TMultiIntXV.HasOverflow: boolean; inline;
begin
  Result := Self.FHasOverflow;
end;


(******************************************)
function TMultiIntXV.IsDefined: boolean; inline;
begin
  Result := Self.FIsDefined;
end;


(******************************************)
function Overflow(const A: TMultiIntXV): boolean; overload; inline;
begin
  Result := A.FHasOverflow;
end;


(******************************************)
function Defined(const A: TMultiIntXV): boolean; overload; inline;
begin
  Result := A.FIsDefined;
end;


(******************************************)
function TMultiIntXV.IsNegative: boolean; inline;
begin
  Result := Self.FIsNegative;
end;


(******************************************)
function Negative(const A: TMultiIntXV): boolean; overload;
begin
  Result := A.FIsNegative;
end;


(******************************************)
function Abs(const A: TMultiIntXV): TMultiIntXV; overload;
begin
  Result := A;
  Result.FIsNegative := uBoolFalse;

  if not A.FIsDefined then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
  end;
end;


(******************************************)
function Multi_Int_XV_Odd(const A: TMultiIntXV): boolean; inline;
var
  bit1_mask: INT_1W_U;
begin

  bit1_mask := $1;

  if ((A.FParts[0] and bit1_mask) = bit1_mask) then
    Result := True
  else
    Result := False;

  if not A.FIsDefined then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
  end;

end;


(******************************************)
function Odd(const A: TMultiIntXV): boolean; overload;
begin
  Result := Multi_Int_XV_Odd(A);
end;


(******************************************)
function Multi_Int_XV_Even(const A: TMultiIntXV): boolean; inline;
var
  bit1_mask: INT_1W_U;
begin

  bit1_mask := $1;

  if ((A.FParts[0] and bit1_mask) = bit1_mask) then
    Result := False
  else
    Result := True;

  if not A.FIsDefined then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
  end;

end;


(******************************************)
function Even(const A: TMultiIntXV): boolean; overload;
begin
  Result := Multi_Int_XV_Even(A);
end;


(******************************************)
procedure ShiftUp_NBits_Multi_Int_XV(var A: TMultiIntXV; NBits: INT_2W_U);
var
  carry_bits_1, carry_bits_2, carry_bits_mask, NBits_max, NBits_carry: INT_1W_U;
  n: INT_1W_U;
{$ifdef CPU_32}
  procedure INT_1W_U_shl(var A: INT_1W_U; const nbits: INT_2W_U); inline;
  var
    carry_bits_mask_2w: INT_2W_U;
  begin
    carry_bits_mask_2w := A;
    carry_bits_mask_2w := (carry_bits_mask_2w << NBits);
    A := INT_1W_U(carry_bits_mask_2w and INT_1W_U_MAXINT);
  end;
  {$endif}
begin
  if NBits > 0 then
  begin

    {$ifdef CPU_32}
    carry_bits_mask := $FFFF;
    {$else}
    carry_bits_mask := $FFFFFFFF;
    {$endif}

    NBits_max   := INT_1W_SIZE;
    NBits_carry := (NBits_max - NBits);

    {$ifdef CPU_32}
    INT_1W_U_shl(carry_bits_mask, NBits_carry);
    {$else}
    carry_bits_mask := (carry_bits_mask << NBits_carry);
    {$endif}

    if NBits <= NBits_max then
    begin
      carry_bits_1 := ((A.FParts[0] and carry_bits_mask) shr NBits_carry);
      {$ifdef CPU_32}
      // A.M_Value[0]:= (A.M_Value[0] << NBits);
      INT_1W_U_shl(A.M_Value[0], NBits);
      {$else}
      A.FParts[0] := (A.FParts[0] << NBits);
      {$endif}

      n := 1;
      while (n < (A.FPartsSize - 1)) do
      begin
        carry_bits_2 := ((A.FParts[n] and carry_bits_mask) shr NBits_carry);

        {$ifdef CPU_32}
        // A.M_Value[n]:= ((A.M_Value[n] << NBits) OR carry_bits_1);
        INT_1W_U_shl(A.M_Value[n], NBits);
        A.M_Value[n] := (A.M_Value[n] or carry_bits_1);
        {$else}
        A.FParts[n] := ((A.FParts[n] << NBits) or carry_bits_1);
        {$endif}

        carry_bits_1 := carry_bits_2;
        Inc(n);
      end;

      A.FParts[n] := ((A.FParts[n] << NBits) or carry_bits_1);

    end;
  end;
end;


(******************************************)
procedure ShiftUp_NWords_Multi_Int_XV(var A: TMultiIntXV; NWords: INT_2W_U);
var
  n, i: INT_1W_U;
begin
  if (NWords > 0) then
    if (NWords < Multi_XV_size) then
    begin
      n := NWords;
      while (n > 0) do
      begin
        i := Multi_XV_maxi;
        while (i > 0) do
        begin
          A.FParts[i] := A.FParts[i - 1];
          Dec(i);
        end;
        A.FParts[i] := 0;
        Dec(n);
      end;
    end
    else
    begin
      n := Multi_XV_maxi;
      while (n > 0) do
      begin
        A.FParts[n] := 0;
        Dec(n);
      end;
    end;
end;


{******************************************}
procedure ShiftUp_MultiBits_Multi_Int_XV(var A: TMultiIntXV; NBits: INT_2W_U);
var
  NWords_count, NBits_count: INT_1W_U;
begin
  if not A.FIsDefined then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (NBits > 0) then
  begin
    if (NBits >= INT_1W_SIZE) then
    begin
      NWords_count := (NBits div INT_1W_SIZE);
      NBits_count  := (NBits mod INT_1W_SIZE);
      ShiftUp_NWords_Multi_Int_XV(A, NWords_count);
    end
    else
      NBits_count := NBits;
    ShiftUp_NBits_Multi_Int_XV(A, NBits_count);
  end;
end;


{******************************************}
class operator TMultiIntXV.shl(const A: TMultiIntXV;
  const NBits: INT_2W_U): TMultiIntXV;
begin
  // Result:= A;                // this causes problems in calling code
  Multi_Int_XV_to_Multi_Int_XV(A, Result);
  // if not done, causes problems in calling code
  ShiftUp_MultiBits_Multi_Int_XV(Result, NBits);
end;


(******************************************)
procedure ShiftDown_NBits_Multi_Int_XV(var A: TMultiIntXV; NBits: INT_2W_U);
var
  carry_bits_1, carry_bits_2, carry_bits_mask, NBits_max, NBits_carry: INT_1W_U;
  n: integer;
begin
  if NBits > 0 then
  begin

    {$ifdef CPU_32}
    carry_bits_mask := $FFFF;
    {$endif}
    {$ifdef CPU_64}
        carry_bits_mask:= $FFFFFFFF;
    {$endif}

    NBits_max   := INT_1W_SIZE;
    NBits_carry := (NBits_max - NBits);
    carry_bits_mask := (carry_bits_mask shr NBits_carry);

    if NBits <= NBits_max then
    begin
      n := (A.FPartsSize - 1);
      carry_bits_1 := ((A.FParts[n] and carry_bits_mask) << NBits_carry);
      A.FParts[n] := (A.FParts[n] shr NBits);

      Dec(n);
      while (n > 0) do
      begin
        carry_bits_2 := ((A.FParts[n] and carry_bits_mask) << NBits_carry);
        A.FParts[n]  := ((A.FParts[n] shr NBits) or carry_bits_1);
        carry_bits_1 := carry_bits_2;
        Dec(n);
      end;

      A.FParts[n] := ((A.FParts[n] shr NBits) or carry_bits_1);
    end;
  end;
end;


(******************************************)
procedure ShiftDown_NWords_Multi_Int_XV(var A: TMultiIntXV; NWords: INT_2W_U);
var
  n, i: INT_1W_U;
begin

  if (NWords > 0) then
    if (NWords < Multi_XV_size) then
    begin
      n := NWords;
      while (n > 0) do
      begin
        i := 0;
        while (i < Multi_XV_maxi) do
        begin
          A.FParts[i] := A.FParts[i + 1];
          Inc(i);
        end;
        A.FParts[i] := 0;
        Dec(n);
      end;
    end
    else
    begin
      n := Multi_XV_maxi;
      while (n > 0) do
      begin
        A.FParts[n] := 0;
        Dec(n);
      end;
    end;

end;


{******************************************}
procedure ShiftDown_MultiBits_Multi_Int_XV(var A: TMultiIntXV; NBits: INT_2W_U);
var
  NWords_count, NBits_count: INT_1W_U;
begin
  if not A.FIsDefined then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (NBits >= INT_1W_SIZE) then
  begin
    NWords_count := (NBits div INT_1W_SIZE);
    NBits_count  := (NBits mod INT_1W_SIZE);
    ShiftDown_NWords_Multi_Int_XV(A, NWords_count);
  end
  else
    NBits_count := NBits;

  ShiftDown_NBits_Multi_Int_XV(A, NBits_count);
end;


{******************************************}
class operator TMultiIntXV.shr(const A: TMultiIntXV;
  const NBits: INT_2W_U): TMultiIntXV;
begin
  // Result:= A;                // this causes problems in calling code
  Multi_Int_XV_to_Multi_Int_XV(A, Result);
  // if not done, causes problems in calling code
  ShiftDown_MultiBits_Multi_Int_XV(Result, NBits);
end;


(******************************************)
class operator TMultiIntXV.>(const A, B: TMultiIntXV): boolean;
begin
  if not A.FIsDefined or (not B.FIsDefined) or (A.FHasOverflow) or
    (B.FHasOverflow) then
  begin
    Result := False;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  Result := False;
  if ((A.FIsNegative = False) and (B.FIsNegative = True)) then
    Result := True
  else
  if ((A.FIsNegative = True) and (B.FIsNegative = False)) then
    Result := False
  else
  if ((A.FIsNegative = False) and (B.FIsNegative = False)) then
    Result := ABS_greaterthan_Multi_Int_XV(A, B)
  else
  if ((A.FIsNegative = True) and (B.FIsNegative = True)) then
    Result := ABS_lessthan_Multi_Int_XV(A, B);
end;


(******************************************)
class operator TMultiIntXV.<(const A, B: TMultiIntXV): boolean;
begin
  if not A.FIsDefined or (not B.FIsDefined) or (A.FHasOverflow) or
    (B.FHasOverflow) then
  begin
    Result := False;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  Result := False;
  if ((A.FIsNegative = True) and (B.FIsNegative = False)) then
    Result := True
  else
  if ((A.FIsNegative = False) and (B.FIsNegative = False)) then
    Result := ABS_lessthan_Multi_Int_XV(A, B)
  else
  if ((A.FIsNegative = True) and (B.FIsNegative = True)) then
    Result := ABS_greaterthan_Multi_Int_XV(A, B);
end;


(******************************************)
function ABS_equal_Multi_Int_XV(const A, B: TMultiIntXV): boolean;
var
  i1, i2: INT_2W_S;
begin
  Result := True;
  i1     := (A.FPartsSize - 1);
  i2     := (B.FPartsSize - 1);
  while (i1 > i2) do
  begin
    if (A.FParts[i1] > 0) then
    begin
      Result := False;
      exit;
    end;
    Dec(i1);
  end;
  while (i2 > i1) do
  begin
    if (B.FParts[i2] > 0) then
    begin
      Result := False;
      exit;
    end;
    Dec(i2);
  end;
  while (i2 >= 0) do
  begin
    if (A.FParts[i2] <> B.FParts[i2]) then
    begin
      Result := False;
      exit;
    end;
    Dec(i2);
  end;
end;


(******************************************)
function ABS_notequal_Multi_Int_XV(const A, B: TMultiIntXV): boolean; inline;
begin
  Result := (not ABS_equal_Multi_Int_XV(A, B));
end;


(******************************************)
class operator TMultiIntXV.=(const A, B: TMultiIntXV): boolean;
begin
  if not A.FIsDefined or (not B.FIsDefined) or (A.FHasOverflow) or
    (B.FHasOverflow) then
  begin
    Result := False;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  Result := True;
  if (A.FIsNegative <> B.FIsNegative) then
    Result := False
  else
    Result := ABS_equal_Multi_Int_XV(A, B);
end;


(******************************************)
class operator TMultiIntXV.<>(const A, B: TMultiIntXV): boolean;
begin
  if not A.FIsDefined or (not B.FIsDefined) or (A.FHasOverflow) or
    (B.FHasOverflow) then
  begin
    Result := False;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  Result := False;
  if (A.FIsNegative <> B.FIsNegative) then
    Result := True
  else
    Result := (not ABS_equal_Multi_Int_XV(A, B));
end;


(******************************************)
class operator TMultiIntXV.<=(const A, B: TMultiIntXV): boolean;
begin
  if not A.FIsDefined or (not B.FIsDefined) or (A.FHasOverflow) or
    (B.FHasOverflow) then
  begin
    Result := False;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  Result := False;
  if ((A.FIsNegative = False) and (B.FIsNegative = True)) then
    Result := False
  else
  if ((A.FIsNegative = True) and (B.FIsNegative = False)) then
    Result := True
  else
  if ((A.FIsNegative = False) and (B.FIsNegative = False)) then
    Result := (not ABS_greaterthan_Multi_Int_XV(A, B))
  else
  if ((A.FIsNegative = True) and (B.FIsNegative = True)) then
    Result := (not ABS_lessthan_Multi_Int_XV(A, B));
end;


(******************************************)
class operator TMultiIntXV.>=(const A, B: TMultiIntXV): boolean;
begin
  if not A.FIsDefined or (not B.FIsDefined) or (A.FHasOverflow) or
    (B.FHasOverflow) then
  begin
    Result := False;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  Result := False;
  if ((A.FIsNegative = False) and (B.FIsNegative = True)) then
    Result := True
  else
  if ((A.FIsNegative = True) and (B.FIsNegative = False)) then
    Result := False
  else
  if ((A.FIsNegative = False) and (B.FIsNegative = False)) then
    Result := (not ABS_lessthan_Multi_Int_XV(A, B))
  else
  if ((A.FIsNegative = True) and (B.FIsNegative = True)) then
    Result := (not ABS_greaterthan_Multi_Int_XV(A, B));
end;


(******************************************)
procedure String_to_Multi_Int_XV(const A: ansistring; out mi: TMultiIntXV); inline;
label
  999;
var
  n, i, b, c, e, s: INT_2W_U;
  M_Val: array of INT_2W_U;
  Signeg, Zeroneg, M_Val_All_Zero: boolean;
begin
  MultiIntError := False;

  s := Multi_XV_size;
  setlength(M_Val, s);

  mi.Initialize;
  mi.FHasOverflow := False;
  mi.FIsDefined := True;
  mi.FIsNegative := False;
  Signeg  := False;
  Zeroneg := False;

  n := 0;
  while (n < s) do
  begin
    M_Val[n] := 0;
    Inc(n);
  end;

  if (length(A) > 0) then
  begin
    b := low(ansistring);
    e := b + INT_2W_U(length(A)) - 1;
    if (A[b] = '-') then
    begin
      Signeg := True;
      Inc(b);
    end;

    c := b;
    while (c <= e) do
    begin
      try
        i := StrToInt(A[c]);
      except
        on EConvertError do
        begin
          mi.FIsDefined   := False;
          mi.FHasOverflow := True;
          MultiIntError   := True;
          if MultiIntEnableExceptions then
            raise;
        end;
      end;
      if mi.FIsDefined = False then
        goto 999;

      M_Val[0] := (M_Val[0] * 10) + i;
      n := 1;
      while (n < s) do
      begin
        M_Val[n] := (M_Val[n] * 10);
        Inc(n);
      end;

      n := 0;
      while (n < (s - 1)) do
      begin
        if M_Val[n] > INT_1W_U_MAXINT then
        begin
          M_Val[n + 1] := M_Val[n + 1] + (M_Val[n] div INT_1W_U_MAXINT_1);
          M_Val[n]     := (M_Val[n] mod INT_1W_U_MAXINT_1);
        end;

        Inc(n);
      end;

      if M_Val[n] > INT_1W_U_MAXINT then
      begin
        Inc(s);
        setlength(M_Val, s);
        M_Val[n + 1] := M_Val[n + 1] + (M_Val[n] div INT_1W_U_MAXINT_1);
        M_Val[n]     := (M_Val[n] mod INT_1W_U_MAXINT_1);
      end;
      Inc(c);
    end;
  end;

  if (s > Multi_XV_size) then
  begin
    Multi_Int_Reset_XV_Size(MI, s);
    if (mi.HasOverflow) then
    begin
      mi.FIsDefined := False;
      MultiIntError := True;
      if MultiIntEnableExceptions then
        raise EInterror.Create('Overflow');
      goto 999;
    end;
  end;

  M_Val_All_Zero := True;
  n := 0;
  while (n < s) do
  begin
    mi.FParts[n] := M_Val[n];
    if M_Val[n] > 0 then
      M_Val_All_Zero := False;
    Inc(n);
  end;

  if M_Val_All_Zero then
    Zeroneg := True;

  if Zeroneg then
    mi.FIsNegative := uBoolFalse
  else if Signeg then
    mi.FIsNegative := uBoolTrue
  else
    mi.FIsNegative := uBoolFalse;

  999: ;
end;


(******************************************)
class operator TMultiIntXV.:=(const A: ansistring): TMultiIntXV;
begin
  String_to_Multi_Int_XV(A, Result);
end;


(******************************************)
procedure Multi_Int_XV_to_String(const A: TMultiIntXV; var B: ansistring); inline;
var
  s: ansistring = '';
  M_Val: array of INT_2W_U;
  n, t: INT_2W_U;
  M_Val_All_Zero: boolean;
begin
  if not A.FIsDefined then
  begin
    B := 'UNDEFINED';
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow) then
  begin
    B := 'OVERFLOW';
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    exit;
  end;

  setlength(M_Val, A.FPartsSize);

  n := 0;
  while (n < A.FPartsSize) do
  begin
    t := A.FParts[n];
    M_Val[n] := t;
    Inc(n);
  end;

  repeat
    n := (A.FPartsSize - 1);
    M_Val_All_Zero := True;
    repeat
      M_Val[n - 1] := M_Val[n - 1] + (INT_1W_U_MAXINT_1 * (M_Val[n] mod 10));
      M_Val[n]     := (M_Val[n] div 10);
      if M_Val[n] <> 0 then
        M_Val_All_Zero := False;
      Dec(n);
    until (n = 0);

    s := IntToStr(M_Val[0] mod 10) + s;
    M_Val[0] := (M_Val[0] div 10);
    if M_Val[0] <> 0 then
      M_Val_All_Zero := False;

  until M_Val_All_Zero;

  if (A.FIsNegative = uBoolTrue) then
    s := '-' + s;
  B   := s;
end;


(******************************************)
function TMultiIntXV.ToString: ansistring;
begin
  Multi_Int_XV_to_String(Self, Result);
end;


(******************************************)
class operator TMultiIntXV.:=(const A: TMultiIntXV): ansistring;
begin
  Multi_Int_XV_to_String(A, Result);
end;


(******************************************)
procedure hex_to_Multi_Int_XV(const A: ansistring; out mi: TMultiIntXV); inline;
label
  999;
var
  n, i, b, c, e, s: INT_2W_U;
  M_Val: array of INT_2W_U;
  Signeg, Zeroneg, M_Val_All_Zero: boolean;
begin
  MultiIntError := False;
  s := Multi_XV_size;
  setlength(M_Val, s);

  mi.Initialize;
  mi.FHasOverflow := False;
  mi.FIsDefined := True;
  mi.FIsNegative := False;
  Signeg  := False;
  Zeroneg := False;

  n := 0;
  while (n < s) do
  begin
    M_Val[n] := 0;
    Inc(n);
  end;

  if (length(A) > 0) then
  begin
    b := low(ansistring);
    e := b + INT_2W_U(length(A)) - 1;
    if (A[b] = '-') then
    begin
      Signeg := True;
      Inc(b);
    end;

    c := b;
    while (c <= e) do
    begin
      try
        i := Hex2Dec(A[c]);
      except
        MultiIntError   := True;
        mi.FHasOverflow := True;
        mi.FIsDefined   := False;
        if MultiIntEnableExceptions then
          raise;
      end;
      if mi.FIsDefined = False then
        goto 999;

      M_Val[0] := (M_Val[0] * 16) + i;
      n := 1;
      while (n < s) do
      begin
        M_Val[n] := (M_Val[n] * 16);
        Inc(n);
      end;

      n := 0;
      while (n < (s - 1)) do
      begin
        if M_Val[n] > INT_1W_U_MAXINT then
        begin
          M_Val[n + 1] := M_Val[n + 1] + (M_Val[n] div INT_1W_U_MAXINT_1);
          M_Val[n]     := (M_Val[n] mod INT_1W_U_MAXINT_1);
        end;

        Inc(n);
      end;

      if M_Val[n] > INT_1W_U_MAXINT then
      begin
        Inc(s);
        setlength(M_Val, s);
        M_Val[n + 1] := M_Val[n + 1] + (M_Val[n] div INT_1W_U_MAXINT_1);
        M_Val[n]     := (M_Val[n] mod INT_1W_U_MAXINT_1);
      end;

      Inc(c);
    end;
  end;

  if (s > Multi_XV_size) then
  begin
    Multi_Int_Reset_XV_Size(MI, s);
    if (mi.HasOverflow) then
    begin
      mi.FIsDefined := False;
      MultiIntError := True;
      if MultiIntEnableExceptions then
        raise EInterror.Create('Overflow');
      goto 999;
    end;
  end;

  M_Val_All_Zero := True;
  n := 0;
  while (n < s) do
  begin
    mi.FParts[n] := M_Val[n];
    if M_Val[n] > 0 then
      M_Val_All_Zero := False;
    Inc(n);
  end;
  if M_Val_All_Zero then
    Zeroneg := True;

  if Zeroneg then
    mi.FIsNegative := uBoolFalse
  else if Signeg then
    mi.FIsNegative := uBoolTrue
  else
    mi.FIsNegative := uBoolFalse;

  999: ;
end;


(******************************************)
function TMultiIntXV.FromHexString(const A: ansistring): TMultiIntXV;
begin
  hex_to_Multi_Int_XV(A, Result);
end;


(******************************************)
procedure FromHex(const A: ansistring; out B: TMultiIntXV); overload;
begin
  hex_to_Multi_Int_XV(A, B);
end;


(******************************************)
procedure Multi_Int_XV_to_hex(const A: TMultiIntXV; var B: ansistring;
  LeadingZeroMode: TMultiLeadingZeros); inline;
var
  s: ansistring = '';
  i, n: INT_1W_S;
begin
  if not A.FIsDefined then
  begin
    B := 'UNDEFINED';
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow) then
  begin
    B := 'OVERFLOW';
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    exit;
  end;

  // The "4" here looks suspicious, but it is not!
  // It is the size in bits of a nibble (half-byte).

  n := (INT_1W_SIZE div 4);
  s := '';

  i := (A.FPartsSize - 1);
  while (i >= 0) do
  begin
    s := s + IntToHex(A.FParts[i], n);
    Dec(i);
  end;

  if (LeadingZeroMode = TrimLeadingZeros) then
    RemoveLeadingChars(s, ['0']);
  if (A.FIsNegative = uBoolTrue) then
    s := '-' + s;
  if (s = '') then
    s := '0';
  B   := s;
end;


(******************************************)
function TMultiIntXV.ToHexString(const LeadingZeroMode: TMultiLeadingZeros): ansistring;
begin
  Multi_Int_XV_to_hex(Self, Result, LeadingZeroMode);
end;


(******************************************)
procedure Bin_to_Multi_Int_XV(const A: ansistring; out mi: TMultiIntXV); inline;
label
  999;
var
  n, b, c, e, s: INT_2W_U;
  bit: INT_1W_S;
  M_Val: array of INT_2W_U;
  Signeg, Zeroneg, M_Val_All_Zero: boolean;
begin
  MultiIntError := False;
  s := Multi_XV_size;
  setlength(M_Val, s);

  mi.Initialize;
  mi.FHasOverflow := False;
  mi.FIsDefined := True;
  mi.FIsNegative := False;
  Signeg  := False;
  Zeroneg := False;

  n := 0;
  while (n < s) do
  begin
    M_Val[n] := 0;
    Inc(n);
  end;

  if (length(A) > 0) then
  begin
    b := low(ansistring);
    e := b + INT_2W_U(length(A)) - 1;
    if (A[b] = '-') then
    begin
      Signeg := True;
      Inc(b);
    end;

    c := b;
    while (c <= e) do
    begin
      bit := (Ord(A[c]) - Ord('0'));
      if (bit > 1) or (bit < 0) then
      begin
        MultiIntError   := True;
        mi.FHasOverflow := True;
        mi.FIsDefined   := False;
        if MultiIntEnableExceptions then
          raise EInterror.Create('Invalid binary digit');
        goto 999;
      end;

      M_Val[0] := (M_Val[0] * 2) + bit;
      n := 1;
      while (n < s) do
      begin
        M_Val[n] := (M_Val[n] * 2);
        Inc(n);
      end;

      n := 0;
      while (n < (s - 1)) do
      begin
        if M_Val[n] > INT_1W_U_MAXINT then
        begin
          M_Val[n + 1] := M_Val[n + 1] + (M_Val[n] div INT_1W_U_MAXINT_1);
          M_Val[n]     := (M_Val[n] mod INT_1W_U_MAXINT_1);
        end;

        Inc(n);
      end;

      if M_Val[n] > INT_1W_U_MAXINT then
      begin
        Inc(s);
        setlength(M_Val, s);
        M_Val[n + 1] := M_Val[n + 1] + (M_Val[n] div INT_1W_U_MAXINT_1);
        M_Val[n]     := (M_Val[n] mod INT_1W_U_MAXINT_1);
      end;

      Inc(c);
    end;
  end;

  if (s > Multi_XV_size) then
  begin
    Multi_Int_Reset_XV_Size(MI, s);
    if (mi.HasOverflow) then
    begin
      mi.FIsDefined := False;
      MultiIntError := True;
      if MultiIntEnableExceptions then
        raise EInterror.Create('Overflow');
      goto 999;
    end;
  end;

  M_Val_All_Zero := True;
  n := 0;
  while (n < s) do
  begin
    mi.FParts[n] := M_Val[n];
    if M_Val[n] > 0 then
      M_Val_All_Zero := False;
    Inc(n);
  end;
  if M_Val_All_Zero then
    Zeroneg := True;

  if Zeroneg then
    mi.FIsNegative := uBoolFalse
  else if Signeg then
    mi.FIsNegative := uBoolTrue
  else
    mi.FIsNegative := uBoolFalse;

  999: ;
end;


(******************************************)
procedure FromBin(const A: ansistring; out mi: TMultiIntXV); overload;
begin
  Bin_to_Multi_Int_XV(A, mi);
end;


(******************************************)
function TMultiIntXV.FromBinaryString(const A: ansistring): TMultiIntXV;
begin
  bin_to_Multi_Int_XV(A, Result);
end;


(******************************************)
procedure Multi_Int_XV_to_bin(const A: TMultiIntXV; var B: ansistring;
  LeadingZeroMode: TMultiLeadingZeros); inline;
var
  s: ansistring = '';
  i, n: INT_1W_S;
begin
  if not A.FIsDefined then
  begin
    B := 'UNDEFINED';
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow) then
  begin
    B := 'OVERFLOW';
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    exit;
  end;

  n := INT_1W_SIZE;
  s := '';

  i := (A.FPartsSize - 1);
  while (i >= 0) do
  begin
    s := s + IntToBin(A.FParts[i], n);
    Dec(i);
  end;

  if (LeadingZeroMode = TrimLeadingZeros) then
    RemoveLeadingChars(s, ['0']);
  if (A.FIsNegative = uBoolTrue) then
    s := '-' + s;
  if (s = '') then
    s := '0';
  B   := s;
end;


(******************************************)
function TMultiIntXV.ToBinaryString(const LeadingZeroMode: TMultiLeadingZeros):
ansistring;
begin
  Multi_Int_XV_to_bin(Self, Result, LeadingZeroMode);
end;


(******************************************)
procedure INT_2W_S_to_Multi_Int_XV(const A: INT_2W_S; out mi: TMultiIntXV); inline;
var
  n: INT_2W_U;
begin
  mi.Initialize;
  mi.FHasOverflow := False;
  mi.FIsDefined   := True;

  n := 2;
  while (n <= Multi_XV_maxi) do
  begin
    mi.FParts[n] := 0;
    Inc(n);
  end;

  if (A < 0) then
  begin
    mi.FIsNegative := uBoolTrue;
    mi.FParts[0]   := (ABS(A) mod INT_1W_U_MAXINT_1);
    mi.FParts[1]   := (ABS(A) div INT_1W_U_MAXINT_1);
  end
  else
  begin
    mi.FIsNegative := uBoolFalse;
    mi.FParts[0]   := (A mod INT_1W_U_MAXINT_1);
    mi.FParts[1]   := (A div INT_1W_U_MAXINT_1);
  end;
end;


(******************************************)
class operator TMultiIntXV.:=(const A: INT_2W_S): TMultiIntXV;
begin
  INT_2W_S_to_Multi_Int_XV(A, Result);
end;


(******************************************)
procedure INT_2W_U_to_Multi_Int_XV(const A: INT_2W_U; out mi: TMultiIntXV); inline;
var
  n: INT_2W_U;
begin
  mi.Initialize;
  mi.FHasOverflow := False;
  mi.FIsDefined   := True;
  mi.FIsNegative  := uBoolFalse;

  mi.FParts[0] := (A mod INT_1W_U_MAXINT_1);
  mi.FParts[1] := (A div INT_1W_U_MAXINT_1);

  n := 2;
  while (n <= Multi_XV_maxi) do
  begin
    mi.FParts[n] := 0;
    Inc(n);
  end;
end;


(******************************************)
class operator TMultiIntXV.:=(const A: INT_2W_U): TMultiIntXV;
begin
  INT_2W_U_to_Multi_Int_XV(A, Result);
end;


{$ifdef CPU_32}
// The fact that thse routines only exist in 32bit mode looks suspicious.
// But it is not! These are dealing with 64bit integers in 32bit mode, which are 4 words in size)
// 4 word integers do not exist in 64bit mode

(******************************************)
procedure INT_4W_S_to_Multi_Int_XV(const A: INT_4W_S; var mi: TMultiIntXV); inline;
var
  v: INT_4W_U;
  n: INT_2W_U;
begin
  mi.init;
  if (mi.M_Value_Size < 4) then
  begin
    Multi_Int_Reset_XV_Size(MI, 4);
    if (mi.Overflow) then
    begin
      mi.Defined_flag := False;
      Multi_Int_ERROR := True;
      if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
        raise EInterror.Create('Overflow');
      exit;
    end;
  end;
  mi.Overflow_flag := False;
  mi.Defined_flag  := True;

  v := Abs(A);
  mi.M_Value[0] := INT_1W_U(v mod INT_1W_U_MAXINT_1);
  v := (v div INT_1W_U_MAXINT_1);
  mi.M_Value[1] := INT_1W_U(v mod INT_1W_U_MAXINT_1);
  v := (v div INT_1W_U_MAXINT_1);
  mi.M_Value[2] := INT_1W_U(v mod INT_1W_U_MAXINT_1);
  v := (v div INT_1W_U_MAXINT_1);
  mi.M_Value[3] := v;

  n := 4;
  while (n <= Multi_XV_maxi) do
  begin
    mi.M_Value[n] := 0;
    Inc(n);
  end;

  if (A < 0) then
    mi.Negative_flag := uBoolTrue
  else
    mi.Negative_flag := uBoolFalse;
end;


(******************************************)
class operator TMultiIntXV.:=(const A: INT_4W_S): TMultiIntXV;
begin
  INT_4W_S_to_Multi_Int_XV(A, Result);
end;


(******************************************)
procedure INT_4W_U_to_Multi_Int_XV(const A: INT_4W_U; var mi: TMultiIntXV); inline;
var
  v: INT_4W_U;
  n: INT_2W_U;
begin
  mi.init;

  if (mi.M_Value_Size < 4) then
  begin
    Multi_Int_Reset_XV_Size(MI, 4);
    if (mi.Overflow) then
    begin
      mi.Defined_flag := False;
      Multi_Int_ERROR := True;
      if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
        raise EInterror.Create('Overflow');
      exit;
    end;
  end;
  mi.Overflow_flag := False;
  mi.Defined_flag  := True;
  mi.Negative_flag := uBoolFalse;

  v := A;
  mi.M_Value[0] := INT_1W_U(v mod INT_1W_U_MAXINT_1);
  v := (v div INT_1W_U_MAXINT_1);
  mi.M_Value[1] := INT_1W_U(v mod INT_1W_U_MAXINT_1);
  v := (v div INT_1W_U_MAXINT_1);
  mi.M_Value[2] := INT_1W_U(v mod INT_1W_U_MAXINT_1);
  v := (v div INT_1W_U_MAXINT_1);
  mi.M_Value[3] := v;

  n := 4;
  while (n <= Multi_XV_maxi) do
  begin
    mi.M_Value[n] := 0;
    Inc(n);
  end;
end;


(******************************************)
class operator TMultiIntXV.:=(const A: INT_4W_U): TMultiIntXV;
begin
  INT_4W_U_to_Multi_Int_XV(A, Result);
end;
{$endif}


(******************************************)
procedure Multi_Int_X4_to_Multi_Int_XV(const A: TMultiIntX4;
  var MI: TMultiIntXV); inline;
label
  OVERFLOW_BRANCH, CLEAN_EXIT;
var
  n: INT_1W_U;
begin
  MI.Initialize;

  if (A.FIsDefined = False) then
  begin
    MultiIntError := True;
    MI.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FHasOverflow = True) then
    goto OVERFLOW_BRANCH;

  MI.FHasOverflow := A.FHasOverflow;
  MI.FIsDefined   := A.FIsDefined;
  MI.FIsNegative  := A.FIsNegative;

  n := 0;
  if (MI.FPartsSize < Multi_X4_size) then
  begin
    Multi_Int_Reset_XV_Size(MI, Multi_X4_size);
    if (MI.HasOverflow) then
      goto OVERFLOW_BRANCH;
  end;

  while (n <= Multi_X4_maxi) do
  begin
    MI.FParts[n] := A.FParts[n];
    Inc(n);
  end;
  while (n <= Multi_XV_maxi) do
  begin
    MI.FParts[n] := 0;
    Inc(n);
  end;

  goto CLEAN_EXIT;

  OVERFLOW_BRANCH:

    MultiIntError := True;
  MI.FHasOverflow := True;
  if MultiIntEnableExceptions then
    raise EInterror.Create('Overflow');
  exit;

  CLEAN_EXIT: ;

end;


(******************************************)
class operator TMultiIntXV.:=(const A: TMultiIntX4): TMultiIntXV;
begin
  Multi_Int_X4_to_Multi_Int_XV(A, Result);
end;


(******************************************)
function To_Multi_Int_XV(const A: TMultiIntX4): TMultiIntXV;
begin
  Multi_Int_X4_to_Multi_Int_XV(A, Result);
end;


(******************************************)
procedure Multi_Int_X3_to_Multi_Int_XV(const A: TMultiIntX3;
  var MI: TMultiIntXV); inline;
label
  OVERFLOW_BRANCH, CLEAN_EXIT;
var
  n: INT_1W_U;
begin
  MI.Initialize;

  if (A.FIsDefined = False) then
  begin
    MultiIntError := True;
    MI.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FHasOverflow = True) then
    goto OVERFLOW_BRANCH;

  MI.FHasOverflow := A.FHasOverflow;
  MI.FIsDefined   := A.FIsDefined;
  MI.FIsNegative  := A.FIsNegative;

  n := 0;
  if (MI.FPartsSize < Multi_X3_size) then
  begin
    Multi_Int_Reset_XV_Size(MI, Multi_X3_size);
    if (MI.HasOverflow) then
      goto OVERFLOW_BRANCH;
  end;

  while (n <= Multi_X3_maxi) do
  begin
    MI.FParts[n] := A.FParts[n];
    Inc(n);
  end;
  while (n <= Multi_XV_maxi) do
  begin
    MI.FParts[n] := 0;
    Inc(n);
  end;

  goto CLEAN_EXIT;

  OVERFLOW_BRANCH:

    MultiIntError := True;
  MI.FHasOverflow := True;
  if MultiIntEnableExceptions then
    raise EInterror.Create('Overflow');
  exit;

  CLEAN_EXIT: ;

end;


(******************************************)
class operator TMultiIntXV.:=(const A: TMultiIntX3): TMultiIntXV;
begin
  Multi_Int_X3_to_Multi_Int_XV(A, Result);
end;


(******************************************)
function To_Multi_Int_XV(const A: TMultiIntX3): TMultiIntXV;
begin
  Multi_Int_X3_to_Multi_Int_XV(A, Result);
end;


(******************************************)
procedure Multi_Int_X2_to_Multi_Int_XV(const A: TMultiIntX2;
  var MI: TMultiIntXV); inline;
label
  OVERFLOW_BRANCH, CLEAN_EXIT;
var
  n: INT_1W_U;
begin
  MI.Initialize;

  if (A.FIsDefined = False) then
  begin
    MultiIntError := True;
    MI.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  if (A.FHasOverflow = True) then
    goto OVERFLOW_BRANCH;

  MI.FHasOverflow := A.FHasOverflow;
  MI.FIsDefined   := A.FIsDefined;
  MI.FIsNegative  := A.FIsNegative;

  n := 0;
  if (MI.FPartsSize < Multi_X2_size) then
  begin
    Multi_Int_Reset_XV_Size(MI, Multi_X2_size);
    if (MI.HasOverflow) then
      goto OVERFLOW_BRANCH;
  end;

  while (n <= Multi_X2_maxi) do
  begin
    MI.FParts[n] := A.FParts[n];
    Inc(n);
  end;
  while (n <= Multi_XV_maxi) do
  begin
    MI.FParts[n] := 0;
    Inc(n);
  end;

  goto CLEAN_EXIT;

  OVERFLOW_BRANCH:

    MultiIntError := True;
  MI.FHasOverflow := True;
  if MultiIntEnableExceptions then
    raise EInterror.Create('Overflow');
  exit;

  CLEAN_EXIT: ;

end;


(******************************************)
class operator TMultiIntXV.:=(const A: TMultiIntX2): TMultiIntXV;
begin
  Multi_Int_X2_to_Multi_Int_XV(A, Result);
end;


(******************************************)
function To_Multi_Int_XV(const A: TMultiIntX2): TMultiIntXV;
begin
  Multi_Int_X2_to_Multi_Int_XV(A, Result);
end;


(******************************************)
class operator TMultiIntXV.:=(const A: TMultiIntXV): single;
var
  R, V, M: single;
  i: INT_1W_U;
  finished: boolean;
begin
  if not A.FIsDefined then
  begin
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow) then
  begin
    Result := 0;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  MultiIntError := False;
  finished := False;
  M := INT_1W_U_MAXINT_1;

  R := A.FParts[0];
  i := 1;
  while (i < A.FPartsSize) and (not MultiIntError) do
  begin
    if (not finished) then
    begin
      V := A.FParts[i];
      try
        begin
          V := (V * M);
          R := R + V;
        end
      except
        begin
          MultiIntError := True;
          if MultiIntEnableExceptions then
            raise EIntOverflow.Create('Overflow');
        end;
      end;
      V := INT_1W_U_MAXINT_1;
      try
        M := (M * V);
      except
        finished := True;
      end;
    end
    else
    if (A.FParts[i] > 0) then
    begin
      MultiIntError := True;
      if MultiIntEnableExceptions then
        raise EIntOverflow.Create('Overflow');
    end;
    Inc(i);
  end;

  if A.FIsNegative then
    R    := (-R);
  Result := R;
end;


(******************************************)
class operator TMultiIntXV.:=(const A: TMultiIntXV): real;
var
  R, V, M: real;
  i: INT_1W_U;
  finished: boolean;
begin
  if not A.FIsDefined then
  begin
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow) then
  begin
    Result := 0;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  MultiIntError := False;
  finished := False;
  M := INT_1W_U_MAXINT_1;

  R := A.FParts[0];
  i := 1;
  while (i < A.FPartsSize) and (not MultiIntError) do
  begin
    if (not finished) then
    begin
      V := A.FParts[i];
      try
        begin
          V := (V * M);
          R := R + V;
        end
      except
        begin
          MultiIntError := True;
          if MultiIntEnableExceptions then
            raise EIntOverflow.Create('Overflow');
        end;
      end;
      V := INT_1W_U_MAXINT_1;
      try
        M := (M * V);
      except
        finished := True;
      end;
    end
    else
    if (A.FParts[i] > 0) then
    begin
      MultiIntError := True;
      if MultiIntEnableExceptions then
        raise EIntOverflow.Create('Overflow');
    end;
    Inc(i);
  end;

  if A.FIsNegative then
    R    := (-R);
  Result := R;
end;


(******************************************)
class operator TMultiIntXV.:=(const A: TMultiIntXV): double;
var
  R, V, M: double;
  i: INT_1W_U;
  finished: boolean;
begin
  if not A.FIsDefined then
  begin
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow) then
  begin
    Result := 0;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  MultiIntError := False;
  finished := False;
  M := INT_1W_U_MAXINT_1;

  R := A.FParts[0];
  i := 1;
  while (i < A.FPartsSize) and (not MultiIntError) do
  begin
    if (not finished) then
    begin
      V := A.FParts[i];
      try
        begin
          V := (V * M);
          R := R + V;
        end
      except
        begin
          MultiIntError := True;
          if MultiIntEnableExceptions then
            raise EIntOverflow.Create('Overflow');
        end;
      end;
      V := INT_1W_U_MAXINT_1;
      try
        M := (M * V);
      except
        finished := True;
      end;
    end
    else
    if (A.FParts[i] > 0) then
    begin
      MultiIntError := True;
      if MultiIntEnableExceptions then
        raise EIntOverflow.Create('Overflow');
    end;
    Inc(i);
  end;

  if A.FIsNegative then
    R    := (-R);
  Result := R;
end;


(******************************************)
// WARNING Float type to Multi_Int type conversion loses some precision
class operator TMultiIntXV.:=(const A: single): TMultiIntXV;
var
  R: TMultiIntXV;
  R_FLOATREC: TFloatRec;
begin
  MultiIntError := False;

  FloatToDecimal(R_FLOATREC, A, SINGLE_TYPE_PRECISION_DIGITS, 0);
  String_to_Multi_Int_XV(AddCharR('0', AnsiLeftStr(R_FLOATREC.digits,
    (SINGLE_TYPE_PRECISION_DIGITS - 1)), R_FLOATREC.Exponent), R);

  if (R.HasOverflow) then
  begin
    Result.FIsDefined  := False;
    Result.FIsNegative := uBoolUndefined;
    MultiIntError      := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  if (R_FLOATREC.Negative) then
    R.FIsNegative := True;
  Result := R;
end;


(******************************************)
// WARNING Float type to Multi_Int type conversion loses some precision
class operator TMultiIntXV.:=(const A: real): TMultiIntXV;
var
  R: TMultiIntXV;
  R_FLOATREC: TFloatRec;
begin
  MultiIntError := False;

  FloatToDecimal(R_FLOATREC, A, REAL_TYPE_PRECISION_DIGITS, 0);
  String_to_Multi_Int_XV(AddCharR('0', AnsiLeftStr(R_FLOATREC.digits,
    (REAL_TYPE_PRECISION_DIGITS - 1)), R_FLOATREC.Exponent), R);

  if (R.HasOverflow) then
  begin
    MultiIntError      := True;
    Result.FIsDefined  := False;
    Result.FIsNegative := uBoolUndefined;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  if (R_FLOATREC.Negative) then
    R.FIsNegative := True;
  Result := R;
end;


(******************************************)
// WARNING Float type to Multi_Int type conversion loses some precision
class operator TMultiIntXV.:=(const A: double): TMultiIntXV;
var
  R: TMultiIntXV;
  R_FLOATREC: TFloatRec;
begin
  MultiIntError := False;

  FloatToDecimal(R_FLOATREC, A, DOUBLE_TYPE_PRECISION_DIGITS, 0);
  String_to_Multi_Int_XV(AddCharR('0', AnsiLeftStr(R_FLOATREC.digits,
    (DOUBLE_TYPE_PRECISION_DIGITS - 1)), R_FLOATREC.Exponent), R);

  if (R.HasOverflow) then
  begin
    MultiIntError      := True;
    Result.FIsDefined  := False;
    Result.FIsNegative := uBoolUndefined;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  if (R_FLOATREC.Negative) then
    R.FIsNegative := True;
  Result := R;
end;


(******************************************)
class operator TMultiIntXV.:=(const A: TMultiIntXV): INT_2W_S;
var
  R: INT_2W_U;
  n: INT_1W_U;
  M_Val_All_Zero: boolean;
begin
  MultiIntError := False;
  if not A.FIsDefined then
  begin
    Result := 0;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow) then
  begin
    Result := 0;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  R := (INT_2W_U(A.FParts[0]) + (INT_2W_U(A.FParts[1]) * INT_1W_U_MAXINT_1));

  M_Val_All_Zero := True;
  n := 2;
  while (n < A.FPartsSize) and M_Val_All_Zero do
  begin
    if (A.FParts[n] <> 0) then
      M_Val_All_Zero := False;
    Inc(n);
  end;

  if (R >= INT_2W_S_MAXINT) or (not M_Val_All_Zero) then
  begin
    Result := 0;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  if A.FIsNegative then
    Result := INT_2W_S(-R)
  else
    Result := INT_2W_S(R);
end;


(******************************************)
class operator TMultiIntXV.:=(const A: TMultiIntXV): INT_2W_U;
var
  R: INT_2W_U;
  n: INT_1W_U;
  M_Val_All_Zero: boolean;
begin
  MultiIntError := False;
  if not A.FIsDefined then
  begin
    Result := 0;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow) or (A.FIsNegative = True) then
  begin
    Result := 0;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  R := (INT_2W_U(A.FParts[1]) << INT_1W_SIZE);
  R := (R or INT_2W_U(A.FParts[0]));

  M_Val_All_Zero := True;
  n := 2;
  while (n < A.FPartsSize) and M_Val_All_Zero do
  begin
    if (A.FParts[n] <> 0) then
      M_Val_All_Zero := False;
    Inc(n);
  end;

  if (not M_Val_All_Zero) then
  begin
    Result := 0;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    exit;
  end;

  Result := R;
end;


(******************************************)
class operator TMultiIntXV.:=(const A: TMultiIntXV): INT_1W_S;
var
  R: INT_2W_U;
  n: INT_1W_U;
  M_Val_All_Zero: boolean;
begin
  MultiIntError := False;
  if not A.FIsDefined then
  begin
    Result := 0;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow) then
  begin
    Result := 0;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  R := (INT_2W_U(A.FParts[0]) + (INT_2W_U(A.FParts[1]) * INT_1W_U_MAXINT_1));

  M_Val_All_Zero := True;
  n := 2;
  while (n < A.FPartsSize) and M_Val_All_Zero do
  begin
    if (A.FParts[n] <> 0) then
      M_Val_All_Zero := False;
    Inc(n);
  end;

  if (R > INT_1W_S_MAXINT) or (not M_Val_All_Zero) then
  begin
    Result := 0;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    exit;
  end;

  if A.FIsNegative then
    Result := INT_1W_S(-R)
  else
    Result := INT_1W_S(R);
end;


(******************************************)
class operator TMultiIntXV.:=(const A: TMultiIntXV): INT_1W_U;
var
  R: INT_2W_U;
  n: INT_1W_U;
  M_Val_All_Zero: boolean;
begin
  MultiIntError := False;
  if not A.FIsDefined then
  begin
    Result := 0;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow) or (A.FIsNegative = True) then
  begin
    Result := 0;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  R := (INT_2W_U(A.FParts[0]) + (INT_2W_U(A.FParts[1]) * INT_1W_U_MAXINT_1));

  M_Val_All_Zero := True;
  n := 2;
  while (n < A.FPartsSize) and M_Val_All_Zero do
  begin
    if (A.FParts[n] <> 0) then
      M_Val_All_Zero := False;
    Inc(n);
  end;

  if (R > INT_1W_U_MAXINT) or (not M_Val_All_Zero) then
  begin
    Result := 0;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Overflow');
    exit;
  end;

  Result := INT_1W_U(R);
end;


{******************************************}
class operator TMultiIntXV.:=(const A: TMultiIntXV): TMultiUInt8;
begin
  MultiIntError := False;
  if not A.FIsDefined then
  begin
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow) or (A.FIsNegative = uBoolTrue) then
  begin
    Result := 0;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  if A > UINT8_MAX then
  begin
    MultiIntError := True;
    Result := 0;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  Result := TMultiUInt8(A.FParts[0]);
end;


{******************************************}
class operator TMultiIntXV.:=(const A: TMultiIntXV): TMultiInt8;
begin
  MultiIntError := False;
  if not A.FIsDefined then
  begin
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow) then
  begin
    Result := 0;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  if A > UINT8_MAX then
  begin
    MultiIntError := True;
    Result := 0;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;

  Result := TMultiInt8(A.FParts[0]);
end;


(******************************************)
function add_Multi_Int_XV(const A, B: TMultiIntXV): TMultiIntXV;
label
  999;
var
  tv1, tv2: INT_2W_S;
  i, s1, s2, s, ss: INT_1W_S;
  M_Val: array of INT_2W_U;
  M_Val_All_Zero: boolean;
begin
  s1 := A.FPartsSize;
  s2 := B.FPartsSize;
  s  := s1;
  if (s1 < s2) then
    s := s2;
  ss  := (s + 1);
  setlength(M_Val, ss);

  tv1      := A.FParts[0];
  tv2      := B.FParts[0];
  M_Val[0] := (tv1 + tv2);
  if M_Val[0] > INT_1W_U_MAXINT then
  begin
    M_Val[1] := (M_Val[0] div INT_1W_U_MAXINT_1);
    M_Val[0] := (M_Val[0] mod INT_1W_U_MAXINT_1);
  end
  else
    M_Val[1] := 0;

  i := 1;
  while (i < (s - 1)) do
  begin
    if (i < s1) then
      tv1 := A.FParts[i]
    else
      tv1 := 0;
    if (i < s2) then
      tv2 := B.FParts[i]
    else
      tv2 := 0;
    M_Val[i] := (M_Val[i] + tv1 + tv2);
    if M_Val[i] > INT_1W_U_MAXINT then
    begin
      M_Val[i + 1] := (M_Val[i] div INT_1W_U_MAXINT_1);
      M_Val[i]     := (M_Val[i] mod INT_1W_U_MAXINT_1);
    end
    else
      M_Val[i + 1] := 0;
    Inc(i);
  end;

  if (i < s1) then
    tv1 := A.FParts[i]
  else
    tv1 := 0;
  if (i < s2) then
    tv2 := B.FParts[i]
  else
    tv2 := 0;
  M_Val[i] := (M_Val[i] + tv1 + tv2);

  if M_Val[i] > INT_1W_U_MAXINT then
  begin
    M_Val[i + 1] := (M_Val[i] div INT_1W_U_MAXINT_1);
    M_Val[i]     := (M_Val[i] mod INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[i + 1] := 0;
    ss := s;
  end;

  Result := 0;
  if (ss > Result.FPartsSize) then
  begin
    Multi_Int_Reset_XV_Size(Result, ss);
    if (Result.HasOverflow) then
    begin
      MultiIntError     := True;
      Result.FIsDefined := False;
      goto 999;
    end;
  end;

  Result.FHasOverflow := False;
  Result.FIsDefined   := True;
  Result.FIsNegative  := uBoolUndefined;

  M_Val_All_Zero := True;
  i := 0;
  while (i < ss) do
  begin
    Result.FParts[i] := M_Val[i];
    if M_Val[i] <> 0 then
      M_Val_All_Zero := False;
    Inc(i);
  end;

  if M_Val_All_Zero then
    Result.FIsNegative := uBoolFalse;

  999: ;
end;


(******************************************)
function subtract_Multi_Int_XV(const A, B: TMultiIntXV): TMultiIntXV;
label
  999;
var
  tv1, tv2: INT_2W_S;
  M_Val: array of INT_2W_S;
  i, s1, s2, s, ss: INT_2W_S;
  M_Val_All_Zero: boolean;
begin
  s1 := A.FPartsSize;
  s2 := B.FPartsSize;
  s  := s1;
  if (s1 < s2) then
    s := s2;
  ss  := (s + 1);
  setlength(M_Val, ss);

  M_Val[0] := (A.FParts[0] - B.FParts[0]);
  if M_Val[0] < 0 then
  begin
    M_Val[1] := -1;
    M_Val[0] := (M_Val[0] + INT_1W_U_MAXINT_1);
  end
  else
    M_Val[1] := 0;

  i := 1;
  while (i < (s - 1)) do
  begin
    if (i < s1) then
      tv1 := A.FParts[i]
    else
      tv1 := 0;
    if (i < s2) then
      tv2 := B.FParts[i]
    else
      tv2 := 0;
    M_Val[i] := (M_Val[i] + (tv1 - tv2));
    if M_Val[i] < 0 then
    begin
      M_Val[i + 1] := -1;
      M_Val[i]     := (M_Val[i] + INT_1W_U_MAXINT_1);
    end
    else
      M_Val[i + 1] := 0;
    Inc(i);
  end;

  if (i < s1) then
    tv1 := A.FParts[i]
  else
    tv1 := 0;
  if (i < s2) then
    tv2 := B.FParts[i]
  else
    tv2 := 0;
  M_Val[i] := (M_Val[i] + (tv1 - tv2));
  if M_Val[i] < 0 then
  begin
    M_Val[i + 1] := -1;
    M_Val[i]     := (M_Val[i] + INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[i + 1] := 0;
    ss := s;
  end;

  Result := 0;
  if (ss > Result.FPartsSize) then
  begin
    Multi_Int_Reset_XV_Size(Result, ss);
    if (Result.HasOverflow) then
    begin
      MultiIntError     := True;
      Result.FIsDefined := False;
      goto 999;
    end;
  end;

  Result.FHasOverflow := False;
  Result.FIsDefined   := True;
  Result.FIsNegative  := uBoolUndefined;

  M_Val_All_Zero := True;
  i := 0;
  while (i < ss) do
  begin
    Result.FParts[i] := M_Val[i];
    if M_Val[i] > 0 then
      M_Val_All_Zero := False;
    Inc(i);
  end;

  if M_Val_All_Zero then
    Result.FIsNegative := uBoolFalse;

  999: ;
end;


(******************************************)
class operator TMultiIntXV.+(const A, B: TMultiIntXV): TMultiIntXV;
var
  Neg: TMultiUBool;
begin
  if not A.FIsDefined or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow or B.FHasOverflow) then
  begin
    Result := 0;
    Result.FHasOverflow := True;
    Result.FIsDefined := True;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  Neg := uBoolUndefined;

  if (A.FIsNegative = B.FIsNegative) then
  begin
    Result := add_Multi_Int_XV(A, B);
    Neg    := A.FIsNegative;
  end
  else
  if ((A.FIsNegative = False) and (B.FIsNegative = True)) then
  begin
    if ABS_greaterthan_Multi_Int_XV(B, A) then
    begin
      Result := subtract_Multi_Int_XV(B, A);
      Neg    := uBoolTrue;
    end
    else
    begin
      Result := subtract_Multi_Int_XV(A, B);
      Neg    := uBoolFalse;
    end;
  end
  else
  if ABS_greaterthan_Multi_Int_XV(A, B) then
  begin
    Result := subtract_Multi_Int_XV(A, B);
    Neg    := uBoolTrue;
  end
  else
  begin
    Result := subtract_Multi_Int_XV(B, A);
    Neg    := uBoolFalse;
  end;

  if (Result.FHasOverflow = True) then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
  end;

  if (Result.FIsNegative = uBoolUndefined) then
    Result.FIsNegative := Neg;
end;


(******************************************)
class operator TMultiIntXV.Inc(const A: TMultiIntXV): TMultiIntXV;
var
  Neg: TMultiUBoolState;
  B: TMultiIntXV;
begin
  if not A.FIsDefined then
  begin
    Result := 0;
    Result.FIsDefined := A.FIsDefined;
    Result.FHasOverflow := A.FHasOverflow;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow) then
  begin
    Result := 0;
    Result.FIsDefined := A.FIsDefined;
    Result.FHasOverflow := A.FHasOverflow;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  Neg := uBoolUndefined;
  B   := 1;

  if (A.FIsNegative = False) then
  begin
    Result := add_Multi_Int_XV(A, B);
    Neg    := A.FIsNegative;
  end
  else
  if ABS_greaterthan_Multi_Int_XV(A, B) then
  begin
    Result := subtract_Multi_Int_XV(A, B);
    Neg    := uBoolTrue;
  end
  else
  begin
    Result := subtract_Multi_Int_XV(B, A);
    Neg    := uBoolFalse;
  end;

  if (Result.FHasOverflow = True) then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
  end;

  if (Result.FIsNegative = uBoolUndefined) then
    Result.FIsNegative := Neg;
end;


(******************************************)
class operator TMultiIntXV.-(const A, B: TMultiIntXV): TMultiIntXV;
var
  Neg: TMultiUBoolState;
begin
  if not A.FIsDefined or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow or B.FHasOverflow) then
  begin
    Result := 0;
    Result.FHasOverflow := True;
    Result.FIsDefined := True;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  Neg := uBoolUndefined;

  if (A.FIsNegative = B.FIsNegative) then
  begin
    if (A.FIsNegative = True) then
    begin
      if ABS_greaterthan_Multi_Int_XV(A, B) then
      begin
        Result := subtract_Multi_Int_XV(A, B);
        Neg    := uBoolTrue;
      end
      else
      begin
        Result := subtract_Multi_Int_XV(B, A);
        Neg    := uBoolFalse;
      end;
    end
    else  (* if  not FIsNegative then  *)
    begin
      if ABS_greaterthan_Multi_Int_XV(B, A) then
      begin
        Result := subtract_Multi_Int_XV(B, A);
        Neg    := uBoolTrue;
      end
      else
      begin
        Result := subtract_Multi_Int_XV(A, B);
        Neg    := uBoolFalse;
      end;
    end;
  end
  else (* A.FIsNegative <> B.FIsNegative *)
  if (B.FIsNegative = True) then
  begin
    Result := add_Multi_Int_XV(A, B);
    Neg    := uBoolFalse;
  end
  else
  begin
    Result := add_Multi_Int_XV(A, B);
    Neg    := uBoolTrue;
  end;

  if (Result.FHasOverflow = True) then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
  end;

  if (Result.FIsNegative = uBoolUndefined) then
    Result.FIsNegative := Neg;
end;


(******************************************)
class operator TMultiIntXV.Dec(const A: TMultiIntXV): TMultiIntXV;
var
  Neg: TMultiUBoolState;
  B: TMultiIntXV;
begin
  if not A.FIsDefined then
  begin
    Result := 0;
    Result.FIsDefined := A.FIsDefined;
    Result.FHasOverflow := A.FHasOverflow;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow) then
  begin
    Result := 0;
    Result.FIsDefined := A.FIsDefined;
    Result.FHasOverflow := A.FHasOverflow;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  Neg := uBoolUndefined;
  B   := 1;

  if (A.FIsNegative = False) then
  begin
    if ABS_greaterthan_Multi_Int_XV(B, A) then
    begin
      Result := subtract_Multi_Int_XV(B, A);
      Neg    := uBoolTrue;
    end
    else
    begin
      Result := subtract_Multi_Int_XV(A, B);
      Neg    := uBoolFalse;
    end;
  end
  else (* A is FIsNegative *)
  begin
    Result := add_Multi_Int_XV(A, B);
    Neg    := uBoolTrue;
  end;

  if (Result.FHasOverflow = True) then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
  end;

  if (Result.FIsNegative = uBoolUndefined) then
    Result.FIsNegative := Neg;
end;


(******************************************)
class operator TMultiIntXV.-(const A: TMultiIntXV): TMultiIntXV;
begin
  if not A.FIsDefined then
  begin
    Result := 0;
    Result.FIsDefined := A.FIsDefined;
    Result.FHasOverflow := A.FHasOverflow;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow) then
  begin
    Result := 0;
    Result.FIsDefined := A.FIsDefined;
    Result.FHasOverflow := A.FHasOverflow;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  Result := A;
  if (A.FIsNegative = uBoolTrue) then
    Result.FIsNegative := uBoolFalse;
  if (A.FIsNegative = uBoolFalse) then
    Result.FIsNegative := uBoolTrue;
end;


(******************************************)
class operator TMultiIntXV.xor(const A, B: TMultiIntXV): TMultiIntXV;
label
  999;
var
  i, s1, s2, s: INT_1W_S;
  tv1, tv2: INT_1W_U;
begin
  if not A.FIsDefined or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow or B.FHasOverflow) then
  begin
    Result := 0;
    Result.FHasOverflow := True;
    Result.FIsDefined := False;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  s1 := A.FPartsSize;
  s2 := B.FPartsSize;
  s  := s1;
  if (s1 < s2) then
    s := s2;

  Result.Initialize;
  if (s > Result.FPartsSize) then
  begin
    Multi_Int_Reset_XV_Size(Result, s);
    if (Result.HasOverflow) then
    begin
      MultiIntError     := True;
      Result.FIsDefined := False;
      goto 999;
    end;
  end;

  i := 0;
  while (i < s) do
  begin
    if (i < s1) then
      tv1 := A.FParts[i]
    else
      tv1 := 0;
    if (i < s2) then
      tv2 := B.FParts[i]
    else
      tv2 := 0;
    Result.FParts[i] := (tv1 xor tv2);
    Inc(i);
  end;

  Result.FIsDefined   := True;
  Result.FHasOverflow := False;

  Result.FIsNegative := uBoolFalse;
  if (A.IsNegative <> B.IsNegative) then
    Result.FIsNegative := uBoolTrue;

  999: ;
end;


(******************************************)
class operator TMultiIntXV.or(const A, B: TMultiIntXV): TMultiIntXV;
label
  999;
var
  i, s1, s2, s: INT_1W_S;
  tv1, tv2: INT_1W_U;
begin
  if not A.FIsDefined or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow or B.FHasOverflow) then
  begin
    Result := 0;
    Result.FHasOverflow := True;
    Result.FIsDefined := True;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  s1 := A.FPartsSize;
  s2 := B.FPartsSize;
  s  := s1;
  if (s1 < s2) then
    s := s2;

  Result.Initialize;
  if (s > Result.FPartsSize) then
  begin
    Multi_Int_Reset_XV_Size(Result, s);
    if (Result.HasOverflow) then
    begin
      MultiIntError     := True;
      Result.FIsDefined := False;
      goto 999;
    end;
  end;

  i := 0;
  while (i < s) do
  begin
    if (i < s1) then
      tv1 := A.FParts[i]
    else
      tv1 := 0;
    if (i < s2) then
      tv2 := B.FParts[i]
    else
      tv2 := 0;
    Result.FParts[i] := (tv1 or tv2);
    Inc(i);
  end;

  Result.FIsDefined   := True;
  Result.FHasOverflow := False;

  Result.FIsNegative := uBoolFalse;
  if A.IsNegative and B.IsNegative then
    Result.FIsNegative := uBoolTrue;

  999: ;
end;


(******************************************)
class operator TMultiIntXV.and(const A, B: TMultiIntXV): TMultiIntXV;
label
  999;
var
  i, s1, s2, s: INT_1W_S;
  tv1, tv2: INT_1W_U;
begin
  if not A.FIsDefined or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow or B.FHasOverflow) then
  begin
    Result := 0;
    Result.FHasOverflow := True;
    Result.FIsDefined := True;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  s1 := A.FPartsSize;
  s2 := B.FPartsSize;
  s  := s1;
  if (s1 < s2) then
    s := s2;

  Result.Initialize;
  if (s > Result.FPartsSize) then
  begin
    Multi_Int_Reset_XV_Size(Result, s);
    if (Result.HasOverflow) then
    begin
      MultiIntError     := True;
      Result.FIsDefined := False;
      goto 999;
    end;
  end;

  i := 0;
  while (i < s) do
  begin
    if (i < s1) then
      tv1 := A.FParts[i]
    else
      tv1 := 0;
    if (i < s2) then
      tv2 := B.FParts[i]
    else
      tv2 := 0;
    Result.FParts[i] := (tv1 and tv2);
    Inc(i);
  end;

  Result.FIsDefined   := True;
  Result.FHasOverflow := False;

  Result.FIsNegative := uBoolFalse;
  if A.IsNegative and B.IsNegative then
    Result.FIsNegative := uBoolTrue;

  999: ;
end;


(******************************************)
class operator TMultiIntXV.not(const A: TMultiIntXV): TMultiIntXV;
label
  999;
var
  i, s1, s: INT_1W_S;
  tv1: INT_1W_U;
begin
  if not A.FIsDefined then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow) then
  begin
    Result := 0;
    Result.FHasOverflow := True;
    Result.FIsDefined := True;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  s1 := A.FPartsSize;
  s  := s1;

  Result.Initialize;
  if (s > Result.FPartsSize) then
  begin
    Multi_Int_Reset_XV_Size(Result, s);
    if (Result.HasOverflow) then
    begin
      MultiIntError     := True;
      Result.FIsDefined := False;
      goto 999;
    end;
  end;

  i := 0;
  while (i < s) do
  begin
    if (i < s1) then
      tv1 := A.FParts[i]
    else
      tv1 := 0;
    Result.FParts[i] := (not tv1);
    Inc(i);
  end;

  Result.FIsDefined   := True;
  Result.FHasOverflow := False;

  Result.FIsNegative := uBoolTrue;
  if A.IsNegative then
    Result.FIsNegative := uBoolFalse;

  999: ;
end;


(*******************v4*********************)
procedure multiply_Multi_Int_XV(const A, B: TMultiIntXV; out Result: TMultiIntXV);
  overload;
label
  999;
var
  i, j, k, s1, s2, ss, z2, z1: INT_2W_S;
  zf, zero_mult: boolean;
  tv1, tv2: INT_2W_U;
  M_Val: array of INT_2W_U;
begin
  s1 := A.FPartsSize;
  s2 := B.FPartsSize;
  ss := (s1 + s2 + 1);
  setlength(M_Val, ss);

  Result.Initialize;
  Result.FHasOverflow := False;
  Result.FIsDefined   := True;
  Result.FIsNegative  := uBoolUndefined;

  // skip leading zeros in B
  zf := False;
  i  := (s2 - 1);
  z2 := -1;
  repeat
    if (B.FParts[i] <> 0) then
    begin
      z2 := i;
      zf := True;
    end;
    Dec(i);
  until (i < 0) or (zf);
  if (z2 < 0) then
  begin
    Result.FIsNegative := uBoolFalse;
    goto 999;
  end;

  // skip leading zeros in A
  zf := False;
  i  := (s1 - 1);
  z1 := -1;
  repeat
    if (A.FParts[i] <> 0) then
    begin
      z1 := i;
      zf := True;
    end;
    Dec(i);
  until (i < 0) or (zf);
  if (z1 < 0) then
  begin
    Result.FIsNegative := uBoolFalse;
    goto 999;
  end;

  // main loopy
  i := 0;
  j := 0;
  repeat
    if (B.FParts[j] <> 0) then
    begin
      zero_mult := True;
      repeat
        if (A.FParts[i] <> 0) then
        begin
          zero_mult := False;
          tv1 := A.FParts[i];
          tv2 := B.FParts[j];
          M_Val[i + j + 1] :=
            (M_Val[i + j + 1] + ((tv1 * tv2) div INT_1W_U_MAXINT_1));
          M_Val[i + j] := (M_Val[i + j] + ((tv1 * tv2) mod INT_1W_U_MAXINT_1));
        end;
        Inc(i);
      until (i > z1);
      if not zero_mult then
      begin
        k := 0;
        repeat
          if (M_Val[k] <> 0) then
          begin
            M_Val[k + 1] := M_Val[k + 1] + (M_Val[k] div INT_1W_U_MAXINT_1);
            M_Val[k]     := (M_Val[k] mod INT_1W_U_MAXINT_1);
          end;
          Inc(k);
        until (k >= ss);
      end;
      i := 0;
    end;
    Inc(j);
  until (j > z2);

  // skip leading zeros to make result var just big enough, but no bigger
  // check if result all zeros; if so, negative:= false, else negative:= undefined

  Result.FIsNegative := uBoolFalse;
  zf := False;
  z1 := -1;
  i  := (ss - 1);
  repeat
    if (M_Val[i] <> 0) then
    begin
      Result.FIsNegative := uBoolUndefined;
      if (not zf) then
      begin
        zf := True;
        z1 := i;
      end;
    end;
    Dec(i);
  until (i < 0);

  if ((z1 + 1) > Result.FPartsSize) then
  begin
    Multi_Int_Reset_XV_Size(Result, (z1 + 1));
    if (Result.HasOverflow) then
    begin
      MultiIntError     := True;
      Result.FIsDefined := False;
      goto 999;
    end;
  end;

  // copy temp M_Val to Result
  i := 0;
  while (i <= z1) do
  begin
    Result.FParts[i] := M_Val[i];
    Inc(i);
  end;

  999: ;
end;


(******************************************)
class operator TMultiIntXV.*(const A, B: TMultiIntXV): TMultiIntXV;
var
  R: TMultiIntXV;
begin
  if not A.FIsDefined or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow or B.FHasOverflow) then
  begin
    Result := 0;
    Result.FHasOverflow := True;
    Result.FIsDefined := True;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  multiply_Multi_Int_XV(A, B, R);

  if (R.FIsNegative = uBoolUndefined) then
    if (A.FIsNegative = B.FIsNegative) then
      R.FIsNegative := uBoolFalse
    else
      R.FIsNegative := uBoolTrue;

  Result.Initialize;

  // redundant?
{
if (R.FPartsSize > Result.FPartsSize) then
  begin
  Multi_Int_Reset_XV_Size(Result,R.FPartsSize);
  if (Result.HasOverflow) then
    begin
    MultiIntError:= TRUE;
    Result.FIsDefined:= FALSE;
    if MultiIntEnableExceptions then
      Raise EIntOverflow.create('Overflow');
    end;
  end;
}

  Result := R;

  if (Result.FHasOverflow = True) then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
  end;

end;


(********************v3********************)
{ Function exp_by_squaring_iterative(TV, P) }

class operator TMultiIntXV.**(const A: TMultiIntXV; const P: INT_2W_S): TMultiIntXV;
var
  Y, TV, T, R: TMultiIntXV;
  PT: INT_2W_S;
begin
  if not A.FIsDefined then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow) then
  begin
    Result := 0;
    Result.FHasOverflow := True;
    Result.FIsDefined := True;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  PT := P;
  TV := A;
  if (PT < 0) then
    R := 0
  else if (PT = 0) then
    R := 1
  else
  begin
    Y := 1;
    while (PT > 1) do
    begin
      if odd(PT) then
      begin
        multiply_Multi_Int_XV(TV, Y, T);
        if (T.FHasOverflow) then
        begin
          Result := 0;
          Result.FIsDefined := False;
          Result.FHasOverflow := True;
          MultiIntError := True;
          if MultiIntEnableExceptions then
            raise EIntOverflow.Create('Overflow');
          exit;
        end;
        if (T.FIsNegative = uBoolUndefined) then
          if (TV.FIsNegative = Y.FIsNegative) then
            T.FIsNegative := uBoolFalse
          else
            T.FIsNegative := uBoolTrue;

        Y  := T;
        PT := PT - 1;
      end;
      multiply_Multi_Int_XV(TV, TV, T);
      if (T.FHasOverflow) then
      begin
        Result := 0;
        Result.FIsDefined := False;
        Result.FHasOverflow := True;
        MultiIntError := True;
        if MultiIntEnableExceptions then
          raise EIntOverflow.Create('Overflow');
        exit;
      end;
      T.FIsNegative := uBoolFalse;

      TV := T;
      PT := (PT div 2);
    end;
    multiply_Multi_Int_XV(TV, Y, R);
    if (R.FHasOverflow) then
    begin
      Result := 0;
      Result.FIsDefined := False;
      Result.FHasOverflow := True;
      MultiIntError := True;
      if MultiIntEnableExceptions then
        raise EIntOverflow.Create('Overflow');
      exit;
    end;
    if (R.FIsNegative = uBoolUndefined) then
      if (TV.FIsNegative = Y.FIsNegative) then
        R.FIsNegative := uBoolFalse
      else
        R.FIsNegative := uBoolTrue;
  end;

  Result := R;
end;


(********************v0********************)
procedure intdivide_taylor_warruth_XV(const P_dividend, P_dividor: TMultiIntXV;
  out P_quotient, P_remainder: TMultiIntXV);
label
  AGAIN, 9000, 9999;
var
  dividor, quotient, dividend, next_dividend: TMultiIntXV;

  dividend_i, dividend_i_1, quotient_i, dividor_i, div_size, div_size_plus,
  dividor_i_1, dividor_non_zero_pos, shiftup_bits_dividor, i: INT_2W_S;

  adjacent_word_dividend, adjacent_word_division, word_division,
  word_dividend, word_carry, next_word_carry: INT_2W_U;

  finished: boolean;

  (****)
begin

  P_quotient  := 0;
  P_remainder := 0;

  if (P_dividor = 0) then
  begin
    P_quotient.FIsDefined := False;
    P_quotient.FHasOverflow := True;
    P_remainder.FIsDefined := False;
    P_remainder.FHasOverflow := True;
    MultiIntError := True;
  end
  else if (P_dividor = P_dividend) then
    P_quotient := 1
  else
  begin
    if (Abs(P_dividor) > Abs(P_dividend)) then
    begin
      P_remainder := P_dividend;
      goto 9000;
    end;

    div_size := (P_dividend.FPartsSize + 1);

    dividor := P_dividor;
    Multi_Int_Reset_XV_Size(dividor, div_size);
    if (dividor.HasOverflow) then
    begin
      P_quotient.FIsDefined := False;
      P_quotient.FHasOverflow := True;
      P_remainder.FIsDefined := False;
      P_remainder.FHasOverflow := True;
      MultiIntError := True;
      goto 9999;
    end;

    dividend := P_dividend;
    Multi_Int_Reset_XV_Size(dividend, div_size);
    dividend.FIsNegative := False;

    quotient := 0;
    Multi_Int_Reset_XV_Size(quotient, div_size);

    next_dividend := 0;
    Multi_Int_Reset_XV_Size(next_dividend, div_size);

    dividor_non_zero_pos := 0;
    i := (dividor.FPartsSize - 1);
    while (i >= 0) do
    begin
      if (dividor_non_zero_pos = 0) then
        if (dividor.FParts[i] <> 0) then
        begin
          dividor_non_zero_pos := i;
          break;
        end;
      Dec(i);
    end;
    dividor.FIsNegative := False;

    // essential short-cut for single word dividor
    // NB this is not just for speed, the later code
    // will break if this case is not processed in advance

    if (dividor_non_zero_pos = 0) then
    begin
      word_carry := 0;
      i := Multi_XV_maxi;
      while (i >= 0) do
      begin
        P_quotient.FParts[i] :=
          (((word_carry * INT_2W_U(INT_1W_U_MAXINT_1)) +
          INT_2W_U(P_dividend.FParts[i])) div INT_2W_U(P_dividor.FParts[0]));
        word_carry := (((word_carry * INT_2W_U(INT_1W_U_MAXINT_1)) +
          INT_2W_U(P_dividend.FParts[i])) -
          (INT_2W_U(P_quotient.FParts[i]) * INT_2W_U(P_dividor.FParts[0])));
        Dec(i);
      end;
      P_remainder.FParts[0] := word_carry;
      goto 9000;
    end;

    shiftup_bits_dividor := LeadingZeroCount(dividor.FParts[dividor_non_zero_pos]);
    if (shiftup_bits_dividor > 0) then
    begin
      ShiftUp_NBits_Multi_Int_XV(dividend, shiftup_bits_dividor);
      ShiftUp_NBits_Multi_Int_XV(dividor, shiftup_bits_dividor);
    end;

    next_word_carry := 0;
    word_carry  := 0;
    dividor_i   := dividor_non_zero_pos;
    dividor_i_1 := (dividor_i - 1);
    dividend_i  := (dividend.FPartsSize - 1);
    finished    := False;
    while (not finished) do
      if (dividend_i >= 0) then
      begin
        if (dividend.FParts[dividend_i] = 0) then
          Dec(dividend_i)
        else
        begin
          finished := True;
        end;
      end
      else
        finished := True;
    quotient_i   := (dividend_i - dividor_non_zero_pos);

    while (dividend >= 0) and (quotient_i >= 0) do
    begin
      word_dividend   := ((word_carry * INT_2W_U(INT_1W_U_MAXINT_1)) +
        dividend.FParts[dividend_i]);
      word_division   := (word_dividend div dividor.FParts[dividor_i]);
      next_word_carry := (word_dividend mod dividor.FParts[dividor_i]);

      if (word_division > 0) then
      begin
        dividend_i_1 := (dividend_i - 1);
        if (dividend_i_1 >= 0) then
        begin
          AGAIN:
            adjacent_word_dividend :=
              ((next_word_carry * INT_2W_U(INT_1W_U_MAXINT_1)) +
            dividend.FParts[dividend_i_1]);
          adjacent_word_division   := (dividor.FParts[dividor_i_1] * word_division);
          if (adjacent_word_division > adjacent_word_dividend) or
            (word_division >= INT_1W_U_MAXINT_1) then
          begin
            Dec(word_division);
            next_word_carry := next_word_carry + dividor.FParts[dividor_i];
            if (next_word_carry < INT_1W_U_MAXINT_1) then
              goto AGAIN;
          end;
        end;

        quotient := 0;
        Multi_Int_Reset_XV_Size(quotient, div_size);

        quotient.FParts[quotient_i] := word_division;
        next_dividend := (dividor * quotient);
        next_dividend := (dividend - next_dividend);
        if (next_dividend.IsNegative) then
        begin
          Dec(word_division);
          quotient.FParts[quotient_i] := word_division;
          next_dividend := (dividend - (dividor * quotient));
        end;
        P_quotient.FParts[quotient_i] := word_division;
        dividend   := next_dividend;
        word_carry := dividend.FParts[dividend_i];
      end
      else
        word_carry := word_dividend;

      Dec(dividend_i);
      quotient_i := (dividend_i - dividor_non_zero_pos);
    end; { while }

    ShiftDown_MultiBits_Multi_Int_XV(dividend, shiftup_bits_dividor);
    P_remainder := dividend;

    9000:
      if (P_dividend.FIsNegative = True) and (P_remainder > 0) then
        P_remainder.FIsNegative := True;

    if (P_dividend.FIsNegative <> P_dividor.FIsNegative) and (P_quotient > 0) then
      P_quotient.FIsNegative := True;

  end;

  9999: ;
end;


(******************************************)
class operator TMultiIntXV.div(const A, B: TMultiIntXV): TMultiIntXV;
var
  Remainder, Quotient: TMultiIntXV;
begin
  if not A.FIsDefined or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow or B.FHasOverflow) then
  begin
    Result := 0;
    Result.FHasOverflow := True;
    Result.FIsDefined := True;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  // same values as last time

  if (XV_Last_Divisor = B) and (XV_Last_Dividend = A) then
    Result := XV_Last_Quotient
  else  // different values than last time
  begin
    intdivide_taylor_warruth_XV(A, B, Quotient, Remainder);

    XV_Last_Divisor   := B;
    XV_Last_Dividend  := A;
    XV_Last_Quotient  := Quotient;
    XV_Last_Remainder := Remainder;

    Result := Quotient;
  end;

  if (XV_Last_Remainder.FHasOverflow) or (XV_Last_Quotient.FHasOverflow) then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
  end;
end;


(******************************************)
class operator TMultiIntXV.mod(const A, B: TMultiIntXV): TMultiIntXV;
var
  Remainder, Quotient: TMultiIntXV;
begin
  if not A.FIsDefined or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow or B.FHasOverflow) then
  begin
    Result := 0;
    Result.FHasOverflow := True;
    Result.FIsDefined := True;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  // same values as last time

  if (XV_Last_Divisor = B) and (XV_Last_Dividend = A) then
    Result := XV_Last_Remainder
  else  // different values than last time
  begin
    intdivide_taylor_warruth_XV(A, B, Quotient, Remainder);

    XV_Last_Divisor   := B;
    XV_Last_Dividend  := A;
    XV_Last_Quotient  := Quotient;
    XV_Last_Remainder := Remainder;

    Result := Remainder;
  end;


  if (XV_Last_Remainder.FHasOverflow) or (XV_Last_Quotient.FHasOverflow) then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;
end;


(***********v2************)
procedure SqRoot(const A: TMultiIntXV; out VR, VREM: TMultiIntXV);
var
  D, D2: INT_2W_S;
  HS, LS: ansistring;
  H, L, C, CC, LPC, CCD, Q, R, T: TMultiIntXV;
  finished: boolean;
begin
  if not A.FIsDefined then
  begin
    VR   := 0;
    VR.FIsDefined := False;
    VREM := 0;
    VREM.FIsDefined := False;
    if MultiIntEnableExceptions then
      raise EInterror.Create('Uninitialised variable');
    exit;
  end;
  if (A.FHasOverflow) then
  begin
    VR   := 0;
    VR.FIsDefined := False;
    VREM := 0;
    VREM.FIsDefined := False;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  if (A.FIsNegative = uBoolTrue) then
  begin
    VR   := 0;
    VR.FIsDefined := False;
    VREM := 0;
    VREM.FIsDefined := False;
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Overflow');
    exit;
  end;

  if (A >= 100) then
  begin
    D  := length(A.ToString);
    D2 := D div 2;
    if ((D mod 2) = 0) then
    begin
      LS := '1' + AddCharR('0', '', D2 - 1);
      HS := '1' + AddCharR('0', '', D2);
      H  := HS;
      L  := LS;
    end
    else
    begin
      LS := '1' + AddCharR('0', '', D2);
      HS := '1' + AddCharR('0', '', D2 + 1);
      H  := HS;
      L  := LS;
    end;

    T := (H - L);
    ShiftDown_MultiBits_Multi_Int_XV(T, 1);
    C := (L + T);
  end
  else
  begin
    C := (A div 2);
    if (C = 0) then
      C := 1;
  end;

  finished := False;
  LPC      := A;
  repeat
    begin
      // CC:= ((C + (A div C)) div 2);
      intdivide_taylor_warruth_XV(A, C, Q, R);
      CC := (C + Q);
      ShiftDown_MultiBits_Multi_Int_XV(CC, 1);
      if (ABS(C - CC) < 2) then
        if (CC < LPC) then
          LPC := CC
        else if (CC >= LPC) then
          finished := True;
      C := CC;
    end
  until finished;

  VREM := (A - (LPC * LPC));
  VR   := LPC;
  VR.FIsNegative := uBoolFalse;
  VREM.FIsNegative := uBoolFalse;

end;


(*************************)
procedure SqRoot(const A: TMultiIntXV; out VR: TMultiIntXV);
var
  VREM: TMultiIntXV;
begin
  VREM := 0;
  sqroot(A, VR, VREM);
end;


(*************************)
function SqRoot(const A: TMultiIntXV): TMultiIntXV;
var
  VR, VREM: TMultiIntXV;
begin
  VREM := 0;
  sqroot(A, VR, VREM);
  Result := VR;
end;


{
******************************************
Multi_Init_Initialisation
******************************************
}

procedure Multi_Int_Initialisation(const P_Multi_XV_size: INT_2W_U = 16);
var
  i: INT_2W_S;
begin
  if Multi_Init_Initialisation_done then
  begin
    MultiIntError := True;
    if MultiIntEnableExceptions then
      raise EIntOverflow.Create('Multi_Init_Initialisation already called');
    exit;
  end
  else
  begin
    Multi_Init_Initialisation_done := True;

    Multi_XV_size := P_Multi_XV_size;
    if (Multi_XV_size < 2) then
    begin
      raise EInterror.Create('Multi_XV_size must be > 1');
      exit;
    end;
    Multi_XV_limit := (Multi_XV_size * 2);

    Multi_XV_maxi := (Multi_XV_size - 1);

    X3_Last_Divisor   := 0;
    X3_Last_Dividend  := 0;
    X3_Last_Quotient  := 0;
    X3_Last_Remainder := 0;

    X2_Last_Divisor   := 0;
    X2_Last_Dividend  := 0;
    X2_Last_Quotient  := 0;
    X2_Last_Remainder := 0;

    X4_Last_Divisor   := 0;
    X4_Last_Dividend  := 0;
    X4_Last_Quotient  := 0;
    X4_Last_Remainder := 0;

    XV_Last_Divisor   := 0;
    XV_Last_Dividend  := 0;
    XV_Last_Quotient  := 0;
    XV_Last_Remainder := 0;

    Multi_Int_X2_MAXINT := 0;
    i := 0;
    while (i <= Multi_X2_maxi) do
    begin
      Multi_Int_X2_MAXINT.FParts[i] := INT_1W_U_MAXINT;
      Inc(i);
    end;

    Multi_Int_X3_MAXINT := 0;
    i := 0;
    while (i <= Multi_X3_maxi) do
    begin
      Multi_Int_X3_MAXINT.FParts[i] := INT_1W_U_MAXINT;
      Inc(i);
    end;

    Multi_Int_X4_MAXINT := 0;
    i := 0;
    while (i <= Multi_X4_maxi) do
    begin
      Multi_Int_X4_MAXINT.FParts[i] := INT_1W_U_MAXINT;
      Inc(i);
    end;

    if (Multi_XV_maxi < 1) then
    begin
      if MultiIntEnableExceptions then
        raise EInterror.Create('Multi_XV_maxi value must be > 0');
      halt(1);
    end;

    Multi_Int_XV_MAXINT := 0;
    i := 0;
    while (i <= Multi_XV_maxi) do
    begin
      Multi_Int_XV_MAXINT.FParts[i] := INT_1W_U_MAXINT;
      Inc(i);
    end;
  end;
end;

procedure Multi_Int_Reset_X2_Last_Divisor;
begin
  X2_Last_Divisor   := 0;
  X2_Last_Dividend  := 0;
  X2_Last_Quotient  := 0;
  X2_Last_Remainder := 0;
end;

procedure Multi_Int_Reset_X3_Last_Divisor;
begin
  X3_Last_Divisor   := 0;
  X3_Last_Dividend  := 0;
  X3_Last_Quotient  := 0;
  X3_Last_Remainder := 0;
end;

procedure Multi_Int_Reset_X4_Last_Divisor;
begin
  X4_Last_Divisor   := 0;
  X4_Last_Dividend  := 0;
  X4_Last_Quotient  := 0;
  X4_Last_Remainder := 0;
end;

procedure Multi_Int_Reset_XV_Last_Divisor;
begin
  XV_Last_Divisor   := 0;
  XV_Last_Dividend  := 0;
  XV_Last_Quotient  := 0;
  XV_Last_Remainder := 0;
end;

begin
end.
