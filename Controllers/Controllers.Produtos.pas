unit Controllers.Produtos;

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
    THorse.Get('/Produtos', Listar);
    THorse.Post('/Produtos', Inserir);
    THorse.Put('/Produtos', Editar);
    THorse.Delete('/Produtos', Excluir);
end;

procedure Listar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var dmlamapa : Tdmlamapa;
begin
try
dmlamapa := Tdmlamapa.Create(Nil);
//Res.Send(dmlamapa.EmpresaListar).Status(200);
finally
FreeAndNil(dmlamapa);
end;
end;

procedure Inserir(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin

end;

procedure Editar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
    Res.Send('Aqui vou editar os Produtos').Status(200);
end;

procedure Excluir(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
    Res.Send('Aqui vou excluir os Produtos').Status(200);
end;

end.
