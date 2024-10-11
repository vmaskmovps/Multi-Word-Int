unit MultiInt.Bool;

{$mode ObjFPC}{$H+}
{$modeswitch advancedrecords}

interface

uses
  Math,
  SysUtils;

type
  TTriBoolState = (tbFalse = -1, tbIndeterminate = 0, tbTrue = 1);

  { TTriBool }

  TTriBool = record
  private
    FState: TTriBoolState;
  public
    procedure Create(AState: TTriBoolState); inline;
    function ToString: string;

    function State: TTriBoolState;

    class operator := (AState: TTriBoolState): TTriBool;
    class operator := (ATriBool: TTriBool): TTriBoolState;
    class operator := (ABool: boolean): TTriBool;
    class operator := (ATriBool: TTriBool): boolean;

    class operator =(A, B: TTriBool): boolean;
    class operator =(A: TTriBool; B: boolean): boolean;
    class operator =(A: boolean; B: TTriBool): boolean;

    class operator and(A, B: TTriBool): TTriBool;
    class operator and(A: TTriBool; B: boolean): TTriBool;
    class operator and(A: boolean; B: TTriBool): TTriBool;

    class operator or(A, B: TTriBool): TTriBool;
    class operator or(A: TTriBool; B: boolean): TTriBool;
    class operator or(A: boolean; B: TTriBool): TTriBool;

    class operator not(A: TTriBool): TTriBool;

    class operator xor(A, B: TTriBool): TTriBool;
    class operator xor(A: TTriBool; B: boolean): TTriBool;
    class operator xor(A: boolean; B: TTriBool): TTriBool;
  end;

implementation


{ TTriBool }

procedure TTriBool.Create(AState: TTriBoolState);
begin
  FState := AState;
end;

function TTriBool.ToString: string;
begin
  case FState of
    tbTrue:
      Result := 'True';
    tbFalse:
      Result := 'False';
    tbIndeterminate:
      Result := 'Undefined';
  end;
end;

function TTriBool.State: TTriBoolState;
begin
  Result := FState;
end;

class operator TTriBool.:=(AState: TTriBoolState): TTriBool;
begin
  Result.FState := AState;
end;

class operator TTriBool.:=(ATriBool: TTriBool): TTriBoolState;
begin
  Result := ATriBool.FState;
end;

class operator TTriBool.:=(ABool: boolean): TTriBool;
begin
  case ABool of
    True:
      Result.FState := tbTrue;
    False:
      Result.FState := tbFalse;
  end;
end;

class operator TTriBool.:=(ATriBool: TTriBool): boolean;
begin
  case ATriBool.FState of
    tbTrue:
      Result := True;
    else
      Result := False;
  end;
end;

class operator TTriBool.=(A, B: TTriBool): boolean;
begin
  Result := (A.FState = B.FState);
end;

class operator TTriBool.=(A: TTriBool; B: boolean): boolean;
begin
  if B then
    Result := (A.FState = tbTrue)
  else
    Result := (A.FState = tbFalse);
end;

class operator TTriBool.=(A: boolean; B: TTriBool): boolean;
begin
  Result := (B = A);
end;

class operator TTriBool.and(A, B: TTriBool): TTriBool;
begin
  Result.FState := TTriBoolState(Min(Ord(A.FState), Ord(B.FState)));
end;

class operator TTriBool.and(A: TTriBool; B: boolean): TTriBool;
begin
  Result := A and TTriBool(B);
end;

class operator TTriBool.and(A: boolean; B: TTriBool): TTriBool;
begin
  Result := TTriBool(A) and B;
end;

class operator TTriBool.or(A, B: TTriBool): TTriBool;
begin
  Result.FState := TTriBoolState(Max(Ord(A.FState), Ord(B.FState)));
end;

class operator TTriBool.or(A: TTriBool; B: boolean): TTriBool;
begin
  Result := A or TTriBool(B);
end;

class operator TTriBool.or(A: boolean; B: TTriBool): TTriBool;
begin
  Result := TTriBool(A) or B;
end;

class operator TTriBool.not(A: TTriBool): TTriBool;
begin
  Result.FState := TTriBoolState(-Ord(A.FState));
end;

class operator TTriBool.xor(A, B: TTriBool): TTriBool;
var
  AOrd, BOrd: integer;
begin
  AOrd := Ord(A.FState);
  BOrd := Ord(B.FState);
  Result.FState := TTriBoolState(Min(Max(AOrd, BOrd), -Min(AOrd, BOrd)));
end;

class operator TTriBool.xor(A: TTriBool; B: boolean): TTriBool;
begin
  Result := A xor TTriBool(B);
end;

class operator TTriBool.xor(A: boolean; B: TTriBool): TTriBool;
begin
  Result := TTriBool(A) xor B;
end;

end.
