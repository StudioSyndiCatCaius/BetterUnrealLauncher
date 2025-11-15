extends Resource
class_name UE_Project

var base_path=""
var file_name=""
var engine_version='0.0'
var thumbnail: Texture2D
var thumb_file
var uproject_data={
	
}

func LAUNCH():
	var engine_key=uproject_data.get('EngineAssociation',"")
	var _ueVer=G.ENGINE_GetVersion(engine_key)
	if _ueVer:
		var _edExe=_ueVer.Get_PathTo_EditorEXE()
		var _projFile=Get_PathTo_Uproject()
		OS.create_process(_edExe,[_projFile])
		G.LOG("Launching Porject: "+Get_PathTo_Uproject(),0)
	else:
		G.LOG("Failed to launch. Engine version "+engine_key+" NOT installed",2)

func Load(uproject_path: String):
	var path_split=uproject_path.rsplit("/",true,1)
	base_path=path_split[0]
	base_path.replace("\\","/")
	base_path+="/"
	base_path.replace("//","/")
	file_name=uproject_path.get_file().get_basename()
	var file_str=FileAccess.get_file_as_string(uproject_path)
	uproject_data=JSON.parse_string(file_str)
	thumb_file=base_path+file_name+".png"
	if FileAccess.file_exists(thumb_file):
		thumbnail=G_Load.Texture(thumb_file)

func Get_PathTo_Uproject() -> String:
	return base_path+file_name+".uproject"
