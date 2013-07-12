unit u_stringsutf8;

{$I ..\DLCompilers.inc}
{$I ..\extends.inc}

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  SysUtils,

{$IFDEF VERSIONS}
  fonctions_version,
{$ENDIF}
   Classes;

{$IFDEF VERSIONS}
const
    gVer_stringsutf8 : T_Version = ( Component : 'String management' ; FileUnit : 'u_stringsutf8' ;
                        			                 Owner : 'Matthieu Giroux' ;
                        			                 Comment : 'Strings UTF8.' ;
                        			                 BugsStory : 'Version 1.0.0.0 : Certaines fonctions non utilisées sont à tester.';
                        			                 UnitType : 1 ;
                        			                 Major : 1 ; Minor : 0 ; Release : 0 ; Build :  0);
{$ENDIF}
type

{ TStringListUTF8 }

 TStringListUTF8 = class(TStringlist)
       procedure LoadFromFile(const FileName: string); override;
       procedure SaveToFile(const FileName: string); override;

     End;

implementation

uses fonctions_file;

{ TStringListUTF8 }

procedure TStringListUTF8.LoadFromFile(const FileName: string);
begin
  p_LoadStrings(Self,FileName,'');
end;

procedure TStringListUTF8.SaveToFile(const FileName: string);
begin
  p_SaveStrings(Self,FileName,'');
end;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_fonction_string );
{$ENDIF}
end.

