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
  System.JSON,
  Horse, Horse.Jhonson, Horse.CORS;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
  // Middlewares
  THorse.Use(Jhonson());
  THorse.Use(CORS);

  THorse.Get('/ping',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    begin
      Res.Send('pong');
    end);

  THorse.Get('/hello/:nome',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    begin
      Res.Send('Olá, ' + Req.Params['nome']);
    end);

  THorse.Post('/echo',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      Body: TJSONObject;
    begin
      Body := Req.Body<TJSONObject>;
      try
        Res.Send<TJSONObject>(Body);
      finally
        Body.Free;
      end;
    end);

  THorse.Put('/items/:id',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      Body: TJSONObject;
    begin
      Body := Req.Body<TJSONObject>;
      try
        Body.AddPair('id', Req.Params['id']);
        Res.Send<TJSONObject>(Body);
      finally
        Body.Free;
      end;
    end);

  THorse.Delete('/items/:id',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      OutJson: TJSONObject;
    begin
      OutJson := TJSONObject.Create;
      try
        OutJson.AddPair('id', Req.Params['id']);
        OutJson.AddPair('deleted', TJSONBool.Create(True));
        Res.Send<TJSONObject>(OutJson);
      finally
        OutJson.Free;
      end;
    end);

  Label1.Caption := 'Iniciando servidor...';

  // Sobe o servidor sem travar a UI
  TThread.CreateAnonymousThread(
    procedure
    begin
      THorse.Listen(3000,
        procedure
        begin
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
