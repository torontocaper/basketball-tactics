extends Sprite2D

# this script gets the colors from an image and creates a gradient based on those colors

var space_colors : PackedColorArray
var space_image : Image

var gradient : Gradient = Gradient.new()
var offsets : PackedFloat32Array
var new_sprite : Sprite2D = Sprite2D.new()
var new_sprite_texture : NoiseTexture2D = NoiseTexture2D.new() # create a new noise texture
var new_sprite_noise : Noise = FastNoiseLite.new()

# it also creates a label that reads out the co-ordinates and the noise value at those co-ordinates
var coord_label : Label = Label.new()
var mouse_x : int
var mouse_y : int

var pixel_x : int = 0
var pixel_y : int = 0

var color : Color
# Called when the node enters the scene tree for the first time.
func _ready():
	space_image = get_texture().get_image() # get the assigned texture as an image
	
	for columns in range(0, space_image.get_width()):
		for rows in range(0, space_image.get_height()):
			color = space_image.get_pixel(pixel_x, pixel_y) # get the color for each pixel
			if color.a == 0 or color in space_colors:
				pixel_y += 1
			else:
				space_colors.append(color) # add it to the space_colors array
				pixel_y += 1
		# this part doesn't seem like best practice
		pixel_y = 0
		pixel_x += 1
	
	gradient.colors = space_colors
	for i in range(len(space_colors)):
		offsets.append(float(i)/len(space_colors)) # interesting! set the offsets to even out across the gradient
	gradient.offsets = offsets
	gradient.interpolation_mode = Gradient.GRADIENT_INTERPOLATE_CONSTANT # hard colour boundaries
	
	# could export some of these
	new_sprite_noise.set_seed(randi())
	new_sprite_noise.set_noise_type(2)
	new_sprite_noise.set_domain_warp_enabled(true)
	new_sprite_noise.set_domain_warp_fractal_gain(1)
	new_sprite_noise.set_domain_warp_fractal_lacunarity(100)
	new_sprite_noise.frequency = 0.001
	
	new_sprite_texture.noise = new_sprite_noise
	new_sprite_texture.color_ramp = gradient
	new_sprite_texture.width = 1024
	new_sprite_texture.height = 768
	new_sprite.centered = false
	new_sprite.texture = new_sprite_texture
	new_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

	add_child(new_sprite)
	add_child(coord_label)
	
func _process(_delta):
	mouse_x = get_local_mouse_position().x
	mouse_y = get_local_mouse_position().y
	coord_label.text = "Mouse Coords: " + str(mouse_x) + ", " + str(mouse_y) + "\nNoise Value: " + str(new_sprite.texture.noise.get_noise_2d(mouse_x, mouse_y)) + "\nColor Value: " + str(new_sprite.texture.get_image().get_pixel(mouse_x, mouse_y))
	coord_label.position = get_local_mouse_position()
