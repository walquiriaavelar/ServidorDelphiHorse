object Dm: TDm
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  Height = 309
  Width = 442
  object conn: TUniConnection
    AutoCommit = False
    ProviderName = 'SQL Server'
    Port = 1433
    Database = 'DPM2804'
    DefaultTransaction = UniTransaction1
    Username = 'sa'
    Server = '158.69.166.169'
    LoginPrompt = False
    BeforeConnect = ConnBeforeConnect
    Left = 48
    Top = 16
    EncryptedPassword = 'A8FF96FF93FFCEFFC8FFCEFFC7FFCFFFC8FF'
  end
  object UniTransaction1: TUniTransaction
    DefaultConnection = conn
    Left = 112
    Top = 16
  end
  object SQLServerUniProvider1: TSQLServerUniProvider
    Left = 208
    Top = 16
  end
  object Qry: TUniQuery
    Connection = conn
    Transaction = UniTransaction1
    Left = 128
    Top = 88
  end
end
