# Delphi TJSONObject class helper
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
