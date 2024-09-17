extends Label

@onready var region_changed: AnimationPlayer = $RegionChanged

func new_region_changed(new_region):
	region_changed.play("found")
	self.text = new_region
