extends Node

const ICON_PATH="res://Textures/Items/Upgrades/"
const WEAPON_PATH="res://Textures/Items/Weapons/"

const UPGRADES = {
	"HTTPattack1":{
		"icon": WEAPON_PATH +"HTTPattack.png",
		"displayname": "HTTP attack",
		"details": "Your HTTP fireball gains +10 knockback",
		"level": "Level 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"HTTPattack2":{
		"icon": WEAPON_PATH +"HTTPattack.png",
		"displayname": "HTTP attack",
		"details": "An additional HTTP fireball is fired",
		"level": "Level 2",
		"prerequisite": ["HTTPattack1"],
		"type": "weapon"
	},
	"HTTPattack3": {
		"icon": WEAPON_PATH + "HTTPattack.png",
		"displayname": "HTTP attack",
		"details": "HTTP attacks now pass through another enemy and do + 25% damage",
		"level": "Level: 3",
		"prerequisite": ["HTTPattack2"],
		"type": "weapon"
	},
	"HTTPattack4": {
		"icon": WEAPON_PATH + "HTTPattack.png",
		"displayname": "HTTP attack",
		"details": "An additional 2 HTTP attack are thrown",
		"level": "Level: 4",
		"prerequisite": ["HTTPattack3"],
		"type": "weapon"
	},
	"NÄPPIS1": {
		"icon": WEAPON_PATH + "näppis.png",
		"displayname": "NÄPPIS",
		"details": "A magical NÄPPIS will follow you attacking enemies in a straight line",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"NÄPPIS2": {
		"icon": WEAPON_PATH + "näppis.png",
		"displayname": "NÄPPIS",
		"details": "The NÄPPIS will now attack an additional enemy per attack",
		"level": "Level: 2",
		"prerequisite": ["NÄPPIS1"],
		"type": "weapon"
	},
	"NÄPPIS3": {
		"icon": WEAPON_PATH + "näppis.png",
		"displayname": "NÄPPIS",
		"details": "The NÄPPIS will attack another additional enemy per attack",
		"level": "Level: 3",
		"prerequisite": ["NÄPPIS2"],
		"type": "weapon"
	},
	"NÄPPIS4": {
		"icon": WEAPON_PATH + "näppis.png",
		"displayname": "NÄPPIS",
		"details": "The NÄPPIS now does + 5 damage per attack and causes 20% additional knockback",
		"level": "Level: 4",
		"prerequisite": ["NÄPPIS3"],
		"type": "weapon"
	},
	"matrix1": {
		"icon": WEAPON_PATH + "matrix.png",
		"displayname": "Matrix",
		"details": "A matrix is created and random heads somewhere in the players direction",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"matrix2": {
		"icon": WEAPON_PATH + "matrix.png",
		"displayname": "Matrix",
		"details": "An additional Matrix is created",
		"level": "Level: 2",
		"prerequisite": ["matrix1"],
		"type": "weapon"
	},
	"matrix3": {
		"icon": WEAPON_PATH + "matrix.png",
		"displayname": "Matrix",
		"details": "The Matrix cooldown is reduced by 0.5 seconds",
		"level": "Level: 3",
		"prerequisite": ["matrix2"],
		"type": "weapon"
	},
	"matrix4": {
		"icon": WEAPON_PATH + "matrix.png",
		"displayname": "Matrix",
		"details": "An additional matrix is created and the knockback is increased by 25%",
		"level": "Level: 4",
		"prerequisite": ["matrix3"],
		"type": "weapon"
	},
	"armor1": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armor",
		"details": "Reduces Damage By 2 point",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"armor2": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armor",
		"details": "Reduces Damage By an additional 2 point",
		"level": "Level: 2",
		"prerequisite": ["armor1"],
		"type": "upgrade"
	},
	"armor3": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armor",
		"details": "Reduces Damage By an additional 2 point",
		"level": "Level: 3",
		"prerequisite": ["armor2"],
		"type": "upgrade"
	},
	"armor4": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armor",
		"details": "Reduces Damage By an additional 2 point",
		"level": "Level: 4",
		"prerequisite": ["armor3"],
		"type": "upgrade"
	},
	"speed1": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Speed",
		"details": "Movement Speed Increased by 25% of base speed",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"speed2": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Speed",
		"details": "Movement Speed Increased by an additional 25% of base speed",
		"level": "Level: 2",
		"prerequisite": ["speed1"],
		"type": "upgrade"
	},
	"speed3": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Speed",
		"details": "Movement Speed Increased by an additional 25% of base speed",
		"level": "Level: 3",
		"prerequisite": ["speed2"],
		"type": "upgrade"
	},
	"speed4": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Speed",
		"details": "Movement Speed Increased an additional 25% of base speed",
		"level": "Level: 4",
		"prerequisite": ["speed3"],
		"type": "upgrade"
	},
	"tome1": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Tome",
		"details": "Increases the size of spells an additional 15% of their base size",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"tome2": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Tome",
		"details": "Increases the size of spells an additional 15% of their base size",
		"level": "Level: 2",
		"prerequisite": ["tome1"],
		"type": "upgrade"
	},
	"tome3": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Tome",
		"details": "Increases the size of spells an additional 15% of their base size",
		"level": "Level: 3",
		"prerequisite": ["tome2"],
		"type": "upgrade"
	},
	"tome4": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Tome",
		"details": "Increases the size of spells an additional 15% of their base size",
		"level": "Level: 4",
		"prerequisite": ["tome3"],
		"type": "upgrade"
	},
	"scroll1": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Scroll",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"scroll2": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Scroll",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 2",
		"prerequisite": ["scroll1"],
		"type": "upgrade"
	},
	"scroll3": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Scroll",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 3",
		"prerequisite": ["scroll2"],
		"type": "upgrade"
	},
	"scroll4": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Scroll",
		"details": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 4",
		"prerequisite": ["scroll3"],
		"type": "upgrade"
	},
	"ring1": {
		"icon": ICON_PATH + "urand_mage.png",
		"displayname": "Ring",
		"details": "Your spells now spawn 1 more additional attack",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"ring2": {
		"icon": ICON_PATH + "urand_mage.png",
		"displayname": "Ring",
		"details": "Your spells now spawn an additional attack",
		"level": "Level: 2",
		"prerequisite": ["ring1"],
		"type": "upgrade"
	},
	"food":{
		"icon": ICON_PATH +"salmon_paste.png",
		"displayname": "Salmon Paste (Lohimureke)",
		"details": "Eating Lohimureke heals you for 20 health",
		"level": "N/A",
		"prerequisite": [],
		"type": "item"
	}
	
}
