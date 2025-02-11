; ---------------------------------------------------------------------------
; Object 58 - giant spiked balls (SYZ)
; ---------------------------------------------------------------------------

BigSpikeBall:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	BBall_Index(pc,d0.w),d1
		jmp	BBall_Index(pc,d1.w)
; ===========================================================================
BBall_Index:	index *,,2
		ptr BBall_Main
		ptr BBall_Move

ost_bball_y_start:	equ $38	; original y-axis position (2 bytes)
ost_bball_x_start:	equ $3A	; original x-axis position (2 bytes)
ost_bball_radius:	equ $3C	; radius of circle
ost_bball_speed:	equ $3E	; speed (2 bytes)
; ===========================================================================

BBall_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_BBall,ost_mappings(a0)
		move.w	#tile_Nem_BigSpike,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)
		move.b	#$18,ost_actwidth(a0)
		move.w	ost_x_pos(a0),ost_bball_x_start(a0)
		move.w	ost_y_pos(a0),ost_bball_y_start(a0)
		move.b	#id_col_16x16+id_col_hurt,ost_col_type(a0)
		move.b	ost_subtype(a0),d1 ; get object type
		andi.b	#$F0,d1		; read only the	1st digit
		ext.w	d1
		asl.w	#3,d1		; multiply by 8
		move.w	d1,ost_bball_speed(a0) ; set object speed
		move.b	ost_status(a0),d0
		ror.b	#2,d0
		andi.b	#$C0,d0
		move.b	d0,ost_angle(a0)
		move.b	#$50,ost_bball_radius(a0) ; set radius of circle motion

BBall_Move:	; Routine 2
		moveq	#0,d0
		move.b	ost_subtype(a0),d0 ; get object type
		andi.w	#7,d0		; read only the	2nd digit
		add.w	d0,d0
		move.w	BBall_Types(pc,d0.w),d1
		jsr	BBall_Types(pc,d1.w)
		out_of_range	DeleteObject,ost_bball_x_start(a0)
		bra.w	DisplaySprite
; ===========================================================================
BBall_Types:	index *
		ptr BBall_Still
		ptr BBall_Sideways
		ptr BBall_UpDown
		ptr BBall_Circle
; ===========================================================================

; Type 0
BBall_Still:
		rts	
; ===========================================================================

; Type 1
BBall_Sideways:
		move.w	#$60,d1
		moveq	#0,d0
		move.b	(v_oscillating_table+$C).w,d0
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	@noflip1
		neg.w	d0
		add.w	d1,d0

	@noflip1:
		move.w	ost_bball_x_start(a0),d1
		sub.w	d0,d1
		move.w	d1,ost_x_pos(a0) ; move object horizontally
		rts	
; ===========================================================================

; Type 2
BBall_UpDown:
		move.w	#$60,d1
		moveq	#0,d0
		move.b	(v_oscillating_table+$C).w,d0
		btst	#status_xflip_bit,ost_status(a0)
		beq.s	@noflip2
		neg.w	d0
		addi.w	#$80,d0

	@noflip2:
		move.w	ost_bball_y_start(a0),d1
		sub.w	d0,d1
		move.w	d1,ost_y_pos(a0) ; move object vertically
		rts	
; ===========================================================================

; Type 3
BBall_Circle:
		move.w	ost_bball_speed(a0),d0
		add.w	d0,ost_angle(a0)
		move.b	ost_angle(a0),d0
		jsr	(CalcSine).l
		move.w	ost_bball_y_start(a0),d2
		move.w	ost_bball_x_start(a0),d3
		moveq	#0,d4
		move.b	ost_bball_radius(a0),d4
		move.l	d4,d5
		muls.w	d0,d4
		asr.l	#8,d4
		muls.w	d1,d5
		asr.l	#8,d5
		add.w	d2,d4
		add.w	d3,d5
		move.w	d4,ost_y_pos(a0) ; move object circularly
		move.w	d5,ost_x_pos(a0)
		rts	
