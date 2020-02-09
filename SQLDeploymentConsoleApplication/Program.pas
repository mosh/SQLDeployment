namespace SQLDeploymentConsoleApplication;

uses
  System.Linq, SQLDeployment.Core;

type
  Program = class
  public
    class method Main(args: array of String): Int32;
    begin
      var obj := new SQLProgram;
      exit obj.Main(args);
    end;

  end;

end.