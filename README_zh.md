# Delphi TJSONObject类助手
- 版本: v1.0.11
- 日期: 2024-08-27  作者: gale
- https://github.com/higale/JOHelper

## 示例:
    var
      jo: TJO; // 或者 TJSONObject
      fTemp: Extended;
    begin
      jo := TJO.Create;
      try
        jo['title'] := 'hello world'; // 或者 jo.S['title'] := 'hello world';
        jo['a.b[3].c'] := 0.3;        // 或者 jo.F['a.arr[3].b'] := 0.3;
        jo['good'] := False;          // 或者 jo.B['good'] := False;
        Memo1.Text := jo.Format;

        fTemp := jo['a.b[3].c'];
        Memo1.Lines.Add(fTemp.ToString);

        fTemp := jo['a1'];
        Memo1.Lines.Add(fTemp.ToString);

        Memo1.Lines.Add(jo['a2'].ToFloat(-1).ToString);
        Memo1.Lines.Add(jo['a3'].ToStr('a3 not exist'));
        jo.SaveToFile('test.json');
      finally
        jo.Free;
      end;
    end;

## 方法和属性:
- V[path]   - 默认属性，获取或设置 JSON 数据，支持常见数据类型
- S[path]   - 字符串类型，获取失败时返回空字符串 ''
- I[path]   - 整型，获取失败时返回 0
- I64[path] - 64位整型，获取失败时返回 0
- F[path]   - 浮点型，使用 Extended 类型，获取失败时返回 0.0
- B[path]   - 布尔型，获取失败时返回 False
- JA[path]  - JSONArray 类型，获取失败时返回 nil
- FA[path]  - JSONArray 类型，获取失败时自动创建
- JO[path]  - JSONObject 类型，获取失败时返回 nil
- FO[path]  - JSONObject 类型，获取失败时自动创建

*获取失败: 不存在或类型不匹配定义为获取失败*

- Clear          - 清除数据
- LoadFromString - 从字符串加载数据
- LoadFromFile   - 从文件加载数据
- SaveToFile     - 保存到文件

类方法
- FromString - 从字符串创建实例
- FromFile   - 从文件创建实例

## TAutoJSONValue
JO[path](或者 JO.V[path]) 返回一个 TAutoJSONValue 类型的数据。调用以下方法
来改变获取失败时返回的默认值：
- ToStr   - 转换为字符串，默认为 ''
- ToInt   - 转换为整型，默认为 0
- ToInt64 - 转换为 64位整型，默认为 0
- ToFloat - 转换为浮点型(Extended)，默认为 0.0
- ToBool  - 转换为布尔型，默认为 false
- ToJA    - 转换为 TJSONArray 类型，默认为 nil
- ToJO    - 转换为 TJSONObject 类型，默认为 nil

如果为空并且调用了 ToJO(True) 或 ToJA(True) 方法，则会自动创建相应的
实例。此时相当于直接使用 FO[path] 或 FA[path]
