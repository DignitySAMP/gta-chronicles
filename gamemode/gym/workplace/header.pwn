
// Maximum stat level = 25.
enum E_PLAYER_STATS {

	// Weight and muscle unlock different fightstyles, damage reduction and increased damage.
	// Default fightstyle: punching

	// Punch / kick fightstyle (ctrl+f default):
	// Minimum of 10 muscle
	// Maximum of 15 weight
	// Increased melee damage by 0.25
	// Reduced melee damage by 0.25

	// Kungfu fightstyle
	// Minimum of 15 muscle
	// Maximum of 10 weight
	// Increased melee damage by 0.50
	// Reduced melee damage by 0.50

	// Boxing fightstyle:
	// Minimum of 20 muscle
	// Maximum of 7 weight
	// Increased melee damage by 1.00
	// Reduced melee damage by 1.00

	// Fightstyles will be lost if not maintained. If you don't hit the gym, your muscle naturally detoriates.
	// You will also be "forced" to eat in order to heal (new drivethru system, vending machine system, ... added)
	// which will make you increase weight and further detoriate your muscle.


	E_STAT_WEIGHT,
	E_STAT_MUSCLE,

	// Tired determines when you can get "progress" from the gym. If tired is full, then you must
	// wait for it to go down to at least 0. (Goes down by 1 every 5 minutes) (tired full = +- 2 hours cooldown)
	// This stat is only ever increased after a workout and serves as a restriction against grinding.
	// You can maximum do 4 levels (muscle/weight) before you get level 25 tired.
	E_STAT_TIRED,

	// Hunger determines muscle gain. The more muscle you get, the more hungry you will get.
	// You will get weight for being hungry, though! Hunger serves as "energy" 
	// (the more hunger, the less muscle gain you'll get)
	E_STAT_HUNGER,

	// Thirst determines weight loss. The more weight you lose, the thirstier you will get.
	// Thirst directly influences hunger loss as well. For best results, stay hydrated.
	E_STAT_THIRST

}

OnPlayerChangeStats(playerid) {



}