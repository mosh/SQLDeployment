namespace SQLDeploymentConsoleApplication;

uses
  System.Linq, SQLDeployment.Core;

type
  Program = class
  public
    class method Main(args: array of String): Int32;
    begin

      args := ['-f','isailed-schema-updates.deployment'];

      var obj := new SQLProgram;
      exit obj.Main(args);
    end;

  end;

end.