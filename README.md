## A (Better) Unreal Engine Launcher
<img src="icon.png" width="200" height="200">

This is a very simple and fast alternative Unreal Engine project launcher written in Godot. (heh)


### How to use?
* Download & Launch it
![alt text](DOCS/image/showcase_1.png)
* Go into `CONFIG` and add all paths to where your engine versions & projects are located (seperated by line breaks).`uprojects` are searched one folder deep from where the Project Path is.
![alt text](DOCS/image/showcase_2.png)
* Back in `Main` select `Reload` to load your & project engine versions.
* Just double click your project and it will load. (WITHOUT closing the launcher.)

##### To-Do
* Add advanced panel for Engine & Project details.
* Add tags to filter by engine


##### Possible Future Features:
* Option to autocreate a `.bat` file in the project folder to force run it with the given UE version.
* More support for custom UE builds, like [Vite Studio's Fork.](https://x.com/theredpix/status/1977561999027347966)