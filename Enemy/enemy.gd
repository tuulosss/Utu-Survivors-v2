extends CharacterBody2D


@export var movement_speed=40.0
@export var hp=20
@export var knockback_recovery = 3.5
@export var experience = 1
@export var damage = 1
var knockback = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")
@onready var snd_hit = $snd_hit
@onready var snd_death = $snd_death
@onready var loot_base = get_tree().get_first_node_in_group("loot")
@onready var hitBox = $HitBox
@onready var sprite = $Sprite2D

var death_anim = preload("res://Enemy/explosion.tscn")
var exp_gem = preload("res://Objects/experience_gem.tscn")
signal remove_from_array(object)

func _ready():
	hitBox.damage = damage
	
	
func  _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	move_and_slide()
	if direction.x > 0.1:
		sprite.flip_h = true;
	elif direction.x < -0.1:
		sprite.flip_h = false;
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)

	velocity = direction*movement_speed
	velocity += knockback

func death():
		emit_signal("remove_from_array",self)
		var enemy_death = death_anim.instantiate()
		enemy_death.scale = $Sprite2D.scale*10
		enemy_death.global_position = global_position
		get_parent().call_deferred("add_child",enemy_death)
		var new_gem = exp_gem.instantiate()
		new_gem.global_position = global_position
		new_gem.experience = experience 
		loot_base.call_deferred("add_child", new_gem)
		queue_free()

func _on_hurt_box_hurt(damage, angle, knockback_amount):
	hp-=damage
	knockback = angle * knockback_amount
	print("enemy hp", hp)
	if hp <= 0:
		death()
	else:
		snd_hit.play()
