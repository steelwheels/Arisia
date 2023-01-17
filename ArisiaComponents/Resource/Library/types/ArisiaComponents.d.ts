/* Enum declaration: AccessType */
declare enum AccessType {
  append = 2,
  read = 0,
  write = 1
}
/* Enum declaration: AlertType */
declare enum AlertType {
  critical = 3,
  informational = 1,
  warning = 2
}
/* Enum declaration: Alignment */
declare enum Alignment {
  center = 3,
  fill = 2,
  leading = 0,
  trailing = 1
}
/* Enum declaration: AnimationState */
declare enum AnimationState {
  idle = 0,
  pause = 2,
  run = 1
}
/* Enum declaration: Authorize */
declare enum Authorize {
  authorized = 3,
  denied = 2,
  undetermined = 0
}
/* Enum declaration: Axis */
declare enum Axis {
  horizontal = 0,
  vertical = 1
}
/* Enum declaration: ButtonState */
declare enum ButtonState {
  disable = 1,
  hidden = 0,
  off = 2,
  on = 3
}
/* Enum declaration: ComparisonResult */
declare enum ComparisonResult {
  ascending = -1,
  descending = 1,
  same = 0
}
/* Enum declaration: Device */
declare enum Device {
  carPlay = 4,
  ipad = 2,
  mac = 0,
  phone = 1,
  tv = 3
}
/* Enum declaration: Distribution */
declare enum Distribution {
  equalSpacing = 3,
  fill = 0,
  fillEqually = 2,
  fillProportinally = 1
}
/* Enum declaration: ExitCode */
declare enum ExitCode {
  commaneLineError = 2,
  exception = 4,
  internalError = 1,
  noError = 0,
  syntaxError = 3
}
/* Enum declaration: FileType */
declare enum FileType {
  directory = 2,
  file = 1,
  notExist = 0
}
/* Enum declaration: FontSize */
declare enum FontSize {
  large = 19,
  regular = 13,
  small = 11
}
/* Enum declaration: LogLevel */
declare enum LogLevel {
  debug = 3,
  detail = 4,
  error = 1,
  nolog = 0,
  warning = 2
}
/* Enum declaration: SortOrder */
declare enum SortOrder {
  decreasing = 1,
  increasing = -1,
  none = 0
}
/* Enum declaration: SymbolSize */
declare enum SymbolSize {
  large = 180,
  regular = 120,
  small = 60
}
/* Enum declaration: Symbols */
declare enum Symbols {
  character = "character",
  checkmarkSquare = "checkmark.square",
  chevronBackward = "chevron.backward",
  chevronDown = "chevron.down",
  chevronForward = "chevron.forward",
  chevronUp = "chevron.up",
  gearshape = "gearshape",
  handPointUp = "hand.point.up",
  handRaised = "hand.raised",
  line16p = "line.16p",
  line1p = "line.1p",
  line2p = "line.2p",
  line4p = "line.4p",
  line8p = "line.8p",
  lineDiagonal = "line.diagonal",
  moonStars = "moon.stars",
  oval = "oval",
  ovalFill = "oval.fill",
  paintbrush = "paintbrush",
  pencil = "pencil",
  pencilCircle = "pencil.circle",
  pencilCircleFill = "pencil.circle.fill",
  play = "play",
  questionmark = "questionmark",
  rectangle = "rectangle",
  rectangleFill = "rectangle.fill",
  square = "square",
  sunMax = "sun.max",
  sunMin = "sun.min"
}
/* Enum declaration: TextAlign */
declare enum TextAlign {
  center = 1,
  justfied = 3,
  left = 0,
  normal = 4,
  right = 2
}
interface FrameCoreIF {
  _value(p0: string): any ;
  _setValue(p0: string, p1: any): boolean ;
  _definePropertyType(p0: string, p1: string): void ;
  _addObserver(p0: string, p1: () => void): void ;
}

interface FrameIF extends FrameCoreIF {
  frameName: string ;
  propertyNames: string[] ;
}

/* Interface declaration: PointIF */
interface PointIF {
	x: number ;
	y: number ;
}
/* Interface declaration: SizeIF */
interface SizeIF {
	height: number ;
	width: number ;
}
/* Interface declaration: RecordIF */
interface RecordIF {
	fieldCount: number ;
	fieldNames: string[] ;
	setValue(p0: any, p1: string): void ;
	value(p0: string): any ;
}
/* Interface declaration: RectIF */
interface RectIF {
	height: number ;
	width: number ;
	x: number ;
	y: number ;
}
/* Interface declaration: RangeIF */
interface RangeIF {
	length: number ;
	location: number ;
}
/* Interface declaration: TableDataIF */
interface TableDataIF extends FrameIF{
	count: number ;
	fieldName(p0: string): string ;
	fieldNames: string[] ;
	newRecord(): RecordIF ;
	record(p0: number): RecordIF ;
	save(): boolean ;
	toString(): string ;
}
/**
 * Builtin.d.ts
 */

interface ColorIF {
	red:			number ;
	green:			number ;
	blue:			number ;
	alpha:			number ;

        toString():             string ;
}

interface ConsoleIF {
	log(message: string): void ;
	print(message: string): void ;
	error(message: string): void ;
}

interface ColorManagerIF {
        black:          ColorIF ;
        red:            ColorIF ;
        green:          ColorIF ;
        yellow:         ColorIF ;
        blue:           ColorIF ;
        magenta:        ColorIF ;
        cyan:           ColorIF ;
        white:          ColorIF ;
}

interface CursesIF {
        minColor:	number ;
        maxColor:       number ;
        black:          number ;
        red:            number ;
        green:          number ;
        yellow:         number ;
        blue:           number ;
        magenta:        number ;
        cyan:           number ;
        white:          number ;

        begin(): void ;
        end(): void ;

        width:                  number ;
        height:                 number ;

        foregroundColor:        number ;
        backgroundColor:        number ;

	moveTo(x: number, y: number): boolean ;
	inkey(): string | null ;

	put(str: string): void ;
	fill(x: number, y: number, width: number, height: number, c: string): void ;
}

interface EscapeCodeIF {
        backspace():                    string ;
	delete():                       string ;

	cursorUp(delta: number): string ;
	cursorDown(delta: number): string ;
	cursorForward(delta: number): string ;
	cursorBackward(delta: number): string ;
	cursorNextLine(delta: number): string ;
	cursorPreviousLine(delta: number): string ;
	cursorMoveTo(y: number, x: number): string ;

	saveCursorPosition(): string ;
	restoreCursorPosition(): string ;

	eraceFromCursorToEnd(): string ;
	eraceFromCursorToBegin(): string ;
	eraceEntireBuffer(): string ;
	eraceFromCursorToRight(): string ;
	eraceFromCursorToLeft(): string ;
	eraceEntireLine(): string ;

	scrollUp(lines: number): string ;
	scrollDown(lines: number): string ;

	color(type: number, color: number): string ;
	bold(flag: boolean): string ;

	reset(): string
}

interface FileIF {
	getc(): string ;
	getl(): string ;
	put(str: string): void ;
	close(): void ;
}

interface PipeIF {
        reading:        FileIF ;
        writing:        FileIF ;
}

interface TextIF
{
        core(): any ;
	toString(): string ;
}

interface TextLineIF extends TextIF
{
        set(str: string): void ;
	append(str: string): void ;
	prepend(str: string): void ;
}

interface TextSectionIF extends TextIF
{
	contentCount: number ;

	add(text: TextIF): void ;
	insert(text: TextIF): void ;
	append(str: string): void ;
	prepend(str: string): void ;
}

interface TextRecordIF extends TextIF
{
        columnCount: number ;
	columns: number ;
        append(str: string): void ;
	prepend(str: string): void ;
}

interface TextTableIF extends TextIF
{
        count: number ;
        records: TextRecordIF[] ;

        add(rec: TextRecordIF): void ;
        inert(rec: TextRecordIF): void ;
	append(str: string): void ;
        prepend(str: string): void ;
}

interface ImageDataIF {
	size: SizeIF ;
}

/* KLGraphicsContext in swift */
interface GraphicsContextIF {
	logicalFrame:	RectIF ;

	setFillColor(col: ColorIF): void ;
	setStrokeColor(col: ColorIF): void ;
	setPenSize(size: number): void ;
	moveTo(x: number, y: number): void ;
	lineTo(x: number, y: number): void ;
	rect(x: number, y: number, width: number, height: number, dofill: boolean): void ;
	circle(x: number, y: number, rad: number, dofill: boolean): void ;
}

interface BitmapIF
{
	width:		number ;
	height:		number ;

	get(x: number, y: number): ColorIF ;
	set(x: number, y: number, color: ColorIF): void ;
}

interface ProcessIF {
	isRunning:	boolean ;
	didFinished:	boolean ;
	exitCode:	number ;
	terminate(): void ;
}

interface URLIF {
	isNull:			boolean ;
	absoluteString:		string ;
	path:			string ;
	appending(comp: string): URLIF | null ;
	loadText():		string | null ;
}

interface FileManagerIF {
	open(path: URLIF | string, access: string): FileIF ;

	fileExists(file: URLIF | string): boolean ;

	isReadable(file: URLIF | string): boolean ;
	isWritable(file: URLIF | string): boolean ;
	isExecutable(file: URLIF | string): boolean ;
	isAccessible(file: URLIF | string): boolean ;

	fullPath(path: string, base: URLIF): URLIF | null ;

	documentDirectory:	URLIF ;
	libraryDirectory:	URLIF ;
	resourceDirectory:	URLIF | null ;
	temporaryDirectory:	URLIF ;
	currentDirectory: 	URLIF ;

	copy(from: URLIF, to: URLIF): boolean ;
	remove(file: URLIF | string): boolean ;
}

interface StorageIF {
	value(path: string): any ;

	set(value: any, path: string): boolean ;
	append(value: any, path: string): boolean ;
	delete(path: string): boolean

	save(): boolean ;
	toString(): string ;
}

interface PointerValueIF {
	path:			string ;
}

interface MappingTableIF extends TableDataIF {

	setFilterFunction(filter: (rec: RecordIF) => boolean): void ;
	addVirtualField(field: string, callback: (rec: RecordIF) => any): void

	sortOrder: 		SortOrder | null ;
	setCompareFunction(compare: (rec0: RecordIF, rec1: RecordIF) => ComparisonResult): void
}

interface ContactDatabaseIF {
	recordCount:		number ;

	authorize(callback: (granted: boolean) => void): void
	load(url: URLIF | null): boolean ;

	record(index: number): RecordIF | null ;
	search(value: any, name: string):	RecordIF[] | null ;
        append(record: RecordIF): void ;
	forEach(callback: (record: RecordIF) => void): void ;
}

interface CollectionDataIF {
	sectionCount:			number ;
	itemCount(section: number):	number ;

	header(section: number): string ;
	footer(section: number): string ;

	value(section: number, item: number): string ; // -> symbol-name
	add(header: string, footer: string, symbols: string[]): void ;

	toStrings(): string[] ;
}

interface SystemPreferenceIF {
	device:			Device ;
	version:		string ;
	logLevel:		number ;
}

interface TerminalPreferenceIF {
	width:			number ;
	height:			number ;
	foregroundColor:	ColorIF ;
	backgroundColor:	ColorIF ;
}

interface UserPreferenceIF {
	homeDirectory: 		URLIF ;
}

interface PreferenceIF {
	system:			SystemPreferenceIF ;
	terminal:		TerminalPreferenceIF ;
	user:			UserPreferenceIF ;
}

interface ThreadIF {
	isRunning:		boolean ;
	didFinished:		boolean ;
	exitCode:		number ;
	start(args: string[]):	void ;
	terminate():		void ;
}

/* Singleton object*/
declare var console:		ConsoleIF ;
declare var Color:      	ColorManagerIF ;
declare var Curses:     	CursesIF ;
declare var EscapeCode: 	EscapeCodeIF ;
declare var Contacts:	        ContactDatabaseIF ;
declare var Preference:		PreferenceIF ;
declare var FileManager:	FileManagerIF ;

declare function Pipe(): PipeIF ;
declare function Point(x: number, y: number): PointIF ;
declare function Rect(x: number, y: number, width: number, height: number): RectIF ;
declare function Size(width: number, height: number): SizeIF ;
declare function CollectionData(): CollectionDataIF ;
declare function URL(path: string): URLIF | null ;

declare function Storage(path: string): StorageIF | null ;
declare function TableStorage(storage: string, path: string): TableDataIF | null ;
declare function MappingTableStorage(storage: string, path: string): MappingTableIF | null ;

declare function isArray(value: any): boolean ;
declare function isBitmap(value: any): boolean ;
declare function isBoolean(value: any): boolean ;
declare function isDate(value: any): boolean ;
declare function isNull(value: any): boolean ;
declare function isNumber(value: any): boolean ;
declare function isDictionary(value: any): boolean ;
declare function isRecord(value: any): boolean ;
declare function isObject(value: any): boolean ;
declare function isPoint(value: any): boolean ;
declare function isRect(value: any): boolean ;
declare function isSize(value: any): boolean ;
declare function isString(value: any): boolean ;
declare function isUndefined(value: any): boolean ;
declare function isURL(value: any): boolean ;
declare function isEOF(value: any): boolean ;

declare function toArray(value: any): any[] | null ;
declare function toBitmap(value: any): BitmapIF | null ;
declare function toBoolean(value: any): boolean | null ;
declare function toDate(value: any): object | null ;
declare function toNumber(value: any): number | null ;
declare function toDictionary(value: any): {[name:string]: any} | null ;
declare function toRecord(value: any): RecordIF | null ;
declare function toObject(value: any): object | null ;
declare function toPoint(value: any): PointIF | null ;
declare function toRect(value: any): RectIF | null ;
declare function toSize(value: any): SizeIF | null ;
declare function toString(value: any): string | null ;
declare function toURL(value: any): URLIF | null ;
declare function toText(value: any): TextIF ;

declare function asciiCodeName(code: number): string | null ;

declare function exit(code: number): void ;
declare function sleep(sec: number): boolean ;

declare function TextLine(str: string): TextLineIF ;
declare function TextSection(): TextSectionIF ;
declare function TextRecord(): TextRecordIF ;
declare function TextTable(): TextTableIF ;

declare function _openURL(title: URLIF | string, cbfunc: any): void ;
declare function _allocateThread(path: URLIF | string, input: FileIF, output: FileIF, error: FileIF): ThreadIF | null ;

/// <reference path="Enum.d.ts" />
/// <reference path="Intf.d.ts" />
/// <reference path="Builtin.d.ts" />
declare function isEmptyString(str: string): boolean;
declare function isEmptyObject(obj: object): boolean;
/// <reference path="Builtin.d.ts" />
/// <reference path="Process.d.ts" />
/// <reference path="Enum.d.ts" />
declare function first<T>(arr: T[] | null): T | null;
/// <reference path="Enum.d.ts" />
/// <reference path="Intf.d.ts" />
/// <reference path="Builtin.d.ts" />
declare class File {
    mCore: FileIF;
    constructor(core: FileIF);
    getc(): string;
    getl(): string;
    put(str: string): void;
}
declare var _stdin: FileIF;
declare var _stdout: FileIF;
declare var _stderr: FileIF;
declare const stdin: File;
declare const stdout: File;
declare const stderr: File;
interface JSONFileIF {
    read(file: FileIF): object | null;
    write(file: FileIF, src: object): boolean;
}
declare var _JSONFile: JSONFileIF;
declare class JSONFile {
    constructor();
    read(file: File): object | null;
    write(file: File, src: object): boolean;
}
/// <reference path="Enum.d.ts" />
/// <reference path="Intf.d.ts" />
/// <reference path="Builtin.d.ts" />
interface Math {
    randomInt(min: number, max: number): number;
    clamp(src: number, min: number, max: number): number;
}
declare function int(value: number): number;
declare function compareNumbers(n0: number, n1: number): ComparisonResult;
declare function compareStrings(s0: string, s1: string): ComparisonResult;
/**
 * Debug.ts
 */
/// <reference path="Enum.d.ts" />
/// <reference path="Intf.d.ts" />
/// <reference path="Builtin.d.ts" />
declare function checkVariables(place: string, ...vars: any[]): boolean;
/// <reference path="Builtin.d.ts" />
/// <reference path="Math.d.ts" />
/// <reference path="Enum.d.ts" />
declare function addPoint(p0: PointIF, p1: PointIF): PointIF;
declare function isSamePoints(p0: PointIF, p1: PointIF): boolean;
declare function clampPoint(src: PointIF, x: number, y: number, width: number, height: number): PointIF;
/// <reference path="Enum.d.ts" />
/// <reference path="Intf.d.ts" />
/// <reference path="Builtin.d.ts" />
declare function _waitUntilExitOne(process: ProcessIF): number;
declare function _waitUntilExitAll(processes: ProcessIF[]): number;
declare class Semaphore {
    mValue: {
        [key: string]: number;
    };
    constructor(initval: number);
    signal(): void;
    wait(): void;
}
declare class CancelException extends Error {
    code: number;
    constructor(code: number);
}
declare function _cancel(): void;
declare function openURL(url: URLIF | string): boolean;
declare function run(path: URLIF | string, args: string[], input: FileIF, output: FileIF, error: FileIF): number;
/// <reference path="Enum.d.ts" />
/// <reference path="Intf.d.ts" />
/// <reference path="Builtin.d.ts" />
declare function maxLengthOfStrings(strs: string[]): number;
declare function adjustLengthOfStrings(strs: string[]): string[];
declare function pasteStrings(src0: string[], src1: string[], space: string): string[];
declare function isEqualTrimmedStrings(str0: string, str1: string): boolean;
/// <reference path="Enum.d.ts" />
/// <reference path="Intf.d.ts" />
/// <reference path="Builtin.d.ts" />
declare class CFrame {
    mFrame: RectIF;
    mCursorX: number;
    mCursorY: number;
    mForegroundColor: number;
    mBackgroundColor: number;
    constructor(frame: RectIF);
    get frame(): RectIF;
    get foregroundColor(): number;
    set foregroundColor(newcol: number);
    get backgroundColor(): number;
    set backgroundColor(newcol: number);
    fill(pat: string): void;
    moveTo(x: number, y: number): boolean;
    put(str: string): void;
}
/// <reference path="Enum.d.ts" />
/// <reference path="Intf.d.ts" />
/// <reference path="Builtin.d.ts" />
type TurtleStatus = {
    x: number;
    y: number;
    angle: number;
};
declare class Turtle {
    mContext: GraphicsContextIF;
    mCurrentX: number;
    mCurrentY: number;
    mCurrentAngle: number;
    mMovingAngle: number;
    mMovingDistance: number;
    mPenSize: number;
    mHistory: TurtleStatus[];
    constructor(ctxt: GraphicsContextIF);
    setup(x: number, y: number, angle: number, pen: number): void;
    get logicalFrame(): RectIF;
    get currentX(): number;
    get currentY(): number;
    get currentAngle(): number;
    get movingAngle(): number;
    set movingAngle(newval: number);
    get movingDistance(): number;
    set movingDistance(newval: number);
    get penSize(): number;
    set penSize(newval: number);
    forward(dodraw: boolean): void;
    turn(doright: boolean): void;
    push(): void;
    pop(): void;
    exec(commands: string): void;
}
/// <reference path="Builtin.d.ts" />
/// <reference path="Process.d.ts" />
/// <reference path="Enum.d.ts" />
declare function requestContactAccess(): boolean;
/*
 * Builtin.d.ts: Declaration of type and functions of ArisiaLibrary
 */


declare function _alloc_Frame(): FrameIF ;

/**
 * Transpiler.ts
 */
/// <reference path="KiwiLibrary.d.ts" />
/// <reference path="Builtin.d.ts" />
/// <reference path="Frame.d.ts" />
declare function _definePropertyIF(frame: FrameIF, names: string[]): void;
/**
 * Builtin.d.ts : Built-in objects in KiwiComponents
 */

declare function _enterView(path: string, arg: any, cbfunc: (retval: any) => void): void ;
declare function _alert(type: AlertType, message: string, labels: string[], cbfunc: (retval: number) => void): void ;
declare function leaveView(param: any): void ;

declare function _openPanel(title: string, type: FileType, exts: string[], cbfunc: any): void ;
declare function _savePanel(title: string, cbfunc: any): void ;


/// <reference path="ArisiaLibrary.d.ts" />
/// <reference path="Builtin.d.ts" />
declare function openPanel(title: string, type: FileType, exts: string[]): URLIF | null;
declare function savePanel(title: string): URLIF | null;
/// <reference path="ArisiaLibrary.d.ts" />
/// <reference path="Builtin.d.ts" />
declare function alert(type: AlertType, message: string, labels: string[]): number;
declare function enterView(path: string, arg: any): any;
