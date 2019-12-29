namespace SQLDeployment.Core.Models;

uses
  System.Collections.Generic;

type
  Folder = public class
  public
    property Name:String;
    property Files:List<File> := new List<File>;
  end;

end.