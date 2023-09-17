
local globals = {
	BACK_COL = {160/255, 160/255, 160/255},
	PANEL_COL = {0.53, 0.53, 0.55},
	
	MASTER_VOLUME = 0.75,
	MUSIC_VOLUME = 0.4,
	DEFAULT_MUSIC_DURATION = 174.69,
	CROSSFADE_TIME = 0,
	
	PHYSICS_SCALE = 300,
	LINE_SPACING = 36,
	INC_OFFSET = -15,
	
	VIEW_WIDTH = 3000,
	VIEW_HEIGHT = 1800,
	SHOP_WIDTH = 800,
	MAIN_PADDING = 150,
	PROP_SPACING = 64,
	
	DEFAULT_LEVEL = "7TimeBelt",
	DEFAULT_LEVEL_SAVE_SUFFIX = "_test",
	HG_GRID_SIZE = 3200,
	FRAMES_PER_SECOND = 60,
	MIN_DIMENSION = 400,
	
	IGNORE_MOVE_ON_SELECT = false,
	
	PICKUP_LIST = {
		"timeJump",
		"timeReverse",
		"timeGun",
		"reverseGun",
		"timePause",
	},
	BOX_TYPES = {
		"none",
		"box",
		"bomb",
		"light",
		"balloon",
	},
}

return globals