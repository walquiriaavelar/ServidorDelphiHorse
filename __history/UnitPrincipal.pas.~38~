unit UnitPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.StdCtrls;

type
  TFrmPrincipal = class(TForm)
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}

uses
  System.Threading,
  Horse, Horse.Jhonson, Horse.CORS,
  Controllers.Tormad, Controllers.Madqua, Controllers.Madrrr,
  Controllers.Torlan, Controllers.Senhas, Controllers.Romporto,
  Controllers.Rommer, Controllers.Produtos, Controllers.Empresa;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
  // Middlewares
  THorse.Use(Jhonson());
  THorse.Use(CORS);

  // Health-check
  THorse.Get('/ping',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    begin
      Res.Send('pong');
    end);

  // Rotas
  Controllers.Empresa.RegistrarRotas;
  Controllers.Tormad.RegistrarRotas;
  Controllers.Madqua.RegistrarRotas;
  Controllers.Madrrr.RegistrarRotas;
  Controllers.Torlan.RegistrarRotas;
  Controllers.Romporto.RegistrarRotas;
  Controllers.Rommer.RegistrarRotas;
  Controllers.Produtos.RegistrarRotas;
  Controllers.Senhas.RegistrarRotas;

  Label1.Caption := 'Iniciando servidor...';

  // Sobe o servidor sem travar a UI (apenas UM Listen)
  TThread.CreateAnonymousThread(
    procedure
    begin
      THorse.Listen(3000,
        procedure
        begin
          // executa quando o servidor começou a ouvir
          TThread.Synchronize(nil,
            procedure
            begin
              Label1.Caption := 'Servidor rodando na porta ' + THorse.Port.ToString;
            end);
        end);
    end
  ).Start;
end;

end.

