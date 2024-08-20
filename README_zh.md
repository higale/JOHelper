# TJSONObject类助手
- v1.0.10
- 2024-08-19  by gale
- ++https://github.com/higale/JOHelper++

---

## 示例:
    var
      jo: TJO; // or TJSONObject
      f: Extended;
    begin
      jo := TJO.Create;
      try
        jo['title'] := '🍎eng🍎中文🍎'; // 或 jo.S['title'] := '🍎eng🍎中文🍎';
        jo['a.arr[3].b'] := 0.3;        // 或 jo.F['a.arr[3].b'] := 0.3;
        jo['good'] := False;            // 或 jo.B['good'] := False;
        f := jo['a.arr[3].b'];          // 或 f := jo.F['a.arr[3].b'];
        Memo1.Text := jo.Format;
        Memo1.Lines.Add(f.ToString);
      finally
        jo.free;
      end;
    end;

---

## 方法和属性：
- V[path]   - 缺省属性，获取或设置Json数据，支持常用数据类型
- S[path]   - 字符串，获取失败时返回''
- I[path]   - 整数，获取失败时返回0
- I64[path] - 64位整数，获取失败时返回0
- F[path]   - 浮点数，使用Extended，获取失败时返回0.0
- B[path]   - 布尔值，获取失败时返回False
- JA[path]  - JSONArray，获取失败时返回nil
- FA[path]  - JSONArray，获取失败时自动创建
- JO[path]  - JSONObject，获取失败时返回nil
- FO[path]  - JSONObject，获取失败时自动创建

*获取失败：不存在或类型不匹配，都定义为获取失败*

- Clear          清空
- LoadFromString 从字符串加载数据
- LoadFromFile   从文件加载数据
- SaveToFile     保存到文件

- class FromString 从字符串创建实例
- class FromFile   从文件创建实例

---

## 注意:
  V[path]返回一个TJSONAuto类型的数据，如果为空，且使用ToJO(True) 或 ToJA(True) 方法时，
  会自动创建相应实例，这时，和直接使用FO[path]或FA[path]是等效的

---
