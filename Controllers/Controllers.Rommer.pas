unit Controllers.Rommer;

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
    THorse.Get('/Rommer', Listar);
    THorse.Post('/Rommer', Inserir);
    THorse.Put('/Rommer', Editar);
    THorse.Delete('/Rommer', Excluir);
end;

procedure Listar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var dmlamapa : Tdmlamapa;
begin
try
dmlamapa := Tdmlamapa.Create(Nil);
//Res.Send(dmlamapa.listarRommer).Status(200);
finally
FreeAndNil(dmlamapa);
end;
end;

procedure Inserir(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
    Res.Send('Aqui vou inserir Rommer').Status(201);
end;

procedure Editar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
    Res.Send('Aqui vou editar os Rommer').Status(200);
end;

procedure Excluir(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
    Res.Send('Aqui vou excluir os Rommer').Status(200);
end;
end.
