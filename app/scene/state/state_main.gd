extends PanelContainer

# - MAIN
@export var list_engine_ver: ItemList
@export var list_projects: ItemList
@export var lbl_log_line: Label

# - CONFIG
@export var txtedit_paths_engines: TextEdit
@export var txtedit_paths_projects: TextEdit

const ICON = preload("uid://cdxqftbdy03w1")


func _ready():
	G.GlobalEvent.connect(_OnGlobalEvent)
	Reload_All()
	txtedit_paths_engines.text="\n".join(G.config.get('engine_installpaths',[""]))
	txtedit_paths_projects.text="\n".join(G.config.get('project_installpaths',[""]))

func Reload_All():
	list_engine_ver.clear()
	for i in G.UE_LoadedVersion:
		list_engine_ver.add_item(i.engine_version,ICON)
	list_projects.clear()
	
	for i in G.UE_LoadedProjects:
		var in_icon=ICON
		if i.thumbnail:
			in_icon=i.thumbnail
		list_projects.add_item(i.file_name,in_icon)


func _OnGlobalEvent(event: StringName, context):
	if event=='log':
		lbl_log_line.text=context.text
		lbl_log_line.modulate=G.log_data[context.type].color
		%timer_logDisplay.start()


func _on_timer_log_display_timeout():
	lbl_log_line.text=""

var can_launch=true

func _on_list_engine_ver_item_activated(index):
	if can_launch:
		can_launch=false
		var _ver=G.UE_LoadedVersion[index]
		_ver.LAUNCH()
		list_engine_ver.modulate.a=0.5
		%timer_LaunchCooldown.start()


func _on_timer_launch_cooldown_timeout():
	list_engine_ver.modulate.a=1
	can_launch=true


func _on_btn_open_save_pressed():
	OS.shell_open(ProjectSettings.globalize_path("user://"))

func _on_list_projects_item_activated(index):
	var _proj=G.UE_LoadedProjects[index]
	if _proj:
		_proj.LAUNCH()


## ========================================================================
## config
## ========================================================================

func _on_txtedit_paths_engines_text_changed():
	G.config.engine_installpaths=txtedit_paths_engines.text.split("\n")


func _on_txt_edit_paths_projects_text__changed():
	G.config.project_installpaths=txtedit_paths_projects.text.split("\n")


func _on_btn_reload_engines_pressed():
	G.ENGINE_LoadVersions()
	Reload_All()

func _on_btn_reload_projects_pressed():
	G.PROJECT_Reload()
	Reload_All()
