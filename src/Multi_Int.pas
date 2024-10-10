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
  strutils;

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
  TMultiUBoolState   = (uBoolUndefined, uBoolFalse, uBoolTrue);

  TMultiUBool = record
  private
    FValue: TMultiUBoolState;
  public
    procedure Initialize(AValue: TMultiUBoolState); inline;
    function ToString: ansistring; inline;

    class operator := (AValue: boolean): TMultiUBool; inline;
    class operator := (AValue: TMultiUBool): boolean; inline;
    class operator := (AValue: TMultiUBoolState): TMultiUBool; inline;
    class operator := (AValue: TMultiUBool): TMultiUBoolState; inline;

    class operator =(A, B: TMultiUBool): boolean; inline;
    class operator <>(A, B: TMultiUBool): boolean; inline;

    class operator or(A, B: TMultiUBool): boolean; inline;
    class operator or(A: TMultiUBool; B: boolean): boolean; inline;
    class operator or(A: boolean; B: TMultiUBool): boolean; inline;

    class operator and(A, B: TMultiUBool): boolean; inline;
    class operator and(A: TMultiUBool; B: boolean): boolean; inline;
    class operator and(A: boolean; B: TMultiUBool): boolean; inline;

    class operator not(A: TMultiUBool): boolean; inline;
  end;

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

    class operator := (const AValue: TMultiIntX2): TMultiUInt8; inline;
    class operator := (const AValue: TMultiIntX2): TMultiInt8; inline;

    class operator := (const AValue: TMultiIntX2): INT_1W_U; inline;
    class operator := (const AValue: TMultiIntX2): INT_1W_S; inline;
    class operator := (const AValue: TMultiIntX2): INT_2W_U; inline;
    class operator := (const AValue: TMultiIntX2): INT_2W_S; inline;

    class operator := (const AValue: INT_2W_S): TMultiIntX2; inline;
    class operator := (const AValue: INT_2W_U): TMultiIntX2; inline;

    {$ifdef CPU_32}
    class operator := (const AValue: INT_4W_S): TMultiIntX2; inline;
    class operator := (const AValue: INT_4W_U): TMultiIntX2; inline;
    {$endif}

    class operator := (const AValue: ansistring): TMultiIntX2; inline;
    class operator := (const AValue: TMultiIntX2): ansistring; inline;
    class operator := (const AValue: single): TMultiIntX2; inline;
    class operator := (const AValue: real): TMultiIntX2; inline;
    class operator := (const AValue: double): TMultiIntX2; inline;
    class operator := (const AValue: TMultiIntX2): single; inline;
    class operator := (const AValue: TMultiIntX2): real; inline;
    class operator := (const AValue: TMultiIntX2): double; inline;
    class operator +(const A, B: TMultiIntX2): TMultiIntX2; inline;
    class operator -(const A, B: TMultiIntX2): TMultiIntX2; inline;
    class operator Inc(const AValue: TMultiIntX2): TMultiIntX2; inline;
    class operator Dec(const AValue: TMultiIntX2): TMultiIntX2; inline;
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
    class operator not(const AValue: TMultiIntX2): TMultiIntX2; inline;
    class operator -(const AValue: TMultiIntX2): TMultiIntX2; inline;
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
    Overflow_flag: boolean;
    Defined_flag: boolean;
    Negative_flag: TMultiUBool;
    M_Value: array[0..Multi_X3_maxi] of INT_1W_U;
  public
    function ToStr: ansistring; inline;
    function ToHex(const LZ: TMultiLeadingZeros = TrimLeadingZeros): ansistring; inline;
    function ToBin(const LZ: TMultiLeadingZeros = TrimLeadingZeros): ansistring; inline;
    function FromHex(const v1: ansistring): TMultiIntX3; inline;
    function FromBin(const v1: ansistring): TMultiIntX3; inline;
    function Overflow: boolean; inline;
    function Negative: boolean; inline;
    function Defined: boolean; inline;
    class operator := (const v1: TMultiIntX3): TMultiUInt8; inline;
    class operator := (const v1: TMultiIntX3): TMultiInt8; inline;
    class operator := (const v1: TMultiIntX3): INT_1W_U; inline;
    class operator := (const v1: TMultiIntX3): INT_1W_S; inline;
    class operator := (const v1: TMultiIntX3): INT_2W_U; inline;
    class operator := (const v1: TMultiIntX3): INT_2W_S; inline;
    class operator := (const v1: INT_2W_S): TMultiIntX3; inline;
    class operator := (const v1: INT_2W_U): TMultiIntX3; inline;
    {$ifdef CPU_32}
    class operator := (const v1: INT_4W_S): TMultiIntX3; inline;
    class operator := (const v1: INT_4W_U): TMultiIntX3; inline;
    {$endif}
    class operator := (const v1: TMultiIntX2): TMultiIntX3; inline;
    class operator := (const v1: ansistring): TMultiIntX3; inline;
    class operator := (const v1: TMultiIntX3): ansistring; inline;
    class operator := (const v1: single): TMultiIntX3; inline;
    class operator := (const v1: real): TMultiIntX3; inline;
    class operator := (const v1: double): TMultiIntX3; inline;
    class operator := (const v1: TMultiIntX3): real; inline;
    class operator := (const v1: TMultiIntX3): single; inline;
    class operator := (const v1: TMultiIntX3): double; inline;
    class operator +(const v1, v2: TMultiIntX3): TMultiIntX3; inline;
    class operator -(const v1, v2: TMultiIntX3): TMultiIntX3; inline;
    class operator Inc(const v1: TMultiIntX3): TMultiIntX3; inline;
    class operator Dec(const v1: TMultiIntX3): TMultiIntX3; inline;
    class operator >(const v1, v2: TMultiIntX3): boolean; inline;
    class operator <(const v1, v2: TMultiIntX3): boolean; inline;
    class operator =(const v1, v2: TMultiIntX3): boolean; inline;
    class operator <>(const v1, v2: TMultiIntX3): boolean; inline;
    class operator *(const v1, v2: TMultiIntX3): TMultiIntX3; inline;
    class operator div(const v1, v2: TMultiIntX3): TMultiIntX3; inline;
    class operator mod(const v1, v2: TMultiIntX3): TMultiIntX3; inline;
    class operator xor(const v1, v2: TMultiIntX3): TMultiIntX3; inline;
    class operator or(const v1, v2: TMultiIntX3): TMultiIntX3; inline;
    class operator and(const v1, v2: TMultiIntX3): TMultiIntX3; inline;
    class operator not(const v1: TMultiIntX3): TMultiIntX3; inline;
    class operator -(const v1: TMultiIntX3): TMultiIntX3; inline;
    class operator >=(const v1, v2: TMultiIntX3): boolean; inline;
    class operator <=(const v1, v2: TMultiIntX3): boolean; inline;
    class operator **(const v1: TMultiIntX3; const P: INT_2W_S): TMultiIntX3;
      inline;
    class operator shr(const v1: TMultiIntX3;
      const NBits: INT_1W_U): TMultiIntX3; inline;
    class operator shl(const v1: TMultiIntX3;
      const NBits: INT_1W_U): TMultiIntX3; inline;
  end;


  TMultiIntX4 = record
  private
    Overflow_flag: boolean;
    Defined_flag: boolean;
    Negative_flag: TMultiUBool;
    M_Value: array[0..Multi_X4_maxi] of INT_1W_U;
  public
    function ToStr: ansistring; inline;
    function ToHex(const LZ: TMultiLeadingZeros = TrimLeadingZeros): ansistring; inline;
    function ToBin(const LZ: TMultiLeadingZeros = TrimLeadingZeros): ansistring; inline;
    function FromHex(const v1: ansistring): TMultiIntX4; inline;
    function FromBin(const v1: ansistring): TMultiIntX4; inline;
    function Overflow: boolean; inline;
    function Negative: boolean; inline;
    function Defined: boolean; inline;
    class operator := (const v1: TMultiIntX4): TMultiUInt8; inline;
    class operator := (const v1: TMultiIntX4): TMultiInt8; inline;
    class operator := (const v1: TMultiIntX4): INT_1W_U; inline;
    class operator := (const v1: TMultiIntX4): INT_1W_S; inline;
    class operator := (const v1: TMultiIntX4): INT_2W_U; inline;
    class operator := (const v1: TMultiIntX4): INT_2W_S; inline;
    class operator := (const v1: INT_2W_S): TMultiIntX4; inline;
    class operator := (const v1: INT_2W_U): TMultiIntX4; inline;
    {$ifdef CPU_32}
    class operator := (const v1: INT_4W_S): TMultiIntX4; inline;
    class operator := (const v1: INT_4W_U): TMultiIntX4; inline;
    {$endif}
    class operator := (const v1: TMultiIntX2): TMultiIntX4; inline;
    class operator := (const v1: TMultiIntX3): TMultiIntX4; inline;
    class operator := (const v1: ansistring): TMultiIntX4; inline;
    class operator := (const v1: TMultiIntX4): ansistring; inline;
    class operator := (const v1: single): TMultiIntX4; inline;
    class operator := (const v1: real): TMultiIntX4; inline;
    class operator := (const v1: double): TMultiIntX4; inline;
    class operator := (const v1: TMultiIntX4): single; inline;
    class operator := (const v1: TMultiIntX4): real; inline;
    class operator := (const v1: TMultiIntX4): double; inline;
    class operator +(const v1, v2: TMultiIntX4): TMultiIntX4; inline;
    class operator -(const v1, v2: TMultiIntX4): TMultiIntX4; inline;
    class operator Inc(const v1: TMultiIntX4): TMultiIntX4; inline;
    class operator Dec(const v1: TMultiIntX4): TMultiIntX4; inline;
    class operator >(const v1, v2: TMultiIntX4): boolean; inline;
    class operator <(const v1, v2: TMultiIntX4): boolean; inline;
    class operator =(const v1, v2: TMultiIntX4): boolean; inline;
    class operator <>(const v1, v2: TMultiIntX4): boolean; inline;
    class operator *(const v1, v2: TMultiIntX4): TMultiIntX4; inline;
    class operator div(const v1, v2: TMultiIntX4): TMultiIntX4; inline;
    class operator mod(const v1, v2: TMultiIntX4): TMultiIntX4; inline;
    class operator xor(const v1, v2: TMultiIntX4): TMultiIntX4; inline;
    class operator or(const v1, v2: TMultiIntX4): TMultiIntX4; inline;
    class operator and(const v1, v2: TMultiIntX4): TMultiIntX4; inline;
    class operator not(const v1: TMultiIntX4): TMultiIntX4; inline;
    class operator -(const v1: TMultiIntX4): TMultiIntX4; inline;
    class operator >=(const v1, v2: TMultiIntX4): boolean; inline;
    class operator <=(const v1, v2: TMultiIntX4): boolean; inline;
    class operator **(const v1: TMultiIntX4; const P: INT_2W_S): TMultiIntX4;
      inline;
    class operator shr(const v1: TMultiIntX4;
      const NBits: INT_1W_U): TMultiIntX4; inline;
    class operator shl(const v1: TMultiIntX4;
      const NBits: INT_1W_U): TMultiIntX4; inline;
  end;


  TMultiIntXV = record
  private
    Overflow_flag: boolean;
    Defined_flag: boolean;
    M_Value_Size: INT_2W_U;
    Negative_flag: TMultiUBool;
    M_Value: array of INT_1W_U;
  public
    procedure init; inline;
    function ToStr: ansistring; inline;
    function ToHex(const LZ: TMultiLeadingZeros = TrimLeadingZeros): ansistring; inline;
    function ToBin(const LZ: TMultiLeadingZeros = TrimLeadingZeros): ansistring; inline;
    function FromHex(const v1: ansistring): TMultiIntXV; inline;
    function FromBin(const v1: ansistring): TMultiIntXV; inline;
    function Overflow: boolean; inline;
    function Negative: boolean; inline;
    function Defined: boolean; inline;
    class operator := (const v1: TMultiIntXV): TMultiUInt8; inline;
    class operator := (const v1: TMultiIntXV): TMultiInt8; inline;
    class operator := (const v1: TMultiIntXV): INT_1W_U; inline;
    class operator := (const v1: TMultiIntXV): INT_1W_S; inline;
    class operator := (const v1: TMultiIntXV): INT_2W_U; inline;
    class operator := (const v1: TMultiIntXV): INT_2W_S; inline;
    class operator := (const v1: TMultiIntX2): TMultiIntXV; inline;
    class operator := (const v1: TMultiIntX3): TMultiIntXV; inline;
    class operator := (const v1: TMultiIntX4): TMultiIntXV; inline;
    class operator := (const v1: INT_2W_S): TMultiIntXV; inline;
    class operator := (const v1: INT_2W_U): TMultiIntXV; inline;
    {$ifdef CPU_32}
    class operator := (const v1: INT_4W_S): TMultiIntXV; inline;
    class operator := (const v1: INT_4W_U): TMultiIntXV; inline;
    {$endif}
    class operator := (const v1: ansistring): TMultiIntXV; inline;
    class operator := (const v1: TMultiIntXV): ansistring; inline;
    class operator := (const v1: single): TMultiIntXV; inline;
    class operator := (const v1: TMultiIntXV): single; inline;
    class operator := (const v1: real): TMultiIntXV; inline;
    class operator := (const v1: TMultiIntXV): real; inline;
    class operator := (const v1: double): TMultiIntXV; inline;
    class operator := (const v1: TMultiIntXV): double; inline;
    class operator +(const v1, v2: TMultiIntXV): TMultiIntXV; inline;
    class operator >(const v1, v2: TMultiIntXV): boolean; inline;
    class operator <(const v1, v2: TMultiIntXV): boolean; inline;
    class operator =(const v1, v2: TMultiIntXV): boolean; inline;
    class operator <>(const v1, v2: TMultiIntXV): boolean; inline;
    class operator -(const v1, v2: TMultiIntXV): TMultiIntXV; inline;
    class operator Inc(const v1: TMultiIntXV): TMultiIntXV; inline;
    class operator Dec(const v1: TMultiIntXV): TMultiIntXV; inline;
    class operator *(const v1, v2: TMultiIntXV): TMultiIntXV; inline;
    class operator div(const v1, v2: TMultiIntXV): TMultiIntXV; inline;
    class operator mod(const v1, v2: TMultiIntXV): TMultiIntXV; inline;
    class operator xor(const v1, v2: TMultiIntXV): TMultiIntXV; inline;
    class operator or(const v1, v2: TMultiIntXV): TMultiIntXV; inline;
    class operator and(const v1, v2: TMultiIntXV): TMultiIntXV; inline;
    class operator not(const v1: TMultiIntXV): TMultiIntXV; inline;
    class operator -(const v1: TMultiIntXV): TMultiIntXV; inline;
    class operator >=(const v1, v2: TMultiIntXV): boolean; inline;
    class operator <=(const v1, v2: TMultiIntXV): boolean; inline;
    class operator **(const v1: TMultiIntXV; const P: INT_2W_S): TMultiIntXV;
      inline;
    class operator shr(const v1: TMultiIntXV;
      const NBits: INT_2W_U): TMultiIntXV; inline;
    class operator shl(const v1: TMultiIntXV;
      const NBits: INT_2W_U): TMultiIntXV; inline;
  end;

var
  Multi_Int_RAISE_EXCEPTIONS_ENABLED: boolean = True;
  Multi_Int_ERROR:     boolean = False;
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

function Odd(const v1: TMultiIntXV): boolean; overload; inline;
function Odd(const v1: TMultiIntX4): boolean; overload; inline;
function Odd(const v1: TMultiIntX3): boolean; overload; inline;
function Odd(const v1: TMultiIntX2): boolean; overload; inline;

function Even(const v1: TMultiIntXV): boolean; overload; inline;
function Even(const v1: TMultiIntX4): boolean; overload; inline;
function Even(const v1: TMultiIntX3): boolean; overload; inline;
function Even(const v1: TMultiIntX2): boolean; overload; inline;

function Abs(const v1: TMultiIntX2): TMultiIntX2; overload; inline;
function Abs(const v1: TMultiIntX3): TMultiIntX3; overload; inline;
function Abs(const v1: TMultiIntX4): TMultiIntX4; overload; inline;
function Abs(const v1: TMultiIntXV): TMultiIntXV; overload; inline;

function Negative(const v1: TMultiIntX2): boolean; overload; inline;
function Negative(const v1: TMultiIntX3): boolean; overload; inline;
function Negative(const v1: TMultiIntX4): boolean; overload; inline;
function Negative(const v1: TMultiIntXV): boolean; overload; inline;

procedure SqRoot(const v1: TMultiIntXV; out VR, VREM: TMultiIntXV); overload; inline;
procedure SqRoot(const v1: TMultiIntX4; out VR, VREM: TMultiIntX4); overload; inline;
procedure SqRoot(const v1: TMultiIntX3; out VR, VREM: TMultiIntX3); overload; inline;
procedure SqRoot(const v1: TMultiIntX2; out VR, VREM: TMultiIntX2); overload; inline;

procedure SqRoot(const v1: TMultiIntXV; out VR: TMultiIntXV); overload; inline;
procedure SqRoot(const v1: TMultiIntX4; out VR: TMultiIntX4); overload; inline;
procedure SqRoot(const v1: TMultiIntX3; out VR: TMultiIntX3); overload; inline;
procedure SqRoot(const v1: TMultiIntX2; out VR: TMultiIntX2); overload; inline;

function SqRoot(const v1: TMultiIntXV): TMultiIntXV; overload; inline;
function SqRoot(const v1: TMultiIntX4): TMultiIntX4; overload; inline;
function SqRoot(const v1: TMultiIntX3): TMultiIntX3; overload; inline;
function SqRoot(const v1: TMultiIntX2): TMultiIntX2; overload; inline;

procedure FromHex(const v1: ansistring; out v2: TMultiIntX2); overload; inline;
procedure FromHex(const v1: ansistring; out v2: TMultiIntX3); overload; inline;
procedure FromHex(const v1: ansistring; out v2: TMultiIntX4); overload; inline;
procedure FromHex(const v1: ansistring; out v2: TMultiIntXV); overload; inline;

procedure FromBin(const v1: ansistring; out mi: TMultiIntX2); overload; inline;
procedure FromBin(const v1: ansistring; out mi: TMultiIntX3); overload; inline;
procedure FromBin(const v1: ansistring; out mi: TMultiIntX4); overload; inline;
procedure FromBin(const v1: ansistring; out mi: TMultiIntXV); overload; inline;

procedure Hex_to_Multi_Int_X2(const v1: ansistring; out mi: TMultiIntX2); overload; inline;
procedure Hex_to_Multi_Int_X3(const v1: ansistring; out mi: TMultiIntX3); overload; inline;
procedure Hex_to_Multi_Int_X4(const v1: ansistring; out mi: TMultiIntX4); overload; inline;
procedure Hex_to_Multi_Int_XV(const v1: ansistring; out mi: TMultiIntXV); overload; inline;

procedure bin_to_Multi_Int_X2(const v1: ansistring; out mi: TMultiIntX2); overload; inline;
procedure bin_to_Multi_Int_X3(const v1: ansistring; out mi: TMultiIntX3); overload; inline;
procedure bin_to_Multi_Int_X4(const v1: ansistring; out mi: TMultiIntX4); overload; inline;
procedure bin_to_Multi_Int_XV(const v1: ansistring; out mi: TMultiIntXV); overload; inline;

function To_Multi_Int_XV(const v1: TMultiIntX4): TMultiIntXV; overload; inline;
function To_Multi_Int_XV(const v1: TMultiIntX3): TMultiIntXV; overload; inline;
function To_Multi_Int_XV(const v1: TMultiIntX2): TMultiIntXV; overload; inline;

function To_Multi_Int_X4(const v1: TMultiIntXV): TMultiIntX4; overload; inline;
function To_Multi_Int_X4(const v1: TMultiIntX3): TMultiIntX4; overload; inline;
function To_Multi_Int_X4(const v1: TMultiIntX2): TMultiIntX4; overload; inline;

function To_Multi_Int_X3(const v1: TMultiIntXV): TMultiIntX3; overload; inline;
function To_Multi_Int_X3(const v1: TMultiIntX4): TMultiIntX3; overload; inline;
function To_Multi_Int_X3(const v1: TMultiIntX2): TMultiIntX3; overload; inline;

function To_Multi_Int_X2(const v1: TMultiIntXV): TMultiIntX2; overload; inline;
function To_Multi_Int_X2(const v1: TMultiIntX4): TMultiIntX2; overload; inline;
function To_Multi_Int_X2(const v1: TMultiIntX3): TMultiIntX2; overload; inline;


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
    class operator := (const v1: INT_2W_U): Multi_Int_X5;
    class operator := (const v1: TMultiIntX4): Multi_Int_X5;
    class operator >=(const v1, v2: Multi_Int_X5): boolean;
    class operator >(const v1, v2: Multi_Int_X5): boolean;
    class operator *(const v1, v2: Multi_Int_X5): Multi_Int_X5;
    class operator -(const v1, v2: Multi_Int_X5): Multi_Int_X5;
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

procedure ShiftUp_NBits_Multi_Int_X3(var v1: TMultiIntX3; NBits: INT_1W_U);
  forward; inline;
procedure ShiftDown_MultiBits_Multi_Int_X3(var v1: TMultiIntX3; NBits: INT_1W_U);
  forward; inline;
procedure ShiftUp_NBits_Multi_Int_X4(var v1: TMultiIntX4; NBits: INT_1W_U);
  forward; inline;
procedure ShiftDown_MultiBits_Multi_Int_X4(var v1: TMultiIntX4; NBits: INT_1W_U);
  forward; inline;
procedure ShiftUp_NBits_Multi_Int_X5(var v1: Multi_Int_X5; NBits: INT_1W_U);
  forward; inline;
procedure ShiftDown_MultiBits_Multi_Int_X5(var v1: Multi_Int_X5; NBits: INT_1W_U);
  forward; inline;
function To_Multi_Int_X5(const v1: TMultiIntX4): Multi_Int_X5; forward; inline;
function Multi_Int_X2_to_X3_multiply(const v1, v2: TMultiIntX2): TMultiIntX3;
  forward; inline;
function Multi_Int_X3_to_X4_multiply(const v1, v2: TMultiIntX3): TMultiIntX4;
  forward; inline;
function Multi_Int_X4_to_X5_multiply(const v1, v2: TMultiIntX4): Multi_Int_X5;
  forward; inline;
function To_Multi_Int_X4(const v1: Multi_Int_X5): TMultiIntX4; forward;
  overload; inline;

(******************************************)
procedure TMultiUBool.Initialize(AValue: TMultiUBoolState);
begin
  if (AValue = uBoolTrue) then
  begin
    FValue := uBoolTrue;
  end
  else if (AValue = uBoolFalse) then
  begin
    FValue := uBoolFalse;
  end
  else
  begin
    FValue := uBoolUndefined;
  end;
end;

function TMultiUBool.ToString: ansistring;
begin
  if (FValue = uBoolTrue) then
  begin
    Result := 'TRUE';
  end
  else if (FValue = uBoolFalse) then
  begin
    Result := 'FALSE';
  end
  else
  begin
    Result := 'UNDEFINED';
  end;
end;

class operator TMultiUBool.:=(AValue: TMultiUBoolState): TMultiUBool;
begin
  Result.FValue := AValue;
end;

class operator TMultiUBool.:=(AValue: TMultiUBool): TMultiUBoolState;
begin
  Result := AValue.FValue;
end;

class operator TMultiUBool.:=(AValue: boolean): TMultiUBool;
begin
  if AValue then
  begin
    Result.FValue := uBoolTrue;
  end
  else
  begin
    Result.FValue := uBoolFalse;
  end;
end;

class operator TMultiUBool.:=(AValue: TMultiUBool): boolean;
begin
  if (AValue.FValue = uBoolTrue) then
  begin
    Result := True;
  end
  else
  begin
    Result := False;
  end;
end;

class operator TMultiUBool.=(A, B: TMultiUBool): boolean;
begin
  if (A.FValue = B.FValue) then
  begin
    Result := True;
  end
  else
  begin
    Result := False;
  end;
end;

class operator TMultiUBool.<>(A, B: TMultiUBool): boolean;
begin
  if (A.FValue <> B.FValue) then
  begin
    Result := True;
  end
  else
  begin
    Result := False;
  end;
end;

class operator TMultiUBool.or(A, B: TMultiUBool): boolean;
begin
  if (A.FValue = uBoolTrue) or (B.FValue = uBoolTrue) then
  begin
    Result := True;
  end
  else
  begin
    Result := False;
  end;
end;

class operator TMultiUBool.or(A: TMultiUBool; B: boolean): boolean;
begin
  if (A.FValue = uBoolTrue) or (B) then
  begin
    Result := True;
  end
  else
  begin
    Result := False;
  end;
end;

class operator TMultiUBool.or(A: boolean; B: TMultiUBool): boolean;
begin
  if (A) or (B.FValue = uBoolTrue) then
  begin
    Result := True;
  end
  else
  begin
    Result := False;
  end;
end;

class operator TMultiUBool.and(A, B: TMultiUBool): boolean;
begin
  if (A.FValue = uBoolTrue) and (B.FValue = uBoolTrue) then
  begin
    Result := True;
  end
  else
  begin
    Result := False;
  end;
end;

class operator TMultiUBool.and(A: TMultiUBool; B: boolean): boolean;
begin
  if (A.FValue = uBoolTrue) and (B) then
  begin
    Result := True;
  end
  else
  begin
    Result := False;
  end;
end;

class operator TMultiUBool.and(A: boolean; B: TMultiUBool): boolean;
begin
  if (A) and (B.FValue = uBoolTrue) then
  begin
    Result := True;
  end
  else
  begin
    Result := False;
  end;
end;

class operator TMultiUBool.not(A: TMultiUBool): boolean;
begin
  if (A.FValue = uBoolTrue) then
  begin
    Result := False;
  end
  else if (A.FValue = uBoolFalse) then
  begin
    Result := True;
  end
  else
  begin
    Result := False;
  end;
end;


{$ifdef CPU_32}
(******************************************)
function nlz_bits(P_x: INT_1W_U): INT_1W_U;
var
  n: TMultiInt32;
  x, t: INT_1W_U;
begin
  if (P_x = 0) then
  begin
    Result := 16;
  end
  else
  begin
    x := P_x;
    n := 0;
    t := (x and INT_1W_U(65280));
    if (t = 0) then
    begin
      n := (n + 8);
      x := (x << 8);
    end;

    t := (x and INT_1W_U(61440));
    if (t = 0) then
    begin
      n := (n + 4);
      x := (x << 4);
    end;

    t := (x and INT_1W_U(49152));
    if (t = 0) then
    begin
      n := (n + 2);
      x := (x << 2);
    end;

    t := (x and INT_1W_U(32768));
    if (t = 0) then
    begin
      n := (n + 1);
    end;
    Result := n;
  end;
end;

{$endif}


{$ifdef CPU_64}
(******************************************)
function nlz_bits(x:INT_1W_U):INT_1W_U;
var     n       :TMultiInt32;
begin
if (x = 0) then Result:= 32
else
        begin
        n:= 1;
        if      ((x >> 16) = 0) then begin n:=(n + 16); x:=(x << 16); end;
        if      ((x >> 24) = 0) then begin n:=(n + 8); x:=(x << 8); end;
        if      ((x >> 28) = 0) then begin n:=(n + 4); x:=(x << 4); end;
        if      ((x >> 30) = 0) then begin n:=(n + 2); x:=(x << 2); end;
        n:= (n - (x >> 31));
        Result:= n;
        end;
end;
{$endif}


{
******************************************
TMultiIntX2
******************************************
}

function ABS_greaterthan_Multi_Int_X2(const v1, v2: TMultiIntX2): boolean;
begin
  if (v1.FParts[3] > v2.FParts[3]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.FParts[3] < v2.FParts[3]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.FParts[2] > v2.FParts[2]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.FParts[2] < v2.FParts[2]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.FParts[1] > v2.FParts[1]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.FParts[1] < v2.FParts[1]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.FParts[0] > v2.FParts[0]) then
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
function ABS_lessthan_Multi_Int_X2(const v1, v2: TMultiIntX2): boolean;
begin
  if (v1.FParts[3] < v2.FParts[3]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.FParts[3] > v2.FParts[3]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.FParts[2] < v2.FParts[2]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.FParts[2] > v2.FParts[2]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.FParts[1] < v2.FParts[1]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.FParts[1] > v2.FParts[1]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.FParts[0] < v2.FParts[0]) then
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
function ABS_equal_Multi_Int_X2(const v1, v2: TMultiIntX2): boolean;
begin
  Result := True;
  if (v1.FParts[3] <> v2.FParts[3]) then
  begin
    Result := False;
  end
  else
  if (v1.FParts[2] <> v2.FParts[2]) then
  begin
    Result := False;
  end
  else
  if (v1.FParts[1] <> v2.FParts[1]) then
  begin
    Result := False;
  end
  else
  if (v1.FParts[0] <> v2.FParts[0]) then
  begin
    Result := False;
  end;
end;


(******************************************)
function ABS_notequal_Multi_Int_X2(const v1, v2: TMultiIntX2): boolean;
begin
  Result := (not ABS_equal_Multi_Int_X2(v1, v2));
end;


(******************************************)
function nlz_words_X2(m: TMultiIntX2): INT_1W_U;
var
  i, n: TMultiInt32;
  fini: boolean;
begin
  n    := 0;
  i    := Multi_X2_maxi;
  fini := False;
  repeat
    if (i < 0) then
    begin
      fini := True;
    end
    else if (m.FParts[i] <> 0) then
    begin
      fini := True;
    end
    else
    begin
      Inc(n);
      Dec(i);
    end;
  until fini;
  Result := n;
end;


(******************************************)
function nlz_MultiBits_X2(const v1: TMultiIntX2): INT_1W_U;
var
  w: INT_1W_U;
begin
  if (not v1.FIsDefined) then
  begin
    Result := 0;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
  end;

  w := nlz_words_X2(v1);
  if (w <= Multi_X2_maxi) then
  begin
    Result :=
      nlz_bits(v1.FParts[Multi_X2_maxi - w]) + (w * INT_1W_SIZE);
  end
  else
  begin
    Result := (w * INT_1W_SIZE);
  end;
end;


(******************************************)
function TMultiIntX2.IsDefined: boolean; inline;
begin
  Result := self.FIsDefined;
end;


(******************************************)
function TMultiIntX2.HasOverflow: boolean; inline;
begin
  Result := self.FHasOverflow;
end;


(******************************************)
function Overflow(const v1: TMultiIntX2): boolean; overload; inline;
begin
  Result := v1.FHasOverflow;
end;


(******************************************)
function TMultiIntX2.IsNegative: boolean; inline;
begin
  Result := self.FIsNegative;
end;


(******************************************)
function Negative(const v1: TMultiIntX2): boolean; overload; inline;
begin
  Result := v1.FIsNegative;
end;


(******************************************)
function Abs(const v1: TMultiIntX2): TMultiIntX2; overload;
begin
  Result := v1;
  Result.FIsNegative := uBoolFalse;

  if (not v1.FIsDefined) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
  end;
end;


(******************************************)
function Defined(const v1: TMultiIntX2): boolean; overload; inline;
begin
  Result := v1.FIsDefined;
end;


(******************************************)
function Multi_Int_X2_Odd(const v1: TMultiIntX2): boolean; inline;
var
  bit1_mask: INT_1W_U;
begin
  bit1_mask := $1;

  if ((v1.FParts[0] and bit1_mask) = bit1_mask) then
  begin
    Result := True;
  end
  else
  begin
    Result := False;
  end;

  if (not v1.FIsDefined) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
  end;

end;


(******************************************)
function Odd(const v1: TMultiIntX2): boolean; overload;
begin
  Result := Multi_Int_X2_Odd(v1);
end;


(******************************************)
function Multi_Int_X2_Even(const v1: TMultiIntX2): boolean; inline;
var
  bit1_mask: INT_1W_U;
begin

  bit1_mask := $1;

  if ((v1.FParts[0] and bit1_mask) = bit1_mask) then
  begin
    Result := False;
  end
  else
  begin
    Result := True;
  end;

  if (not v1.FIsDefined) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
  end;

end;


(******************************************)
function Even(const v1: TMultiIntX2): boolean; overload;
begin
  Result := Multi_Int_X2_Even(v1);
end;


{$ifdef CPU_32}
(******************************************)
procedure ShiftUp_NBits_Multi_Int_X2(var v1: TMultiIntX2; NBits: INT_1W_U);
var
  carry_bits_1, carry_bits_2, carry_bits_mask, NBits_max, NBits_carry: INT_1W_U;

  procedure INT_1W_U_shl(var v1: INT_1W_U; const nbits: INT_1W_U); inline;
  var
    carry_bits_mask_2w: INT_2W_U;
  begin
    carry_bits_mask_2w := v1;
    carry_bits_mask_2w := (carry_bits_mask_2w << NBits);
    v1 := INT_1W_U(carry_bits_mask_2w and INT_1W_U_MAXINT);
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
      carry_bits_1 := ((v1.FParts[0] and carry_bits_mask) >> NBits_carry);
      INT_1W_U_shl(v1.FParts[0], NBits);

      carry_bits_2 := ((v1.FParts[1] and carry_bits_mask) >> NBits_carry);
      INT_1W_U_shl(v1.FParts[1], NBits);
      v1.FParts[1] := (v1.FParts[1] or carry_bits_1);

      carry_bits_1 := ((v1.FParts[2] and carry_bits_mask) >> NBits_carry);
      INT_1W_U_shl(v1.FParts[2], NBits);
      v1.FParts[2] := (v1.FParts[2] or carry_bits_2);

      INT_1W_U_shl(v1.FParts[3], NBits);
      v1.FParts[3] := (v1.FParts[3] or carry_bits_1);
    end;
  end;

end;
{$endif}

{$ifdef CPU_64}
(******************************************)
procedure ShiftUp_NBits_Multi_Int_X2(Var v1:TMultiIntX2; NBits:INT_1W_U);
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
                carry_bits_1:= ((v1.FParts[0] and carry_bits_mask) >> NBits_carry);
                v1.FParts[0]:= (v1.FParts[0] << NBits);

                carry_bits_2:= ((v1.FParts[1] and carry_bits_mask) >> NBits_carry);
                v1.FParts[1]:= ((v1.FParts[1] << NBits) OR carry_bits_1);

                carry_bits_1:= ((v1.FParts[2] and carry_bits_mask) >> NBits_carry);
                v1.FParts[2]:= ((v1.FParts[2] << NBits) OR carry_bits_2);

                v1.FParts[3]:= ((v1.FParts[3] << NBits) OR carry_bits_1);
                end;
        end;

end;
{$endif}


(******************************************)
procedure ShiftUp_NWords_Multi_Int_X2(var v1: TMultiIntX2; NWords: INT_1W_U);
var
  n: INT_1W_U;
begin
  if (NWords > 0) then
  begin
    if (NWords <= Multi_X2_maxi) then
    begin
      n := NWords;
      while (n > 0) do
      begin
        v1.FParts[3] := v1.FParts[2];
        v1.FParts[2] := v1.FParts[1];
        v1.FParts[1] := v1.FParts[0];
        v1.FParts[0] := 0;
        Dec(n);
      end;
    end
    else
    begin
      v1.FParts[0] := 0;
      v1.FParts[1] := 0;
      v1.FParts[2] := 0;
      v1.FParts[3] := 0;
    end;
  end;
end;


{******************************************}
procedure ShiftUp_MultiBits_Multi_Int_X2(var v1: TMultiIntX2; NBits: INT_1W_U);
var
  NWords_count, NBits_count: INT_1W_U;
begin
  if (not v1.FIsDefined) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (NBits > 0) then
  begin
    if (NBits >= INT_1W_SIZE) then
    begin
      NWords_count := (NBits div INT_1W_SIZE);
      NBits_count  := (NBits mod INT_1W_SIZE);
      ShiftUp_NWords_Multi_Int_X2(v1, NWords_count);
    end
    else
    begin
      NBits_count := NBits;
    end;
    ShiftUp_NBits_Multi_Int_X2(v1, NBits_count);
  end;
end;


(******************************************)
procedure ShiftDown_NBits_Multi_Int_X2(var v1: TMultiIntX2; NBits: INT_1W_U);
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
    carry_bits_mask := (carry_bits_mask >> NBits_carry);

    if NBits <= NBits_max then
    begin
      carry_bits_1 := ((v1.FParts[3] and carry_bits_mask) << NBits_carry);
      v1.FParts[3] := (v1.FParts[3] >> NBits);

      carry_bits_2 := ((v1.FParts[2] and carry_bits_mask) << NBits_carry);
      v1.FParts[2] := ((v1.FParts[2] >> NBits) or carry_bits_1);

      carry_bits_1 := ((v1.FParts[1] and carry_bits_mask) << NBits_carry);
      v1.FParts[1] := ((v1.FParts[1] >> NBits) or carry_bits_2);

      v1.FParts[0] := ((v1.FParts[0] >> NBits) or carry_bits_1);
    end;
  end;

end;


(******************************************)
procedure ShiftDown_NWords_Multi_Int_X2(var v1: TMultiIntX2; NWords: INT_1W_U);
var
  n: INT_1W_U;
begin
  if (NWords > 0) then
  begin
    if (NWords <= Multi_X2_maxi) then
    begin
      n := NWords;
      while (n > 0) do
      begin
        v1.FParts[0] := v1.FParts[1];
        v1.FParts[1] := v1.FParts[2];
        v1.FParts[2] := v1.FParts[3];
        v1.FParts[3] := 0;
        Dec(n);
      end;
    end
    else
    begin
      v1.FParts[0] := 0;
      v1.FParts[1] := 0;
      v1.FParts[2] := 0;
      v1.FParts[3] := 0;
    end;
  end;
end;


{******************************************}
procedure ShiftDown_MultiBits_Multi_Int_X2(var v1: TMultiIntX2; NBits: INT_1W_U);
var
  NWords_count, NBits_count: INT_1W_U;
begin
  if (not v1.FIsDefined) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (NBits >= INT_1W_SIZE) then
  begin
    NWords_count := (NBits div INT_1W_SIZE);
    NBits_count  := (NBits mod INT_1W_SIZE);
    ShiftDown_NWords_Multi_Int_X2(v1, NWords_count);
  end
  else
  begin
    NBits_count := NBits;
  end;

  ShiftDown_NBits_Multi_Int_X2(v1, NBits_count);
end;


{******************************************}
class operator TMultiIntX2.shl(const A: TMultiIntX2;
  const B: INT_1W_U): TMultiIntX2;
begin
  Result := A;
  ShiftUp_MultiBits_Multi_Int_X2(Result, B);
end;


{******************************************}
class operator TMultiIntX2.shr(const A: TMultiIntX2;
  const B: INT_1W_U): TMultiIntX2;
begin
  Result := A;
  ShiftDown_MultiBits_Multi_Int_X2(Result, B);
end;


(******************************************)
class operator TMultiIntX2.<=(const A, B: TMultiIntX2): boolean;
begin
  if (not A.FIsDefined) or (not B.FIsDefined) or (A.FHasOverflow) or
    (B.FHasOverflow) then
  begin
    Result := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Result := False;
  if ((A.FIsNegative = False) and (B.FIsNegative = True)) then
  begin
    Result := False;
  end
  else
  if ((A.FIsNegative = True) and (B.FIsNegative = False)) then
  begin
    Result := True;
  end
  else
  if ((A.FIsNegative = False) and (B.FIsNegative = False)) then
  begin
    Result := (not ABS_greaterthan_Multi_Int_X2(A, B));
  end
  else
  if ((A.FIsNegative = True) and (B.FIsNegative = True)) then
  begin
    Result := (not ABS_lessthan_Multi_Int_X2(A, B));
  end;
end;


(******************************************)
class operator TMultiIntX2.>=(const A, B: TMultiIntX2): boolean;
begin
  if (not A.FIsDefined) or (not B.FIsDefined) or (A.FHasOverflow) or
    (B.FHasOverflow) then
  begin
    Result := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Result := False;
  if ((A.FIsNegative = False) and (B.FIsNegative = True)) then
  begin
    Result := True;
  end
  else
  if ((A.FIsNegative = True) and (B.FIsNegative = False)) then
  begin
    Result := False;
  end
  else
  if ((A.FIsNegative = False) and (B.FIsNegative = False)) then
  begin
    Result := (not ABS_lessthan_Multi_Int_X2(A, B));
  end
  else
  if ((A.FIsNegative = True) and (B.FIsNegative = True)) then
  begin
    Result := (not ABS_greaterthan_Multi_Int_X2(A, B));
  end;
end;


(******************************************)
class operator TMultiIntX2.>(const A, B: TMultiIntX2): boolean;
begin
  if (not A.FIsDefined) or (not B.FIsDefined) or (A.FHasOverflow) or
    (B.FHasOverflow) then
  begin
    Result := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Result := False;
  if ((A.FIsNegative = False) and (B.FIsNegative = True)) then
  begin
    Result := True;
  end
  else
  if ((A.FIsNegative = True) and (B.FIsNegative = False)) then
  begin
    Result := False;
  end
  else
  if ((A.FIsNegative = False) and (B.FIsNegative = False)) then
  begin
    Result := ABS_greaterthan_Multi_Int_X2(A, B);
  end
  else
  if ((A.FIsNegative = True) and (B.FIsNegative = True)) then
  begin
    Result := ABS_lessthan_Multi_Int_X2(A, B);
  end;
end;


(******************************************)
class operator TMultiIntX2.<(const A, B: TMultiIntX2): boolean;
begin
  if (not A.FIsDefined) or (not B.FIsDefined) or (A.FHasOverflow) or
    (B.FHasOverflow) then
  begin
    Result := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Result := False;
  if ((A.FIsNegative = True) and (B.FIsNegative = False)) then
  begin
    Result := True;
  end
  else
  if ((A.FIsNegative = False) and (B.FIsNegative = False)) then
  begin
    Result := ABS_lessthan_Multi_Int_X2(A, B);
  end
  else
  if ((A.FIsNegative = True) and (B.FIsNegative = True)) then
  begin
    Result := ABS_greaterthan_Multi_Int_X2(A, B);
  end;
end;


(******************************************)
class operator TMultiIntX2.=(const A, B: TMultiIntX2): boolean;
begin
  if (not A.FIsDefined) or (not B.FIsDefined) or (A.FHasOverflow) or
    (B.FHasOverflow) then
  begin
    Result := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Result := True;
  if (A.FIsNegative <> B.FIsNegative) then
  begin
    Result := False;
  end
  else
  begin
    Result := ABS_equal_Multi_Int_X2(A, B);
  end;
end;


(******************************************)
class operator TMultiIntX2.<>(const A, B: TMultiIntX2): boolean;
begin
  if (not A.FIsDefined) or (not B.FIsDefined) or (A.FHasOverflow) or
    (B.FHasOverflow) then
  begin
    Result := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Result := False;
  if (A.FIsNegative <> B.FIsNegative) then
  begin
    Result := True;
  end
  else
  begin
    Result := (not ABS_equal_Multi_Int_X2(A, B));
  end;
end;


(******************************************)
procedure String_to_Multi_Int_X2(const v1: ansistring; out mi: TMultiIntX2); inline;
label
  999;
var
  i, b, c, e: INT_2W_U;
  M_Val: array[0..Multi_X2_maxi] of INT_2W_U;
  Signeg, Zeroneg: boolean;
begin
  Multi_Int_ERROR := False;

  mi.FHasOverflow := False;
  mi.FIsDefined := True;
  mi.FIsNegative := False;
  Signeg  := False;
  Zeroneg := False;

  M_Val[0] := 0;
  M_Val[1] := 0;
  M_Val[2] := 0;
  M_Val[3] := 0;

  if (length(v1) > 0) then
  begin
    b := low(ansistring);
    e := b + INT_2W_U(length(v1)) - 1;
    if (v1[b] = '-') then
    begin
      Signeg := True;
      Inc(b);
    end;

    c := b;
    while (c <= e) do
    begin
      try
        i := StrToInt(v1[c]);
      except
        on EConvertError do
        begin
          Multi_Int_ERROR := True;
          mi.FHasOverflow := True;
          mi.FIsDefined   := False;
          if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
          begin
            raise;
          end;
        end;
      end;
      if mi.FIsDefined = False then
      begin
        goto 999;
      end;
      M_Val[0] := (M_Val[0] * 10) + i;
      M_Val[1] := (M_Val[1] * 10);
      M_Val[2] := (M_Val[2] * 10);
      M_Val[3] := (M_Val[3] * 10);

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
        Multi_Int_ERROR := True;
        mi.FIsDefined   := False;
        mi.FHasOverflow := True;
        if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
        begin
          raise EIntOverflow.Create('Overflow');
        end;
        goto 999;
      end;

      Inc(c);
    end;
  end;

  mi.FParts[0] := M_Val[0];
  mi.FParts[1] := M_Val[1];
  mi.FParts[2] := M_Val[2];
  mi.FParts[3] := M_Val[3];

  if (M_Val[0] = 0) and (M_Val[1] = 0) and (M_Val[2] = 0) and (M_Val[3] = 0) then
  begin
    Zeroneg := True;
  end;

  if Zeroneg then
  begin
    mi.FIsNegative := uBoolFalse;
  end
  else if Signeg then
  begin
    mi.FIsNegative := uBoolTrue;
  end
  else
  begin
    mi.FIsNegative := uBoolFalse;
  end;

  999: ;
end;


(******************************************)
function To_Multi_Int_X2(const v1: TMultiIntX3): TMultiIntX2;
var
  n: INT_1W_U;
begin
  Result.FHasOverflow := v1.Overflow_flag;
  Result.FIsDefined   := v1.Defined_flag;
  Result.FIsNegative  := v1.Negative_flag;

  if (v1.Defined_flag = False) then
  begin
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    Multi_Int_ERROR   := True;
    Result.FIsDefined := False;
    exit;
  end;

  if (v1.Overflow_flag = True) or (v1 > Multi_Int_X2_MAXINT) then
  begin
    Multi_Int_ERROR     := True;
    Result.FHasOverflow := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    Multi_Int_ERROR := True;
    exit;
  end;

  n := 0;
  while (n <= Multi_X2_maxi) do
  begin
    Result.FParts[n] := v1.M_Value[n];
    Inc(n);
  end;
end;


(******************************************)
function To_Multi_Int_X2(const v1: TMultiIntX4): TMultiIntX2;
var
  n: INT_1W_U;
begin
  Result.FHasOverflow := v1.Overflow_flag;
  Result.FIsDefined   := v1.Defined_flag;
  Result.FIsNegative  := v1.Negative_flag;

  if (v1.Defined_flag = False) then
  begin
    Multi_Int_ERROR   := True;
    Result.FIsDefined := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (v1.Overflow_flag = True) or (v1 > Multi_Int_X2_MAXINT) then
  begin
    Multi_Int_ERROR     := True;
    Result.FHasOverflow := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    exit;
  end;

  n := 0;
  while (n <= Multi_X2_maxi) do
  begin
    Result.FParts[n] := v1.M_Value[n];
    Inc(n);
  end;
end;


(******************************************)
function To_Multi_Int_X2(const v1: TMultiIntXV): TMultiIntX2;
label
  OVERFLOW_BRANCH, CLEAN_EXIT;
var
  n: INT_2W_U;
begin
  if (v1.Defined_flag = False) then
  begin
    Multi_Int_ERROR   := True;
    Result.FIsDefined := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (v1.Overflow_flag = True) then
  begin
    goto OVERFLOW_BRANCH;
  end;

  Result.FHasOverflow := v1.Overflow_flag;
  Result.FIsDefined   := v1.Defined_flag;
  Result.FIsNegative  := v1.Negative_flag;

  n := 0;
  if (Multi_XV_size > Multi_X2_size) then
  begin
    while (n <= Multi_X2_maxi) do
    begin
      Result.FParts[n] := v1.M_Value[n];
      Inc(n);
    end;
    while (n <= Multi_XV_maxi) do
    begin
      if (v1.M_Value[n] <> 0) then
      begin
        goto OVERFLOW_BRANCH;
      end;
      Inc(n);
    end;
  end
  else
  begin
    while (n <= Multi_XV_maxi) do
    begin
      Result.FParts[n] := v1.M_Value[n];
      Inc(n);
    end;
    while (n <= Multi_X2_maxi) do
    begin
      Result.FParts[n] := 0;
      Inc(n);
    end;
  end;

  goto CLEAN_EXIT;

  OVERFLOW_BRANCH:

    Multi_Int_ERROR   := True;
  Result.FHasOverflow := True;
  if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
  begin
    raise EInterror.Create('Overflow');
  end;
  exit;

  CLEAN_EXIT: ;

end;


(******************************************)
class operator TMultiIntX2.:=(const AValue: ansistring): TMultiIntX2;
begin
  String_to_Multi_Int_X2(AValue, Result);
end;


{$ifdef CPU_32}
(******************************************)
procedure INT_4W_S_to_Multi_Int_X2(const v1: INT_4W_S; out mi: TMultiIntX2); inline;
var
  v: INT_4W_U;
begin
  mi.FHasOverflow := False;
  mi.FIsDefined := True;
  v := Abs(v1);

  v := v1;
  mi.FParts[0] := INT_1W_U(v mod INT_1W_U_MAXINT_1);
  v := (v div INT_1W_U_MAXINT_1);
  mi.FParts[1] := INT_1W_U(v mod INT_1W_U_MAXINT_1);
  v := (v div INT_1W_U_MAXINT_1);
  mi.FParts[2] := INT_1W_U(v mod INT_1W_U_MAXINT_1);
  v := (v div INT_1W_U_MAXINT_1);
  mi.FParts[3] := v;

  if (v1 < 0) then
  begin
    mi.FIsNegative := uBoolTrue;
  end
  else
  begin
    mi.FIsNegative := uBoolFalse;
  end;

end;


(******************************************)
class operator TMultiIntX2.:=(const v1: INT_4W_S): TMultiIntX2;
begin
  INT_4W_S_to_Multi_Int_X2(v1, Result);
end;


(******************************************)
procedure INT_4W_U_to_Multi_Int_X2(const v1: INT_4W_U; out mi: TMultiIntX2); inline;
var
  v: INT_4W_U;
begin
  mi.FHasOverflow := False;
  mi.FIsDefined  := True;
  mi.FIsNegative := uBoolFalse;

  v := v1;
  mi.FParts[0] := INT_1W_U(v mod INT_1W_U_MAXINT_1);
  v := (v div INT_1W_U_MAXINT_1);
  mi.FParts[1] := INT_1W_U(v mod INT_1W_U_MAXINT_1);
  v := (v div INT_1W_U_MAXINT_1);
  mi.FParts[2] := INT_1W_U(v mod INT_1W_U_MAXINT_1);
  v := (v div INT_1W_U_MAXINT_1);
  mi.FParts[3] := v;

end;


(******************************************)
class operator TMultiIntX2.:=(const v1: INT_4W_U): TMultiIntX2;
begin
  INT_4W_U_to_Multi_Int_X2(v1, Result);
end;
{$endif}


(******************************************)
procedure INT_2W_S_to_Multi_Int_X2(const v1: INT_2W_S; out mi: TMultiIntX2); inline;
begin
  mi.FHasOverflow := False;
  mi.FIsDefined   := True;
  mi.FParts[2]    := 0;
  mi.FParts[3]    := 0;

  if (v1 < 0) then
  begin
    mi.FIsNegative := uBoolTrue;
    mi.FParts[0]   := (ABS(v1) mod INT_1W_U_MAXINT_1);
    mi.FParts[1]   := (ABS(v1) div INT_1W_U_MAXINT_1);
  end
  else
  begin
    mi.FIsNegative := uBoolFalse;
    mi.FParts[0]   := (v1 mod INT_1W_U_MAXINT_1);
    mi.FParts[1]   := (v1 div INT_1W_U_MAXINT_1);
  end;

end;


(******************************************)
class operator TMultiIntX2.:=(const AValue: INT_2W_S): TMultiIntX2;
begin
  INT_2W_S_to_Multi_Int_X2(AValue, Result);
end;


(******************************************)
procedure INT_2W_U_to_Multi_Int_X2(const v1: INT_2W_U; out mi: TMultiIntX2); inline;
begin
  mi.FHasOverflow := False;
  mi.FIsDefined   := True;
  mi.FIsNegative  := uBoolFalse;

  mi.FParts[0] := (v1 mod INT_1W_U_MAXINT_1);
  mi.FParts[1] := (v1 div INT_1W_U_MAXINT_1);
  mi.FParts[2] := 0;
  mi.FParts[3] := 0;
end;


(******************************************)
class operator TMultiIntX2.:=(const AValue: INT_2W_U): TMultiIntX2;
begin
  INT_2W_U_to_Multi_Int_X2(AValue, Result);
end;


(******************************************)
// WARNING Float to Multi_Int type conversion loses some precision
class operator TMultiIntX2.:=(const AValue: single): TMultiIntX2;
var
  R: TMultiIntX2;
  R_FLOATREC: TFloatRec;
begin
  Multi_Int_ERROR := False;

  FloatToDecimal(R_FLOATREC, AValue, SINGLE_TYPE_PRECISION_DIGITS, 0);
  String_to_Multi_Int_X2(AddCharR('0', AnsiLeftStr(R_FLOATREC.digits,
    (SINGLE_TYPE_PRECISION_DIGITS - 1)), R_FLOATREC.Exponent), R);

  if (R.HasOverflow) then
  begin
    Multi_Int_ERROR    := True;
    Result.FIsDefined  := False;
    Result.FIsNegative := uBoolUndefined;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  if (R_FLOATREC.Negative) then
  begin
    R.FIsNegative := True;
  end;
  Result := R;
end;


(******************************************)
// WARNING Float to Multi_Int type conversion loses some precision
class operator TMultiIntX2.:=(const AValue: real): TMultiIntX2;
var
  R: TMultiIntX2;
  R_FLOATREC: TFloatRec;
begin
  Multi_Int_ERROR := False;

  FloatToDecimal(R_FLOATREC, AValue, REAL_TYPE_PRECISION_DIGITS, 0);
  String_to_Multi_Int_X2(AddCharR('0', AnsiLeftStr(R_FLOATREC.digits,
    (REAL_TYPE_PRECISION_DIGITS - 1)), R_FLOATREC.Exponent), R);

  if (R.HasOverflow) then
  begin
    Multi_Int_ERROR    := True;
    Result.FIsDefined  := False;
    Result.FIsNegative := uBoolUndefined;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  if (R_FLOATREC.Negative) then
  begin
    R.FIsNegative := True;
  end;
  Result := R;
end;


(******************************************)
// WARNING Float to Multi_Int type conversion loses some precision
class operator TMultiIntX2.:=(const AValue: double): TMultiIntX2;
var
  R: TMultiIntX2;
  R_FLOATREC: TFloatRec;
begin
  Multi_Int_ERROR := False;

  FloatToDecimal(R_FLOATREC, AValue, DOUBLE_TYPE_PRECISION_DIGITS, 0);
  String_to_Multi_Int_X2(AddCharR('0', AnsiLeftStr(R_FLOATREC.digits,
    (DOUBLE_TYPE_PRECISION_DIGITS - 1)), R_FLOATREC.Exponent), R);

  if (R.HasOverflow) then
  begin
    Multi_Int_ERROR    := True;
    Result.FIsDefined  := False;
    Result.FIsNegative := uBoolUndefined;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  if (R_FLOATREC.Negative) then
  begin
    R.FIsNegative := True;
  end;
  Result := R;
end;


(******************************************)
class operator TMultiIntX2.:=(const AValue: TMultiIntX2): single;
var
  R, V, M: single;
  i: INT_1W_U;
  finished: boolean;
begin
  if (not AValue.FIsDefined) then
  begin
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Multi_Int_ERROR := False;
  finished := False;
  M := INT_1W_U_MAXINT_1;

  R := AValue.FParts[0];
  i := 1;
  while (i <= Multi_X2_maxi) and (not Multi_Int_ERROR) do
  begin
    if (not finished) then
    begin
      V := AValue.FParts[i];
      try
        begin
          V := (V * M);
          R := R + V;
        end
      except
        begin
          Multi_Int_ERROR := True;
          if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
          begin
            raise EIntOverflow.Create('Overflow');
          end;
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
    begin
      if (AValue.FParts[i] > 0) then
      begin
        Multi_Int_ERROR := True;
        if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
        begin
          raise EIntOverflow.Create('Overflow');
        end;
      end;
    end;
    Inc(i);
  end;

  if AValue.FIsNegative then
  begin
    R := (-R);
  end;
  Result := R;
end;


(******************************************)
class operator TMultiIntX2.:=(const AValue: TMultiIntX2): real;
var
  R, V, M: real;
  i: INT_1W_U;
  finished: boolean;
begin
  if (not AValue.FIsDefined) then
  begin
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Multi_Int_ERROR := False;
  finished := False;
  M := INT_1W_U_MAXINT_1;

  R := AValue.FParts[0];
  i := 1;
  while (i <= Multi_X2_maxi) and (not Multi_Int_ERROR) do
  begin
    if (not finished) then
    begin
      V := AValue.FParts[i];
      try
        begin
          V := (V * M);
          R := R + V;
        end
      except
        begin
          Multi_Int_ERROR := True;
          if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
          begin
            raise EIntOverflow.Create('Overflow');
          end;
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
    begin
      if (AValue.FParts[i] > 0) then
      begin
        Multi_Int_ERROR := True;
        if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
        begin
          raise EIntOverflow.Create('Overflow');
        end;
      end;
    end;
    Inc(i);
  end;

  if AValue.FIsNegative then
  begin
    R := (-R);
  end;
  Result := R;
end;


(******************************************)
class operator TMultiIntX2.:=(const AValue: TMultiIntX2): double;
var
  R, V, M: double;
  i: INT_1W_U;
  finished: boolean;
begin
  if (not AValue.FIsDefined) then
  begin
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Multi_Int_ERROR := False;
  finished := False;
  M := INT_1W_U_MAXINT_1;

  R := AValue.FParts[0];
  i := 1;
  while (i <= Multi_X2_maxi) and (not Multi_Int_ERROR) do
  begin
    if (not finished) then
    begin
      V := AValue.FParts[i];
      try
        begin
          V := (V * M);
          R := R + V;
        end
      except
        begin
          Multi_Int_ERROR := True;
          if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
          begin
            raise EIntOverflow.Create('Overflow');
          end;
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
    begin
      if (AValue.FParts[i] > 0) then
      begin
        Multi_Int_ERROR := True;
        if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
        begin
          raise EIntOverflow.Create('Overflow');
        end;
      end;
    end;
    Inc(i);
  end;

  if AValue.FIsNegative then
  begin
    R := (-R);
  end;
  Result := R;
end;


{******************************************}
class operator TMultiIntX2.:=(const AValue: TMultiIntX2): INT_2W_S;
var
  R: INT_2W_U;
begin
  Multi_Int_ERROR := False;
  if (not AValue.FIsDefined) then
  begin
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  R := (INT_2W_U(AValue.FParts[0]) + (INT_2W_U(AValue.FParts[1]) * INT_1W_U_MAXINT_1));

  if (R > INT_2W_S_MAXINT) or (AValue.FParts[2] <> 0) or (AValue.FParts[3] <> 0) then
  begin
    Result := 0;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    exit;
  end;

  if AValue.FIsNegative then
  begin
    Result := INT_2W_S(-R);
  end
  else
  begin
    Result := INT_2W_S(R);
  end;
end;


{******************************************}
class operator TMultiIntX2.:=(const AValue: TMultiIntX2): INT_2W_U;
var
  R: INT_2W_U;
begin
  Multi_Int_ERROR := False;
  if (not AValue.FIsDefined) then
  begin
    Result := 0;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  R := (INT_2W_U(AValue.FParts[1]) << INT_1W_SIZE);
  R := (R or INT_2W_U(AValue.FParts[0]));

  if (AValue.FParts[2] <> 0) or (AValue.FParts[3] <> 0) then
  begin
    Result := 0;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    exit;
  end;
  Result := R;
end;


{******************************************}
class operator TMultiIntX2.:=(const AValue: TMultiIntX2): INT_1W_S;
var
  R: INT_2W_U;
begin
  Multi_Int_ERROR := False;
  if (not AValue.FIsDefined) then
  begin
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  R := (INT_2W_U(AValue.FParts[0]) + (INT_2W_U(AValue.FParts[1]) * INT_1W_U_MAXINT_1));

  if (R > INT_1W_S_MAXINT) or (AValue.FParts[2] <> 0) or (AValue.FParts[3] <> 0) then
  begin
    Result := 0;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    exit;
  end;

  if AValue.FIsNegative then
  begin
    Result := INT_1W_S(-R);
  end
  else
  begin
    Result := INT_1W_S(R);
  end;
end;


{******************************************}
class operator TMultiIntX2.:=(const AValue: TMultiIntX2): INT_1W_U;
var
  R: INT_2W_U;
begin
  Multi_Int_ERROR := False;
  if (not AValue.FIsDefined) or (AValue.FIsNegative = uBoolTrue) then
  begin
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  R := (AValue.FParts[0] + (AValue.FParts[1] * INT_1W_U_MAXINT_1));
  if (R > INT_1W_U_MAXINT) or (AValue.FParts[2] <> 0) or (AValue.FParts[3] <> 0) then
  begin
    Result := 0;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    exit;
  end;

  Result := INT_1W_U(R);
end;


{******************************************}
class operator TMultiIntX2.:=(const AValue: TMultiIntX2): TMultiUInt8;
begin
  Multi_Int_ERROR := False;
  if (not AValue.FIsDefined) or (AValue.FIsNegative = uBoolTrue) then
  begin
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (AValue.FParts[0] > UINT8_MAX) or (AValue.FParts[1] <> 0) or (AValue.FParts[2] <> 0) or
    (AValue.FParts[3] <> 0) then
  begin
    Multi_Int_ERROR := True;
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    exit;
  end;

  Result := TMultiUInt8(AValue.FParts[0]);
end;


{******************************************}
class operator TMultiIntX2.:=(const AValue: TMultiIntX2): TMultiInt8;
begin
  Multi_Int_ERROR := False;
  if (not AValue.FIsDefined) or (AValue.FIsNegative = uBoolTrue) then
  begin
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (AValue.FParts[0] > INT8_MAX) or (AValue.FParts[1] <> 0) or (AValue.FParts[2] <> 0) or
    (AValue.FParts[3] <> 0) then
  begin
    Multi_Int_ERROR := True;
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    exit;
  end;

  Result := TMultiInt8(AValue.FParts[0]);
end;


(******************************************)
procedure bin_to_Multi_Int_X2(const v1: ansistring; out mi: TMultiIntX2); inline;
label
  999;
var
  n, b, c, e: INT_2W_U;
  bit: INT_1W_S;
  M_Val: array[0..Multi_X2_maxi] of INT_2W_U;
  Signeg, Zeroneg, M_Val_All_Zero: boolean;
begin
  Multi_Int_ERROR := False;

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

  if (length(v1) > 0) then
  begin
    b := low(ansistring);
    e := b + INT_2W_U(length(v1)) - 1;
    if (v1[b] = '-') then
    begin
      Signeg := True;
      Inc(b);
    end;

    c := b;
    while (c <= e) do
    begin
      bit := (Ord(v1[c]) - Ord('0'));
      if (bit > 1) or (bit < 0) then
      begin
        Multi_Int_ERROR := True;
        mi.FHasOverflow := True;
        mi.FIsDefined   := False;
        if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
        begin
          raise EInterror.Create('Invalid binary digit');
        end;
        goto 999;
      end;

      M_Val[0] := (M_Val[0] * 2) + bit;
      n := 1;
      while (n <= Multi_X2_maxi) do
      begin
        M_Val[n] := (M_Val[n] * 2);
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
        mi.FIsDefined   := False;
        mi.FHasOverflow := True;
        Multi_Int_ERROR := True;
        if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
        begin
          raise EIntOverflow.Create('Overflow');
        end;
        goto 999;
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
    begin
      M_Val_All_Zero := False;
    end;
    Inc(n);
  end;
  if M_Val_All_Zero then
  begin
    Zeroneg := True;
  end;

  if Zeroneg then
  begin
    mi.FIsNegative := uBoolFalse;
  end
  else if Signeg then
  begin
    mi.FIsNegative := uBoolTrue;
  end
  else
  begin
    mi.FIsNegative := uBoolFalse;
  end;

  999: ;
end;


(******************************************)
procedure FromBin(const v1: ansistring; out mi: TMultiIntX2); overload;
begin
  Bin_to_Multi_Int_X2(v1, mi);
end;


(******************************************)
function TMultiIntX2.FromBinaryString(const AStr: ansistring): TMultiIntX2;
begin
  bin_to_Multi_Int_X2(AStr, Result);
end;


(******************************************)
procedure Multi_Int_X2_to_bin(const v1: TMultiIntX2; out v2: ansistring;
  LZ: TMultiLeadingZeros); inline;
var
  s: ansistring = '';
  n: INT_1W_S;
begin
  if (not v1.FIsDefined) then
  begin
    v2 := 'UNDEFINED';
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.FHasOverflow) then
  begin
    v2 := 'OVERFLOW';
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    exit;
  end;

  n := INT_1W_SIZE;
  s := '';

  s := s + IntToBin(v1.FParts[3], n) + IntToBin(v1.FParts[2], n) +
    IntToBin(v1.FParts[1], n) + IntToBin(v1.FParts[0], n);

  if (LZ = TrimLeadingZeros) then
  begin
    Removeleadingchars(s, ['0']);
  end;
  if (v1.FIsNegative = uBoolTrue) then
  begin
    s := '-' + s;
  end;
  if (s = '') then
  begin
    s := '0';
  end;
  v2 := s;
end;


(******************************************)
function TMultiIntX2.ToBinaryString(const LeadingZeroMode: TMultiLeadingZeros): ansistring;
begin
  Multi_Int_X2_to_bin(self, Result, LeadingZeroMode);
end;


(******************************************)
procedure Multi_Int_X2_to_hex(const v1: TMultiIntX2; out v2: ansistring;
  LZ: TMultiLeadingZeros); inline;
var
  s: ansistring = '';
  n: TMultiUInt16;
begin
  if (not v1.FIsDefined) then
  begin
    v2 := 'UNDEFINED';
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.FHasOverflow) then
  begin
    v2 := 'OVERFLOW';
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    exit;
  end;

  n := (INT_1W_SIZE div 4);
  s := '';

  s := s + IntToHex(v1.FParts[3], n) + IntToHex(v1.FParts[2], n) +
    IntToHex(v1.FParts[1], n) + IntToHex(v1.FParts[0], n);

  if (LZ = TrimLeadingZeros) then
  begin
    Removeleadingchars(s, ['0']);
  end;
  if (v1.FIsNegative = uBoolTrue) then
  begin
    s := '-' + s;
  end;
  if (s = '') then
  begin
    s := '0';
  end;
  v2 := s;
end;


(******************************************)
function TMultiIntX2.ToHexString(const LeadingZeroMode: TMultiLeadingZeros): ansistring;
begin
  Multi_Int_X2_to_hex(self, Result, LeadingZeroMode);
end;


(******************************************)
procedure hex_to_Multi_Int_X2(const v1: ansistring; out mi: TMultiIntX2); inline;
label
  999;
var
  n, i, b, c, e: INT_2W_U;
  M_Val: array[0..Multi_X2_maxi] of INT_2W_U;
  Signeg, Zeroneg, M_Val_All_Zero: boolean;
begin
  Multi_Int_ERROR := False;

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

  if (length(v1) > 0) then
  begin
    b := low(ansistring);
    e := b + INT_2W_U(length(v1)) - 1;
    if (v1[b] = '-') then
    begin
      Signeg := True;
      Inc(b);
    end;

    c := b;
    while (c <= e) do
    begin
      try
        i := Hex2Dec(v1[c]);
      except
        on EConvertError do
        begin
          Multi_Int_ERROR := True;
          mi.FIsDefined   := False;
          mi.FHasOverflow := True;
          if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
          begin
            raise;
          end;
        end;
      end;
      if mi.FIsDefined = False then
      begin
        goto 999;
      end;

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
        Multi_Int_ERROR := True;
        mi.FIsDefined   := False;
        mi.FHasOverflow := True;
        if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
        begin
          raise EIntOverflow.Create('Overflow');
        end;
        goto 999;
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
    begin
      M_Val_All_Zero := False;
    end;
    Inc(n);
  end;
  if M_Val_All_Zero then
  begin
    Zeroneg := True;
  end;

  if Zeroneg then
  begin
    mi.FIsNegative := uBoolFalse;
  end
  else if Signeg then
  begin
    mi.FIsNegative := uBoolTrue;
  end
  else
  begin
    mi.FIsNegative := uBoolFalse;
  end;

  999: ;
end;


(******************************************)
procedure FromHex(const v1: ansistring; out v2: TMultiIntX2); overload;
begin
  hex_to_Multi_Int_X2(v1, v2);
end;


(******************************************)
function TMultiIntX2.FromHexString(const AStr: ansistring): TMultiIntX2;
begin
  hex_to_Multi_Int_X2(AStr, Result);
end;


(******************************************)
procedure Multi_Int_X2_to_String(const v1: TMultiIntX2; out v2: ansistring); inline;
var
  s: ansistring = '';
  M_Val: array[0..Multi_X2_maxi] of INT_2W_U;
begin
  if (not v1.FIsDefined) then
  begin
    v2 := 'UNDEFINED';
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.FHasOverflow) then
  begin
    v2 := 'OVERFLOW';
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    exit;
  end;

  M_Val[0] := v1.FParts[0];
  M_Val[1] := v1.FParts[1];
  M_Val[2] := v1.FParts[2];
  M_Val[3] := v1.FParts[3];

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

  if (v1.FIsNegative = uBoolTrue) then
  begin
    s := '-' + s;
  end;

  v2 := s;
end;


(******************************************)
function TMultiIntX2.ToString: ansistring;
begin
  Multi_Int_X2_to_String(self, Result);
end;


(******************************************)
class operator TMultiIntX2.:=(const AValue: TMultiIntX2): ansistring;
begin
  Multi_Int_X2_to_String(AValue, Result);
end;


(******************************************)
class operator TMultiIntX2.xor(const A, B: TMultiIntX2): TMultiIntX2;
begin
  if (not A.FIsDefined) or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (A.FHasOverflow or B.FHasOverflow) then
  begin
    Result := 0;
    Result.FHasOverflow := True;
    Result.FIsDefined := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
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
  begin
    Result.FIsNegative := uBoolTrue;
  end;
end;


(******************************************)
class operator TMultiIntX2.or(const A, B: TMultiIntX2): TMultiIntX2;
begin
  if (not A.FIsDefined) or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
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
  begin
    Result.FIsNegative := uBoolTrue;
  end;
end;


(******************************************)
class operator TMultiIntX2.and(const A, B: TMultiIntX2): TMultiIntX2;
begin
  if (not A.FIsDefined) or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
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
  begin
    Result.FIsNegative := uBoolTrue;
  end;
end;


(******************************************)
class operator TMultiIntX2.not(const AValue: TMultiIntX2): TMultiIntX2;
begin
  if (not AValue.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Result.FParts[0]    := (not AValue.FParts[0]);
  Result.FParts[1]    := (not AValue.FParts[1]);
  Result.FParts[2]    := (not AValue.FParts[2]);
  Result.FParts[3]    := (not AValue.FParts[3]);
  Result.FIsDefined   := True;
  Result.FHasOverflow := False;

  Result.FIsNegative := uBoolTrue;
  if AValue.IsNegative then
  begin
    Result.FIsNegative := uBoolFalse;
  end;
end;


(******************************************)
function add_Multi_Int_X2(const v1, v2: TMultiIntX2): TMultiIntX2;
var
  tv1, tv2: INT_2W_U;
  M_Val: array[0..Multi_X2_maxi] of INT_2W_U;
begin
  Result.FHasOverflow := False;
  Result.FIsDefined   := True;
  Result.FIsNegative  := uBoolUndefined;

  tv1      := v1.FParts[0];
  tv2      := v2.FParts[0];
  M_Val[0] := (tv1 + tv2);
  if M_Val[0] > INT_1W_U_MAXINT then
  begin
    M_Val[1] := (M_Val[0] div INT_1W_U_MAXINT_1);
    M_Val[0] := (M_Val[0] mod INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[1] := 0;
  end;

  tv1      := v1.FParts[1];
  tv2      := v2.FParts[1];
  M_Val[1] := (M_Val[1] + tv1 + tv2);
  if M_Val[1] > INT_1W_U_MAXINT then
  begin
    M_Val[2] := (M_Val[1] div INT_1W_U_MAXINT_1);
    M_Val[1] := (M_Val[1] mod INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[2] := 0;
  end;

  tv1      := v1.FParts[2];
  tv2      := v2.FParts[2];
  M_Val[2] := (M_Val[2] + tv1 + tv2);
  if M_Val[2] > INT_1W_U_MAXINT then
  begin
    M_Val[3] := (M_Val[2] div INT_1W_U_MAXINT_1);
    M_Val[2] := (M_Val[2] mod INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[3] := 0;
  end;

  tv1      := v1.FParts[3];
  tv2      := v2.FParts[3];
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
  begin
    Result.FIsNegative := uBoolFalse;
  end;

end;


(******************************************)
function subtract_Multi_Int_X2(const v1, v2: TMultiIntX2): TMultiIntX2;
var
  M_Val: array[0..Multi_X2_maxi] of INT_2W_S;
begin
  Result.FHasOverflow := False;
  Result.FIsDefined   := True;
  Result.FIsNegative  := uBoolUndefined;

  M_Val[0] := (v1.FParts[0] - v2.FParts[0]);
  if M_Val[0] < 0 then
  begin
    M_Val[1] := -1;
    M_Val[0] := (M_Val[0] + INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[1] := 0;
  end;

  M_Val[1] := (v1.FParts[1] - v2.FParts[1] + M_Val[1]);
  if M_Val[1] < 0 then
  begin
    M_Val[2] := -1;
    M_Val[1] := (M_Val[1] + INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[2] := 0;
  end;

  M_Val[2] := (v1.FParts[2] - v2.FParts[2] + M_Val[2]);
  if M_Val[2] < 0 then
  begin
    M_Val[3] := -1;
    M_Val[2] := (M_Val[2] + INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[3] := 0;
  end;

  M_Val[3] := (v1.FParts[3] - v2.FParts[3] + M_Val[3]);
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
  begin
    Result.FIsNegative := uBoolFalse;
  end;

end;

(******************************************)
class operator TMultiIntX2.Inc(const AValue: TMultiIntX2): TMultiIntX2;
var
  Neg: TMultiUBoolState;
  v2: TMultiIntX2;
begin
  if (not AValue.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := AValue.FIsDefined;
    Result.FHasOverflow := AValue.FHasOverflow;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (AValue.FHasOverflow) then
  begin
    Result := 0;
    Multi_Int_ERROR := True;
    Result.FIsDefined := AValue.FIsDefined;
    Result.FHasOverflow := AValue.FHasOverflow;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  Neg := uBoolUndefined;
  v2  := 1;

  if (AValue.FIsNegative = False) then
  begin
    Result := add_Multi_Int_X2(AValue, v2);
    Neg    := AValue.FIsNegative;
  end
  else
  begin
    if ABS_greaterthan_Multi_Int_X2(AValue, v2) then
    begin
      Result := subtract_Multi_Int_X2(AValue, v2);
      Neg    := uBoolTrue;
    end
    else
    begin
      Result := subtract_Multi_Int_X2(v2, AValue);
      Neg    := uBoolFalse;
    end;
  end;

  if (Result.FHasOverflow = True) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
  end;

  if (Result.FIsNegative = uBoolUndefined) then
  begin
    Result.FIsNegative := Neg;
  end;
end;


(******************************************)
class operator TMultiIntX2.+(const A, B: TMultiIntX2): TMultiIntX2;
var
  Neg: TMultiUBool;
begin
  if (not A.FIsDefined) or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (A.FHasOverflow or B.FHasOverflow) then
  begin
    Multi_Int_ERROR := True;
    Result := 0;
    Result.FHasOverflow := True;
    Result.FIsDefined := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
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
  end;

  if (Result.FHasOverflow = True) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
  end;

  if (Result.FIsNegative = uBoolUndefined) then
  begin
    Result.FIsNegative := Neg;
  end;
end;


(******************************************)
class operator TMultiIntX2.Dec(const AValue: TMultiIntX2): TMultiIntX2;
var
  Neg: TMultiUBoolState;
  v2: TMultiIntX2;
begin
  if (not AValue.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := AValue.FIsDefined;
    Result.FHasOverflow := AValue.FHasOverflow;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (AValue.FHasOverflow) then
  begin
    Multi_Int_ERROR := True;
    Result := 0;
    Result.FIsDefined := AValue.FIsDefined;
    Result.FHasOverflow := AValue.FHasOverflow;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  Neg := uBoolUndefined;
  v2  := 1;

  if (AValue.FIsNegative = False) then
  begin
    if ABS_greaterthan_Multi_Int_X2(v2, AValue) then
    begin
      Result := subtract_Multi_Int_X2(v2, AValue);
      Neg    := uBoolTrue;
    end
    else
    begin
      Result := subtract_Multi_Int_X2(AValue, v2);
      Neg    := uBoolFalse;
    end;
  end
  else (* AValue is FIsNegative *)
  begin
    Result := add_Multi_Int_X2(AValue, v2);
    Neg    := uBoolTrue;
  end;

  if (Result.FHasOverflow = True) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
  end;

  if (Result.FIsNegative = uBoolUndefined) then
  begin
    Result.FIsNegative := Neg;
  end;
end;


(******************************************)
class operator TMultiIntX2.-(const A, B: TMultiIntX2): TMultiIntX2;
var
  Neg: TMultiUBoolState;
begin
  if (not A.FIsDefined) or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (A.FHasOverflow or B.FHasOverflow) then
  begin
    Multi_Int_ERROR := True;
    Result := 0;
    Result.FHasOverflow := True;
    Result.FIsDefined := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
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
  begin
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
  end;

  if (Result.FHasOverflow = True) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
  end;

  if (Result.FIsNegative = uBoolUndefined) then
  begin
    Result.FIsNegative := Neg;
  end;
end;


(******************************************)
class operator TMultiIntX2.-(const AValue: TMultiIntX2): TMultiIntX2; inline;
begin
  Result := AValue;
  if (AValue.FIsNegative = uBoolTrue) then
  begin
    Result.FIsNegative := uBoolFalse;
  end;
  if (AValue.FIsNegative = uBoolFalse) then
  begin
    Result.FIsNegative := uBoolTrue;
  end;
end;


(********************v1********************)
procedure multiply_Multi_Int_X2(const v1, v2: TMultiIntX2; out Result: TMultiIntX2);
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
    if (v2.FParts[i] <> 0) then
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
    if (v1.FParts[i] <> 0) then
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
    if (v2.FParts[j] <> 0) then
    begin
      zero_mult := True;
      repeat
        if (v1.FParts[i] <> 0) then
        begin
          zero_mult := False;
          tv1 := v1.FParts[i];
          tv2 := v2.FParts[j];
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
      begin
        Result.FHasOverflow := True;
      end;
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
  if (not A.FIsDefined) or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (A.FHasOverflow or B.FHasOverflow) then
  begin
    Result := 0;
    Result.FHasOverflow := True;
    Result.FIsDefined := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  multiply_Multi_Int_X2(A, B, R);

  if (R.FIsNegative = uBoolUndefined) then
  begin
    if (A.FIsNegative = B.FIsNegative) then
    begin
      R.FIsNegative := uBoolFalse;
    end
    else
    begin
      R.FIsNegative := uBoolTrue;
    end;
  end;

  Result := R;

  if R.FHasOverflow then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
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
  begin
    R := 0;
  end
  else if (PT = 0) then
  begin
    R := 1;
  end
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
          Multi_Int_ERROR := True;
          Result := 0;
          Result.FIsDefined := False;
          Result.FHasOverflow := True;
          if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
          begin
            raise EIntOverflow.Create('Overflow');
          end;
          exit;
        end;
        if (T.FIsNegative = uBoolUndefined) then
        begin
          if (TV.FIsNegative = Y.FIsNegative) then
          begin
            T.FIsNegative := uBoolFalse;
          end
          else
          begin
            T.FIsNegative := uBoolTrue;
          end;
        end;

        Y  := T;
        PT := PT - 1;
      end;
      multiply_Multi_Int_X2(TV, TV, T);
      if (T.FHasOverflow) then
      begin
        Multi_Int_ERROR := True;
        Result := 0;
        Result.FIsDefined := False;
        Result.FHasOverflow := True;
        if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
        begin
          raise EIntOverflow.Create('Overflow');
        end;
        exit;
      end;
      T.FIsNegative := uBoolFalse;

      TV := T;
      PT := (PT div 2);
    end;
    multiply_Multi_Int_X2(TV, Y, R);
    if (R.FHasOverflow) then
    begin
      Multi_Int_ERROR := True;
      Result := 0;
      Result.FIsDefined := False;
      Result.FHasOverflow := True;
      if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
      begin
        raise EIntOverflow.Create('Overflow');
      end;
      exit;
    end;
    if (R.FIsNegative = uBoolUndefined) then
    begin
      if (TV.FIsNegative = Y.FIsNegative) then
      begin
        R.FIsNegative := uBoolFalse;
      end
      else
      begin
        R.FIsNegative := uBoolTrue;
      end;
    end;
  end;

  Result := R;
end;


(********************v1********************)
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
    Multi_Int_ERROR := True;
  end
  else if (P_dividor = P_dividend) then
  begin
    P_quotient := 1;
  end
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
      dividor.M_Value[i] := P_dividor.FParts[i];
      if (dividor_non_zero_pos = 0) then
      begin
        if (dividor.M_Value[i] <> 0) then
        begin
          dividor_non_zero_pos := i;
        end;
      end;
      Dec(i);
    end;
    dividor.Negative_flag := False;

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
    dividend.Negative_flag := False;

    shiftup_bits_dividor := nlz_bits(dividor.M_Value[dividor_non_zero_pos]);
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
    begin
      if (dividend_i >= 0) then
      begin
        if (dividend.M_Value[dividend_i] = 0) then
        begin
          Dec(dividend_i);
        end
        else
        begin
          finished := True;
        end;
      end
      else
      begin
        finished := True;
      end;
    end;
    quotient_i := (dividend_i - dividor_non_zero_pos);

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
            begin
              goto AGAIN;
            end;
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
      begin
        word_carry := word_dividend;
      end;

      Dec(dividend_i);
      quotient_i := (dividend_i - dividor_non_zero_pos);
    end; { while }

    ShiftDown_MultiBits_Multi_Int_X3(dividend, shiftup_bits_dividor);
    P_remainder := To_Multi_Int_X2(dividend);

    9000:
      if (P_dividend.FIsNegative = True) and (P_remainder > 0) then
      begin
        P_remainder.FIsNegative := True;
      end;

    if (P_dividend.FIsNegative <> P_dividor.FIsNegative) and (P_quotient > 0) then
    begin
      P_quotient.FIsNegative := True;
    end;

  end;
  9999: ;
end;


(******************************************)
class operator TMultiIntX2.div(const A, B: TMultiIntX2): TMultiIntX2;
var
  Remainder, Quotient: TMultiIntX2;
begin
  if (not A.FIsDefined) or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (A.FHasOverflow or B.FHasOverflow) then
  begin
    Multi_Int_ERROR := True;
    Result := 0;
    Result.FHasOverflow := True;
    Result.FIsDefined := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  // same values as last time

  if (X2_Last_Divisor = B) and (X2_Last_Dividend = A) then
  begin
    Result := X2_Last_Quotient;
  end
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
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
  end;
end;


(******************************************)
class operator TMultiIntX2.mod(const A, B: TMultiIntX2): TMultiIntX2;
var
  Remainder, Quotient: TMultiIntX2;
begin
  if (not A.FIsDefined) or (not B.FIsDefined) then
  begin
    Result := 0;
    Result.FIsDefined := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (A.FHasOverflow or B.FHasOverflow) then
  begin
    Multi_Int_ERROR := True;
    Result := 0;
    Result.FHasOverflow := True;
    Result.FIsDefined := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  // same values as last time

  if (X2_Last_Divisor = B) and (X2_Last_Dividend = A) then
  begin
    Result := X2_Last_Remainder;
  end
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
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
  end;
end;


(***********v2************)
procedure SqRoot(const v1: TMultiIntX2; out VR, VREM: TMultiIntX2);
var
  D, D2: INT_2W_S;
  HS, LS: ansistring;
  H, L, C, CC, LPC, Q, R, T: TMultiIntX2;
  finished: boolean;
begin
  if (not v1.FIsDefined) then
  begin
    VR   := 0;
    VR.FIsDefined := False;
    VREM := 0;
    VREM.FIsDefined := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.FHasOverflow) then
  begin
    VR   := 0;
    VR.FIsDefined := False;
    VREM := 0;
    VREM.FIsDefined := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  if (v1.FIsNegative = uBoolTrue) then
  begin
    VR   := 0;
    VR.FIsDefined := False;
    VREM := 0;
    VREM.FIsDefined := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  if (v1 >= 100) then
  begin
    D  := length(v1.ToString);
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
    C := (v1 div 2);
    if (C = 0) then
    begin
      C := 1;
    end;
  end;

  finished := False;
  LPC      := v1;
  repeat
    begin
      // CC:= ((C + (v1 div C)) div 2);
      intdivide_taylor_warruth_X2(v1, C, Q, R);
      CC := (C + Q);
      ShiftDown_MultiBits_Multi_Int_X2(CC, 1);
      if (ABS(C - CC) < 2) then
      begin
        if (CC < LPC) then
        begin
          LPC := CC;
        end
        else if (CC >= LPC) then
        begin
          finished := True;
        end;
      end;
      C := CC;
    end
  until finished;

  VREM := (v1 - (LPC * LPC));
  VR   := LPC;
  VR.FIsNegative := uBoolFalse;
  VREM.FIsNegative := uBoolFalse;

end;


(*************************)
procedure SqRoot(const v1: TMultiIntX2; out VR: TMultiIntX2);
var
  VREM: TMultiIntX2;
begin
  VREM := 0;
  sqroot(v1, VR, VREM);
end;


(*************************)
function SqRoot(const v1: TMultiIntX2): TMultiIntX2;
var
  VR, VREM: TMultiIntX2;
begin
  VREM := 0;
  sqroot(v1, VR, VREM);
  Result := VR;
end;


{
******************************************
TMultiIntX3
******************************************
}

function ABS_greaterthan_Multi_Int_X3(const v1, v2: TMultiIntX3): boolean;
begin
  if (v1.M_Value[5] > v2.M_Value[5]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[5] < v2.M_Value[5]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[4] > v2.M_Value[4]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[4] < v2.M_Value[4]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[3] > v2.M_Value[3]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[3] < v2.M_Value[3]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[2] > v2.M_Value[2]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[2] < v2.M_Value[2]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[1] > v2.M_Value[1]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[1] < v2.M_Value[1]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[0] > v2.M_Value[0]) then
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
function ABS_lessthan_Multi_Int_X3(const v1, v2: TMultiIntX3): boolean;
begin
  if (v1.M_Value[5] < v2.M_Value[5]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[5] > v2.M_Value[5]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[4] < v2.M_Value[4]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[4] > v2.M_Value[4]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[3] < v2.M_Value[3]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[3] > v2.M_Value[3]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[2] < v2.M_Value[2]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[2] > v2.M_Value[2]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[1] < v2.M_Value[1]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[1] > v2.M_Value[1]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[0] < v2.M_Value[0]) then
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
function ABS_equal_Multi_Int_X3(const v1, v2: TMultiIntX3): boolean;
begin
  Result := True;
  if (v1.M_Value[5] <> v2.M_Value[5]) then
  begin
    Result := False;
  end
  else
  if (v1.M_Value[4] <> v2.M_Value[4]) then
  begin
    Result := False;
  end
  else
  if (v1.M_Value[3] <> v2.M_Value[3]) then
  begin
    Result := False;
  end
  else
  if (v1.M_Value[2] <> v2.M_Value[2]) then
  begin
    Result := False;
  end
  else
  if (v1.M_Value[1] <> v2.M_Value[1]) then
  begin
    Result := False;
  end
  else
  if (v1.M_Value[0] <> v2.M_Value[0]) then
  begin
    Result := False;
  end;
end;


(******************************************)
function ABS_notequal_Multi_Int_X3(const v1, v2: TMultiIntX3): boolean; inline;
begin
  Result := (not ABS_equal_Multi_Int_X3(v1, v2));
end;


(******************************************)
function TMultiIntX3.Overflow: boolean; inline;
begin
  Result := self.Overflow_flag;
end;


(******************************************)
function TMultiIntX3.Defined: boolean; inline;
begin
  Result := self.Defined_flag;
end;


(******************************************)
function Overflow(const v1: TMultiIntX3): boolean; overload; inline;
begin
  Result := v1.Overflow_flag;
end;


(******************************************)
function Defined(const v1: TMultiIntX3): boolean; overload; inline;
begin
  Result := v1.Defined_flag;
end;


(******************************************)
function TMultiIntX3.Negative: boolean; inline;
begin
  Result := self.Negative_flag;
end;


(******************************************)
function Negative(const v1: TMultiIntX3): boolean; overload; inline;
begin
  Result := v1.Negative_flag;
end;


(******************************************)
function Abs(const v1: TMultiIntX3): TMultiIntX3; overload;
begin
  Result := v1;
  Result.Negative_flag := uBoolFalse;

  if (not v1.Defined_flag) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
  end;
end;


(******************************************)
function Multi_Int_X3_Odd(const v1: TMultiIntX3): boolean;
var
  bit1_mask: INT_1W_U;
begin

  bit1_mask := $1;

  if ((v1.M_Value[0] and bit1_mask) = bit1_mask) then
  begin
    Result := True;
  end
  else
  begin
    Result := False;
  end;

  if (not v1.Defined_flag) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
  end;

end;


(******************************************)
function Odd(const v1: TMultiIntX3): boolean; overload;
begin
  Result := Multi_Int_X3_Odd(v1);
end;


(******************************************)
function Multi_Int_X3_Even(const v1: TMultiIntX3): boolean; inline;
var
  bit1_mask: INT_1W_U;
begin

  bit1_mask := $1;

  if ((v1.M_Value[0] and bit1_mask) = bit1_mask) then
  begin
    Result := False;
  end
  else
  begin
    Result := True;
  end;

  if (not v1.Defined_flag) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
  end;

end;


(******************************************)
function Even(const v1: TMultiIntX3): boolean; overload;
begin
  Result := Multi_Int_X3_Even(v1);
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
    begin
      fini := True;
    end
    else if (m.M_Value[i] <> 0) then
    begin
      fini := True;
    end
    else
    begin
      Inc(n);
      Dec(i);
    end;
  until fini;
  Result := n;
end;


(******************************************)
function nlz_MultiBits_X3(v1: TMultiIntX3): INT_1W_U;
var
  w: INT_1W_U;
begin
  if (not v1.Defined_flag) then
  begin
    Result := 0;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
  end;

  w := nlz_words_X3(v1);
  if (w <= Multi_X3_maxi) then
  begin
    Result :=
      nlz_bits(v1.M_Value[Multi_X3_maxi - w]) + (w * INT_1W_SIZE);
  end
  else
  begin
    Result := (w * INT_1W_SIZE);
  end;
end;


{$ifdef CPU_32}
(******************************************)
procedure ShiftUp_NBits_Multi_Int_X3(var v1: TMultiIntX3; NBits: INT_1W_U);
var
  carry_bits_1, carry_bits_2, carry_bits_mask, NBits_max, NBits_carry: INT_1W_U;

  procedure INT_1W_U_shl(var v1: INT_1W_U; const nbits: INT_1W_U); inline;
  var
    carry_bits_mask_2w: INT_2W_U;
  begin
    carry_bits_mask_2w := v1;
    carry_bits_mask_2w := (carry_bits_mask_2w << NBits);
    v1 := INT_1W_U(carry_bits_mask_2w and INT_1W_U_MAXINT);
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
      carry_bits_1 := ((v1.M_Value[0] and carry_bits_mask) >> NBits_carry);
      INT_1W_U_shl(v1.M_Value[0], NBits);

      carry_bits_2 := ((v1.M_Value[1] and carry_bits_mask) >> NBits_carry);
      INT_1W_U_shl(v1.M_Value[1], NBits);
      v1.M_Value[1] := (v1.M_Value[1] or carry_bits_1);

      carry_bits_1 := ((v1.M_Value[2] and carry_bits_mask) >> NBits_carry);
      INT_1W_U_shl(v1.M_Value[2], NBits);
      v1.M_Value[2] := (v1.M_Value[2] or carry_bits_2);

      carry_bits_2 := ((v1.M_Value[3] and carry_bits_mask) >> NBits_carry);
      INT_1W_U_shl(v1.M_Value[3], NBits);
      v1.M_Value[3] := (v1.M_Value[3] or carry_bits_1);

      carry_bits_1 := ((v1.M_Value[4] and carry_bits_mask) >> NBits_carry);
      INT_1W_U_shl(v1.M_Value[4], NBits);
      v1.M_Value[4] := (v1.M_Value[4] or carry_bits_2);

      INT_1W_U_shl(v1.M_Value[5], NBits);
      v1.M_Value[5] := (v1.M_Value[5] or carry_bits_1);
    end;
  end;

end;
{$endif}

{$ifdef CPU_64}
(******************************************)
procedure ShiftUp_NBits_Multi_Int_X3(Var v1:TMultiIntX3; NBits:INT_1W_U);
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
        carry_bits_1:= ((v1.M_Value[0] and carry_bits_mask) >> NBits_carry);
        v1.M_Value[0]:= (v1.M_Value[0] << NBits);

        carry_bits_2:= ((v1.M_Value[1] and carry_bits_mask) >> NBits_carry);
        v1.M_Value[1]:= ((v1.M_Value[1] << NBits) OR carry_bits_1);

        carry_bits_1:= ((v1.M_Value[2] and carry_bits_mask) >> NBits_carry);
        v1.M_Value[2]:= ((v1.M_Value[2] << NBits) OR carry_bits_2);

        carry_bits_2:= ((v1.M_Value[3] and carry_bits_mask) >> NBits_carry);
        v1.M_Value[3]:= ((v1.M_Value[3] << NBits) OR carry_bits_1);

        carry_bits_1:= ((v1.M_Value[4] and carry_bits_mask) >> NBits_carry);
        v1.M_Value[4]:= ((v1.M_Value[4] << NBits) OR carry_bits_2);

        v1.M_Value[5]:= ((v1.M_Value[5] << NBits) OR carry_bits_1);
        end;
end;

end;
{$endif}


(******************************************)
procedure ShiftUp_NWords_Multi_Int_X3(var v1: TMultiIntX3; NWords: INT_1W_U);
var
  n: INT_1W_U;
begin
  if (NWords > 0) then
  begin
    if (NWords <= Multi_X3_maxi) then
    begin
      n := NWords;
      while (n > 0) do
      begin
        v1.M_Value[5] := v1.M_Value[4];
        v1.M_Value[4] := v1.M_Value[3];
        v1.M_Value[3] := v1.M_Value[2];
        v1.M_Value[2] := v1.M_Value[1];
        v1.M_Value[1] := v1.M_Value[0];
        v1.M_Value[0] := 0;
        Dec(n);
      end;
    end
    else
    begin
      v1.M_Value[0] := 0;
      v1.M_Value[1] := 0;
      v1.M_Value[2] := 0;
      v1.M_Value[3] := 0;
      v1.M_Value[4] := 0;
      v1.M_Value[5] := 0;
    end;
  end;
end;


(******************************************)
procedure ShiftDown_NWords_Multi_Int_X3(var v1: TMultiIntX3; NWords: INT_1W_U);
var
  n: INT_1W_U;
begin
  if (NWords > 0) then
  begin
    if (NWords <= Multi_X3_maxi) then
    begin
      n := NWords;
      while (n > 0) do
      begin
        v1.M_Value[0] := v1.M_Value[1];
        v1.M_Value[1] := v1.M_Value[2];
        v1.M_Value[2] := v1.M_Value[3];
        v1.M_Value[3] := v1.M_Value[4];
        v1.M_Value[4] := v1.M_Value[5];
        v1.M_Value[5] := 0;
        Dec(n);
      end;
    end
    else
    begin
      v1.M_Value[0] := 0;
      v1.M_Value[1] := 0;
      v1.M_Value[2] := 0;
      v1.M_Value[3] := 0;
      v1.M_Value[4] := 0;
      v1.M_Value[5] := 0;
    end;
  end;
end;


{******************************************}
procedure ShiftUp_MultiBits_Multi_Int_X3(var v1: TMultiIntX3; NBits: INT_1W_U);
var
  NWords_count, NBits_count: INT_1W_U;
begin
  if (not v1.Defined_flag) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (NBits > 0) then
  begin
    if (NBits >= INT_1W_SIZE) then
    begin
      NWords_count := (NBits div INT_1W_SIZE);
      NBits_count  := (NBits mod INT_1W_SIZE);
      ShiftUp_NWords_Multi_Int_X3(v1, NWords_count);
    end
    else
    begin
      NBits_count := NBits;
    end;
    ShiftUp_NBits_Multi_Int_X3(v1, NBits_count);
  end;
end;


(******************************************)
procedure ShiftDown_NBits_Multi_Int_X3(var v1: TMultiIntX3; NBits: INT_1W_U);
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
    carry_bits_mask := (carry_bits_mask >> NBits_carry);

    if NBits <= NBits_max then
    begin

      carry_bits_1  := ((v1.M_Value[5] and carry_bits_mask) << NBits_carry);
      v1.M_Value[5] := (v1.M_Value[5] >> NBits);

      carry_bits_2  := ((v1.M_Value[4] and carry_bits_mask) << NBits_carry);
      v1.M_Value[4] := ((v1.M_Value[4] >> NBits) or carry_bits_1);

      carry_bits_1  := ((v1.M_Value[3] and carry_bits_mask) << NBits_carry);
      v1.M_Value[3] := ((v1.M_Value[3] >> NBits) or carry_bits_2);

      carry_bits_2  := ((v1.M_Value[2] and carry_bits_mask) << NBits_carry);
      v1.M_Value[2] := ((v1.M_Value[2] >> NBits) or carry_bits_1);

      carry_bits_1  := ((v1.M_Value[1] and carry_bits_mask) << NBits_carry);
      v1.M_Value[1] := ((v1.M_Value[1] >> NBits) or carry_bits_2);

      v1.M_Value[0] := ((v1.M_Value[0] >> NBits) or carry_bits_1);

    end;
  end;

end;


{******************************************}
procedure ShiftDown_MultiBits_Multi_Int_X3(var v1: TMultiIntX3; NBits: INT_1W_U);
var
  NWords_count, NBits_count: INT_1W_U;
begin
  if (not v1.Defined_flag) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (NBits >= INT_1W_SIZE) then
  begin
    NWords_count := (NBits div INT_1W_SIZE);
    NBits_count  := (NBits mod INT_1W_SIZE);
    ShiftDown_NWords_Multi_Int_X3(v1, NWords_count);
  end
  else
  begin
    NBits_count := NBits;
  end;

  ShiftDown_NBits_Multi_Int_X3(v1, NBits_count);
end;


{******************************************}
class operator TMultiIntX3.shl(const v1: TMultiIntX3;
  const NBits: INT_1W_U): TMultiIntX3;
begin
  Result := v1;
  ShiftUp_MultiBits_Multi_Int_X3(Result, NBits);
end;


{******************************************}
class operator TMultiIntX3.shr(const v1: TMultiIntX3;
  const NBits: INT_1W_U): TMultiIntX3;
begin
  Result := v1;
  ShiftDown_MultiBits_Multi_Int_X3(Result, NBits);
end;


(******************************************)
class operator TMultiIntX3.<=(const v1, v2: TMultiIntX3): boolean;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) or (v1.Overflow_flag) or
    (v2.Overflow_flag) then
  begin
    Result := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Result := False;
  if ((v1.Negative_flag = False) and (v2.Negative_flag = True)) then
  begin
    Result := False;
  end
  else
  if ((v1.Negative_flag = True) and (v2.Negative_flag = False)) then
  begin
    Result := True;
  end
  else
  if ((v1.Negative_flag = False) and (v2.Negative_flag = False)) then
  begin
    Result := (not ABS_greaterthan_Multi_Int_X3(v1, v2));
  end
  else
  if ((v1.Negative_flag = True) and (v2.Negative_flag = True)) then
  begin
    Result := (not ABS_lessthan_Multi_Int_X3(v1, v2));
  end;
end;


(******************************************)
class operator TMultiIntX3.>=(const v1, v2: TMultiIntX3): boolean;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) or (v1.Overflow_flag) or
    (v2.Overflow_flag) then
  begin
    Result := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Result := False;
  if ((v1.Negative_flag = False) and (v2.Negative_flag = True)) then
  begin
    Result := True;
  end
  else
  if ((v1.Negative_flag = True) and (v2.Negative_flag = False)) then
  begin
    Result := False;
  end
  else
  if ((v1.Negative_flag = False) and (v2.Negative_flag = False)) then
  begin
    Result := (not ABS_lessthan_Multi_Int_X3(v1, v2));
  end
  else
  if ((v1.Negative_flag = True) and (v2.Negative_flag = True)) then
  begin
    Result := (not ABS_greaterthan_Multi_Int_X3(v1, v2));
  end;
end;


(******************************************)
class operator TMultiIntX3.>(const v1, v2: TMultiIntX3): boolean;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) or (v1.Overflow_flag) or
    (v2.Overflow_flag) then
  begin
    Result := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Result := False;
  if ((v1.Negative_flag = False) and (v2.Negative_flag = True)) then
  begin
    Result := True;
  end
  else
  if ((v1.Negative_flag = True) and (v2.Negative_flag = False)) then
  begin
    Result := False;
  end
  else
  if ((v1.Negative_flag = False) and (v2.Negative_flag = False)) then
  begin
    Result := ABS_greaterthan_Multi_Int_X3(v1, v2);
  end
  else
  if ((v1.Negative_flag = True) and (v2.Negative_flag = True)) then
  begin
    Result := ABS_lessthan_Multi_Int_X3(v1, v2);
  end;
end;


(******************************************)
class operator TMultiIntX3.<(const v1, v2: TMultiIntX3): boolean;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) or (v1.Overflow_flag) or
    (v2.Overflow_flag) then
  begin
    Result := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Result := False;
  if ((v1.Negative_flag = True) and (v2.Negative_flag = False)) then
  begin
    Result := True;
  end
  else
  if ((v1.Negative_flag = False) and (v2.Negative_flag = False)) then
  begin
    Result := ABS_lessthan_Multi_Int_X3(v1, v2);
  end
  else
  if ((v1.Negative_flag = True) and (v2.Negative_flag = True)) then
  begin
    Result := ABS_greaterthan_Multi_Int_X3(v1, v2);
  end;
end;


(******************************************)
class operator TMultiIntX3.=(const v1, v2: TMultiIntX3): boolean;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) or (v1.Overflow_flag) or
    (v2.Overflow_flag) then
  begin
    Result := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Result := True;
  if (v1.Negative_flag <> v2.Negative_flag) then
  begin
    Result := False;
  end
  else
  begin
    Result := ABS_equal_Multi_Int_X3(v1, v2);
  end;
end;


(******************************************)
class operator TMultiIntX3.<>(const v1, v2: TMultiIntX3): boolean;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) or (v1.Overflow_flag) or
    (v2.Overflow_flag) then
  begin
    Result := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Result := False;
  if (v1.Negative_flag <> v2.Negative_flag) then
  begin
    Result := True;
  end
  else
  begin
    Result := (not ABS_equal_Multi_Int_X3(v1, v2));
  end;
end;


(******************************************)
procedure String_to_Multi_Int_X3(const v1: ansistring; out mi: TMultiIntX3); inline;
label
  999;
var
  i, b, c, e: INT_2W_U;
  M_Val: array[0..Multi_X3_maxi] of INT_2W_U;
  Signeg, Zeroneg: boolean;
begin
  Multi_Int_ERROR := False;

  mi.Overflow_flag := False;
  mi.Defined_flag := True;
  mi.Negative_flag := False;
  Signeg  := False;
  Zeroneg := False;

  M_Val[0] := 0;
  M_Val[1] := 0;
  M_Val[2] := 0;
  M_Val[3] := 0;
  M_Val[4] := 0;
  M_Val[5] := 0;

  if (length(v1) > 0) then
  begin
    b := low(ansistring);
    e := b + INT_2W_U(length(v1)) - 1;
    if (v1[b] = '-') then
    begin
      Signeg := True;
      Inc(b);
    end;

    c := b;
    while (c <= e) do
    begin
      try
        i := StrToInt(v1[c]);
      except
        on EConvertError do
        begin
          Multi_Int_ERROR  := True;
          mi.Defined_flag  := False;
          mi.Overflow_flag := True;
          if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
          begin
            raise;
          end;
        end;
      end;
      if mi.Defined_flag = False then
      begin
        goto 999;
      end;
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
        Multi_Int_ERROR  := True;
        mi.Defined_flag  := False;
        mi.Overflow_flag := True;
        if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
        begin
          raise EIntOverflow.Create('Overflow');
        end;
        goto 999;
      end;

      Inc(c);
    end;
  end;

  mi.M_Value[0] := M_Val[0];
  mi.M_Value[1] := M_Val[1];
  mi.M_Value[2] := M_Val[2];
  mi.M_Value[3] := M_Val[3];
  mi.M_Value[4] := M_Val[4];
  mi.M_Value[5] := M_Val[5];

  if (M_Val[0] = 0) and (M_Val[1] = 0) and (M_Val[2] = 0) and
    (M_Val[3] = 0) and (M_Val[4] = 0) and (M_Val[5] = 0) then
  begin
    Zeroneg := True;
  end;

  if Zeroneg then
  begin
    mi.Negative_flag := uBoolFalse;
  end
  else if Signeg then
  begin
    mi.Negative_flag := uBoolTrue;
  end
  else
  begin
    mi.Negative_flag := uBoolFalse;
  end;

  999: ;
end;


(******************************************)
class operator TMultiIntX3.:=(const v1: ansistring): TMultiIntX3;
begin
  String_to_Multi_Int_X3(v1, Result);
end;


{$ifdef CPU_32}
(******************************************)
procedure INT_4W_S_to_Multi_Int_X3(const v1: INT_4W_S; out mi: TMultiIntX3); inline;
var
  v: INT_4W_U;
begin
  mi.Overflow_flag := False;
  mi.Defined_flag := True;
  v := Abs(v1);

  v := v1;
  mi.M_Value[0] := INT_1W_U(v mod INT_1W_U_MAXINT_1);
  v := (v div INT_1W_U_MAXINT_1);
  mi.M_Value[1] := INT_1W_U(v mod INT_1W_U_MAXINT_1);
  v := (v div INT_1W_U_MAXINT_1);
  mi.M_Value[2] := INT_1W_U(v mod INT_1W_U_MAXINT_1);
  v := (v div INT_1W_U_MAXINT_1);
  mi.M_Value[3] := v;

  mi.M_Value[4] := 0;
  mi.M_Value[5] := 0;

  if (v1 < 0) then
  begin
    mi.Negative_flag := uBoolTrue;
  end
  else
  begin
    mi.Negative_flag := uBoolFalse;
  end;

end;


(******************************************)
class operator TMultiIntX3.:=(const v1: INT_4W_S): TMultiIntX3;
begin
  INT_4W_S_to_Multi_Int_X3(v1, Result);
end;


(******************************************)
procedure INT_4W_U_to_Multi_Int_X3(const v1: INT_4W_U; out mi: TMultiIntX3); inline;
var
  v: INT_4W_U;
begin
  mi.Overflow_flag := False;
  mi.Defined_flag  := True;
  mi.Negative_flag := uBoolFalse;

  v := v1;
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
class operator TMultiIntX3.:=(const v1: INT_4W_U): TMultiIntX3;
begin
  INT_4W_U_to_Multi_Int_X3(v1, Result);
end;
{$endif}


(******************************************)
procedure INT_2W_S_to_Multi_Int_X3(const v1: INT_2W_S; out mi: TMultiIntX3); inline;
begin
  mi.Overflow_flag := False;
  mi.Defined_flag  := True;
  mi.M_Value[2]    := 0;
  mi.M_Value[3]    := 0;
  mi.M_Value[4]    := 0;
  mi.M_Value[5]    := 0;

  if (v1 < 0) then
  begin
    mi.Negative_flag := uBoolTrue;
    mi.M_Value[0]    := (ABS(v1) mod INT_1W_U_MAXINT_1);
    mi.M_Value[1]    := (ABS(v1) div INT_1W_U_MAXINT_1);
  end
  else
  begin
    mi.Negative_flag := uBoolFalse;
    mi.M_Value[0]    := (v1 mod INT_1W_U_MAXINT_1);
    mi.M_Value[1]    := (v1 div INT_1W_U_MAXINT_1);
  end;
end;


(******************************************)
class operator TMultiIntX3.:=(const v1: INT_2W_S): TMultiIntX3;
begin
  INT_2W_S_to_Multi_Int_X3(v1, Result);
end;


(******************************************)
procedure INT_2W_U_to_Multi_Int_X3(const v1: INT_2W_U; out mi: TMultiIntX3); inline;
begin
  mi.Overflow_flag := False;
  mi.Defined_flag  := True;
  mi.Negative_flag := uBoolFalse;

  mi.M_Value[0] := (v1 mod INT_1W_U_MAXINT_1);
  mi.M_Value[1] := (v1 div INT_1W_U_MAXINT_1);
  mi.M_Value[2] := 0;
  mi.M_Value[3] := 0;
  mi.M_Value[4] := 0;
  mi.M_Value[5] := 0;
end;


(******************************************)
class operator TMultiIntX3.:=(const v1: INT_2W_U): TMultiIntX3;
begin
  INT_2W_U_to_Multi_Int_X3(v1, Result);
end;


(******************************************)
function To_Multi_Int_X3(const v1: TMultiIntXV): TMultiIntX3;
label
  OVERFLOW_BRANCH, CLEAN_EXIT;
var
  n: INT_2W_U;
begin
  if (v1.Defined_flag = False) then
  begin
    Multi_Int_ERROR     := True;
    Result.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (v1.Overflow_flag = True) then
  begin
    goto OVERFLOW_BRANCH;
  end;

  Result.Overflow_flag := v1.Overflow_flag;
  Result.Defined_flag  := v1.Defined_flag;
  Result.Negative_flag := v1.Negative_flag;

  n := 0;
  if (Multi_XV_size > Multi_X3_size) then
  begin
    while (n <= Multi_X3_maxi) do
    begin
      Result.M_Value[n] := v1.M_Value[n];
      Inc(n);
    end;
    while (n <= Multi_XV_maxi) do
    begin
      if (v1.M_Value[n] <> 0) then
      begin
        goto OVERFLOW_BRANCH;
      end;
      Inc(n);
    end;
  end
  else
  begin
    while (n <= Multi_XV_maxi) do
    begin
      Result.M_Value[n] := v1.M_Value[n];
      Inc(n);
    end;
    while (n <= Multi_X3_maxi) do
    begin
      Result.M_Value[n] := 0;
      Inc(n);
    end;
  end;

  goto CLEAN_EXIT;

  OVERFLOW_BRANCH:

    Multi_Int_ERROR    := True;
  Result.Overflow_flag := True;
  if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
  begin
    raise EInterror.Create('Overflow');
  end;
  exit;

  CLEAN_EXIT: ;

end;


{
var n :INT_1W_U;
begin
Result.Overflow_flag:= v1.Overflow_flag;
Result.Defined_flag:= v1.Defined_flag;
Result.Negative_flag:= v1.Negative_flag;

if  (v1.Defined_flag = FALSE)
then
  begin
  if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
    Raise EInterror.create('Uninitialised variable');
    end;
  Result.Defined_flag:= FALSE;
  exit;
  end;

if  (v1.Overflow_flag = TRUE)
then
  begin
  Multi_Int_ERROR:= TRUE;
  Result.Overflow_flag:= TRUE;
  if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
    Raise EInterror.create('Overflow');
    end;
  exit;
  end;

n:= 0;
while (n <= Multi_X3_maxi) do
  begin
  Result.M_Value[n]:= v1.M_Value[n];
  inc(n);
  end;
end;
}


(******************************************)
function To_Multi_Int_X3(const v1: TMultiIntX4): TMultiIntX3;
var
  n: INT_1W_U;
begin
  Result.Overflow_flag := v1.Overflow_flag;
  Result.Defined_flag  := v1.Defined_flag;
  Result.Negative_flag := v1.Negative_flag;

  if (v1.Defined_flag = False) then
  begin
    Result.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (v1.Overflow_flag = True) or (v1 > Multi_Int_X3_MAXINT) then
  begin
    Multi_Int_ERROR      := True;
    Result.Overflow_flag := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    exit;
  end;

  n := 0;
  while (n <= Multi_X3_maxi) do
  begin
    Result.M_Value[n] := v1.M_Value[n];
    Inc(n);
  end;
end;


(******************************************)
function To_Multi_Int_X3(const v1: TMultiIntX2): TMultiIntX3;
var
  n: INT_1W_U;
begin
  Result.Overflow_flag := v1.FHasOverflow;
  Result.Defined_flag  := v1.FIsDefined;
  Result.Negative_flag := v1.FIsNegative;

  if (v1.FIsDefined = False) then
  begin
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    Result.Defined_flag := False;
    exit;
  end;

  if (v1.FHasOverflow = True) then
  begin
    Multi_Int_ERROR      := True;
    Result.Overflow_flag := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    exit;
  end;

  n := 0;
  while (n <= Multi_X2_maxi) do
  begin
    Result.M_Value[n] := v1.FParts[n];
    Inc(n);
  end;

  while (n <= Multi_X3_maxi) do
  begin
    Result.M_Value[n] := 0;
    Inc(n);
  end;
end;


(******************************************)
procedure Multi_Int_X2_to_Multi_Int_X3(const v1: TMultiIntX2;
  out MI: TMultiIntX3); inline;
var
  n: INT_1W_U;
begin
  MI.Overflow_flag := v1.FHasOverflow;
  MI.Defined_flag  := v1.FIsDefined;
  MI.Negative_flag := v1.FIsNegative;

  if (v1.FIsDefined = False) then
  begin
    Multi_Int_ERROR := True;
    MI.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (v1.FHasOverflow = True) then
  begin
    Multi_Int_ERROR  := True;
    MI.Overflow_flag := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    exit;
  end;

  n := 0;
  while (n <= Multi_X2_maxi) do
  begin
    MI.M_Value[n] := v1.FParts[n];
    Inc(n);
  end;

  while (n <= Multi_X3_maxi) do
  begin
    MI.M_Value[n] := 0;
    Inc(n);
  end;
end;


(******************************************)
class operator TMultiIntX3.:=(const v1: TMultiIntX2): TMultiIntX3;
begin
  Multi_Int_X2_to_Multi_Int_X3(v1, Result);
end;


(******************************************)
// WARNING Float to Multi_Int type conversion loses some precision
class operator TMultiIntX3.:=(const v1: single): TMultiIntX3;
var
  R: TMultiIntX3;
  R_FLOATREC: TFloatRec;
begin
  Multi_Int_ERROR := False;

  FloatToDecimal(R_FLOATREC, v1, SINGLE_TYPE_PRECISION_DIGITS, 0);
  String_to_Multi_Int_X3(AddCharR('0', AnsiLeftStr(R_FLOATREC.digits,
    (SINGLE_TYPE_PRECISION_DIGITS - 1)), R_FLOATREC.Exponent), R);

  if (R.Overflow) then
  begin
    Multi_Int_ERROR      := True;
    Result.Defined_flag  := False;
    Result.Negative_flag := uBoolUndefined;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  if (R_FLOATREC.Negative) then
  begin
    R.Negative_flag := True;
  end;
  Result := R;
end;


(******************************************)
// WARNING Float to Multi_Int type conversion loses some precision
class operator TMultiIntX3.:=(const v1: real): TMultiIntX3;
var
  R: TMultiIntX3;
  R_FLOATREC: TFloatRec;
begin
  Multi_Int_ERROR := False;

  FloatToDecimal(R_FLOATREC, v1, REAL_TYPE_PRECISION_DIGITS, 0);
  String_to_Multi_Int_X3(AddCharR('0', AnsiLeftStr(R_FLOATREC.digits,
    (REAL_TYPE_PRECISION_DIGITS - 1)), R_FLOATREC.Exponent), R);

  if (R.Overflow) then
  begin
    Multi_Int_ERROR      := True;
    Result.Defined_flag  := False;
    Result.Negative_flag := uBoolUndefined;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  if (R_FLOATREC.Negative) then
  begin
    R.Negative_flag := True;
  end;
  Result := R;
end;


(******************************************)
// WARNING Float to Multi_Int type conversion loses some precision
class operator TMultiIntX3.:=(const v1: double): TMultiIntX3;
var
  R: TMultiIntX3;
  R_FLOATREC: TFloatRec;
begin
  Multi_Int_ERROR := False;

  FloatToDecimal(R_FLOATREC, v1, DOUBLE_TYPE_PRECISION_DIGITS, 0);
  String_to_Multi_Int_X3(AddCharR('0', AnsiLeftStr(R_FLOATREC.digits,
    (DOUBLE_TYPE_PRECISION_DIGITS - 1)), R_FLOATREC.Exponent), R);

  if (R.Overflow) then
  begin
    Multi_Int_ERROR      := True;
    Result.Defined_flag  := False;
    Result.Negative_flag := uBoolUndefined;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  if (R_FLOATREC.Negative) then
  begin
    R.Negative_flag := True;
  end;
  Result := R;
end;


(******************************************)
class operator TMultiIntX3.:=(const v1: TMultiIntX3): single;
var
  R, V, M: single;
  i: INT_1W_U;
  finished: boolean;
begin
  if (not v1.Defined_flag) then
  begin
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Multi_Int_ERROR := False;
  finished := False;
  M := INT_1W_U_MAXINT_1;

  R := v1.M_Value[0];
  i := 1;
  while (i <= Multi_X3_maxi) and (not Multi_Int_ERROR) do
  begin
    if (not finished) then
    begin
      V := v1.M_Value[i];
      try
        begin
          V := (V * M);
          R := R + V;
        end
      except
        begin
          Multi_Int_ERROR := True;
          if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
          begin
            raise EIntOverflow.Create('Overflow');
          end;
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
    begin
      if (v1.M_Value[i] > 0) then
      begin
        Multi_Int_ERROR := True;
        if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
        begin
          raise EIntOverflow.Create('Overflow');
        end;
      end;
    end;
    Inc(i);
  end;

  if v1.Negative_flag then
  begin
    R := (-R);
  end;
  Result := R;
end;


(******************************************)
class operator TMultiIntX3.:=(const v1: TMultiIntX3): real;
var
  R, V, M: real;
  i: INT_1W_U;
  finished: boolean;
begin
  if (not v1.Defined_flag) then
  begin
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Multi_Int_ERROR := False;
  finished := False;
  M := INT_1W_U_MAXINT_1;

  R := v1.M_Value[0];
  i := 1;
  while (i <= Multi_X3_maxi) and (not Multi_Int_ERROR) do
  begin
    if (not finished) then
    begin
      V := v1.M_Value[i];
      try
        begin
          V := (V * M);
          R := R + V;
        end
      except
        begin
          Multi_Int_ERROR := True;
          if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
          begin
            raise EIntOverflow.Create('Overflow');
          end;
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
    begin
      if (v1.M_Value[i] > 0) then
      begin
        Multi_Int_ERROR := True;
        if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
        begin
          raise EIntOverflow.Create('Overflow');
        end;
      end;
    end;
    Inc(i);
  end;

  if v1.Negative_flag then
  begin
    R := (-R);
  end;
  Result := R;
end;


(******************************************)
class operator TMultiIntX3.:=(const v1: TMultiIntX3): double;
var
  R, V, M: double;
  i: INT_1W_U;
  finished: boolean;
begin
  if (not v1.Defined_flag) then
  begin
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Multi_Int_ERROR := False;
  finished := False;
  M := INT_1W_U_MAXINT_1;

  R := v1.M_Value[0];
  i := 1;
  while (i <= Multi_X3_maxi) and (not Multi_Int_ERROR) do
  begin
    if (not finished) then
    begin
      V := v1.M_Value[i];
      try
        begin
          V := (V * M);
          R := R + V;
        end
      except
        begin
          Multi_Int_ERROR := True;
          if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
          begin
            raise EIntOverflow.Create('Overflow');
          end;
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
    begin
      if (v1.M_Value[i] > 0) then
      begin
        Multi_Int_ERROR := True;
        if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
        begin
          raise EIntOverflow.Create('Overflow');
        end;
      end;
    end;
    Inc(i);
  end;

  if v1.Negative_flag then
  begin
    R := (-R);
  end;
  Result := R;
end;


(******************************************)
class operator TMultiIntX3.:=(const v1: TMultiIntX3): INT_2W_S;
var
  R: INT_2W_U;
begin
  Multi_Int_ERROR := False;
  if (not v1.Defined_flag) then
  begin
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  R := (INT_2W_U(v1.M_Value[0]) + (INT_2W_U(v1.M_Value[1]) * INT_1W_U_MAXINT_1));

  if (R > INT_2W_S_MAXINT) or (v1.M_Value[2] <> 0) or (v1.M_Value[3] <> 0) or
    (v1.M_Value[4] <> 0) or (v1.M_Value[5] <> 0) then
  begin
    Result := 0;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    exit;
  end;

  if v1.Negative_flag then
  begin
    Result := INT_2W_S(-R);
  end
  else
  begin
    Result := INT_2W_S(R);
  end;
end;


(******************************************)
class operator TMultiIntX3.:=(const v1: TMultiIntX3): INT_2W_U;
var
  R: INT_2W_U;
begin
  Multi_Int_ERROR := False;
  if (not v1.Defined_flag) then
  begin
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  R := (INT_2W_U(v1.M_Value[1]) << INT_1W_SIZE);
  R := (R or INT_2W_U(v1.M_Value[0]));

  if (v1.M_Value[2] <> 0) or (v1.M_Value[3] <> 0) or (v1.M_Value[4] <> 0) or
    (v1.M_Value[5] <> 0) then
  begin
    Result := 0;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    exit;
  end;
  Result := R;
end;


(******************************************)
class operator TMultiIntX3.:=(const v1: TMultiIntX3): INT_1W_S;
var
  R: INT_2W_U;
begin
  Multi_Int_ERROR := False;
  if (not v1.Defined_flag) then
  begin
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  R := (INT_2W_U(v1.M_Value[0]) + (INT_2W_U(v1.M_Value[1]) * INT_1W_U_MAXINT_1));

  if (R > INT_1W_S_MAXINT) or (v1.M_Value[2] <> 0) or (v1.M_Value[3] <> 0) or
    (v1.M_Value[4] <> 0) or (v1.M_Value[5] <> 0) then
  begin
    Result := 0;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    exit;
  end;

  if v1.Negative_flag then
  begin
    Result := INT_1W_S(-R);
  end
  else
  begin
    Result := INT_1W_S(R);
  end;
end;


(******************************************)
class operator TMultiIntX3.:=(const v1: TMultiIntX3): INT_1W_U;
var
  R: INT_2W_U;
begin
  Multi_Int_ERROR := False;
  if (not v1.Defined_flag) or (v1.Negative_flag = uBoolTrue) then
  begin
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  R := (v1.M_Value[0] + (v1.M_Value[1] * INT_1W_U_MAXINT_1));

  if (R > INT_1W_U_MAXINT) or (v1.M_Value[2] <> 0) or (v1.M_Value[3] <> 0) or
    (v1.M_Value[4] <> 0) or (v1.M_Value[5] <> 0) then
  begin
    Result := 0;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    exit;
  end;

  Result := INT_1W_U(R);
end;


{******************************************}
class operator TMultiIntX3.:=(const v1: TMultiIntX3): TMultiUInt8;
  (* var  R  :TMultiUInt8; *)
begin
  Multi_Int_ERROR := False;
  if (not v1.Defined_flag) or (v1.Negative_flag = uBoolTrue) then
  begin
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (v1.M_Value[0] > UINT8_MAX) or (v1.M_Value[1] <> 0) or
    (v1.M_Value[2] <> 0) or (v1.M_Value[3] <> 0) or (v1.M_Value[4] <> 0) or
    (v1.M_Value[5] <> 0) then
  begin
    Multi_Int_ERROR := True;
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    exit;
  end;

  Result := TMultiUInt8(v1.M_Value[0]);
end;


{******************************************}
class operator TMultiIntX3.:=(const v1: TMultiIntX3): TMultiInt8;
  (* var  R  :TMultiInt8; *)
begin
  Multi_Int_ERROR := False;
  if (not v1.Defined_flag) or (v1.Negative_flag = uBoolTrue) then
  begin
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (v1.M_Value[0] > INT8_MAX) or (v1.M_Value[2] <> 0) or
    (v1.M_Value[3] <> 0) or (v1.M_Value[4] <> 0) or (v1.M_Value[5] <> 0) then
  begin
    Multi_Int_ERROR := True;
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Result := TMultiInt8(v1.M_Value[0]);
end;


(******************************************)
procedure bin_to_Multi_Int_X3(const v1: ansistring; out mi: TMultiIntX3); inline;
label
  999;
var
  n, b, c, e: INT_2W_U;
  bit: INT_1W_S;
  M_Val: array[0..Multi_X3_maxi] of INT_2W_U;
  Signeg, Zeroneg, M_Val_All_Zero: boolean;
begin
  Multi_Int_ERROR := False;

  mi.Overflow_flag := False;
  mi.Defined_flag := True;
  mi.Negative_flag := False;
  Signeg  := False;
  Zeroneg := False;

  n := 0;
  while (n <= Multi_X3_maxi) do
  begin
    M_Val[n] := 0;
    Inc(n);
  end;

  if (length(v1) > 0) then
  begin
    b := low(ansistring);
    e := b + INT_2W_U(length(v1)) - 1;
    if (v1[b] = '-') then
    begin
      Signeg := True;
      Inc(b);
    end;

    c := b;
    while (c <= e) do
    begin
      bit := (Ord(v1[c]) - Ord('0'));
      if (bit > 1) or (bit < 0) then
      begin
        Multi_Int_ERROR  := True;
        mi.Defined_flag  := False;
        mi.Overflow_flag := True;
        if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
        begin
          raise EInterror.Create('Invalid binary digit');
        end;
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
        mi.Defined_flag  := False;
        mi.Overflow_flag := True;
        Multi_Int_ERROR  := True;
        if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
        begin
          raise EIntOverflow.Create('Overflow');
        end;
        goto 999;
      end;
      Inc(c);
    end;
  end;

  M_Val_All_Zero := True;
  n := 0;
  while (n <= Multi_X3_maxi) do
  begin
    mi.M_Value[n] := M_Val[n];
    if M_Val[n] > 0 then
    begin
      M_Val_All_Zero := False;
    end;
    Inc(n);
  end;
  if M_Val_All_Zero then
  begin
    Zeroneg := True;
  end;

  if Zeroneg then
  begin
    mi.Negative_flag := uBoolFalse;
  end
  else if Signeg then
  begin
    mi.Negative_flag := uBoolTrue;
  end
  else
  begin
    mi.Negative_flag := uBoolFalse;
  end;

  999: ;
end;


(******************************************)
procedure FromBin(const v1: ansistring; out mi: TMultiIntX3); overload;
begin
  Bin_to_Multi_Int_X3(v1, mi);
end;


(******************************************)
function TMultiIntX3.FromBin(const v1: ansistring): TMultiIntX3;
begin
  bin_to_Multi_Int_X3(v1, Result);
end;


(******************************************)
procedure Multi_Int_X3_to_bin(const v1: TMultiIntX3; out v2: ansistring;
  LZ: TMultiLeadingZeros); inline;
var
  s: ansistring = '';
  n: INT_1W_S;
begin
  if (not v1.Defined_flag) then
  begin
    v2 := 'UNDEFINED';
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.Overflow_flag) then
  begin
    v2 := 'OVERFLOW';
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    exit;
  end;

  n := INT_1W_SIZE;
  s := '';

  s := s + IntToBin(v1.M_Value[5], n) + IntToBin(v1.M_Value[4], n) +
    IntToBin(v1.M_Value[3], n) + IntToBin(v1.M_Value[2], n) +
    IntToBin(v1.M_Value[1], n) + IntToBin(v1.M_Value[0], n);

  if (LZ = TrimLeadingZeros) then
  begin
    Removeleadingchars(s, ['0']);
  end;
  if (v1.Negative_flag = uBoolTrue) then
  begin
    s := '-' + s;
  end;
  if (s = '') then
  begin
    s := '0';
  end;
  v2 := s;
end;


(******************************************)
function TMultiIntX3.Tobin(const LZ: TMultiLeadingZeros): ansistring;
begin
  Multi_Int_X3_to_bin(self, Result, LZ);
end;


(******************************************)
procedure Multi_Int_X3_to_hex(const v1: TMultiIntX3; out v2: ansistring;
  LZ: TMultiLeadingZeros); inline;
var
  s: ansistring = '';
  n: TMultiUInt16;
begin
  if (not v1.Defined_flag) then
  begin
    v2 := 'UNDEFINED';
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.Overflow_flag) then
  begin
    Multi_Int_ERROR := True;
    v2 := 'OVERFLOW';
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  n := (INT_1W_SIZE div 4);
  s := '';

  s := s + IntToHex(v1.M_Value[5], n) + IntToHex(v1.M_Value[4], n) +
    IntToHex(v1.M_Value[3], n) + IntToHex(v1.M_Value[2], n) +
    IntToHex(v1.M_Value[1], n) + IntToHex(v1.M_Value[0], n);

  if (LZ = TrimLeadingZeros) then
  begin
    Removeleadingchars(s, ['0']);
  end;
  if (v1.Negative_flag = uBoolTrue) then
  begin
    s := '-' + s;
  end;
  if (s = '') then
  begin
    s := '0';
  end;
  v2 := s;
end;


(******************************************)
function TMultiIntX3.ToHex(const LZ: TMultiLeadingZeros): ansistring;
begin
  Multi_Int_X3_to_hex(self, Result, LZ);
end;


(******************************************)
procedure hex_to_Multi_Int_X3(const v1: ansistring; out mi: TMultiIntX3); inline;
label
  999;
var
  n, i, b, c, e: INT_2W_U;
  M_Val: array[0..Multi_X3_maxi] of INT_2W_U;
  Signeg, Zeroneg, M_Val_All_Zero: boolean;
begin
  Multi_Int_ERROR := False;

  mi.Overflow_flag := False;
  mi.Defined_flag := True;
  mi.Negative_flag := False;
  Signeg  := False;
  Zeroneg := False;

  n := 0;
  while (n <= Multi_X3_maxi) do
  begin
    M_Val[n] := 0;
    Inc(n);
  end;

  if (length(v1) > 0) then
  begin
    b := low(ansistring);
    e := b + INT_2W_U(length(v1)) - 1;
    if (v1[b] = '-') then
    begin
      Signeg := True;
      Inc(b);
    end;

    c := b;
    while (c <= e) do
    begin
      try
        i := Hex2Dec(v1[c]);
      except
        on EConvertError do
        begin
          Multi_Int_ERROR  := True;
          mi.Defined_flag  := False;
          mi.Overflow_flag := True;
          if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
          begin
            raise;
          end;
        end;
      end;
      if mi.Defined_flag = False then
      begin
        goto 999;
      end;

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
        Multi_Int_ERROR  := True;
        mi.Defined_flag  := False;
        mi.Overflow_flag := True;
        if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
        begin
          raise EIntOverflow.Create('Overflow');
        end;
        goto 999;
      end;
      Inc(c);
    end;
  end;

  M_Val_All_Zero := True;
  n := 0;
  while (n <= Multi_X3_maxi) do
  begin
    mi.M_Value[n] := M_Val[n];
    if M_Val[n] > 0 then
    begin
      M_Val_All_Zero := False;
    end;
    Inc(n);
  end;
  if M_Val_All_Zero then
  begin
    Zeroneg := True;
  end;

  if Zeroneg then
  begin
    mi.Negative_flag := uBoolFalse;
  end
  else if Signeg then
  begin
    mi.Negative_flag := uBoolTrue;
  end
  else
  begin
    mi.Negative_flag := uBoolFalse;
  end;

  999: ;
end;


(******************************************)
procedure FromHex(const v1: ansistring; out v2: TMultiIntX3); overload;
begin
  hex_to_Multi_Int_X3(v1, v2);
end;


(******************************************)
function TMultiIntX3.FromHex(const v1: ansistring): TMultiIntX3;
begin
  hex_to_Multi_Int_X3(v1, Result);
end;


(******************************************)
procedure Multi_Int_X3_to_String(const v1: TMultiIntX3; out v2: ansistring); inline;
var
  s: ansistring = '';
  M_Val: array[0..Multi_X3_maxi] of INT_2W_U;
begin
  if (not v1.Defined_flag) then
  begin
    v2 := 'UNDEFINED';
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.Overflow_flag) then
  begin
    Multi_Int_ERROR := True;
    v2 := 'OVERFLOW';
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    exit;
  end;

  M_Val[0] := v1.M_Value[0];
  M_Val[1] := v1.M_Value[1];
  M_Val[2] := v1.M_Value[2];
  M_Val[3] := v1.M_Value[3];
  M_Val[4] := v1.M_Value[4];
  M_Val[5] := v1.M_Value[5];

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

  if (v1.Negative_flag = uBoolTrue) then
  begin
    s := '-' + s;
  end;

  v2 := s;
end;


(******************************************)
function TMultiIntX3.ToStr: ansistring;
begin
  Multi_Int_X3_to_String(self, Result);
end;


(******************************************)
class operator TMultiIntX3.:=(const v1: TMultiIntX3): ansistring;
begin
  Multi_Int_X3_to_String(v1, Result);
end;


(******************************************)
class operator TMultiIntX3.xor(const v1, v2: TMultiIntX3): TMultiIntX3;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.Overflow_flag or v2.Overflow_flag) then
  begin
    Result := 0;
    Result.Overflow_flag := True;
    Result.Defined_flag := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  Result.M_Value[0]    := (v1.M_Value[0] xor v2.M_Value[0]);
  Result.M_Value[1]    := (v1.M_Value[1] xor v2.M_Value[1]);
  Result.M_Value[2]    := (v1.M_Value[2] xor v2.M_Value[2]);
  Result.M_Value[3]    := (v1.M_Value[3] xor v2.M_Value[3]);
  Result.M_Value[4]    := (v1.M_Value[4] xor v2.M_Value[4]);
  Result.M_Value[5]    := (v1.M_Value[5] xor v2.M_Value[5]);
  Result.Defined_flag  := True;
  Result.Overflow_flag := False;

  Result.Negative_flag := uBoolFalse;
  if (v1.Negative <> v2.Negative) then
  begin
    Result.Negative_flag := uBoolTrue;
  end;
end;


(******************************************)
class operator TMultiIntX3.or(const v1, v2: TMultiIntX3): TMultiIntX3;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Result.M_Value[0]    := (v1.M_Value[0] or v2.M_Value[0]);
  Result.M_Value[1]    := (v1.M_Value[1] or v2.M_Value[1]);
  Result.M_Value[2]    := (v1.M_Value[2] or v2.M_Value[2]);
  Result.M_Value[3]    := (v1.M_Value[3] or v2.M_Value[3]);
  Result.M_Value[4]    := (v1.M_Value[4] or v2.M_Value[4]);
  Result.M_Value[5]    := (v1.M_Value[5] or v2.M_Value[5]);
  Result.Defined_flag  := True;
  Result.Overflow_flag := False;

  Result.Negative_flag := uBoolFalse;
  if v1.Negative and v2.Negative then
  begin
    Result.Negative_flag := uBoolTrue;
  end;
end;


(******************************************)
class operator TMultiIntX3.and(const v1, v2: TMultiIntX3): TMultiIntX3;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Result.M_Value[0]    := (v1.M_Value[0] and v2.M_Value[0]);
  Result.M_Value[1]    := (v1.M_Value[1] and v2.M_Value[1]);
  Result.M_Value[2]    := (v1.M_Value[2] and v2.M_Value[2]);
  Result.M_Value[3]    := (v1.M_Value[3] and v2.M_Value[3]);
  Result.M_Value[4]    := (v1.M_Value[4] and v2.M_Value[4]);
  Result.M_Value[5]    := (v1.M_Value[5] and v2.M_Value[5]);
  Result.Defined_flag  := True;
  Result.Overflow_flag := False;

  Result.Negative_flag := uBoolFalse;
  if v1.Negative and v2.Negative then
  begin
    Result.Negative_flag := uBoolTrue;
  end;
end;


(******************************************)
class operator TMultiIntX3.not(const v1: TMultiIntX3): TMultiIntX3;
begin
  if (not v1.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Result.M_Value[0]    := (not v1.M_Value[0]);
  Result.M_Value[1]    := (not v1.M_Value[1]);
  Result.M_Value[2]    := (not v1.M_Value[2]);
  Result.M_Value[3]    := (not v1.M_Value[3]);
  Result.M_Value[4]    := (not v1.M_Value[4]);
  Result.M_Value[5]    := (not v1.M_Value[5]);
  Result.Defined_flag  := True;
  Result.Overflow_flag := False;

  Result.Negative_flag := uBoolTrue;
  if v1.Negative then
  begin
    Result.Negative_flag := uBoolFalse;
  end;
end;


(******************************************)
function add_Multi_Int_X3(const v1, v2: TMultiIntX3): TMultiIntX3;
var
  tv1, tv2: INT_2W_U;
  M_Val: array[0..Multi_X3_maxi] of INT_2W_U;
begin
  Result.Overflow_flag := False;
  Result.Defined_flag  := True;
  Result.Negative_flag := uBoolUndefined;

  tv1      := v1.M_Value[0];
  tv2      := v2.M_Value[0];
  M_Val[0] := (tv1 + tv2);
  if M_Val[0] > INT_1W_U_MAXINT then
  begin
    M_Val[1] := (M_Val[0] div INT_1W_U_MAXINT_1);
    M_Val[0] := (M_Val[0] mod INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[1] := 0;
  end;

  tv1      := v1.M_Value[1];
  tv2      := v2.M_Value[1];
  M_Val[1] := (M_Val[1] + tv1 + tv2);
  if M_Val[1] > INT_1W_U_MAXINT then
  begin
    M_Val[2] := (M_Val[1] div INT_1W_U_MAXINT_1);
    M_Val[1] := (M_Val[1] mod INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[2] := 0;
  end;

  tv1      := v1.M_Value[2];
  tv2      := v2.M_Value[2];
  M_Val[2] := (M_Val[2] + tv1 + tv2);
  if M_Val[2] > INT_1W_U_MAXINT then
  begin
    M_Val[3] := (M_Val[2] div INT_1W_U_MAXINT_1);
    M_Val[2] := (M_Val[2] mod INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[3] := 0;
  end;

  tv1      := v1.M_Value[3];
  tv2      := v2.M_Value[3];
  M_Val[3] := (M_Val[3] + tv1 + tv2);
  if M_Val[3] > INT_1W_U_MAXINT then
  begin
    M_Val[4] := (M_Val[3] div INT_1W_U_MAXINT_1);
    M_Val[3] := (M_Val[3] mod INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[4] := 0;
  end;

  tv1      := v1.M_Value[4];
  tv2      := v2.M_Value[4];
  M_Val[4] := (M_Val[4] + tv1 + tv2);
  if M_Val[4] > INT_1W_U_MAXINT then
  begin
    M_Val[5] := (M_Val[4] div INT_1W_U_MAXINT_1);
    M_Val[4] := (M_Val[4] mod INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[5] := 0;
  end;

  tv1      := v1.M_Value[5];
  tv2      := v2.M_Value[5];
  M_Val[5] := (M_Val[5] + tv1 + tv2);
  if M_Val[5] > INT_1W_U_MAXINT then
  begin
    M_Val[5] := (M_Val[5] mod INT_1W_U_MAXINT_1);
    Result.Defined_flag := False;
    Result.Overflow_flag := True;
  end;

  Result.M_Value[0] := M_Val[0];
  Result.M_Value[1] := M_Val[1];
  Result.M_Value[2] := M_Val[2];
  Result.M_Value[3] := M_Val[3];
  Result.M_Value[4] := M_Val[4];
  Result.M_Value[5] := M_Val[5];

  if (M_Val[0] = 0) and (M_Val[1] = 0) and (M_Val[2] = 0) and
    (M_Val[3] = 0) and (M_Val[4] = 0) and (M_Val[5] = 0) then
  begin
    Result.Negative_flag := uBoolFalse;
  end;

end;


(******************************************)
function subtract_Multi_Int_X3(const v1, v2: TMultiIntX3): TMultiIntX3;
var
  M_Val: array[0..Multi_X3_maxi] of INT_2W_S;
begin
  Result.Overflow_flag := False;
  Result.Defined_flag  := True;
  Result.Negative_flag := uBoolUndefined;

  M_Val[0] := (v1.M_Value[0] - v2.M_Value[0]);
  if M_Val[0] < 0 then
  begin
    M_Val[1] := -1;
    M_Val[0] := (M_Val[0] + INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[1] := 0;
  end;

  M_Val[1] := (v1.M_Value[1] - v2.M_Value[1] + M_Val[1]);
  if M_Val[1] < 0 then
  begin
    M_Val[2] := -1;
    M_Val[1] := (M_Val[1] + INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[2] := 0;
  end;

  M_Val[2] := (v1.M_Value[2] - v2.M_Value[2] + M_Val[2]);
  if M_Val[2] < 0 then
  begin
    M_Val[3] := -1;
    M_Val[2] := (M_Val[2] + INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[3] := 0;
  end;

  M_Val[3] := (v1.M_Value[3] - v2.M_Value[3] + M_Val[3]);
  if M_Val[3] < 0 then
  begin
    M_Val[4] := -1;
    M_Val[3] := (M_Val[3] + INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[4] := 0;
  end;

  M_Val[4] := (v1.M_Value[4] - v2.M_Value[4] + M_Val[4]);
  if M_Val[4] < 0 then
  begin
    M_Val[5] := -1;
    M_Val[4] := (M_Val[4] + INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[5] := 0;
  end;

  M_Val[5] := (v1.M_Value[5] - v2.M_Value[5] + M_Val[5]);
  if M_Val[5] < 0 then
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

  if (M_Val[0] = 0) and (M_Val[1] = 0) and (M_Val[2] = 0) and
    (M_Val[3] = 0) and (M_Val[4] = 0) and (M_Val[5] = 0) then
  begin
    Result.Negative_flag := uBoolFalse;
  end;

end;


(******************************************)
class operator TMultiIntX3.Inc(const v1: TMultiIntX3): TMultiIntX3;
var
  Neg: TMultiUBoolState;
  v2: TMultiIntX3;
begin
  if (not v1.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := v1.Defined_flag;
    Result.Overflow_flag := v1.Overflow_flag;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (v1.Overflow_flag) then
  begin
    Multi_Int_ERROR := True;
    Result := 0;
    Result.Defined_flag := v1.Defined_flag;
    Result.Overflow_flag := v1.Overflow_flag;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  Neg := uBoolUndefined;
  v2  := 1;

  if (v1.Negative_flag = False) then
  begin
    Result := add_Multi_Int_X3(v1, v2);
    Neg    := v1.Negative_flag;
  end
  else
  begin
    if ABS_greaterthan_Multi_Int_X3(v1, v2) then
    begin
      Result := subtract_Multi_Int_X3(v1, v2);
      Neg    := uBoolTrue;
    end
    else
    begin
      Result := subtract_Multi_Int_X3(v2, v1);
      Neg    := uBoolFalse;
    end;
  end;

  if (Result.Overflow_flag = True) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
  end;

  if (Result.Negative_flag = uBoolUndefined) then
  begin
    Result.Negative_flag := Neg;
  end;
end;


(******************************************)
class operator TMultiIntX3.+(const v1, v2: TMultiIntX3): TMultiIntX3;
var
  Neg: TMultiUBool;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (v1.Overflow_flag or v2.Overflow_flag) then
  begin
    Multi_Int_ERROR := True;
    Result := 0;
    Result.Overflow_flag := True;
    Result.Defined_flag := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  Neg := uBoolUndefined;

  if (v1.Negative_flag = v2.Negative_flag) then
  begin
    Result := add_Multi_Int_X3(v1, v2);
    Neg    := v1.Negative_flag;
  end
  else
  if ((v1.Negative_flag = False) and (v2.Negative_flag = True)) then
  begin
    if ABS_greaterthan_Multi_Int_X3(v2, v1) then
    begin
      Result := subtract_Multi_Int_X3(v2, v1);
      Neg    := uBoolTrue;
    end
    else
    begin
      Result := subtract_Multi_Int_X3(v1, v2);
      Neg    := uBoolFalse;
    end;
  end
  else
  begin
    if ABS_greaterthan_Multi_Int_X3(v1, v2) then
    begin
      Result := subtract_Multi_Int_X3(v1, v2);
      Neg    := uBoolTrue;
    end
    else
    begin
      Result := subtract_Multi_Int_X3(v2, v1);
      Neg    := uBoolFalse;
    end;
  end;

  if (Result.Overflow_flag = True) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
  end;

  if (Result.Negative_flag = uBoolUndefined) then
  begin
    Result.Negative_flag := Neg;
  end;
end;


(******************************************)
class operator TMultiIntX3.Dec(const v1: TMultiIntX3): TMultiIntX3;
var
  Neg: TMultiUBoolState;
  v2: TMultiIntX3;
begin
  if (not v1.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := v1.Defined_flag;
    Result.Overflow_flag := v1.Overflow_flag;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (v1.Overflow_flag) then
  begin
    Result := 0;
    Result.Defined_flag := v1.Defined_flag;
    Result.Overflow_flag := v1.Overflow_flag;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  Neg := uBoolUndefined;
  v2  := 1;

  if (v1.Negative_flag = False) then
  begin
    if ABS_greaterthan_Multi_Int_X3(v2, v1) then
    begin
      Result := subtract_Multi_Int_X3(v2, v1);
      Neg    := uBoolTrue;
    end
    else
    begin
      Result := subtract_Multi_Int_X3(v1, v2);
      Neg    := uBoolFalse;
    end;
  end
  else (* v1 is Negative_flag *)
  begin
    Result := add_Multi_Int_X3(v1, v2);
    Neg    := uBoolTrue;
  end;

  if (Result.Overflow_flag = True) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
  end;

  if (Result.Negative_flag = uBoolUndefined) then
  begin
    Result.Negative_flag := Neg;
  end;
end;


(******************************************)
class operator TMultiIntX3.-(const v1, v2: TMultiIntX3): TMultiIntX3;
var
  Neg: TMultiUBoolState;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (v1.Overflow_flag or v2.Overflow_flag) then
  begin
    Result := 0;
    Result.Overflow_flag := True;
    Result.Defined_flag := True;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  Neg := uBoolUndefined;

  if (v1.Negative_flag = v2.Negative_flag) then
  begin
    if (v1.Negative_flag = True) then
    begin
      if ABS_greaterthan_Multi_Int_X3(v1, v2) then
      begin
        Result := subtract_Multi_Int_X3(v1, v2);
        Neg    := uBoolTrue;
      end
      else
      begin
        Result := subtract_Multi_Int_X3(v2, v1);
        Neg    := uBoolFalse;
      end;
    end
    else  (* if  not Negative_flag then  *)
    begin
      if ABS_greaterthan_Multi_Int_X3(v2, v1) then
      begin
        Result := subtract_Multi_Int_X3(v2, v1);
        Neg    := uBoolTrue;
      end
      else
      begin
        Result := subtract_Multi_Int_X3(v1, v2);
        Neg    := uBoolFalse;
      end;
    end;
  end
  else (* v1.Negative_flag <> v2.Negative_flag *)
  begin
    if (v2.Negative_flag = True) then
    begin
      Result := add_Multi_Int_X3(v1, v2);
      Neg    := uBoolFalse;
    end
    else
    begin
      Result := add_Multi_Int_X3(v1, v2);
      Neg    := uBoolTrue;
    end;
  end;

  if (Result.Overflow_flag = True) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
  end;

  if (Result.Negative_flag = uBoolUndefined) then
  begin
    Result.Negative_flag := Neg;
  end;
end;


(******************************************)
class operator TMultiIntX3.-(const v1: TMultiIntX3): TMultiIntX3;
begin
  Result := v1;
  if (v1.Negative_flag = uBoolTrue) then
  begin
    Result.Negative_flag := uBoolFalse;
  end;
  if (v1.Negative_flag = uBoolFalse) then
  begin
    Result.Negative_flag := uBoolTrue;
  end;
end;


(*******************v4*********************)
procedure multiply_Multi_Int_X3(const v1, v2: TMultiIntX3;
  out Result: TMultiIntX3); overload;
label
  999;
var
  M_Val: array[0..Multi_X3_maxi_x2] of INT_2W_U;
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
  until (i > Multi_X3_maxi_x2);

  zf := False;
  i  := Multi_X3_maxi;
  jz := -1;
  repeat
    if (v2.M_Value[i] <> 0) then
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
  i  := Multi_X3_maxi;
  iz := -1;
  repeat
    if (v1.M_Value[i] <> 0) then
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
    if (v2.M_Value[j] <> 0) then
    begin
      zero_mult := True;
      repeat
        if (v1.M_Value[i] <> 0) then
        begin
          zero_mult := False;
          tv1 := v1.M_Value[i];
          tv2 := v2.M_Value[j];
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

  Result.Negative_flag := uBoolFalse;
  i := 0;
  repeat
    if (M_Val[i] <> 0) then
    begin
      Result.Negative_flag := uBoolUndefined;
      if (i > Multi_X3_maxi) then
      begin
        Result.Overflow_flag := True;
      end;
    end;
    Inc(i);
  until (i > Multi_X3_maxi_x2) or (Result.Overflow_flag);

  n := 0;
  while (n <= Multi_X3_maxi) do
  begin
    Result.M_Value[n] := M_Val[n];
    Inc(n);
  end;

  999: ;
end;


(******************************************)
class operator TMultiIntX3.*(const v1, v2: TMultiIntX3): TMultiIntX3;
var
  R: TMultiIntX3;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (v1.Overflow_flag or v2.Overflow_flag) then
  begin
    Result := 0;
    Result.Overflow_flag := True;
    Result.Defined_flag := True;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  multiply_Multi_Int_X3(v1, v2, R);

  if (R.Negative_flag = uBoolUndefined) then
  begin
    if (v1.Negative_flag = v2.Negative_flag) then
    begin
      R.Negative_flag := uBoolFalse;
    end
    else
    begin
      R.Negative_flag := uBoolTrue;
    end;
  end;

  Result := R;

  if (Result.Overflow_flag = True) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
  end;
end;


(******************************************)
function Multi_Int_X2_to_X3_multiply(const v1, v2: TMultiIntX2): TMultiIntX3;
var
  R: TMultiIntX3;
begin
  if (not v1.FIsDefined) or (not v2.FIsDefined) then
  begin
    Result := 0;
    Result.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (v1.FHasOverflow or v2.FHasOverflow) then
  begin
    Result := 0;
    Result.Overflow_flag := True;
    Result.Defined_flag := True;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  multiply_Multi_Int_X3(v1, v2, R);

  if (R.Negative_flag = uBoolUndefined) then
  begin
    if (v1.FIsNegative = v2.FIsNegative) then
    begin
      R.Negative_flag := uBoolFalse;
    end
    else
    begin
      R.Negative_flag := uBoolTrue;
    end;
  end;

  Result := R;

  if (Result.Overflow_flag = True) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
  end;
end;


(********************v3********************)
{ Function exp_by_squaring_iterative(TV, P) }

class operator TMultiIntX3.**(const v1: TMultiIntX3; const P: INT_2W_S): TMultiIntX3;
var
  Y, TV, T, R: TMultiIntX3;
  PT: INT_2W_S;
begin
  PT := P;
  TV := v1;
  if (PT < 0) then
  begin
    R := 0;
  end
  else if (PT = 0) then
  begin
    R := 1;
  end
  else
  begin
    Y := 1;
    while (PT > 1) do
    begin
      if odd(PT) then
      begin
        multiply_Multi_Int_X3(TV, Y, T);
        if (T.Overflow_flag) then
        begin
          Result := 0;
          Result.Defined_flag := False;
          Result.Overflow_flag := True;
          Multi_Int_ERROR := True;
          if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
          begin
            raise EIntOverflow.Create('Overflow');
          end;
          exit;
        end;
        if (T.Negative_flag = uBoolUndefined) then
        begin
          if (TV.Negative_flag = Y.Negative_flag) then
          begin
            T.Negative_flag := uBoolFalse;
          end
          else
          begin
            T.Negative_flag := uBoolTrue;
          end;
        end;

        Y  := T;
        PT := PT - 1;
      end;
      multiply_Multi_Int_X3(TV, TV, T);
      if (T.Overflow_flag) then
      begin
        Result := 0;
        Result.Defined_flag := False;
        Result.Overflow_flag := True;
        Multi_Int_ERROR := True;
        if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
        begin
          raise EIntOverflow.Create('Overflow');
        end;
        exit;
      end;
      T.Negative_flag := uBoolFalse;

      TV := T;
      PT := (PT div 2);
    end;
    multiply_Multi_Int_X3(TV, Y, R);
    if (R.Overflow_flag) then
    begin
      Result := 0;
      Result.Defined_flag := False;
      Result.Overflow_flag := True;
      Multi_Int_ERROR := True;
      if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
      begin
        raise EIntOverflow.Create('Overflow');
      end;
      exit;
    end;
    if (R.Negative_flag = uBoolUndefined) then
    begin
      if (TV.Negative_flag = Y.Negative_flag) then
      begin
        R.Negative_flag := uBoolFalse;
      end
      else
      begin
        R.Negative_flag := uBoolTrue;
      end;
    end;
  end;

  Result := R;
end;


(********************v1********************)
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
    P_quotient.Defined_flag := False;
    P_quotient.Overflow_flag := True;
    P_remainder.Defined_flag := False;
    P_remainder.Overflow_flag := True;
    Multi_Int_ERROR := True;
  end
  else if (P_dividor = P_dividend) then
  begin
    P_quotient := 1;
  end
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
      dividor.M_Value[i] := P_dividor.M_Value[i];
      if (dividor_non_zero_pos = 0) then
      begin
        if (dividor.M_Value[i] <> 0) then
        begin
          dividor_non_zero_pos := i;
        end;
      end;
      Dec(i);
    end;
    dividor.Negative_flag := False;

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
        P_quotient.M_Value[i] :=
          (((word_carry * INT_2W_U(INT_1W_U_MAXINT_1)) +
          INT_2W_U(P_dividend.M_Value[i])) div INT_2W_U(dividor.M_Value[0]));
        word_carry := (((word_carry * INT_2W_U(INT_1W_U_MAXINT_1)) +
          INT_2W_U(P_dividend.M_Value[i])) -
          (INT_2W_U(P_quotient.M_Value[i]) * INT_2W_U(dividor.M_Value[0])));
        Dec(i);
      end;
      P_remainder.M_Value[0] := word_carry;
      goto 9000;
    end;

    dividend := P_dividend;
    dividend.Negative_flag := False;

    shiftup_bits_dividor := nlz_bits(dividor.M_Value[dividor_non_zero_pos]);
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
    begin
      if (dividend_i >= 0) then
      begin
        if (dividend.M_Value[dividend_i] = 0) then
        begin
          Dec(dividend_i);
        end
        else
        begin
          finished := True;
        end;
      end
      else
      begin
        finished := True;
      end;
    end;
    quotient_i := (dividend_i - dividor_non_zero_pos);

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
            begin
              goto AGAIN;
            end;
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
        P_quotient.M_Value[quotient_i] := word_division;
        dividend   := next_dividend;
        word_carry := dividend.M_Value[dividend_i];
      end
      else
      begin
        word_carry := word_dividend;
      end;

      Dec(dividend_i);
      quotient_i := (dividend_i - dividor_non_zero_pos);
    end; { while }

    ShiftDown_MultiBits_Multi_Int_X4(dividend, shiftup_bits_dividor);
    P_remainder := To_Multi_Int_X3(dividend);

    9000:
      if (P_dividend.Negative_flag = True) and (P_remainder > 0) then
      begin
        P_remainder.Negative_flag := True;
      end;

    if (P_dividend.Negative_flag <> P_dividor.Negative_flag) and (P_quotient > 0) then
    begin
      P_quotient.Negative_flag := True;
    end;

  end;
  9999: ;
end;


(******************************************)
class operator TMultiIntX3.div(const v1, v2: TMultiIntX3): TMultiIntX3;
var
  Remainder, Quotient: TMultiIntX3;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (v1.Overflow_flag or v2.Overflow_flag) then
  begin
    Result := 0;
    Result.Overflow_flag := True;
    Result.Defined_flag := True;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  // same values as last time

  if (X3_Last_Divisor = v2) and (X3_Last_Dividend = v1) then
  begin
    Result := X3_Last_Quotient;
  end
  else  // different values than last time
  begin
    intdivide_taylor_warruth_X3(v1, v2, Quotient, Remainder);

    X3_Last_Divisor   := v2;
    X3_Last_Dividend  := v1;
    X3_Last_Quotient  := Quotient;
    X3_Last_Remainder := Remainder;

    Result := Quotient;
  end;

  if (X3_Last_Remainder.Overflow_flag) or (X3_Last_Quotient.Overflow_flag) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
  end;
end;


(******************************************)
class operator TMultiIntX3.mod(const v1, v2: TMultiIntX3): TMultiIntX3;
var
  Remainder, Quotient: TMultiIntX3;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (v1.Overflow_flag or v2.Overflow_flag) then
  begin
    Result := 0;
    Result.Overflow_flag := True;
    Result.Defined_flag := True;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  // same values as last time

  if (X3_Last_Divisor = v2) and (X3_Last_Dividend = v1) then
  begin
    Result := X3_Last_Remainder;
  end
  else  // different values than last time
  begin
    intdivide_taylor_warruth_X3(v1, v2, Quotient, Remainder);

    X3_Last_Divisor   := v2;
    X3_Last_Dividend  := v1;
    X3_Last_Quotient  := Quotient;
    X3_Last_Remainder := Remainder;

    Result := Remainder;
  end;

  if (X3_Last_Remainder.Overflow_flag) or (X3_Last_Quotient.Overflow_flag) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
  end;
end;


(***********v2************)
procedure SqRoot(const v1: TMultiIntX3; out VR, VREM: TMultiIntX3);
var
  D, D2: INT_2W_S;
  HS, LS: ansistring;
  H, L, C, CC, LPC, Q, R, T: TMultiIntX3;
  finished: boolean;
begin
  if (not v1.Defined_flag) then
  begin
    VR   := 0;
    VR.Defined_flag := False;
    VREM := 0;
    VREM.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.Overflow_flag) then
  begin
    VR   := 0;
    VR.Defined_flag := False;
    VREM := 0;
    VREM.Defined_flag := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  if (v1.Negative_flag = uBoolTrue) then
  begin
    VR   := 0;
    VR.Defined_flag := False;
    VREM := 0;
    VREM.Defined_flag := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  if (v1 >= 100) then
  begin
    D  := length(v1.ToStr);
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
    C := (v1 div 2);
    if (C = 0) then
    begin
      C := 1;
    end;
  end;

  finished := False;
  LPC      := v1;
  repeat
    begin
      // CC:= ((C + (v1 div C)) div 2);
      intdivide_taylor_warruth_X3(v1, C, Q, R);
      CC := (C + Q);
      ShiftDown_MultiBits_Multi_Int_X3(CC, 1);
      if (ABS(C - CC) < 2) then
      begin
        if (CC < LPC) then
        begin
          LPC := CC;
        end
        else if (CC >= LPC) then
        begin
          finished := True;
        end;
      end;
      C := CC;
    end
  until finished;

  VREM := (v1 - (LPC * LPC));
  VR   := LPC;
  VR.Negative_flag := uBoolFalse;
  VREM.Negative_flag := uBoolFalse;

end;


(*************************)
procedure SqRoot(const v1: TMultiIntX3; out VR: TMultiIntX3);
var
  VREM: TMultiIntX3;
begin
  VREM := 0;
  sqroot(v1, VR, VREM);
end;


(*************************)
function SqRoot(const v1: TMultiIntX3): TMultiIntX3;
var
  VR, VREM: TMultiIntX3;
begin
  VREM := 0;
  sqroot(v1, VR, VREM);
  Result := VR;
end;


{
******************************************
TMultiIntX4
******************************************
}


(******************************************)
function ABS_greaterthan_Multi_Int_X4(const v1, v2: TMultiIntX4): boolean;
begin
  if (v1.M_Value[7] > v2.M_Value[7]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[7] < v2.M_Value[7]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[6] > v2.M_Value[6]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[6] < v2.M_Value[6]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[5] > v2.M_Value[5]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[5] < v2.M_Value[5]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[4] > v2.M_Value[4]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[4] < v2.M_Value[4]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[3] > v2.M_Value[3]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[3] < v2.M_Value[3]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[2] > v2.M_Value[2]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[2] < v2.M_Value[2]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[1] > v2.M_Value[1]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[1] < v2.M_Value[1]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[0] > v2.M_Value[0]) then
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
function ABS_lessthan_Multi_Int_X4(const v1, v2: TMultiIntX4): boolean;
begin
  if (v1.M_Value[7] < v2.M_Value[7]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[7] > v2.M_Value[7]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[6] < v2.M_Value[6]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[6] > v2.M_Value[6]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[5] < v2.M_Value[5]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[5] > v2.M_Value[5]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[4] < v2.M_Value[4]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[4] > v2.M_Value[4]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[3] < v2.M_Value[3]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[3] > v2.M_Value[3]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[2] < v2.M_Value[2]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[2] > v2.M_Value[2]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[1] < v2.M_Value[1]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[1] > v2.M_Value[1]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[0] < v2.M_Value[0]) then
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
function ABS_equal_Multi_Int_X4(const v1, v2: TMultiIntX4): boolean;
begin
  Result := True;
  if (v1.M_Value[0] <> v2.M_Value[0]) then
  begin
    Result := False;
  end
  else
  if (v1.M_Value[1] <> v2.M_Value[1]) then
  begin
    Result := False;
  end
  else
  if (v1.M_Value[2] <> v2.M_Value[2]) then
  begin
    Result := False;
  end
  else
  if (v1.M_Value[3] <> v2.M_Value[3]) then
  begin
    Result := False;
  end
  else
  if (v1.M_Value[4] <> v2.M_Value[4]) then
  begin
    Result := False;
  end
  else
  if (v1.M_Value[5] <> v2.M_Value[5]) then
  begin
    Result := False;
  end
  else
  if (v1.M_Value[6] <> v2.M_Value[6]) then
  begin
    Result := False;
  end
  else
  if (v1.M_Value[7] <> v2.M_Value[7]) then
  begin
    Result := False;
  end;
end;


(******************************************)
function ABS_notequal_Multi_Int_X4(const v1, v2: TMultiIntX4): boolean; inline;
begin
  Result := (not ABS_equal_Multi_Int_X4(v1, v2));
end;


(******************************************)
function TMultiIntX4.Overflow: boolean; inline;
begin
  Result := self.Overflow_flag;
end;


(******************************************)
function TMultiIntX4.Defined: boolean; inline;
begin
  Result := self.Defined_flag;
end;


(******************************************)
function Overflow(const v1: TMultiIntX4): boolean; overload; inline;
begin
  Result := v1.Overflow_flag;
end;


(******************************************)
function Defined(const v1: TMultiIntX4): boolean; overload; inline;
begin
  Result := v1.Defined_flag;
end;


(******************************************)
function TMultiIntX4.Negative: boolean; inline;
begin
  Result := self.Negative_flag;
end;


(******************************************)
function Negative(const v1: TMultiIntX4): boolean; overload; inline;
begin
  Result := v1.Negative_flag;
end;


(******************************************)
function Abs(const v1: TMultiIntX4): TMultiIntX4; overload;
begin
  Result := v1;
  Result.Negative_flag := uBoolFalse;

  if (not v1.Defined_flag) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
  end;
end;


(******************************************)
function Multi_Int_X4_Odd(const v1: TMultiIntX4): boolean; inline;
var
  bit1_mask: INT_1W_U;
begin

  bit1_mask := $1;

  if ((v1.M_Value[0] and bit1_mask) = bit1_mask) then
  begin
    Result := True;
  end
  else
  begin
    Result := False;
  end;

  if (not v1.Defined_flag) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
  end;

end;


(******************************************)
function Odd(const v1: TMultiIntX4): boolean; overload;
begin
  Result := Multi_Int_X4_Odd(v1);
end;


(******************************************)
function Multi_Int_X4_Even(const v1: TMultiIntX4): boolean; inline;
var
  bit1_mask: INT_1W_U;
begin

  bit1_mask := $1;

  if ((v1.M_Value[0] and bit1_mask) = bit1_mask) then
  begin
    Result := False;
  end
  else
  begin
    Result := True;
  end;

  if (not v1.Defined_flag) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
  end;

end;


(******************************************)
function Even(const v1: TMultiIntX4): boolean; overload;
begin
  Result := Multi_Int_X4_Even(v1);
end;


(******************************************)
function nlz_words_X4(m: TMultiIntX4): INT_1W_U; // v2
var
  i, n: TMultiInt32;
  fini: boolean;
begin
  n    := 0;
  i    := Multi_X4_maxi;
  fini := False;
  repeat
    if (i < 0) then
    begin
      fini := True;
    end
    else if (m.M_Value[i] <> 0) then
    begin
      fini := True;
    end
    else
    begin
      Inc(n);
      Dec(i);
    end;
  until fini;
  Result := n;
end;


(******************************************)
function nlz_MultiBits_X4(v1: TMultiIntX4): INT_1W_U;
var
  w: INT_1W_U;
begin
  if (not v1.Defined_flag) then
  begin
    Result := 0;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
  end;

  w := nlz_words_X4(v1);
  if (w <= Multi_X4_maxi) then
  begin
    Result :=
      nlz_bits(v1.M_Value[Multi_X4_maxi - w]) + (w * INT_1W_SIZE);
  end
  else
  begin
    Result := (w * INT_1W_SIZE);
  end;
end;


{$ifdef CPU_32}
(******************************************)
procedure ShiftUp_NBits_Multi_Int_X4(var v1: TMultiIntX4; NBits: INT_1W_U);
var
  carry_bits_1, carry_bits_2, carry_bits_mask, NBits_max, NBits_carry: INT_1W_U;

  procedure INT_1W_U_shl(var v1: INT_1W_U; const nbits: INT_1W_U); inline;
  var
    carry_bits_mask_2w: INT_2W_U;
  begin
    carry_bits_mask_2w := v1;
    carry_bits_mask_2w := (carry_bits_mask_2w << NBits);
    v1 := INT_1W_U(carry_bits_mask_2w and INT_1W_U_MAXINT);
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
      carry_bits_1 := ((v1.M_Value[0] and carry_bits_mask) >> NBits_carry);
      INT_1W_U_shl(v1.M_Value[0], NBits);

      carry_bits_2 := ((v1.M_Value[1] and carry_bits_mask) >> NBits_carry);
      INT_1W_U_shl(v1.M_Value[1], NBits);
      v1.M_Value[1] := (v1.M_Value[1] or carry_bits_1);

      carry_bits_1 := ((v1.M_Value[2] and carry_bits_mask) >> NBits_carry);
      INT_1W_U_shl(v1.M_Value[2], NBits);
      v1.M_Value[2] := (v1.M_Value[2] or carry_bits_2);

      carry_bits_2 := ((v1.M_Value[3] and carry_bits_mask) >> NBits_carry);
      INT_1W_U_shl(v1.M_Value[3], NBits);
      v1.M_Value[3] := (v1.M_Value[3] or carry_bits_1);

      carry_bits_1 := ((v1.M_Value[4] and carry_bits_mask) >> NBits_carry);
      INT_1W_U_shl(v1.M_Value[4], NBits);
      v1.M_Value[4] := (v1.M_Value[4] or carry_bits_2);

      carry_bits_2 := ((v1.M_Value[5] and carry_bits_mask) >> NBits_carry);
      INT_1W_U_shl(v1.M_Value[5], NBits);
      v1.M_Value[5] := (v1.M_Value[5] or carry_bits_1);

      carry_bits_1 := ((v1.M_Value[6] and carry_bits_mask) >> NBits_carry);
      INT_1W_U_shl(v1.M_Value[6], NBits);
      v1.M_Value[6] := (v1.M_Value[6] or carry_bits_2);

      INT_1W_U_shl(v1.M_Value[7], NBits);
      v1.M_Value[7] := (v1.M_Value[7] or carry_bits_1);
    end;
  end;

end;
{$endif}


{$ifdef CPU_64}

(******************************************)
procedure ShiftUp_NBits_Multi_Int_X4(Var v1:TMultiIntX4; NBits:INT_1W_U);
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
        carry_bits_1:= ((v1.M_Value[0] and carry_bits_mask) >> NBits_carry);
        v1.M_Value[0]:= (v1.M_Value[0] << NBits);

        carry_bits_2:= ((v1.M_Value[1] and carry_bits_mask) >> NBits_carry);
        v1.M_Value[1]:= ((v1.M_Value[1] << NBits) OR carry_bits_1);

        carry_bits_1:= ((v1.M_Value[2] and carry_bits_mask) >> NBits_carry);
        v1.M_Value[2]:= ((v1.M_Value[2] << NBits) OR carry_bits_2);

        carry_bits_2:= ((v1.M_Value[3] and carry_bits_mask) >> NBits_carry);
        v1.M_Value[3]:= ((v1.M_Value[3] << NBits) OR carry_bits_1);

        carry_bits_1:= ((v1.M_Value[4] and carry_bits_mask) >> NBits_carry);
        v1.M_Value[4]:= ((v1.M_Value[4] << NBits) OR carry_bits_2);

        carry_bits_2:= ((v1.M_Value[5] and carry_bits_mask) >> NBits_carry);
        v1.M_Value[5]:= ((v1.M_Value[5] << NBits) OR carry_bits_1);

        carry_bits_1:= ((v1.M_Value[6] and carry_bits_mask) >> NBits_carry);
        v1.M_Value[6]:= ((v1.M_Value[6] << NBits) OR carry_bits_2);

        v1.M_Value[7]:= ((v1.M_Value[7] << NBits) OR carry_bits_1);
        end;
end;

end;

{$endif}


(******************************************)
procedure ShiftUp_NWords_Multi_Int_X4(var v1: TMultiIntX4; NWords: INT_1W_U);
var
  n: INT_1W_U;
begin
  if (NWords > 0) then
  begin
    if (NWords <= Multi_X4_maxi) then
    begin
      n := NWords;
      while (n > 0) do
      begin
        v1.M_Value[7] := v1.M_Value[6];
        v1.M_Value[6] := v1.M_Value[5];
        v1.M_Value[5] := v1.M_Value[4];
        v1.M_Value[4] := v1.M_Value[3];
        v1.M_Value[3] := v1.M_Value[2];
        v1.M_Value[2] := v1.M_Value[1];
        v1.M_Value[1] := v1.M_Value[0];
        v1.M_Value[0] := 0;
        Dec(n);
      end;
    end
    else
    begin
      v1.M_Value[0] := 0;
      v1.M_Value[1] := 0;
      v1.M_Value[2] := 0;
      v1.M_Value[3] := 0;
      v1.M_Value[4] := 0;
      v1.M_Value[5] := 0;
      v1.M_Value[6] := 0;
      v1.M_Value[7] := 0;
    end;
  end;
end;


(******************************************)
procedure ShiftDown_NBits_Multi_Int_X4(var v1: TMultiIntX4; NBits: INT_1W_U);
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
    carry_bits_mask := (carry_bits_mask >> NBits_carry);

    if NBits <= NBits_max then
    begin

      carry_bits_1  := ((v1.M_Value[7] and carry_bits_mask) << NBits_carry);
      v1.M_Value[7] := (v1.M_Value[7] >> NBits);

      carry_bits_2  := ((v1.M_Value[6] and carry_bits_mask) << NBits_carry);
      v1.M_Value[6] := ((v1.M_Value[6] >> NBits) or carry_bits_1);

      carry_bits_1  := ((v1.M_Value[5] and carry_bits_mask) << NBits_carry);
      v1.M_Value[5] := ((v1.M_Value[5] >> NBits) or carry_bits_2);

      carry_bits_2  := ((v1.M_Value[4] and carry_bits_mask) << NBits_carry);
      v1.M_Value[4] := ((v1.M_Value[4] >> NBits) or carry_bits_1);

      carry_bits_1  := ((v1.M_Value[3] and carry_bits_mask) << NBits_carry);
      v1.M_Value[3] := ((v1.M_Value[3] >> NBits) or carry_bits_2);

      carry_bits_2  := ((v1.M_Value[2] and carry_bits_mask) << NBits_carry);
      v1.M_Value[2] := ((v1.M_Value[2] >> NBits) or carry_bits_1);

      carry_bits_1  := ((v1.M_Value[1] and carry_bits_mask) << NBits_carry);
      v1.M_Value[1] := ((v1.M_Value[1] >> NBits) or carry_bits_2);

      v1.M_Value[0] := ((v1.M_Value[0] >> NBits) or carry_bits_1);

    end;
  end;

end;


(******************************************)
procedure ShiftDown_NWords_Multi_Int_X4(var v1: TMultiIntX4; NWords: INT_1W_U);
var
  n: INT_1W_U;
begin
  if (NWords > 0) then
  begin
    if (NWords <= Multi_X4_maxi) then
    begin
      n := NWords;
      while (n > 0) do
      begin
        v1.M_Value[0] := v1.M_Value[1];
        v1.M_Value[1] := v1.M_Value[2];
        v1.M_Value[2] := v1.M_Value[3];
        v1.M_Value[3] := v1.M_Value[4];
        v1.M_Value[4] := v1.M_Value[5];
        v1.M_Value[5] := v1.M_Value[6];
        v1.M_Value[6] := v1.M_Value[7];
        v1.M_Value[7] := 0;
        Dec(n);
      end;
    end
    else
    begin
      v1.M_Value[0] := 0;
      v1.M_Value[1] := 0;
      v1.M_Value[2] := 0;
      v1.M_Value[3] := 0;
      v1.M_Value[4] := 0;
      v1.M_Value[5] := 0;
      v1.M_Value[6] := 0;
      v1.M_Value[7] := 0;
    end;
  end;
end;


{******************************************}
procedure ShiftUp_MultiBits_Multi_Int_X4(var v1: TMultiIntX4; NBits: INT_1W_U);
var
  NWords_count, NBits_count: INT_1W_U;
begin
  if (not v1.Defined_flag) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (NBits > 0) then
  begin
    if (NBits >= INT_1W_SIZE) then
    begin
      NWords_count := (NBits div INT_1W_SIZE);
      NBits_count  := (NBits mod INT_1W_SIZE);
      ShiftUp_NWords_Multi_Int_X4(v1, NWords_count);
    end
    else
    begin
      NBits_count := NBits;
    end;
    ShiftUp_NBits_Multi_Int_X4(v1, NBits_count);
  end;
end;


{******************************************}
procedure ShiftDown_MultiBits_Multi_Int_X4(var v1: TMultiIntX4; NBits: INT_1W_U);
var
  NWords_count, NBits_count: INT_1W_U;
begin
  if (not v1.Defined_flag) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (NBits >= INT_1W_SIZE) then
  begin
    NWords_count := (NBits div INT_1W_SIZE);
    NBits_count  := (NBits mod INT_1W_SIZE);
    ShiftDown_NWords_Multi_Int_X4(v1, NWords_count);
  end
  else
  begin
    NBits_count := NBits;
  end;

  ShiftDown_NBits_Multi_Int_X4(v1, NBits_count);
end;


{******************************************}
class operator TMultiIntX4.shl(const v1: TMultiIntX4;
  const NBits: INT_1W_U): TMultiIntX4;
begin
  Result := v1;
  ShiftUp_MultiBits_Multi_Int_X4(Result, NBits);
end;


{******************************************}
class operator TMultiIntX4.shr(const v1: TMultiIntX4;
  const NBits: INT_1W_U): TMultiIntX4;
begin
  Result := v1;
  ShiftDown_MultiBits_Multi_Int_X4(Result, NBits);
end;


(******************************************)
class operator TMultiIntX4.<=(const v1, v2: TMultiIntX4): boolean;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) or (v1.Overflow_flag) or
    (v2.Overflow_flag) then
  begin
    Result := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Result := False;
  if ((v1.Negative_flag = False) and (v2.Negative_flag = True)) then
  begin
    Result := False;
  end
  else
  if ((v1.Negative_flag = True) and (v2.Negative_flag = False)) then
  begin
    Result := True;
  end
  else
  if ((v1.Negative_flag = False) and (v2.Negative_flag = False)) then
  begin
    Result := (not ABS_greaterthan_Multi_Int_X4(v1, v2));
  end
  else
  if ((v1.Negative_flag = True) and (v2.Negative_flag = True)) then
  begin
    Result := (not ABS_lessthan_Multi_Int_X4(v1, v2));
  end;
end;


(******************************************)
class operator TMultiIntX4.>=(const v1, v2: TMultiIntX4): boolean;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) or (v1.Overflow_flag) or
    (v2.Overflow_flag) then
  begin
    Result := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Result := False;
  if ((v1.Negative_flag = False) and (v2.Negative_flag = True)) then
  begin
    Result := True;
  end
  else
  if ((v1.Negative_flag = True) and (v2.Negative_flag = False)) then
  begin
    Result := False;
  end
  else
  if ((v1.Negative_flag = False) and (v2.Negative_flag = False)) then
  begin
    Result := (not ABS_lessthan_Multi_Int_X4(v1, v2));
  end
  else
  if ((v1.Negative_flag = True) and (v2.Negative_flag = True)) then
  begin
    Result := (not ABS_greaterthan_Multi_Int_X4(v1, v2));
  end;
end;


(******************************************)
class operator TMultiIntX4.>(const v1, v2: TMultiIntX4): boolean;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) or (v1.Overflow_flag) or
    (v2.Overflow_flag) then
  begin
    Result := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Result := False;
  if ((v1.Negative_flag = False) and (v2.Negative_flag = True)) then
  begin
    Result := True;
  end
  else
  if ((v1.Negative_flag = True) and (v2.Negative_flag = False)) then
  begin
    Result := False;
  end
  else
  if ((v1.Negative_flag = False) and (v2.Negative_flag = False)) then
  begin
    Result := ABS_greaterthan_Multi_Int_X4(v1, v2);
  end
  else
  if ((v1.Negative_flag = True) and (v2.Negative_flag = True)) then
  begin
    Result := ABS_lessthan_Multi_Int_X4(v1, v2);
  end;
end;


(******************************************)
class operator TMultiIntX4.<(const v1, v2: TMultiIntX4): boolean;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) or (v1.Overflow_flag) or
    (v2.Overflow_flag) then
  begin
    Result := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Result := False;
  if ((v1.Negative_flag = True) and (v2.Negative_flag = False)) then
  begin
    Result := True;
  end
  else
  if ((v1.Negative_flag = False) and (v2.Negative_flag = False)) then
  begin
    Result := ABS_lessthan_Multi_Int_X4(v1, v2);
  end
  else
  if ((v1.Negative_flag = True) and (v2.Negative_flag = True)) then
  begin
    Result := ABS_greaterthan_Multi_Int_X4(v1, v2);
  end;
end;


(******************************************)
class operator TMultiIntX4.=(const v1, v2: TMultiIntX4): boolean;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) or (v1.Overflow_flag) or
    (v2.Overflow_flag) then
  begin
    Result := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Result := True;
  if (v1.Negative_flag <> v2.Negative_flag) then
  begin
    Result := False;
  end
  else
  begin
    Result := ABS_equal_Multi_Int_X4(v1, v2);
  end;
end;


(******************************************)
class operator TMultiIntX4.<>(const v1, v2: TMultiIntX4): boolean;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) or (v1.Overflow_flag) or
    (v2.Overflow_flag) then
  begin
    Result := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Result := False;
  if (v1.Negative_flag <> v2.Negative_flag) then
  begin
    Result := True;
  end
  else
  begin
    Result := (not ABS_equal_Multi_Int_X4(v1, v2));
  end;
end;


(******************************************)
function To_Multi_Int_X4(const v1: TMultiIntXV): TMultiIntX4;
label
  OVERFLOW_BRANCH, CLEAN_EXIT;
var
  n: INT_2W_U;
begin
  if (v1.Defined_flag = False) then
  begin
    Multi_Int_ERROR     := True;
    Result.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (v1.Overflow_flag = True) then
  begin
    goto OVERFLOW_BRANCH;
  end;

  Result.Overflow_flag := v1.Overflow_flag;
  Result.Defined_flag  := v1.Defined_flag;
  Result.Negative_flag := v1.Negative_flag;

  n := 0;
  if (Multi_XV_size > Multi_X4_size) then
  begin
    while (n <= Multi_X4_maxi) do
    begin
      Result.M_Value[n] := v1.M_Value[n];
      Inc(n);
    end;
    while (n <= Multi_XV_maxi) do
    begin
      if (v1.M_Value[n] <> 0) then
      begin
        goto OVERFLOW_BRANCH;
      end;
      Inc(n);
    end;
  end
  else
  begin
    while (n <= Multi_XV_maxi) do
    begin
      Result.M_Value[n] := v1.M_Value[n];
      Inc(n);
    end;
    while (n <= Multi_X4_maxi) do
    begin
      Result.M_Value[n] := 0;
      Inc(n);
    end;
  end;

  goto CLEAN_EXIT;

  OVERFLOW_BRANCH:

    Multi_Int_ERROR    := True;
  Result.Overflow_flag := True;
  if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
  begin
    raise EInterror.Create('Overflow');
  end;
  exit;

  CLEAN_EXIT: ;

end;

{
var n :INT_1W_U;
begin
Result.Overflow_flag:= v1.Overflow_flag;
Result.Defined_flag:= v1.Defined_flag;
Result.Negative_flag:= v1.Negative_flag;

if  (v1.Defined_flag = FALSE)
then
  begin
  if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
    Raise EInterror.create('Uninitialised variable');
    end;
  Result.Defined_flag:= FALSE;
  exit;
  end;

if  (v1.Overflow_flag = TRUE)
then
  begin
  Result.Overflow_flag:= TRUE;
  Multi_Int_ERROR:= TRUE;
  if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
    Raise EInterror.create('Overflow');
    end;
  exit;
  end;

n:= 0;
while (n <= Multi_X4_maxi) do
  begin
  Result.M_Value[n]:= v1.M_Value[n];
  inc(n);
  end;
end;
}


(******************************************)
function To_Multi_Int_X4(const v1: TMultiIntX3): TMultiIntX4;
var
  n: INT_1W_U;
begin
  Result.Overflow_flag := v1.Overflow_flag;
  Result.Defined_flag  := v1.Defined_flag;
  Result.Negative_flag := v1.Negative_flag;

  if (v1.Defined_flag = False) then
  begin
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    Result.Defined_flag := False;
    exit;
  end;

  if (v1.Overflow_flag = True) then
  begin
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    Result.Overflow_flag := True;
    exit;
  end;

  n := 0;
  while (n <= Multi_X3_maxi) do
  begin
    Result.M_Value[n] := v1.M_Value[n];
    Inc(n);
  end;

  while (n <= Multi_X4_maxi) do
  begin
    Result.M_Value[n] := 0;
    Inc(n);
  end;
end;


(******************************************)
function To_Multi_Int_X4(const v1: TMultiIntX2): TMultiIntX4;
var
  n: INT_1W_U;
begin
  Result.Overflow_flag := v1.FHasOverflow;
  Result.Defined_flag  := v1.FIsDefined;
  Result.Negative_flag := v1.FIsNegative;

  if (v1.FIsDefined = False) then
  begin
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    Result.Defined_flag := False;
    exit;
  end;

  if (v1.FHasOverflow = True) then
  begin
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    Result.Overflow_flag := True;
    exit;
  end;

  n := 0;
  while (n <= Multi_X2_maxi) do
  begin
    Result.M_Value[n] := v1.FParts[n];
    Inc(n);
  end;

  while (n <= Multi_X4_maxi) do
  begin
    Result.M_Value[n] := 0;
    Inc(n);
  end;
end;


(******************************************)
procedure Multi_Int_X2_to_Multi_Int_X4(const v1: TMultiIntX2;
  out MI: TMultiIntX4); inline;
var
  n: INT_1W_U;
begin
  MI.Overflow_flag := v1.FHasOverflow;
  MI.Defined_flag  := v1.FIsDefined;
  MI.Negative_flag := v1.FIsNegative;

  if (v1.FIsDefined = False) then
  begin
    Multi_Int_ERROR := True;
    MI.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (v1.FHasOverflow = True) then
  begin
    Multi_Int_ERROR  := True;
    MI.Overflow_flag := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    exit;
  end;

  n := 0;
  while (n <= Multi_X2_maxi) do
  begin
    MI.M_Value[n] := v1.FParts[n];
    Inc(n);
  end;

  while (n <= Multi_X4_maxi) do
  begin
    MI.M_Value[n] := 0;
    Inc(n);
  end;
end;


(******************************************)
class operator TMultiIntX4.:=(const v1: TMultiIntX2): TMultiIntX4;
begin
  Multi_Int_X2_to_Multi_Int_X4(v1, Result);
end;


(******************************************)
procedure Multi_Int_X3_to_Multi_Int_X4(const v1: TMultiIntX3;
  out MI: TMultiIntX4); inline;
var
  n: INT_1W_U;
begin
  MI.Overflow_flag := v1.Overflow_flag;
  MI.Defined_flag  := v1.Defined_flag;
  MI.Negative_flag := v1.Negative_flag;

  if (v1.Defined_flag = False) then
  begin
    Multi_Int_ERROR := True;
    MI.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (v1.Overflow_flag = True) then
  begin
    Multi_Int_ERROR  := True;
    MI.Overflow_flag := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    exit;
  end;

  n := 0;
  while (n <= Multi_X3_maxi) do
  begin
    MI.M_Value[n] := v1.M_Value[n];
    Inc(n);
  end;

  while (n <= Multi_X4_maxi) do
  begin
    MI.M_Value[n] := 0;
    Inc(n);
  end;
end;


(******************************************)
class operator TMultiIntX4.:=(const v1: TMultiIntX3): TMultiIntX4;
begin
  Multi_Int_X3_to_Multi_Int_X4(v1, Result);
end;


(******************************************)
procedure String_to_Multi_Int_X4(const v1: ansistring; out mi: TMultiIntX4); inline;
label
  999;
var
  i, b, c, e: INT_2W_U;
  M_Val: array[0..Multi_X4_maxi] of INT_2W_U;
  Signeg, Zeroneg: boolean;
begin
  Multi_Int_ERROR := False;

  mi.Overflow_flag := False;
  mi.Defined_flag := True;
  mi.Negative_flag := False;
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

  if (length(v1) > 0) then
  begin
    b := low(ansistring);
    e := b + INT_2W_U(length(v1)) - 1;
    if (v1[b] = '-') then
    begin
      Signeg := True;
      Inc(b);
    end;

    c := b;
    while (c <= e) do
    begin
      try
        i := StrToInt(v1[c]);
      except
        on EConvertError do
        begin
          mi.Defined_flag  := False;
          mi.Overflow_flag := True;
          Multi_Int_ERROR  := True;
          if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
          begin
            raise;
          end;
        end;
      end;
      if mi.Defined_flag = False then
      begin
        goto 999;
      end;
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
        mi.Defined_flag  := False;
        mi.Overflow_flag := True;
        Multi_Int_ERROR  := True;
        if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
        begin
          raise EIntOverflow.Create('Overflow');
        end;
        goto 999;
      end;
      Inc(c);
    end;
  end;

  mi.M_Value[0] := M_Val[0];
  mi.M_Value[1] := M_Val[1];
  mi.M_Value[2] := M_Val[2];
  mi.M_Value[3] := M_Val[3];
  mi.M_Value[4] := M_Val[4];
  mi.M_Value[5] := M_Val[5];
  mi.M_Value[6] := M_Val[6];
  mi.M_Value[7] := M_Val[7];

  if (M_Val[0] = 0) and (M_Val[1] = 0) and (M_Val[2] = 0) and
    (M_Val[3] = 0) and (M_Val[4] = 0) and (M_Val[5] = 0) and
    (M_Val[6] = 0) and (M_Val[7] = 0) then
  begin
    Zeroneg := True;
  end;

  if Zeroneg then
  begin
    mi.Negative_flag := uBoolFalse;
  end
  else if Signeg then
  begin
    mi.Negative_flag := uBoolTrue;
  end
  else
  begin
    mi.Negative_flag := uBoolFalse;
  end;

  999: ;
end;


(******************************************)
class operator TMultiIntX4.:=(const v1: ansistring): TMultiIntX4;
begin
  String_to_Multi_Int_X4(v1, Result);
end;


{$ifdef CPU_32}
(******************************************)
procedure INT_4W_S_to_Multi_Int_X4(const v1: INT_4W_S; out mi: TMultiIntX4); inline;
var
  v: INT_4W_U;
begin
  mi.Overflow_flag := False;
  mi.Defined_flag := True;
  v := Abs(v1);

  v := v1;
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

  if (v1 < 0) then
  begin
    mi.Negative_flag := uBoolTrue;
  end
  else
  begin
    mi.Negative_flag := uBoolFalse;
  end;

end;


(******************************************)
class operator TMultiIntX4.:=(const v1: INT_4W_S): TMultiIntX4;
begin
  INT_4W_S_to_Multi_Int_X4(v1, Result);
end;


(******************************************)
procedure INT_4W_U_to_Multi_Int_X4(const v1: INT_4W_U; out mi: TMultiIntX4); inline;
var
  v: INT_4W_U;
begin
  mi.Overflow_flag := False;
  mi.Defined_flag  := True;
  mi.Negative_flag := uBoolFalse;

  v := v1;
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
class operator TMultiIntX4.:=(const v1: INT_4W_U): TMultiIntX4;
begin
  INT_4W_U_to_Multi_Int_X4(v1, Result);
end;
{$endif}


(******************************************)
procedure INT_2W_S_to_Multi_Int_X4(const v1: INT_2W_S; out mi: TMultiIntX4); inline;
begin
  mi.Overflow_flag := False;
  mi.Defined_flag  := True;
  mi.M_Value[2]    := 0;
  mi.M_Value[3]    := 0;
  mi.M_Value[4]    := 0;
  mi.M_Value[5]    := 0;
  mi.M_Value[6]    := 0;
  mi.M_Value[7]    := 0;

  if (v1 < 0) then
  begin
    mi.Negative_flag := uBoolTrue;
    mi.M_Value[0]    := (ABS(v1) mod INT_1W_U_MAXINT_1);
    mi.M_Value[1]    := (ABS(v1) div INT_1W_U_MAXINT_1);
  end
  else
  begin
    mi.Negative_flag := uBoolFalse;
    mi.M_Value[0]    := (v1 mod INT_1W_U_MAXINT_1);
    mi.M_Value[1]    := (v1 div INT_1W_U_MAXINT_1);
  end;
end;


(******************************************)
class operator TMultiIntX4.:=(const v1: INT_2W_S): TMultiIntX4;
begin
  INT_2W_S_to_Multi_Int_X4(v1, Result);
end;


(******************************************)
procedure INT_2W_U_to_Multi_Int_X4(const v1: INT_2W_U; out mi: TMultiIntX4); inline;
begin
  mi.Overflow_flag := False;
  mi.Defined_flag  := True;
  mi.Negative_flag := uBoolFalse;

  mi.M_Value[0] := (v1 mod INT_1W_U_MAXINT_1);
  mi.M_Value[1] := (v1 div INT_1W_U_MAXINT_1);
  mi.M_Value[2] := 0;
  mi.M_Value[3] := 0;
  mi.M_Value[4] := 0;
  mi.M_Value[5] := 0;
  mi.M_Value[6] := 0;
  mi.M_Value[7] := 0;
end;


(******************************************)
class operator TMultiIntX4.:=(const v1: INT_2W_U): TMultiIntX4;
begin
  INT_2W_U_to_Multi_Int_X4(v1, Result);
end;


(******************************************)
// WARNING Float to Multi_Int type conversion loses some precision
class operator TMultiIntX4.:=(const v1: single): TMultiIntX4;
var
  R: TMultiIntX4;
  R_FLOATREC: TFloatRec;
begin
  Multi_Int_ERROR := False;

  FloatToDecimal(R_FLOATREC, v1, SINGLE_TYPE_PRECISION_DIGITS, 0);
  String_to_Multi_Int_X4(AddCharR('0', AnsiLeftStr(R_FLOATREC.digits,
    (SINGLE_TYPE_PRECISION_DIGITS - 1)), R_FLOATREC.Exponent), R);

  if (R.Overflow) then
  begin
    Multi_Int_ERROR      := True;
    Result.Defined_flag  := False;
    Result.Negative_flag := uBoolUndefined;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  if (R_FLOATREC.Negative) then
  begin
    R.Negative_flag := True;
  end;
  Result := R;
end;


(******************************************)
// WARNING Float to Multi_Int type conversion loses some precision
class operator TMultiIntX4.:=(const v1: real): TMultiIntX4;
var
  R: TMultiIntX4;
  R_FLOATREC: TFloatRec;
begin
  Multi_Int_ERROR := False;

  FloatToDecimal(R_FLOATREC, v1, REAL_TYPE_PRECISION_DIGITS, 0);
  String_to_Multi_Int_X4(AddCharR('0', AnsiLeftStr(R_FLOATREC.digits,
    (REAL_TYPE_PRECISION_DIGITS - 1)), R_FLOATREC.Exponent), R);

  if (R.Overflow) then
  begin
    Multi_Int_ERROR      := True;
    Result.Defined_flag  := False;
    Result.Negative_flag := uBoolUndefined;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  if (R_FLOATREC.Negative) then
  begin
    R.Negative_flag := True;
  end;
  Result := R;
end;


(******************************************)
// WARNING Float to Multi_Int type conversion loses some precision
class operator TMultiIntX4.:=(const v1: double): TMultiIntX4;
var
  R: TMultiIntX4;
  R_FLOATREC: TFloatRec;
begin
  Multi_Int_ERROR := False;

  FloatToDecimal(R_FLOATREC, v1, DOUBLE_TYPE_PRECISION_DIGITS, 0);
  String_to_Multi_Int_X4(AddCharR('0', AnsiLeftStr(R_FLOATREC.digits,
    (DOUBLE_TYPE_PRECISION_DIGITS - 1)), R_FLOATREC.Exponent), R);

  if (R.Overflow) then
  begin
    Multi_Int_ERROR      := True;
    Result.Defined_flag  := False;
    Result.Negative_flag := uBoolUndefined;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  if (R_FLOATREC.Negative) then
  begin
    R.Negative_flag := True;
  end;
  Result := R;
end;


(******************************************)
// WARNING Float to Multi_Int type conversion loses some precision
class operator TMultiIntX4.:=(const v1: TMultiIntX4): single;
var
  R, V, M: single;
  i: INT_1W_U;
  finished: boolean;
begin
  if (not v1.Defined_flag) then
  begin
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Multi_Int_ERROR := False;
  finished := False;
  M := INT_1W_U_MAXINT_1;

  R := v1.M_Value[0];
  i := 1;
  while (i <= Multi_X4_maxi) and (not Multi_Int_ERROR) do
  begin
    if (not finished) then
    begin
      V := v1.M_Value[i];
      try
        begin
          V := (V * M);
          R := R + V;
        end
      except
        begin
          Multi_Int_ERROR := True;
          if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
          begin
            raise EIntOverflow.Create('Overflow');
          end;
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
    begin
      if (v1.M_Value[i] > 0) then
      begin
        Multi_Int_ERROR := True;
        if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
        begin
          raise EIntOverflow.Create('Overflow');
        end;
      end;
    end;
    Inc(i);
  end;

  if v1.Negative_flag then
  begin
    R := (-R);
  end;
  Result := R;
end;


(******************************************)
class operator TMultiIntX4.:=(const v1: TMultiIntX4): real;
var
  R, V, M: real;
  i: INT_1W_U;
  finished: boolean;
begin
  if (not v1.Defined_flag) then
  begin
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Multi_Int_ERROR := False;
  finished := False;
  M := INT_1W_U_MAXINT_1;

  R := v1.M_Value[0];
  i := 1;
  while (i <= Multi_X4_maxi) and (not Multi_Int_ERROR) do
  begin
    if (not finished) then
    begin
      V := v1.M_Value[i];
      try
        begin
          V := (V * M);
          R := R + V;
        end
      except
        begin
          Multi_Int_ERROR := True;
          if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
          begin
            raise EIntOverflow.Create('Overflow');
          end;
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
    begin
      if (v1.M_Value[i] > 0) then
      begin
        Multi_Int_ERROR := True;
        if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
        begin
          raise EIntOverflow.Create('Overflow');
        end;
      end;
    end;
    Inc(i);
  end;

  if v1.Negative_flag then
  begin
    R := (-R);
  end;
  Result := R;
end;


(******************************************)
class operator TMultiIntX4.:=(const v1: TMultiIntX4): double;
var
  R, V, M: double;
  i: INT_1W_U;
  finished: boolean;
begin
  if (not v1.Defined_flag) then
  begin
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Multi_Int_ERROR := False;
  finished := False;
  M := INT_1W_U_MAXINT_1;

  R := v1.M_Value[0];
  i := 1;
  while (i <= Multi_X4_maxi) and (not Multi_Int_ERROR) do
  begin
    if (not finished) then
    begin
      V := v1.M_Value[i];
      try
        begin
          V := (V * M);
          R := R + V;
        end
      except
        begin
          Multi_Int_ERROR := True;
          if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
          begin
            raise EIntOverflow.Create('Overflow');
          end;
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
    begin
      if (v1.M_Value[i] > 0) then
      begin
        Multi_Int_ERROR := True;
        if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
        begin
          raise EIntOverflow.Create('Overflow');
        end;
      end;
    end;
    Inc(i);
  end;

  if v1.Negative_flag then
  begin
    R := (-R);
  end;
  Result := R;
end;


(******************************************)
class operator TMultiIntX4.:=(const v1: TMultiIntX4): INT_2W_S;
var
  R: INT_2W_U;
begin
  if (not v1.Defined_flag) then
  begin
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  R := (INT_2W_U(v1.M_Value[0]) + (INT_2W_U(v1.M_Value[1]) * INT_1W_U_MAXINT_1));

  if (R >= INT_2W_S_MAXINT) or (v1.M_Value[2] <> 0) or (v1.M_Value[3] <> 0) or
    (v1.M_Value[4] <> 0) or (v1.M_Value[5] <> 0) or (v1.M_Value[6] <> 0) or
    (v1.M_Value[7] <> 0) then
  begin
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if v1.Negative_flag then
  begin
    Result := INT_2W_S(-R);
  end
  else
  begin
    Result := INT_2W_S(R);
  end;
end;


(******************************************)
class operator TMultiIntX4.:=(const v1: TMultiIntX4): INT_2W_U;
var
  R: INT_2W_U;
begin
  Multi_Int_ERROR := False;
  if (not v1.Defined_flag) then
  begin
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  R := (INT_2W_U(v1.M_Value[1]) << INT_1W_SIZE);
  R := (R or INT_2W_U(v1.M_Value[0]));

  if (v1.M_Value[2] <> 0) or (v1.M_Value[3] <> 0) or (v1.M_Value[4] <> 0) or
    (v1.M_Value[5] <> 0) or (v1.M_Value[6] <> 0) or (v1.M_Value[7] <> 0) then
  begin
    Result := 0;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    exit;
  end;

  Result := R;
end;


(******************************************)
class operator TMultiIntX4.:=(const v1: TMultiIntX4): INT_1W_S;
var
  R: INT_2W_U;
begin
  Multi_Int_ERROR := False;
  if (not v1.Defined_flag) then
  begin
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  R := (INT_2W_U(v1.M_Value[0]) + (INT_2W_U(v1.M_Value[1]) * INT_1W_U_MAXINT_1));

  if (R > INT_1W_S_MAXINT) or (v1.M_Value[2] <> 0) or (v1.M_Value[3] <> 0) or
    (v1.M_Value[4] <> 0) or (v1.M_Value[5] <> 0) or (v1.M_Value[6] <> 0) or
    (v1.M_Value[7] <> 0) then
  begin
    Result := 0;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    exit;
  end;

  if v1.Negative_flag then
  begin
    Result := INT_1W_S(-R);
  end
  else
  begin
    Result := INT_1W_S(R);
  end;
end;


(******************************************)
class operator TMultiIntX4.:=(const v1: TMultiIntX4): INT_1W_U;
var
  R: INT_2W_U;
begin
  Multi_Int_ERROR := False;
  if (not v1.Defined_flag) or (v1.Negative_flag = uBoolTrue) then
  begin
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  R := (INT_2W_U(v1.M_Value[0]) + (INT_2W_U(v1.M_Value[1]) * INT_1W_U_MAXINT_1));

  if (R > INT_1W_U_MAXINT) or (v1.M_Value[2] <> 0) or (v1.M_Value[3] <> 0) or
    (v1.M_Value[4] <> 0) or (v1.M_Value[5] <> 0) or (v1.M_Value[6] <> 0) or
    (v1.M_Value[7] <> 0) then
  begin
    Result := 0;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    exit;
  end;

  Result := INT_1W_U(R);
end;


{******************************************}
class operator TMultiIntX4.:=(const v1: TMultiIntX4): TMultiUInt8;
  (* var  R  :TMultiUInt8; *)
begin
  Multi_Int_ERROR := False;
  if (not v1.Defined_flag) or (v1.Negative_flag = uBoolTrue) then
  begin
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (v1.M_Value[0] > UINT8_MAX) or (v1.M_Value[1] <> 0) or
    (v1.M_Value[2] <> 0) or (v1.M_Value[3] <> 0) or (v1.M_Value[4] <> 0) or
    (v1.M_Value[5] <> 0) or (v1.M_Value[6] <> 0) or (v1.M_Value[7] <> 0) then
  begin
    Multi_Int_ERROR := True;
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Result := TMultiUInt8(v1.M_Value[0]);
end;


{******************************************}
class operator TMultiIntX4.:=(const v1: TMultiIntX4): TMultiInt8;
  (* var  R  :TMultiUInt8; *)
begin
  Multi_Int_ERROR := False;
  if (not v1.Defined_flag) or (v1.Negative_flag = uBoolTrue) then
  begin
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (v1.M_Value[0] > INT8_MAX) or (v1.M_Value[1] <> 0) or
    (v1.M_Value[2] <> 0) or (v1.M_Value[3] <> 0) or (v1.M_Value[4] <> 0) or
    (v1.M_Value[5] <> 0) or (v1.M_Value[6] <> 0) or (v1.M_Value[7] <> 0) then
  begin
    Multi_Int_ERROR := True;
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Result := TMultiInt8(v1.M_Value[0]);
end;


(******************************************)
procedure bin_to_Multi_Int_X4(const v1: ansistring; out mi: TMultiIntX4); inline;
label
  999;
var
  n, b, c, e: INT_2W_U;
  bit: INT_1W_S;
  M_Val: array[0..Multi_X4_maxi] of INT_2W_U;
  Signeg, Zeroneg, M_Val_All_Zero: boolean;
begin
  Multi_Int_ERROR := False;

  mi.Overflow_flag := False;
  mi.Defined_flag := True;
  mi.Negative_flag := False;
  Signeg  := False;
  Zeroneg := False;

  n := 0;
  while (n <= Multi_X4_maxi) do
  begin
    M_Val[n] := 0;
    Inc(n);
  end;

  if (length(v1) > 0) then
  begin
    b := low(ansistring);
    e := b + INT_2W_U(length(v1)) - 1;
    if (v1[b] = '-') then
    begin
      Signeg := True;
      Inc(b);
    end;

    c := b;
    while (c <= e) do
    begin
      bit := (Ord(v1[c]) - Ord('0'));
      if (bit > 1) or (bit < 0) then
      begin
        Multi_Int_ERROR  := True;
        mi.Overflow_flag := True;
        mi.Defined_flag  := False;
        if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
        begin
          raise EInterror.Create('Invalid binary digit');
        end;
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
        mi.Defined_flag  := False;
        mi.Overflow_flag := True;
        Multi_Int_ERROR  := True;
        if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
        begin
          raise EIntOverflow.Create('Overflow');
        end;
        goto 999;
      end;
      Inc(c);
    end;
  end;

  M_Val_All_Zero := True;
  n := 0;
  while (n <= Multi_X4_maxi) do
  begin
    mi.M_Value[n] := M_Val[n];
    if M_Val[n] > 0 then
    begin
      M_Val_All_Zero := False;
    end;
    Inc(n);
  end;
  if M_Val_All_Zero then
  begin
    Zeroneg := True;
  end;

  if Zeroneg then
  begin
    mi.Negative_flag := uBoolFalse;
  end
  else if Signeg then
  begin
    mi.Negative_flag := uBoolTrue;
  end
  else
  begin
    mi.Negative_flag := uBoolFalse;
  end;

  999: ;
end;


(******************************************)
procedure FromBin(const v1: ansistring; out mi: TMultiIntX4); overload;
begin
  Bin_to_Multi_Int_X4(v1, mi);
end;


(******************************************)
function TMultiIntX4.FromBin(const v1: ansistring): TMultiIntX4;
begin
  bin_to_Multi_Int_X4(v1, Result);
end;


(******************************************)
procedure Multi_Int_X4_to_bin(const v1: TMultiIntX4; out v2: ansistring;
  LZ: TMultiLeadingZeros); inline;
var
  s: ansistring = '';
  n: INT_1W_S;
begin
  if (not v1.Defined_flag) then
  begin
    v2 := 'UNDEFINED';
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.Overflow_flag) then
  begin
    v2 := 'OVERFLOW';
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    exit;
  end;

  n := INT_1W_SIZE;
  s := '';

  s := s + IntToBin(v1.M_Value[7], n) + IntToBin(v1.M_Value[6], n) +
    IntToBin(v1.M_Value[5], n) + IntToBin(v1.M_Value[4], n) +
    IntToBin(v1.M_Value[3], n) + IntToBin(v1.M_Value[2], n) +
    IntToBin(v1.M_Value[1], n) + IntToBin(v1.M_Value[0], n);

  if (LZ = TrimLeadingZeros) then
  begin
    Removeleadingchars(s, ['0']);
  end;
  if (v1.Negative_flag = uBoolTrue) then
  begin
    s := '-' + s;
  end;
  if (s = '') then
  begin
    s := '0';
  end;
  v2 := s;
end;


(******************************************)
function TMultiIntX4.Tobin(const LZ: TMultiLeadingZeros): ansistring;
begin
  Multi_Int_X4_to_bin(self, Result, LZ);
end;


(******************************************)
procedure hex_to_Multi_Int_X4(const v1: ansistring; out mi: TMultiIntX4); inline;
label
  999;
var
  n, i, b, c, e: INT_2W_U;
  M_Val: array[0..Multi_X4_maxi] of INT_2W_U;
  Signeg, Zeroneg, M_Val_All_Zero: boolean;
begin
  Multi_Int_ERROR := False;

  mi.Overflow_flag := False;
  mi.Defined_flag := True;
  mi.Negative_flag := False;
  Signeg  := False;
  Zeroneg := False;

  n := 0;
  while (n <= Multi_X4_maxi) do
  begin
    M_Val[n] := 0;
    Inc(n);
  end;

  if (length(v1) > 0) then
  begin
    b := low(ansistring);
    e := b + INT_2W_U(length(v1)) - 1;
    if (v1[b] = '-') then
    begin
      Signeg := True;
      Inc(b);
    end;

    c := b;
    while (c <= e) do
    begin
      try
        i := Hex2Dec(v1[c]);
      except
        on EConvertError do
        begin
          Multi_Int_ERROR  := True;
          mi.Overflow_flag := True;
          mi.Defined_flag  := False;
          if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
          begin
            raise;
          end;
        end;
      end;
      if mi.Defined_flag = False then
      begin
        goto 999;
      end;

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
        mi.Defined_flag  := False;
        mi.Overflow_flag := True;
        Multi_Int_ERROR  := True;
        if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
        begin
          raise EIntOverflow.Create('Overflow');
        end;
        goto 999;
      end;
      Inc(c);
    end;
  end;

  M_Val_All_Zero := True;
  n := 0;
  while (n <= Multi_X4_maxi) do
  begin
    mi.M_Value[n] := M_Val[n];
    if M_Val[n] > 0 then
    begin
      M_Val_All_Zero := False;
    end;
    Inc(n);
  end;
  if M_Val_All_Zero then
  begin
    Zeroneg := True;
  end;

  if Zeroneg then
  begin
    mi.Negative_flag := uBoolFalse;
  end
  else if Signeg then
  begin
    mi.Negative_flag := uBoolTrue;
  end
  else
  begin
    mi.Negative_flag := uBoolFalse;
  end;

  999: ;
end;


(******************************************)
procedure FromHex(const v1: ansistring; out v2: TMultiIntX4); overload;
begin
  hex_to_Multi_Int_X4(v1, v2);
end;


(******************************************)
function TMultiIntX4.FromHex(const v1: ansistring): TMultiIntX4;
begin
  hex_to_Multi_Int_X4(v1, Result);
end;


(******************************************)
procedure Multi_Int_X4_to_hex(const v1: TMultiIntX4; out v2: ansistring;
  LZ: TMultiLeadingZeros); inline;
var
  s: ansistring = '';
  n: TMultiUInt16;
begin
  if (not v1.Defined_flag) then
  begin
    v2 := 'UNDEFINED';
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.Overflow_flag) then
  begin
    v2 := 'OVERFLOW';
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    exit;
  end;

  n := (INT_1W_SIZE div 4);
  s := '';

  s := s + IntToHex(v1.M_Value[7], n) + IntToHex(v1.M_Value[6], n) +
    IntToHex(v1.M_Value[5], n) + IntToHex(v1.M_Value[4], n) +
    IntToHex(v1.M_Value[3], n) + IntToHex(v1.M_Value[2], n) +
    IntToHex(v1.M_Value[1], n) + IntToHex(v1.M_Value[0], n);

  if (LZ = TrimLeadingZeros) then
  begin
    Removeleadingchars(s, ['0']);
  end;
  if (v1.Negative_flag = uBoolTrue) then
  begin
    s := '-' + s;
  end;
  if (s = '') then
  begin
    s := '0';
  end;
  v2 := s;
end;


(******************************************)
function TMultiIntX4.ToHex(const LZ: TMultiLeadingZeros): ansistring;
begin
  Multi_Int_X4_to_hex(self, Result, LZ);
end;


(******************************************)
procedure Multi_Int_X4_to_String(const v1: TMultiIntX4; out v2: ansistring); inline;
var
  s: ansistring = '';
  M_Val: array[0..Multi_X4_maxi] of INT_2W_U;
begin
  if (not v1.Defined_flag) then
  begin
    v2 := 'UNDEFINED';
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.Overflow_flag) then
  begin
    v2 := 'OVERFLOW';
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  M_Val[0] := v1.M_Value[0];
  M_Val[1] := v1.M_Value[1];
  M_Val[2] := v1.M_Value[2];
  M_Val[3] := v1.M_Value[3];
  M_Val[4] := v1.M_Value[4];
  M_Val[5] := v1.M_Value[5];
  M_Val[6] := v1.M_Value[6];
  M_Val[7] := v1.M_Value[7];

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

  if (v1.Negative_flag = uBoolTrue) then
  begin
    s := '-' + s;
  end;

  v2 := s;
end;


(******************************************)
function TMultiIntX4.ToStr: ansistring;
begin
  Multi_Int_X4_to_String(self, Result);
end;


(******************************************)
class operator TMultiIntX4.:=(const v1: TMultiIntX4): ansistring;
begin
  Multi_Int_X4_to_String(v1, Result);
end;


(******************************************)
class operator TMultiIntX4.xor(const v1, v2: TMultiIntX4): TMultiIntX4;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.Overflow_flag or v2.Overflow_flag) then
  begin
    Result := 0;
    Result.Overflow_flag := True;
    Result.Defined_flag := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  Result.M_Value[0]    := (v1.M_Value[0] xor v2.M_Value[0]);
  Result.M_Value[1]    := (v1.M_Value[1] xor v2.M_Value[1]);
  Result.M_Value[2]    := (v1.M_Value[2] xor v2.M_Value[2]);
  Result.M_Value[3]    := (v1.M_Value[3] xor v2.M_Value[3]);
  Result.M_Value[4]    := (v1.M_Value[4] xor v2.M_Value[4]);
  Result.M_Value[5]    := (v1.M_Value[5] xor v2.M_Value[5]);
  Result.M_Value[6]    := (v1.M_Value[6] xor v2.M_Value[6]);
  Result.M_Value[7]    := (v1.M_Value[7] xor v2.M_Value[7]);
  Result.Defined_flag  := True;
  Result.Overflow_flag := False;

  Result.Negative_flag := uBoolFalse;
  if (v1.Negative <> v2.Negative) then
  begin
    Result.Negative_flag := uBoolTrue;
  end;
end;


(******************************************)
class operator TMultiIntX4.or(const v1, v2: TMultiIntX4): TMultiIntX4;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Result.M_Value[0] := (v1.M_Value[0] or v2.M_Value[0]);
  Result.M_Value[1] := (v1.M_Value[1] or v2.M_Value[1]);
  Result.M_Value[2] := (v1.M_Value[2] or v2.M_Value[2]);
  Result.M_Value[3] := (v1.M_Value[3] or v2.M_Value[3]);
  Result.M_Value[4] := (v1.M_Value[4] or v2.M_Value[4]);
  Result.M_Value[5] := (v1.M_Value[5] or v2.M_Value[5]);
  Result.M_Value[6] := (v1.M_Value[6] or v2.M_Value[6]);
  Result.M_Value[7] := (v1.M_Value[7] or v2.M_Value[7]);

  Result.Defined_flag  := True;
  Result.Overflow_flag := False;

  Result.Negative_flag := uBoolFalse;
  if v1.Negative and v2.Negative then
  begin
    Result.Negative_flag := uBoolTrue;
  end;
end;


(******************************************)
class operator TMultiIntX4.and(const v1, v2: TMultiIntX4): TMultiIntX4;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Result.M_Value[0] := (v1.M_Value[0] and v2.M_Value[0]);
  Result.M_Value[1] := (v1.M_Value[1] and v2.M_Value[1]);
  Result.M_Value[2] := (v1.M_Value[2] and v2.M_Value[2]);
  Result.M_Value[3] := (v1.M_Value[3] and v2.M_Value[3]);
  Result.M_Value[4] := (v1.M_Value[4] and v2.M_Value[4]);
  Result.M_Value[5] := (v1.M_Value[5] and v2.M_Value[5]);
  Result.M_Value[6] := (v1.M_Value[6] and v2.M_Value[6]);
  Result.M_Value[7] := (v1.M_Value[7] and v2.M_Value[7]);

  Result.Defined_flag  := True;
  Result.Overflow_flag := False;

  Result.Negative_flag := uBoolFalse;
  if v1.Negative and v2.Negative then
  begin
    Result.Negative_flag := uBoolTrue;
  end;
end;


(******************************************)
class operator TMultiIntX4.not(const v1: TMultiIntX4): TMultiIntX4;
begin
  if (not v1.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Result.M_Value[0] := (not v1.M_Value[0]);
  Result.M_Value[1] := (not v1.M_Value[1]);
  Result.M_Value[2] := (not v1.M_Value[2]);
  Result.M_Value[3] := (not v1.M_Value[3]);
  Result.M_Value[4] := (not v1.M_Value[4]);
  Result.M_Value[5] := (not v1.M_Value[5]);
  Result.M_Value[6] := (not v1.M_Value[6]);
  Result.M_Value[7] := (not v1.M_Value[7]);

  Result.Defined_flag  := True;
  Result.Overflow_flag := False;

  Result.Negative_flag := uBoolTrue;
  if v1.Negative then
  begin
    Result.Negative_flag := uBoolFalse;
  end;
end;


(******************************************)
function add_Multi_Int_X4(const v1, v2: TMultiIntX4): TMultiIntX4;
var
  tv1, tv2: INT_2W_U;
  M_Val: array[0..Multi_X4_maxi] of INT_2W_U;
begin
  Result.Overflow_flag := False;
  Result.Defined_flag  := True;
  Result.Negative_flag := uBoolUndefined;

  tv1      := v1.M_Value[0];
  tv2      := v2.M_Value[0];
  M_Val[0] := (tv1 + tv2);
  if M_Val[0] > INT_1W_U_MAXINT then
  begin
    M_Val[1] := (M_Val[0] div INT_1W_U_MAXINT_1);
    M_Val[0] := (M_Val[0] mod INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[1] := 0;
  end;

  tv1      := v1.M_Value[1];
  tv2      := v2.M_Value[1];
  M_Val[1] := (M_Val[1] + tv1 + tv2);
  if M_Val[1] > INT_1W_U_MAXINT then
  begin
    M_Val[2] := (M_Val[1] div INT_1W_U_MAXINT_1);
    M_Val[1] := (M_Val[1] mod INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[2] := 0;
  end;

  tv1      := v1.M_Value[2];
  tv2      := v2.M_Value[2];
  M_Val[2] := (M_Val[2] + tv1 + tv2);
  if M_Val[2] > INT_1W_U_MAXINT then
  begin
    M_Val[3] := (M_Val[2] div INT_1W_U_MAXINT_1);
    M_Val[2] := (M_Val[2] mod INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[3] := 0;
  end;

  tv1      := v1.M_Value[3];
  tv2      := v2.M_Value[3];
  M_Val[3] := (M_Val[3] + tv1 + tv2);
  if M_Val[3] > INT_1W_U_MAXINT then
  begin
    M_Val[4] := (M_Val[3] div INT_1W_U_MAXINT_1);
    M_Val[3] := (M_Val[3] mod INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[4] := 0;
  end;

  tv1      := v1.M_Value[4];
  tv2      := v2.M_Value[4];
  M_Val[4] := (M_Val[4] + tv1 + tv2);
  if M_Val[4] > INT_1W_U_MAXINT then
  begin
    M_Val[5] := (M_Val[4] div INT_1W_U_MAXINT_1);
    M_Val[4] := (M_Val[4] mod INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[5] := 0;
  end;

  tv1      := v1.M_Value[5];
  tv2      := v2.M_Value[5];
  M_Val[5] := (M_Val[5] + tv1 + tv2);
  if M_Val[5] > INT_1W_U_MAXINT then
  begin
    M_Val[6] := (M_Val[5] div INT_1W_U_MAXINT_1);
    M_Val[5] := (M_Val[5] mod INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[6] := 0;
  end;

  tv1      := v1.M_Value[6];
  tv2      := v2.M_Value[6];
  M_Val[6] := (M_Val[6] + tv1 + tv2);
  if M_Val[6] > INT_1W_U_MAXINT then
  begin
    M_Val[7] := (M_Val[6] div INT_1W_U_MAXINT_1);
    M_Val[6] := (M_Val[6] mod INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[7] := 0;
  end;

  tv1      := v1.M_Value[7];
  tv2      := v2.M_Value[7];
  M_Val[7] := (M_Val[7] + tv1 + tv2);
  if M_Val[7] > INT_1W_U_MAXINT then
  begin
    M_Val[7] := (M_Val[7] mod INT_1W_U_MAXINT_1);
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

  if (M_Val[0] = 0) and (M_Val[1] = 0) and (M_Val[2] = 0) and
    (M_Val[3] = 0) and (M_Val[4] = 0) and (M_Val[5] = 0) and
    (M_Val[6] = 0) and (M_Val[7] = 0) then
  begin
    Result.Negative_flag := uBoolFalse;
  end;

end;


(******************************************)
function subtract_Multi_Int_X4(const v1, v2: TMultiIntX4): TMultiIntX4;
var
  M_Val: array[0..Multi_X4_maxi] of INT_2W_S;
begin
  Result.Overflow_flag := False;
  Result.Defined_flag  := True;
  Result.Negative_flag := uBoolUndefined;

  M_Val[0] := (v1.M_Value[0] - v2.M_Value[0]);
  if M_Val[0] < 0 then
  begin
    M_Val[1] := -1;
    M_Val[0] := (M_Val[0] + INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[1] := 0;
  end;

  M_Val[1] := (v1.M_Value[1] - v2.M_Value[1] + M_Val[1]);
  if M_Val[1] < 0 then
  begin
    M_Val[2] := -1;
    M_Val[1] := (M_Val[1] + INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[2] := 0;
  end;

  M_Val[2] := (v1.M_Value[2] - v2.M_Value[2] + M_Val[2]);
  if M_Val[2] < 0 then
  begin
    M_Val[3] := -1;
    M_Val[2] := (M_Val[2] + INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[3] := 0;
  end;

  M_Val[3] := (v1.M_Value[3] - v2.M_Value[3] + M_Val[3]);
  if M_Val[3] < 0 then
  begin
    M_Val[4] := -1;
    M_Val[3] := (M_Val[3] + INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[4] := 0;
  end;

  M_Val[4] := (v1.M_Value[4] - v2.M_Value[4] + M_Val[4]);
  if M_Val[4] < 0 then
  begin
    M_Val[5] := -1;
    M_Val[4] := (M_Val[4] + INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[5] := 0;
  end;

  M_Val[5] := (v1.M_Value[5] - v2.M_Value[5] + M_Val[5]);
  if M_Val[5] < 0 then
  begin
    M_Val[6] := -1;
    M_Val[5] := (M_Val[5] + INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[6] := 0;
  end;

  M_Val[6] := (v1.M_Value[6] - v2.M_Value[6] + M_Val[6]);
  if M_Val[6] < 0 then
  begin
    M_Val[7] := -1;
    M_Val[6] := (M_Val[6] + INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[7] := 0;
  end;

  M_Val[7] := (v1.M_Value[7] - v2.M_Value[7] + M_Val[7]);
  if M_Val[7] < 0 then
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

  if (M_Val[0] = 0) and (M_Val[1] = 0) and (M_Val[2] = 0) and
    (M_Val[3] = 0) and (M_Val[4] = 0) and (M_Val[5] = 0) and
    (M_Val[6] = 0) and (M_Val[7] = 0) then
  begin
    Result.Negative_flag := uBoolFalse;
  end;

end;


(******************************************)
class operator TMultiIntX4.Inc(const v1: TMultiIntX4): TMultiIntX4;
var
  Neg: TMultiUBoolState;
  v2: TMultiIntX4;
begin
  if (not v1.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := v1.Defined_flag;
    Result.Overflow_flag := v1.Overflow_flag;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (v1.Overflow_flag) then
  begin
    Result := 0;
    Result.Defined_flag := v1.Defined_flag;
    Result.Overflow_flag := v1.Overflow_flag;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  Neg := uBoolUndefined;
  v2  := 1;

  if (v1.Negative_flag = False) then
  begin
    Result := add_Multi_Int_X4(v1, v2);
    Neg    := v1.Negative_flag;
  end
  else
  begin
    if ABS_greaterthan_Multi_Int_X4(v1, v2) then
    begin
      Result := subtract_Multi_Int_X4(v1, v2);
      Neg    := uBoolTrue;
    end
    else
    begin
      Result := subtract_Multi_Int_X4(v2, v1);
      Neg    := uBoolFalse;
    end;
  end;

  if (Result.Overflow_flag = True) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
  end;

  if (Result.Negative_flag = uBoolUndefined) then
  begin
    Result.Negative_flag := Neg;
  end;
end;


(******************************************)
class operator TMultiIntX4.+(const v1, v2: TMultiIntX4): TMultiIntX4;
var
  Neg: TMultiUBool;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (v1.Overflow_flag or v2.Overflow_flag) then
  begin
    Result := 0;
    Result.Overflow_flag := True;
    Result.Defined_flag := True;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  Neg := uBoolUndefined;

  if (v1.Negative_flag = v2.Negative_flag) then
  begin
    Result := add_Multi_Int_X4(v1, v2);
    Neg    := v1.Negative_flag;
  end
  else
  if ((v1.Negative_flag = False) and (v2.Negative_flag = True)) then
  begin
    if ABS_greaterthan_Multi_Int_X4(v2, v1) then
    begin
      Result := subtract_Multi_Int_X4(v2, v1);
      Neg    := uBoolTrue;
    end
    else
    begin
      Result := subtract_Multi_Int_X4(v1, v2);
      Neg    := uBoolFalse;
    end;
  end
  else
  begin
    if ABS_greaterthan_Multi_Int_X4(v1, v2) then
    begin
      Result := subtract_Multi_Int_X4(v1, v2);
      Neg    := uBoolTrue;
    end
    else
    begin
      Result := subtract_Multi_Int_X4(v2, v1);
      Neg    := uBoolFalse;
    end;
  end;

  if (Result.Overflow_flag = True) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
  end;

  if (Result.Negative_flag = uBoolUndefined) then
  begin
    Result.Negative_flag := Neg;
  end;
end;


(******************************************)
class operator TMultiIntX4.-(const v1, v2: TMultiIntX4): TMultiIntX4;
var
  Neg: TMultiUBoolState;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (v1.Overflow_flag or v2.Overflow_flag) then
  begin
    Result := 0;
    Result.Overflow_flag := True;
    Result.Defined_flag := True;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  Neg := uBoolUndefined;

  if (v1.Negative_flag = v2.Negative_flag) then
  begin
    if (v1.Negative_flag = True) then
    begin
      if ABS_greaterthan_Multi_Int_X4(v1, v2) then
      begin
        Result := subtract_Multi_Int_X4(v1, v2);
        Neg    := uBoolTrue;
      end
      else
      begin
        Result := subtract_Multi_Int_X4(v2, v1);
        Neg    := uBoolFalse;
      end;
    end
    else  (* if  not Negative_flag then  *)
    begin
      if ABS_greaterthan_Multi_Int_X4(v2, v1) then
      begin
        Result := subtract_Multi_Int_X4(v2, v1);
        Neg    := uBoolTrue;
      end
      else
      begin
        Result := subtract_Multi_Int_X4(v1, v2);
        Neg    := uBoolFalse;
      end;
    end;
  end
  else (* v1.Negative_flag <> v2.Negative_flag *)
  begin
    if (v2.Negative_flag = True) then
    begin
      Result := add_Multi_Int_X4(v1, v2);
      Neg    := uBoolFalse;
    end
    else
    begin
      Result := add_Multi_Int_X4(v1, v2);
      Neg    := uBoolTrue;
    end;
  end;

  if (Result.Overflow_flag = True) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
  end;

  if (Result.Negative_flag = uBoolUndefined) then
  begin
    Result.Negative_flag := Neg;
  end;
end;


(******************************************)
class operator TMultiIntX4.Dec(const v1: TMultiIntX4): TMultiIntX4;
var
  Neg: TMultiUBoolState;
  v2: TMultiIntX4;
begin
  if (not v1.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := v1.Defined_flag;
    Result.Overflow_flag := v1.Overflow_flag;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (v1.Overflow_flag) then
  begin
    Result := 0;
    Result.Defined_flag := v1.Defined_flag;
    Result.Overflow_flag := v1.Overflow_flag;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  Neg := uBoolUndefined;
  v2  := 1;

  if (v1.Negative_flag = False) then
  begin
    if ABS_greaterthan_Multi_Int_X4(v2, v1) then
    begin
      Result := subtract_Multi_Int_X4(v2, v1);
      Neg    := uBoolTrue;
    end
    else
    begin
      Result := subtract_Multi_Int_X4(v1, v2);
      Neg    := uBoolFalse;
    end;
  end
  else (* v1 is Negative_flag *)
  begin
    Result := add_Multi_Int_X4(v1, v2);
    Neg    := uBoolTrue;
  end;

  if (Result.Overflow_flag = True) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
  end;

  if (Result.Negative_flag = uBoolUndefined) then
  begin
    Result.Negative_flag := Neg;
  end;
end;


(******************************************)
class operator TMultiIntX4.-(const v1: TMultiIntX4): TMultiIntX4;
begin
  Result := v1;
  if (v1.Negative_flag = uBoolTrue) then
  begin
    Result.Negative_flag := uBoolFalse;
  end;
  if (v1.Negative_flag = uBoolFalse) then
  begin
    Result.Negative_flag := uBoolTrue;
  end;
end;


(*******************v4*********************)
procedure multiply_Multi_Int_X4(const v1, v2: TMultiIntX4;
  out Result: TMultiIntX4); overload;
label
  999;
var
  M_Val: array[0..Multi_X4_maxi_x2] of INT_2W_U;
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
  until (i > Multi_X4_maxi_x2);

  zf := False;
  i  := Multi_X4_maxi;
  jz := -1;
  repeat
    if (v2.M_Value[i] <> 0) then
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
  i  := Multi_X4_maxi;
  iz := -1;
  repeat
    if (v1.M_Value[i] <> 0) then
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
    if (v2.M_Value[j] <> 0) then
    begin
      zero_mult := True;
      repeat
        if (v1.M_Value[i] <> 0) then
        begin
          zero_mult := False;
          tv1 := v1.M_Value[i];
          tv2 := v2.M_Value[j];
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

  Result.Negative_flag := uBoolFalse;
  i := 0;
  repeat
    if (M_Val[i] <> 0) then
    begin
      Result.Negative_flag := uBoolUndefined;
      if (i > Multi_X4_maxi) then
      begin
        Result.Overflow_flag := True;
      end;
    end;
    Inc(i);
  until (i > Multi_X4_maxi_x2) or (Result.Overflow_flag);

  n := 0;
  while (n <= Multi_X4_maxi) do
  begin
    Result.M_Value[n] := M_Val[n];
    Inc(n);
  end;

  999: ;
end;


(******************************************)
class operator TMultiIntX4.*(const v1, v2: TMultiIntX4): TMultiIntX4;
var
  R: TMultiIntX4;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (v1.Overflow_flag or v2.Overflow_flag) then
  begin
    Result := 0;
    Result.Overflow_flag := True;
    Result.Defined_flag := True;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  multiply_Multi_Int_X4(v1, v2, R);

  if (R.Negative_flag = uBoolUndefined) then
  begin
    if (v1.Negative_flag = v2.Negative_flag) then
    begin
      R.Negative_flag := uBoolFalse;
    end
    else
    begin
      R.Negative_flag := uBoolTrue;
    end;
  end;

  Result := R;

  if (Result.Overflow_flag = True) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
  end;

end;


(******************************************)
function Multi_Int_X3_to_X4_multiply(const v1, v2: TMultiIntX3): TMultiIntX4;
var
  R: TMultiIntX4;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (v1.Overflow_flag or v2.Overflow_flag) then
  begin
    Result := 0;
    Result.Overflow_flag := True;
    Result.Defined_flag := True;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  multiply_Multi_Int_X4(v1, v2, R);

  if (R.Negative_flag = uBoolUndefined) then
  begin
    if (v1.Negative_flag = v2.Negative_flag) then
    begin
      R.Negative_flag := uBoolFalse;
    end
    else
    begin
      R.Negative_flag := uBoolTrue;
    end;
  end;

  Result := R;

  if (Result.Overflow_flag = True) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
  end;
end;


(********************v3********************)
{ Function exp_by_squaring_iterative(TV, P) }

class operator TMultiIntX4.**(const v1: TMultiIntX4; const P: INT_2W_S): TMultiIntX4;
var
  Y, TV, T, R: TMultiIntX4;
  PT: INT_2W_S;
begin
  PT := P;
  TV := v1;
  if (PT < 0) then
  begin
    R := 0;
  end
  else if (PT = 0) then
  begin
    R := 1;
  end
  else
  begin
    Y := 1;
    while (PT > 1) do
    begin
      if odd(PT) then
      begin
        multiply_Multi_Int_X4(TV, Y, T);
        if (T.Overflow_flag) then
        begin
          Result := 0;
          Result.Defined_flag := False;
          Result.Overflow_flag := True;
          Multi_Int_ERROR := True;
          if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
          begin
            raise EIntOverflow.Create('Overflow');
          end;
          exit;
        end;
        if (T.Negative_flag = uBoolUndefined) then
        begin
          if (TV.Negative_flag = Y.Negative_flag) then
          begin
            T.Negative_flag := uBoolFalse;
          end
          else
          begin
            T.Negative_flag := uBoolTrue;
          end;
        end;

        Y  := T;
        PT := PT - 1;
      end;
      multiply_Multi_Int_X4(TV, TV, T);
      if (T.Overflow_flag) then
      begin
        Result := 0;
        Result.Defined_flag := False;
        Result.Overflow_flag := True;
        Multi_Int_ERROR := True;
        if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
        begin
          raise EIntOverflow.Create('Overflow');
        end;
        exit;
      end;
      T.Negative_flag := uBoolFalse;

      TV := T;
      PT := (PT div 2);
    end;
    {$WARNINGS OFF}
    {$HINTS OFF}
    multiply_Multi_Int_X4(TV, Y, R);

    if (R.Overflow_flag) then
    begin
      Result := 0;
      Result.Defined_flag := False;
      Result.Overflow_flag := True;
      Multi_Int_ERROR := True;
      if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
      begin
        raise EIntOverflow.Create('Overflow');
      end;
      exit;
    end;
    if (R.Negative_flag = uBoolUndefined) then
    begin
      if (TV.Negative_flag = Y.Negative_flag) then
      begin
        R.Negative_flag := uBoolFalse;
      end
      else
      begin
        R.Negative_flag := uBoolTrue;
      end;
    end;
  end;

  Result := R;
end;


(********************v1********************)
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
    P_quotient.Defined_flag := False;
    P_quotient.Overflow_flag := True;
    P_remainder.Defined_flag := False;
    P_remainder.Overflow_flag := True;
    Multi_Int_ERROR := True;
  end
  else if (P_dividor = P_dividend) then
  begin
    P_quotient := 1;
  end
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
      t_word := P_dividor.M_Value[i];
      dividor.M_Value[i] := t_word;
      if (dividor_non_zero_pos = 0) then
      begin
        if (t_word <> 0) then
        begin
          dividor_non_zero_pos := i;
        end;
      end;
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
        P_quotient.M_Value[i] :=
          (((word_carry * INT_2W_U(INT_1W_U_MAXINT_1)) +
          INT_2W_U(dividend.M_Value[i])) div INT_2W_U(dividor.M_Value[0]));
        word_carry := (((word_carry * INT_2W_U(INT_1W_U_MAXINT_1)) +
          INT_2W_U(dividend.M_Value[i])) -
          (INT_2W_U(P_quotient.M_Value[i]) * INT_2W_U(dividor.M_Value[0])));
        Dec(i);
      end;
      P_remainder.M_Value[0] := word_carry;
      goto 9000;
    end;

    shiftup_bits_dividor := nlz_bits(dividor.M_Value[dividor_non_zero_pos]);
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
    begin
      if (dividend_i >= 0) then
      begin
        if (dividend.M_Value[dividend_i] = 0) then
        begin
          Dec(dividend_i);
        end
        else
        begin
          finished := True;
        end;
      end
      else
      begin
        finished := True;
      end;
    end;
    quotient_i := (dividend_i - dividor_non_zero_pos);

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
            begin
              goto AGAIN;
            end;
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
        P_quotient.M_Value[quotient_i] := word_division;
        dividend   := next_dividend;
        word_carry := dividend.M_Value[dividend_i];
      end
      else
      begin
        word_carry := word_dividend;
      end;

      Dec(dividend_i);
      quotient_i := (dividend_i - dividor_non_zero_pos);
    end; { while }

    ShiftDown_MultiBits_Multi_Int_X5(dividend, shiftup_bits_dividor);
    P_remainder := To_Multi_Int_X4(dividend);

    9000:
      if (P_dividend.Negative_flag = True) and (P_remainder > 0) then
      begin
        P_remainder.Negative_flag := True;
      end;

    if (P_dividend.Negative_flag <> P_dividor.Negative_flag) and (P_quotient > 0) then
    begin
      P_quotient.Negative_flag := True;
    end;

  end;
  9999: ;
end;


(******************************************)
class operator TMultiIntX4.div(const v1, v2: TMultiIntX4): TMultiIntX4;
var
  Remainder, Quotient: TMultiIntX4;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (v1.Overflow_flag or v2.Overflow_flag) then
  begin
    Result := 0;
    Result.Overflow_flag := True;
    Result.Defined_flag := True;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  // same values as last time

  if (X4_Last_Divisor = v2) and (X4_Last_Dividend = v1) then
  begin
    Result := X4_Last_Quotient;
  end
  else  // different values than last time
  begin
    intdivide_taylor_warruth_X4(v1, v2, Quotient, Remainder);

    X4_Last_Divisor   := v2;
    X4_Last_Dividend  := v1;
    X4_Last_Quotient  := Quotient;
    X4_Last_Remainder := Remainder;

    Result := Quotient;
  end;

  if (X4_Last_Remainder.Overflow_flag) or (X4_Last_Quotient.Overflow_flag) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
  end;
end;


(******************************************)
class operator TMultiIntX4.mod(const v1, v2: TMultiIntX4): TMultiIntX4;
var
  Remainder, Quotient: TMultiIntX4;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.Overflow_flag or v2.Overflow_flag) then
  begin
    Result := 0;
    Result.Overflow_flag := True;
    Result.Defined_flag := True;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  // same values as last time

  if (X4_Last_Divisor = v2) and (X4_Last_Dividend = v1) then
  begin
    Result := X4_Last_Remainder;
  end
  else  // different values than last time
  begin
    intdivide_taylor_warruth_X4(v1, v2, Quotient, Remainder);

    X4_Last_Divisor   := v2;
    X4_Last_Dividend  := v1;
    X4_Last_Quotient  := Quotient;
    X4_Last_Remainder := Remainder;

    Result := Remainder;
  end;

  if (X4_Last_Remainder.Overflow_flag) or (X4_Last_Quotient.Overflow_flag) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
  end;
end;


(***********v2************)
procedure SqRoot(const v1: TMultiIntX4; out VR, VREM: TMultiIntX4);
var
  D, D2: INT_2W_S;
  HS, LS: ansistring;
  H, L, C, CC, LPC, Q, R, T: TMultiIntX4;
  finished: boolean;
begin
  if (not v1.Defined_flag) then
  begin
    VR   := 0;
    VR.Defined_flag := False;
    VREM := 0;
    VREM.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.Overflow_flag) then
  begin
    VR   := 0;
    VR.Defined_flag := False;
    VREM := 0;
    VREM.Defined_flag := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  if (v1.Negative_flag = uBoolTrue) then
  begin
    VR   := 0;
    VR.Defined_flag := False;
    VREM := 0;
    VREM.Defined_flag := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  if (v1 >= 100) then
  begin
    D  := length(v1.ToStr);
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
    C := (v1 div 2);
    if (C = 0) then
    begin
      C := 1;
    end;
  end;

  finished := False;
  LPC      := v1;
  repeat
    begin
      // CC:= ((C + (v1 div C)) div 2);
      intdivide_taylor_warruth_X4(v1, C, Q, R);
      CC := (C + Q);
      ShiftDown_MultiBits_Multi_Int_X4(CC, 1);
      if (ABS(C - CC) < 2) then
      begin
        if (CC < LPC) then
        begin
          LPC := CC;
        end
        else if (CC >= LPC) then
        begin
          finished := True;
        end;
      end;
      C := CC;
    end
  until finished;

  VREM := (v1 - (LPC * LPC));
  VR   := LPC;
  VR.Negative_flag := uBoolFalse;
  VREM.Negative_flag := uBoolFalse;

end;


(*************************)
procedure SqRoot(const v1: TMultiIntX4; out VR: TMultiIntX4);
var
  VREM: TMultiIntX4;
begin
  VREM := 0;
  sqroot(v1, VR, VREM);
end;


(*************************)
function SqRoot(const v1: TMultiIntX4): TMultiIntX4;
var
  VR, VREM: TMultiIntX4;
begin
  VREM := 0;
  sqroot(v1, VR, VREM);
  Result := VR;
end;


{
******************************************
Multi_Int_X5  INTERNAL USE ONLY!
******************************************
}


(******************************************)
function ABS_greaterthan_Multi_Int_X5(const v1, v2: Multi_Int_X5): boolean;
begin
  if (v1.M_Value[8] > v2.M_Value[8]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[8] < v2.M_Value[8]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[7] > v2.M_Value[7]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[7] < v2.M_Value[7]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[6] > v2.M_Value[6]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[6] < v2.M_Value[6]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[5] > v2.M_Value[5]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[5] < v2.M_Value[5]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[4] > v2.M_Value[4]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[4] < v2.M_Value[4]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[3] > v2.M_Value[3]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[3] < v2.M_Value[3]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[2] > v2.M_Value[2]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[2] < v2.M_Value[2]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[1] > v2.M_Value[1]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[1] < v2.M_Value[1]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[0] > v2.M_Value[0]) then
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
function ABS_lessthan_Multi_Int_X5(const v1, v2: Multi_Int_X5): boolean;
begin
  if (v1.M_Value[8] < v2.M_Value[8]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[8] > v2.M_Value[8]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[7] < v2.M_Value[7]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[7] > v2.M_Value[7]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[6] < v2.M_Value[6]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[6] > v2.M_Value[6]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[5] < v2.M_Value[5]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[5] > v2.M_Value[5]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[4] < v2.M_Value[4]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[4] > v2.M_Value[4]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[3] < v2.M_Value[3]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[3] > v2.M_Value[3]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[2] < v2.M_Value[2]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[2] > v2.M_Value[2]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[1] < v2.M_Value[1]) then
  begin
    Result := True;
    exit;
  end
  else
  if (v1.M_Value[1] > v2.M_Value[1]) then
  begin
    Result := False;
    exit;
  end
  else
  if (v1.M_Value[0] < v2.M_Value[0]) then
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
  Result := self.Negative_flag;
end;


(******************************************)
class operator Multi_Int_X5.>(const v1, v2: Multi_Int_X5): boolean;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) or (v1.Overflow_flag) or
    (v2.Overflow_flag) then
  begin
    Result := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Result := False;
  if ((v1.Negative_flag = False) and (v2.Negative_flag = True)) then
  begin
    Result := True;
  end
  else
  if ((v1.Negative_flag = True) and (v2.Negative_flag = False)) then
  begin
    Result := False;
  end
  else
  if ((v1.Negative_flag = False) and (v2.Negative_flag = False)) then
  begin
    Result := ABS_greaterthan_Multi_Int_X5(v1, v2);
  end
  else
  if ((v1.Negative_flag = True) and (v2.Negative_flag = True)) then
  begin
    Result := ABS_lessthan_Multi_Int_X5(v1, v2);
  end;
end;


(******************************************)
class operator Multi_Int_X5.>=(const v1, v2: Multi_Int_X5): boolean;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) or (v1.Overflow_flag) or
    (v2.Overflow_flag) then
  begin
    Result := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Result := False;
  if ((v1.Negative_flag = False) and (v2.Negative_flag = True)) then
  begin
    Result := True;
  end
  else
  if ((v1.Negative_flag = True) and (v2.Negative_flag = False)) then
  begin
    Result := False;
  end
  else
  if ((v1.Negative_flag = False) and (v2.Negative_flag = False)) then
  begin
    Result := (not ABS_lessthan_Multi_Int_X5(v1, v2));
  end
  else
  if ((v1.Negative_flag = True) and (v2.Negative_flag = True)) then
  begin
    Result := (not ABS_greaterthan_Multi_Int_X5(v1, v2));
  end;
end;


{$ifdef CPU_32}
(******************************************)
procedure ShiftUp_NBits_Multi_Int_X5(var v1: Multi_Int_X5; NBits: INT_1W_U);
var
  carry_bits_1, carry_bits_2, carry_bits_mask, NBits_max, NBits_carry: INT_1W_U;

  procedure INT_1W_U_shl(var v1: INT_1W_U; const nbits: INT_1W_U); inline;
  var
    carry_bits_mask_2w: INT_2W_U;
  begin
    carry_bits_mask_2w := v1;
    carry_bits_mask_2w := (carry_bits_mask_2w << NBits);
    v1 := INT_1W_U(carry_bits_mask_2w and INT_1W_U_MAXINT);
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
      carry_bits_1 := ((v1.M_Value[0] and carry_bits_mask) >> NBits_carry);
      INT_1W_U_shl(v1.M_Value[0], NBits);

      carry_bits_2 := ((v1.M_Value[1] and carry_bits_mask) >> NBits_carry);
      INT_1W_U_shl(v1.M_Value[1], NBits);
      v1.M_Value[1] := (v1.M_Value[1] or carry_bits_1);

      carry_bits_1 := ((v1.M_Value[2] and carry_bits_mask) >> NBits_carry);
      INT_1W_U_shl(v1.M_Value[2], NBits);
      v1.M_Value[2] := (v1.M_Value[2] or carry_bits_2);

      carry_bits_2 := ((v1.M_Value[3] and carry_bits_mask) >> NBits_carry);
      INT_1W_U_shl(v1.M_Value[3], NBits);
      v1.M_Value[3] := (v1.M_Value[3] or carry_bits_1);

      carry_bits_1 := ((v1.M_Value[4] and carry_bits_mask) >> NBits_carry);
      INT_1W_U_shl(v1.M_Value[4], NBits);
      v1.M_Value[4] := (v1.M_Value[4] or carry_bits_2);

      carry_bits_2 := ((v1.M_Value[5] and carry_bits_mask) >> NBits_carry);
      INT_1W_U_shl(v1.M_Value[5], NBits);
      v1.M_Value[5] := (v1.M_Value[5] or carry_bits_1);

      carry_bits_1 := ((v1.M_Value[6] and carry_bits_mask) >> NBits_carry);
      INT_1W_U_shl(v1.M_Value[6], NBits);
      v1.M_Value[6] := (v1.M_Value[6] or carry_bits_2);

      carry_bits_2 := ((v1.M_Value[7] and carry_bits_mask) >> NBits_carry);
      INT_1W_U_shl(v1.M_Value[7], NBits);
      v1.M_Value[7] := (v1.M_Value[7] or carry_bits_1);

      INT_1W_U_shl(v1.M_Value[8], NBits);
      v1.M_Value[8] := (v1.M_Value[8] or carry_bits_2);
    end;
  end;

end;

{$endif}


{$ifdef CPU_64}
(******************************************)
procedure ShiftUp_NBits_Multi_Int_X5(Var v1:Multi_Int_X5; NBits:INT_1W_U);
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
        carry_bits_1:= ((v1.M_Value[0] and carry_bits_mask) >> NBits_carry);
        v1.M_Value[0]:= (v1.M_Value[0] << NBits);

        carry_bits_2:= ((v1.M_Value[1] and carry_bits_mask) >> NBits_carry);
        v1.M_Value[1]:= ((v1.M_Value[1] << NBits) OR carry_bits_1);

        carry_bits_1:= ((v1.M_Value[2] and carry_bits_mask) >> NBits_carry);
        v1.M_Value[2]:= ((v1.M_Value[2] << NBits) OR carry_bits_2);

        carry_bits_2:= ((v1.M_Value[3] and carry_bits_mask) >> NBits_carry);
        v1.M_Value[3]:= ((v1.M_Value[3] << NBits) OR carry_bits_1);

        carry_bits_1:= ((v1.M_Value[4] and carry_bits_mask) >> NBits_carry);
        v1.M_Value[4]:= ((v1.M_Value[4] << NBits) OR carry_bits_2);

        carry_bits_2:= ((v1.M_Value[5] and carry_bits_mask) >> NBits_carry);
        v1.M_Value[5]:= ((v1.M_Value[5] << NBits) OR carry_bits_1);

        carry_bits_1:= ((v1.M_Value[6] and carry_bits_mask) >> NBits_carry);
        v1.M_Value[6]:= ((v1.M_Value[6] << NBits) OR carry_bits_2);

        carry_bits_2:= ((v1.M_Value[7] and carry_bits_mask) >> NBits_carry);
        v1.M_Value[7]:= ((v1.M_Value[7] << NBits) OR carry_bits_1);

        v1.M_Value[8]:= ((v1.M_Value[8] << NBits) OR carry_bits_2);
        end;
end;

end;

{$endif}


(******************************************)
procedure ShiftDown_NBits_Multi_Int_X5(var v1: Multi_Int_X5; NBits: INT_1W_U);
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
    carry_bits_mask := (carry_bits_mask >> NBits_carry);

    if NBits <= NBits_max then
    begin

      carry_bits_2  := ((v1.M_Value[8] and carry_bits_mask) << NBits_carry);
      v1.M_Value[8] := (v1.M_Value[8] >> NBits);

      carry_bits_1  := ((v1.M_Value[7] and carry_bits_mask) << NBits_carry);
      v1.M_Value[7] := ((v1.M_Value[7] >> NBits) or carry_bits_2);

      carry_bits_2  := ((v1.M_Value[6] and carry_bits_mask) << NBits_carry);
      v1.M_Value[6] := ((v1.M_Value[6] >> NBits) or carry_bits_1);

      carry_bits_1  := ((v1.M_Value[5] and carry_bits_mask) << NBits_carry);
      v1.M_Value[5] := ((v1.M_Value[5] >> NBits) or carry_bits_2);

      carry_bits_2  := ((v1.M_Value[4] and carry_bits_mask) << NBits_carry);
      v1.M_Value[4] := ((v1.M_Value[4] >> NBits) or carry_bits_1);

      carry_bits_1  := ((v1.M_Value[3] and carry_bits_mask) << NBits_carry);
      v1.M_Value[3] := ((v1.M_Value[3] >> NBits) or carry_bits_2);

      carry_bits_2  := ((v1.M_Value[2] and carry_bits_mask) << NBits_carry);
      v1.M_Value[2] := ((v1.M_Value[2] >> NBits) or carry_bits_1);

      carry_bits_1  := ((v1.M_Value[1] and carry_bits_mask) << NBits_carry);
      v1.M_Value[1] := ((v1.M_Value[1] >> NBits) or carry_bits_2);

      v1.M_Value[0] := ((v1.M_Value[0] >> NBits) or carry_bits_1);

    end;
  end;

end;


(******************************************)
procedure ShiftDown_NWords_Multi_Int_X5(var v1: Multi_Int_X5; NWords: INT_1W_U);
var
  n: INT_1W_U;
begin
  if (NWords > 0) then
  begin
    if (NWords <= Multi_X5_maxi) then
    begin
      n := NWords;
      while (n > 0) do
      begin
        v1.M_Value[0] := v1.M_Value[1];
        v1.M_Value[1] := v1.M_Value[2];
        v1.M_Value[2] := v1.M_Value[3];
        v1.M_Value[3] := v1.M_Value[4];
        v1.M_Value[4] := v1.M_Value[5];
        v1.M_Value[5] := v1.M_Value[6];
        v1.M_Value[6] := v1.M_Value[7];
        v1.M_Value[7] := v1.M_Value[8];
        v1.M_Value[8] := 0;
        Dec(n);
      end;
    end
    else
    begin
      v1.M_Value[0] := 0;
      v1.M_Value[1] := 0;
      v1.M_Value[2] := 0;
      v1.M_Value[3] := 0;
      v1.M_Value[4] := 0;
      v1.M_Value[5] := 0;
      v1.M_Value[6] := 0;
      v1.M_Value[7] := 0;
      v1.M_Value[8] := 0;
    end;
  end;
end;


{******************************************}
procedure ShiftDown_MultiBits_Multi_Int_X5(var v1: Multi_Int_X5; NBits: INT_1W_U);
var
  NWords_count, NBits_count: INT_1W_U;
begin
  if (not v1.Defined_flag) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (NBits >= INT_1W_SIZE) then
  begin
    NWords_count := (NBits div INT_1W_SIZE);
    NBits_count  := (NBits mod INT_1W_SIZE);
    ShiftDown_NWords_Multi_Int_X5(v1, NWords_count);
  end
  else
  begin
    NBits_count := NBits;
  end;

  ShiftDown_NBits_Multi_Int_X5(v1, NBits_count);
end;


(******************************************)
procedure INT_2W_U_to_Multi_Int_X5(const v1: INT_2W_U; out mi: Multi_Int_X5); inline;
begin
  mi.Overflow_flag := False;
  mi.Defined_flag  := True;
  mi.Negative_flag := uBoolFalse;

  mi.M_Value[0] := (v1 mod INT_1W_U_MAXINT_1);
  mi.M_Value[1] := (v1 div INT_1W_U_MAXINT_1);
  mi.M_Value[2] := 0;
  mi.M_Value[3] := 0;
  mi.M_Value[4] := 0;
  mi.M_Value[5] := 0;
  mi.M_Value[6] := 0;
  mi.M_Value[7] := 0;
  mi.M_Value[8] := 0;
end;


(******************************************)
class operator Multi_Int_X5.:=(const v1: INT_2W_U): Multi_Int_X5;
begin
  INT_2W_U_to_Multi_Int_X5(v1, Result);
end;


(******************************************)
procedure Multi_Int_X4_to_Multi_Int_X5(const v1: TMultiIntX4;
  var MI: Multi_Int_X5); inline;
var
  n: INT_1W_U;
begin
  MI.Overflow_flag := v1.Overflow_flag;
  MI.Defined_flag  := v1.Defined_flag;
  MI.Negative_flag := v1.Negative_flag;

  if (v1.Defined_flag = False) then
  begin
    Multi_Int_ERROR := True;
    MI.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (v1.Overflow_flag = True) then
  begin
    Multi_Int_ERROR  := True;
    MI.Overflow_flag := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    exit;
  end;

  n := 0;
  while (n <= Multi_X4_maxi) do
  begin
    MI.M_Value[n] := v1.M_Value[n];
    Inc(n);
  end;

  while (n <= Multi_X5_max) do
  begin
    MI.M_Value[n] := 0;
    Inc(n);
  end;
end;


(******************************************)
class operator Multi_Int_X5.:=(const v1: TMultiIntX4): Multi_Int_X5;
begin
  Multi_Int_X4_to_Multi_Int_X5(v1, Result);
end;


(******************************************)
function To_Multi_Int_X5(const v1: TMultiIntX4): Multi_Int_X5;
begin
  Multi_Int_X4_to_Multi_Int_X5(v1, Result);
end;


(******************************************)
function To_Multi_Int_X4(const v1: Multi_Int_X5): TMultiIntX4; overload;
var
  n: INT_1W_U;
begin
  Result.Overflow_flag := v1.Overflow_flag;
  Result.Defined_flag  := v1.Defined_flag;
  Result.Negative_flag := v1.Negative_flag;

  if (v1.Defined_flag = False) then
  begin
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    Result.Defined_flag := False;
    exit;
  end;

  if (v1.Overflow_flag = True) or (v1 > Multi_Int_X4_MAXINT) then
  begin
    Result.Overflow_flag := True;
    Multi_Int_ERROR      := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    exit;
  end;

  n := 0;
  while (n <= Multi_X4_maxi) do
  begin
    Result.M_Value[n] := v1.M_Value[n];
    Inc(n);
  end;
end;


(*******************v4*********************)
procedure multiply_Multi_Int_X5(const v1, v2: Multi_Int_X5;
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
    if (v2.M_Value[i] <> 0) then
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
    if (v1.M_Value[i] <> 0) then
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
    if (v2.M_Value[j] <> 0) then
    begin
      zero_mult := True;
      repeat
        if (v1.M_Value[i] <> 0) then
        begin
          zero_mult := False;
          tv1 := v1.M_Value[i];
          tv2 := v2.M_Value[j];
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
      begin
        Result.Overflow_flag := True;
      end;
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
class operator Multi_Int_X5.*(const v1, v2: Multi_Int_X5): Multi_Int_X5;
var
  R: Multi_Int_X5;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (v1.Overflow_flag or v2.Overflow_flag) then
  begin
    Result := 0;
    Result.Overflow_flag := True;
    Result.Defined_flag := True;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  multiply_Multi_Int_X5(v1, v2, R);

  if (R.Negative_flag = uBoolUndefined) then
  begin
    if (v1.Negative_flag = v2.Negative_flag) then
    begin
      R.Negative_flag := uBoolFalse;
    end
    else
    begin
      R.Negative_flag := uBoolTrue;
    end;
  end;

  Result := R;

  if (Result.Overflow_flag = True) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
  end;

end;


(******************************************)
function Multi_Int_X4_to_X5_multiply(const v1, v2: TMultiIntX4): Multi_Int_X5;
var
  R: Multi_Int_X5;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (v1.Overflow_flag or v2.Overflow_flag) then
  begin
    Result := 0;
    Result.Overflow_flag := True;
    Result.Defined_flag := True;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  multiply_Multi_Int_X5(v1, v2, R);

  if (R.Negative_flag = uBoolUndefined) then
  begin
    if (v1.Negative_flag = v2.Negative_flag) then
    begin
      R.Negative_flag := uBoolFalse;
    end
    else
    begin
      R.Negative_flag := uBoolTrue;
    end;
  end;

  Result := R;

  if (Result.Overflow_flag = True) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
  end;
end;


(******************************************)
function add_Multi_Int_X5(const v1, v2: Multi_Int_X5): Multi_Int_X5;
var
  tv1, tv2: INT_2W_U;
  M_Val: array[0..Multi_X5_max] of INT_2W_U;
begin
  Result.Overflow_flag := False;
  Result.Defined_flag  := True;
  Result.Negative_flag := uBoolUndefined;

  tv1      := v1.M_Value[0];
  tv2      := v2.M_Value[0];
  M_Val[0] := (tv1 + tv2);
  if M_Val[0] > INT_1W_U_MAXINT then
  begin
    M_Val[1] := (M_Val[0] div INT_1W_U_MAXINT_1);
    M_Val[0] := (M_Val[0] mod INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[1] := 0;
  end;

  tv1      := v1.M_Value[1];
  tv2      := v2.M_Value[1];
  M_Val[1] := (M_Val[1] + tv1 + tv2);
  if M_Val[1] > INT_1W_U_MAXINT then
  begin
    M_Val[2] := (M_Val[1] div INT_1W_U_MAXINT_1);
    M_Val[1] := (M_Val[1] mod INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[2] := 0;
  end;

  tv1      := v1.M_Value[2];
  tv2      := v2.M_Value[2];
  M_Val[2] := (M_Val[2] + tv1 + tv2);
  if M_Val[2] > INT_1W_U_MAXINT then
  begin
    M_Val[3] := (M_Val[2] div INT_1W_U_MAXINT_1);
    M_Val[2] := (M_Val[2] mod INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[3] := 0;
  end;

  tv1      := v1.M_Value[3];
  tv2      := v2.M_Value[3];
  M_Val[3] := (M_Val[3] + tv1 + tv2);
  if M_Val[3] > INT_1W_U_MAXINT then
  begin
    M_Val[4] := (M_Val[3] div INT_1W_U_MAXINT_1);
    M_Val[3] := (M_Val[3] mod INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[4] := 0;
  end;

  tv1      := v1.M_Value[4];
  tv2      := v2.M_Value[4];
  M_Val[4] := (M_Val[4] + tv1 + tv2);
  if M_Val[4] > INT_1W_U_MAXINT then
  begin
    M_Val[5] := (M_Val[4] div INT_1W_U_MAXINT_1);
    M_Val[4] := (M_Val[4] mod INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[5] := 0;
  end;

  tv1      := v1.M_Value[5];
  tv2      := v2.M_Value[5];
  M_Val[5] := (M_Val[5] + tv1 + tv2);
  if M_Val[5] > INT_1W_U_MAXINT then
  begin
    M_Val[6] := (M_Val[5] div INT_1W_U_MAXINT_1);
    M_Val[5] := (M_Val[5] mod INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[6] := 0;
  end;

  tv1      := v1.M_Value[6];
  tv2      := v2.M_Value[6];
  M_Val[6] := (M_Val[6] + tv1 + tv2);
  if M_Val[6] > INT_1W_U_MAXINT then
  begin
    M_Val[7] := (M_Val[6] div INT_1W_U_MAXINT_1);
    M_Val[6] := (M_Val[6] mod INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[7] := 0;
  end;

  tv1      := v1.M_Value[7];
  tv2      := v2.M_Value[7];
  M_Val[7] := (M_Val[7] + tv1 + tv2);
  if M_Val[7] > INT_1W_U_MAXINT then
  begin
    M_Val[8] := (M_Val[7] div INT_1W_U_MAXINT_1);
    M_Val[7] := (M_Val[7] mod INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[8] := 0;
  end;

  tv1      := v1.M_Value[8];
  tv2      := v2.M_Value[8];
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
  begin
    Result.Negative_flag := uBoolFalse;
  end;

end;


(******************************************)
function subtract_Multi_Int_X5(const v1, v2: Multi_Int_X5): Multi_Int_X5;
var
  M_Val: array[0..Multi_X5_max] of INT_2W_S;
begin
  Result.Overflow_flag := False;
  Result.Defined_flag  := True;
  Result.Negative_flag := uBoolUndefined;

  M_Val[0] := (v1.M_Value[0] - v2.M_Value[0]);
  if M_Val[0] < 0 then
  begin
    M_Val[1] := -1;
    M_Val[0] := (M_Val[0] + INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[1] := 0;
  end;

  M_Val[1] := (v1.M_Value[1] - v2.M_Value[1] + M_Val[1]);
  if M_Val[1] < 0 then
  begin
    M_Val[2] := -1;
    M_Val[1] := (M_Val[1] + INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[2] := 0;
  end;

  M_Val[2] := (v1.M_Value[2] - v2.M_Value[2] + M_Val[2]);
  if M_Val[2] < 0 then
  begin
    M_Val[3] := -1;
    M_Val[2] := (M_Val[2] + INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[3] := 0;
  end;

  M_Val[3] := (v1.M_Value[3] - v2.M_Value[3] + M_Val[3]);
  if M_Val[3] < 0 then
  begin
    M_Val[4] := -1;
    M_Val[3] := (M_Val[3] + INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[4] := 0;
  end;

  M_Val[4] := (v1.M_Value[4] - v2.M_Value[4] + M_Val[4]);
  if M_Val[4] < 0 then
  begin
    M_Val[5] := -1;
    M_Val[4] := (M_Val[4] + INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[5] := 0;
  end;

  M_Val[5] := (v1.M_Value[5] - v2.M_Value[5] + M_Val[5]);
  if M_Val[5] < 0 then
  begin
    M_Val[6] := -1;
    M_Val[5] := (M_Val[5] + INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[6] := 0;
  end;

  M_Val[6] := (v1.M_Value[6] - v2.M_Value[6] + M_Val[6]);
  if M_Val[6] < 0 then
  begin
    M_Val[7] := -1;
    M_Val[6] := (M_Val[6] + INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[7] := 0;
  end;

  M_Val[7] := (v1.M_Value[7] - v2.M_Value[7] + M_Val[7]);
  if M_Val[7] < 0 then
  begin
    M_Val[8] := -1;
    M_Val[7] := (M_Val[7] + INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[8] := 0;
  end;

  M_Val[8] := (v1.M_Value[8] - v2.M_Value[8] + M_Val[8]);
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
  begin
    Result.Negative_flag := uBoolFalse;
  end;

end;


(******************************************)
class operator Multi_Int_X5.-(const v1, v2: Multi_Int_X5): Multi_Int_X5;
var
  Neg: TMultiUBoolState;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (v1.Overflow_flag or v2.Overflow_flag) then
  begin
    Result := 0;
    Result.Overflow_flag := True;
    Result.Defined_flag := True;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  Neg := uBoolUndefined;

  if (v1.Negative_flag = v2.Negative_flag) then
  begin
    if (v1.Negative_flag = True) then
    begin
      if ABS_greaterthan_Multi_Int_X5(v1, v2) then
      begin
        Result := subtract_Multi_Int_X5(v1, v2);
        Neg    := uBoolTrue;
      end
      else
      begin
        Result := subtract_Multi_Int_X5(v2, v1);
        Neg    := uBoolFalse;
      end;
    end
    else  (* if  not Negative_flag then  *)
    begin
      if ABS_greaterthan_Multi_Int_X5(v2, v1) then
      begin
        Result := subtract_Multi_Int_X5(v2, v1);
        Neg    := uBoolTrue;
      end
      else
      begin
        Result := subtract_Multi_Int_X5(v1, v2);
        Neg    := uBoolFalse;
      end;
    end;
  end
  else (* v1.Negative_flag <> v2.Negative_flag *)
  begin
    if (v2.Negative_flag = True) then
    begin
      Result := add_Multi_Int_X5(v1, v2);
      Neg    := uBoolFalse;
    end
    else
    begin
      Result := add_Multi_Int_X5(v1, v2);
      Neg    := uBoolTrue;
    end;
  end;

  if (Result.Overflow_flag = True) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
  end;

  if (Result.Negative_flag = uBoolUndefined) then
  begin
    Result.Negative_flag := Neg;
  end;
end;


{
******************************************
TMultiIntXV
******************************************
}

(******************************************)
procedure TMultiIntXV.init;
begin
  self.Defined_flag := False;
  if (not Multi_Init_Initialisation_done) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Multi_Init_Initialisation has not been called');
    end;
    exit;
  end;

  setlength(self.M_Value, Multi_XV_size);
  self.M_Value_Size  := Multi_XV_size;
  self.Negative_flag := uBoolFalse;
  self.Overflow_flag := False;
  self.Defined_flag  := False;
end;


(********************v3********************)
procedure Multi_Int_Reset_XV_Size(var v1: TMultiIntXV; const S: INT_2W_U);
begin
  if (S < 2) then
  begin
    Multi_Int_ERROR  := True;
    v1.Overflow_flag := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Multi_Int_XV Size must be > 1');
    end;
    exit;
  end;
  if (S > (Multi_XV_limit)) then
  begin
    Multi_Int_ERROR  := True;
    v1.Overflow_flag := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    exit;
  end;

  setlength(v1.M_Value, S);
  v1.M_Value_Size := S;
end;


(******************************************)
procedure Multi_Int_Set_XV_Limit(const S: INT_2W_U);
begin
  if (S >= Multi_XV_size) then
  begin
    Multi_XV_limit := S;
  end
  else
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Multi_XV_limit must be >= Multi_XV_size');
    end;
    exit;
  end;
end;


(******************************************)
procedure Multi_Int_XV_to_Multi_Int_XV(const v1: TMultiIntXV; var MI: TMultiIntXV);
var
  n: INT_1W_U;
begin
  MI.init;

  if (v1.Defined_flag = False) then
  begin
    Multi_Int_ERROR := True;
    MI.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (v1.Overflow_flag = True) then
  begin
    Multi_Int_ERROR  := True;
    MI.Overflow_flag := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    exit;
  end;

  if (v1.M_Value_Size > mi.M_Value_Size) then
  begin
    Multi_Int_Reset_XV_Size(MI, v1.M_Value_Size);
    if (mi.Overflow) then
    begin
      Multi_Int_ERROR := True;
      mi.Defined_flag := False;
      if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
      begin
        raise EInterror.Create('Overflow');
      end;
      exit;
    end;
  end;

  MI.Overflow_flag := v1.Overflow_flag;
  MI.Defined_flag  := v1.Defined_flag;
  MI.Negative_flag := v1.Negative_flag;

  n := 0;
  while (n < v1.M_Value_Size) do
  begin
    MI.M_Value[n] := v1.M_Value[n];
    Inc(n);
  end;

  while (n < MI.M_Value_Size) do
  begin
    MI.M_Value[n] := 0;
    Inc(n);
  end;
end;


(******************************************)
function ABS_greaterthan_Multi_Int_XV(const v1, v2: TMultiIntXV): boolean;
var
  i1, i2: INT_2W_S;
begin
  i1 := (v1.M_Value_Size - 1);
  i2 := (v2.M_Value_Size - 1);

  while (i1 > i2) do
  begin
    if (v1.M_Value[i1] > 0) then
    begin
      Result := True;
      exit;
    end;
    Dec(i1);
  end;

  while (i2 > i1) do
  begin
    if (v2.M_Value[i2] > 0) then
    begin
      Result := False;
      exit;
    end;
    Dec(i2);
  end;

  while (i2 > 0) do
  begin
    if (v1.M_Value[i2] > v2.M_Value[i2]) then
    begin
      Result := True;
      exit;
    end
    else
    if (v1.M_Value[i2] < v2.M_Value[i2]) then
    begin
      Result := False;
      exit;
    end;
    Dec(i2);
  end;

  if (v1.M_Value[0] > v2.M_Value[0]) then
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
function ABS_lessthan_Multi_Int_XV(const v1, v2: TMultiIntXV): boolean;
var
  i1, i2: INT_2W_S;
begin
  i1 := (v1.M_Value_Size - 1);
  i2 := (v2.M_Value_Size - 1);

  while (i1 > i2) do
  begin
    if (v1.M_Value[i1] > 0) then
    begin
      Result := False;
      exit;
    end;
    Dec(i1);
  end;

  while (i2 > i1) do
  begin
    if (v2.M_Value[i2] > 0) then
    begin
      Result := True;
      exit;
    end;
    Dec(i2);
  end;

  while (i2 > 0) do
  begin
    if (v1.M_Value[i2] > v2.M_Value[i2]) then
    begin
      Result := False;
      exit;
    end
    else
    if (v1.M_Value[i2] < v2.M_Value[i2]) then
    begin
      Result := True;
      exit;
    end;
    Dec(i2);
  end;

  if (v1.M_Value[0] < v2.M_Value[0]) then
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
function nlz_words_XV(const V: TMultiIntXV): INT_1W_U; // v2
var
  i, n: TMultiInt32;
  fini: boolean;
begin
  n    := 0;
  i    := (V.M_Value_Size - 1);
  fini := False;
  repeat
    if (i < 0) then
    begin
      fini := True;
    end
    else if (V.M_Value[i] <> 0) then
    begin
      fini := True;
    end
    else
    begin
      Inc(n);
      Dec(i);
    end;
  until fini;
  Result := n;
end;


(******************************************)
function nlz_MultiBits_XV(const v1: TMultiIntXV): INT_2W_U;
var
  w, R: INT_2W_U;
begin
  if (not v1.Defined_flag) then
  begin
    Result := 0;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
  end;

  w := nlz_words_XV(v1);
  if (w < v1.M_Value_Size) then
  begin
    R      := nlz_bits(v1.M_Value[v1.M_Value_Size - w - 1]);
    R      := R + (w * INT_1W_SIZE);
    Result := R;
  end
  else
  begin
    Result := (w * INT_1W_SIZE);
  end;
end;


(******************************************)
function TMultiIntXV.Overflow: boolean; inline;
begin
  Result := self.Overflow_flag;
end;


(******************************************)
function TMultiIntXV.Defined: boolean; inline;
begin
  Result := self.Defined_flag;
end;


(******************************************)
function Overflow(const v1: TMultiIntXV): boolean; overload; inline;
begin
  Result := v1.Overflow_flag;
end;


(******************************************)
function Defined(const v1: TMultiIntXV): boolean; overload; inline;
begin
  Result := v1.Defined_flag;
end;


(******************************************)
function TMultiIntXV.Negative: boolean; inline;
begin
  Result := self.Negative_flag;
end;


(******************************************)
function Negative(const v1: TMultiIntXV): boolean; overload;
begin
  Result := v1.Negative_flag;
end;


(******************************************)
function Abs(const v1: TMultiIntXV): TMultiIntXV; overload;
begin
  Result := v1;
  Result.Negative_flag := uBoolFalse;

  if (not v1.Defined_flag) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
  end;
end;


(******************************************)
function Multi_Int_XV_Odd(const v1: TMultiIntXV): boolean; inline;
var
  bit1_mask: INT_1W_U;
begin

  bit1_mask := $1;

  if ((v1.M_Value[0] and bit1_mask) = bit1_mask) then
  begin
    Result := True;
  end
  else
  begin
    Result := False;
  end;

  if (not v1.Defined_flag) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
  end;

end;


(******************************************)
function Odd(const v1: TMultiIntXV): boolean; overload;
begin
  Result := Multi_Int_XV_Odd(v1);
end;


(******************************************)
function Multi_Int_XV_Even(const v1: TMultiIntXV): boolean; inline;
var
  bit1_mask: INT_1W_U;
begin

  bit1_mask := $1;

  if ((v1.M_Value[0] and bit1_mask) = bit1_mask) then
  begin
    Result := False;
  end
  else
  begin
    Result := True;
  end;

  if (not v1.Defined_flag) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
  end;

end;


(******************************************)
function Even(const v1: TMultiIntXV): boolean; overload;
begin
  Result := Multi_Int_XV_Even(v1);
end;


(******************************************)
procedure ShiftUp_NBits_Multi_Int_XV(var v1: TMultiIntXV; NBits: INT_2W_U);
var
  carry_bits_1, carry_bits_2, carry_bits_mask, NBits_max, NBits_carry: INT_1W_U;
  n: INT_1W_U;
  {$ifdef CPU_32}
  procedure INT_1W_U_shl(var v1: INT_1W_U; const nbits: INT_2W_U); inline;
  var
    carry_bits_mask_2w: INT_2W_U;
  begin
    carry_bits_mask_2w := v1;
    carry_bits_mask_2w := (carry_bits_mask_2w << NBits);
    v1 := INT_1W_U(carry_bits_mask_2w and INT_1W_U_MAXINT);
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
      carry_bits_1  := ((v1.M_Value[0] and carry_bits_mask) >> NBits_carry);
      {$ifdef CPU_32}
      // v1.M_Value[0]:= (v1.M_Value[0] << NBits);
      INT_1W_U_shl(v1.M_Value[0], NBits);
      {$else}
      v1.M_Value[0] := (v1.M_Value[0] << NBits);
      {$endif}

      n := 1;
      while (n < (v1.M_Value_Size - 1)) do
      begin
        carry_bits_2 := ((v1.M_Value[n] and carry_bits_mask) >> NBits_carry);

        {$ifdef CPU_32}
        // v1.M_Value[n]:= ((v1.M_Value[n] << NBits) OR carry_bits_1);
        INT_1W_U_shl(v1.M_Value[n], NBits);
        v1.M_Value[n] := (v1.M_Value[n] or carry_bits_1);
        {$else}
        v1.M_Value[n] := ((v1.M_Value[n] << NBits) or carry_bits_1);
        {$endif}

        carry_bits_1 := carry_bits_2;
        Inc(n);
      end;

      v1.M_Value[n] := ((v1.M_Value[n] << NBits) or carry_bits_1);

    end;
  end;
end;


(******************************************)
procedure ShiftUp_NWords_Multi_Int_XV(var v1: TMultiIntXV; NWords: INT_2W_U);
var
  n, i: INT_1W_U;
begin
  if (NWords > 0) then
  begin
    if (NWords < Multi_XV_size) then
    begin
      n := NWords;
      while (n > 0) do
      begin
        i := Multi_XV_maxi;
        while (i > 0) do
        begin
          v1.M_Value[i] := v1.M_Value[i - 1];
          Dec(i);
        end;
        v1.M_Value[i] := 0;
        Dec(n);
      end;
    end
    else
    begin
      n := Multi_XV_maxi;
      while (n > 0) do
      begin
        v1.M_Value[n] := 0;
        Dec(n);
      end;
    end;
  end;
end;


{******************************************}
procedure ShiftUp_MultiBits_Multi_Int_XV(var v1: TMultiIntXV; NBits: INT_2W_U);
var
  NWords_count, NBits_count: INT_1W_U;
begin
  if (not v1.Defined_flag) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (NBits > 0) then
  begin
    if (NBits >= INT_1W_SIZE) then
    begin
      NWords_count := (NBits div INT_1W_SIZE);
      NBits_count  := (NBits mod INT_1W_SIZE);
      ShiftUp_NWords_Multi_Int_XV(v1, NWords_count);
    end
    else
    begin
      NBits_count := NBits;
    end;
    ShiftUp_NBits_Multi_Int_XV(v1, NBits_count);
  end;
end;


{******************************************}
class operator TMultiIntXV.shl(const v1: TMultiIntXV;
  const NBits: INT_2W_U): TMultiIntXV;
begin
  // Result:= v1;                // this causes problems in calling code
  Multi_Int_XV_to_Multi_Int_XV(v1, Result);
  // if not done, causes problems in calling code
  ShiftUp_MultiBits_Multi_Int_XV(Result, NBits);
end;


(******************************************)
procedure ShiftDown_NBits_Multi_Int_XV(var v1: TMultiIntXV; NBits: INT_2W_U);
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
    carry_bits_mask := (carry_bits_mask >> NBits_carry);

    if NBits <= NBits_max then
    begin
      n := (v1.M_Value_Size - 1);
      carry_bits_1 := ((v1.M_Value[n] and carry_bits_mask) << NBits_carry);
      v1.M_Value[n] := (v1.M_Value[n] >> NBits);

      Dec(n);
      while (n > 0) do
      begin
        carry_bits_2  := ((v1.M_Value[n] and carry_bits_mask) << NBits_carry);
        v1.M_Value[n] := ((v1.M_Value[n] >> NBits) or carry_bits_1);
        carry_bits_1  := carry_bits_2;
        Dec(n);
      end;

      v1.M_Value[n] := ((v1.M_Value[n] >> NBits) or carry_bits_1);
    end;
  end;
end;


(******************************************)
procedure ShiftDown_NWords_Multi_Int_XV(var v1: TMultiIntXV; NWords: INT_2W_U);
var
  n, i: INT_1W_U;
begin

  if (NWords > 0) then
  begin
    if (NWords < Multi_XV_size) then
    begin
      n := NWords;
      while (n > 0) do
      begin
        i := 0;
        while (i < Multi_XV_maxi) do
        begin
          v1.M_Value[i] := v1.M_Value[i + 1];
          Inc(i);
        end;
        v1.M_Value[i] := 0;
        Dec(n);
      end;
    end
    else
    begin
      n := Multi_XV_maxi;
      while (n > 0) do
      begin
        v1.M_Value[n] := 0;
        Dec(n);
      end;
    end;
  end;

end;


{******************************************}
procedure ShiftDown_MultiBits_Multi_Int_XV(var v1: TMultiIntXV; NBits: INT_2W_U);
var
  NWords_count, NBits_count: INT_1W_U;
begin
  if (not v1.Defined_flag) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (NBits >= INT_1W_SIZE) then
  begin
    NWords_count := (NBits div INT_1W_SIZE);
    NBits_count  := (NBits mod INT_1W_SIZE);
    ShiftDown_NWords_Multi_Int_XV(v1, NWords_count);
  end
  else
  begin
    NBits_count := NBits;
  end;

  ShiftDown_NBits_Multi_Int_XV(v1, NBits_count);
end;


{******************************************}
class operator TMultiIntXV.shr(const v1: TMultiIntXV;
  const NBits: INT_2W_U): TMultiIntXV;
begin
  // Result:= v1;                // this causes problems in calling code
  Multi_Int_XV_to_Multi_Int_XV(v1, Result);
  // if not done, causes problems in calling code
  ShiftDown_MultiBits_Multi_Int_XV(Result, NBits);
end;


(******************************************)
class operator TMultiIntXV.>(const v1, v2: TMultiIntXV): boolean;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) or (v1.Overflow_flag) or
    (v2.Overflow_flag) then
  begin
    Result := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Result := False;
  if ((v1.Negative_flag = False) and (v2.Negative_flag = True)) then
  begin
    Result := True;
  end
  else
  if ((v1.Negative_flag = True) and (v2.Negative_flag = False)) then
  begin
    Result := False;
  end
  else
  if ((v1.Negative_flag = False) and (v2.Negative_flag = False)) then
  begin
    Result := ABS_greaterthan_Multi_Int_XV(v1, v2);
  end
  else
  if ((v1.Negative_flag = True) and (v2.Negative_flag = True)) then
  begin
    Result := ABS_lessthan_Multi_Int_XV(v1, v2);
  end;
end;


(******************************************)
class operator TMultiIntXV.<(const v1, v2: TMultiIntXV): boolean;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) or (v1.Overflow_flag) or
    (v2.Overflow_flag) then
  begin
    Result := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Result := False;
  if ((v1.Negative_flag = True) and (v2.Negative_flag = False)) then
  begin
    Result := True;
  end
  else
  if ((v1.Negative_flag = False) and (v2.Negative_flag = False)) then
  begin
    Result := ABS_lessthan_Multi_Int_XV(v1, v2);
  end
  else
  if ((v1.Negative_flag = True) and (v2.Negative_flag = True)) then
  begin
    Result := ABS_greaterthan_Multi_Int_XV(v1, v2);
  end;
end;


(******************************************)
function ABS_equal_Multi_Int_XV(const v1, v2: TMultiIntXV): boolean;
var
  i1, i2: INT_2W_S;
begin
  Result := True;
  i1     := (v1.M_Value_Size - 1);
  i2     := (v2.M_Value_Size - 1);
  while (i1 > i2) do
  begin
    if (v1.M_Value[i1] > 0) then
    begin
      Result := False;
      exit;
    end;
    Dec(i1);
  end;
  while (i2 > i1) do
  begin
    if (v2.M_Value[i2] > 0) then
    begin
      Result := False;
      exit;
    end;
    Dec(i2);
  end;
  while (i2 >= 0) do
  begin
    if (v1.M_Value[i2] <> v2.M_Value[i2]) then
    begin
      Result := False;
      exit;
    end;
    Dec(i2);
  end;
end;


(******************************************)
function ABS_notequal_Multi_Int_XV(const v1, v2: TMultiIntXV): boolean; inline;
begin
  Result := (not ABS_equal_Multi_Int_XV(v1, v2));
end;


(******************************************)
class operator TMultiIntXV.=(const v1, v2: TMultiIntXV): boolean;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) or (v1.Overflow_flag) or
    (v2.Overflow_flag) then
  begin
    Result := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Result := True;
  if (v1.Negative_flag <> v2.Negative_flag) then
  begin
    Result := False;
  end
  else
  begin
    Result := ABS_equal_Multi_Int_XV(v1, v2);
  end;
end;


(******************************************)
class operator TMultiIntXV.<>(const v1, v2: TMultiIntXV): boolean;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) or (v1.Overflow_flag) or
    (v2.Overflow_flag) then
  begin
    Result := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Result := False;
  if (v1.Negative_flag <> v2.Negative_flag) then
  begin
    Result := True;
  end
  else
  begin
    Result := (not ABS_equal_Multi_Int_XV(v1, v2));
  end;
end;


(******************************************)
class operator TMultiIntXV.<=(const v1, v2: TMultiIntXV): boolean;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) or (v1.Overflow_flag) or
    (v2.Overflow_flag) then
  begin
    Result := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Result := False;
  if ((v1.Negative_flag = False) and (v2.Negative_flag = True)) then
  begin
    Result := False;
  end
  else
  if ((v1.Negative_flag = True) and (v2.Negative_flag = False)) then
  begin
    Result := True;
  end
  else
  if ((v1.Negative_flag = False) and (v2.Negative_flag = False)) then
  begin
    Result := (not ABS_greaterthan_Multi_Int_XV(v1, v2));
  end
  else
  if ((v1.Negative_flag = True) and (v2.Negative_flag = True)) then
  begin
    Result := (not ABS_lessthan_Multi_Int_XV(v1, v2));
  end;
end;


(******************************************)
class operator TMultiIntXV.>=(const v1, v2: TMultiIntXV): boolean;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) or (v1.Overflow_flag) or
    (v2.Overflow_flag) then
  begin
    Result := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Result := False;
  if ((v1.Negative_flag = False) and (v2.Negative_flag = True)) then
  begin
    Result := True;
  end
  else
  if ((v1.Negative_flag = True) and (v2.Negative_flag = False)) then
  begin
    Result := False;
  end
  else
  if ((v1.Negative_flag = False) and (v2.Negative_flag = False)) then
  begin
    Result := (not ABS_lessthan_Multi_Int_XV(v1, v2));
  end
  else
  if ((v1.Negative_flag = True) and (v2.Negative_flag = True)) then
  begin
    Result := (not ABS_greaterthan_Multi_Int_XV(v1, v2));
  end;
end;


(******************************************)
procedure String_to_Multi_Int_XV(const v1: ansistring; out mi: TMultiIntXV); inline;
label
  999;
var
  n, i, b, c, e, s: INT_2W_U;
  M_Val: array of INT_2W_U;
  Signeg, Zeroneg, M_Val_All_Zero: boolean;
begin
  Multi_Int_ERROR := False;

  s := Multi_XV_size;
  setlength(M_Val, s);

  mi.init;
  mi.Overflow_flag := False;
  mi.Defined_flag := True;
  mi.Negative_flag := False;
  Signeg  := False;
  Zeroneg := False;

  n := 0;
  while (n < s) do
  begin
    M_Val[n] := 0;
    Inc(n);
  end;

  if (length(v1) > 0) then
  begin
    b := low(ansistring);
    e := b + INT_2W_U(length(v1)) - 1;
    if (v1[b] = '-') then
    begin
      Signeg := True;
      Inc(b);
    end;

    c := b;
    while (c <= e) do
    begin
      try
        i := StrToInt(v1[c]);
      except
        on EConvertError do
        begin
          mi.Defined_flag  := False;
          mi.Overflow_flag := True;
          Multi_Int_ERROR  := True;
          if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
          begin
            raise;
          end;
        end;
      end;
      if mi.Defined_flag = False then
      begin
        goto 999;
      end;

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
    if (mi.Overflow) then
    begin
      mi.Defined_flag := False;
      Multi_Int_ERROR := True;
      if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
      begin
        raise EInterror.Create('Overflow');
      end;
      goto 999;
    end;
  end;

  M_Val_All_Zero := True;
  n := 0;
  while (n < s) do
  begin
    mi.M_Value[n] := M_Val[n];
    if M_Val[n] > 0 then
    begin
      M_Val_All_Zero := False;
    end;
    Inc(n);
  end;

  if M_Val_All_Zero then
  begin
    Zeroneg := True;
  end;

  if Zeroneg then
  begin
    mi.Negative_flag := uBoolFalse;
  end
  else if Signeg then
  begin
    mi.Negative_flag := uBoolTrue;
  end
  else
  begin
    mi.Negative_flag := uBoolFalse;
  end;

  999: ;
end;


(******************************************)
class operator TMultiIntXV.:=(const v1: ansistring): TMultiIntXV;
begin
  String_to_Multi_Int_XV(v1, Result);
end;


(******************************************)
procedure Multi_Int_XV_to_String(const v1: TMultiIntXV; var v2: ansistring); inline;
var
  s: ansistring = '';
  M_Val: array of INT_2W_U;
  n, t: INT_2W_U;
  M_Val_All_Zero: boolean;
begin
  if (not v1.Defined_flag) then
  begin
    v2 := 'UNDEFINED';
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.Overflow_flag) then
  begin
    v2 := 'OVERFLOW';
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    exit;
  end;

  setlength(M_Val, v1.M_Value_Size);

  n := 0;
  while (n < v1.M_Value_Size) do
  begin
    t := v1.M_Value[n];
    M_Val[n] := t;
    Inc(n);
  end;

  repeat
    n := (v1.M_Value_Size - 1);
    M_Val_All_Zero := True;
    repeat
      M_Val[n - 1] := M_Val[n - 1] + (INT_1W_U_MAXINT_1 * (M_Val[n] mod 10));
      M_Val[n]     := (M_Val[n] div 10);
      if M_Val[n] <> 0 then
      begin
        M_Val_All_Zero := False;
      end;
      Dec(n);
    until (n = 0);

    s := IntToStr(M_Val[0] mod 10) + s;
    M_Val[0] := (M_Val[0] div 10);
    if M_Val[0] <> 0 then
    begin
      M_Val_All_Zero := False;
    end;

  until M_Val_All_Zero;

  if (v1.Negative_flag = uBoolTrue) then
  begin
    s := '-' + s;
  end;
  v2 := s;
end;


(******************************************)
function TMultiIntXV.ToStr: ansistring;
begin
  Multi_Int_XV_to_String(self, Result);
end;


(******************************************)
class operator TMultiIntXV.:=(const v1: TMultiIntXV): ansistring;
begin
  Multi_Int_XV_to_String(v1, Result);
end;


(******************************************)
procedure hex_to_Multi_Int_XV(const v1: ansistring; out mi: TMultiIntXV); inline;
label
  999;
var
  n, i, b, c, e, s: INT_2W_U;
  M_Val: array of INT_2W_U;
  Signeg, Zeroneg, M_Val_All_Zero: boolean;
begin
  Multi_Int_ERROR := False;
  s := Multi_XV_size;
  setlength(M_Val, s);

  mi.init;
  mi.Overflow_flag := False;
  mi.Defined_flag := True;
  mi.Negative_flag := False;
  Signeg  := False;
  Zeroneg := False;

  n := 0;
  while (n < s) do
  begin
    M_Val[n] := 0;
    Inc(n);
  end;

  if (length(v1) > 0) then
  begin
    b := low(ansistring);
    e := b + INT_2W_U(length(v1)) - 1;
    if (v1[b] = '-') then
    begin
      Signeg := True;
      Inc(b);
    end;

    c := b;
    while (c <= e) do
    begin
      try
        i := Hex2Dec(v1[c]);
      except
        Multi_Int_ERROR  := True;
        mi.Overflow_flag := True;
        mi.Defined_flag  := False;
        if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
        begin
          raise;
        end;
      end;
      if mi.Defined_flag = False then
      begin
        goto 999;
      end;

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
    if (mi.Overflow) then
    begin
      mi.Defined_flag := False;
      Multi_Int_ERROR := True;
      if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
      begin
        raise EInterror.Create('Overflow');
      end;
      goto 999;
    end;
  end;

  M_Val_All_Zero := True;
  n := 0;
  while (n < s) do
  begin
    mi.M_Value[n] := M_Val[n];
    if M_Val[n] > 0 then
    begin
      M_Val_All_Zero := False;
    end;
    Inc(n);
  end;
  if M_Val_All_Zero then
  begin
    Zeroneg := True;
  end;

  if Zeroneg then
  begin
    mi.Negative_flag := uBoolFalse;
  end
  else if Signeg then
  begin
    mi.Negative_flag := uBoolTrue;
  end
  else
  begin
    mi.Negative_flag := uBoolFalse;
  end;

  999: ;
end;


(******************************************)
function TMultiIntXV.FromHex(const v1: ansistring): TMultiIntXV;
begin
  hex_to_Multi_Int_XV(v1, Result);
end;


(******************************************)
procedure FromHex(const v1: ansistring; out v2: TMultiIntXV); overload;
begin
  hex_to_Multi_Int_XV(v1, v2);
end;


(******************************************)
procedure Multi_Int_XV_to_hex(const v1: TMultiIntXV; var v2: ansistring;
  LZ: TMultiLeadingZeros); inline;
var
  s: ansistring = '';
  i, n: INT_1W_S;
begin
  if (not v1.Defined_flag) then
  begin
    v2 := 'UNDEFINED';
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.Overflow_flag) then
  begin
    v2 := 'OVERFLOW';
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    exit;
  end;

  // The "4" here looks suspicious, but it is not!
  // It is the size in bits of a nibble (half-byte).

  n := (INT_1W_SIZE div 4);
  s := '';

  i := (v1.M_Value_Size - 1);
  while (i >= 0) do
  begin
    s := s + IntToHex(v1.M_Value[i], n);
    Dec(i);
  end;

  if (LZ = TrimLeadingZeros) then
  begin
    Removeleadingchars(s, ['0']);
  end;
  if (v1.Negative_flag = uBoolTrue) then
  begin
    s := '-' + s;
  end;
  if (s = '') then
  begin
    s := '0';
  end;
  v2 := s;
end;


(******************************************)
function TMultiIntXV.ToHex(const LZ: TMultiLeadingZeros): ansistring;
begin
  Multi_Int_XV_to_hex(self, Result, LZ);
end;


(******************************************)
procedure Bin_to_Multi_Int_XV(const v1: ansistring; out mi: TMultiIntXV); inline;
label
  999;
var
  n, b, c, e, s: INT_2W_U;
  bit: INT_1W_S;
  M_Val: array of INT_2W_U;
  Signeg, Zeroneg, M_Val_All_Zero: boolean;
begin
  Multi_Int_ERROR := False;
  s := Multi_XV_size;
  setlength(M_Val, s);

  mi.init;
  mi.Overflow_flag := False;
  mi.Defined_flag := True;
  mi.Negative_flag := False;
  Signeg  := False;
  Zeroneg := False;

  n := 0;
  while (n < s) do
  begin
    M_Val[n] := 0;
    Inc(n);
  end;

  if (length(v1) > 0) then
  begin
    b := low(ansistring);
    e := b + INT_2W_U(length(v1)) - 1;
    if (v1[b] = '-') then
    begin
      Signeg := True;
      Inc(b);
    end;

    c := b;
    while (c <= e) do
    begin
      bit := (Ord(v1[c]) - Ord('0'));
      if (bit > 1) or (bit < 0) then
      begin
        Multi_Int_ERROR  := True;
        mi.Overflow_flag := True;
        mi.Defined_flag  := False;
        if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
        begin
          raise EInterror.Create('Invalid binary digit');
        end;
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
    if (mi.Overflow) then
    begin
      mi.Defined_flag := False;
      Multi_Int_ERROR := True;
      if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
      begin
        raise EInterror.Create('Overflow');
      end;
      goto 999;
    end;
  end;

  M_Val_All_Zero := True;
  n := 0;
  while (n < s) do
  begin
    mi.M_Value[n] := M_Val[n];
    if M_Val[n] > 0 then
    begin
      M_Val_All_Zero := False;
    end;
    Inc(n);
  end;
  if M_Val_All_Zero then
  begin
    Zeroneg := True;
  end;

  if Zeroneg then
  begin
    mi.Negative_flag := uBoolFalse;
  end
  else if Signeg then
  begin
    mi.Negative_flag := uBoolTrue;
  end
  else
  begin
    mi.Negative_flag := uBoolFalse;
  end;

  999: ;
end;


(******************************************)
procedure FromBin(const v1: ansistring; out mi: TMultiIntXV); overload;
begin
  Bin_to_Multi_Int_XV(v1, mi);
end;


(******************************************)
function TMultiIntXV.FromBin(const v1: ansistring): TMultiIntXV;
begin
  bin_to_Multi_Int_XV(v1, Result);
end;


(******************************************)
procedure Multi_Int_XV_to_bin(const v1: TMultiIntXV; var v2: ansistring;
  LZ: TMultiLeadingZeros); inline;
var
  s: ansistring = '';
  i, n: INT_1W_S;
begin
  if (not v1.Defined_flag) then
  begin
    v2 := 'UNDEFINED';
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.Overflow_flag) then
  begin
    v2 := 'OVERFLOW';
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    exit;
  end;

  n := INT_1W_SIZE;
  s := '';

  i := (v1.M_Value_Size - 1);
  while (i >= 0) do
  begin
    s := s + IntToBin(v1.M_Value[i], n);
    Dec(i);
  end;

  if (LZ = TrimLeadingZeros) then
  begin
    Removeleadingchars(s, ['0']);
  end;
  if (v1.Negative_flag = uBoolTrue) then
  begin
    s := '-' + s;
  end;
  if (s = '') then
  begin
    s := '0';
  end;
  v2 := s;
end;


(******************************************)
function TMultiIntXV.ToBin(const LZ: TMultiLeadingZeros): ansistring;
begin
  Multi_Int_XV_to_bin(self, Result, LZ);
end;


(******************************************)
procedure INT_2W_S_to_Multi_Int_XV(const v1: INT_2W_S; out mi: TMultiIntXV); inline;
var
  n: INT_2W_U;
begin
  mi.init;
  mi.Overflow_flag := False;
  mi.Defined_flag  := True;

  n := 2;
  while (n <= Multi_XV_maxi) do
  begin
    mi.M_Value[n] := 0;
    Inc(n);
  end;

  if (v1 < 0) then
  begin
    mi.Negative_flag := uBoolTrue;
    mi.M_Value[0]    := (ABS(v1) mod INT_1W_U_MAXINT_1);
    mi.M_Value[1]    := (ABS(v1) div INT_1W_U_MAXINT_1);
  end
  else
  begin
    mi.Negative_flag := uBoolFalse;
    mi.M_Value[0]    := (v1 mod INT_1W_U_MAXINT_1);
    mi.M_Value[1]    := (v1 div INT_1W_U_MAXINT_1);
  end;
end;


(******************************************)
class operator TMultiIntXV.:=(const v1: INT_2W_S): TMultiIntXV;
begin
  INT_2W_S_to_Multi_Int_XV(v1, Result);
end;


(******************************************)
procedure INT_2W_U_to_Multi_Int_XV(const v1: INT_2W_U; out mi: TMultiIntXV); inline;
var
  n: INT_2W_U;
begin
  mi.init;
  mi.Overflow_flag := False;
  mi.Defined_flag  := True;
  mi.Negative_flag := uBoolFalse;

  mi.M_Value[0] := (v1 mod INT_1W_U_MAXINT_1);
  mi.M_Value[1] := (v1 div INT_1W_U_MAXINT_1);

  n := 2;
  while (n <= Multi_XV_maxi) do
  begin
    mi.M_Value[n] := 0;
    Inc(n);
  end;
end;


(******************************************)
class operator TMultiIntXV.:=(const v1: INT_2W_U): TMultiIntXV;
begin
  INT_2W_U_to_Multi_Int_XV(v1, Result);
end;


{$ifdef CPU_32}
// The fact that thse routines only exist in 32bit mode looks suspicious.
// But it is not! These are dealing with 64bit integers in 32bit mode, which are 4 words in size)
// 4 word integers do not exist in 64bit mode

(******************************************)
procedure INT_4W_S_to_Multi_Int_XV(const v1: INT_4W_S; var mi: TMultiIntXV); inline;
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
      begin
        raise EInterror.Create('Overflow');
      end;
      exit;
    end;
  end;
  mi.Overflow_flag := False;
  mi.Defined_flag  := True;

  v := Abs(v1);
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

  if (v1 < 0) then
  begin
    mi.Negative_flag := uBoolTrue;
  end
  else
  begin
    mi.Negative_flag := uBoolFalse;
  end;
end;


(******************************************)
class operator TMultiIntXV.:=(const v1: INT_4W_S): TMultiIntXV;
begin
  INT_4W_S_to_Multi_Int_XV(v1, Result);
end;


(******************************************)
procedure INT_4W_U_to_Multi_Int_XV(const v1: INT_4W_U; var mi: TMultiIntXV); inline;
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
      begin
        raise EInterror.Create('Overflow');
      end;
      exit;
    end;
  end;
  mi.Overflow_flag := False;
  mi.Defined_flag  := True;
  mi.Negative_flag := uBoolFalse;

  v := v1;
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
class operator TMultiIntXV.:=(const v1: INT_4W_U): TMultiIntXV;
begin
  INT_4W_U_to_Multi_Int_XV(v1, Result);
end;
{$endif}


(******************************************)
procedure Multi_Int_X4_to_Multi_Int_XV(const v1: TMultiIntX4;
  var MI: TMultiIntXV); inline;
label
  OVERFLOW_BRANCH, CLEAN_EXIT;
var
  n: INT_1W_U;
begin
  MI.init;

  if (v1.Defined_flag = False) then
  begin
    Multi_Int_ERROR := True;
    MI.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (v1.Overflow_flag = True) then
  begin
    goto OVERFLOW_BRANCH;
  end;

  MI.Overflow_flag := v1.Overflow_flag;
  MI.Defined_flag  := v1.Defined_flag;
  MI.Negative_flag := v1.Negative_flag;

  n := 0;
  if (MI.M_Value_Size < Multi_X4_size) then
  begin
    Multi_Int_Reset_XV_Size(MI, Multi_X4_size);
    if (MI.Overflow) then
    begin
      goto OVERFLOW_BRANCH;
    end;
  end;

  while (n <= Multi_X4_maxi) do
  begin
    MI.M_Value[n] := v1.M_Value[n];
    Inc(n);
  end;
  while (n <= Multi_XV_maxi) do
  begin
    MI.M_Value[n] := 0;
    Inc(n);
  end;

  goto CLEAN_EXIT;

  OVERFLOW_BRANCH:

    Multi_Int_ERROR := True;
  MI.Overflow_flag  := True;
  if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
  begin
    raise EInterror.Create('Overflow');
  end;
  exit;

  CLEAN_EXIT: ;

end;


(******************************************)
class operator TMultiIntXV.:=(const v1: TMultiIntX4): TMultiIntXV;
begin
  Multi_Int_X4_to_Multi_Int_XV(v1, Result);
end;


(******************************************)
function To_Multi_Int_XV(const v1: TMultiIntX4): TMultiIntXV;
begin
  Multi_Int_X4_to_Multi_Int_XV(v1, Result);
end;


(******************************************)
procedure Multi_Int_X3_to_Multi_Int_XV(const v1: TMultiIntX3;
  var MI: TMultiIntXV); inline;
label
  OVERFLOW_BRANCH, CLEAN_EXIT;
var
  n: INT_1W_U;
begin
  MI.init;

  if (v1.Defined_flag = False) then
  begin
    Multi_Int_ERROR := True;
    MI.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (v1.Overflow_flag = True) then
  begin
    goto OVERFLOW_BRANCH;
  end;

  MI.Overflow_flag := v1.Overflow_flag;
  MI.Defined_flag  := v1.Defined_flag;
  MI.Negative_flag := v1.Negative_flag;

  n := 0;
  if (MI.M_Value_Size < Multi_X3_size) then
  begin
    Multi_Int_Reset_XV_Size(MI, Multi_X3_size);
    if (MI.Overflow) then
    begin
      goto OVERFLOW_BRANCH;
    end;
  end;

  while (n <= Multi_X3_maxi) do
  begin
    MI.M_Value[n] := v1.M_Value[n];
    Inc(n);
  end;
  while (n <= Multi_XV_maxi) do
  begin
    MI.M_Value[n] := 0;
    Inc(n);
  end;

  goto CLEAN_EXIT;

  OVERFLOW_BRANCH:

    Multi_Int_ERROR := True;
  MI.Overflow_flag  := True;
  if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
  begin
    raise EInterror.Create('Overflow');
  end;
  exit;

  CLEAN_EXIT: ;

end;


(******************************************)
class operator TMultiIntXV.:=(const v1: TMultiIntX3): TMultiIntXV;
begin
  Multi_Int_X3_to_Multi_Int_XV(v1, Result);
end;


(******************************************)
function To_Multi_Int_XV(const v1: TMultiIntX3): TMultiIntXV;
begin
  Multi_Int_X3_to_Multi_Int_XV(v1, Result);
end;


(******************************************)
procedure Multi_Int_X2_to_Multi_Int_XV(const v1: TMultiIntX2;
  var MI: TMultiIntXV); inline;
label
  OVERFLOW_BRANCH, CLEAN_EXIT;
var
  n: INT_1W_U;
begin
  MI.init;

  if (v1.FIsDefined = False) then
  begin
    Multi_Int_ERROR := True;
    MI.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  if (v1.FHasOverflow = True) then
  begin
    goto OVERFLOW_BRANCH;
  end;

  MI.Overflow_flag := v1.FHasOverflow;
  MI.Defined_flag  := v1.FIsDefined;
  MI.Negative_flag := v1.FIsNegative;

  n := 0;
  if (MI.M_Value_Size < Multi_X2_size) then
  begin
    Multi_Int_Reset_XV_Size(MI, Multi_X2_size);
    if (MI.Overflow) then
    begin
      goto OVERFLOW_BRANCH;
    end;
  end;

  while (n <= Multi_X2_maxi) do
  begin
    MI.M_Value[n] := v1.FParts[n];
    Inc(n);
  end;
  while (n <= Multi_XV_maxi) do
  begin
    MI.M_Value[n] := 0;
    Inc(n);
  end;

  goto CLEAN_EXIT;

  OVERFLOW_BRANCH:

    Multi_Int_ERROR := True;
  MI.Overflow_flag  := True;
  if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
  begin
    raise EInterror.Create('Overflow');
  end;
  exit;

  CLEAN_EXIT: ;

end;


(******************************************)
class operator TMultiIntXV.:=(const v1: TMultiIntX2): TMultiIntXV;
begin
  Multi_Int_X2_to_Multi_Int_XV(v1, Result);
end;


(******************************************)
function To_Multi_Int_XV(const v1: TMultiIntX2): TMultiIntXV;
begin
  Multi_Int_X2_to_Multi_Int_XV(v1, Result);
end;


(******************************************)
class operator TMultiIntXV.:=(const v1: TMultiIntXV): single;
var
  R, V, M: single;
  i: INT_1W_U;
  finished: boolean;
begin
  if (not v1.Defined_flag) then
  begin
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.Overflow_flag) then
  begin
    Result := 0;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  Multi_Int_ERROR := False;
  finished := False;
  M := INT_1W_U_MAXINT_1;

  R := v1.M_Value[0];
  i := 1;
  while (i < v1.M_Value_Size) and (not Multi_Int_ERROR) do
  begin
    if (not finished) then
    begin
      V := v1.M_Value[i];
      try
        begin
          V := (V * M);
          R := R + V;
        end
      except
        begin
          Multi_Int_ERROR := True;
          if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
          begin
            raise EIntOverflow.Create('Overflow');
          end;
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
    begin
      if (v1.M_Value[i] > 0) then
      begin
        Multi_Int_ERROR := True;
        if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
        begin
          raise EIntOverflow.Create('Overflow');
        end;
      end;
    end;
    Inc(i);
  end;

  if v1.Negative_flag then
  begin
    R := (-R);
  end;
  Result := R;
end;


(******************************************)
class operator TMultiIntXV.:=(const v1: TMultiIntXV): real;
var
  R, V, M: real;
  i: INT_1W_U;
  finished: boolean;
begin
  if (not v1.Defined_flag) then
  begin
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.Overflow_flag) then
  begin
    Result := 0;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  Multi_Int_ERROR := False;
  finished := False;
  M := INT_1W_U_MAXINT_1;

  R := v1.M_Value[0];
  i := 1;
  while (i < v1.M_Value_Size) and (not Multi_Int_ERROR) do
  begin
    if (not finished) then
    begin
      V := v1.M_Value[i];
      try
        begin
          V := (V * M);
          R := R + V;
        end
      except
        begin
          Multi_Int_ERROR := True;
          if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
          begin
            raise EIntOverflow.Create('Overflow');
          end;
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
    begin
      if (v1.M_Value[i] > 0) then
      begin
        Multi_Int_ERROR := True;
        if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
        begin
          raise EIntOverflow.Create('Overflow');
        end;
      end;
    end;
    Inc(i);
  end;

  if v1.Negative_flag then
  begin
    R := (-R);
  end;
  Result := R;
end;


(******************************************)
class operator TMultiIntXV.:=(const v1: TMultiIntXV): double;
var
  R, V, M: double;
  i: INT_1W_U;
  finished: boolean;
begin
  if (not v1.Defined_flag) then
  begin
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.Overflow_flag) then
  begin
    Result := 0;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  Multi_Int_ERROR := False;
  finished := False;
  M := INT_1W_U_MAXINT_1;

  R := v1.M_Value[0];
  i := 1;
  while (i < v1.M_Value_Size) and (not Multi_Int_ERROR) do
  begin
    if (not finished) then
    begin
      V := v1.M_Value[i];
      try
        begin
          V := (V * M);
          R := R + V;
        end
      except
        begin
          Multi_Int_ERROR := True;
          if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
          begin
            raise EIntOverflow.Create('Overflow');
          end;
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
    begin
      if (v1.M_Value[i] > 0) then
      begin
        Multi_Int_ERROR := True;
        if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
        begin
          raise EIntOverflow.Create('Overflow');
        end;
      end;
    end;
    Inc(i);
  end;

  if v1.Negative_flag then
  begin
    R := (-R);
  end;
  Result := R;
end;


(******************************************)
// WARNING Float type to Multi_Int type conversion loses some precision
class operator TMultiIntXV.:=(const v1: single): TMultiIntXV;
var
  R: TMultiIntXV;
  R_FLOATREC: TFloatRec;
begin
  Multi_Int_ERROR := False;

  FloatToDecimal(R_FLOATREC, v1, SINGLE_TYPE_PRECISION_DIGITS, 0);
  String_to_Multi_Int_XV(AddCharR('0', AnsiLeftStr(R_FLOATREC.digits,
    (SINGLE_TYPE_PRECISION_DIGITS - 1)), R_FLOATREC.Exponent), R);

  if (R.Overflow) then
  begin
    Result.Defined_flag  := False;
    Result.Negative_flag := uBoolUndefined;
    Multi_Int_ERROR      := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  if (R_FLOATREC.Negative) then
  begin
    R.Negative_flag := True;
  end;
  Result := R;
end;


(******************************************)
// WARNING Float type to Multi_Int type conversion loses some precision
class operator TMultiIntXV.:=(const v1: real): TMultiIntXV;
var
  R: TMultiIntXV;
  R_FLOATREC: TFloatRec;
begin
  Multi_Int_ERROR := False;

  FloatToDecimal(R_FLOATREC, v1, REAL_TYPE_PRECISION_DIGITS, 0);
  String_to_Multi_Int_XV(AddCharR('0', AnsiLeftStr(R_FLOATREC.digits,
    (REAL_TYPE_PRECISION_DIGITS - 1)), R_FLOATREC.Exponent), R);

  if (R.Overflow) then
  begin
    Multi_Int_ERROR      := True;
    Result.Defined_flag  := False;
    Result.Negative_flag := uBoolUndefined;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  if (R_FLOATREC.Negative) then
  begin
    R.Negative_flag := True;
  end;
  Result := R;
end;


(******************************************)
// WARNING Float type to Multi_Int type conversion loses some precision
class operator TMultiIntXV.:=(const v1: double): TMultiIntXV;
var
  R: TMultiIntXV;
  R_FLOATREC: TFloatRec;
begin
  Multi_Int_ERROR := False;

  FloatToDecimal(R_FLOATREC, v1, DOUBLE_TYPE_PRECISION_DIGITS, 0);
  String_to_Multi_Int_XV(AddCharR('0', AnsiLeftStr(R_FLOATREC.digits,
    (DOUBLE_TYPE_PRECISION_DIGITS - 1)), R_FLOATREC.Exponent), R);

  if (R.Overflow) then
  begin
    Multi_Int_ERROR      := True;
    Result.Defined_flag  := False;
    Result.Negative_flag := uBoolUndefined;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  if (R_FLOATREC.Negative) then
  begin
    R.Negative_flag := True;
  end;
  Result := R;
end;


(******************************************)
class operator TMultiIntXV.:=(const v1: TMultiIntXV): INT_2W_S;
var
  R: INT_2W_U;
  n: INT_1W_U;
  M_Val_All_Zero: boolean;
begin
  Multi_Int_ERROR := False;
  if (not v1.Defined_flag) then
  begin
    Result := 0;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.Overflow_flag) then
  begin
    Result := 0;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  R := (INT_2W_U(v1.M_Value[0]) + (INT_2W_U(v1.M_Value[1]) * INT_1W_U_MAXINT_1));

  M_Val_All_Zero := True;
  n := 2;
  while (n < v1.M_Value_Size) and M_Val_All_Zero do
  begin
    if (v1.M_Value[n] <> 0) then
    begin
      M_Val_All_Zero := False;
    end;
    Inc(n);
  end;

  if (R >= INT_2W_S_MAXINT) or (not M_Val_All_Zero) then
  begin
    Result := 0;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  if v1.Negative_flag then
  begin
    Result := INT_2W_S(-R);
  end
  else
  begin
    Result := INT_2W_S(R);
  end;
end;


(******************************************)
class operator TMultiIntXV.:=(const v1: TMultiIntXV): INT_2W_U;
var
  R: INT_2W_U;
  n: INT_1W_U;
  M_Val_All_Zero: boolean;
begin
  Multi_Int_ERROR := False;
  if (not v1.Defined_flag) then
  begin
    Result := 0;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.Overflow_flag) or (v1.Negative_flag = True) then
  begin
    Result := 0;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  R := (INT_2W_U(v1.M_Value[1]) << INT_1W_SIZE);
  R := (R or INT_2W_U(v1.M_Value[0]));

  M_Val_All_Zero := True;
  n := 2;
  while (n < v1.M_Value_Size) and M_Val_All_Zero do
  begin
    if (v1.M_Value[n] <> 0) then
    begin
      M_Val_All_Zero := False;
    end;
    Inc(n);
  end;

  if (not M_Val_All_Zero) then
  begin
    Result := 0;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    exit;
  end;

  Result := R;
end;


(******************************************)
class operator TMultiIntXV.:=(const v1: TMultiIntXV): INT_1W_S;
var
  R: INT_2W_U;
  n: INT_1W_U;
  M_Val_All_Zero: boolean;
begin
  Multi_Int_ERROR := False;
  if (not v1.Defined_flag) then
  begin
    Result := 0;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.Overflow_flag) then
  begin
    Result := 0;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  R := (INT_2W_U(v1.M_Value[0]) + (INT_2W_U(v1.M_Value[1]) * INT_1W_U_MAXINT_1));

  M_Val_All_Zero := True;
  n := 2;
  while (n < v1.M_Value_Size) and M_Val_All_Zero do
  begin
    if (v1.M_Value[n] <> 0) then
    begin
      M_Val_All_Zero := False;
    end;
    Inc(n);
  end;

  if (R > INT_1W_S_MAXINT) or (not M_Val_All_Zero) then
  begin
    Result := 0;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    exit;
  end;

  if v1.Negative_flag then
  begin
    Result := INT_1W_S(-R);
  end
  else
  begin
    Result := INT_1W_S(R);
  end;
end;


(******************************************)
class operator TMultiIntXV.:=(const v1: TMultiIntXV): INT_1W_U;
var
  R: INT_2W_U;
  n: INT_1W_U;
  M_Val_All_Zero: boolean;
begin
  Multi_Int_ERROR := False;
  if (not v1.Defined_flag) then
  begin
    Result := 0;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.Overflow_flag) or (v1.Negative_flag = True) then
  begin
    Result := 0;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  R := (INT_2W_U(v1.M_Value[0]) + (INT_2W_U(v1.M_Value[1]) * INT_1W_U_MAXINT_1));

  M_Val_All_Zero := True;
  n := 2;
  while (n < v1.M_Value_Size) and M_Val_All_Zero do
  begin
    if (v1.M_Value[n] <> 0) then
    begin
      M_Val_All_Zero := False;
    end;
    Inc(n);
  end;

  if (R > INT_1W_U_MAXINT) or (not M_Val_All_Zero) then
  begin
    Result := 0;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Overflow');
    end;
    exit;
  end;

  Result := INT_1W_U(R);
end;


{******************************************}
class operator TMultiIntXV.:=(const v1: TMultiIntXV): TMultiUInt8;
begin
  Multi_Int_ERROR := False;
  if (not v1.Defined_flag) then
  begin
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.Overflow_flag) or (v1.Negative_flag = uBoolTrue) then
  begin
    Result := 0;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  if v1 > UINT8_MAX then
  begin
    Multi_Int_ERROR := True;
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  Result := TMultiUInt8(v1.M_Value[0]);
end;


{******************************************}
class operator TMultiIntXV.:=(const v1: TMultiIntXV): TMultiInt8;
begin
  Multi_Int_ERROR := False;
  if (not v1.Defined_flag) then
  begin
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.Overflow_flag) then
  begin
    Result := 0;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  if v1 > UINT8_MAX then
  begin
    Multi_Int_ERROR := True;
    Result := 0;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;

  Result := TMultiInt8(v1.M_Value[0]);
end;


(******************************************)
function add_Multi_Int_XV(const v1, v2: TMultiIntXV): TMultiIntXV;
label
  999;
var
  tv1, tv2: INT_2W_S;
  i, s1, s2, s, ss: INT_1W_S;
  M_Val: array of INT_2W_U;
  M_Val_All_Zero: boolean;
begin
  s1 := v1.M_Value_Size;
  s2 := v2.M_Value_Size;
  s  := s1;
  if (s1 < s2) then
  begin
    s := s2;
  end;
  ss := (s + 1);
  setlength(M_Val, ss);

  tv1      := v1.M_Value[0];
  tv2      := v2.M_Value[0];
  M_Val[0] := (tv1 + tv2);
  if M_Val[0] > INT_1W_U_MAXINT then
  begin
    M_Val[1] := (M_Val[0] div INT_1W_U_MAXINT_1);
    M_Val[0] := (M_Val[0] mod INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[1] := 0;
  end;

  i := 1;
  while (i < (s - 1)) do
  begin
    if (i < s1) then
    begin
      tv1 := v1.M_Value[i];
    end
    else
    begin
      tv1 := 0;
    end;
    if (i < s2) then
    begin
      tv2 := v2.M_Value[i];
    end
    else
    begin
      tv2 := 0;
    end;
    M_Val[i] := (M_Val[i] + tv1 + tv2);
    if M_Val[i] > INT_1W_U_MAXINT then
    begin
      M_Val[i + 1] := (M_Val[i] div INT_1W_U_MAXINT_1);
      M_Val[i]     := (M_Val[i] mod INT_1W_U_MAXINT_1);
    end
    else
    begin
      M_Val[i + 1] := 0;
    end;
    Inc(i);
  end;

  if (i < s1) then
  begin
    tv1 := v1.M_Value[i];
  end
  else
  begin
    tv1 := 0;
  end;
  if (i < s2) then
  begin
    tv2 := v2.M_Value[i];
  end
  else
  begin
    tv2 := 0;
  end;
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
  if (ss > Result.M_Value_Size) then
  begin
    Multi_Int_Reset_XV_Size(Result, ss);
    if (Result.Overflow) then
    begin
      Multi_Int_ERROR     := True;
      Result.Defined_flag := False;
      goto 999;
    end;
  end;

  Result.Overflow_flag := False;
  Result.Defined_flag  := True;
  Result.Negative_flag := uBoolUndefined;

  M_Val_All_Zero := True;
  i := 0;
  while (i < ss) do
  begin
    Result.M_Value[i] := M_Val[i];
    if M_Val[i] <> 0 then
    begin
      M_Val_All_Zero := False;
    end;
    Inc(i);
  end;

  if M_Val_All_Zero then
  begin
    Result.Negative_flag := uBoolFalse;
  end;

  999: ;
end;


(******************************************)
function subtract_Multi_Int_XV(const v1, v2: TMultiIntXV): TMultiIntXV;
label
  999;
var
  tv1, tv2: INT_2W_S;
  M_Val: array of INT_2W_S;
  i, s1, s2, s, ss: INT_2W_S;
  M_Val_All_Zero: boolean;
begin
  s1 := v1.M_Value_Size;
  s2 := v2.M_Value_Size;
  s  := s1;
  if (s1 < s2) then
  begin
    s := s2;
  end;
  ss := (s + 1);
  setlength(M_Val, ss);

  M_Val[0] := (v1.M_Value[0] - v2.M_Value[0]);
  if M_Val[0] < 0 then
  begin
    M_Val[1] := -1;
    M_Val[0] := (M_Val[0] + INT_1W_U_MAXINT_1);
  end
  else
  begin
    M_Val[1] := 0;
  end;

  i := 1;
  while (i < (s - 1)) do
  begin
    if (i < s1) then
    begin
      tv1 := v1.M_Value[i];
    end
    else
    begin
      tv1 := 0;
    end;
    if (i < s2) then
    begin
      tv2 := v2.M_Value[i];
    end
    else
    begin
      tv2 := 0;
    end;
    M_Val[i] := (M_Val[i] + (tv1 - tv2));
    if M_Val[i] < 0 then
    begin
      M_Val[i + 1] := -1;
      M_Val[i]     := (M_Val[i] + INT_1W_U_MAXINT_1);
    end
    else
    begin
      M_Val[i + 1] := 0;
    end;
    Inc(i);
  end;

  if (i < s1) then
  begin
    tv1 := v1.M_Value[i];
  end
  else
  begin
    tv1 := 0;
  end;
  if (i < s2) then
  begin
    tv2 := v2.M_Value[i];
  end
  else
  begin
    tv2 := 0;
  end;
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
  if (ss > Result.M_Value_Size) then
  begin
    Multi_Int_Reset_XV_Size(Result, ss);
    if (Result.Overflow) then
    begin
      Multi_Int_ERROR     := True;
      Result.Defined_flag := False;
      goto 999;
    end;
  end;

  Result.Overflow_flag := False;
  Result.Defined_flag  := True;
  Result.Negative_flag := uBoolUndefined;

  M_Val_All_Zero := True;
  i := 0;
  while (i < ss) do
  begin
    Result.M_Value[i] := M_Val[i];
    if M_Val[i] > 0 then
    begin
      M_Val_All_Zero := False;
    end;
    Inc(i);
  end;

  if M_Val_All_Zero then
  begin
    Result.Negative_flag := uBoolFalse;
  end;

  999: ;
end;


(******************************************)
class operator TMultiIntXV.+(const v1, v2: TMultiIntXV): TMultiIntXV;
var
  Neg: TMultiUBool;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.Overflow_flag or v2.Overflow_flag) then
  begin
    Result := 0;
    Result.Overflow_flag := True;
    Result.Defined_flag := True;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  Neg := uBoolUndefined;

  if (v1.Negative_flag = v2.Negative_flag) then
  begin
    Result := add_Multi_Int_XV(v1, v2);
    Neg    := v1.Negative_flag;
  end
  else
  if ((v1.Negative_flag = False) and (v2.Negative_flag = True)) then
  begin
    if ABS_greaterthan_Multi_Int_XV(v2, v1) then
    begin
      Result := subtract_Multi_Int_XV(v2, v1);
      Neg    := uBoolTrue;
    end
    else
    begin
      Result := subtract_Multi_Int_XV(v1, v2);
      Neg    := uBoolFalse;
    end;
  end
  else
  begin
    if ABS_greaterthan_Multi_Int_XV(v1, v2) then
    begin
      Result := subtract_Multi_Int_XV(v1, v2);
      Neg    := uBoolTrue;
    end
    else
    begin
      Result := subtract_Multi_Int_XV(v2, v1);
      Neg    := uBoolFalse;
    end;
  end;

  if (Result.Overflow_flag = True) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
  end;

  if (Result.Negative_flag = uBoolUndefined) then
  begin
    Result.Negative_flag := Neg;
  end;
end;


(******************************************)
class operator TMultiIntXV.Inc(const v1: TMultiIntXV): TMultiIntXV;
var
  Neg: TMultiUBoolState;
  v2: TMultiIntXV;
begin
  if (not v1.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := v1.Defined_flag;
    Result.Overflow_flag := v1.Overflow_flag;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.Overflow_flag) then
  begin
    Result := 0;
    Result.Defined_flag := v1.Defined_flag;
    Result.Overflow_flag := v1.Overflow_flag;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  Neg := uBoolUndefined;
  v2  := 1;

  if (v1.Negative_flag = False) then
  begin
    Result := add_Multi_Int_XV(v1, v2);
    Neg    := v1.Negative_flag;
  end
  else
  begin
    if ABS_greaterthan_Multi_Int_XV(v1, v2) then
    begin
      Result := subtract_Multi_Int_XV(v1, v2);
      Neg    := uBoolTrue;
    end
    else
    begin
      Result := subtract_Multi_Int_XV(v2, v1);
      Neg    := uBoolFalse;
    end;
  end;

  if (Result.Overflow_flag = True) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
  end;

  if (Result.Negative_flag = uBoolUndefined) then
  begin
    Result.Negative_flag := Neg;
  end;
end;


(******************************************)
class operator TMultiIntXV.-(const v1, v2: TMultiIntXV): TMultiIntXV;
var
  Neg: TMultiUBoolState;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.Overflow_flag or v2.Overflow_flag) then
  begin
    Result := 0;
    Result.Overflow_flag := True;
    Result.Defined_flag := True;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  Neg := uBoolUndefined;

  if (v1.Negative_flag = v2.Negative_flag) then
  begin
    if (v1.Negative_flag = True) then
    begin
      if ABS_greaterthan_Multi_Int_XV(v1, v2) then
      begin
        Result := subtract_Multi_Int_XV(v1, v2);
        Neg    := uBoolTrue;
      end
      else
      begin
        Result := subtract_Multi_Int_XV(v2, v1);
        Neg    := uBoolFalse;
      end;
    end
    else  (* if  not Negative_flag then  *)
    begin
      if ABS_greaterthan_Multi_Int_XV(v2, v1) then
      begin
        Result := subtract_Multi_Int_XV(v2, v1);
        Neg    := uBoolTrue;
      end
      else
      begin
        Result := subtract_Multi_Int_XV(v1, v2);
        Neg    := uBoolFalse;
      end;
    end;
  end
  else (* v1.Negative_flag <> v2.Negative_flag *)
  begin
    if (v2.Negative_flag = True) then
    begin
      Result := add_Multi_Int_XV(v1, v2);
      Neg    := uBoolFalse;
    end
    else
    begin
      Result := add_Multi_Int_XV(v1, v2);
      Neg    := uBoolTrue;
    end;
  end;

  if (Result.Overflow_flag = True) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
  end;

  if (Result.Negative_flag = uBoolUndefined) then
  begin
    Result.Negative_flag := Neg;
  end;
end;


(******************************************)
class operator TMultiIntXV.Dec(const v1: TMultiIntXV): TMultiIntXV;
var
  Neg: TMultiUBoolState;
  v2: TMultiIntXV;
begin
  if (not v1.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := v1.Defined_flag;
    Result.Overflow_flag := v1.Overflow_flag;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.Overflow_flag) then
  begin
    Result := 0;
    Result.Defined_flag := v1.Defined_flag;
    Result.Overflow_flag := v1.Overflow_flag;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  Neg := uBoolUndefined;
  v2  := 1;

  if (v1.Negative_flag = False) then
  begin
    if ABS_greaterthan_Multi_Int_XV(v2, v1) then
    begin
      Result := subtract_Multi_Int_XV(v2, v1);
      Neg    := uBoolTrue;
    end
    else
    begin
      Result := subtract_Multi_Int_XV(v1, v2);
      Neg    := uBoolFalse;
    end;
  end
  else (* v1 is Negative_flag *)
  begin
    Result := add_Multi_Int_XV(v1, v2);
    Neg    := uBoolTrue;
  end;

  if (Result.Overflow_flag = True) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
  end;

  if (Result.Negative_flag = uBoolUndefined) then
  begin
    Result.Negative_flag := Neg;
  end;
end;


(******************************************)
class operator TMultiIntXV.-(const v1: TMultiIntXV): TMultiIntXV;
begin
  if (not v1.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := v1.Defined_flag;
    Result.Overflow_flag := v1.Overflow_flag;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.Overflow_flag) then
  begin
    Result := 0;
    Result.Defined_flag := v1.Defined_flag;
    Result.Overflow_flag := v1.Overflow_flag;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  Result := v1;
  if (v1.Negative_flag = uBoolTrue) then
  begin
    Result.Negative_flag := uBoolFalse;
  end;
  if (v1.Negative_flag = uBoolFalse) then
  begin
    Result.Negative_flag := uBoolTrue;
  end;
end;


(******************************************)
class operator TMultiIntXV.xor(const v1, v2: TMultiIntXV): TMultiIntXV;
label
  999;
var
  i, s1, s2, s: INT_1W_S;
  tv1, tv2: INT_1W_U;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.Overflow_flag or v2.Overflow_flag) then
  begin
    Result := 0;
    Result.Overflow_flag := True;
    Result.Defined_flag := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  s1 := v1.M_Value_Size;
  s2 := v2.M_Value_Size;
  s  := s1;
  if (s1 < s2) then
  begin
    s := s2;
  end;

  Result.init;
  if (s > Result.M_Value_Size) then
  begin
    Multi_Int_Reset_XV_Size(Result, s);
    if (Result.Overflow) then
    begin
      Multi_Int_ERROR     := True;
      Result.Defined_flag := False;
      goto 999;
    end;
  end;

  i := 0;
  while (i < s) do
  begin
    if (i < s1) then
    begin
      tv1 := v1.M_Value[i];
    end
    else
    begin
      tv1 := 0;
    end;
    if (i < s2) then
    begin
      tv2 := v2.M_Value[i];
    end
    else
    begin
      tv2 := 0;
    end;
    Result.M_Value[i] := (tv1 xor tv2);
    Inc(i);
  end;

  Result.Defined_flag  := True;
  Result.Overflow_flag := False;

  Result.Negative_flag := uBoolFalse;
  if (v1.Negative <> v2.Negative) then
  begin
    Result.Negative_flag := uBoolTrue;
  end;

  999: ;
end;


(******************************************)
class operator TMultiIntXV.or(const v1, v2: TMultiIntXV): TMultiIntXV;
label
  999;
var
  i, s1, s2, s: INT_1W_S;
  tv1, tv2: INT_1W_U;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.Overflow_flag or v2.Overflow_flag) then
  begin
    Result := 0;
    Result.Overflow_flag := True;
    Result.Defined_flag := True;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  s1 := v1.M_Value_Size;
  s2 := v2.M_Value_Size;
  s  := s1;
  if (s1 < s2) then
  begin
    s := s2;
  end;

  Result.init;
  if (s > Result.M_Value_Size) then
  begin
    Multi_Int_Reset_XV_Size(Result, s);
    if (Result.Overflow) then
    begin
      Multi_Int_ERROR     := True;
      Result.Defined_flag := False;
      goto 999;
    end;
  end;

  i := 0;
  while (i < s) do
  begin
    if (i < s1) then
    begin
      tv1 := v1.M_Value[i];
    end
    else
    begin
      tv1 := 0;
    end;
    if (i < s2) then
    begin
      tv2 := v2.M_Value[i];
    end
    else
    begin
      tv2 := 0;
    end;
    Result.M_Value[i] := (tv1 or tv2);
    Inc(i);
  end;

  Result.Defined_flag  := True;
  Result.Overflow_flag := False;

  Result.Negative_flag := uBoolFalse;
  if v1.Negative and v2.Negative then
  begin
    Result.Negative_flag := uBoolTrue;
  end;

  999: ;
end;


(******************************************)
class operator TMultiIntXV.and(const v1, v2: TMultiIntXV): TMultiIntXV;
label
  999;
var
  i, s1, s2, s: INT_1W_S;
  tv1, tv2: INT_1W_U;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.Overflow_flag or v2.Overflow_flag) then
  begin
    Result := 0;
    Result.Overflow_flag := True;
    Result.Defined_flag := True;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  s1 := v1.M_Value_Size;
  s2 := v2.M_Value_Size;
  s  := s1;
  if (s1 < s2) then
  begin
    s := s2;
  end;

  Result.init;
  if (s > Result.M_Value_Size) then
  begin
    Multi_Int_Reset_XV_Size(Result, s);
    if (Result.Overflow) then
    begin
      Multi_Int_ERROR     := True;
      Result.Defined_flag := False;
      goto 999;
    end;
  end;

  i := 0;
  while (i < s) do
  begin
    if (i < s1) then
    begin
      tv1 := v1.M_Value[i];
    end
    else
    begin
      tv1 := 0;
    end;
    if (i < s2) then
    begin
      tv2 := v2.M_Value[i];
    end
    else
    begin
      tv2 := 0;
    end;
    Result.M_Value[i] := (tv1 and tv2);
    Inc(i);
  end;

  Result.Defined_flag  := True;
  Result.Overflow_flag := False;

  Result.Negative_flag := uBoolFalse;
  if v1.Negative and v2.Negative then
  begin
    Result.Negative_flag := uBoolTrue;
  end;

  999: ;
end;


(******************************************)
class operator TMultiIntXV.not(const v1: TMultiIntXV): TMultiIntXV;
label
  999;
var
  i, s1, s: INT_1W_S;
  tv1: INT_1W_U;
begin
  if (not v1.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.Overflow_flag) then
  begin
    Result := 0;
    Result.Overflow_flag := True;
    Result.Defined_flag := True;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  s1 := v1.M_Value_Size;
  s  := s1;

  Result.init;
  if (s > Result.M_Value_Size) then
  begin
    Multi_Int_Reset_XV_Size(Result, s);
    if (Result.Overflow) then
    begin
      Multi_Int_ERROR     := True;
      Result.Defined_flag := False;
      goto 999;
    end;
  end;

  i := 0;
  while (i < s) do
  begin
    if (i < s1) then
    begin
      tv1 := v1.M_Value[i];
    end
    else
    begin
      tv1 := 0;
    end;
    Result.M_Value[i] := (not tv1);
    Inc(i);
  end;

  Result.Defined_flag  := True;
  Result.Overflow_flag := False;

  Result.Negative_flag := uBoolTrue;
  if v1.Negative then
  begin
    Result.Negative_flag := uBoolFalse;
  end;

  999: ;
end;


(*******************v4*********************)
procedure multiply_Multi_Int_XV(const v1, v2: TMultiIntXV;
  out Result: TMultiIntXV); overload;
label
  999;
var
  i, j, k, s1, s2, ss, z2, z1: INT_2W_S;
  zf, zero_mult: boolean;
  tv1, tv2: INT_2W_U;
  M_Val: array of INT_2W_U;
begin
  s1 := v1.M_Value_Size;
  s2 := v2.M_Value_Size;
  ss := (s1 + s2 + 1);
  setlength(M_Val, ss);

  Result.init;
  Result.Overflow_flag := False;
  Result.Defined_flag  := True;
  Result.Negative_flag := uBoolUndefined;

  // skip leading zeros in v2
  zf := False;
  i  := (s2 - 1);
  z2 := -1;
  repeat
    if (v2.M_Value[i] <> 0) then
    begin
      z2 := i;
      zf := True;
    end;
    Dec(i);
  until (i < 0) or (zf);
  if (z2 < 0) then
  begin
    Result.Negative_flag := uBoolFalse;
    goto 999;
  end;

  // skip leading zeros in v1
  zf := False;
  i  := (s1 - 1);
  z1 := -1;
  repeat
    if (v1.M_Value[i] <> 0) then
    begin
      z1 := i;
      zf := True;
    end;
    Dec(i);
  until (i < 0) or (zf);
  if (z1 < 0) then
  begin
    Result.Negative_flag := uBoolFalse;
    goto 999;
  end;

  // main loopy
  i := 0;
  j := 0;
  repeat
    if (v2.M_Value[j] <> 0) then
    begin
      zero_mult := True;
      repeat
        if (v1.M_Value[i] <> 0) then
        begin
          zero_mult := False;
          tv1 := v1.M_Value[i];
          tv2 := v2.M_Value[j];
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

  Result.Negative_flag := uBoolFalse;
  zf := False;
  z1 := -1;
  i  := (ss - 1);
  repeat
    if (M_Val[i] <> 0) then
    begin
      Result.Negative_flag := uBoolUndefined;
      if (not zf) then
      begin
        zf := True;
        z1 := i;
      end;
    end;
    Dec(i);
  until (i < 0);

  if ((z1 + 1) > Result.M_Value_Size) then
  begin
    Multi_Int_Reset_XV_Size(Result, (z1 + 1));
    if (Result.Overflow) then
    begin
      Multi_Int_ERROR     := True;
      Result.Defined_flag := False;
      goto 999;
    end;
  end;

  // copy temp M_Val to Result
  i := 0;
  while (i <= z1) do
  begin
    Result.M_Value[i] := M_Val[i];
    Inc(i);
  end;

  999: ;
end;


(******************************************)
class operator TMultiIntXV.*(const v1, v2: TMultiIntXV): TMultiIntXV;
var
  R: TMultiIntXV;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.Overflow_flag or v2.Overflow_flag) then
  begin
    Result := 0;
    Result.Overflow_flag := True;
    Result.Defined_flag := True;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  multiply_Multi_Int_XV(v1, v2, R);

  if (R.Negative_flag = uBoolUndefined) then
  begin
    if (v1.Negative_flag = v2.Negative_flag) then
    begin
      R.Negative_flag := uBoolFalse;
    end
    else
    begin
      R.Negative_flag := uBoolTrue;
    end;
  end;

  Result.init;

  // redundant?
{
if (R.M_Value_Size > Result.M_Value_Size) then
  begin
  Multi_Int_Reset_XV_Size(Result,R.M_Value_Size);
  if (Result.Overflow) then
    begin
    Multi_Int_ERROR:= TRUE;
    Result.Defined_flag:= FALSE;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
      Raise EIntOverflow.create('Overflow');
    end;
  end;
}

  Result := R;

  if (Result.Overflow_flag = True) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
  end;

end;


(********************v3********************)
{ Function exp_by_squaring_iterative(TV, P) }

class operator TMultiIntXV.**(const v1: TMultiIntXV; const P: INT_2W_S): TMultiIntXV;
var
  Y, TV, T, R: TMultiIntXV;
  PT: INT_2W_S;
begin
  if (not v1.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.Overflow_flag) then
  begin
    Result := 0;
    Result.Overflow_flag := True;
    Result.Defined_flag := True;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  PT := P;
  TV := v1;
  if (PT < 0) then
  begin
    R := 0;
  end
  else if (PT = 0) then
  begin
    R := 1;
  end
  else
  begin
    Y := 1;
    while (PT > 1) do
    begin
      if odd(PT) then
      begin
        multiply_Multi_Int_XV(TV, Y, T);
        if (T.Overflow_flag) then
        begin
          Result := 0;
          Result.Defined_flag := False;
          Result.Overflow_flag := True;
          Multi_Int_ERROR := True;
          if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
          begin
            raise EIntOverflow.Create('Overflow');
          end;
          exit;
        end;
        if (T.Negative_flag = uBoolUndefined) then
        begin
          if (TV.Negative_flag = Y.Negative_flag) then
          begin
            T.Negative_flag := uBoolFalse;
          end
          else
          begin
            T.Negative_flag := uBoolTrue;
          end;
        end;

        Y  := T;
        PT := PT - 1;
      end;
      multiply_Multi_Int_XV(TV, TV, T);
      if (T.Overflow_flag) then
      begin
        Result := 0;
        Result.Defined_flag := False;
        Result.Overflow_flag := True;
        Multi_Int_ERROR := True;
        if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
        begin
          raise EIntOverflow.Create('Overflow');
        end;
        exit;
      end;
      T.Negative_flag := uBoolFalse;

      TV := T;
      PT := (PT div 2);
    end;
    multiply_Multi_Int_XV(TV, Y, R);
    if (R.Overflow_flag) then
    begin
      Result := 0;
      Result.Defined_flag := False;
      Result.Overflow_flag := True;
      Multi_Int_ERROR := True;
      if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
      begin
        raise EIntOverflow.Create('Overflow');
      end;
      exit;
    end;
    if (R.Negative_flag = uBoolUndefined) then
    begin
      if (TV.Negative_flag = Y.Negative_flag) then
      begin
        R.Negative_flag := uBoolFalse;
      end
      else
      begin
        R.Negative_flag := uBoolTrue;
      end;
    end;
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
    P_quotient.Defined_flag := False;
    P_quotient.Overflow_flag := True;
    P_remainder.Defined_flag := False;
    P_remainder.Overflow_flag := True;
    Multi_Int_ERROR := True;
  end
  else if (P_dividor = P_dividend) then
  begin
    P_quotient := 1;
  end
  else
  begin
    if (Abs(P_dividor) > Abs(P_dividend)) then
    begin
      P_remainder := P_dividend;
      goto 9000;
    end;

    div_size := (P_dividend.M_Value_Size + 1);

    dividor := P_dividor;
    Multi_Int_Reset_XV_Size(dividor, div_size);
    if (dividor.Overflow) then
    begin
      P_quotient.Defined_flag := False;
      P_quotient.Overflow_flag := True;
      P_remainder.Defined_flag := False;
      P_remainder.Overflow_flag := True;
      Multi_Int_ERROR := True;
      goto 9999;
    end;

    dividend := P_dividend;
    Multi_Int_Reset_XV_Size(dividend, div_size);
    dividend.Negative_flag := False;

    quotient := 0;
    Multi_Int_Reset_XV_Size(quotient, div_size);

    next_dividend := 0;
    Multi_Int_Reset_XV_Size(next_dividend, div_size);

    dividor_non_zero_pos := 0;
    i := (dividor.M_Value_Size - 1);
    while (i >= 0) do
    begin
      if (dividor_non_zero_pos = 0) then
      begin
        if (dividor.M_Value[i] <> 0) then
        begin
          dividor_non_zero_pos := i;
          break;
        end;
      end;
      Dec(i);
    end;
    dividor.Negative_flag := False;

    // essential short-cut for single word dividor
    // NB this is not just for speed, the later code
    // will break if this case is not processed in advance

    if (dividor_non_zero_pos = 0) then
    begin
      word_carry := 0;
      i := Multi_XV_maxi;
      while (i >= 0) do
      begin
        P_quotient.M_Value[i] :=
          (((word_carry * INT_2W_U(INT_1W_U_MAXINT_1)) +
          INT_2W_U(P_dividend.M_Value[i])) div INT_2W_U(P_dividor.M_Value[0]));
        word_carry := (((word_carry * INT_2W_U(INT_1W_U_MAXINT_1)) +
          INT_2W_U(P_dividend.M_Value[i])) -
          (INT_2W_U(P_quotient.M_Value[i]) * INT_2W_U(P_dividor.M_Value[0])));
        Dec(i);
      end;
      P_remainder.M_Value[0] := word_carry;
      goto 9000;
    end;

    shiftup_bits_dividor := nlz_bits(dividor.M_Value[dividor_non_zero_pos]);
    if (shiftup_bits_dividor > 0) then
    begin
      ShiftUp_NBits_Multi_Int_XV(dividend, shiftup_bits_dividor);
      ShiftUp_NBits_Multi_Int_XV(dividor, shiftup_bits_dividor);
    end;

    next_word_carry := 0;
    word_carry  := 0;
    dividor_i   := dividor_non_zero_pos;
    dividor_i_1 := (dividor_i - 1);
    dividend_i  := (dividend.M_Value_Size - 1);
    finished    := False;
    while (not finished) do
    begin
      if (dividend_i >= 0) then
      begin
        if (dividend.M_Value[dividend_i] = 0) then
        begin
          Dec(dividend_i);
        end
        else
        begin
          finished := True;
        end;
      end
      else
      begin
        finished := True;
      end;
    end;
    quotient_i := (dividend_i - dividor_non_zero_pos);

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
            begin
              goto AGAIN;
            end;
          end;
        end;

        quotient := 0;
        Multi_Int_Reset_XV_Size(quotient, div_size);

        quotient.M_Value[quotient_i] := word_division;
        next_dividend := (dividor * quotient);
        next_dividend := (dividend - next_dividend);
        if (next_dividend.Negative) then
        begin
          Dec(word_division);
          quotient.M_Value[quotient_i] := word_division;
          next_dividend := (dividend - (dividor * quotient));
        end;
        P_quotient.M_Value[quotient_i] := word_division;
        dividend   := next_dividend;
        word_carry := dividend.M_Value[dividend_i];
      end
      else
      begin
        word_carry := word_dividend;
      end;

      Dec(dividend_i);
      quotient_i := (dividend_i - dividor_non_zero_pos);
    end; { while }

    ShiftDown_MultiBits_Multi_Int_XV(dividend, shiftup_bits_dividor);
    P_remainder := dividend;

    9000:
      if (P_dividend.Negative_flag = True) and (P_remainder > 0) then
      begin
        P_remainder.Negative_flag := True;
      end;

    if (P_dividend.Negative_flag <> P_dividor.Negative_flag) and (P_quotient > 0) then
    begin
      P_quotient.Negative_flag := True;
    end;

  end;

  9999: ;
end;


(******************************************)
class operator TMultiIntXV.div(const v1, v2: TMultiIntXV): TMultiIntXV;
var
  Remainder, Quotient: TMultiIntXV;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.Overflow_flag or v2.Overflow_flag) then
  begin
    Result := 0;
    Result.Overflow_flag := True;
    Result.Defined_flag := True;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  // same values as last time

  if (XV_Last_Divisor = v2) and (XV_Last_Dividend = v1) then
  begin
    Result := XV_Last_Quotient;
  end
  else  // different values than last time
  begin
    intdivide_taylor_warruth_XV(v1, v2, Quotient, Remainder);

    XV_Last_Divisor   := v2;
    XV_Last_Dividend  := v1;
    XV_Last_Quotient  := Quotient;
    XV_Last_Remainder := Remainder;

    Result := Quotient;
  end;

  if (XV_Last_Remainder.Overflow_flag) or (XV_Last_Quotient.Overflow_flag) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
  end;
end;


(******************************************)
class operator TMultiIntXV.mod(const v1, v2: TMultiIntXV): TMultiIntXV;
var
  Remainder, Quotient: TMultiIntXV;
begin
  if (not v1.Defined_flag) or (not v2.Defined_flag) then
  begin
    Result := 0;
    Result.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.Overflow_flag or v2.Overflow_flag) then
  begin
    Result := 0;
    Result.Overflow_flag := True;
    Result.Defined_flag := True;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  // same values as last time

  if (XV_Last_Divisor = v2) and (XV_Last_Dividend = v1) then
  begin
    Result := XV_Last_Remainder;
  end
  else  // different values than last time
  begin
    intdivide_taylor_warruth_XV(v1, v2, Quotient, Remainder);

    XV_Last_Divisor   := v2;
    XV_Last_Dividend  := v1;
    XV_Last_Quotient  := Quotient;
    XV_Last_Remainder := Remainder;

    Result := Remainder;
  end;


  if (XV_Last_Remainder.Overflow_flag) or (XV_Last_Quotient.Overflow_flag) then
  begin
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;
end;


(***********v2************)
procedure SqRoot(const v1: TMultiIntXV; out VR, VREM: TMultiIntXV);
var
  D, D2: INT_2W_S;
  HS, LS: ansistring;
  H, L, C, CC, LPC, CCD, Q, R, T: TMultiIntXV;
  finished: boolean;
begin
  if (not v1.Defined_flag) then
  begin
    VR   := 0;
    VR.Defined_flag := False;
    VREM := 0;
    VREM.Defined_flag := False;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EInterror.Create('Uninitialised variable');
    end;
    exit;
  end;
  if (v1.Overflow_flag) then
  begin
    VR   := 0;
    VR.Defined_flag := False;
    VREM := 0;
    VREM.Defined_flag := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  if (v1.Negative_flag = uBoolTrue) then
  begin
    VR   := 0;
    VR.Defined_flag := False;
    VREM := 0;
    VREM.Defined_flag := False;
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Overflow');
    end;
    exit;
  end;

  if (v1 >= 100) then
  begin
    D  := length(v1.ToStr);
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
    C := (v1 div 2);
    if (C = 0) then
    begin
      C := 1;
    end;
  end;

  finished := False;
  LPC      := v1;
  repeat
    begin
      // CC:= ((C + (v1 div C)) div 2);
      intdivide_taylor_warruth_XV(v1, C, Q, R);
      CC := (C + Q);
      ShiftDown_MultiBits_Multi_Int_XV(CC, 1);
      if (ABS(C - CC) < 2) then
      begin
        if (CC < LPC) then
        begin
          LPC := CC;
        end
        else if (CC >= LPC) then
        begin
          finished := True;
        end;
      end;
      C := CC;
    end
  until finished;

  VREM := (v1 - (LPC * LPC));
  VR   := LPC;
  VR.Negative_flag := uBoolFalse;
  VREM.Negative_flag := uBoolFalse;

end;


(*************************)
procedure SqRoot(const v1: TMultiIntXV; out VR: TMultiIntXV);
var
  VREM: TMultiIntXV;
begin
  VREM := 0;
  sqroot(v1, VR, VREM);
end;


(*************************)
function SqRoot(const v1: TMultiIntXV): TMultiIntXV;
var
  VR, VREM: TMultiIntXV;
begin
  VREM := 0;
  sqroot(v1, VR, VREM);
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
    Multi_Int_ERROR := True;
    if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
    begin
      raise EIntOverflow.Create('Multi_Init_Initialisation already called');
    end;
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
      Multi_Int_X3_MAXINT.M_Value[i] := INT_1W_U_MAXINT;
      Inc(i);
    end;

    Multi_Int_X4_MAXINT := 0;
    i := 0;
    while (i <= Multi_X4_maxi) do
    begin
      Multi_Int_X4_MAXINT.M_Value[i] := INT_1W_U_MAXINT;
      Inc(i);
    end;

    if (Multi_XV_maxi < 1) then
    begin
      if Multi_Int_RAISE_EXCEPTIONS_ENABLED then
      begin
        raise EInterror.Create('Multi_XV_maxi value must be > 0');
      end;
      halt(1);
    end;

    Multi_Int_XV_MAXINT := 0;
    i := 0;
    while (i <= Multi_XV_maxi) do
    begin
      Multi_Int_XV_MAXINT.M_Value[i] := INT_1W_U_MAXINT;
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
