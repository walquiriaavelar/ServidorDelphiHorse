unit Controllers.Madqua;

interface

uses Horse;

procedure RegistrarRotas;

implementation

uses
  System.SysUtils, System.JSON, Horse.Jhonson,
  DataModule.Global;  // <- importa o TDmlamapa

procedure RegistrarRotas;
begin
  THorse.Post('/madqua',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      dm: TDmlamapa;
      body: TJSONObject;
      quacod: Integer;
      quanom, quares: string;
      outJson: TJSONObject;
    begin
      dm := TDmlamapa.Create(nil);
      try
        body := Req.Body<TJSONObject>;
        quacod := body.GetValue<Integer>('quacod', 0);
        quanom := body.GetValue<string>('quanom', '');
        quares := body.GetValue<string>('quares', '');

        outJson := dm.madquaInserir(quacod, quanom, quares);
        try
          Res.Send<TJSONObject>(outJson).Status(201);
        finally
          outJson.Free;
        end;
      except
        on E: Exception do
          Res.Send('Ocorreu um erro: ' + E.Message).Status(500);
      end;
      dm.Free;
    end);

  THorse.Put('/madqua/:quacod',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      dm: TDmlamapa;
      body: TJSONObject;
      quacod: Integer;
      quanom, quares: string;
      outJson: TJSONObject;
    begin
      dm := TDmlamapa.Create(nil);
      try
        body := Req.Body<TJSONObject>;
        quacod := Req.Params.Items['quacod'].ToInteger;
        quanom := body.GetValue<string>('quanom', '');
        quares := body.GetValue<string>('quares', '');

        outJson := dm.madquaEditar(quacod, quanom, quares);
        try
          Res.Send<TJSONObject>(outJson);
        finally
          outJson.Free;
        end;
      finally
        dm.Free;
      end;
    end);

  THorse.Delete('/madqua/:quacod',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      dm: TDmlamapa;
      quacod: Integer;
      outJson: TJSONObject;
    begin
      dm := TDmlamapa.Create(nil);
      try
        quacod := Req.Params.Items['quacod'].ToInteger;
        outJson := dm.madquaExcluir(quacod);
        try
          Res.Send<TJSONObject>(outJson).Status(204);
        finally
          outJson.Free;
        end;
      finally
        dm.Free;
      end;
    end);
end;

end.

