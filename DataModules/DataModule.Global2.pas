unit DataModule.Global;

interface

uses
  System.SysUtils, System.Classes, Data.DB,

  DataSet.Serialize.Config, DataSet.Serialize,
  System.JSON, UniProvider, SQLServerUniProvider, DBAccess, Uni, MemDS;

type
  TDm = class(TDataModule)
    conn: TUniConnection;
    UniTransaction1: TUniTransaction;
    SQLServerUniProvider1: TSQLServerUniProvider;
    Qry: TUniQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure ConnBeforeConnect(Sender: TObject);
  private
    procedure CarregarConfigDB(Connection: TUniConnection);
  public
    function TormadListar(filtro: string): TJsonArray;
    function TormadListarId(id_Tormad: integer): TJsonObject;
    function TormadInserir(nome, endereco, complemento, bairro, cidade,
                            uf: string): TJsonObject;
    function TormadEditar(id_Tormad: integer; nome,endereco, complemento,
                          bairro, cidade, uf: string): TJsonObject;
    function TormadExcluir(id_Tormad: integer): TJsonObject;
    function ProdutoListar(filtro: string): TJsonArray;
    function UsuarioLogin(email, senha: string): TJsonObject;
    function PedidoEditar(id_pedido, id_Tormad: integer;
                          dt_pedido: string;
                          vl_total: double;
                          itens: TJSONArray): TJsonObject;
    function PedidoExcluir(id_pedido: integer): TJsonObject;
    function PedidoInserir(id_usuario, id_Tormad: integer;
                           dt_pedido: string;
                           vl_total: double;
                           itens: TJSONArray): TJsonObject;
    function PedidoListar(filtro: string): TJsonArray;
    function PedidoListarId(id_pedido: integer): TJsonObject;
  end;

var
  Dm: TDm;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDm.CarregarConfigDB(Connection: TUniConnection);
begin
{    Connection.DriverName := 'SQLite';

    with Connection.Params do
    begin
        Clear;
        Add('DriverID=SQLite');

        // Mudar para sua pasta!!!!!!!!
        Add('Database=D:\EasyPedido\FontesServidor\DB\banco.db');

        Add('User_Name=');
        Add('Password=');
        Add('Port=');
        Add('Server=');
        Add('Protocol=');
        Add('LockingMode=Normal');
    end;}
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

function TDm.TormadListar(filtro: string): TJsonArray;
var
    qry: TUNiQuery;
begin
    try
        qry := TUNiQuery.Create(nil);
        qry.Connection := Conn;

        qry.SQL.Add('select *');
        qry.SQL.Add('from Tormad');

        if filtro <> '' then
        begin
            qry.SQL.Add('where nome like :filtro');
            qry.ParamByName('filtro').Value := '%' + filtro + '%';
        end;

        qry.SQL.Add('order by nome');
        qry.Active := true;

        Result := qry.ToJSONArray;

    finally
        FreeAndNil(qry);
    end;
end;

function TDm.TormadListarId(id_Tormad: integer): TJsonObject;
var
    qry: TuNIQuery;
begin
    try
        qry := TuNIQuery.Create(nil);
        qry.Connection := Conn;

        qry.SQL.Add('select *');
        qry.SQL.Add('from Tormad');
        qry.SQL.Add('where id_Tormad = :id_Tormad');
        qry.ParamByName('id_Tormad').Value := id_Tormad;
        qry.Active := true;

        Result := qry.ToJSONObject;

    finally
        FreeAndNil(qry);
    end;
end;

function TDm.TormadInserir(nome, endereco, complemento,
                            bairro, cidade, uf: string): TJsonObject;
var
    qry: TuNIQuery;
begin
    try
        qry := TuNIQuery.Create(nil);
        qry.Connection := Conn;

        qry.SQL.Add('insert into Tormad(nome, endereco, complemento,');
        qry.SQL.Add('bairro, cidade, uf)');
        qry.SQL.Add('values(:nome, :endereco, :complemento,');
        qry.SQL.Add(':bairro, :cidade, :uf);');
        qry.SQL.Add('select last_insert_rowid() as id_Tormad');
        //  returning id_Tormad

        qry.ParamByName('nome').Value := nome;
        qry.ParamByName('endereco').Value := endereco;
        qry.ParamByName('complemento').Value := complemento;
        qry.ParamByName('bairro').Value := bairro;
        qry.ParamByName('cidade').Value := cidade;
        qry.ParamByName('uf').Value := uf;
        qry.Active := true;

        Result := qry.ToJSONObject;

    finally
        FreeAndNil(qry);
    end;
end;

function TDm.TormadEditar(id_Tormad: integer;
                           nome, endereco, complemento,
                           bairro, cidade, uf: string): TJsonObject;
var
    qry: TuNIQuery;
begin
    try
        qry := TuNIQuery.Create(nil);
        qry.Connection := Conn;

        qry.SQL.Add('update Tormad set nome=:nome, endereco=:endereco,');
        qry.SQL.Add('complemento=:complemento, bairro=:bairro, cidade=:cidade, uf=:uf');
        qry.SQL.Add('where id_Tormad = :id_Tormad');

        qry.ParamByName('id_Tormad').Value := id_Tormad;
        qry.ParamByName('nome').Value := nome;
        qry.ParamByName('endereco').Value := endereco;
        qry.ParamByName('complemento').Value := complemento;
        qry.ParamByName('bairro').Value := bairro;
        qry.ParamByName('cidade').Value := cidade;
        qry.ParamByName('uf').Value := uf;
        qry.ExecSQL;

//        Result := TJSONObject.Create(TJsonPair.Create('id_Tormad', id_Tormad)); {"id_Tormad": 123}

    finally
        FreeAndNil(qry);
    end;
end;

function TDm.TormadExcluir(id_Tormad: integer): TJsonObject;
var
    qry: TuNIQuery;
begin
    try
        qry := TuNIQuery.Create(nil);
        qry.Connection := Conn;

        qry.SQL.Add('delete from Tormad');
        qry.SQL.Add('where id_Tormad = :id_Tormad');
        qry.ParamByName('id_Tormad').Value := id_Tormad;
        qry.ExecSQL;

//        Result := TJSONObject.Create(TJsonPair.Create('id_Tormad', id_Tormad)); {"id_Tormad": 123}

    finally
        FreeAndNil(qry);
    end;
end;

function TDm.ProdutoListar(filtro: string): TJsonArray;
var
    qry: TuNIQuery;
begin
    try
        qry := TuNIQuery.Create(nil);
        qry.Connection := Conn;

        qry.SQL.Add('select *');
        qry.SQL.Add('from produto');

        if filtro <> '' then
        begin
            qry.SQL.Add('where descricao like :filtro');
            qry.ParamByName('filtro').Value := '%' + filtro + '%';
        end;

        qry.SQL.Add('order by descricao');
        qry.Active := true;

        Result := qry.ToJSONArray;

    finally
        FreeAndNil(qry);
    end;
end;

function TDm.UsuarioLogin(email, senha: string): TJsonObject;
var
    qry: TuNIQuery;
begin
    try
        qry := TuNIQuery.Create(nil);
        qry.Connection := Conn;

        qry.SQL.Add('select id_usuario, nome, email');
        qry.SQL.Add('from usuario');
        qry.SQL.Add('where email = :email and senha = :senha');
        qry.ParamByName('email').Value := email;
//        qry.ParamByName('senha').Value :=  SaltPassword(senha);
        qry.Active := true;

        Result := qry.ToJSONObject;

    finally
        FreeAndNil(qry);
    end;
end;

function TDm.PedidoListar(filtro: string): TJsonArray;
var
    qry: TuNIQuery;
begin
    try
        qry := TuNIQuery.Create(nil);
        qry.Connection := Conn;

        qry.SQL.Add('select p.*, c.nome, c.cidade, u.nome as usuario');
        qry.SQL.Add('from pedido p');
        qry.SQL.Add('join Tormad c on (c.id_Tormad = p.id_Tormad)');
        qry.SQL.Add('join usuario u on (u.id_usuario = p.id_usuario)');

        if filtro <> '' then
        begin
            qry.SQL.Add('where c.nome like :filtro');
            qry.ParamByName('filtro').Value := '%' + filtro + '%';
        end;

        qry.SQL.Add('order by p.id_pedido desc');
        qry.Active := true;

        Result := qry.ToJSONArray;

    finally
        FreeAndNil(qry);
    end;
end;

function TDm.PedidoListarId(id_pedido: integer): TJsonObject;
var
    qry: TuNIQuery;
begin
    try
        qry := TuNIQuery.Create(nil);
        qry.Connection := Conn;

        qry.SQL.Add('select p.*, c.nome, c.cidade, u.nome as usuario');
        qry.SQL.Add('from pedido p');
        qry.SQL.Add('join Tormad c on (c.id_Tormad = p.id_Tormad)');
        qry.SQL.Add('join usuario u on (u.id_usuario = p.id_usuario)');
        qry.SQL.Add('where p.id_pedido = :id_pedido');
        qry.ParamByName('id_pedido').Value := id_pedido;
        qry.Active := true;

        Result := qry.ToJSONObject;

        // tratamento dos itens...
        qry.Active := false;
        qry.SQL.Clear;
        qry.SQL.Add('select i.id_item, i.id_produto, p.descricao, i.qtd, i.vl_unitario, i.vl_total');
        qry.SQL.Add('from pedido_item i');
        qry.SQL.Add('join produto p on (p.id_produto = i.id_produto)');
        qry.SQL.Add('where i.id_pedido = :id_pedido');
        qry.ParamByName('id_pedido').Value := id_pedido;
        qry.Active := true;

        Result.AddPair('itens', qry.ToJSONArray);

    finally
        FreeAndNil(qry);
    end;
end;

function TDm.PedidoInserir(id_usuario, id_Tormad: integer;
                           dt_pedido: string;
                           vl_total: double;
                           itens: TJSONArray): TJsonObject;
var
    qry: TuNIQuery;
    id_pedido, i: integer;
begin
    try
        qry := TuNIQuery.Create(nil);
        qry.Connection := Conn;

        qry.SQL.Add('insert into pedido(id_usuario, id_Tormad, dt_pedido, vl_total)');
        qry.SQL.Add('values(:id_usuario, :id_Tormad, :dt_pedido, :vl_total);');
        qry.SQL.Add('select last_insert_rowid() as id_pedido'); // SQLite...
        //qry.SQL.Add('returning id_pedido'); // Firebird...
        qry.ParamByName('id_usuario').Value := id_usuario;
        qry.ParamByName('id_Tormad').Value := id_Tormad;
        qry.ParamByName('dt_pedido').Value := dt_pedido;  //yyyy-mm-dd
        qry.ParamByName('vl_total').Value := vl_total;
        qry.Active := true;

        id_pedido := qry.FieldByName('id_pedido').AsInteger;


        // Itens...
        for i := 0 to itens.Size - 1 do
        begin
{            qry.SQL.Clear;
            qry.SQL.Add('insert into pedido_item(id_pedido, id_produto, qtd, vl_unitario, vl_total)');
            qry.SQL.Add('values(:id_pedido, :id_produto, :qtd, :vl_unitario, :vl_total)');

            qry.ParamByName('id_pedido').Value := id_pedido;
            qry.ParamByName('id_produto').Value := itens[i].GetValue<integer>('id_produto', 0);
            qry.ParamByName('qtd').Value := itens[i].GetValue<integer>('qtd', 0);
            qry.ParamByName('vl_unitario').Value := itens[i].GetValue<integer>('vl_unitario', 0);
            qry.ParamByName('vl_total').Value := itens[i].GetValue<integer>('vl_total', 0);
            qry.ExecSQL;}
        end;


//        Result := TJSONObject.Create(TJSONPair.Create('id_pedido', id_pedido));
        {"id_pedido": 123}

    finally
        FreeAndNil(qry);
    end;
end;

function TDm.PedidoEditar(id_pedido, id_Tormad: integer;
                          dt_pedido: string;
                          vl_total: double;
                          itens: TJSONArray): TJsonObject;
var
    qry: TuNIQuery;
    i: integer;
begin
    try
        qry := TuNIQuery.Create(nil);
        qry.Connection := Conn;

        qry.SQL.Add('update pedido set id_Tormad=:id_Tormad,');
        qry.SQL.Add('dt_pedido=:dt_pedido, vl_total=:vl_total');
        qry.SQL.Add('where id_pedido = :id_pedido');
        qry.ParamByName('id_pedido').Value := id_pedido;
        qry.ParamByName('id_Tormad').Value := id_Tormad;
        qry.ParamByName('dt_pedido').Value := dt_pedido;  //yyyy-mm-dd
        qry.ParamByName('vl_total').Value := vl_total;
        qry.ExecSQL;


        qry.SQL.Clear;
        qry.SQL.Add('delete from pedido_item ');
        qry.SQL.Add('where id_pedido = :id_pedido');
        qry.ParamByName('id_pedido').Value := id_pedido;
        qry.ExecSQL;


        // Itens...
        for i := 0 to itens.Size - 1 do
        begin
            qry.SQL.Clear;
            qry.SQL.Add('insert into pedido_item(id_pedido, id_produto, qtd, vl_unitario, vl_total)');
            qry.SQL.Add('values(:id_pedido, :id_produto, :qtd, :vl_unitario, :vl_total)');

            qry.ParamByName('id_pedido').Value := id_pedido;
{            qry.ParamByName('id_produto').Value := itens[i].GetValue<integer>('id_produto', 0);
            qry.ParamByName('qtd').Value := itens[i].GetValue<integer>('qtd', 0);
            qry.ParamByName('vl_unitario').Value := itens[i].GetValue<integer>('vl_unitario', 0);
            qry.ParamByName('vl_total').Value := itens[i].GetValue<integer>('vl_total', 0);}
            qry.ExecSQL;
        end;


//        Result := TJSONObject.Create(TJSONPair.Create('id_pedido', id_pedido));

    finally
        FreeAndNil(qry);
    end;
end;

function TDm.PedidoExcluir(id_pedido: integer): TJsonObject;
var
    qry: TuNIQuery;
begin
    try
        qry := TuNIQuery.Create(nil);
        qry.Connection := Conn;

        qry.SQL.Add('delete from pedido_item');
        qry.SQL.Add('where id_pedido = :id_pedido');
        qry.ParamByName('id_pedido').Value := id_pedido;
        qry.ExecSQL;

        qry.SQL.Clear;
        qry.SQL.Add('delete from pedido');
        qry.SQL.Add('where id_pedido = :id_pedido');
        qry.ParamByName('id_pedido').Value := id_pedido;
        qry.ExecSQL;

//        Result := TJSONObject.Create(TJsonPair.Create('id_pedido', id_pedido));

    finally
        FreeAndNil(qry);
    end;
end;



end.
