namespace SQLDeployment.Core;

uses
  Dapper,
  System.Data.SqlClient,
  SQLDeployment.Core.Models,
  System.Text.RegularExpressions,
  System.Threading.Tasks;

type

  DeploymentExtensions = public extension class(Deployment)
  private

    ///
    /// With this text
    /// "There is already an object named 'get_sailed_for_boat' in the database";
    /// Will extract get_sailed_for_boat
    ///
    method ExistingStoredProcedure(message:String): tuple of (Boolean,String);
    begin
      var pattern := "(?:There is already an object named ')(.*)(?:' in the database)";
      var reg := new Regex(pattern);
      var someMatch := reg.Match(message);

      if((someMatch.Success) and (someMatch.Groups.Count=2))then
      begin
        exit (true,someMatch.Groups[1].Value);
      end;

      exit (false,nil);

    end;

  protected

    method Execute(connection:SqlConnection; filename:String):Task;
    begin

      Console.WriteLine($'Running {filename}');

      var sql := System.IO.File.ReadAllText(filename);
      var repeatWithDrop := false;
      var storedProcedure := '';
      try
        await connection.ExecuteAsync(sql);
      except
        on S:SqlException do
        begin
          var storedProcedureInfo := ExistingStoredProcedure(S.Message);
          if not storedProcedureInfo.Item1 then
          begin
            raise;
          end;
          storedProcedure := storedProcedureInfo.Item2;
          repeatWithDrop := true;
        end;
      end;

      if(repeatWithDrop)then
      begin
        Console.WriteLine($'Dropping stored procedure {storedProcedure} before running');
        await connection.ExecuteAsync($'drop procedure {storedProcedure}');
        await connection.ExecuteAsync(sql);
      end;

    end;
  public

    method Deploy:Task;
    begin
      using connection := new SqlConnection(self.Connection) do
      begin
        for each folder in self.Folders do
        begin
          var name := folder.Name;

          if(folder.Name.StartsWith('~'))then
          begin
            name := folder.Name.Replace('~',System.Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments));
          end;

          for each file in folder.Files do
          begin

            var filename := $'{name}/{file.Name}';

            if System.IO.File.Exists(filename) then
            begin
              await Execute(connection, filename);
            end
            else
            begin
              Console.WriteLine($'{filename} does not exist');
            end;

          end;
        end;
      end;
    end;
  end;

end.