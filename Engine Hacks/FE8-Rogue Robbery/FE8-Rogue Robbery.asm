@Allows rogues to steal anything, provided the weapon isn't equipped and the rogue's con is greater than the item's weight. Returns 0 if can't be stolen and 1 if it can.

.thumb

.org 0x0
@r0 = item location, r1 = slot number*2
push	{r4-r7,r14}
sub		r7,r0,r1
sub		r7,#0x1E		@get beginning of char data
mov		r6,r1
ldrh	r4,[r0]
ldrb	r2,[r0]
lsl		r1,r2,#0x3
add		r1,r1,r2
lsl		r1,r1,#0x2
ldr		r3,ItemTable
add		r5,r3,r1		@beginning of item data
ldr		r2,CurrentCharPointer
ldr		r2,[r2]
ldr		r2,[r2,#0x4]
ldrb	r2,[r2,#0x4]	@class byte
cmp		r2,#0x33		@rogue class byte, can change/extend this if you want other classes to have this stealing ability
bne		NotARogue
mov		r0,r7
bl		GetEquippedItem	@given char struct, puts equipped item halfword into r0 and the slot*2 in r2
cmp		r0,#0x0
beq		GoWild			@no equipped item, so go wild
cmp		r0,r4
bne		GoWild
cmp		r2,r6			
beq		NoSteal			@equipped items and slots are same, so don't steal
GoWild:
ldr		r4,CurrentCharPointer
ldr		r4,[r4]
ldr 	r0,[r4]
ldrb	r2,[r0,#0x13]	@character con
ldr 	r0,[r4,#0x4]
ldrb	r1,[r0,#0x11]	@class con
add		r2,r2,r1
ldrb	r1,[r4,#0x1A]	@character con bonus
add		r2,r2,r1		@total con
ldrb	r5,[r5,#0x17]	@item weight
cmp		r2,r5
ble		NoSteal
CanSteal:
mov		r0,#0x1
b		GoBack
NoSteal:
mov		r0,#0x0
GoBack:
pop		{r4-r7}
pop		{r1}
bx		r1

NotARogue:
ldrb	r2,[r5,#0x7]
cmp		r2,#0x9
bne		NoSteal
b		CanSteal	

GetEquippedItem:
ldr		r1,EquippedItem
bx		r1

.align
ItemTable:
.long 0x08809B10
CurrentCharPointer:
.long 0x03004E50
EquippedItem:
.long 0x08016B29
