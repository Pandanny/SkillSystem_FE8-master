FE8 Rogue Robbery
By Tequila

This hack consists of 2 parts: 1 for the player units and 1 for NPC/enemy units. 
The player version allows rogues to steal anything from an enemy's inventory provided that a) the item isn't equipped, and b) the rogue's con is greater than the item's weight.
The NPC/enemy version is the same, except it calculates priority based on (cost per use)*(uses). Items with a cost per use of 0 cannot be stolen. If you want an unsellable item to be stealable, simply set the 5th bit (0x10) of weapon ability 1 and set the cost to whatever you'd like.

Use EA v9.12 or higher the assemble these. They're currently written to free space found at 0x1C1EC0, which you can change, but make sure your offset is in BL range (+/- 0x400,000 bytes) of the functions necessary. Also, if you've repointed your item table, make sure to update that. The rest should be fine if left alone.

For information on how the vanilla AI determines what to steal, look at this post: http://feuniverse.us/t/fe8-the-official-ai-documentation-thread/483/22