unit U_RegImageComponents;

interface

uses Classes;

procedure Register;

implementation

uses
{$IFDEF FPC}
     lresources,
{$ENDIF}
     U_ExtDBImage ;

procedure Register;
Begin
  RegisterComponents ( 'Extended', [TExtDBImage] );
End;

initialization
{$IFDEF FPC}
  {$I U_RegImageComponents.lrs}
{$ENDIF}
end.
