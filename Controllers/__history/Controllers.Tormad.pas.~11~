unit Controllers.Tormad;

interface
uses Horse,
     System.SysUtils,
     System.JSON,
     DataModule.Global;

procedure RegistrarRotas;
procedure Listar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Inserir(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Editar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure Excluir(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure RegistrarRotas;
begin
    THorse.Get('/Tormad', Listar);
    THorse.Post('/Tormad', Inserir);
    THorse.Put('/Tormad', Editar);
    THorse.Delete('/Tormad', Excluir);
end;

procedure Listar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var dmlamapa : Tdmlamapa;
begin
try
dmlamapa := Tdmlamapa.Create(Nil);
//Res.Send(dmlamapa.listarTormad).Status(200);
finally
FreeAndNil(dmlamapa);
end;
end;

procedure Inserir(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
    Res.Send('Aqui vou inserir Tormad').Status(201);
end;

procedure Editar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
    Res.Send('Aqui vou editar os Tormad').Status(200);
end;

procedure Excluir(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
    Res.Send('Aqui vou excluir os Tormad').Status(200);
end;
end.
