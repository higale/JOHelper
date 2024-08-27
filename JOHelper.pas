{
# System.JSON.TJSONObject class helper
- v1.0.11
- 2024-08-27  by gale
- https://github.com/higale/JOHelper

## Example:
    var
      jo: TJO; // or TJSONObject
      fTemp: Extended;
    begin
      jo := TJO.Create;
      try
        jo['title'] := 'hello world'; // or jo.S['title'] := 'hello world';
        jo['a.b[3].c'] := 0.3;        // or jo.F['a.arr[3].b'] := 0.3;
        jo['good'] := False;          // or jo.B['good'] := False;
        Memo1.Text := jo.Format;

        fTemp := jo['a.b[3].c'];
        Memo1.Lines.Add(fTemp.ToString);

        fTemp := jo['a1'];
        Memo1.Lines.Add(fTemp.ToString);

        Memo1.Lines.Add(jo['a2'].ToFloat(-1).ToString);
        Memo1.Lines.Add(jo['a3'].ToStr('a3 not exist'));
        jo.SaveToFile('test.json');
      finally
        jo.free;
      end;
    end;

## Methods and Properties:
- V[path]   - Default property, get or set Json data, supports common data types
- S[path]   - String, returns '' when fetching fails
- I[path]   - Integer, returns 0 when fetching fails
- I64[path] - 64-bit integer, returns 0 when fetching fails
- F[path]   - Floating-point number, using Extended, returns 0.0 when fetching fails
- B[path]   - Boolean, returns False when fetching fails
- JA[path]  - JSONArray, returns nil when fetching fails
- FA[path]  - JSONArray, automatically created when fetching fails
- JO[path]  - JSONObject, returns nil when fetching fails
- FO[path]  - JSONObject, automatically created when fetching fails

*Fetch failure: Non-existent or type mismatch is defined as fetch failure*

- Clear          - Clear data
- LoadFromString - Load data from string
- LoadFromFile   - Load data from file
- SaveToFile     - Save to file

class Methods
- FromString - Create instance from string
- FromFile   - Create instance from file

## TAutoJSONValue
JO[path](or JO.V[path]) return a data of type TAutoJSONValue. Call the following method
to change the default value returned when Fetch failure:
- ToStr   - Convert to string, default is ''
- ToInt   - Convert to integer, default is 0
- ToInt64 - Convert to int64, default is 0
- ToFloat - Convert to float(Extended), default is 0.0
- ToBool  - Convert to boolean, default is false
- ToJA    - Convert to TJSONArray, default is nil
- ToJO    - Convert to TJSONObject, default is nil

If it is empty and the ToJO(True) or ToJA(True) method is called, the corresponding
instance will be automatically created. At this time, it is equivalent to directly
using FO[path] or FA[path]
}
unit JOHelper;

interface

uses
  System.IOUtils, System.Classes, System.SysUtils, System.JSON, System.Generics.Collections;

type
  { Define alias, so you don't need to uses System.JSON, just uses this unit }
  TJO = TJSONObject;
  TJA = TJSONArray;
  TJV = TJSONValue;

  { json value automatic conversion }
  TAutoJSONValue = record
  private
    FJSONValue: TJSONValue;
    FRoot: TJSONObject;
    FPath: string;
  public
    property JSONValue: TJSONValue read FJSONValue;
    property Root: TJSONObject read FRoot;
    property Path: string read FPath;
  public
    function Clear: TAutoJSONValue;
    function ToStr(const ADefault: string = ''): string;
    class operator Implicit(const Value: string): TAutoJSONValue;
    class operator Implicit(const Value: TAutoJSONValue): string;
    function ToInt(ADefault: Integer = 0): Integer;
    class operator Implicit(Value: Integer): TAutoJSONValue;
    class operator Implicit(const Value: TAutoJSONValue): Integer;
    function ToInt64(ADefault: Int64 = 0): Int64;
    class operator Implicit(Value: Int64): TAutoJSONValue;
    class operator Implicit(const Value: TAutoJSONValue): Int64;
    function ToFloat(ADefault: Extended = 0.0): Extended;
    class operator Implicit(Value: Extended): TAutoJSONValue;
    class operator Implicit(const Value: TAutoJSONValue): Extended;
    function ToBool(ADefault: Boolean = False): Boolean;
    class operator Implicit(Value: Boolean): TAutoJSONValue;
    class operator Implicit(const Value: TAutoJSONValue): Boolean;
    /// <summary>to JSONObject value, if failed and AAutoCreate is true, Create a new TJSONArray Instance to owner</summary>
    function ToJA(AAutoCreate: Boolean = False): TJSONArray;
    class operator Implicit(const Value: TJSONArray): TAutoJSONValue;
    class operator Implicit(const Value: TAutoJSONValue): TJSONArray;
    /// <summary>to JSONObject value, if failed and AAutoCreate is true, Create a new JSONObject Instance to owner</summary>
    function ToJO(AAutoCreate: Boolean = False): TJSONObject;
    class operator Implicit(const Value: TJSONObject): TAutoJSONValue;
    class operator Implicit(const Value: TAutoJSONValue): TJSONObject;
  end;

  { TJSONObject class helper }
  TJSONObjectHelper = class helper for TJSONObject
  private
    function GetOrCreate<T: TJSONValue>(AName: string): T;
    function GetValue<T>(const APath: string; const ADefaultValue: T): T;
    procedure SetValue(const APath: string; const AValue: TJSONValue);
    function GetV(const APath: string): TAutoJSONValue;
    procedure SetV(const APath: string; const AValue: TAutoJSONValue);
    function GetS(const APath: string): string;
    procedure SetS(const APath: string; const AValue: string);
    function GetI(const APath: string): Integer;
    procedure SetI(const APath: string; AValue: Integer);
    function GetI64(const APath: string): Int64;
    procedure SetI64(const APath: string; AValue: Int64);
    function GetF(const APath: string): Extended;
    procedure SetF(const APath: string; AValue: Extended);
    function GetB(const APath: string): Boolean;
    procedure SetB(const APath: string; AValue: Boolean);
    function GetJA(const APath: string): TJSONArray;
    procedure SetJA(const APath: string; const AValue: TJSONArray);
    function GetJO(const APath: string): TJSONObject;
    procedure SetJO(const APath: string; const AValue: TJSONObject);
    function ForceObject(const APath: string): TJSONObject;
    function ForceArray(const APath: string): TJSONArray;
  public
    /// <summary> auto value, return default value of TJSONAuto if it does not exist </summary>
    property V[const APath: string]: TAutoJSONValue read GetV write SetV; default;
    /// <summary> string, return '' if it does not exist </summary>
    property S[const APath: string]: string read GetS write SetS;
    /// <summary> Integer, return 0 if it does not exist </summary>
    property I[const APath: string]: Integer read GetI write SetI;
    /// <summary> Int64, return 0 if it does not exist </summary>
    property I64[const APath: string]: Int64 read GetI64 write SetI64;
    /// <summary> Float(Extended), return 0.0 if it does not exist </summary>
    property F[const APath: string]: Extended read GetF write SetF;
    /// <summary> Boolean, return false if it does not exist </summary>
    property B[const APath: string]: Boolean read GetB write SetB;
    /// <summary> Array, return nil if it does not exist </summary>
    property JA[const APath: string]: TJSONArray read GetJA write SetJA;
    /// <summary> Array, auto create if it does not exist </summary>
    property FA[const APath: string]: TJSONArray read ForceArray;
    /// <summary> Object, return nil if it does not exist </summary>
    property JO[const APath: string]: TJSONObject read GetJO write SetJO;
    /// <summary> Object, auto create if it does not exist </summary>
    property FO[const APath: string]: TJSONObject read ForceObject;
  public
    /// <summary> Clear all data </summary>
    procedure Clear;
    /// <summary> Parse JSONObject from string. The original data will be cleared </summary>
    procedure LoadFromString(const AData: string; UseBool: Boolean = False; RaiseExc: Boolean = False);
    /// <summary> Parse JSONObject from a file. The original data will be cleared </summary>
    procedure LoadFromFile(const AFileName: string; UseBool: Boolean = False; RaiseExc: Boolean = False);
    /// <summary> Save json string to a file </summary>
    procedure SaveToFile(const AFileName: string; Indentation: Integer = 4; AWriteBOM: Boolean = False; ATrailingLineBreak: Boolean = False);
    /// <summary> Creating an instance from a string </summary>
    class function FromString(const AData: string; UseBool: Boolean = False; RaiseExc: Boolean = False): TJSONObject;
    /// <summary> Creating an instance from a string </summary>
    class function FromFile(const AFileName: string; UseBool: Boolean = False; RaiseExc: Boolean = False): TJSONObject;
  end;

implementation

type
  TJSONArrayHelper = class helper for TJSONArray
  private
    procedure Insert(const AIndex: Integer; const AValue: TJSONValue);
    procedure full<T: TJSONValue>(ACount: Integer);
    function GetOrCreate<T: TJSONValue>(ACount: Integer): T;
  end;

procedure TJSONArrayHelper.Insert(const AIndex: Integer; const AValue: TJSONValue);
begin
  With self do
    FElements.Insert(AIndex, AValue);
end;

procedure TJSONArrayHelper.full<T>(ACount: Integer);
begin
  for var j := Count to ACount do
    AddElement(T.Create);
end;

function TJSONArrayHelper.GetOrCreate<T>(ACount: Integer): T;
var
  jvTemp: TJSONValue;
begin
  full<TJSONNull>(ACount);
  jvTemp := Items[ACount];
  if jvTemp is T then
  begin
    Result := jvTemp as T;
  end
  else // not T type
  begin
    jvTemp := Remove(ACount);
    if jvTemp.Owned then
      FreeAndNil(jvTemp);
    jvTemp := T.Create;
    Insert(ACount, jvTemp);
    Result := jvTemp as T;
  end;
end;

{ === TAutoJSONValue === }

function TAutoJSONValue.Clear: TAutoJSONValue;
begin
  FJSONValue := nil;
  FRoot := nil;
  FPath := '';
  Result := self;
end;

function TAutoJSONValue.ToStr(const ADefault: string): string;
begin
  if FJSONValue = nil then
    Exit(ADefault);
  try
    Result := FJSONValue.AsType<string>;
  except
    Result := ADefault;
  end;
end;

class operator TAutoJSONValue.Implicit(const Value: string): TAutoJSONValue;
begin
  Result.FJSONValue := TJSONString.Create(Value);
end;

class operator TAutoJSONValue.Implicit(const Value: TAutoJSONValue): string;
begin
  Result := Value.ToStr('');
end;

function TAutoJSONValue.ToInt(ADefault: Integer): Integer;
begin
  if FJSONValue = nil then
    Exit(ADefault);
  try
    Result := FJSONValue.AsType<Integer>;
  except
    Result := ADefault;
  end;
end;

class operator TAutoJSONValue.Implicit(Value: Integer): TAutoJSONValue;
begin
  Result.FJSONValue := TJSONNumber.Create(Value);
end;

class operator TAutoJSONValue.Implicit(const Value: TAutoJSONValue): Integer;
begin
  Result := Value.ToInt;
end;

function TAutoJSONValue.ToInt64(ADefault: Int64): Int64;
begin
  if FJSONValue = nil then
    Exit(ADefault);
  try
    Result := FJSONValue.AsType<Int64>;
  except
    Result := ADefault;
  end;
end;

class operator TAutoJSONValue.Implicit(Value: Int64): TAutoJSONValue;
begin
  Result.FJSONValue := TJSONNumber.Create(Value);
end;

class operator TAutoJSONValue.Implicit(const Value: TAutoJSONValue): Int64;
begin
  Result := Value.ToInt64;
end;

function TAutoJSONValue.ToFloat(ADefault: Extended): Extended;
begin
  if FJSONValue = nil then
    Exit(ADefault);
  try
    Result := FJSONValue.AsType<Extended>;
  except
    Result := ADefault;
  end;
end;

class operator TAutoJSONValue.Implicit(Value: Extended): TAutoJSONValue;
begin
  Result.FJSONValue := TJSONNumber.Create(Value);
end;

class operator TAutoJSONValue.Implicit(const Value: TAutoJSONValue): Extended;
begin
  Result := Value.ToFloat;
end;

function TAutoJSONValue.ToBool(ADefault: Boolean): Boolean;
begin
  if FJSONValue = nil then
    Exit(ADefault);
  try
    Result := FJSONValue.AsType<Boolean>;
  except
    Result := ADefault;
  end;
end;

class operator TAutoJSONValue.Implicit(Value: Boolean): TAutoJSONValue;
begin
  Result.FJSONValue := TJSONBool.Create(Value);
end;

class operator TAutoJSONValue.Implicit(const Value: TAutoJSONValue): Boolean;
begin
  Result := Value.ToBool;
end;

function TAutoJSONValue.ToJA(AAutoCreate: Boolean): TJSONArray;
begin
  Result := nil;
  if FJSONValue <> nil then
  begin
    try
      Result := FJSONValue.AsType<TJSONArray>;
    except
    end;
  end;
  if (Result = nil) and AAutoCreate then
  begin
    FJSONValue := TJSONArray.Create;
    FRoot[FPath] := FJSONValue As TJSONArray;
    Result := FJSONValue As TJSONArray;
  end;
end;

class operator TAutoJSONValue.Implicit(const Value: TJSONArray): TAutoJSONValue;
begin
  Result.FJSONValue := Value;
end;

class operator TAutoJSONValue.Implicit(const Value: TAutoJSONValue): TJSONArray;
begin
  Result := Value.ToJA;
end;

function TAutoJSONValue.ToJO(AAutoCreate: Boolean): TJSONObject;
begin
  Result := nil;
  if FJSONValue <> nil then
  begin
    try
      Result := FJSONValue.AsType<TJSONObject>;
    except
    end;
  end;
  if (Result = nil) and AAutoCreate and (FRoot <> nil) and (FPath <> '') then
  begin
    FJSONValue := TJSONObject.Create;
    FRoot[FPath] := FJSONValue As TJSONObject;
    Result := FJSONValue As TJSONObject;
  end;
end;

class operator TAutoJSONValue.Implicit(const Value: TJSONObject): TAutoJSONValue;
begin
  Result.FJSONValue := Value;
end;

class operator TAutoJSONValue.Implicit(const Value: TAutoJSONValue): TJSONObject;
begin
  Result := Value.ToJO;
end;

{ === TJSONObjectHelper === }

function TJSONObjectHelper.GetOrCreate<T>(AName: string): T;
var
  jvTemp: TJSONValue;
begin
  jvTemp := FindValue(AName);
  if jvTemp = nil then
  begin
    jvTemp := T.Create;
    AddPair(AName, jvTemp);
    Result := jvTemp as T;
  end
  else if jvTemp is T then
  begin
    Result := jvTemp as T;
  end
  else // not T type
  begin
    jvTemp := T.Create;
    Get(AName).JSONValue := jvTemp;
    Result := jvTemp as T;
  end;
end;

function TJSONObjectHelper.GetValue<T>(const APath: string; const ADefaultValue: T): T;
begin
  if not TryGetValue<T>(APath, Result) then
    Result := ADefaultValue;
end;

procedure TJSONObjectHelper.SetValue(const APath: string; const AValue: TJSONValue);
var
  LParser: TJSONPathParser;
  strName: string;
  jv, jvTemp: TJSONValue;
begin
  try
    if self = nil then
      raise Exception.Create('TJSONObjectHelper.SetValue: JSONObject is nil ');
    if APath = '' then
      raise Exception.Create('TJSONObjectHelper.SetValue: APath = ''''');
    jv := self;
    LParser := TJSONPathParser.Create(APath);
    LParser.NextToken;
    while true do
    begin
      strName := LParser.TokenName;
      LParser.NextToken;
      case LParser.Token of
        TJSONPathParser.TToken.Name:
          begin
            if jv is TJSONObject then
              jv := (jv as TJSONObject).GetOrCreate<TJSONObject>(strName)
            else // TJsonArray
              jv := (jv as TJSONArray).GetOrCreate<TJSONObject>(strName.ToInteger);
          end;
        TJSONPathParser.TToken.ArrayIndex:
          begin
            if jv is TJSONObject then
              jv := (jv as TJSONObject).GetOrCreate<TJSONArray>(strName)
            else // TJsonArray
              jv := (jv as TJSONArray).GetOrCreate<TJSONArray>(strName.ToInteger);
          end;
        TJSONPathParser.TToken.Eof:
          begin
            if jv is TJSONObject then
            begin
              jvTemp := jv.FindValue(strName);
              if jvTemp = nil then
                (jv as TJSONObject).AddPair(strName, AValue)
              else
                (jv as TJSONObject).Get(strName).JSONValue := AValue;
            end
            else // TJsonArray
            begin
              (jv as TJSONArray).full<TJSONNull>(strName.ToInteger);
              jvTemp := (jv as TJSONArray).Remove(strName.ToInteger);
              if jvTemp.Owned then
                FreeAndNil(jvTemp);
              (jv as TJSONArray).Insert(strName.ToInteger, AValue);
            end;
            break;
          end;
      else
        break;
      end;
    end;
  except
    on E: Exception do
    begin
      AValue.Free;
      raise Exception.Create(E.Message);
    end;
  end;
end;

function TJSONObjectHelper.GetV(const APath: string): TAutoJSONValue;
begin
  Result.FRoot := self;
  Result.FPath := APath;
  if not TryGetValue<TJSONValue>(APath, Result.FJSONValue) then
    Result.FJSONValue := nil;
end;

procedure TJSONObjectHelper.SetV(const APath: string; const AValue: TAutoJSONValue);
begin
  SetValue(APath, AValue.FJSONValue);
end;

function TJSONObjectHelper.GetS(const APath: string): string;
begin
  Result := GetValue<string>(APath, '');
end;

procedure TJSONObjectHelper.SetS(const APath: string; const AValue: string);
begin
  SetValue(APath, TJSONString.Create(AValue));
end;

function TJSONObjectHelper.GetI(const APath: string): Integer;
begin
  Result := GetValue<Integer>(APath, 0);
end;

procedure TJSONObjectHelper.SetI(const APath: string; AValue: Integer);
begin
  SetValue(APath, TJSONNumber.Create(AValue));
end;

function TJSONObjectHelper.GetI64(const APath: string): Int64;
begin
  Result := GetValue<Int64>(APath, 0);
end;

procedure TJSONObjectHelper.SetI64(const APath: string; AValue: Int64);
begin
  SetValue(APath, TJSONNumber.Create(AValue));
end;

function TJSONObjectHelper.GetF(const APath: string): Extended;
begin
  Result := GetValue<Extended>(APath, 0.0);
end;

procedure TJSONObjectHelper.SetF(const APath: string; AValue: Extended);
begin
  SetValue(APath, TJSONNumber.Create(AValue));
end;

function TJSONObjectHelper.GetB(const APath: string): Boolean;
begin
  Result := GetValue<Boolean>(APath, False);
end;

procedure TJSONObjectHelper.SetB(const APath: string; AValue: Boolean);
begin
  SetValue(APath, TJSONBool.Create(AValue));
end;

function TJSONObjectHelper.GetJA(const APath: string): TJSONArray;
begin
  Result := GetValue<TJSONArray>(APath, nil);
end;

procedure TJSONObjectHelper.SetJA(const APath: string; const AValue: TJSONArray);
begin
  SetValue(APath, AValue);
end;

function TJSONObjectHelper.GetJO(const APath: string): TJSONObject;
begin
  Result := GetValue<TJSONObject>(APath, nil);
end;

procedure TJSONObjectHelper.SetJO(const APath: string; const AValue: TJSONObject);
begin
  SetValue(APath, AValue);
end;

function TJSONObjectHelper.ForceObject(const APath: string): TJSONObject;
begin
  if not TryGetValue<TJSONObject>(APath, Result) then
  begin
    Result := TJSONObject.Create;
    SetValue(APath, Result);
  end;
end;

function TJSONObjectHelper.ForceArray(const APath: string): TJSONArray;
begin
  if not TryGetValue<TJSONArray>(APath, Result) then
  begin
    Result := TJSONArray.Create;
    SetValue(APath, Result);
  end;
end;

procedure TJSONObjectHelper.Clear;
begin
  with self do
  begin
    for var item in FMembers do
    begin
      if item.Owned then
      begin
        item.Free;
      end;
    end;
    FMembers.Clear;
  end;
end;

procedure TJSONObjectHelper.LoadFromString(const AData: string; UseBool, RaiseExc: Boolean);
var
  joTemp: TJSONObject;
begin
  Clear;
  joTemp := TJSONObject.ParseJSONValue(AData, UseBool, RaiseExc) as TJSONObject;
  try
    if joTemp <> nil then
    begin
      for var I := 0 to joTemp.Count - 1 do
      begin
        self.AddPair(joTemp.pairs[I].Clone as TJSONPair);
      end;
    end;
  finally
    joTemp.Free;
  end;
end;

procedure TJSONObjectHelper.LoadFromFile(const AFileName: string; UseBool: Boolean; RaiseExc: Boolean);
begin
  LoadFromString(TFile.ReadAllText(AFileName, TEncoding.UTF8), UseBool, RaiseExc);
end;

procedure TJSONObjectHelper.SaveToFile(const AFileName: string; Indentation: Integer; AWriteBOM: Boolean; ATrailingLineBreak: Boolean);
var
  strs: TStrings;
begin
  strs := TStringList.Create;
  try
    strs.WriteBOM := AWriteBOM;
    strs.TrailingLineBreak := ATrailingLineBreak;
    if Indentation > 0 then
      strs.Text := Format(Indentation)
    else
      strs.Text := ToString;
    strs.SaveToFile(AFileName, TEncoding.UTF8);
  finally
    strs.Free;
  end;
end;

class function TJSONObjectHelper.FromString(const AData: string; UseBool: Boolean; RaiseExc: Boolean): TJSONObject;
begin
  Result := ParseJSONValue(AData, UseBool, RaiseExc) as TJSONObject;
end;

class function TJSONObjectHelper.FromFile(const AFileName: string; UseBool: Boolean; RaiseExc: Boolean): TJSONObject;
begin
  Result := ParseJSONValue(TFile.ReadAllText(AFileName, TEncoding.UTF8), UseBool, RaiseExc) as TJSONObject;
end;

end.
