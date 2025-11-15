extends Node

signal GlobalEvent(event: StringName, context)

var system_platform='Win64'

var log=[]

var UE_versionList={
	'4.0'={},'4.1'={},'4.2'={},'4.3'={},'4.4'={},'4.5'={},'4.6'={},'4.7'={},'4.8'={},
	'4.9'={},'4.10'={},'4.11'={},'4.12'={},'4.13'={},'4.15'={},'4.16'={},'4.17'={},
	'4.18'={},'4.19'={},'4.20'={},'4.21'={},'4.22'={},'4.23'={},'4.25'={},'4.26'={},
	'4.27'={},'5.0'={},'5.1'={},'5.2'={},'5.3'={},'5.4'={},'5.5'={},'5.6'={},'5.7'={},
}

var config={
	engine_installpaths=[""],
	project_installpaths=[""]
}
var config_path = "user://config.json"
var config_default={
	engine_installpaths=[
		"C:/Program Files/Epic Games/",
		"C:/Program Files/UnrealEngine/",
		"D:/Games/EpicGames/UnrealEngine/",
		"D:/Games/EpicGames/Games/",
	],
	project_installpaths=[
		""
	]
}

var UE_LoadedVersion: Array[UE_EngineVersion]
var UE_LoadedProjects: Array[UE_Project]

func _ready():
	CONFIG_Load()
	RELOAD_All()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		CONFIG_Save()
		get_tree().quit()

func RELOAD_All():
	ENGINE_LoadVersions()
	PROJECT_Reload()

func ENGINE_LoadVersions():
	UE_LoadedVersion.clear()
	print("Loading UE versions: ")
	for i in UE_versionList:
		for p in config.engine_installpaths:
			var engine_path=p+"UE_"+i
			var target_path=engine_path+"/Engine/Binaries/Win64/UnrealEditor.exe"
			print("    - tried to load UE version from: "+target_path)
			if FileAccess.file_exists(target_path):
				
				var new_ver: UE_EngineVersion=UE_EngineVersion.new()
				new_ver.base_path=engine_path
				new_ver.engine_version=i
				UE_LoadedVersion.push_back(new_ver)
				print("        - SUCCESS")
			else:
				print("        - FAILED")

func ENGINE_GetVersion(key: String) -> UE_EngineVersion:
	for i in UE_LoadedVersion:
		if i.engine_version==key:
			return i
	return null


func ENGINES_GetPaths() -> PackedStringArray:
	var out: PackedStringArray
	print("Loading UE versions: ")
	for i in UE_versionList:
		for p in config.engine_installpaths:
			var engine_path=p+"UE_"+i
			var target_path=engine_path+"/Engine/Binaries/Win64/UnrealEditor.exe"
			print("    - tried to load UE version from: "+target_path)
			if FileAccess.file_exists(target_path):
				out.push_back(engine_path)
				print("        - SUCCESS")
			else:
				print("        - FAILED")
	return out
	
func ENGINES_GetPaths_EXEs() -> PackedStringArray:
	var out: PackedStringArray
	for i in ENGINES_GetPaths():
		var target_exe=i+"/Engine/Binaries/Win64/UnrealEditor.exe"
		if FileAccess.file_exists(target_exe):
			out.push_back(target_exe)
	return out

func PROJECT_Reload():
	UE_LoadedProjects.clear()
	for i in config.project_installpaths:
		for p in PROJECT_Find(i):
			var _newProj: UE_Project=UE_Project.new()
			_newProj.Load(p)
			UE_LoadedProjects.push_back(_newProj)

func PROJECT_Find(folder_path: String) -> Array:
	var uprojects = []
	
	# Check if the folder exists
	if not DirAccess.dir_exists_absolute(folder_path):
		push_error("Folder not found: " + folder_path)
		return uprojects
	
	# Open the main directory
	var dir = DirAccess.open(folder_path)
	if dir == null:
		push_error("Failed to open directory: " + folder_path)
		return uprojects
	
	dir.list_dir_begin()
	var item_name = dir.get_next()
	
	# Iterate through items in the main folder
	while item_name != "":
		var item_path = folder_path.path_join(item_name)
		
		# Check if it's a directory
		if dir.current_is_dir() and item_name != "." and item_name != "..":
			# Search inside this subfolder for .uproject files
			var subdir = DirAccess.open(item_path)
			if subdir != null:
				subdir.list_dir_begin()
				var subitem_name = subdir.get_next()
				
				while subitem_name != "":
					if not subdir.current_is_dir() and subitem_name.ends_with(".uproject"):
						var uproject_path = item_path.path_join(subitem_name)
						uprojects.append(uproject_path)
						print("Found .uproject: ", uproject_path)
					
					subitem_name = subdir.get_next()
				
				subdir.list_dir_end()
		
		# Also check the root folder itself for .uproject files
		elif not dir.current_is_dir() and item_name.ends_with(".uproject"):
			var uproject_path = folder_path.path_join(item_name)
			uprojects.append(uproject_path)
			print("Found .uproject: ", uproject_path)
		
		item_name = dir.get_next()
	
	dir.list_dir_end()
	
	print("Total .uproject files found: ", uprojects.size())
	return uprojects




func NODES_ClearChildren(node: Node):
	for i in node.get_children():
		i.queue_free()

enum LOG_TYPE {
	NORMAL=0,
	WARNING=1,
	ERROR=2
}

var log_data=[
	{
		color=Color.WHITE,
	},
	{
		color=Color.YELLOW,
	},
	{
		color=Color.RED,
	},
]

func LOG(text: String, type: LOG_TYPE ):
	var log_data={
		text=text,
		type=type,
	}
	log.push_back(log_data)
	print(" APP LOG: --  "+text)
	GlobalEvent.emit('log',log_data)



func CONFIG_Load():
	if FileAccess.file_exists(config_path):
		# File exists, load it
		var file = FileAccess.open(config_path, FileAccess.READ)
		var json_string = file.get_as_text()
		file.close()
		
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		
		if parse_result == OK:
			config = json.data
			print("Config loaded successfully")
		else:
			print("Error parsing config file, using defaults")
			config = config_default.duplicate_deep()
	else:
		# File doesn't exist, create it with defaults
		print("Config file not found, creating new one")
		config = config_default.duplicate_deep()
		CONFIG_Save()

func CONFIG_Save():
	var file = FileAccess.open(config_path, FileAccess.WRITE)
	var json_string = JSON.stringify(config, "\t")
	file.store_string(json_string)
	file.close()
	print("Config saved to: ", config_path)
