{ Ce fichier a été automatiquement créé par Lazarus. Ne pas l'éditer !
  Cette source est seulement employée pour compiler et installer le paquet.
 }

unit lazextcomponents; 

interface

uses
    U_OnFormInfoIni, PDBCheck, PCheck, U_ExtColorCombos, u_regfwbuttons, 
  u_buttons_appli, u_extcomponent, u_framework_components, U_RegisterExtDBNav, 
  U_DBListView, U_RegisterListView, u_regextcolorcombos, u_regonforminfoini, 
  U_ExtNumEdits, u_regextnumedits, u_regframeworkcomponents, U_ExtDBNavigator, 
  U_FormMainIni, ExtDBImage, RegImageComponents, LazarusPackageIntf;

implementation

procedure Register; 
begin
  RegisterUnit('PDBCheck', @PDBCheck.Register); 
  RegisterUnit('PCheck', @PCheck.Register); 
  RegisterUnit('u_regfwbuttons', @u_regfwbuttons.Register); 
  RegisterUnit('U_RegisterExtDBNav', @U_RegisterExtDBNav.Register); 
  RegisterUnit('U_RegisterListView', @U_RegisterListView.Register); 
  RegisterUnit('u_regextcolorcombos', @u_regextcolorcombos.Register); 
  RegisterUnit('u_regonforminfoini', @u_regonforminfoini.Register); 
  RegisterUnit('u_regextnumedits', @u_regextnumedits.Register); 
  RegisterUnit('u_regframeworkcomponents', @u_regframeworkcomponents.Register); 
  RegisterUnit('RegImageComponents', @RegImageComponents.Register); 
end; 

initialization
  RegisterPackage('lazextcomponents', @Register); 
end.
