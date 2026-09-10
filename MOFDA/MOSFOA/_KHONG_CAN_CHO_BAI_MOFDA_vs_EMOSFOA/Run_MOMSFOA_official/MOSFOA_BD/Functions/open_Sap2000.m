function open_Sap2000(h)
SM.App( 'sap' );
SM.Ver( '24' );
ProgramPath         = 'C:\Program Files\Computers and Structures\SAP2000 24\SAP2000.exe';
APIDLLPath          = 'C:\Program Files\Computers and Structures\SAP2000 24\SAP2000v1.dll';
[Sobj]              = SM.Helper.CreateObject( ProgramPath,APIDLLPath );
[Smdl]              = SM.SapModel();
if h==1
    SM.ApplicationStart('Visible',false)
    SM.Hide;
else
    SM.ApplicationStart
end
end