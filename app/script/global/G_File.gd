extends Node


func Subfolders(folder_path: String) -> PackedStringArray:
	var subfolders = []
	
	# Check if the folder exists
	if not DirAccess.dir_exists_absolute(folder_path):
		push_error("Folder not found: " + folder_path)
		return subfolders
	
	# Open the directory
	var dir = DirAccess.open(folder_path)
	if dir == null:
		push_error("Failed to open directory: " + folder_path)
		return subfolders
	
	dir.list_dir_begin()
	var item_name = dir.get_next()
	
	# Iterate through all items
	while item_name != "":
		# Check if it's a directory (and not . or ..)
		if dir.current_is_dir() and item_name != "." and item_name != "..":
			var subfolder_path = folder_path.path_join(item_name)
			subfolders.append(subfolder_path)
			print("Found subfolder: ", subfolder_path)
		
		item_name = dir.get_next()
	
	dir.list_dir_end()
	
	print("Total subfolders found: ", subfolders.size())
	return subfolders
