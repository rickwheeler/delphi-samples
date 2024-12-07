unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit, Data.Bind.Components,
  Data.Bind.ObjectScope, Data.Bind.GenData, System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt, Fmx.Bind.DBEngExt;

type

  TCustomer = class
  private
    FName: string;
    FChangeCount: Integer;
    FOnChange: TProc<TCustomer>;
    function GetName: string;
    procedure SetName(const Value: string);
    function GetChangeCount: Integer;
  public
    constructor Create(const AOnChange: TProc<TCustomer>);
    property Name: string read GetName write SetName;
    property ChangeCount: Integer read GetChangeCount;
  end;

  TMainForm = class(TForm)
    CustomerEdit: TEdit;
    Label1: TLabel;
    CustomerBindSource: TPrototypeBindSource;
    BindingsList1: TBindingsList;
    LinkControlToField1: TLinkControlToField;
    Button1: TButton;
    CustomerChangedLabel: TLabel;
    procedure CustomerBindSourceCreateAdapter(Sender: TObject; var ABindSourceAdapter: TBindSourceAdapter);
  private
    FCustomer: TCustomer;
    procedure DoCustomerChanged(ACustomer: TCustomer);
  public
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

{ TCustomer }

constructor TCustomer.Create(const AOnChange: TProc<TCustomer>);
begin
  FOnChange := AOnChange;
end;

function TCustomer.GetChangeCount: Integer;
begin
  Result := FChangeCount;
end;

function TCustomer.GetName: string;
begin
  Result := FName;
end;

procedure TCustomer.SetName(const Value: string);
begin
  FName := Value;
  Inc(FChangeCount);
  FOnChange(Self);
end;

procedure TMainForm.CustomerBindSourceCreateAdapter(Sender: TObject; var ABindSourceAdapter: TBindSourceAdapter);
begin
  var Customer := TCustomer.Create(DoCustomerChanged);
  ABindSourceAdapter := TObjectBindSourceAdapter<TCustomer>.Create(CustomerBindSource, Customer, True);
  ABindSourceAdapter.AutoPost := True;
end;

procedure TMainForm.DoCustomerChanged(ACustomer: TCustomer);
begin
  CustomerChangedLabel.Text := Format('"%s" (changed %d times)', [ACustomer.Name, ACustomer.ChangeCount]);
end;

end.
