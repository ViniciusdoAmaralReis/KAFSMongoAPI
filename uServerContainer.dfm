object ServerContainer: TServerContainer
  Height = 86
  Width = 345
  object DSServer: TDSServer
    AutoStart = False
    Left = 32
    Top = 11
  end
  object DSTCPServerTransport: TDSTCPServerTransport
    Port = 8081
    Server = DSServer
    Filters = <>
    Left = 232
    Top = 9
  end
  object DSServerClass: TDSServerClass
    OnGetClass = DSServerClassGetClass
    Server = DSServer
    Left = 112
    Top = 11
  end
end
