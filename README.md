# System.JSON.TJSONObject class helper
- v1.0.10
- 2024-08-19  by gale
- https://github.com/higale/JOHelper

## Example:
    var
      jo: TJO; // or TJSONObject
      f: Extended;
    begin
      jo := TJO.Create;
      try
        jo['title'] := 'hello world'; // or jo.S['title'] := 'hello world';
        jo['a.arr[3].b'] := 0.3;      // or jo.F['a.arr[3].b'] := 0.3;
        jo['good'] := False;          // or jo.B['good'] := False;
        f := jo['a.arr[3].b'];        // or f := jo.F['a.arr[3].b'];
        Memo1.Text := jo.Format;
        Memo1.Lines.Add(f.ToString)
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
- class FromString - Create instance from string
- class FromFile   - Create instance from file

## Note:
  The V[path] returns a data of type TJSONAuto. If it is empty and the ToJO(True) or ToJA(True) method is used,
  the corresponding instance will be automatically created. At this time, it is equivalent to directly using FO[path] or FA[path]

