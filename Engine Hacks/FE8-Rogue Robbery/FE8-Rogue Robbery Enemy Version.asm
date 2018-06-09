@Allows enemy rogues to steal anything, provided the weapon isn't equipped and the rogue's con is greater than the item's weight.

.thumb


.org 0x0
@r0 has item id/uses halfword, r1 has slot*2, r2 and r3 are free, r7 has char data of person being robbed
push	{r4-r6,r14}
mov		r4,r1
lsl		r5,r0,#0x3
add		r5,r5,r0
lsl		r5,r5,#0x2
ldr		r0,ItemTable
add		r5,r5,r0		@beginning of item data
ldr		r2,CurrentCharPointer
ldr		r6,[r2]
ldr		r2,[r6,#0x4]
ldrb	r2,[r2,#0x4]	@class byte
mov		r3,#0x33		@Rogue class id
cmp		r3,r2
bne		NotARogue
mov		r0,r7
bl		ItemTable+4		@given char struct, puts equipped item halfword into r0 and item slot*2 in r2
cmp		r2,r4
beq		NoSteal			@can't steal equipped items
ldr 	r3,[r6]
mov		r1,#0x13
ldsb	r3,[r3,r1]		@character con
ldr 	r2,[r6,#0x4]
mov		r1,#0x11
ldsb	r2,[r2,r1]		@class con
add		r3,r3,r2
mov		r1,#0x1A
ldsb	r2,[r6,r1]		@character con bonus
add		r3,r3,r2		@total con
ldrb	r2,[r5,#0x17]	@item weight
cmp 	r3,r2
ble		NoSteal			@con must be greater than weight
CheckWorth:
ldrh	r2,[r5,#0x1A]	@cost per use
cmp		r2,#0x0
beq		NoSteal			@can still have unsellable items without setting this to 0. If you want unstealable sellable items, do something else
ldr		r3,[r5,#0x8]	@load weapon abilities
mov		r1,#0x08
and		r3,r1
cmp		r3,#0x1			@check if item is unbreakable
beq		WriteOne
add		r0,r4,r7
add		r0,#0x1E
ldrb	r0,[r0,#0x1]	@get item uses
b		CalculateWorth
WriteOne:
mov		r0,#0x1
CalculateWorth:
mul		r0,r2			@worth now in r0
b		GoBack
NoSteal:
mov		r0,#0x1
neg		r0,r0
GoBack:
pop		{r4-r6}
pop		{r1}
bx		r1

NotARogue:
ldrb	r3,[r5,#0x7]
cmp		r3,#0x09		@is it an item?
bne		NoSteal
b		CheckWorth

.align
CurrentCharPointer:
.long 0x03004E50
ItemTable:
@.long 0x08809B10
@GetEquippedItem: (actually ItemTable+4)

@At 3B7E2, change 01 40 08 1C to 08 40 C0 46. This leaves r1 with the item id/uses halfword
@nop out 3b7ea and ec, change bcc to bge, 3b7fe change to mov r0,r5 and mov r2,r6, 3dc22 to mov r0,r2 and nop, nop, nop, 3dc2e change bcc to bge
