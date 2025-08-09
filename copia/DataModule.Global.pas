unit DataModule.Global;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, DataSet.Serialize.Config, DataSet.Serialize, System.JSON,
  FireDAC.DApt;

type
  TDm = class(TDataModule)
    Conn: TFDConnection;
    procedure DataModuleCreate(Sender: TObject);
    procedure ConnBeforeConnect(Sender: TObject);
  private
    procedure CarregarConfigDB(Connection: TFDConnection);
    { Private declarations }
  public
    function ListarConfig: TJsonObject;
    function ListarCardapios: TJsonArray;
    function ListarPedidos: TJsonArray;
    function InserirPedido(id_usuario: integer;
                           endereco, fone: string;
                           vl_subtotal, vl_entrega, vl_total: double;
                           itens: TJSONArray): TJsonObject;
  end;

var
  Dm: TDm;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDm.CarregarConfigDB(Connection: TFDConnection);
begin
    Connection.DriverName := 'SQLite';

    with Connection.Params do
    begin
        Clear;
        Add('DriverID=SQLite');

        // Mudar para sua pasta!!!!!!!!
        Add('Database=D:\99Coders\Posts\400 - Criando o servidor em Horse de um cardápio digital 2\Fontes\DB\banco.db');

        Add('User_Name=');
        Add('Password=');
        Add('Port=');
        Add('Server=');
        Add('Protocol=');
        Add('LockingMode=Normal');
    end;
end;

procedure TDm.ConnBeforeConnect(Sender: TObject);
begin
    CarregarConfigDB(Conn);
end;

procedure TDm.DataModuleCreate(Sender: TObject);
begin
    TDataSetSerializeConfig.GetInstance.CaseNameDefinition := cndLower;
    TDataSetSerializeConfig.GetInstance.Import.DecimalSeparator := '.';

    Conn.Connected := true;
end;

function TDm.ListarConfig: TJsonObject;
var
    qry: TFDQuery;
begin
    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Conn;

        qry.SQL.Add('select * from config');
        qry.Active := true;

        Result := qry.ToJSONObject; //  {"vl_entrega": 3}

    finally
        FreeAndNil(qry);
    end;
end;

function TDm.ListarCardapios: TJsonArray;
var
    qry: TFDQuery;
begin
    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Conn;

        qry.SQL.Add('select p.*, c.categoria');
        qry.SQL.Add('from produto p');
        qry.SQL.Add('join produto_categoria c on (c.id_categoria = p.id_categoria)');
        qry.SQL.Add('order by c.ordem, p.ordem');
        qry.Active := true;

        Result := qry.ToJSONArray;

    finally
        FreeAndNil(qry);
    end;
end;

function TDm.ListarPedidos: TJsonArray;
var
    qry: TFDQuery;
    i: integer;
    ped: TJSONObject;
begin
    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Conn;

        qry.SQL.Add('select id_pedido, id_usuario, endereco, fone, vl_subtotal, vl_entrega,');
        qry.SQL.Add('vl_total, status, strftime(''%d/%m/%Y %H:%M'', dt_pedido) as dt_pedido');
        qry.SQL.Add('from pedido');
        qry.SQL.Add('order by id_pedido desc');
        qry.Active := true;

        Result := qry.ToJSONArray;

        // Acrescentar os itens...
        for i := 0 to Result.Size - 1 do
        begin
            ped := TJSONObject(Result[i]);

            qry.Active := false;
            qry.SQL.Clear;
            qry.SQL.Add('select id_produto, qtd, vl_unitario, vl_total');
            qry.SQL.Add('from pedido_item');
            qry.SQL.Add('where id_pedido = :id_pedido');
            qry.SQL.Add('order by id_item');
            qry.ParamByName('id_pedido').Value := ped.GetValue<integer>('id_pedido', 0);
            qry.Active := true;

            ped.AddPair('itens', qry.ToJSONArray);
        end;

    finally
        FreeAndNil(qry);
    end;
end;


function TDm.InserirPedido(id_usuario: integer;
                           endereco, fone: string;
                           vl_subtotal, vl_entrega, vl_total: double;
                           itens: TJSONArray): TJsonObject;
var
    qry: TFDQuery;
    i, id_pedido: integer;
    item: TJSONObject;
begin
    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Conn;

        qry.SQL.Add('insert into pedido(id_usuario, endereco, fone, vl_subtotal, ');
        qry.SQL.Add('vl_entrega, vl_total, dt_pedido, status)');

        qry.SQL.Add('values(:id_usuario, :endereco, :fone, :vl_subtotal, ');
        qry.SQL.Add(':vl_entrega, :vl_total, :dt_pedido, :status);');
        qry.SQL.Add('select last_insert_rowid() as id_pedido ');

        qry.ParamByName('id_usuario').Value := id_usuario;
        qry.ParamByName('endereco').Value := endereco;
        qry.ParamByName('fone').Value := fone;
        qry.ParamByName('vl_subtotal').Value := vl_subtotal;
        qry.ParamByName('vl_entrega').Value := vl_entrega;
        qry.ParamByName('vl_total').Value := vl_total;
        qry.ParamByName('dt_pedido').Value := FormatDateTime('yyyy-mm-dd HH:nn:ss', now);
        qry.ParamByName('status').Value :=  'A';
        qry.Active := true;
        Result := qry.ToJSONObject;

        // Tratamento dos itens...
        id_pedido := qry.FieldByName('id_pedido').AsInteger;

        for i := 0 to itens.Size - 1 do
        begin
            item := TJsonObject(itens[i]);

            qry.Active := false;
            qry.SQL.Clear;
            qry.SQL.Add('insert into pedido_item(id_pedido, id_produto, qtd, vl_unitario, vl_total)');
            qry.SQL.Add('values(:id_pedido, :id_produto, :qtd, :vl_unitario, :vl_total)');

            qry.ParamByName('id_pedido').Value := id_pedido;
            qry.ParamByName('id_produto').Value := item.GetValue<integer>('id_produto', 0);
            qry.ParamByName('qtd').Value := item.GetValue<double>('qtd', 0);
            qry.ParamByName('vl_unitario').Value := item.GetValue<double>('vl_unitario', 0);
            qry.ParamByName('vl_total').Value := item.GetValue<double>('vl_total', 0);

            qry.ExecSQL;

        end;

    finally
        FreeAndNil(qry);
    end;
end;

end.
