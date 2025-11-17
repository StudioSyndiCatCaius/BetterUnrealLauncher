extends PanelContainer
class_name ui_Project

@export var IMG_icon : TextureRect
@export var N_lbl_nam : Label
@export var N_lbl_path : Label
@export var N_lbl_ver : Label
@export var N_lbl_cat : Label
@export var N_lbl_desc : Label

@export var btn_OpenPath: Button
@export var btn_launch: Button
@export var btn_OpenPlugin: Button
@export var btn_PlayGame: Button

var project: UE_Project

func _ready():
	modulate.a=0

func LOAD(proj: UE_Project):
	if proj:
		project=proj
		var icon=preload("uid://cdxqftbdy03w1")
		if proj.thumbnail:
			icon=proj.thumbnail
		IMG_icon.texture=icon
		N_lbl_nam.text=project.file_name
		N_lbl_path.text=project.base_path
		N_lbl_ver.text=project.uproject_data.get('EngineAssociation',"?")
		N_lbl_cat.text=project.uproject_data.get('Category',"")
		N_lbl_desc.text=project.uproject_data.get('Description',"")
		modulate.a=1
		btn_PlayGame.disabled=!FileAccess.file_exists(project.Get_PathTo_LastBuild())
			
	else:
		modulate.a=0


func _on_btn_launch_pressed():
	if project:
		project.LAUNCH()


func _on_btn_open_path_pressed():
	OS.shell_open(project.base_path)

func _on_btn_open_path_2_pressed():
	OS.shell_open(project.base_path+"/Plugins/")

func _on_btn_play_game_pressed():
	project.PlayBuild()
