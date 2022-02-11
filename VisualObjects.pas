{$REGION ' �������� VisualObjects'}
  /// <summary> ����������� ������� </summary>
  /// <author> evdokimov_v_i </author>
{$ENDREGION ' �������� VisualObjects'}
unit VisualObjects;

interface

uses
  SysUtils, Classes, Graphics,
  superobject,
  VisualCustomTypes,
  OPL_schema,
  OPL_utils;

const
  /// ������� ��������
  {$REGION ' �������� HT_OUT'}
    /// <summary> ��� ������� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� HT_OUT'}
  HT_OUT          = $00000000;
  {$REGION ' �������� HT_IN'}
    /// <summary> ���������� ������� ������� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� HT_IN'}
  HT_IN           = $80000000;
  {$REGION ' �������� HT_VERTEX'}
    /// <summary> ������� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� HT_VERTEX'}
  HT_VERTEX       = $40000000;
  {$REGION ' �������� HT_SIDE'}
    /// <summary> ������� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� HT_SIDE'}
  HT_SIDE         = $20000000;

  /// ���� �������
  {$REGION ' �������� CR_DEFAULT'}
    /// <summary> CR_DEFAULT </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� CR_DEFAULT'}
  CR_DEFAULT      = 0;
  {$REGION ' �������� CR_SIZEALL'}
    /// <summary> CR_SIZEALL </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� CR_SIZEALL'}
  CR_SIZEALL      = 1;
  {$REGION ' �������� CR_HORIZONTAL'}
    /// <summary> CR_HORIZONTAL </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� CR_HORIZONTAL'}
  CR_HORIZONTAL   = 2;
  {$REGION ' �������� CR_VERTICAL'}
    /// <summary> CR_VERTICAL </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� CR_VERTICAL'}
  CR_VERTICAL     = 3;
  {$REGION ' �������� CR_DIAG1'}
    /// <summary> CR_DIAG1 </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� CR_DIAG1'}
  CR_DIAG1        = 4;
  {$REGION ' �������� CR_DIAG2'}
    /// <summary> CR_DIAG2 </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� CR_DIAG2'}
  CR_DIAG2        = 5;   

  {$REGION ' �������� INACTIVE_OBJECT_COLOR'}
    /// <summary> ���� ����������� ������� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� INACTIVE_OBJECT_COLOR'}
  INACTIVE_OBJECT_COLOR = clSilver;

  {$REGION ' �������� MULTISELECT_COLOR'}
    /// <summary> ���� ��������� �������� ��� ������������� ��������� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� MULTISELECT_COLOR'}
  MULTISELECT_COLOR = clGray;

type
  {$REGION ' �������� TConnectionLine'}
    /// <summary> ��������������� ���������� ������ TConnectionLine </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� TConnectionLine'}
  TConnectionLine = class;

  {$REGION ' �������� PHitTestParams'}
    /// <summary> ��������� �� ��������� ��� ����������� ������� ������� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� PHitTestParams'}
  PHitTestParams = ^THitTestParams;
  {$REGION ' �������� THitTestParams'}
    /// <summary> ��������� ��� ����������� ������� ������� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� THitTestParams'}
  THitTestParams = record
    XPos, YPos: Integer;  // ������� � �������� ��������
    Tolerance: Integer;   // ����������������
  end;

  //

  {$REGION ' �������� TComplexDrawParams'}
    /// <summary> ��������� ��������� ������� � ������� �������� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� TComplexDrawParams'}
  TComplexDrawParams = record
    Canvas: TLogicalCanvas;
    IsActive: boolean;
    IsMouseOver: boolean;
  end;

  //
  {$REGION ' �������� TBaseVisualObject'}
    /// <summary> ������� ����� ���������� �������� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� TBaseVisualObject'}
  TBaseVisualObject = class(TObject)
  private
    FBasePoints: TList;
    FOnChange: TNotifyEvent;
    FLockCount: Integer;
    FDragging: Boolean;
    FDragHitTest: Cardinal;
    //
    FBrush: TBrush;
    FPen: TPen;
    FFont: TFont;
    //
    FIsSelected: boolean;
    //
    FRotation: integer;
    //
    FVisualContainer: TObject;
    //
    function GetBasePointsCount: Integer;
    function GetBasePoint(Index: Integer): TFloatPoint;
    procedure SetBasePoint(Index: Integer; const Value: TFloatPoint);
    //
    function GetCommonJson(): string; virtual;
    function GetBrushJson(): string; virtual;
    function GetPenJson(): string; virtual;
    function GetFontJson2(): string; virtual;
    function GetFontJson(): string; virtual;
    function GetBasePointsJson(OffsetX, OffsetY: integer): string; virtual;
    function PrepareObjectJsonResult(prmResult: string): string;
    //
    procedure SpecialDraw(Canvas: TLogicalCanvas); virtual;
    //
    function IsRotated(): boolean;
    //
    procedure SetVisualContainer(Value: TObject);
  protected
    FCanBeAligned: boolean;
    FSelectionColor: TColor;
    FConnectable: boolean;
    FSelectable: boolean;
    FLogicalUnitRequired: boolean;
    //
    procedure AssignBrushPenFont(Canvas: TLogicalCanvas);
    procedure DrawAsSelected(Canvas: TLogicalCanvas);
    //
    procedure Change(Sender: integer = 0);
    // ������ ���������� �������� �������. ������ ��� ������������� � ��������,
    // ����������� ���� ��� �� ��������
    procedure AddBasePoint(X, Y: Extended);
    procedure InsertBasePoint(Index: Integer; X, Y: Extended);
    procedure DeleteBasePoint(Index: Integer);
    procedure ClearBasePoints;
    // ������ ���������� ���������. ������������ ����� ��������� � �������� �������
    // ����� ������ � ��������
    function GetVertexesCount: Integer; virtual; abstract;
    function GetVertex(Index: Integer): TFloatPoint; virtual; abstract;
    procedure SetVertex(Index: Integer; const Value: TFloatPoint); virtual; abstract;
    //
    procedure AddError(var prmErrorsList: TStringList;
      var prmErrorObjects: TList; prmErrorText: string);
    //
    procedure IsTheSameSpecial(prmObject: TBaseVisualObject;
      var prmResult: boolean); virtual;
    //
    procedure SetRotation(Value: integer); virtual;
  public
    {$REGION ' �������� TypeName'}
      /// <summary> �������� ���� ������� </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� TypeName'}
    TypeName: string;
    {$REGION ' �������� TypeID'}
      /// <summary> ������������� ���� ������� </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� TypeID'}
    TypeID: integer;
    //
    {$REGION ' �������� UniqueName'}
      /// <summary> ���������� ��� </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� UniqueName'}
    UniqueName: string;
    //
    {$REGION ' �������� FDragStartPos'}
      /// <summary> ����� ������ ����������� </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� FDragStartPos'}
    FDragStartPos: TFloatPoint;
    {$REGION ' �������� DrawOffsetX'}
      /// <summary> �������� ��������� �� X </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� DrawOffsetX'}
    DrawOffsetX: integer;
    {$REGION ' �������� DrawOffsetY'}
      /// <summary> �������� ��������� �� Y </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� DrawOffsetY'}
    DrawOffsetY: integer;
    //
    {$REGION ' �������� LogicalUnit'}
      /// <summary> ������ �� ���������� ������ ����� </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� LogicalUnit'}
    LogicalUnit: TPlantUnit;
    //
    //
    {$REGION ' �������� VOCBeginDrag'}
      /// <summary> ������� ������ ����������� ������� </summary>
      ///   <param name="prmHitTest"> ��������� ������� ������������� ������� </param>
      ///   <param name="prmStartPos"> ��������� ����� ����������� </param>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� VOCBeginDrag'}
    procedure VOCBeginDrag(prmHitTest: Cardinal; prmStartPos: TFloatPoint); virtual;
    {$REGION ' �������� VOCEndDrag'}
      /// <summary> ������� ��������� ����������� ������� </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� VOCEndDrag'}
    procedure VOCEndDrag(); virtual;
    {$REGION ' �������� VOCDrag'}
      /// <summary> ������� ����������� ������� </summary>
      ///   <param name="prmNewPos"> ����� ����� ����������� </param>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� VOCDrag'}
    procedure VOCDrag(prmNewPos: TFloatPoint); virtual;
    {$REGION ' �������� VOCVertexMove'}
      /// <summary> ������� ����������� ������� ������� </summary>
      ///   <param name="prmIndex"> ������ ������� </param>
      ///   <param name="prmNewPos"> ����� ������� ����� </param>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� VOCVertexMove'}
    procedure VOCVertexMove(prmIndex: integer; prmNewPos: TFloatPoint); virtual;
    {$REGION ' �������� VOCMove'}
      /// <summary> ������� ����������� ������� </summary>
      ///   <param name="prmDeltaX"> �������� �� X </param>
      ///   <param name="prmDeltaY"> �������� �� Y </param>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� VOCMove'}
    procedure VOCMove(prmDeltaX, prmDeltaY: extended); virtual;
    {$REGION ' �������� VOCHitTest'}
      /// <summary> ���������� �������� ������� �������, �������������� ���������� </summary>
      ///   <param name="prmConvertIntf"> ������, ����������� ������ �������������� ��������� </param>
      ///   <param name="prmParams"> ��������� (����������, ����������������) </param>
      /// <returns> cardinal </returns>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� VOCHitTest'}
    function VOCHitTest(prmConvertIntf: ICoordConvert;
      prmParams: THitTestParams): cardinal; virtual;
    {$REGION ' �������� VOCGetCursor'}
      /// <summary> ���������� ������ � ����������� �� ���������� </summary>
      ///   <param name="prmHitTest"> ��������� (����������, ����������������)  </param>
      /// <returns> cardinal </returns>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� VOCGetCursor'}
    function VOCGetCursor(prmHitTest: cardinal): cardinal; virtual;
    //
    {$REGION ' �������� VOCSideMove'}
      /// <summary> ������� ����������� ������� ������� </summary>
      ///   <param name="prmIndex"> ������ ������� </param>
      ///   <param name="prmNewPos"> ����� ������� </param>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� VOCSideMove'}
    procedure VOCSideMove(prmIndex: integer; prmNewPos: TFloatPoint); virtual;
    {$REGION ' �������� VOCConstructPoint'}
      /// <summary> ������� ��������� ����� ����� ������� </summary>
      ///   <param name="prmPos"> ������� ����� </param>
      /// <returns> cardinal </returns>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� VOCConstructPoint'}
    function VOCConstructPoint(prmPos: TFloatPoint): cardinal; virtual;
    {$REGION ' �������� VOCProcessConstruct'}
      /// <summary> ����������� ���������� ������� �� ������ </summary>
      ///   <param name="prmPos"> ����� ������� �����  </param>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� VOCProcessConstruct'}
    procedure VOCProcessConstruct(prmPos: TFloatPoint); virtual;
    {$REGION ' �������� VOCStopConstruct'}
      /// <summary> ����������� ���������� ������� </summary>
      /// <returns> cardinal </returns>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� VOCStopConstruct'}
    function VOCStopConstruct(): cardinal; virtual;
    {$REGION ' �������� VOCVControl'}
      /// <summary> ���������� ��������� ������� </summary>
      ///   <param name="prmHitTest"> ��������� (����������, ����������������) </param>
      ///   <param name="prmPos"> ����� ������� </param>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� VOCVControl'}
    procedure VOCVControl(prmHitTest: Cardinal; prmPos: TFloatPoint); virtual;
    //
    {$REGION ' �������� GetHitTest'}
      /// <summary> ���������� �������� ������� �������, �������������� ���������� </summary>
      ///   <param name="prmCoordConvert"> ������, ����������� ������ �������������� ��������� </param>
      ///   <param name="prmX"> ���������� X </param>
      ///   <param name="prmY"> ���������� Y </param>
      ///   <param name="prmTolerance"> ���������������� </param>
      /// <returns> cardinal </returns>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� GetHitTest'}
    function GetHitTest(prmCoordConvert: ICoordConvert;
      prmX, prmY: integer; prmTolerance: integer = 3): cardinal;
    //
    {$REGION ' �������� IsInRect'}
      /// <summary> ��������, ��������� �� ������ ������ ������������� �������,
      ///   �������� ������� </summary>
      ///   <param name="x1"> ���������� X1 </param>
      ///   <param name="y1"> ���������� Y1 </param>
      ///   <param name="x2"> ���������� X2 </param>
      ///   <param name="y2"> ���������� Y2 </param>
      /// <returns> boolean </returns>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� IsInRect'}
    function IsInRect(x1, y1, x2, y2: integer): boolean;
    //
    {$REGION ' �������� Create'}
      /// <summary> ����������� ���������� ������ </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� Create'}
    constructor Create; virtual;
    {$REGION ' �������� Destroy'}
      /// <summary> ���������� ���������� ������ </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� Destroy'}
    destructor Destroy; override;
    {$REGION ' �������� BeginUpdate'}
      /// <summary> ���������� ����������� ������� </summary>
      ///   <param name="Sender"> �������� ������� - ��� ������� </param>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� BeginUpdate'}
    procedure BeginUpdate(Sender: integer = 0);
    {$REGION ' �������� EndUpdate'}
      /// <summary> ������������� ����������� ������� </summary>
      ///   <param name="Sender"> �������� ������� - ��� ������� </param>      ///
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� EndUpdate'}
    procedure EndUpdate(Sender: integer = 0);
    // ���������
    {$REGION ' �������� Draw'}
      /// <summary> ��������� ������� </summary>
      ///   <param name="Canvas"> ���������� ����� </param>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� Draw'}
    procedure Draw(Canvas: TLogicalCanvas); virtual;
    {$REGION ' �������� DrawInComplex'}
      /// <summary> ��������� ������� � ������� �������� </summary>
      ///   <param name="Params"> ��������� ��������� </param>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� DrawInComplex'}
    procedure DrawInComplex(Params: TComplexDrawParams); virtual;
    //
    {$REGION ' �������� CanBe1stConnObject'}
      /// <summary> ��������, ����� �� ������ ���� 1� � ���������� �������� </summary>
      ///   <param name="prmCL"> ������������� ����� </param>
      ///   <param name="prmHT"> ��������� ������� </param>
      /// <returns> boolean </returns>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� CanBe1stConnObject'}
    function CanBe1stConnObject(prmCL: TConnectionLine;
      prmHT: cardinal): boolean; virtual;
    {$REGION ' �������� CanBe2ndConnObject'}
      /// <summary> ��������, ����� �� ������ ���� 2� � ���������� �������� </summary>
      ///   <param name="prmCL"> �������������� ����� </param>
      ///   <param name="prmHT"> ��������� ������� </param>
      /// <returns> boolean </returns>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� CanBe2ndConnObject'}
    function CanBe2ndConnObject(prmCL: TConnectionLine;
      prmHT: cardinal): boolean; virtual;
    //
    {$REGION ' �������� AddConnection'}
      /// <summary> ���������� ���������� </summary>
      ///   <param name="CL"> ����������� ���������� </param>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� AddConnection'}
    procedure AddConnection(CL: TConnectionLine); virtual;
    {$REGION ' �������� DeleteConnection'}
      /// <summary> �������� ��������� �� ������� </summary>
      ///   <param name="CL"> �������� �������������� ����� </param>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� DeleteConnection'}
    procedure DeleteConnection(CL: TConnectionLine); virtual;
    {$REGION ' �������� Delete'}
      /// <summary> ��������, �������������� �������� ������ </summary>
      ///   <param name="prmMovingCL"> ������ �������������� �����, ��������� ������� ��������� ��� ����� ��������� </param>
      ///   <param name="prmObjects"> ������ ��������, , ��������� ������� ��������� ��� ����� ��������� </param>
      ///   <param name="prmObjectsToFree"> ������ ��������, ������� ������ ���� ������� </param>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� Delete'}
    procedure Delete(var prmMovingCL: TList; var prmObjects: TList;
      var prmObjectsToFree: TList); virtual;
    //
    {$REGION ' �������� MakeBasePointsFromJson'}
      /// <summary> ���������� ������� ����� �� json-�������� </summary>
      ///   <param name="prmJsonObj"> json-�������� </param>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� MakeBasePointsFromJson'}
    procedure MakeBasePointsFromJson(prmJsonObj: ISuperObject); virtual;
    {$REGION ' �������� MakeBrushPenFontFromJson'}
      /// <summary> ������ ��������� �����/����/������ �� json-�������� </summary>
      ///   <param name="prmJsonObj"> json-�������� </param>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� MakeBrushPenFontFromJson'}
    procedure MakeBrushPenFontFromJson(prmJsonObj: ISuperObject); virtual;
    //
    {$REGION ' �������� MakeObjectFromJson'}
      /// <summary> ��������� ������� �� json-�������� </summary>
      ///   <param name="prmJsonObj"> json-������ </param>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� MakeObjectFromJson'}
    procedure MakeObjectFromJson(prmJsonObj: ISuperObject); overload; virtual;
    {$REGION ' �������� MakeObjectFromJson'}
      /// <summary> ��������� ������� �� json-�������� </summary>
      ///   <param name="prmJsonText"> json-����� </param>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� MakeObjectFromJson'}
    procedure MakeObjectFromJson(prmJsonText: string); overload;
    //
    {$REGION ' �������� MoveWhileDrag'}
      /// <summary> �������� ��� ����������� ���� ��� ����������� ������� </summary>
      ///   <param name="prmMovingLines"> �������������� �����, ��������� ������� ���������� ��� ����� ��������� </param>
      ///   <param name="prmSchema"> �����, ������� ����������� ������ </param>
      /// <returns> boolean </returns>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� MoveWhileDrag'}
    function MoveWhileDrag(var prmMovingLines: TList; prmSchema: TObject): boolean; virtual;
    {$REGION ' �������� MoveWhileConstruct'}
      /// <summary> �������� ��� ����������� ���� ��� ��������������� ������� </summary>
      ///   <param name="prmSchema"> �����, ������� ����������� ������ </param>
      ///   <param name="X"> ���������� ���� X </param>
      ///   <param name="Y"> ���������� ���� Y </param>
      ///   <param name="flShift"> ������ �� ������� Shift </param>
      /// <returns> boolean </returns>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� MoveWhileConstruct'}
    function MoveWhileConstruct(prmSchema: TObject;
      X, Y: integer; flShift: boolean): boolean; virtual;
    //
    {$REGION ' �������� ArrangeConnections'}
      /// <summary> ������������ ��������� ���������� � �������� </summary>
      /// <returns> boolean </returns>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� ArrangeConnections'}
    function ArrangeConnections(): boolean; virtual;
    //
    {$REGION ' �������� FinishConstruct'}
      /// <summary> �������� ��� ���������� ���������� ������� </summary>
      ///   <param name="prmPU"> ��������� ���������� ������ </param>
      /// <returns> boolean </returns>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� FinishConstruct'}
    function FinishConstruct(var prmPU: TPlantUnit): boolean; virtual;
    {$REGION ' �������� FinishDrag'}
      /// <summary> �������� ��� ���������� �������������� ������� </summary>
      /// <returns> boolean </returns>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� FinishDrag'}
    function FinishDrag(): boolean; virtual;
    //
    {$REGION ' �������� MakeLogicalUnit'}
      /// <summary> �������� ����������� ������� </summary>
      /// <returns> TPlantUnit </returns>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� MakeLogicalUnit'}
    function MakeLogicalUnit(): TPlantUnit; virtual;
    //
    {$REGION ' �������� GetObjectJson'}
      /// <summary> ���������� json-�������� ������������ ������� </summary>
      ///   <param name="OffsetX"> �������� ��������� �� X </param>
      ///   <param name="OffsetY"> �������� ��������� �� Y </param>
      /// <returns> string </returns>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� GetObjectJson'}
    function GetObjectJson(OffsetX, OffsetY: integer): string; virtual;
    {$REGION ' �������� GetObjectFullJson'}
      /// <summary> ��������� ������ json-�������� ������� - ������������ � ������������ ������� </summary>
      ///   <param name="OffsetX"> �������� ��������� �� X </param>
      ///   <param name="OffsetY"> �������� ��������� �� Y </param>
      /// <returns> string </returns>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� GetObjectFullJson'}
    function GetObjectFullJson(OffsetX, OffsetY: integer): string; virtual;
    //
    {$REGION ' �������� CheckErrors'}
      /// <summary> �������� ������� �� ������� ������ ��������������� </summary>
      ///   <param name="prmErrorsList"> ������ ������ </param>
      ///   <param name="prmErrorObjects"> ������ �������� � �������� </param>
      ///   <param name="prmSchema"> �����, ������� ����������� ������ </param>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� CheckErrors'}
    procedure CheckErrors(var prmErrorsList: TStringList;
      var prmErrorObjects: TList; prmSchema: TObject); virtual;
    //
    {$REGION ' �������� GetText'}
      /// <summary> ���������� ����� ���� ��������� ����� �������� </summary>
      /// <returns> string </returns>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� GetText'}
    function GetText(): string; virtual;
    {$REGION ' �������� IsTextExists'}
      /// <summary> �������� �� ������ ��������� ����� </summary>
      ///   <param name="prmText"> ������� ����� </param>
      /// <returns> boolean </returns>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� IsTextExists'}
    function IsTextExists(prmText: string): boolean;
    //
    {$REGION ' �������� GetCentralPoint'}
      /// <summary> ���������� "�����������" ����� ������� </summary>
      /// <returns> TFloatPoint </returns>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� GetCentralPoint'}
    function GetCentralPoint(): TFloatPoint;
    //
    {$REGION ' �������� IsTheSame'}
      /// <summary> �������� ������� �� ��, ��� �� "��� �� �����" </summary>
      ///   <param name="prmObject"> ����������� ������ </param>
      /// <returns> boolean </returns>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� IsTheSame'}
    function IsTheSame(prmObject: TBaseVisualObject): boolean;
    // ��������/�������
    {$REGION ' �������� BasePointsCount'}
      /// <summary> ���������� ������� ����� </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� BasePointsCount'}
    property BasePointsCount: Integer read GetBasePointsCount;
    {$REGION ' �������� BasePoints'}
      /// <summary> ������ ������� ����� </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� BasePoints'}
    property BasePoints[Index: Integer]: TFloatPoint read GetBasePoint write SetBasePoint;
    //
    {$REGION ' �������� VertexesCount'}
      /// <summary> ���������� ������ </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� VertexesCount'}
    property VertexesCount: Integer read GetVertexesCount;
    {$REGION ' �������� Vertex'}
      /// <summary> ������ ������ </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� Vertex'}
    property Vertex[Index: Integer]: TFloatPoint read GetVertex write SetVertex;
    {$REGION ' �������� OnChange'}
      /// <summary> ������� �� ��������� </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� OnChange'}
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    //
    {$REGION ' �������� Brush'}
      /// <summary> ����� ��������� </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� Brush'}
    property Brush: TBrush read FBrush write FBrush;
    {$REGION ' �������� Pen'}
      /// <summary> ���� ��������� </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� Pen'}
    property Pen: TPen read FPen write FPen;
    {$REGION ' �������� Font'}
      /// <summary> ����� ��������� </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� Font'}
    property Font: TFont read FFont write FFont;
    //
    {$REGION ' �������� IsSelected'}
      /// <summary> ������� �� ������ </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� IsSelected'}
    property IsSelected: boolean read FIsSelected write FIsSelected;
    //
    {$REGION ' �������� CanBeAligned'}
      /// <summary> ������ ����� ���� �������� ������������ ������ �������� </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� CanBeAligned'}
    property CanBeAligned: boolean read FCanBeAligned;
    {$REGION ' �������� SelectionColor'}
      /// <summary> ���� ��������� ������� </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� SelectionColor'}
    property SelectionColor: TColor read FSelectionColor;
    {$REGION ' �������� Connectable'}
      /// <summary> ������ ����� ���� �������� � ������� ��������� </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� Connectable'}
    property Connectable: boolean read FConnectable;
    {$REGION ' �������� Selectable'}
      /// <summary> ������ ����� ���� ������ </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� Selectable'}
    property Selectable: boolean read FSelectable;
    {$REGION ' �������� LogicalUnitRequired'}
      /// <summary> � ������� ������ ����������� ���� ���������� ������ </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� LogicalUnitRequired'}
    property LogicalUnitRequired: boolean read FLogicalUnitRequired;
    //
    {$REGION ' �������� Rotation'}
      /// <summary> ���� �������� ������� </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� Rotation'}
    property Rotation: integer read FRotation write SetRotation;
    {$REGION ' �������� Rotated'}
      /// <summary> �������� �� ������ </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� Rotated'}
    property Rotated: boolean read IsRotated;
    //
    {$REGION ' �������� VisualContainer'}
      /// <summary> ���������, � ������� ��������� ������ </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� VisualContainer'}
    property VisualContainer: TObject read FVisualContainer write SetVisualContainer;
  end;

  {$REGION ' �������� TVisualObjectClass'}
    /// <summary> ��������� ���������� �������� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� TVisualObjectClass'}
  TVisualObjectClass = class of TBaseVisualObject;

  {$REGION ' �������� TRectVisualObject'}
    /// <summary> ������� ����� ��� "�������������" �������� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� TRectVisualObject'}
  TRectVisualObject = class(TBaseVisualObject)
  private
    FConstructing: Boolean;
    FCurrentPoint: Integer;
    FText: String;
    procedure SetText(const Value: String);
    //
    function GetFontJson(): string; override;
  protected
    function GetVertexesCount: Integer; override;
    function GetVertex(Index: Integer): TFloatPoint; override;
    procedure SetVertex(Index: Integer; const Value: TFloatPoint); override;
  public
    {$REGION ' �������� VOCSideMove'}
      /// <summary> ������� ����������� ������� ������� </summary>
      ///   <param name="prmIndex"> ������ ������� </param>
      ///   <param name="prmNewPos"> ����� ������� </param>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� VOCSideMove'}
    procedure VOCSideMove(prmIndex: integer; prmNewPos: TFloatPoint); override;
    {$REGION ' �������� VOCHitTest'}
      /// <summary> ���������� �������� ������� �������, �������������� ���������� </summary>
      ///   <param name="prmConvertIntf"> ������, ����������� ������ �������������� ��������� </param>
      ///   <param name="prmParams"> ��������� (����������, ����������������) </param>
      /// <returns> cardinal </returns>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� VOCHitTest'}
    function VOCHitTest(prmConvertIntf: ICoordConvert;
      prmParams: THitTestParams): cardinal; override;
    {$REGION ' �������� VOCGetCursor'}
      /// <summary> ���������� ������ � ����������� �� ���������� </summary>
      ///   <param name="prmHitTest"> ��������� (����������, ����������������)  </param>
      /// <returns> cardinal </returns>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� VOCGetCursor'}
    function VOCGetCursor(prmHitTest: cardinal): cardinal; override;
    {$REGION ' �������� VOCConstructPoint'}
      /// <summary> ������� ��������� ����� ����� ������� </summary>
      ///   <param name="prmPos"> ������� ����� </param>
      /// <returns> cardinal </returns>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� VOCConstructPoint'}    
    function VOCConstructPoint(prmPos: TFloatPoint): cardinal; override;
    {$REGION ' �������� VOCProcessConstruct'}
      /// <summary> ����������� ���������� ������� �� ������ </summary>
      ///   <param name="prmPos"> ����� ������� �����  </param>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� VOCProcessConstruct'}    
    procedure VOCProcessConstruct(prmPos: TFloatPoint); override;
    {$REGION ' �������� VOCStopConstruct'}
      /// <summary> ����������� ���������� ������� </summary>
      /// <returns> cardinal </returns>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� VOCStopConstruct'}    
    function VOCStopConstruct(): cardinal; override;
    //
    {$REGION ' �������� GetText'}
      /// <summary> ���������� ����� ���� ��������� ����� �������� </summary>
      /// <returns> string </returns>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� GetText'}
    function GetText(): string; override;
    //
    {$REGION ' �������� Create'}
      /// <summary> ����������� ���������� ������ </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� Create'}
    constructor Create; override;
    {$REGION ' �������� Text'}
      /// <summary> ����� �������� </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� Text'}
    property Text: String read FText write SetText;
  end;

  {$REGION ' �������� TLineVisualObject'}
    /// <summary> ������� ����� ��� ��������-����� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� TLineVisualObject'}
  TLineVisualObject = class(TBaseVisualObject)
  private
    FConstructing: Boolean;
    FCurrentPoint: Integer;
    //
    function GetBrushJson(): string; override;
    function GetFontJson(): string; override;
  protected
    function GetVertexesCount: Integer; override;
    function GetVertex(Index: Integer): TFloatPoint; override;
    procedure SetVertex(Index: Integer; const Value: TFloatPoint); override;
    // ����������� ������� ���������� ���������������
    function NeedToStopConstruct(Count: Integer): Longint; virtual; abstract;
    //
    procedure SpecialDraw(Canvas: TLogicalCanvas); override;
  public
    {$REGION ' �������� VOCHitTest'}
      /// <summary> ���������� �������� ������� �������, �������������� ���������� </summary>
      ///   <param name="prmConvertIntf"> ������, ����������� ������ �������������� ��������� </param>
      ///   <param name="prmParams"> ��������� (����������, ����������������) </param>
      /// <returns> cardinal </returns>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� VOCHitTest'}  
    function VOCHitTest(prmConvertIntf: ICoordConvert;
      prmParams: THitTestParams): cardinal; override;
    {$REGION ' �������� VOCGetCursor'}
      /// <summary> ���������� ������ � ����������� �� ���������� </summary>
      ///   <param name="prmHitTest"> ��������� (����������, ����������������)  </param>
      /// <returns> cardinal </returns>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� VOCGetCursor'}
    function VOCGetCursor(prmHitTest: cardinal): cardinal; override;
    {$REGION ' �������� VOCConstructPoint'}
      /// <summary> ������� ��������� ����� ����� ������� </summary>
      ///   <param name="prmPos"> ������� ����� </param>
      /// <returns> cardinal </returns>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� VOCConstructPoint'}    
    function VOCConstructPoint(prmPos: TFloatPoint): cardinal; override;
    {$REGION ' �������� VOCProcessConstruct'}
      /// <summary> ����������� ���������� ������� �� ������ </summary>
      ///   <param name="prmPos"> ����� ������� �����  </param>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� VOCProcessConstruct'}    
    procedure VOCProcessConstruct(prmPos: TFloatPoint); override;
    {$REGION ' �������� VOCStopConstruct'}
      /// <summary> ����������� ���������� ������� </summary>
      /// <returns> cardinal </returns>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� VOCStopConstruct'}    
    function VOCStopConstruct(): cardinal; override;
  end;

  {$REGION ' �������� TSimpleLineBlock'}
    /// <summary> ������ ����� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� TSimpleLineBlock'}
  TSimpleLineBlock = class(TLineVisualObject)
  protected
    function NeedToStopConstruct(Count: Integer): Longint; override;
  public  
    {$REGION ' �������� Create'}
      /// <summary> ����������� ���������� ������ </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� Create'}
    constructor Create(); override;
  end;

  {$REGION ' �������� TPolyLineBlock'}
    /// <summary> ������ �������� ����� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� TPolyLineBlock'}
  TPolyLineBlock = class(TLineVisualObject)
  protected
    function NeedToStopConstruct(Count: Integer): Longint; override;
  public
    {$REGION ' �������� VOCVControl'}
      /// <summary> ���������� ��������� ������� </summary>
      ///   <param name="prmHitTest"> ��������� (����������, ����������������) </param>
      ///   <param name="prmPos"> ����� ������� </param>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� VOCVControl'}
    procedure VOCVControl(prmHitTest: Cardinal; prmPos: TFloatPoint); override;
    //
    {$REGION ' �������� Create'}
      /// <summary> ����������� ���������� ������ </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� Create'}
    constructor Create(); override;
  end;

  {$REGION ' �������� TRectangleBlock'}
    /// <summary> ������ ������������� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� TRectangleBlock'}
  TRectangleBlock = class(TRectVisualObject)
  protected
    procedure SpecialDraw(Canvas: TLogicalCanvas); override;
  public
    {$REGION ' �������� Create'}
      /// <summary> ����������� ���������� ������ </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� Create'}
    constructor Create(); override;
  end;

  {$REGION ' �������� TEllipseBlock'}
    /// <summary> ������ ������ </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� TEllipseBlock'}
  TEllipseBlock = class(TRectVisualObject)
  protected
    procedure SpecialDraw(Canvas: TLogicalCanvas); override;
  public
    {$REGION ' �������� Create'}
      /// <summary> ���������� ���������� ������ </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� Create'}
    constructor Create(); override;
  end;

  {$REGION ' �������� TTextBlock'}
    /// <summary> ������ ��������� ���� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� TTextBlock'}
  TTextBlock = class(TRectVisualObject)
  private
    function GetFontJson(): string; override;
  protected
    procedure SpecialDraw(Canvas: TLogicalCanvas); override;
    procedure SetRotation(Value: integer); override;
  public
    {$REGION ' �������� FieldName'}
      /// <summary>
      ///   ���� ��� �������������� ����� �� ��� ������ � �������
      ///   (���� UniqueName ����� ���� ������)
      /// </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� FieldName'}
    FieldName: string;
    {$REGION ' �������� MakeObjectFromJson'}
      /// <summary> ��������� ������� �� json-�������� </summary>
      ///   <param name="prmJsonObj"> json-������ </param>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� MakeObjectFromJson'}
    procedure MakeObjectFromJson(prmJsonObj: ISuperObject); override;
    {$REGION ' �������� GetObjectJson'}
      /// <summary> ���������� json-�������� ������������ ������� </summary>
      ///   <param name="OffsetX"> �������� ��������� �� X </param>
      ///   <param name="OffsetY"> �������� ��������� �� Y </param>
      /// <returns> string </returns>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� GetObjectJson'}
    function GetObjectJson(OffsetX, OffsetY: integer): string; override;
    {$REGION ' �������� Create'}
      /// <summary> ����������� ���������� ������ </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� Create'}
    constructor Create(); override;
  end;

  {$REGION ' �������� PTextField'}
    /// <summary> ��������� �� ��������� ���� �������� ������� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� PTextField'}
  PTextField = ^TTextField;
  {$REGION ' �������� TTextField'}
    /// <summary> �������� ���� �������� ������� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� TTextField'}
  TTextField = record
    Name: string;
    Text: string;
  end;

  // ����������� ������������� �������� �������
  {$REGION ' �������� TComplexFlyweight'}
    /// <summary> ����������� ������������ �������� ������� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� TComplexFlyweight'}
  TComplexFlyweight = class(TRectVisualObject)
    Primitives: TList;
    Width: integer;
    Height: integer;
    //
    procedure Draw(X, Y: extended; CDP: TComplexDrawParams);
    constructor Create(prmJson: string); reintroduce;
    destructor Destroy(); override;
  end;

  // ������� ������
  {$REGION ' �������� TComplexBlock'}
    /// <summary> ������ - �������, ���������, ������ </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� TComplexBlock'}
  TComplexBlock = class(TRectVisualObject)
    TextFields: TList;
    IsMouseOver: boolean;
    Connections: TList;
    //
    Flyweight: TComplexFlyweight;
    //
    function GetWidth(): integer;
    function GetHeight(): integer;
    function GetX(): integer;
    function GetY(): integer;
    //
    procedure AddConnection(CL: TConnectionLine); override;
    procedure DeleteConnection(CL: TConnectionLine); override;
    //
    function IsPointInside(X, Y: integer): boolean;
    //
    function CanBe1stConnObject(prmCL: TConnectionLine;
      prmHT: cardinal): boolean; override;
    function CanBe2ndConnObject(prmCL: TConnectionLine;
      prmHT: cardinal): boolean; override;
    //
    function CanStartConnect(prmCL: TConnectionLine): boolean; virtual;
    function StartConnection(prmCL: TConnectionLine): boolean; virtual;
    function CanFinishConnect(prmCL: TConnectionLine): boolean; virtual;
    function FinishConnection(prmCL: TConnectionLine): boolean; virtual;
    //
    function MakeLogicalUnit(): TPlantUnit; override;
    //
    function GetTextFieldsJson(): string;
    function GetObjectJson(OffsetX, OffsetY: integer): string; override;
    //
    {$REGION ' �������� MoveConnections'}
      /// <summary> �������� ����� ������� </summary>
      /// <returns> boolean </returns>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� MoveConnections'}
    function MoveConnections(): boolean;
    {$REGION ' �������� AlignConnections'}
      /// <summary> ������������ ������ ������� � ������ ���������� </summary>
      /// <returns> boolean </returns>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� AlignConnections'}
    function AlignConnections(): boolean;
    //
    function MoveWhileDrag(var prmMovingLines: TList; prmSchema: TObject): boolean; override;
    function FinishDrag(): boolean; override;
    function ArrangeConnections(): boolean; override;
    //
    procedure MakeTextFields();
    procedure MakeObjectFromJson(prmJsonObj: ISuperObject); override;
    //
    function FinishConstruct(var prmPU: TPlantUnit): boolean; override;
    //
    procedure Delete(var prmMovingCL: TList; var prmObjects: TList;
      var prmObjectsToFree: TList); override;
    //
    procedure AddTextField(pName, pText: string; pObject: TTextBlock);
    //
    function VOCHitTest(prmConvertIntf: ICoordConvert;
      prmParams: THitTestParams): cardinal; override;
    function VOCConstructPoint(prmPos: TFloatPoint): cardinal; override;
    //
    procedure SpecialDraw(Canvas: TLogicalCanvas); override;
    procedure DrawInComplex(Params: TComplexDrawParams); override;
    //
    procedure CheckErrors(var prmErrorsList: TStringList;
      var prmErrorObjects: TList; prmSchema: TObject); override;
    {$REGION ' �������� GetText'}
      /// <summary> ���������� ����� ���� ��������� ����� �������� </summary>
      /// <returns> string </returns>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� GetText'}
    function GetText(): string; override;
    //
    procedure AfterConstruction(); override;
    constructor Create(); override;
    destructor Destroy(); override;

    property Width: integer read GetWidth;
    property Height: integer read GetHeight;
    property X: integer read GetX;
    property Y: integer read GetY;
  end;

  {$REGION ' �������� TGraphFacility'}
    /// <summary> ���������� ������ - ��������� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� TGraphFacility'}
  TGraphFacility = class(TComplexBlock)
    constructor Create(); override;
  end;

  {$REGION ' �������� TGraphTank'}
    /// <summary> ���������� ������ - ��������� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� TGraphTank'}
  TGraphTank = class(TComplexBlock)
    function CanBe2ndConnObject(prmCL: TConnectionLine;
      prmHT: cardinal): boolean; override;
    function CanFinishConnect(prmCL: TConnectionLine): boolean; override;
    //
    constructor Create(); override;
  end;

  {$REGION ' �������� TGraphDivider'}
    /// <summary> ���������� ������ - ��������/�������� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� TGraphDivider'}
  TGraphDivider = class(TComplexBlock)
    constructor Create(); override;
  end;

  {$REGION ' �������� TGraphMeter'}
    /// <summary> ���������� ������ - ������������� ������ </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� TGraphMeter'}
  TGraphMeter = class(TComplexBlock)
    function CanBe2ndConnObject(prmCL: TConnectionLine;
      prmHT: cardinal): boolean; override;
    function CanStartConnect(prmCL: TConnectionLine): boolean; override;
    function StartConnection(prmCL: TConnectionLine): boolean; override;
    function CanFinishConnect(prmCL: TConnectionLine): boolean; override;
    //
    procedure IsTheSameSpecial(prmObject: TBaseVisualObject;
      var prmResult: boolean); override;
    //
    procedure CheckErrors(var prmErrorsList: TStringList;
      var prmErrorObjects: TList; prmSchema: TObject); override;
    //
    constructor Create(); override;
  end;

  {$REGION ' �������� TGraphValve'}
    /// <summary> ���������� ������ - �������� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� TGraphValve'}
  TGraphValve = class(TComplexBlock)
    constructor Create(); override;
  end;

  {$REGION ' �������� TGraphValveVertical'}
    /// <summary> ���������� ������ - ��������, ������������� ����������� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� TGraphValveVertical'}
  TGraphValveVertical = class(TGraphValve)
    constructor Create(); override;
    procedure AfterConstruction(); override;
  end;

  {$REGION ' �������� TGraphPump'}
    /// <summary> ���������� ������ - ����� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� TGraphPump'}
  TGraphPump = class(TComplexBlock)
    constructor Create(); override;
  end;

  {$REGION ' �������� TGraphRiser'}
    /// <summary> ���������� ������ - ����� ���������� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� TGraphRiser'}
  TGraphRiser = class(TComplexBlock)
    constructor Create(); override;
  end;

  {$REGION ' �������� TToolComplexBlock'}
    /// <summary> ������� ������ "���������������" </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� TToolComplexBlock'}
  TToolComplexBlock = class(TComplexBlock)
    function MakeLogicalUnit(): TPlantUnit; override;
  end;

  {$REGION ' �������� TConnectionPointBlock'}
    /// <summary> ������ ����� ���������� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� TConnectionPointBlock'}
  TConnectionPointBlock = class(TToolComplexBlock)
    function GetObjectJson(OffsetX, OffsetY: integer): string; override;
    procedure DrawInComplex(Params: TComplexDrawParams); override;
    constructor Create(); override;
  end;

  {$REGION ' �������� TFloodFillPointBlock'}
    /// <summary> ������ ��� ������������ �������� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� TFloodFillPointBlock'}
  TFloodFillPointBlock = class(TToolComplexBlock)
    FFloodFillBrush: TBrush;
    procedure SetFloodFillBrush(Value: TBrush);
    //
    function GetFloodFillJson(): string;
    function GetObjectJson(OffsetX, OffsetY: integer): string; override;
    //
    function GetPoint(): TFloatPoint;
    //
    constructor Create(); override;
    destructor Destroy(); override;
    procedure SpecialDraw(Canvas: TLogicalCanvas); override;
    procedure DrawInComplex(Params: TComplexDrawParams); override;
  public
    {$REGION ' �������� FillStyle'}
      /// <summary> ����� ���������� </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� FillStyle'}
    FillStyle: TFillStyle;
    {$REGION ' �������� FillColor'}
      /// <summary> ���� ���������� </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� FillColor'}
    FillColor: TColor;
    {$REGION ' �������� MakeObjectFromJson'}
      /// <summary> ��������� ������� �� json-�������� </summary>
      ///   <param name="prmJsonObj"> json-������ </param>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� MakeObjectFromJson'}
    procedure MakeObjectFromJson(prmJsonObj: ISuperObject); override;
    {$REGION ' �������� FloodFillBrush'}
      /// <summary> ����� ���������� </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� FloodFillBrush'}
    property FloodFillBrush: TBrush read FFloodFillBrush write SetFloodFillBrush;
    {$REGION ' �������� Point'}
      /// <summary> ����� ������ ������� </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� Point'}
    property Point: TFloatPoint read GetPoint;
  end;

  {$REGION ' �������� PIntersection'}
    /// <summary> ������ �� ������ ����������� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� PIntersection'}
  PIntersection = ^TIntersection;
  {$REGION ' �������� TIntersection'}
    /// <summary> ������ ����������� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� TIntersection'}
  TIntersection = record
    VertexID: integer;
    Line: TConnectionLine;
    Distance: integer;
    pt0, // ����������� ��������
    pt1, // ������� �����
    pt2, // ������ ������
    pt3, // ����� ����
    pt4  // ����� ����
    : TFloatPoint;
  end;
  {$REGION ' �������� TIntersections'}
    /// <summary> ������ ����������� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� TIntersections'}
  TIntersections = array of TIntersection;

  {$REGION ' �������� PMeterConnection'}
    /// <summary> ��������� �� ������ ���������� � ������������� �������� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� PMeterConnection'}
  PMeterConnection = ^TMeterConnection;
  {$REGION ' �������� TMeterConnection'}
    /// <summary>  ������ - ���������� � ������������� �������� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� TMeterConnection'}
  TMeterConnection = record
    Line: TConnectionLine;
    Vertex: integer;
    Scale: extended;
  end;
  {$REGION ' �������� TMeterConnections'}
    /// <summary> ������ ���������� � �������������� ��������� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� TMeterConnections'}
  TMeterConnections = array of TMeterConnection;

  {$REGION ' �������� TConnectionLine'}
    /// <summary> ������ - �������������� ����� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� TConnectionLine'}
  TConnectionLine = class(TPolyLineBlock)
    Object1: TBaseVisualObject;
    ConnPoint1: TBaseVisualObject;
    preObject1: TBaseVisualObject;
    HitTest1: Cardinal;
    //
    Object2: TBaseVisualObject;
    ConnPoint2: TBaseVisualObject;
    preObject2: TBaseVisualObject;
    HitTest2: Cardinal;
    //
    Intersections: TIntersections;
    MeterConnections: TList;
    //
    function Check(): boolean;
    function CanBe2ndConnObject(prmCL: TConnectionLine;
      prmHT: cardinal): boolean; override;
    procedure CheckState();
    function CheckDisconnection(): boolean;
    function ConnectObjects(var prmPU: TPlantUnit): boolean;
    procedure CheckAsMeterConnection();
    //
    function MakeLogicalUnit(): TPlantUnit; override;
    //
    procedure AddMeterConnection(pLine: TConnectionLine;
      pVertex: integer; pScale: extended);
    function GetMeterConnectionIndexByLine(Line: TConnectionLine): integer;
    procedure DeleteMeterConnection(Index: integer); overload;
    procedure DeleteMeterConnection(Line: TConnectionLine); overload;
    procedure RecountMeterConnections();
    //
    procedure DeleteConnection(CL: TConnectionLine); override;
    procedure Delete(var prmMovingCL: TList; var prmObjects: TList;
      var prmObjectsToFree: TList); override;
    //
    procedure ClearIntersections();
    function FindIntersections(prmCL2: TConnectionLine): boolean;
    procedure SortIntersections(min, max: Integer);
    //
    function VOCStopConstruct(): cardinal; override;
    //
    function CanStartConnect(prmCL: TConnectionLine; prmHT: Cardinal): boolean;
    function StartConnection(prmCL: TConnectionLine; prmHT: Cardinal): boolean;
    function CanFinishConnect(prmCL: TConnectionLine; prmHT: Cardinal): boolean;
    function FinishConnection(prmCL: TConnectionLine; prmHT: Cardinal;
      prmLX, prmLY: extended): boolean;
    //
    function MoveWhileDrag(var prmMovingLines: TList;
      prmSchema: TObject): boolean; override;
    function MoveWhileConstruct(prmSchema: TObject;
      X, Y: integer; flShift: boolean): boolean; override;
    function FinishDrag(): boolean; override;
    function ArrangeConnections(): boolean; override;
    //
    function FinishConstruct(var prmPU: TPlantUnit): boolean; override;
    //
    procedure ShiftDraw(prmShift: boolean;
      prmPos: TFloatPoint; prmStep: integer);
    //
    function GetConnectionJson(): string;
    function GetObjectJson(OffsetX, OffsetY: integer): string; override;
  protected
    procedure SpecialDraw(Canvas: TLogicalCanvas); override;
  public
    {$REGION ' �������� Direction'}
      /// <summary>
      ///   ����������� �����
      ///   0 - ��� �����������;
      ///   1 - �� ������ � �����;
      ///   2 - �� ����� � ������;
      /// </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� Direction'}
    Direction: byte;
    {$REGION ' �������� IsMeterConnector'}
      /// <summary> �������� �� ����������� � ������������� �������� </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� IsMeterConnector'}
    IsMeterConnector: boolean;
    {$REGION ' �������� State'}
      /// <summary>
      ///   ���������
      ///   0 - �� ���������, ���������� ����������� (������)
      ///   1 - ��� ��������������� - ���� �� ����������� �������� �� ���������
      ///   2 - ��� ��������������� - ��� ������� ����������
      ///   3 - �� ����� ��������� - ���������� �� ������������� (�. �. �������� �������)
      /// </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� State'}
    State: byte;
    //
    {$REGION ' �������� MakeObjectFromJson'}
      /// <summary> �������� ������� �� json-�������� </summary>
      ///   <param name="prmJsonObj"> json-������ </param>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� MakeObjectFromJson'}
    procedure MakeObjectFromJson(prmJsonObj: ISuperObject); override;
    //
    {$REGION ' �������� CheckErrors'}
      /// <summary> �������� ������� �� ������� ������ ��������������� </summary>
      ///   <param name="prmErrorsList"> ������ ������ </param>
      ///   <param name="prmErrorObjects"> ������ �������� � �������� </param>
      ///   <param name="prmSchema"> �����, ������� ����������� ������ </param>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� CheckErrors'}
    procedure CheckErrors(var prmErrorsList: TStringList;
      var prmErrorObjects: TList; prmSchema: TObject); override;
    //
    {$REGION ' �������� CheckIntersections'}
      /// <summary> ������� ����������� ����� � ������� ������� ����� </summary>
      ///   <param name="prmObjects"> ������ �������� ����� </param>
      /// <returns> boolean </returns>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� CheckIntersections'}
    function CheckIntersections(prmObjects: TList): boolean;
    {$REGION ' �������� FindConnectionObjects'}
      /// <summary> ����� ����� �������� ����� ���, � ������ ����� ���� ������������ ����� </summary>
      ///   <param name="prmSchema"> �����, ������� ����������� ������ </param>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� FindConnectionObjects'}
    procedure FindConnectionObjects(prmSchema: TObject);
    //
    {$REGION ' �������� Create'}
      /// <summary> ����������� ���������� ������� </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� Create'}
    constructor Create(); override;
    {$REGION ' �������� Destroy'}
      /// <summary> ���������� ���������� ������� </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� Destroy'}
    destructor Destroy(); override;
  end;

  {$REGION ' �������� TSelector'}
    /// <summary> �������� �������� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� TSelector'}
  TSelector = class(TRectVisualObject)
  protected
    procedure SpecialDraw(Canvas: TLogicalCanvas); override;
  public
    {$REGION ' �������� FinishConstruct'}
      /// <summary> �������� ��� ���������� �������� ������� </summary>
      ///   <param name="prmPU"> ��������� ���������� ������ </param>
      /// <returns> boolean </returns>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� FinishConstruct'}
    function FinishConstruct(var prmPU: TPlantUnit): boolean; override;
    {$REGION ' �������� Create'}
      /// <summary> ����������� ���������� ������ </summary>
      /// <author> evdokimov_v_i </author>
    {$ENDREGION ' �������� Create'}
    constructor Create(); override;
  end;

  {$REGION ' �������� GetVisualObjectClassByName'}
    /// <summary> ���������� ����� ������������ ������� �� ��� �������� </summary>
    ///   <param name="prmName"> �������� ������� </param>
    /// <returns> TVisualObjectClass </returns>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� GetVisualObjectClassByName'}
  function GetVisualObjectClassByName(prmName: string): TVisualObjectClass;

var
  {$REGION ' �������� flMultiselect'}
    /// <summary> ����, ��������������� � ���, ��� ������� ��������� �������� </summary>
    /// <author> evdokimov_v_i </author>
  {$ENDREGION ' �������� flMultiselect'}
  flMultiselect: boolean;

implementation

uses Messages, Math, RTLConsts, VisualUtils, VisualContainer;

function GetVisualObjectClassByName(prmName: string): TVisualObjectClass;
begin
  Result := TBaseVisualObject;
  //
  if prmName = 'Simple line' then Result := TSimpleLineBlock;
  if prmName = 'Poly line' then Result := TPolyLineBlock;
  if prmName = 'Rectangle' then Result := TRectangleBlock;
  if prmName = 'Ellipse' then Result := TEllipseBlock;
  if prmName = 'Text' then Result := TTextBlock;
  if prmName = 'Connection point' then Result := TConnectionPointBlock;
  if prmName = 'Flood fill point' then Result := TFloodFillPointBlock;
  //
  if prmName = 'Facility' then Result := TGraphFacility;
  if prmName = 'Tank' then Result := TGraphTank;
  if prmName = 'Divider' then Result := TGraphDivider;
  if prmName = 'Meter' then Result := TGraphMeter;
  if prmName = 'Valve' then Result := TGraphValve;
  if prmName = 'ValveVertical' then Result := TGraphValveVertical;
  if prmName = 'Pump' then Result := TGraphPump;
  if prmName = 'Riser' then Result := TGraphRiser;
  //
  if prmName = 'Connection line' then Result := TConnectionLine;
end;

{ TBaseVisualObject }

procedure TBaseVisualObject.AddBasePoint(X, Y: Extended);
var
  NewBasePoint: PFloatPoint;
begin
  // �������� ������ ��� ����� ����� � ��������� ��������� �� ��� � ������
  New(NewBasePoint);
  NewBasePoint^.X := X;
  NewBasePoint^.Y := Y;
  FBasePoints.Add(NewBasePoint);
  Change(1);
end;

procedure TBaseVisualObject.AddConnection(CL: TConnectionLine);
begin
  //
end;

procedure TBaseVisualObject.AddError(var prmErrorsList: TStringList;
  var prmErrorObjects: TList; prmErrorText: string);
begin
  if prmErrorObjects.IndexOf(Self) < 0 then
    prmErrorObjects.Add(Self);
  //
  prmErrorsList.Add(UniqueName + ': ' + prmErrorText + ';');
end;

function TBaseVisualObject.ArrangeConnections: boolean;
begin
  Result := false;
end;

procedure TBaseVisualObject.BeginUpdate(Sender: integer = 0);
begin
  Inc(FLockCount);
end;

function TBaseVisualObject.CanBe1stConnObject(prmCL: TConnectionLine;
  prmHT: cardinal): boolean;
begin
  Result := false;
end;

function TBaseVisualObject.CanBe2ndConnObject(prmCL: TConnectionLine;
  prmHT: cardinal): boolean;
begin
  Result := false;
end;

procedure TBaseVisualObject.Change(Sender: integer = 0);
begin
  if Assigned(FOnChange) and (FLockCount = 0) then
    FOnChange(Self);
end;

procedure TBaseVisualObject.CheckErrors(var prmErrorsList: TStringList;
  var prmErrorObjects: TList; prmSchema: TObject);
var VC: TVisualContainer;
begin
  if not Assigned(prmSchema) then exit;
  if not (prmSchema is TVisualContainer) then exit;
  //
  VC := TVisualContainer(prmSchema);
  //
  if FLogicalUnitRequired then
  begin
    if not Assigned(LogicalUnit) then
    begin
      AddError(prmErrorsList, prmErrorObjects, '���������� ������ �� ���������');
      exit;
    end;
    if VC.LogicalSchema.GetUnitByName(LogicalUnit.Name) = nil then
    begin
      AddError(prmErrorsList, prmErrorObjects, '���������� ������ �� ������');
      exit;
    end;
  end;
  //
end;

procedure TBaseVisualObject.ClearBasePoints;
var
  i: Integer;
begin
  // ����������� ������ ��� ������� ����� � ������� ������ �� ���������� �� ���
  for i := 0 to FBasePoints.Count - 1 do
    Dispose(PFloatPoint(FBasePoints[i]));
  FBasePoints.Clear;
  Change(2);
end;

constructor TBaseVisualObject.Create;
begin
  inherited Create;
  //
  FBasePoints := TList.Create;
  //
  FBrush := TBrush.Create;
  FPen := TPen.Create;
  FFont := TFont.Create;
  //
  FBrush.Color := clWhite;
  FBrush.Style := bsClear;
  //
  FPen.Color := clBlack;
  FPen.Mode := pmCopy;
  FPen.Style := psSolid;
  FPen.Width := 1;
  //
  FFont.Name := 'Tahoma';
  FFont.Color := clBlack;
  FFont.Style := FFont.Style - [fsBold, fsItalic, fsUnderline, fsStrikeOut];
  FFont.Size := 14;
  //
  DrawOffsetX := 0;
  DrawOffsetY := 0;
  //
  LogicalUnit := nil;
  //
  TypeName := '?';
  TypeID := -1;
  //
  FCanBeAligned := false;
  FSelectionColor := clLime;
  FConnectable := false;
  FSelectable := true;
  FLogicalUnitRequired := false;
  //
  FRotation := 0;
  //
  FVisualContainer := nil;
end;

procedure TBaseVisualObject.Delete(var prmMovingCL: TList; var prmObjects: TList;
  var prmObjectsToFree: TList);
begin
  AddItemToList(prmObjectsToFree, Self);
end;

procedure TBaseVisualObject.DeleteBasePoint(Index: Integer);
begin
  // ����������� ������, ���������� ��� �������� ��������� ������� �����, � �������
  // ��������� �� ������
  Dispose(PFloatPoint(FBasePoints[Index]));
  FBasePoints.Delete(Index);
  Change(3);
end;

procedure TBaseVisualObject.DeleteConnection(CL: TConnectionLine);
begin
  //
end;

destructor TBaseVisualObject.Destroy;
var
  i: Integer;
begin
  // ����� ������������ ������, ����������� ������ ��� �������
  for i := 0 to FBasePoints.Count - 1 do
    Dispose(PFloatPoint(FBasePoints[i]));
  FBasePoints.Free;
  //
  FFont.Free;
  FPen.Free;
  FBrush.Free;
  //
  inherited Destroy;
end;

function TBaseVisualObject.MoveWhileConstruct(prmSchema: TObject; X, Y: integer;
  flShift: boolean): boolean;
begin
  Result := false;
end;

function TBaseVisualObject.MoveWhileDrag(var prmMovingLines: TList;
  prmSchema: TObject): boolean;
begin
  Result := false;
end;

procedure TBaseVisualObject.AssignBrushPenFont(Canvas: TLogicalCanvas);
begin
  Canvas.FCanvas.Brush.Assign(Brush);
  Canvas.FCanvas.Pen.Assign(Pen);
  Canvas.FCanvas.Font.Assign(Font);
end;

procedure TBaseVisualObject.SpecialDraw(Canvas: TLogicalCanvas);
begin
  //
end;

procedure TBaseVisualObject.Draw(Canvas: TLogicalCanvas);
begin
  AssignBrushPenFont(Canvas);
  SpecialDraw(Canvas);
  DrawAsSelected(Canvas);
end;

procedure TBaseVisualObject.DrawAsSelected(Canvas: TLogicalCanvas);
var i: integer;
begin
  if (not IsSelected) or (not Selectable) then exit;
  //
  if flMultiselect
    then Canvas.FCanvas.Brush.Color := SelectionColor
    else Canvas.FCanvas.Brush.Color := MULTISELECT_COLOR;
  //
  Canvas.FCanvas.Brush.Style := bsSolid;
  Canvas.FCanvas.Pen.Style := psSolid;
  Canvas.FCanvas.Pen.Color := Canvas.FCanvas.Brush.Color;
  Canvas.FCanvas.Pen.Width := 1;
  //
  for i := 0 to VertexesCount - 1 do
    Canvas.DrawVertex(Vertex[i].X, Vertex[i].Y);
end;

procedure TBaseVisualObject.DrawInComplex(Params: TComplexDrawParams);
begin
  Params.Canvas.FCanvas.Brush.Assign(Brush);
  Params.Canvas.FCanvas.Pen.Assign(Pen);
  if not Params.IsActive then
    Params.Canvas.FCanvas.Pen.Color := INACTIVE_OBJECT_COLOR;
  Params.Canvas.FCanvas.Font.Assign(Font);
  //
  SpecialDraw(Params.Canvas);
  DrawAsSelected(Params.Canvas);
end;

procedure TBaseVisualObject.EndUpdate(Sender: integer = 0);
begin
  FLockCount := Max(0, FLockCount - 1);
  if FLockCount = 0 then
    Change(4);
end;

function TBaseVisualObject.FinishConstruct(var prmPU: TPlantUnit): boolean;
begin
  prmPU := nil;
  Result := true;
end;

function TBaseVisualObject.FinishDrag: boolean;
begin
  Result := true;
end;

function TBaseVisualObject.GetBasePoint(Index: Integer): TFloatPoint;
begin
  Result := PFloatPoint(FBasePoints[Index])^;
end;

function TBaseVisualObject.GetBasePointsCount: Integer;
begin
  Result := FBasePoints.Count;
end;

function TBaseVisualObject.GetBasePointsJson(OffsetX, OffsetY: integer): string;
var
  i: integer;
  s: string;
begin
  Result := '';
  //
  s := '';
  for i := 0 to BasePointsCount - 1 do
    s := s +
     '{"X": ' + inttostr(round(BasePoints[i].X + OffsetX)) + ', ' +
      '"Y": ' + inttostr(round(BasePoints[i].Y + OffsetY)) + '}, ';
  if s <> '' then s := copy(s, 1, length(s) - 2);
  //
  Result := '"BasePoints": [' + s + '], ';
end;

function TBaseVisualObject.GetBrushJson: string;
begin
  Result := '';
  //
  if not Assigned(FBrush) then exit;
  //
  Result :=
    '"Brush": {' +
      '"Color": "' + ColorToString(FBrush.Color) + '", ' +
      '"Style": ' + inttostr(Integer(FBrush.Style)) +
    '}, ';
end;

function TBaseVisualObject.GetCentralPoint: TFloatPoint;
begin
  Result.X := 0;
  Result.Y := 0;
  //
  if FBasePoints.Count < 2 then exit;
  //
  Result.X := BasePoints[0].X + (BasePoints[1].X - BasePoints[0].X) / 2;
  Result.Y := BasePoints[0].Y + (BasePoints[1].Y - BasePoints[0].Y) / 2;
end;

function TBaseVisualObject.GetCommonJson: string;
var s: string;
begin
  Result := '';
  //
  s := 'false';
  if (Self is TComplexBlock) then s := 'true';
  //
  Result :=
    '"Type": "' + TypeName + '", ' +
    '"IsComplex": ' + s + ', ' +
    '"UniqueName": "' + UniqueName + '", ';
  if Rotated then
    Result := Result + '"Rotation": ' + inttostr(Rotation) + ', ';
end;

function TBaseVisualObject.GetFontJson2(): string;
begin
  Result := '';
  //
  if not Assigned(FFont) then exit;
  //
  Result :=
    '"Font": {' +
      '"Name": "' + FFont.Name + '", ' +
      '"Size": "' + inttostr(FFont.Size) + '", ' +
      '"Color": "' + ColorToString(FFont.Color) + '"' +
    '}, ';
end;

function TBaseVisualObject.GetHitTest(prmCoordConvert: ICoordConvert;
  prmX, prmY, prmTolerance: integer): cardinal;
var HTP: THitTestParams;
begin
  HTP.XPos := prmX;
  HTP.YPos := prmY;
  HTP.Tolerance := prmTolerance;
  //
  Result := VOCHitTest(prmCoordConvert, HTP);
end;

function TBaseVisualObject.GetFontJson: string;
begin
  Result := GetFontJson2();
end;

function TBaseVisualObject.PrepareObjectJsonResult(prmResult: string): string;
begin
  if prmResult <> '' then Result := Copy(prmResult, 1, length(prmResult) - 2);
  Result := '{' + Result + '}';
end;

function TBaseVisualObject.GetObjectFullJson(OffsetX, OffsetY: integer): string;
var PU: TPlantUnit;
begin
  Result :=
    '{"Graphic": ' + GetObjectJson(OffsetX, OffsetY);
  if Assigned(LogicalUnit) then
  begin
    PU := LogicalUnit;
    //
    Result := Result +
      ', "Logic": {' +
            '"TypeID": ' + inttostr(integer(PU.UnitType)) + ', ' +
            '"Name": "' + PU.Name + '", ' +
            '"Description": "' + PU.Description + '", ' +
            '"GUID": "' + PU.UnitGUID + '", ' +
            '"JSON": ' + PU.MakeJSON() +
          '}';
  end;
  Result := Result + '}';
end;

function TBaseVisualObject.GetObjectJson(OffsetX, OffsetY: integer): string;
begin
  Result :=
    GetCommonJson() +
    GetBrushJson() +
    GetPenJson() +
    GetFontJson() +
    GetBasePointsJson(OffsetX, OffsetY);
  //
  Result := PrepareObjectJsonResult(Result);
end;

function TBaseVisualObject.GetPenJson: string;
begin
  Result := '';
  //
  if not Assigned(FPen) then exit;
  //
  Result :=
    '"Pen": {' +
      '"Color": "' + ColorToString(FPen.Color) + '", ' +
      '"Mode": ' + inttostr(Integer(FPen.Mode)) + ', ' +
      '"Style": ' + inttostr(Integer(FPen.Style)) + ', ' +
      '"Width": ' + inttostr(FPen.Width) +
    '}, ';
end;

function TBaseVisualObject.GetText: string;
begin
  Result := '';
end;

procedure TBaseVisualObject.InsertBasePoint(Index: Integer; X, Y: Extended);
var
  NewBasePoint: PFloatPoint;
begin
  // �������� ������ ��� ����� ����� � ��������� ��������� �� ��� � ������
  New(NewBasePoint);
  NewBasePoint^.X := X;
  NewBasePoint^.Y := Y;
  FBasePoints.Insert(Index, NewBasePoint);
  Change(5);
end;

function TBaseVisualObject.IsTheSame(prmObject: TBaseVisualObject): boolean;
begin
  Result := true;
  //
  IsTheSameSpecial(prmObject, Result);
end;

procedure TBaseVisualObject.IsTheSameSpecial(prmObject: TBaseVisualObject;
  var prmResult: boolean);
var s1, s2: string;
begin
  prmResult := prmResult and (TypeID = prmObject.TypeID);
  //
  s1 := AnsiUpperCase(trim(GetText()));
  s2 := AnsiUpperCase(trim(prmObject.GetText()));
  prmResult := prmResult and ((s1 <> '') and (s1 = s2));
end;

function TBaseVisualObject.IsInRect(x1, y1, x2, y2: integer): boolean;
var i: integer;
begin
  Result := true;
  //
  for i := 0 to BasePointsCount - 1 do
  begin
    if not (
        (x1 <= BasePoints[i].X) and (BasePoints[i].X <= x2) and
        (y1 <= BasePoints[i].Y) and (BasePoints[i].Y <= y2)
      ) then Result := false;
  end;
end;

function TBaseVisualObject.IsRotated: boolean;
begin
  Result := (FRotation <> 0);
end;

function TBaseVisualObject.IsTextExists(prmText: string): boolean;
var s: string;
begin
  Result := false;
  //
  s := GetText();
  if pos(prmText, s) > 0 then Result := true;
end;

procedure TBaseVisualObject.MakeBasePointsFromJson(prmJsonObj: ISuperObject);
var
  i: integer;
  jso: ISuperObject;
  jsa: TSuperArray;
  flp: TFloatPoint;
begin
  jsa := prmJsonObj.A['BasePoints'];
  if not Assigned(jsa) then exit;
  //
  for i := 0 to jsa.Length - 1 do
  begin
    jso := jsa[i];
    flp.X := jso.I['X'];
    flp.Y := jso.I['Y'];
    if FBasePoints.Count < i + 1
      then AddBasePoint(flp.X, flp.Y)
      else BasePoints[i] := flp;
  end;
end;

procedure TBaseVisualObject.MakeBrushPenFontFromJson(prmJsonObj: ISuperObject);
var jso: ISuperObject;
begin
  if Assigned(prmJsonObj.O['Brush']) then
  begin
    jso := prmJsonObj.O['Brush'];
    Brush.Color := StringToColor(jso.S['Color']);
    Brush.Style := TBrushStyle(jso.I['Style']);
  end;
  //
  if (Self is TConnectionLine)
    then jso := SO(FlyweightProvider.CONNECTION_LINE_PEN_JSON)
    else jso := prmJsonObj.O['Pen'];
  //  
  if Assigned(jso) then
  begin
    Pen.Color := StringToColor(jso.S['Color']);
    Pen.Mode := TPenMode(jso.I['Mode']);
    Pen.Style := TPenStyle(jso.I['Style']);
    Pen.Width := jso.I['Width'];
  end;
  //
  if Assigned(prmJsonObj.O['Font']) then
  begin
    jso := prmJsonObj.O['Font'];
    Font.Name := jso.S['Name'];
    Font.Size := jso.I['Size'];
    Font.Color := StringToColor(jso.S['Color']);
  end;
end;

function TBaseVisualObject.MakeLogicalUnit(): TPlantUnit;
begin
  Result := nil;
end;

procedure TBaseVisualObject.MakeObjectFromJson(prmJsonText: string);
var jso: ISuperObject;
begin
  jso := SO(prmJsonText);
  if (prmJsonText = '') or (not Assigned(jso)) then exit;
  //
  MakeObjectFromJson(jso);
end;

procedure TBaseVisualObject.MakeObjectFromJson(prmJsonObj: ISuperObject);
begin
  UniqueName := prmJsonObj.S['UniqueName'];
  //
  if Assigned(prmJsonObj.O['Rotation']) then
    Rotation := prmJsonObj.I['Rotation'];
  //
  MakeBasePointsFromJson(prmJsonObj);
  MakeBrushPenFontFromJson(prmJsonObj);
end;

procedure TBaseVisualObject.SetBasePoint(Index: Integer;
  const Value: TFloatPoint);
begin
  if ArePointsIdent(PFloatPoint(FBasePoints[Index])^, Value) then exit;
  //
  PFloatPoint(FBasePoints[Index])^ := Value;
  Change(6);
end;

procedure TBaseVisualObject.SetRotation(Value: integer);
begin
  raise Exception.Create('Rotation of this object is not supported!');
end;

procedure TBaseVisualObject.SetVisualContainer(Value: TObject);
begin
  if not Assigned(Value) then exit;
  if not (Value is TVisualContainer) then exit;
  //
  FVisualContainer := Value;
end;

procedure TBaseVisualObject.VOCBeginDrag(prmHitTest: Cardinal;
  prmStartPos: TFloatPoint);
begin
  FDragging := True;
  FDragHitTest := prmHitTest;
  FDragStartPos := prmStartPos;
end;

procedure TBaseVisualObject.VOCDrag(prmNewPos: TFloatPoint);
var
  HitTest: Cardinal;
  Index: Integer;
  DeltaX, DeltaY: Extended;
begin
  if FDragging then
  begin
    // ������������ FDragHitTest �� ����� ��� ������� � ������
    HitTest := FDragHitTest and $FFFF0000;
    Index := FDragHitTest and $0000FFFF;
    //
    // � ����������� �� ����, ��� ����� �������� ����, �������� ���������
    // �������
    case HitTest of
      HT_IN:
        begin
          // ���������� �������� ��������
          DeltaX := prmNewPos.X - FDragStartPos.X;
          DeltaY := prmNewPos.Y - FDragStartPos.Y;
          // � ��������� ��� �������� ����� ������� �� ������� �������
          FDragStartPos := prmNewPos;
          VOCMove(DeltaX, DeltaY);
        end;
      HT_VERTEX:
        VOCVertexMove(Index, prmNewPos);
      HT_SIDE:
        VOCSideMove(Index, prmNewPos);
    end;
  end;
end;

procedure TBaseVisualObject.VOCEndDrag();
begin
  FDragging := False;
end;

function TBaseVisualObject.VOCGetCursor(prmHitTest: cardinal): cardinal;
begin
  Result := CR_DEFAULT;
end;

function TBaseVisualObject.VOCHitTest(prmConvertIntf: ICoordConvert;
  prmParams: THitTestParams): cardinal;
begin
  Result := HT_OUT;
end;

procedure TBaseVisualObject.VOCMove(prmDeltaX, prmDeltaY: extended);
var
  i: Integer;
  Pos: TFloatPoint;
begin
  if (prmDeltaX = 0) and (prmDeltaY = 0) then exit;
  //
  BeginUpdate(1);
  try
    // ���������� ��� ������� �� �������� ��������
    for i := 0 to BasePointsCount - 1 do begin
      Pos := BasePoints[i];
      Pos.X := Pos.X + prmDeltaX;
      Pos.Y := Pos.Y + prmDeltaY;
      BasePoints[i] := Pos;
    end;
  finally
    EndUpdate;
  end;
end;

function TBaseVisualObject.VOCConstructPoint(prmPos: TFloatPoint): cardinal;
begin
  Result := 0;
end;

procedure TBaseVisualObject.VOCProcessConstruct(prmPos: TFloatPoint);
begin
  //
end;

procedure TBaseVisualObject.VOCSideMove(prmIndex: integer; prmNewPos: TFloatPoint);
begin
  //
end;

function TBaseVisualObject.VOCStopConstruct(): cardinal;
begin
  Result := 0;
end;

procedure TBaseVisualObject.VOCVControl(prmHitTest: Cardinal; prmPos: TFloatPoint);
begin
  //
end;

procedure TBaseVisualObject.VOCVertexMove(prmIndex: integer; prmNewPos: TFloatPoint);
begin
  if ArePointsIdent(Vertex[prmIndex], prmNewPos) then exit;
  //
  Vertex[prmIndex] := prmNewPos;
end;

{ TRectVisualObject }

constructor TRectVisualObject.Create;
begin
  inherited Create;
  BeginUpdate(); //
  AddBasePoint(0, 0);
  AddBasePoint(0, 0);
  EndUpdate(); // 
end;

function TRectVisualObject.GetFontJson: string;
begin
  Result := '';
end;

function TRectVisualObject.GetText: string;
begin
  Result := Text;
end;

function TRectVisualObject.GetVertex(Index: Integer): TFloatPoint;
begin
  // 0 - ����� ������� ����
  // 1 - ������ ������� ����
  // 2 - ������ ������ ����
  // 3 - ����� ������ ����
  case Index of
    0: Result := BasePoints[0];
    1:
      begin
        Result.X := BasePoints[1].X;
        Result.Y := BasePoints[0].Y;
      end;
    2: Result := BasePoints[1];
    3:
      begin
        Result.X := BasePoints[0].X;
        Result.Y := BasePoints[1].Y;
      end;
    else
      TList.Error(@SListIndexError, Index);
  end;
end;

function TRectVisualObject.GetVertexesCount: Integer;
begin
  Result := 4;
end;

procedure TRectVisualObject.SetText(const Value: String);
begin
  if FText <> Value then begin
    FText := Value;
    Change(7);
  end;
end;

procedure TRectVisualObject.SetVertex(Index: Integer;
  const Value: TFloatPoint);
var
  Point: TFloatPoint;
begin
  // ������������� ����� �������� ������� ������ � ������ ����, ��� 0-�� �����
  // ������ ������ ���� ����� � ���� 1-��
  case Index of
    0:
      begin
        Point := BasePoints[0];
        Point.X := Min(Value.X, BasePoints[1].X);
        Point.Y := Min(Value.Y, BasePoints[1].Y);
        BasePoints[0] := Point;
      end;
    1:
      begin
        Point := BasePoints[1];
        Point.X := Max(Value.X, BasePoints[0].X);
        BasePoints[1] := Point;
        Point := BasePoints[0];
        Point.Y := Min(Value.Y, BasePoints[1].Y);
        BasePoints[0] := Point;
      end;
    2:
      begin
        Point := BasePoints[1];
        Point.X := Max(Value.X, BasePoints[0].X);
        Point.Y := Max(Value.Y, BasePoints[0].Y);
        BasePoints[1] := Point;
      end;
    3:
      begin
        Point := BasePoints[0];
        Point.X := Min(Value.X, BasePoints[1].X);
        BasePoints[0] := Point;
        Point := BasePoints[1];
        Point.Y := Max(Value.Y, BasePoints[0].Y);
        BasePoints[1] := Point;
      end;
    else
      TList.Error(@SListIndexError, Index);
  end;
end;

function TRectVisualObject.VOCConstructPoint(prmPos: TFloatPoint): cardinal;
begin
  Result := 0;
  //
  // ���� ������ �� ��������� � ������ ��������������� - ��������� ��� � ����
  // ����� � ������������� ��������� ����� ������� ������������� �����
  if not FConstructing then
  begin
    FConstructing := True;
    FCurrentPoint := 0;
  end;
  // � ����������� �� ������ ������������� �����, ��������� ������ ��������
  // ����������������
  case FCurrentPoint of
    0:
      begin
        // ���������� ��� ����� ������� � ���������
        BasePoints[0] := prmPos;
        BasePoints[1] := prmPos;
        // ��������������� �� ��������
        Result := 1;
      end;
    1:
      begin
        // ���������� ����� � �������� 1
        BasePoints[1] := prmPos;
        // ��������������� ��������
        FConstructing := False;
        Result := 0;
      end;
  else
    TList.Error(@SListIndexError, FCurrentPoint);
  end;
  // ��������� ������� ������� �����
  Inc(FCurrentPoint);
end;

function TRectVisualObject.VOCGetCursor(prmHitTest: cardinal): cardinal;
begin
  case prmHitTest of
    HT_IN: Result := CR_SIZEALL;
    HT_VERTEX + 0, HT_VERTEX + 2: Result := CR_DIAG1;
    HT_VERTEX + 1, HT_VERTEX + 3: Result := CR_DIAG2;
    HT_SIDE + 0, HT_SIDE + 2: Result := CR_HORIZONTAL;
    HT_SIDE + 1, HT_SIDE + 3: Result := CR_VERTICAL;
  else
    Result := CR_DEFAULT;
  end;
end;

function TRectVisualObject.VOCHitTest(prmConvertIntf: ICoordConvert;
  prmParams: THitTestParams): cardinal;
var
  sX1, sY1, sX2, sY2: Integer;
begin
  // ��������� � �������� ����������
  prmConvertIntf.LogToScreen(BasePoints[0].X, BasePoints[0].Y, sX1, sY1);
  prmConvertIntf.LogToScreen(BasePoints[1].X, BasePoints[1].Y, sX2, sY2);
  // �������� ������� � �����
  Result := HT_OUT;
  if (Abs(prmParams.XPos - sX1) <= prmParams.Tolerance) and
     (Abs(prmParams.YPos - sY1) <= prmParams.Tolerance)
  then begin
    // ������� 0
    Result := HT_VERTEX + 0;
    exit;
  end else
  if (Abs(prmParams.XPos - sX2) <= prmParams.Tolerance) and
     (Abs(prmParams.YPos - sY1) <= prmParams.Tolerance)
  then begin
    // ������� 1
    Result := HT_VERTEX + 1;
    exit;
  end else
  if (Abs(prmParams.XPos - sX2) <= prmParams.Tolerance) and
     (Abs(prmParams.YPos - sY2) <= prmParams.Tolerance)
  then begin
    // ������� 2
    Result := HT_VERTEX + 2;
    exit;
  end else
  if (Abs(prmParams.XPos - sX1) <= prmParams.Tolerance) and
     (Abs(prmParams.YPos - sY2) <= prmParams.Tolerance)
  then begin
    // ������� 3
    Result := HT_VERTEX + 3;
    exit;
  end else
  if (Abs(prmParams.XPos - sX1) <= prmParams.Tolerance) and
     (prmParams.YPos > sY1) and (prmParams.YPos < sY2)
  then begin
    // ������� 0
    Result := HT_SIDE + 0;
    exit;
  end else
  if (Abs(prmParams.YPos - sY1) <= prmParams.Tolerance) and
     (prmParams.XPos > sX1) and (prmParams.XPos < sX2)
  then begin
    // ������� 1
    Result := HT_SIDE + 1;
    exit;
  end else
  if (Abs(prmParams.XPos - sX2) <= prmParams.Tolerance) and
     (prmParams.YPos > sY1) and (prmParams.YPos < sY2)
  then begin
    // ������� 2
    Result := HT_SIDE + 2;
    exit;
  end else
  if (Abs(prmParams.YPos - sY2) <= prmParams.Tolerance) and
     (prmParams.XPos > sX1) and (prmParams.XPos < sX2)
  then begin
    // ������� 1
    Result := HT_SIDE + 3;
    exit;
  end else
  if (prmParams.XPos > sX1) and (prmParams.XPos < sX2) and
     (prmParams.YPos > sY1) and (prmParams.YPos < sY2)
  then begin
    // ������
    Result := HT_IN;
    exit;
  end;
end;

procedure TRectVisualObject.VOCProcessConstruct(prmPos: TFloatPoint);
begin
  // ���������� �������, ��������������� ������� �����.
  if FConstructing then
    case FCurrentPoint of
      0: Vertex[0] := prmPos;
      1: Vertex[2] := prmPos;
    end;
end;

procedure TRectVisualObject.VOCSideMove(prmIndex: integer; prmNewPos: TFloatPoint);
var
  P0, P2: TFloatPoint;
  NX, NY: Extended;
begin
  P0 := Vertex[0];
  P2 := Vertex[2];
  NX := prmNewPos.X;
  NY := prmNewPos.Y;
  // 0 - ����� �������
  // 1 - ������� �������
  // 2 - ������ �������
  // 3 - ������ �������
  case prmIndex of
    0:
      begin
        if P0.X = NX then exit;
        P0.X := NX;
        Vertex[0] := P0;
      end;
    1:
      begin
        if P0.Y = NY then exit;
        P0.Y := NY;
        Vertex[0] := P0;
      end;
    2:
      begin
        if P2.X = NX then exit;
        P2.X := NX;
        Vertex[2] := P2;
      end;
    3:
      begin
        if P2.Y = NY then exit;
        P2.Y := NY;
        Vertex[2] := P2;
      end;
  else
    TList.Error(@SListIndexError, prmIndex);
  end;
end;

function TRectVisualObject.VOCStopConstruct(): cardinal;
begin
  Result := 1;
  if FConstructing then
  begin
    // ������� �� ������ ��������������� ������������� ���������� ��� � ���,
    // ��� ������ �� �������� �� �����
    FConstructing := False;
    Result := 0;
  end;
end;

{ TLineVisualObject }

procedure TLineVisualObject.SpecialDraw(Canvas: TLogicalCanvas);
var i: integer;
begin
  // ��������� ������� �������
  for i := 1 to VertexesCount - 1 do
    Canvas.DrawLine(
      Vertex[i - 1].X + DrawOffsetX,
      Vertex[i - 1].Y + DrawOffsetY,
      Vertex[i].X + DrawOffsetX,
      Vertex[i].Y + DrawOffsetY,
      Pen.Width);
end;

function TLineVisualObject.GetBrushJson: string;
begin
  Result := '';
end;

function TLineVisualObject.GetFontJson: string;
begin
  Result := '';
end;

function TLineVisualObject.GetVertex(Index: Integer): TFloatPoint;
begin
  Result := BasePoints[Index];
end;

function TLineVisualObject.GetVertexesCount: Integer;
begin
  Result := BasePointsCount;
end;

procedure TLineVisualObject.SetVertex(Index: Integer;
  const Value: TFloatPoint);
begin
  BasePoints[Index] := Value;
end;

function TLineVisualObject.VOCConstructPoint(prmPos: TFloatPoint): cardinal;
begin
  // ���� ��������������� ������ ������ - ��������� ������ � �����
  // ���������������, ������������� ��������� ��������� � ��������� ������ �����
  if not FConstructing then
  begin
    FConstructing := True;
    BeginUpdate(2);
    try
      ClearBasePoints;
      FCurrentPoint := 0;
      AddBasePoint(prmPos.X, prmPos.Y);
    finally
      EndUpdate;
    end;
  end;
  // ����� �� ������, ���������� �� ��������� ���������������, �������������
  // �� ����������� ����� NeedToStopConstruct
  Result := NeedToStopConstruct(FCurrentPoint + 1);
  //
  if Result = 0 then
  begin;
    FConstructing := False;
    exit;
  end;
  // ��������� ����� ����� � �������� ������ �������������
  AddBasePoint(prmPos.X, prmPos.Y);
  Inc(FCurrentPoint);
end;

function TLineVisualObject.VOCGetCursor(prmHitTest: cardinal): cardinal;
begin
  if prmHitTest <> HT_OUT then
    Result := CR_SIZEALL
  else
    Result := CR_DEFAULT;
end;

function TLineVisualObject.VOCHitTest(prmConvertIntf: ICoordConvert;
  prmParams: THitTestParams): cardinal;
var
  i, sX1, sY1, sX2, sY2: Integer;
  D: Extended;
begin
  Result := HT_OUT;
  for i := VertexesCount - 1 downto 0 do
  begin
    // ��������� � �������� ����������
    prmConvertIntf.LogToScreen(Vertex[i].X, Vertex[i].Y, sX1, sY1);
    if (Abs(prmParams.XPos - sX1) <= prmParams.Tolerance) and
       (Abs(prmParams.YPos - sY1) <= prmParams.Tolerance) then
    begin
      // ������� i
      Result := HT_VERTEX + i;
      exit;
    end;
  end;
  // �� �� ����� ��?
  for i := VertexesCount - 1 downto 1 do
  begin
    prmConvertIntf.LogToScreen(Vertex[i].X, Vertex[i].Y, sX1, sY1);
    prmConvertIntf.LogToScreen(Vertex[i - 1].X, Vertex[i - 1].Y, sX2, sY2);
    D := LineDistance(prmParams.XPos, prmParams.YPos, sX1, sY1, sX2, sY2);
    if D <= prmParams.Tolerance then
    begin
      // �� �����
      Result := HT_IN + i - 1;
      exit;
    end;
  end;
end;

procedure TLineVisualObject.VOCProcessConstruct(prmPos: TFloatPoint);
begin
  // ���������� ������� �����
  if FConstructing then
    BasePoints[FCurrentPoint] := prmPos;
end;

function TLineVisualObject.VOCStopConstruct(): cardinal;
begin
  Result := 1;
  if FConstructing then
  begin
    // ������� �� ������ ���������������, ������� ������� ����� � ����
    // ����������� ������ ���� ����� - ���������� 0
    FConstructing := False;
    DeleteBasePoint(FCurrentPoint);
    if VertexesCount < 2 then
      Result := 0;
  end;
end;

{ TSimpleLineBlock }

constructor TSimpleLineBlock.Create;
begin
  inherited;
  //
  TypeName := 'Simple line';
end;

function TSimpleLineBlock.NeedToStopConstruct(Count: Integer): Longint;
begin
  Result := IfThen(Count < 2, 1, 0);
end;

{ TPolyLineBlock }

constructor TPolyLineBlock.Create;
begin
  inherited;
  //
  TypeName := 'Poly line';
end;

function TPolyLineBlock.NeedToStopConstruct(Count: Integer): Longint;
begin
  // ��������� ��������������� ����� ������ � ������� ������� VOC_STOPCONSTRUCT
  Result := 1;
end;

procedure TPolyLineBlock.VOCVControl(prmHitTest: Cardinal; prmPos: TFloatPoint);
var
  HitTest: Cardinal;
  Index: Integer;
begin
  // ������������ Command.HitTest �� ����� ��� ������� � ������
  HitTest := prmHitTest and $FFFF0000;
  Index := prmHitTest and $0000FFFF;
  // � ����������� �� HitTest ��������� ��� ������� �������. ������� �� ���������
  // ���� �� ���������� ������ ������ ����.
  case HitTest of
    HT_IN: InsertBasePoint(
            Index + 1,
            prmPos.X,
            prmPos.Y);
    HT_VERTEX: if VertexesCount > 2 then DeleteBasePoint(Index);
  end;
end;

{ TRectangleBlock }

constructor TRectangleBlock.Create;
begin
  inherited;
  //
  TypeName := 'Rectangle';
end;

procedure TRectangleBlock.SpecialDraw(Canvas: TLogicalCanvas);
begin
  Canvas.DrawRect(
    BasePoints[0].X + DrawOffsetX,
    BasePoints[0].Y + DrawOffsetY,
    BasePoints[1].X + DrawOffsetX,
    BasePoints[1].Y + DrawOffsetY,
    FPen.Width);
end;

{ TEllipseBlock }

constructor TEllipseBlock.Create;
begin
  inherited;
  //
  TypeName := 'Ellipse';
end;

procedure TEllipseBlock.SpecialDraw(Canvas: TLogicalCanvas);
begin
  Canvas.DrawEllipse(
    BasePoints[0].X + DrawOffsetX,
    BasePoints[0].Y + DrawOffsetY,
    BasePoints[1].X + DrawOffsetX,
    BasePoints[1].Y + DrawOffsetY,
    FPen.Width);
end;

{ TTextBlock }

constructor TTextBlock.Create;
begin
  inherited;
  //
  TypeName := 'Text';
  FieldName := '';
end;

procedure TTextBlock.SetRotation(Value: integer);
begin
  if Between(Value, 0, 359) then FRotation := Value;
end;

procedure TTextBlock.SpecialDraw(Canvas: TLogicalCanvas);
var
  BMP: TBitmap;
  sx1, sy1, sx2, sy2, sw, sh: integer;
  lw, lh: extended;
  LC: TLogicalCanvas;
  //
  v_01, v_11, v_21, v_31,
  v_02, v_12, v_22, v_32,
  cp, lt, rb: TFloatPoint;
begin
  if Rotated then
  begin
    BMP := TBitmap.Create();
    LC := TLogicalCanvas.Create(BMP.Canvas, Canvas.ConvertIntf);
    try
      v_01 := Vertex[0];
      v_11 := Vertex[1];
      v_21 := Vertex[2];
      v_31 := Vertex[3];
      cp := GetCentralPoint();
      //
      CalcRotate(cp, v_01, DegToRad(FRotation), v_02);
      CalcRotate(cp, v_11, DegToRad(FRotation), v_12);
      CalcRotate(cp, v_21, DegToRad(FRotation), v_22);
      CalcRotate(cp, v_31, DegToRad(FRotation), v_32);
      //
      Canvas.FCanvas.Brush.Color := clRed;
      Canvas.FCanvas.Brush.Style := bsSolid;
      Canvas.FCanvas.Pen.Style := psSolid;
      Canvas.FCanvas.Pen.Color := Canvas.FCanvas.Brush.Color;
      Canvas.FCanvas.Pen.Width := 1;
      //
      {
      Canvas.DrawVertex(v_02.X, v_02.Y);
      Canvas.DrawVertex(v_12.X, v_12.Y);
      Canvas.DrawVertex(v_22.X, v_22.Y);
      Canvas.DrawVertex(v_32.X, v_32.Y);
      }
      //
      lt.X := ArrayMin([v_02.X, v_12.X, v_22.X, v_32.X]);
      lt.Y := ArrayMin([v_02.Y, v_12.Y, v_22.Y, v_32.Y]);
      rb.X := ArrayMax([v_02.X, v_12.X, v_22.X, v_32.X]);
      rb.Y := ArrayMax([v_02.Y, v_12.Y, v_22.Y, v_32.Y]);
      //
      Canvas.ConvertIntf.LogToScreen(BasePoints[0].X, BasePoints[0].Y, sx1, sy1);
      Canvas.ConvertIntf.LogToScreen(BasePoints[1].X, BasePoints[1].Y, sx2, sy2);
      //
      lw := BasePoints[1].X - BasePoints[0].X;
      lh := BasePoints[1].Y - BasePoints[0].Y;
      sw := sx2 - sx1;
      sh := sy2 - sy1;
      BMP.SetSize(sw, sh);
      BMP.TransparentColor := clWhite;
      BMP.Transparent := true;
      LC.FCanvas.Font.Assign(Font);
      LC.DrawText(0, 0, lw, lh, Font.Size, Text, true);
      RotateBitmap(BMP, FRotation, clWhite);
      //
      Canvas.DrawGraphic(lt.X, lt.Y, BMP);
    finally
      LC.Free;
      BMP.Free;
    end;
  end else
  begin
    Canvas.DrawText(
      BasePoints[0].X + DrawOffsetX,
      BasePoints[0].Y + DrawOffsetY,
      BasePoints[1].X + DrawOffsetX,
      BasePoints[1].Y + DrawOffsetY,
      Font.Size,
      Text);
  end;
end;

function TTextBlock.GetFontJson: string;
begin
  Result := GetFontJson2();
end;

function TTextBlock.GetObjectJson(OffsetX, OffsetY: integer): string;
var s: string;
begin
  s := StringReplace(trim(Text), #13#10, '<BR>', [rfReplaceAll, rfIgnoreCase]);
  //
  Result :=
    GetCommonJson() +
    GetFontJson() +
    '"Text": "' + s + '", ' +
    GetBasePointsJson(OffsetX, OffsetY);
  //
  Result := PrepareObjectJsonResult(Result);
end;

procedure TTextBlock.MakeObjectFromJson(prmJsonObj: ISuperObject);
begin
  inherited;
  //
  Text := StringReplace(prmJsonObj.S['Text'], '<BR>', #13#10,
    [rfReplaceAll, rfIgnoreCase]);
end;

{ TComplexBlock }

procedure TComplexBlock.Delete(var prmMovingCL: TList; var prmObjects: TList;
  var prmObjectsToFree: TList);
var CL: TConnectionLine;
begin
  inherited;
  //
  while Connections.Count > 0 do
  begin
    CL := TConnectionLine(Connections[0]);
    FillMovingLinesList(CL, prmMovingCL, prmObjects);
    prmMovingCL.Delete(prmMovingCL.IndexOf(CL));
    CL.Delete(prmMovingCL, prmObjects, prmObjectsToFree);
  end;
end;

procedure TComplexBlock.DeleteConnection(CL: TConnectionLine);
begin
  if not Assigned(CL) then exit;
  //
  if Connections.IndexOf(CL) < 0 then exit;
  //
  if Assigned(LogicalUnit) and Assigned(CL.LogicalUnit)
    then LogicalUnit.DeleteConnection(TPipe(CL.LogicalUnit));
  //
  if Assigned(CL.Object1) and (Cl.Object1 = Self) then CL.Object1 := nil;
  if Assigned(CL.Object2) and (CL.Object2 = Self) then CL.Object2 := nil;
  //
  Connections.Delete(Connections.IndexOf(CL));
end;

procedure TComplexBlock.AddConnection(CL: TConnectionLine);
begin
  if not Assigned(CL) then exit;
  //
  if Connections.IndexOf(CL) >= 0 then exit;
  //
  if Assigned(LogicalUnit) and Assigned(CL.LogicalUnit) then
    LogicalUnit.AddConnection(TPipe(CL.LogicalUnit));
  //
  Connections.Add(CL);
  //
  AlignConnections();
end;

procedure TComplexBlock.AddTextField(pName, pText: string; pObject: TTextBlock);
var
  NewTextField: PTextField;
begin
  New(NewTextField);
  NewTextField^.Name := pName;
  NewTextField^.Text := pText;
  TextFields.Add(NewTextField);
end;

procedure TComplexBlock.AfterConstruction;
begin
  inherited;
  //
  if (TypeID > 0) then
    Flyweight := FlyweightProvider.GetObjectJsonByID(TypeID).Flyweight;
  MakeTextFields();
end;

function TComplexBlock.CanBe1stConnObject(prmCL: TConnectionLine;
  prmHT: cardinal): boolean;
begin
  Result :=
    IsPointInside(
      round(prmCL.Vertex[0].X),
      round(prmCL.Vertex[0].Y));
  //Result := ((prmHT and $F0000000) = HT_IN);
end;

function TComplexBlock.CanBe2ndConnObject(prmCL: TConnectionLine;
  prmHT: cardinal): boolean;
begin
  // �� �������� ����������� �� ����� ���������� ������ � �����������
  Result := not prmCL.IsMeterConnector;
  Result := Result and
    IsPointInside(
      round(prmCL.Vertex[prmCL.VertexesCount - 1].X),
      round(prmCL.Vertex[prmCL.VertexesCount - 1].Y));
//  Result := Result and
//    ((prmHT and $F0000000) <> HT_OUT);
end;

function TComplexBlock.CanStartConnect(prmCL: TConnectionLine): boolean;
begin
  Result := true;
end;

procedure TComplexBlock.CheckErrors(var prmErrorsList: TStringList;
  var prmErrorObjects: TList; prmSchema: TObject);
var
  i, j: integer;
  PU: TPlantUnit;
  PNU: TPlantNodeUnit;
  MetersOwner: IMetersOwner;
  METLST: TMetersList;
  CL: TConnectionLine;
begin
  inherited CheckErrors(prmErrorsList, prmErrorObjects, prmSchema);
  //
  if prmErrorObjects.IndexOf(Self) >= 0 then exit;
  //
  if not Assigned(LogicalUnit) then exit;
  PU := LogicalUnit;
  //
  if TypeID <> integer(PU.UnitType)
    then AddError(prmErrorsList, prmErrorObjects,
      '���� �������� �� ��������� - ' +
      '���. ' + inttostr(integer(PU.UnitType)) + ', ' +
      '����. ' + inttostr(TypeID));
  //
  if (PU is TPlantNodeUnit) then
  begin
    PNU := TPlantNodeUnit(PU);
    i := PNU.PipesIn.Count + PNU.PipesOut.Count;
    if i <> Connections.Count
      then AddError(prmErrorsList, prmErrorObjects,
        '�� ��������� ���������� ���������� - ' +
        '���. ' + inttostr(i)+ ', ' +
        '����. ' + inttostr(Connections.Count));
  end;
  //
  if PU.IsMeterOwner(MetersOwner) then
  begin
    METLST := MetersOwner.GetMeters();
    //
    j := 0;
    for i := 0 to Connections.Count - 1 do
    begin
      CL := TConnectionLine(Connections[i]);
      //
      if not CL.IsMeterConnector then continue;
      if not (CL.Object1 is TGraphMeter) then continue;
      if not (CL.Object2 = Self) then continue;
      //
      if Assigned(CL.Object1.LogicalUnit) then
        if METLST.IsMeterExits(TMeter(CL.Object1.LogicalUnit))
          then inc(j);
    end;
    if j <> METLST.List.Count
      then AddError(prmErrorsList, prmErrorObjects,
        '�� ��������� ���������� ������������� �������� - ' +
        '���. ' +  inttostr(METLST.List.Count) + ', ' +
        '����. ' + inttostr(j));
  end;
end;

function TComplexBlock.StartConnection(prmCL: TConnectionLine): boolean;
begin
  prmCL.Object1 := Self;
  AddConnection(prmCL);
  //
  Result := AlignConnections();
end;

function TComplexBlock.CanFinishConnect(prmCL: TConnectionLine): boolean;
begin
  Result := true;
  //
  // �� �������� ����������� �� ����� ���������� ������ � �����������
  Result := not prmCL.IsMeterConnector;
  //
  if not Result then DeleteConnection(prmCL);
end;

function TComplexBlock.FinishConnection(prmCL: TConnectionLine): boolean;
begin
  Result := true;
  //
  prmCL.Object2 := Self;
  AddConnection(prmCL);
  //
  Result := AlignConnections();
end;

function TComplexBlock.FinishConstruct(var prmPU: TPlantUnit): boolean;
begin
  prmPU := MakeLogicalUnit();
  Result := true;            
end;

function TComplexBlock.FinishDrag: boolean;
begin
  Result := true;
  //
  MoveConnections();
  AlignConnections();
end;

function TComplexBlock.GetObjectJson(OffsetX, OffsetY: integer): string;
begin
  Result :=
    GetCommonJson() +
    GetBasePointsJson(OffsetX, OffsetY) +
    GetTextFieldsJson();
  //
  Result := PrepareObjectJsonResult(Result);
end;

function TComplexBlock.GetText: string;
var
  i: integer;
  s, s1: string;
begin
  s := '';
  for i := 0 to TextFields.Count - 1 do
  begin
    s1 := trim(PTextField(TextFields[i])^.Text);
    if s1 = '' then continue;
    s := s + ' ' + s1;
  end;
  Result := trim(s);
end;

function TComplexBlock.GetTextFieldsJson: string;
var
  i: integer;
  s, s2: string;
  TF: TTextField;
begin
  Result := '';
  //
  s2 := '';
  for i := 0 to TextFields.Count - 1 do
  begin
    TF := PTextField(TextFields[i])^;
    s := trim(TF.Text);
    s := StringReplace(s, #13#10, '<BR>', [rfReplaceAll, rfIgnoreCase]);
    s2 := s2 + '{"Name": "' + TF.Name + '", "Text": "' + s + '"}, ';
  end;
  if s2 <> '' then s2 := copy(s2, 1, length(s2) - 2);
  //
  Result := '"TextFields": [' + s2 + '], ';
end;

function TComplexBlock.GetWidth: integer;
begin
  Result := Flyweight.Width;
end;

function TComplexBlock.GetX: integer;
begin
  Result := Round(BasePoints[0].X);
end;

function TComplexBlock.GetY: integer;
begin
  Result := Round(BasePoints[0].Y);
end;

function TComplexBlock.GetHeight: integer;
begin
  Result := Flyweight.Height;
end;

constructor TComplexBlock.Create;
begin
  inherited;
  //
  IsMouseOver := false;
  Connections := TList.Create();
  TextFields := TList.Create();
  //
  FCanBeAligned := true;
  FSelectionColor := clRed;
  FConnectable := true;
  FLogicalUnitRequired := true;
  //
  TypeID := -1;
end;

destructor TComplexBlock.Destroy;
var i: integer;
begin
  for i := 0 to TextFields.Count - 1 do
    Dispose(PTextField(TextFields[i]));
  TextFields.Free;
  //
  while Connections.Count > 0 do
    DeleteConnection(TConnectionLine(Connections[0]));
  Connections.Clear;
  Connections.Free;
  //
  inherited;
end;

function TComplexBlock.MoveWhileDrag(var prmMovingLines: TList;
  prmSchema: TObject): boolean;
var
  i: integer;
  VC: TVisualContainer;
begin
  Result := false;
  //
  if (not Assigned(prmMovingLines)) or
     (not Assigned(prmSchema)) then exit;
  //
  VC := TVisualContainer(prmSchema);
  //
  if MoveConnections() then Result := true;
  if AlignConnections() then Result := true;
  //
  for i := 0 to Connections.Count - 1 do
    FillMovingLinesList(
      TConnectionLine(Connections[i]),
      prmMovingLines,
      VC.FObjects);
end;

procedure TComplexBlock.SpecialDraw(Canvas: TLogicalCanvas);
var
  i, j: integer;
  fl: boolean;
  CDP: TComplexDrawParams;
  TF: TTextField;
  TB: TTextBlock;
begin
  fl := true;
  if Assigned(Self.LogicalUnit) then
    fl := Self.LogicalUnit.Enabled;
  //
  CDP.Canvas := Canvas;
  CDP.IsActive := fl;
  CDP.IsMouseOver := IsMouseOver;
  //
  for i := 0 to TextFields.Count - 1 do
  begin
    TF := PTextField(TextFields[i])^;
    for j := 0 to Flyweight.Primitives.Count - 1 do
      if (TBaseVisualObject(Flyweight.Primitives[j]) is TTextBlock) then
      begin
        TB := TTextBlock(Flyweight.Primitives[j]);
        if TB.FieldName = TF.Name
          then TB.Text := TF.Text;
      end;
  end;
  //
  Flyweight.Draw(
    X + DrawOffsetX,
    Y + DrawOffsetY,
    CDP);
end;

procedure TComplexBlock.DrawInComplex(Params: TComplexDrawParams);
begin
  inherited;
  //
end;

function TComplexBlock.IsPointInside(X, Y: integer): boolean;
begin
  Result :=
    (X >= Self.X) and (X <= Self.X + Self.Width) and
    (Y >= Self.Y) and (Y <= Self.Y + Self.Height);
end;

function TComplexBlock.MakeLogicalUnit(): TPlantUnit;
var
  PU: TPlantUnit;
  PUCL: TPlantUnitClass;
begin
  Result := nil;
  //
  PUCL := GetPlantUnitClassByID(TypeID);
  PU := PUCL.Create(
    UniqueName,
    UniqueName,
    '');
  //
  LogicalUnit := PU;
  PU.GraphicUnit := Self;
  //
  Result := PU;
end;

procedure TComplexBlock.MakeObjectFromJson(prmJsonObj: ISuperObject);
var
  txt_n, txt_t: string;
  i, j: integer;
  jso: ISuperObject;
  tf_jsa: TSuperArray;
begin
  inherited;
  //
  tf_jsa := prmJsonObj.A['TextFields'];
  if Assigned(tf_jsa) then
  begin
    for i := 0 to tf_jsa.Length - 1 do
    begin
      jso := tf_jsa[i];
      txt_n := jso.S['Name'];
      txt_t := jso.S['Text'];
      txt_t := StringReplace(txt_t, '<BR>', #13#10, [rfReplaceAll, rfIgnoreCase]);
      for j := 0 to TextFields.Count - 1 do
        if PTextField(TextFields[j])^.Name = txt_n then
        begin
          PTextField(TextFields[j])^.Text := txt_t;
          break;
        end;
    end;
  end;
end;

procedure TComplexBlock.MakeTextFields;
var
  i: integer;
  BVO: TBaseVisualObject;
begin
  if not Assigned(Flyweight) then exit;
  //
  for i := 0 to Flyweight.Primitives.Count - 1 do
  begin
    BVO := TBaseVisualObject(Flyweight.Primitives[i]);
    if not (BVO is TTextBlock) then continue;
    //
    AddTextField(
      TTextBlock(BVO).FieldName,
      TTextBlock(BVO).FieldName,
      TTextBlock(BVO));
  end;
end;

function TComplexBlock.MoveConnections: boolean;
var
  i: integer;
  CL: TConnectionLine;
  fp: TFloatPoint;
  fl: boolean;

  function MovePoint(prmCPB: TBaseVisualObject; prmPIndex: integer): boolean;
  var CPB: TConnectionPointBlock;
  begin
    CPB := TConnectionPointBlock(prmCPB);
    Result := false;
    fp.X := X + CPB.X + round(CPB.Width / 2);
    fp.Y := Y + CPB.Y + round(CPB.Height / 2);
    if (CL.Vertex[prmPIndex].X = fp.X) and
       (CL.Vertex[prmPIndex].Y = fp.Y) then exit;
    CL.SetVertex(prmPIndex, fp);
    Result := true;
  end;

begin
  Result := false;
  for i := 0 to Connections.Count - 1 do
  begin
    CL := TConnectionLine(Connections[i]);
    fl := false;
    //
    if (not Assigned(CL.Object1)) and
       (not Assigned(CL.Object2)) then continue;
    //
    if CL.Object1 = Self then
      if MovePoint(CL.ConnPoint1, 0) then fl := true;
    if CL.Object2 = Self then
      if MovePoint(CL.ConnPoint2, CL.BasePointsCount - 1) then fl := true;
    //
    if fl then CL.RecountMeterConnections();
    if fl then Result := true;
  end;
end;

function TComplexBlock.AlignConnections(): boolean;
var
  i: integer;
  CL: TConnectionLine;

  function AlignVertex(pPointIndex, pObjectNo: integer): boolean;
  var
    j, cnp_indx: integer;
    BVO: TBaseVisualObject;
    CNP, CNPc: TConnectionPointBlock;
    cpcX, cpcY, cpcXc, cpcYc, dmin, d: integer;
    bp, fp: TFloatPoint;
  begin
    Result := false;
    //
    dmin := 10000;
    cnp_indx := -1;
    for j := 0 to Flyweight.Primitives.Count - 1 do
    begin
      BVO := TBaseVisualObject(Flyweight.Primitives[j]);
      if not (BVO is TConnectionPointBlock) then continue;
      //
      CNP := TConnectionPointBlock(BVO);
      //
      cpcX := X + CNP.X + round(CNP.Width / 2);
      cpcY := Y + CNP.Y + round(CNP.Height / 2);
      //
      bp := CL.GetVertex(pPointIndex);
      d := round(sqrt(sqr(cpcX - bp.X) + sqr(cpcY - bp.Y)));
      if d < dmin then
      begin
        dmin := d;
        cnp_indx := j;
        cpcXc := cpcX;
        cpcYc := cpcY;
        CNPc := CNP;
      end;
    end;
    //
    if cnp_indx >= 0 then
    begin
      if (pObjectNo = 1) and (CL.ConnPoint1 <> CNPc) then
      begin
        CL.ConnPoint1 := CNPc;
        Result := true;
      end;
      if (pObjectNo = 2) and (CL.ConnPoint2 <> CNPc) then
      begin
        CL.ConnPoint2 := CNPc;
        Result := true;       
      end;
      //
      fp.X := cpcXc;
      fp.Y := cpcYc;
      if (CL.Vertex[pPointIndex].X <> fp.X) or
         (CL.Vertex[pPointIndex].Y <> fp.Y) then
      begin
        Result := true;
        CL.SetVertex(pPointIndex, fp);
      end; 
    end;
  end;

begin
  Result := false;
  for i := 0 to Connections.Count - 1 do
  begin
    CL := TConnectionLine(Connections[i]);
    if CL.VertexesCount <= 0 then continue;
    //
    if (not Assigned(CL.Object1)) and
       (not Assigned(CL.Object2)) then continue;
    //
    if CL.Object1 = Self then
      if AlignVertex(0, 1) then Result := true;
    if CL.Object2 = Self then
      if AlignVertex(CL.BasePointsCount - 1, 2) then Result := true;
  end;
end;

function TComplexBlock.ArrangeConnections: boolean;
begin
  Result := AlignConnections();
end;

function TComplexBlock.VOCConstructPoint(prmPos: TFloatPoint): cardinal;
var p: TFloatPoint;
begin
  BasePoints[0] := prmPos;
  p.X := prmPos.X + Width;
  p.Y := prmPos.Y + Height;
  BasePoints[1] := p;
  //
  FConstructing := false;
  Result := 0;
end;

function TComplexBlock.VOCHitTest(prmConvertIntf: ICoordConvert;
  prmParams: THitTestParams): cardinal;
var
  sX1, sY1, sX2, sY2: Integer;
begin
  // ��������� � �������� ����������
  prmConvertIntf.LogToScreen(BasePoints[0].X, BasePoints[0].Y, sX1, sY1);
  prmConvertIntf.LogToScreen(BasePoints[1].X, BasePoints[1].Y, sX2, sY2);
  // �������� ������� � �����
  Result := HT_OUT;
  if (prmParams.XPos > sX1) and (prmParams.XPos < sX2) and
     (prmParams.YPos > sY1) and (prmParams.YPos < sY2)
    then Result := HT_IN;
end;

{ TConnectionPointBlock }

constructor TConnectionPointBlock.Create;
begin
  inherited;
  //
  TypeName := 'Connection point';
  //
  Flyweight := FlyweightProvider.CONNECTION_POINT_FLYWEIGHT;
end;

procedure TConnectionPointBlock.DrawInComplex(Params: TComplexDrawParams);
begin
  if Params.IsMouseOver then
    Draw(Params.Canvas);
end;

function TConnectionPointBlock.GetObjectJson(OffsetX, OffsetY: integer): string;
begin
  Result :=
    GetCommonJson() +
    GetBasePointsJson(OffsetX, OffsetY);
  //
  Result := PrepareObjectJsonResult(Result);
end;

{ TConnectionLine }

constructor TConnectionLine.Create();
begin
  inherited;
  //
  MeterConnections := TList.Create;
  Direction := 1;
  State := 0;
  IsMeterConnector := false;
  //
  FLogicalUnitRequired := true;
  //
  TypeName := 'Connection line';
  TypeID := 4;
end;

procedure TConnectionLine.DeleteMeterConnection(Index: integer);
begin
  if (Index < 0) or (Index >= MeterConnections.Count) then exit;
  //
  Dispose(PMeterConnection(MeterConnections[Index]));
  MeterConnections.Delete(Index);
end;

procedure TConnectionLine.Delete(var prmMovingCL: TList; var prmObjects: TList;
  var prmObjectsToFree: TList);
var MC: TMeterConnection;
begin
  inherited;
  //
  FillMovingLinesList(Self, prmMovingCL, prmObjects);
  prmMovingCL.Delete(prmMovingCL.IndexOf(Self));
  //
  while MeterConnections.Count > 0 do
  begin
    MC := PMeterConnection(MeterConnections[0])^;
    MC.Line.Delete(prmMovingCL, prmObjects, prmObjectsToFree);
    DeleteMeterConnection(0);
  end;
  //
  if Assigned(Object1) then Object1.DeleteConnection(Self);
  if Assigned(Object2) then Object2.DeleteConnection(Self);
end;

procedure TConnectionLine.DeleteConnection(CL: TConnectionLine);
begin
  inherited;
  //
  DeleteMeterConnection(CL);
end;

procedure TConnectionLine.DeleteMeterConnection(Line: TConnectionLine);
var i: integer;
begin
  if Assigned(LogicalUnit) and Assigned(Line.LogicalUnit) then
    LogicalUnit.DeleteMeterConnection(TPipe(Line.LogicalUnit));
  //
  while true do
  begin
    i := GetMeterConnectionIndexByLine(Line);
    if i >= 0
      then DeleteMeterConnection(i)
      else break;
  end;
end;

destructor TConnectionLine.Destroy;
var i: integer;
begin
  //
  for i := 0 to MeterConnections.Count - 1 do
    Dispose(PMeterConnection(MeterConnections[i]));
  MeterConnections.Free;
  //
  inherited;
end;

function TConnectionLine.MoveWhileConstruct(prmSchema: TObject; X, Y: integer;
  flShift: boolean): boolean;
var
  Pos: TFloatPoint;
  step: Integer;
  VC: TVisualContainer;
begin
  Result := false;
  //
  if not Assigned(prmSchema) then exit;
  VC := TVisualContainer(prmSchema);
  //
  VC.ScreenToLog(X, Y, Pos.X, Pos.Y);
  step := VC.ApplyGridStep(Pos);
  //
  ShiftDraw(flShift, Pos, step);
  CheckIntersections(VC.FObjects);
  FindConnectionObjects(VC);
  //
  Result := true;
end;

function TConnectionLine.MoveWhileDrag(var prmMovingLines: TList;
  prmSchema: TObject): boolean;
var VC: TVisualContainer;
begin
  Result := false;
  //
  if (not Assigned(prmMovingLines)) or
     (not Assigned(prmSchema)) then exit;
  //
  VC := TVisualContainer(prmSchema);
  //
  FindConnectionObjects(VC);
  //
  // ������������� ���������� � ��
  RecountMeterConnections();
  //
  // ����������� �������������� �����
  FillMovingLinesList(Self, prmMovingLines, VC.FObjects);
  //
  Result := true;
end;

procedure TConnectionLine.SpecialDraw(Canvas: TLogicalCanvas);
var
  i, j: integer;
  alpha: extended;
  CD, BD: extended;
  //
  pt01, pt02, pt02_,
  pt111, pt11, pt211, pt21,
  arc_pt1, arc_pt2: TFloatPoint;
  lenAB: extended;
  //
  parr: TPointsArray;
  fl: boolean;
  //
  mul: integer;
  pt: TFloatPoint;
  clr: TColor;
begin
  //
  clr := clBlack;
  case State of
    0: clr := clBlack;
    1: clr := clRed;
    2: clr := clGreen;
    3: clr := INACTIVE_OBJECT_COLOR;
  end;
  //
  if (LogicalUnit <> nil) then
    if TPipe(LogicalUnit).Flow = 0 then clr := INACTIVE_OBJECT_COLOR;
  //
  Canvas.FCanvas.Pen.Style := psSolid;
  Canvas.FCanvas.Pen.Color := clr;
  Canvas.FCanvas.Brush.Style := bsSolid;
  Canvas.FCanvas.Brush.Color := clr;
  // ��������� ������� �������
  for i := 1 to VertexesCount - 1 do
  begin
    fl := true;
    //
    for j := 0 to length(Intersections) - 1 do
      if Intersections[j].VertexID = i - 1 then
      begin
        if fl then
        begin
          pt01 := Vertex[i - 1];
          fl := false;
        end;
        Canvas.DrawLine(
          pt01.X + DrawOffsetX,
          pt01.Y + DrawOffsetY,
          Intersections[j].pt3.X + DrawOffsetX,
          Intersections[j].pt3.Y + DrawOffsetY,
          Pen.Width);
        //
        if Vertex[i - 1].X > Vertex[i].X  then
        begin
          arc_pt1 := Intersections[j].pt4;
          arc_pt2 := Intersections[j].pt3;
        end else
        begin
          arc_pt1 := Intersections[j].pt3;
          arc_pt2 := Intersections[j].pt4;
        end;
        //
        Canvas.DrawArc(
          Intersections[j].pt1.X + DrawOffsetX,
          Intersections[j].pt1.Y + DrawOffsetY,
          Intersections[j].pt2.X + DrawOffsetX,
          Intersections[j].pt2.Y + DrawOffsetY,
          arc_pt2.X + DrawOffsetX,
          arc_pt2.Y + DrawOffsetY,
          arc_pt1.X + DrawOffsetX,
          arc_pt1.Y + DrawOffsetY,
          Pen.Width);
        //
        pt01 := Intersections[j].pt4;
      end;
    if not fl then
    begin
      Canvas.DrawLine(
        pt01.X + DrawOffsetX,
        pt01.Y + DrawOffsetY,
        Vertex[i].X + DrawOffsetX,
        Vertex[i].Y + DrawOffsetY,
        Pen.Width);
    end;
    //
    if fl then
      Canvas.DrawLine(
        Vertex[i - 1].X + DrawOffsetX,
        Vertex[i - 1].Y + DrawOffsetY,
        Vertex[i].X + DrawOffsetX,
        Vertex[i].Y + DrawOffsetY,
        Pen.Width);
  end;
  //
  CD := 3;
  BD := 10;
  //
  if (BasePointsCount >= 2) and (Direction > 0) and (not IsMeterConnector) then
  begin
    SetLength(parr, 3);
    mul := 1;

    if direction = 1 then
    begin
      pt01 := BasePoints[BasePointsCount - 2];
      pt02 := BasePoints[BasePointsCount - 1];
      parr[0].X := pt02.X + DrawOffsetX;
      parr[0].Y := pt02.Y + DrawOffsetX;
      mul := 1;
      pt := pt02;
    end;

    if direction = 2 then
    begin
      pt01 := BasePoints[0];
      pt02 := BasePoints[1];
      parr[0].X := pt01.X + DrawOffsetX;
      parr[0].Y := pt01.Y + DrawOffsetX;
      mul := -1;
      pt := pt01;
    end;

    if (pt01.X = pt02.X) and (pt01.Y >= pt02.Y) then
    begin
      pt11.X := pt01.X - CD;
      pt11.Y := pt.Y + mul * BD;
      pt21.X := pt01.X + CD;
      pt21.Y := pt11.Y;
    end else
    if (pt01.X = pt02.X) and (pt01.Y <= pt02.Y) then
    begin
      pt11.X := pt01.X + CD;
      pt11.Y := pt.Y - mul * BD;
      pt21.X := pt01.X - CD;
      pt21.Y := pt11.Y;
    end else
    if (pt01.Y = pt02.Y) and (pt01.X > pt02.X) then
    begin
      pt11.X := pt.X + mul * BD;
      pt11.Y := pt.Y + CD;
      pt21.X := pt11.X;
      pt21.Y := pt02.Y - CD;
    end else
    begin
      lenAB := sqrt(sqr(pt01.X - pt02.X) + sqr(pt01.Y - pt02.Y)); // ����� �������
      alpha := GetAngle(pt01, pt02);
      alpha := GetAngleWQ(pt01, pt02, alpha);
      //
      if direction = 1 then
        pt02_.X := pt01.X + lenAB;
      if direction = 2 then
        pt02_.X := pt01.X + BD * 2;
      pt02_.Y := pt01.Y;
      //
      pt111.X := pt02_.X - BD;
      pt111.Y := pt02_.Y - CD;
      //
      pt211.X := pt02_.X - BD;
      pt211.Y := pt02_.Y + CD;
      //
      CalcRotate(pt01, pt111, alpha, pt11);
      CalcRotate(pt01, pt211, alpha, pt21);
    end;
    //
    parr[1].X := pt11.X + DrawOffsetX;
    parr[1].Y := pt11.Y + DrawOffsetX;
    parr[2].X := pt21.X + DrawOffsetX;
    parr[2].Y := pt21.Y + DrawOffsetX;
    //
    Canvas.DrawPolygon(
      parr,
      Pen.Width);
  end;
  //
  if IsMeterConnector then
  begin
    pt := BasePoints[BasePointsCount - 1];
    Canvas.DrawEllipse(pt.X - 3, pt.Y - 3, pt.X + 3, pt.Y + 3, Pen.Width);
  end;
end;

procedure TConnectionLine.FindConnectionObjects(prmSchema: TObject);
var
  BVO: TBaseVisualObject;
  connX1, connY1, connX2, connY2: integer;
  i: integer;
  HT1, HT2: Cardinal;
  HTP1, HTP2: THitTestParams;
  VC: TVisualContainer;
begin
  if VertexesCount <= 0 then exit;
  //
  VC := TVisualContainer(prmSchema);
  //
  connX1 := round(Vertex[0].X);
  connY1 := round(Vertex[0].Y);
  connX2 := round(Vertex[VertexesCount - 1].X);
  connY2 := round(Vertex[VertexesCount - 1].Y);
  //
  preObject1 := nil;
  HitTest1 := 0;
  preObject2 := nil;
  HitTest2 := 0;
  //
  VC.LogToScreen(connX1, connY1, HTP1.XPos, HTP1.YPos);
  VC.LogToScreen(connX2, connY2, HTP2.XPos, HTP2.YPos);
  //
  for i := 0 to VC.FObjects.Count - 1 do
  begin
    BVO := TBaseVisualObject(VC.FObjects[i]);
    if BVO = Self then continue;    
    //
    HT1 := BVO.GetHitTest(VC, HTP1.XPos, HTP1.YPos);
    HT2 := BVO.GetHitTest(VC, HTP2.XPos, HTP2.YPos);
    //
    if not Assigned(preObject1) then
      if BVO.CanBe1stConnObject(Self, HT1) then
      begin
        preObject1 := BVO;
        HitTest1 := HT1
      end;
    //
    if not Assigned(preObject2) then
      if BVO.CanBe2ndConnObject(Self, HT2) then
      begin
        preObject2 := BVO;
        HitTest2 := HT2;
      end;
    //
    if Assigned(preObject1) and Assigned(preObject2) then break;
  end;
  //
  CheckState();
end;

function TConnectionLine.FindIntersections(prmCL2: TConnectionLine): boolean;
var
  i, j, k, m, n: integer;
  pt, pt1, pt2, pt3, pt4, tmp: TFloatPoint;
  dx1, dy1, dx2, dy2: extended;
  fl: boolean;
  //
  alpha, lenAB, AE, BE, BE_AE: extended;
  pt2_: TFloatPoint;
  pt011, pt012, pt021, pt022,
  pt031, pt032, pt041, pt042: TFloatPoint;
  delta: extended;
  //
  ptc1, ptc2, ptc3, ptc4: TFloatPoint;
  //
  A1, A2, b1, b2, Xa, Ya: extended;
  mul: integer;
begin
  Result := false;
  delta := 5;
  //
  if prmCL2 = Self then exit;  
  //
  if (not IsMeterConnector) and prmCL2.IsMeterConnector then exit;
  //
  for i := 0 to VertexesCount - 2 do
  begin
    pt1 := Vertex[i];
    pt2 := Vertex[i + 1];
    //
    // ���� ����������� �������� ����� � ��������� ������ �����
    for k := 0 to prmCL2.VertexesCount - 2 do
    begin
      pt3 := prmCL2.Vertex[k];
      pt4 := prmCL2.Vertex[k + 1];
      //
      if ArePointsIdent(pt1, pt3) or ArePointsIdent(pt1, pt4) or
         ArePointsIdent(pt2, pt3) or ArePointsIdent(pt2, pt4)
          then continue;
      //
      dx1 := pt2.X - pt1.X;
      dy1 := pt2.Y - pt1.Y;
      dx2 := pt4.X - pt3.X;
      dy2 := pt4.Y - pt3.Y;
      //
      pt.X := dy1 * dx2 - dy2 * dx1;
      //
      if (dx1 = 0) and (dx2 <> 0) then
      begin
        pt.X := pt1.x;
        A2 := (pt3.y - pt4.y) / (pt3.x - pt4.x);
        b2 := pt3.y - A2 * pt3.x;
        pt.Y := A2 * pt.X + b2;
      end else
      //
      if (dx2 = 0) and (dx1 <> 0) then
      begin
        pt.X := pt3.x;
        A1 := (pt1.y - pt2.y) / (pt1.x - pt2.x);
        b1 := pt1.y - A1 * pt1.x;
        pt.Y := A1 * pt.X + b1;
      end else
      //
      if (pt.X <> 0) and (dx2 <> 0) then
      begin
        pt.Y := pt3.X * pt4.Y - pt3.Y * pt4.X;
        pt.X := ((pt1.X * pt2.Y - pt1.Y * pt2.X) * dx2 - pt.Y * dx1) / pt.X;
        pt.Y := (dy2 * pt.X - pt.Y) / dx2;
      end;
      //
      //
      if IsPointInSegment(pt1, pt2, pt) and
         IsPointInSegment(pt3, pt4, pt) then
      begin
        fl := false;
        for n := 0 to length(prmCL2.Intersections) - 1 do
          if prmCL2.Intersections[n].Line = Self then
          begin
            fl := true;
            break;
          end;
        if ArePointsIdent(pt, pt1, 3) or ArePointsIdent(pt, pt2, 3)
          then fl := true;
        if fl then continue;
        //
        m := Length(Intersections);
        SetLength(Intersections, m + 1);
        // ������ ����� ����� �� ����������� (���)
        Intersections[m].VertexID := i;
        // �����, ����������� � ������� �������
        Intersections[m].Line := prmCL2;
        // ���������� �� ��� �� ����� �����������
        Intersections[m].Distance := round(sqrt(sqr(pt.X - pt1.X) + sqr(pt.Y - pt1.Y)));
        // ����� �����������
        Intersections[m].pt0 := pt;
        //
        mul := 1;
        if (pt1.X = pt2.X) then
        begin
          if pt1.Y > pt2.Y then mul := -1;
          if pt1.Y <= pt2.Y then mul := 1;
          pt032.X := pt1.X;
          pt032.Y := pt.Y - mul * delta;
          pt042.X := pt1.X;
          pt042.Y := pt.Y + mul * delta;
        end else
        if (pt1.Y = pt2.Y) then
        begin
          if pt1.X > pt2.X then mul := -1;
          if pt1.X <= pt2.X then mul := 1;
          pt032.X := pt.X - mul * delta;
          pt032.Y := pt1.Y;
          pt042.X := pt.X + mul * delta;
          pt042.Y := pt1.Y;
        end else
        begin
          //
          lenAB := sqrt(sqr(pt1.X - pt.X) + sqr(pt1.Y - pt.Y));
          alpha := GetAngle(pt1, pt);
          alpha := GetAngleWQ(pt1, pt2, alpha);
          //
          pt2_.X := pt1.X + lenAB;
          pt2_.Y := pt1.Y;
          //
          pt031.X := pt2_.X - delta;
          pt031.Y := pt2_.Y;
          pt041.X := pt2_.X + delta;
          pt041.Y := pt2_.Y;
          //
          CalcRotate(pt1, pt031, alpha, pt032);
          CalcRotate(pt1, pt041, alpha, pt042);
          //
        end;
        //
        Intersections[m].pt1.X := pt.X - delta;
        Intersections[m].pt1.Y := pt.Y - delta;
        Intersections[m].pt2.X := pt.X + delta;
        Intersections[m].pt2.Y := pt.Y + delta;
        Intersections[m].pt3 := pt032;
        Intersections[m].pt4 := pt042;
        //
        Result := true;
      end;
    end;
  end;
end;

function TConnectionLine.GetConnectionJson: string;
var
  i: integer;
  s, s1, s2: string;
  MC: TMeterConnection;
begin
  Result := '';
  //
  s := 'false';
  if IsMeterConnector then s := 'true';
  //
  s1 := ''; s2 := '';
  if Assigned(Object1) then s1 := Object1.UniqueName;
  if Assigned(Object2) then s2 := Object2.UniqueName;
  Result :=
    '"IsMeterConnector": ' + s + ', ' +
    '"Direction": ' + inttostr(Direction) + ', ' +
    '"Object1": "' + s1 + '", ' +
    '"Object2": "' + s2 + '", ' +
    '"MeterConnections": [';
  //
  s := '';
  for i := 0 to MeterConnections.Count - 1 do
  begin
    MC := PMeterConnection(MeterConnections[i])^;
    s := s +
      '{' +
        '"Line": "' + MC.Line.UniqueName + '", ' +
        '"Vertex": ' + inttostr(MC.Vertex) + ', ' +
        '"Scale": ' + StringReplace(
            FormatFloat('0.000', MC.Scale), ',', '.',
            [rfReplaceAll, rfIgnoreCase]) +
      '}, ';
  end;
  if s <> '' then s := Copy(s, 1, length(s) - 2);
  //
  Result := Result + s + '], ';
end;

function TConnectionLine.GetMeterConnectionIndexByLine(
  Line: TConnectionLine): integer;
var i: integer;
begin
  Result := -1;
  for i := 0 to MeterConnections.Count - 1 do
    if PMeterConnection(MeterConnections[i])^.Line = Line then
    begin
      Result := i;
      break;
    end;
end;

function TConnectionLine.GetObjectJson(OffsetX, OffsetY: integer): string;
begin
  Result :=
    GetCommonJson() +
    GetBasePointsJson(OffsetX, OffsetY) +
    GetConnectionJson();
  //
  Result := PrepareObjectJsonResult(Result);  
end;

function TConnectionLine.MakeLogicalUnit(): TPlantUnit;
var
  BVO1, BVO2: TBaseVisualObject;
  PU1, PU2: TPlantUnit;
  PIP: TPipe;
begin
  Result := nil;
  //
  //if not Assigned(prmLogicalSchema) then exit;
  //
  if Assigned(Object1) and Assigned(Object2) then
  begin
    BVO1 := TBaseVisualObject(Object1);
    BVO2 := TBaseVisualObject(Object2);
    if Assigned(BVO1.LogicalUnit) and Assigned(BVO2.LogicalUnit) then
    begin
      PU1 := BVO1.LogicalUnit;
      PU2 := BVO2.LogicalUnit;
      PIP := TPipe.Create(
          UniqueName,
          UniqueName,
          ''
          ,PU1
          ,PU2
          );
      //
      PIP.GraphicUnit := Self;
      LogicalUnit := PIP;
      //
      Result := PIP;
    end;
  end;
end;

procedure TConnectionLine.MakeObjectFromJson(prmJsonObj: ISuperObject);
begin
  inherited;
  //
  IsMeterConnector := prmJsonObj.B['IsMeterConnector'];
  Direction := prmJsonObj.I['Direction'];
  UniqueName := prmJsonObj.S['UniqueName'];
end;

procedure TConnectionLine.RecountMeterConnections;
var
  i: integer;
  MC: TMeterConnection;
  MCL: TConnectionLine;
  pt1, pt2, pt3, pt3_: TFloatPoint;
  alpha, lenAB: extended;
begin
  for i := 0 to MeterConnections.Count - 1 do
  begin
    MC := PMeterConnection(MeterConnections[i])^;
    MCL := MC.Line;
    pt1 := Vertex[MC.Vertex];
    pt2 := Vertex[MC.Vertex + 1];
    //
    if (pt1.X = pt2.X) and (pt1.Y > pt2.Y) then
    begin
      lenAB := abs(pt2.Y - pt1.Y);
      pt3_.X := pt1.X;
      pt3_.Y := pt1.Y - lenAB * MC.Scale;
      //pt3_.Y := pt1.Y - trunc(lenAB * MC.Scale);
    end else
    if (pt1.X = pt2.X) and (pt1.Y <= pt2.Y) then
    begin
      lenAB := abs(pt2.Y - pt1.Y);
      pt3_.X := pt1.X;
      pt3_.Y := pt1.Y + lenAB * MC.Scale;
      //pt3_.Y := pt1.Y + trunc(lenAB * MC.Scale);
    end else
    if (pt1.Y = pt2.Y) and (pt1.X > pt2.X) then
    begin
      lenAB := abs(pt2.X - pt1.X);
      pt3_.X := pt1.X - lenAB * MC.Scale;
      //pt3_.X := pt1.X - trunc(lenAB * MC.Scale);
      pt3_.Y := pt1.Y;
    end else
    if (pt1.Y = pt2.Y) and (pt1.X <= pt2.X) then
    begin
      lenAB := abs(pt2.X - pt1.X);
      pt3_.X := pt1.X + lenAB * MC.Scale;
      //pt3_.X := pt1.X + trunc(lenAB * MC.Scale);
      pt3_.Y := pt1.Y;
    end else
    begin
      lenAB := sqrt(sqr(pt1.X - pt2.X) + sqr(pt1.Y - pt2.Y));
      alpha := GetAngle(pt1, pt2);
      alpha := GetAngleWQ(pt1, pt2, alpha);
      //
      pt3.X := pt1.X + lenAB * MC.Scale;
      //pt3.X := pt1.X + trunc(lenAB * MC.Scale);
      pt3.Y := pt1.Y;
      //
      CalcRotate(pt1, pt3, alpha, pt3_);
    end;
    //
    // pt3_.X := trunc(pt3_.X); //
    // pt3_.Y := trunc(pt3_.Y); //
    //
    MCL.SetVertex(MCL.VertexesCount - 1, pt3_);
  end;
end;

procedure TConnectionLine.ShiftDraw(prmShift: boolean;
  prmPos: TFloatPoint; prmStep: integer);
var
  vrtx_id: integer;
  vrtx1, vrtx2: TFloatPoint;
  L, alpha: Extended;
  vrtx3: TFloatPoint;
begin
  // ��������� ��� ������, �������� 45 ��������, ��� ������� Shift
  if (VertexesCount <= 1) or (not prmShift) then exit;
  //
  vrtx1 := Vertex[VertexesCount - 2];
  vrtx_id := VertexesCount - 1;
  vrtx2 := Vertex[vrtx_id];
  //
  alpha := GetAngle(vrtx1, vrtx2);
  alpha := GetAngleWQ(vrtx1, vrtx2, alpha);
  alpha := RadToDeg(alpha);
  L := sqrt(sqr(prmPos.X - vrtx1.X) + sqr(prmPos.Y - vrtx1.Y));
  vrtx3.X := vrtx1.X + L;
  vrtx3.Y := vrtx1.Y;
  //
  alpha := round(alpha);
  if between(alpha, 327, 359) or
     between(alpha, 0, 21) or
     between(alpha, 157, 201) then
  begin
    vrtx2.X := prmPos.X;
    vrtx2.Y := vrtx1.Y;
  end else
  if between(alpha, 67, 111) or
     between(alpha, 247, 291) then
  begin
    vrtx2.X := vrtx1.X;
    vrtx2.Y := prmPos.Y;
  end else
  if between(alpha, 22, 66)
    then CalcRotate(vrtx1, vrtx3, DegToRad(45), vrtx2)
    else if between(alpha, 112, 156)
      then CalcRotate(vrtx1, vrtx3, DegToRad(135), vrtx2)
    else if between(alpha, 202, 246)
      then CalcRotate(vrtx1, vrtx3, DegToRad(225), vrtx2)
    else if between(alpha, 292, 326)
      then CalcRotate(vrtx1, vrtx3, DegToRad(315), vrtx2);
  //
  ApplyGridStep2(vrtx2, prmStep); //
  //
  SetVertex(vrtx_id, vrtx2);
end;

procedure TConnectionLine.SortIntersections(min, max: Integer);
var
  i, j, supp: integer;
  tmp: TIntersection;
begin
  supp := Intersections[max - ((max - min) div 2)].Distance;
  i := min; j := max;
  while i < j do
  begin
    while Intersections[i].Distance < supp do i := i + 1;
    while Intersections[j].Distance > supp do j := j - 1;
    if i <= j then
    begin
      tmp := Intersections[i];
      Intersections[i] := Intersections[j];
      Intersections[j] := tmp;
      i := i + 1;
      j := j - 1;
    end;
  end;
  if min < j then SortIntersections(min, j);
  if i < max then SortIntersections(i, max);
end;

function TConnectionLine.VOCStopConstruct(): cardinal;
begin
  Result := 1;
  if FConstructing then
  begin
    FConstructing := False;
    DeleteBasePoint(FCurrentPoint);
    if not Check then Result := 0;
  end;
end;

procedure TConnectionLine.AddMeterConnection(pLine: TConnectionLine;
  pVertex: integer; pScale: extended);
var
  NewMeterConnection: PMeterConnection;
  i: integer;
begin
  i := GetMeterConnectionIndexByLine(pLine);
  if i >= 0 then
    DeleteMeterConnection(pLine);
  //
  if pLine.IsMeterConnector then
  begin
    New(NewMeterConnection);
    NewMeterConnection^.Line := pLine;
    NewMeterConnection^.Vertex := pVertex;
    NewMeterConnection^.Scale := pScale;
    MeterConnections.Add(NewMeterConnection);
    //
    if Assigned(pLine) and Assigned(pLine.LogicalUnit) then
      LogicalUnit.AddMeterConnection(TPipe(pLine.LogicalUnit));
  end;
  //
  RecountMeterConnections();
end;

function TConnectionLine.ArrangeConnections: boolean;
begin
  Result := true;
  //
  RecountMeterConnections();
end;

function TConnectionLine.CanBe2ndConnObject(prmCL: TConnectionLine;
  prmHT: cardinal): boolean;
begin
  Result := false;
  //
  if not prmCL.IsMeterConnector then exit;
  //
  if IsMeterConnector then exit;
  //
  Result := ((prmHT and $F0000000) = HT_IN);
end;

function TConnectionLine.CanStartConnect(prmCL: TConnectionLine;
  prmHT: Cardinal): boolean;
begin
  // �� �� ����� ���������� � ������ ��
  Result := false;
end;

function TConnectionLine.StartConnection(prmCL: TConnectionLine;
  prmHT: Cardinal): boolean;
begin
  Result := false;
end;    

function TConnectionLine.CanFinishConnect(prmCL: TConnectionLine;
  prmHT: Cardinal): boolean;
begin
  Result := true;
  // ���� ���������� �� ������������
  if ((prmHT and $F0000000) <> HT_IN) then Result := false;
  // ���� ������ �� - ���������� � ��
  if prmCL.IsMeterConnector and IsMeterConnector then Result := false;
  //
  if not Result then DeleteMeterConnection(prmCL);
end;

function TConnectionLine.FinishConnection(prmCL: TConnectionLine;
  prmHT: Cardinal; prmLX, prmLY: extended): boolean;
var
  vrtx_id: integer;
  vrtx1, vrtx2: TFloatPoint;
  d1, d2: extended;
begin
  Result := false;
  //
  // ������������ ����� ������������ �������������� �� � ��-��
  vrtx_id := prmHT and $0FFFFFFF;
  vrtx1 := Vertex[vrtx_id];
  vrtx2 := Vertex[vrtx_id + 1];
  d1 := sqrt(sqr(vrtx1.X - vrtx2.X) + sqr(vrtx1.Y - vrtx2.Y));
  d2 := sqrt(sqr(vrtx1.X - prmLX) + sqr(vrtx1.Y - prmLY));
  //
  AddMeterConnection(prmCL, vrtx_id, d2 / d1);
  //
  prmCL.Object2 := Self;
end;

function TConnectionLine.FinishConstruct(var prmPU: TPlantUnit): boolean;
begin
  prmPU := nil;
  Result := false;
  //
  if ConnectObjects(prmPU) then
  begin
    State := 0;
    Result := true;
  end;
end;

function TConnectionLine.FinishDrag(): boolean;
var PU: TPlantUnit;
begin
  // ���������, �� ���������� �� ����������� �������
  // ���� ��������� - ��������� �����
  Result := ConnectObjects(PU);
  //
  if Result then
  begin
    State := 0;
    Object1.ArrangeConnections();
    Object2.ArrangeConnections();
  end;
end;

function TConnectionLine.Check: boolean;
begin
  Result := true;
  //
  if VertexesCount < 2 then Result := false;
  //
  if (not Assigned(preObject1)) or
     (not Assigned(preObject2))
    then Result := false;
end;

procedure TConnectionLine.ClearIntersections;
begin
  SetLength(Intersections, 0);
end;

procedure TConnectionLine.CheckState();
begin
  if (not Assigned(preObject1)) or
     (not Assigned(preObject2))
    then State := 1
    else State := 2;
  //
  CheckAsMeterConnection();
end;

procedure TConnectionLine.CheckErrors(var prmErrorsList: TStringList;
  var prmErrorObjects: TList; prmSchema: TObject);
var
  i, j: integer;
  PU: TPlantUnit;
  PIP: TPipe;
  MC: TMeterConnection;
  VC: TVisualContainer;

  procedure CheckObject(prmObjNo: integer);
  var
    objG: TBaseVisualObject;
    objL: TPlantUnit;
    objN: string;
  begin
    if prmObjNo = 1 then
    begin
      objG := Object1;
      objL := PIP.pPlantUnit1;
    end else
    begin
      objG := Object2;
      objL := PIP.pPlantUnit2;
    end;
    objN := inttostr(prmObjNo);
    //
    if not Assigned(objG)
      then AddError(prmErrorsList, prmErrorObjects,
            '������ ' + objN + ' �� ���������')
      else
        if VC.GetObjectByUniqueName(objG.UniqueName) = nil
          then AddError(prmErrorsList, prmErrorObjects,
                '������ ' + objN + ' �� ������')
          else
            if not Assigned(objG.LogicalUnit)
              then AddError(prmErrorsList, prmErrorObjects,
                    '������ ' + objN + ' - ���. ������ �� ���������')
              else
                if objL <> objG.LogicalUnit
                  then AddError(prmErrorsList, prmErrorObjects,
                        '������ ' + objN + ' - ' +
                        '���. ������ ' + objL.Name + ' �� ������������� ' +
                        '����. ������� ' + objG.LogicalUnit.Name);
  end;

begin
  inherited CheckErrors(prmErrorsList, prmErrorObjects, prmSchema);
  //
  VC := TVisualContainer(prmSchema);
  //
  if prmErrorObjects.IndexOf(Self) >= 0 then exit;
  //
  if not Assigned(LogicalUnit) then exit;
  PU := LogicalUnit;
  //
  if not (PU is TPipe) then
  begin
    AddError(prmErrorsList, prmErrorObjects,
      '���. ������ �� ������������� ����. �������');
    exit;
  end;
  //
  PIP := TPipe(PU);
  //
  j := 0;
  for i := 0 to MeterConnections.Count - 1 do
  begin
    MC := PMeterConnection(MeterConnections[i])^;
    //
    if not MC.Line.IsMeterConnector then
    begin
      AddError(prmErrorsList, prmErrorObjects,
        '����� ' + MC.Line.UniqueName + ' �� �������� �������������� � ��');
      continue;
    end;
    //
    if not (MC.Line.Object1 is TGraphMeter) then
    begin
      AddError(prmErrorsList, prmErrorObjects,
        '����� ' + MC.Line.UniqueName + ' ��������� �� � ��');
      continue;
    end;
    //
    if not (MC.Line.Object2 = Self) then continue;
    //
    if Assigned(MC.Line.Object1.LogicalUnit) then
      if PIP.Meters.IsMeterExits(TMeter(MC.Line.Object1.LogicalUnit))
        then inc(j);
  end;
  if j <> PIP.Meters.List.Count
    then AddError(prmErrorsList, prmErrorObjects,
          '�� ��������� ���������� ������������� �������� - ' +
          '���. ' + inttostr(PIP.Meters.List.Count) + ', ' +
          '����. ' + inttostr(j));
  //
  if MeterConnections.Count <> PIP.Meters.Count
    then AddError(prmErrorsList, prmErrorObjects,
          '�� ��������� ���������� ������������� ��������: ' +
          '���. = ' + inttostr(PIP.Meters.Count) + ', ' +
          '����. = ' + inttostr(MeterConnections.Count));
  //
  CheckObject(1);
  CheckObject(2);
end;

function TConnectionLine.CheckIntersections(prmObjects: TList): boolean;
var
  i: integer;
  BVO: TBaseVisualObject;
begin
  Result := false;
  //
  ClearIntersections();
  //
  for i := 0 to prmObjects.Count - 1 do
  begin
    BVO := TBaseVisualObject(prmObjects[i]);
    if not (BVO is TConnectionLine) then continue;
    if BVO = Self then continue;
    //
    if FindIntersections(TConnectionLine(BVO)) then Result := true;
  end;
  //
  if Result then
    SortIntersections(0, High(Intersections));
end;

function TConnectionLine.CheckDisconnection(): boolean;
begin
  Result := false;
  //
  if (Object1 <> preObject1) and Assigned(Object1) then
  begin
    Object1.DeleteConnection(Self);
    Object1 := nil;
    Result := true;
  end;
  //
  if (Object2 <> preObject2) and Assigned(Object2) then
  begin
    Object2.DeleteConnection(Self);
    Object2 := nil;
    Result := true;
  end;
end;

function TConnectionLine.ConnectObjects(var prmPU: TPlantUnit): boolean;
begin
  Result := false;
  //
  // ���������, ��������� �� ����� ����� ���������
  // � ������������ ������ �����
  CheckDisconnection();
  //
  if not Assigned(preObject1) then exit;
  if not Assigned(preObject2) then exit;
  //
  Object1 := preObject1;
  Object2 := preObject2;
  //
  if not Assigned(LogicalUnit)
    then prmPU := MakeLogicalUnit()
    else prmPU := LogicalUnit;
  //
  TPipe(LogicalUnit).pPlantUnit1 := Object1.LogicalUnit;
  TPipe(LogicalUnit).pPlantUnit2 := Object2.LogicalUnit;
  //
  if Assigned(Object1) then Object1.AddConnection(Self);
  if Assigned(Object2) then Object2.AddConnection(Self);
  //
  CheckAsMeterConnection();
  //
  Result := true;
end;

procedure TConnectionLine.CheckAsMeterConnection();
var
  i, connX2, connY2: integer;
  vrtx_id: integer;
  vrtx1, vrtx2: TFloatPoint;
  d1, d2: extended;
  CL: TConnectionLine;
begin
  if (preObject2 <> Object2) or
     (not (Object2 is TConnectionLine)) then exit;
  //
  connX2 := round(Vertex[VertexesCount - 1].X);
  connY2 := round(Vertex[VertexesCount - 1].Y);
  //
  CL := TConnectionLine(Object2);
  vrtx_id := HitTest2 and $0FFFFFFF;
  vrtx1 := CL.Vertex[vrtx_id];
  vrtx2 := CL.Vertex[vrtx_id + 1];
  d1 := sqrt(sqr(vrtx1.X - vrtx2.X) + sqr(vrtx1.Y - vrtx2.Y));
  d2 := sqrt(sqr(vrtx1.X - connX2) + sqr(vrtx1.Y - connY2));
  //
  i := CL.GetMeterConnectionIndexByLine(Self);
  if i >= 0 then
  begin
    PMeterConnection(CL.MeterConnections[i])^.Vertex := vrtx_id;
    PMeterConnection(CL.MeterConnections[i])^.Scale := d2 / d1;
  end else
    CL.AddMeterConnection(Self, vrtx_id, d2 / d1);
end;

{ TSelector }

constructor TSelector.Create;
begin
  inherited;
  //
  TypeName := 'Selector';
  //
  FSelectable := false;
end;

function TSelector.FinishConstruct(var prmPU: TPlantUnit): boolean;
begin
  prmPU := nil;
  Result := false;
end;

procedure TSelector.SpecialDraw(Canvas: TLogicalCanvas);
begin
  Canvas.FCanvas.Pen.Width := 1;
  Canvas.FCanvas.Pen.Style := psDot;
  //
  Canvas.DrawRect(
    BasePoints[0].X + DrawOffsetX,
    BasePoints[0].Y + DrawOffsetY,
    BasePoints[1].X + DrawOffsetX,
    BasePoints[1].Y + DrawOffsetY,
    FPen.Width);
end;

{ TFloodFillPointBlock }

constructor TFloodFillPointBlock.Create;
begin
  inherited;
  //
  FFloodFillBrush := TBrush.Create();
  //
  TypeName := 'Flood fill point';
  //
  Flyweight := FlyweightProvider.FLOOD_FILL_POINT_FLYWEIGHT;
end;

destructor TFloodFillPointBlock.Destroy;
begin
  FFloodFillBrush.Free;
  //
  inherited;
end;

procedure TFloodFillPointBlock.SpecialDraw(Canvas: TLogicalCanvas);
begin
  Canvas.FCanvas.Brush.Color := FloodFillBrush.Color;
  Canvas.FCanvas.Brush.Style := FloodFillBrush.Style;
  Canvas.DrawFloodFill(Point.X, Point.Y, FillColor, FillStyle);
end;

procedure TFloodFillPointBlock.DrawInComplex(Params: TComplexDrawParams);
var clr: TColor;
begin
  Params.Canvas.FCanvas.Brush.Color := FloodFillBrush.Color;
  Params.Canvas.FCanvas.Brush.Style := FloodFillBrush.Style;
  Params.Canvas.FCanvas.Pen.Color := FloodFillBrush.Color;
  //
  if Params.IsActive
    then clr := FillColor
    else clr := INACTIVE_OBJECT_COLOR;
  //  
  Params.Canvas.DrawFloodFill(Point.X, Point.Y, clr, FillStyle);
end;

function TFloodFillPointBlock.GetFloodFillJson: string;
begin
  Result := '';
  //
  if not Assigned(FFloodFillBrush) then exit;
  //
  Result :=
    '"FloodFillBrush": {' +
      '"Color": "' + ColorToString(FFloodFillBrush.Color) + '", ' +
      '"Style": ' + inttostr(Integer(FFloodFillBrush.Style)) + ', ' +
      '"FillColor": "' + ColorToString(FillColor) + '", ' +
      '"FillStyle": ' + inttostr(Integer(FillStyle)) +
    '}, ';
end;

function TFloodFillPointBlock.GetObjectJson(OffsetX, OffsetY: integer): string;
begin
  Result :=
    GetCommonJson() +
    GetBasePointsJson(OffsetX, OffsetY) +
    GetFloodFillJson();
  //
  Result := PrepareObjectJsonResult(Result);  
end;

function TFloodFillPointBlock.GetPoint: TFloatPoint;
begin
  Result.X := (BasePoints[0].X + BasePoints[1].X + DrawOffsetX * 2) / 2;
  Result.Y := (BasePoints[0].Y + BasePoints[1].Y + DrawOffsetY * 2) / 2;
end;

procedure TFloodFillPointBlock.MakeObjectFromJson(prmJsonObj: ISuperObject);
var jso: ISuperObject;
begin
  inherited;
  //
  jso := prmJsonObj.O['FloodFillBrush'];
  if not Assigned(jso) then exit;
  //
  FloodFillBrush.Color := StringToColor(jso.S['Color']);
  FloodFillBrush.Style := TBrushStyle(jso.I['Style']);
  FillColor := StringToColor(jso.S['FillColor']);
  FillStyle := TFillStyle(jso.I['FillStyle']);
end;

procedure TFloodFillPointBlock.SetFloodFillBrush(Value: TBrush);
begin
  FFloodFillBrush.Color := Value.Color;
  FFloodFillBrush.Style := Value.Style;
  TBaseVisualObject(Flyweight.Primitives[0]).Brush.Color := FFloodFillBrush.Color;
  TBaseVisualObject(Flyweight.Primitives[0]).Brush.Style := FFloodFillBrush.Style;
end;

{ TGraphFacility }

constructor TGraphFacility.Create;
begin
  inherited;
  //
  TypeName := 'Facility';
  TypeID := 1;
end;

{ TGraphTank }

function TGraphTank.CanBe2ndConnObject(prmCL: TConnectionLine;
  prmHT: cardinal): boolean;
begin
  Result :=
    IsPointInside(
      round(prmCL.Vertex[prmCL.VertexesCount - 1].X),
      round(prmCL.Vertex[prmCL.VertexesCount - 1].Y));
end;

function TGraphTank.CanFinishConnect(prmCL: TConnectionLine): boolean;
begin
  Result := true;
end;

constructor TGraphTank.Create;
begin
  inherited;
  //
  TypeName := 'Tank';
  TypeID := 2;
end;

{ TGraphDivider }

constructor TGraphDivider.Create;
begin
  inherited;
  //
  TypeName := 'Divider';
  TypeID := 3;
end;

{ TGraphMeter }

function TGraphMeter.CanBe2ndConnObject(prmCL: TConnectionLine;
  prmHT: cardinal): boolean;
begin
  Result := false;
end;

function TGraphMeter.CanFinishConnect(prmCL: TConnectionLine): boolean;
begin
  // C��������� � �� ���������� ����������� � �� � �� ����� �� �������������
  Result := false;
  //
  DeleteConnection(prmCL);
end;

function TGraphMeter.CanStartConnect(prmCL: TConnectionLine): boolean;
begin
  Result := true;
  //
  // � �� ����� ���� ������ ���� ����������
  if (Connections.Count > 0) then Result := false;
  //
  if not Result then DeleteConnection(prmCL);
end;

procedure TGraphMeter.CheckErrors(var prmErrorsList: TStringList;
  var prmErrorObjects: TList; prmSchema: TObject);
var
  i: integer;
  VC: TVisualContainer;
  PU: TPlantUnit;
  MET1, MET2: TMeter;
  CL: TConnectionLine;
  MetersOwner: IMetersOwner;
  METLST: TMetersList;
begin
  inherited CheckErrors(prmErrorsList, prmErrorObjects, prmSchema);
  //
  VC := TVisualContainer(prmSchema);
  //
  if prmErrorObjects.IndexOf(Self) >= 0 then exit;
  //
  if not Assigned(LogicalUnit) then exit;
  MET1 := TMeter(LogicalUnit);
  //
  // �������� �� ����������
  for i := 0 to Connections.Count - 1 do
  begin
    CL := TConnectionLine(Connections[i]);
    if not CL.IsMeterConnector then
      AddError(prmErrorsList, prmErrorObjects,
        '����� ' + CL.UniqueName + ' �� �������� �������������� � ��');
    //
    if not Assigned(CL.Object2) then continue;
    if not Assigned(CL.Object2.LogicalUnit) then continue;
    //
    if not CL.Object2.LogicalUnit.IsMeterOwner(MetersOwner) then
    begin
      AddError(prmErrorsList, prmErrorObjects,
        CL.Object2.UniqueName + ' �� ����� ���� ������� � ��');
      continue;
    end;
    //
    METLST := MetersOwner.GetMeters();
    if not METLST.IsMeterExits(MET1) then
    begin
      AddError(prmErrorsList, prmErrorObjects,
        '�� �� ���������� � ���. ������� ' + CL.Object2.UniqueName);
      continue;
    end;
  end;  
  //
  // �������� �� ����� ����� ��
  for i := 0 to VC.LogicalSchema.Units.Count - 1 do
  begin
    PU := TPlantUnit(VC.LogicalSchema.Units[i]);
    if PU = MET1 then continue;    
    if (not (PU is TMeter)) then continue;
    //
    MET2 := TMeter(PU);
    //
    if (MET1.TagID <> 0) and
       (MET2.TagID <> 0) and
       (MET1.TagID = MET2.TagID) then
        AddError(prmErrorsList, prmErrorObjects,
          '���������� ���� � ' + MET2.Name);
  end;
end;

constructor TGraphMeter.Create;
begin
  inherited;
  //
  TypeName := 'Meter';
  TypeID := 5;
end;

procedure TGraphMeter.IsTheSameSpecial(prmObject: TBaseVisualObject;
  var prmResult: boolean);
var MET1, MET2: TMeter;
begin
  inherited IsTheSameSpecial(prmObject, prmResult);
  if not prmResult then exit;
  //
  if Assigned(LogicalUnit) and Assigned(prmObject.LogicalUnit) then
  begin
    MET1 := TMeter(LogicalUnit);
    MET2 := TMeter(prmObject.LogicalUnit);
    prmResult :=
      prmResult and ((MET1.TagName <> '') and (MET1.TagName = MET2.TagName));
  end;
end;

function TGraphMeter.StartConnection(prmCL: TConnectionLine): boolean;
begin
  Result := true;
  //
  prmCL.Direction := 0;
  prmCL.IsMeterConnector := true;
  //
  inherited StartConnection(prmCL);
end;

{ TGraphValve }

constructor TGraphValve.Create;
begin
  inherited;
  //
  TypeName := 'Valve';
  TypeID := 6;
end;

{ TGraphPump }

constructor TGraphPump.Create;
begin
  inherited;
  //
  TypeName := 'Pump';
  TypeID := 7;
end;

{ TGraphRiser }

constructor TGraphRiser.Create;
begin
  inherited;
  //
  TypeName := 'Riser';
  TypeID := 8;
end;

{ TToolComplexBlock }

function TToolComplexBlock.MakeLogicalUnit(): TPlantUnit;
begin
  Result := nil;
end;

{ TGraphValveVertical }

procedure TGraphValveVertical.AfterConstruction;
begin
  Flyweight := FlyweightProvider.GetObjectJsonByID(9).Flyweight;
  MakeTextFields();
end;

constructor TGraphValveVertical.Create;
begin
  inherited;
  //
  TypeName := 'ValveVertical';
end;

{ TComplexFlyweight }

constructor TComplexFlyweight.Create(prmJson: string);
var
  i: integer;
  prmJsonObj, jso: ISuperObject;
  jsa: TSuperArray;
begin
  inherited Create();
  //
  Primitives := TList.Create();
  //
  prmJsonObj := SO(prmJson);
  if (prmJson = '') or (not Assigned(prmJsonObj)) then exit;
  //
  Width := prmJsonObj.I['Width'];
  Height := prmJsonObj.I['Height'];
  //
  jsa := prmJsonObj.A['Primitives'];
  if Assigned(jsa) then
  for i := 0 to jsa.Length - 1 do
  begin
    jso := jsa[i];
    MakeObjects(jso, Primitives);
  end;
  //
  // �������������� ���� ��� �������, ��� ��� UniqueName ����� ���� ������
  for i := 0 to Primitives.Count - 1 do
    if TBaseVisualObject(Primitives[i]) is TTextBlock then
      TTextBlock(Primitives[i]).FieldName := TTextBlock(Primitives[i]).Text;
end;

destructor TComplexFlyweight.Destroy;
begin
  while Primitives.Count > 0 do
  begin
    TBaseVisualObject(Primitives[0]).Free;
    Primitives.Delete(0);
  end;
  Primitives.Clear;
  Primitives.Free;
  //
  inherited;
end;

procedure TComplexFlyweight.Draw(X, Y: extended; CDP: TComplexDrawParams);
var
  i: integer;
  BVO: TBaseVisualObject;
begin
  for i := 0 to Primitives.Count - 1 do
  begin
    BVO := TBaseVisualObject(Primitives[i]);
    BVO.DrawOffsetX := round(X);
    BVO.DrawOffsetY := round(Y);
    BVO.DrawInComplex(CDP);
  end;
end;

end.
