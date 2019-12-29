namespace SQLDeployment.Core;

uses
  McMaster.Extensions.CommandLineUtils,
  Newtonsoft.Json,
  SQLDeployment.Core,
  SQLDeployment.Core.Models,
  System.Threading.Tasks;

type
  SQLProgram = public class
  private
  protected
  public

    method Main(args:array of String):Integer;
    begin

      var app := new CommandLineApplication;
      app.HelpOption;

      var fOption := app.Option('-f','Deployment filename', CommandOptionType.SingleValue);

      app.OnExecuteAsync((ct) ->
        begin
          if(not fOption.HasValue)then
          begin
            Console.WriteLine('Deployment filename must be specified with -f');
            exit 0;
          end;

          var deployFilename := $'{System.Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments)}/Documents/Secrets/{fOption.Value}';

          if(not System.IO.File.Exists(deployFilename))then
          begin
            Console.WriteLine($'Deployment filename {deployFilename} does not exist');
            exit;
          end;

          Console.WriteLine($'Deploymment filename is {deployFilename}');

          var deploy := JsonConvert.DeserializeObject<Deployment>(System.IO.File.ReadAllText(deployFilename));

          Console.WriteLine($'Connection is {deploy.Connection}');

          await deploy.Deploy;

        end);

      exit app.Execute(args);
    end;
  end;

end.