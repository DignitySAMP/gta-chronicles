enum E_FISH_DATA {

	E_FISH_NAME[64],
	Float: E_FISH_MIN_WEIGHT, 
	Float: E_FISH_MIN_PAYOUT,
	E_FISH_COLOUR
};

// Add a "get name" function for this
enum {
	E_FISH_CLASS_NONE = 1,
	E_FISH_CLASS_SMALL,
	E_FISH_CLASS_MEDIUM,
	E_FISH_CLASS_LARGE,
	E_FISH_CLASS_HUGE, // deep sea
	E_FISH_CLASS_EXOTIC,
	E_FISH_CLASS_LEGENDARY
}

enum {
	E_FISH_MAX_MODIFIER = 1.5
} ;

/*
https://hayday.fandom.com/wiki/Fishing_List
https://hayday.fandom.com/wiki/Fish
*/
new Fish [ ] [ E_FISH_DATA ] = {


	{ "Arctic charr", 			4.747, 	180, 	0xa67ad8FF },
	{ "Asp", 					1.764, 	180, 	0x89c1e9FF },
	{ "Bitterling", 			3.793,	160,	0x746aceFF },
	{ "Black Bullhead", 		1.658,	140,	0xb38c4eFF },
	{ "Bluegill", 				4.519,	160,	0x2863d6FF },
	{ "Bluespotted Sunfish", 	4.279,	140,	0x776546FF },
	{ "Brook Trout", 			2.886,	100,	0x776546FF },
	{ "Carp", 					12.186,	140,	0x66cc61FF },
	{ "Coho Salmon", 			4.315,	140,	0x1fac18FF },
	{ "Copper Redhorse", 		3.837,	40,		0xac7018FF },
	{ "Fallfish", 				3.739,	120,	0x18ac88FF },
	{ "Giant Barb", 			13.126,	120,	0xaa18acFF },
	{ "Golden Trout", 			2.489,	200,	0xd3a731FF },
	{ "Goldfish", 				4.513,	200,	0xd37a31FF },
	{ "Grass Carp", 			2.039,	120,	0x279d21FF },
	{ "Greater Redhorse", 		2.590,	180,	0x9d5221FF },
	// Continue at "Green Sunfish"

}
#define RandomEx(%0,%1)                     (random((%1) - (%0)) + (%0))
Float: Fish_CheckRarity(constant) {
	// The higher the rarity, the less chance you can actually recieve it.

	new min_value, max_value ;

	switch ( Fish_GetClass(constant) ) {

		case E_FISH_CLASS_SMALL: 		min_value = 20, max_value = 80 ;
		case E_FISH_CLASS_MEDIUM: 		min_value = 30, max_value = 80 ;
		case E_FISH_CLASS_LARGE: 		min_value = 40, max_value = 80 ;
		case E_FISH_CLASS_HUGE: 		min_value = 35, max_value = 70 ; // deep sea
		case E_FISH_CLASS_EXOTIC: 		min_value = 40, max_value = 70 ;
		case E_FISH_CLASS_LEGENDARY: 	min_value = 45, max_value = 70 ;
	}

	return (random((max_value) - (min_value)) + (min_value)) ;
}

Float: Fish_GetMaxWeight(constant) {

	return Fish [ constant ] [ E_FISH_MIN_WEIGHT ] *  Fish_GetClass(constant) ;
}
Float: Fish_GetMaxPayout(constant) {

	return ( Fish [ constant ] [ E_FISH_MIN_PAYOUT ] * Fish_GetClass(constant) ) * Fish_GetMaxWeight ( constant ) / E_FISH_MAX_MODIFIER ; 
}

Float: Fish_GetClass(constant) {

	switch ( Fish [ constant ] [ E_FISH_MIN_WEIGHT ] ) {

		case 0.0: 			return E_FISH_CLASS_NONE ;
		case 0.1 .. 4.0: 	return E_FISH_CLASS_SMALL ;
		case 4.1 .. 7.5 : 	return E_FISH_CLASS_MEDIUM ;
		case 7.6 .. 12.5: 	return E_FISH_CLASS_LARGE ;
		case 12.6 .. 15.0: 	return E_FISH_CLASS_HUGE ;
		case 15.1 .. 20.0: 	return E_FISH_CLASS_EXOTIC ;
		default: 			return E_FISH_CLASS_LEGENDARY ;
	}

	return E_FISH_CLASS_NONE ;
}