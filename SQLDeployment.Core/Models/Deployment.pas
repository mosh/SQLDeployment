namespace SQLDeployment.Core.Models;

uses
  System.Collections.Generic;

type
  Deployment = public class
  private
  protected
  public
    property Connection:String;
    property Folders:List<Folder> := new List<Folder>;
  end;

end.