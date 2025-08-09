unit Controllers.Empresa;

interface

uses
  Horse, System.SysUtils, System.JSON, Horse.Jhonson,
  DataModule.Global;

procedure RegistrarRotas;
procedure Listar (Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Inserir(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Editar (Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Excluir(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure RegistrarRotas;
begin
  THorse.Get   ('/empresa',            Listar);
  THorse.Post  ('/empresa',            Inserir);
  THorse.Put   ('/empresa/:codigo',    Editar);   // código na rota
  THorse.Delete('/empresa/:codigo',    Excluir);
end;

procedure Listar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  dm : TDmlamapa;
  arr: TJSONArray;
begin
  dm := TDmlamapa.Create(nil);
  try
    arr := dm.EmpresaListar;                   // <-- precisa existir no DataModule
    try
      Res.Send<TJSONArray>(arr).Status(200);
    finally
      arr.Free;
    end;
  finally
    dm.Free;
  end;
end;

procedure Inserir(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  dm: TDmlamapa;
  body, ret: TJSONObject;
  codigo: Integer;
  nome,endereco,cgc,bairro,cidade,estado: string;
begin
  dm := TDmlamapa.Create(nil);
  try
    body     := Req.Body<TJSONObject>;
    codigo   := body.GetValue<Integer>('codigo',0);
    nome     := body.GetValue<string>('nome','');
    endereco := body.GetValue<string>('endereco','');
    cgc      := body.GetValue<string>('cgc','');
    bairro   := body.GetValue<string>('bairro','');
    cidade   := body.GetValue<string>('cidade','');
    estado   := body.GetValue<string>('estado','');

    ret := dm.EmpresaInserir(codigo, nome, endereco, cgc, bairro, cidade, estado);
    try
      Res.Send<TJSONObject>(ret).Status(201);
    finally
      ret.Free;
    end;
  finally
    dm.Free;
  end;
end;

procedure Editar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  dm: TDmlamapa;
  body, ret: TJSONObject;
  codigo: Integer;
  nome,endereco,cgc,bairro,cidade,estado: string;
begin
  dm := TDmlamapa.Create(nil);
  try
    codigo   := Req.Params['codigo'].ToInteger;    // da URL
    body     := Req.Body<TJSONObject>;
    nome     := body.GetValue<string>('nome','');
    endereco := body.GetValue<string>('endereco','');
    cgc      := body.GetValue<string>('cgc','');
    bairro   := body.GetValue<string>('bairro','');
    cidade   := body.GetValue<string>('cidade','');
    estado   := body.GetValue<string>('estado','');

    ret := dm.EmpresaEditar(codigo, nome, endereco, cgc, bairro, cidade, estado);
    try
      Res.Send<TJSONObject>(ret).Status(200);
    finally
      ret.Free;
    end;
  finally
    dm.Free;
  end;
end;

procedure Excluir(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  dm: TDmlamapa;
  ret: TJSONObject;
  codigo: Integer;
begin
  dm := TDmlamapa.Create(nil);
  try
    codigo := Req.Params['codigo'].ToInteger;
    ret := dm.EmpresaExcluir(codigo);
    try
      Res.Send<TJSONObject>(ret).Status(200); // ou .Status(204) e não envia body
    finally
      ret.Free;
    end;
  finally
    dm.Free;
  end;
end;

end.

