extends Resource
class_name UE_EngineVersion

var base_path=""
var engine_version='0.0'
var editor_exe="/Engine/Binaries/Win64/UnrealEditor.exe"

func Get_PathTo_Binaries() -> String:
	return base_path+"/Engine/Binaries/"+G.system_platform+"/"

func Get_PathTo_EditorEXE() -> String:
	return editor_exe

func LAUNCH():
	OS.execute_with_pipe(Get_PathTo_EditorEXE(),[],false)
	G.LOG("Starting Engine: "+Get_PathTo_EditorEXE(),0)
