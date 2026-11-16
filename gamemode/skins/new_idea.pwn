Basic website with basic template (pure.css with bootstrap)
You log in using your MA (make sure this is protected, look at player panel for info)

Basic ticket system displaying all pending skins 
 - You can "download" the skin package. It must be exported in modloader and /skintest done ingame by a skin handler.
 (It will always replace the /skintest skin. They must make sure that the rig of the body is fine.)
 (The head will also replace a test object that will be attached at temp coordinates so they can see if it's gap-free)
 - There will be two buttons "approve" and "deny (with reason)". 
 --- Approve
 ------Approving a skin will use a cron job to send the skin to the skin directory and automatically rename it in a folder of the master account with characterid and date:
 EXAMPLE: "Hades/Addison_Barrington_1234_01-01-1996_12-59-00.dff"
 ------There must be a timer running ingame that sends an announce to admins every 30 min "Adding new skins". It will then loop through the database with skins that are "not-initialised".
 Once they are "initialised" their model will load ingame and the skin will be usable in /playerskin (or w/e cmd we use).
 This way, we have an autonomous skin addition system and players can get their skin added overnight rather than waiting a full week.
 --- Deny 
 ------Denying will require you to enter a reason. The player gets this reason shown ingame but also on the submission website.
 ------They will be able to re-download their files (expires in 72 hours) and they can resubmit the skin lest their correct the mistake.