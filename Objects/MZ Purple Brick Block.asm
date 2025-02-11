; ---------------------------------------------------------------------------
; Object 46 - solid blocks and blocks that fall	from the ceiling (MZ)
; ---------------------------------------------------------------------------

MarbleBrick:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Brick_Index(pc,d0.w),d1
		jmp	Brick_Index(pc,d1.w)
; ===========================================================================
Brick_Index:	index *,,2
		ptr Brick_Main
		ptr Brick_Action

ost_brick_y_start:	equ $30	; original y position (2 bytes)
; ===========================================================================

Brick_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.b	#$F,ost_height(a0)
		move.b	#$F,ost_width(a0)
		move.l	#Map_Brick,ost_mappings(a0)
		move.w	#0+tile_pal3,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#3,ost_priority(a0)
		move.b	#$10,ost_actwidth(a0)
		move.w	ost_y_pos(a0),ost_brick_y_start(a0)
		move.w	#$5C0,$32(a0)

Brick_Action:	; Routine 2
		tst.b	ost_render(a0)
		bpl.s	@chkdel
		moveq	#0,d0
		move.b	ost_subtype(a0),d0 ; get object type
		andi.w	#7,d0		; read only bits 0-2
		add.w	d0,d0
		move.w	Brick_TypeIndex(pc,d0.w),d1
		jsr	Brick_TypeIndex(pc,d1.w)
		move.w	#$1B,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	ost_x_pos(a0),d4
		bsr.w	SolidObject

	@chkdel:
		if Revision=0
			bsr.w	DisplaySprite
			out_of_range	DeleteObject
			rts	
		else
			out_of_range	DeleteObject
			bra.w	DisplaySprite
		endc
; ===========================================================================
Brick_TypeIndex:index *
		ptr Brick_Still		; doesn't move
		ptr Brick_Wobbles	; wobbles
		ptr Brick_Falls		; wobbles and falls
		ptr Brick_FallNow	; falls immediately
		ptr Brick_FallLava	; wobbles slowly (it's on the lava now)
; ===========================================================================

; Type 0
Brick_Still:
		rts	
; ===========================================================================

; Type 2
Brick_Falls:
		move.w	(v_ost_player+ost_x_pos).w,d0
		sub.w	ost_x_pos(a0),d0
		bcc.s	loc_E888
		neg.w	d0

	loc_E888:
		cmpi.w	#$90,d0		; is Sonic within $90 pixels of	the block?
		bcc.s	Brick_Wobbles	; if not, resume wobbling
		move.b	#id_Brick_FallNow,ost_subtype(a0) ; if yes, make the block fall

; Type 1
Brick_Wobbles:
		moveq	#0,d0
		move.b	(v_oscillating_table+$14).w,d0
		btst	#3,ost_subtype(a0) ; is subtype 8 or above?
		beq.s	@no_rev		; if not, branch
		neg.w	d0		; wobble the opposite way
		addi.w	#$10,d0

	@no_rev:
		move.w	ost_brick_y_start(a0),d1
		sub.w	d0,d1
		move.w	d1,ost_y_pos(a0) ; update the block's position to make it wobble
		rts	
; ===========================================================================

; Type 3
Brick_FallNow:
		bsr.w	SpeedToPos
		addi.w	#$18,ost_y_vel(a0) ; increase falling speed
		bsr.w	FindFloorObj
		tst.w	d1		; has the block	hit the	floor?
		bpl.w	locret_E8EE	; if not, branch
		add.w	d1,ost_y_pos(a0)
		clr.w	ost_y_vel(a0)	; stop the block falling
		move.w	ost_y_pos(a0),ost_brick_y_start(a0)
		move.b	#id_Brick_FallLava,ost_subtype(a0) ; final subtype - slow wobble
		move.w	(a1),d0
		andi.w	#$3FF,d0
		if Revision=0
			cmpi.w	#$2E8,d0 ; wrong 16x16 tile check in rev. 0
		else
			cmpi.w	#$16A,d0 ; is the 16x16 tile it's landed on lava?
		endc
		bcc.s	locret_E8EE	; if yes, branch
		move.b	#0,ost_subtype(a0) ; don't wobble

	locret_E8EE:
		rts	
; ===========================================================================

; Type 4
Brick_FallLava:
		moveq	#0,d0
		move.b	(v_oscillating_table+$10).w,d0
		lsr.w	#3,d0
		move.w	ost_brick_y_start(a0),d1
		sub.w	d0,d1
		move.w	d1,ost_y_pos(a0) ; make the block wobble
		rts	
