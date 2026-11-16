enum E_GUN_SELECTION_DATA {
	E_GUN_SEL_GUNID,
	E_GUN_SEL_DESC [ 32 ]
} ;

new GunSelection [ ] [ E_GUN_SELECTION_DATA ] = {

	{ E_GUN_SEL_MELEE, 			"Melee Weapon" },
	{ E_GUN_SEL_PISTOL, 		"Pistol"  },
	{ E_GUN_SEL_SHOTGUN, 		"Shotgun" }, 
	{ E_GUN_SEL_SMG, 			"Submachinegun"	 }, 
	{ E_GUN_SEL_ASSAULT, 		"Assault Rifle"	 },
	{ E_GUN_SEL_BOLT_ACTION, 	"Bolt-Action Rifle" }
} ;