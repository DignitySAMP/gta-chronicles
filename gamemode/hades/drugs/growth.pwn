/*
Drug growth
	 - Drugs grow over a period of time. The time is impacted based on base potency (low potency drugs take less time to grow, high potency take longer)
	 - It has to be interacted with once every 25 ticks. You have 8 hours to interact.
	 -- Failing to interact will add a -1 to potency (down to 0) regardless of "base" potency with the chance to lose all additional potency
	 -- Interacting every tick will give you full potency potential. You will have a chance to get 1 extra potency (RNG)
	 - Your goal is to have interaction ticks at 0 or above it. Going below it will impact your potency.
	 - Interaction is a simple key press, but you are expected to roleplay interaction (i.e. watering your weed, boiling your crack, ...)
	 - Each drug growth is logged.
*/