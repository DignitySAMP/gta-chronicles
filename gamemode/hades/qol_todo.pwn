
#################################################################################################################################
#################################################################################################################################
    
Add /fadv (approved by admins, paid through fbank)



(Copacabana Suggestion for Chopshop)
tl;dr: Chop shop script exists, owned by official facs that get approved for it by FM.

Script goes like this:
Faction leader (or a person he picks for it) is the owner. They can give /givechopperms to any player in the server. The players then are able to access that chop shop and chop cars there. It would require you to stay near the car for X amount of time and RP it.
Payments for chopping cars would be increased and the public chop shop removed.



 - Go through all concerns after the 31th. Sort everything properly i.e. "Management", "Factions", "Community", "Staff", "Development" and split it well




DRUG SYSTEM IS NOW FULL PRIORITY! PRISON AFTER



/omakehelper -> copy paste -£> /omakyadmin

Make a dev log video for the YouTube channel about the FM changes (have Reb voice record it, maybe with a diff staff member)
 - Discuss this with Reb

Make a dev log video for drugs, our plans (unlist it), have it voice covered. Release video this weekend of script v1 and get feedback.
 - DISCUSS WITH REB/MANAGEMENT WHICH DRUGS TO GATEKEEP AND WHICH ONES TO GIVE FREE ACCESS
 - Make it so staff can /createdrug [name] [addiction %] [health + or -] [extra] - create a base set of settings they can choose from. 
Effects:
 - RC-RP mushroom / peyote effect (multiple ones, randomized) (different world, zones in and out occassionally, add RP text too and a brief sentence telling them to RP the effects, explain the effects)
 - Different weathers like LS-RP (green, red, ...) + eventual screen shakes & screen fades in different colors (i.e. add red timecyc through red/pink fading, then fade from red to green, show green timecyc, irky shit)
 - Ability to heal or take health over time depending on the drug
 - Ability to boost gym progress (i.e. cocaine, steroids, ...) and have drugs alter gym / hunger stats
 - + See notes chat Reb!



 - Remove the gym progression entirely, rather just make it a visual minigame.
 Fightstyles should be given through the schemes system.
 (SEE REB FOR SCHEME DRAFT) 



 - Make basic prison script! THE REST HAS TO WAIT!!!!
 - Then do phone, and jobs after



Structured Staffhelp:
to add on this, like /ahelp [passpoints]
/ahelp [properties]
way cleaner, simpler
you need a specific passpoint cmd?
no need to burn your eyes looking at 10000 character
/ahelp passpoint
and a simple list that explains what each cmd does
i'm thinking of putting it in dialogs too, and allowing you to "print" it if you cba
dialogs showing the full info, saying what each cmd does, and print just a simple SCM with the commands listed like w egot rn



Structured /report:
maybe could even make it "player has broken a rule" -> shows list with all rule subjects
so ppl know whats good
or "misc"
so you can request misc help and/or select which rule was broken
and then automatically deny the report with "this rule is too broad to cover ingame, make a forum report with evidence, etc"
"what are you reporting"
- a player (shows rule list)
- a faction (make faction report ticket on support)
- a staff member (make staff ticket on support)
- misc (free entry)

#################################################################################################################################
#################################################################################################################################
4. Ability to hire other players as managers of your biz, allowing them to lock/unlock and /badvert as well as access propbank.
5. More furniture to /furni
10. Character Kill if player is arrested for many serious crimes. (To avoid robot gang members and create a bit of fear of police)
12. Create a streak limit for Dockworker job. (i.e. after 400 deliveries payments do not increase)
13. [HAS TO BE LOGGED / WARNED PROPERLY] /breakin system for houses.



Bronze Donator:
	[DONATION ONLY] Increase the amount of cars a player can have on one character.
	[DONATION ONLY] Make house and business limits static since joining the server. (up to 3 homes and 2 bizzes).
	[Bike Permission]
	[Motorcycle Permission (Sanchez, FCR, PCJ)]

Bike permission ($10 monthly):
 Bike / BMX permissions
 [Motorcycle Permission (Sanchez, FCR, PCJ)]
 - Automatically expires after 1 month

https://www.codeleaks.io/increase-session-timeout-in-php/
https://linuxhint.com/set-session-timeout-php

Reb suggestion:
Weed:
- Reduce health-regen;
Crack:
- Remove shaky screen;
- Reduce Armor to 15;

----
something like /propertyopen for business types and it shows up in a /biz list - selecting it shows you a gps check point

You've set your property to OPEN - it'll now display in the /biz list for others to find.
(stays up in /biz until the player logs out or something)

/bizlist = shows property id address, property name - selecting it allows you to check gps 
---


From what I got we've figured out some minor tweaks - entirely 'stat-based' - on drugs, that can be done to make things more realistic. I'll follow up on that but basically:
1) little less weed regen, anyone to be able to plant if they have seeds, not only facs;
2) no shaky crack screen and tweak to give less armor
3) any minor tweak to coke would be okay, though not needed - only if dev wants;

Farming (job)
 - Truckers transport the farmed goods (wheat, meat, ...) to the factory
Factory (Job)
 - Truckers transport the factory goods (burgers, buns, ...) to the restaurants
Restaurant owners pay a small % to refill the stocks


[Basic Government Taxes]
 - Portion of savings goes to gov fbank (1.010%)
 - Basic paycheck taxation for cars (insurance) and properties (land tax) (1.0065% of buy price)
 - Basic taxation of income on property till (1.008%)

If you want taxes I can make it so a portion of saving interest is put in the gov fbank. I can also add a basic taxation system based on the qty of owned properties and vehicles
But there's no time for anything more elaborate right now

/gvisible
/companypaycheck [tier1] [tier2] [tier3]
(needs money in /groupbank)

Add reyo marco's bistro models to furniture / spawnables (ask him for latest version)

Reyo: Efficient way to travrse all businesses (browse per type, perhaps allow admins to tp using /gps)
(make it show how many businesses there are, and also of each type)


if a player takes out a gun from car/house or is gifted it and they already hold a weapon with the same type
	make it send warning!


- add cmd for furniture that lets admins spawn in custom objects for players that arent normally attainable through /furni buy 
(they need to do /furnimode, steal the prop id from there)

- replace /buy with a simple dialog system for now
- remove the house textdraw, change it to the subtitle + alert textdraw
- remove phone textdraw, see phone todo
- make it so new players get an easy way of transport (cheap car? discuss with team)
fix logout (don't call textdraw creation/destruction on spawn)
fully delete the poker script & reimplement it, fix the GUI and remove the spam


+ add the remaining furniture objects suggested from the thread

Import SOLS pool script to GTA C (less spam, more RP lines, cleaner GUI)
check the putting things in house inventory and /id scripts. - There's still things that show UCP name (i.e. placing things in property inventory and /id)

--------------------------------------------------

/gunbanlist - to see which players have an assigned gunban and when it was added. (for bike bans maybe too)
- useful for moderation

[BillyBobJoe - Assigned: 01/05/2022] 


--------------------------------------------------

Nature Update 
 - Fishing Update (see fishing/header)
 - Hunting Update (ability to hunt deer, bears, ... and sell the meat for money!)
 - Camping Update (ability to spawn wagons, tents, campfires, equip more bags, ...)
 - Improved forest maps