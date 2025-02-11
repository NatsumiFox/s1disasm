; ---------------------------------------------------------------------------
; Object 6F - spinning platforms that move around a conveyor belt (SBZ)
; ---------------------------------------------------------------------------

SpinConvey:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	SpinC_Index(pc,d0.w),d1
		jsr	SpinC_Index(pc,d1.w)
		out_of_range.s	loc_1629A,$30(a0)

SpinC_Display:
		jmp	(DisplaySprite).l
; ===========================================================================

loc_1629A:
		cmpi.b	#2,(v_act).w	; check if act is 3
		bne.s	SpinC_Act1or2	; if not, branch
		cmpi.w	#-$80,d0
		bcc.s	SpinC_Display

SpinC_Act1or2:
		move.b	ost_spinc_subtype_copy(a0),d0
		bpl.s	SpinC_Delete
		andi.w	#$7F,d0
		lea	(v_convey_init_list).w,a2
		bclr	#0,(a2,d0.w)

SpinC_Delete:
		jmp	(DeleteObject).l
; ===========================================================================
SpinC_Index:	index *,,2
		ptr SpinC_Main
		ptr loc_163D8

ost_spinc_subtype_copy:	equ $2F	; copy of the initial subtype ($80/$81/etc.)

ost_spinc_reverse:	equ $3B	; 1 = conveyors run backwards
ost_spinc_corner_ptr:	equ $3C	; address of corner position data (4 bytes)
; ===========================================================================

SpinC_Main:	; Routine 0
		move.b	ost_subtype(a0),d0
		bmi.w	loc_16380
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Spin,ost_mappings(a0)
		move.w	#tile_Nem_SpinPform,ost_tile(a0)
		move.b	#$10,ost_actwidth(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	#4,ost_priority(a0)
		moveq	#0,d0
		move.b	ost_subtype(a0),d0
		move.w	d0,d1
		lsr.w	#3,d0
		andi.w	#$1E,d0
		lea	SpinC_Data(pc),a2
		adda.w	(a2,d0.w),a2	; get address of corner data
		move.w	(a2)+,$39-1(a0)
		move.w	(a2)+,$30(a0)
		move.l	a2,ost_spinc_corner_ptr(a0)
		andi.w	#$F,d1
		lsl.w	#2,d1
		move.b	d1,$38(a0)
		move.b	#4,$3A(a0)
		tst.b	(f_convey_reverse).w
		beq.s	loc_16356
		move.b	#1,ost_spinc_reverse(a0)
		neg.b	$3A(a0)
		moveq	#0,d1
		move.b	$38(a0),d1
		add.b	$3A(a0),d1
		cmp.b	$39(a0),d1
		bcs.s	loc_16352
		move.b	d1,d0
		moveq	#0,d1
		tst.b	d0
		bpl.s	loc_16352
		move.b	$39(a0),d1
		subq.b	#4,d1

loc_16352:
		move.b	d1,$38(a0)

loc_16356:
		move.w	(a2,d1.w),$34(a0)
		move.w	2(a2,d1.w),$36(a0)
		tst.w	d1
		bne.s	loc_1636C
		move.b	#1,ost_anim(a0)

loc_1636C:
		cmpi.w	#8,d1
		bne.s	loc_16378
		move.b	#0,ost_anim(a0)

loc_16378:
		bsr.w	LCon_Platform_Move
		bra.w	loc_163D8
; ===========================================================================

loc_16380:
		move.b	d0,ost_spinc_subtype_copy(a0)
		andi.w	#$7F,d0
		lea	(v_convey_init_list).w,a2
		bset	#0,(a2,d0.w)
		beq.s	loc_1639A
		jmp	(DeleteObject).l
; ===========================================================================

loc_1639A:
		add.w	d0,d0
		andi.w	#$1E,d0
		addi.w	#ObjPosSBZPlatform_Index-ObjPos_Index,d0
		lea	(ObjPos_Index).l,a2
		adda.w	(a2,d0.w),a2
		move.w	(a2)+,d1
		movea.l	a0,a1
		bra.s	SpinC_LoadPform
; ===========================================================================

SpinC_Loop:
		jsr	(FindFreeObj).l
		bne.s	loc_163D0

SpinC_LoadPform:
		move.b	#id_SpinConvey,0(a1)
		move.w	(a2)+,ost_x_pos(a1)
		move.w	(a2)+,ost_y_pos(a1)
		move.w	(a2)+,d0
		move.b	d0,ost_subtype(a1)

loc_163D0:
		dbf	d1,SpinC_Loop

		addq.l	#4,sp
		rts	
; ===========================================================================

loc_163D8:	; Routine 2
		lea	(Ani_SpinConvey).l,a1
		jsr	(AnimateSprite).l
		tst.b	ost_frame(a0)
		bne.s	loc_16404
		move.w	ost_x_pos(a0),-(sp)
		bsr.w	loc_16424
		move.w	#$1B,d1
		move.w	#7,d2
		move.w	d2,d3
		addq.w	#1,d3
		move.w	(sp)+,d4
		bra.w	SolidObject
; ===========================================================================

loc_16404:
		btst	#status_platform_bit,ost_status(a0)
		beq.s	loc_16420
		lea	(v_ost_all).w,a1
		bclr	#status_platform_bit,ost_status(a1)
		bclr	#status_platform_bit,ost_status(a0)
		clr.b	ost_solid(a0)

loc_16420:
		bra.w	loc_16424

loc_16424:
		move.w	ost_x_pos(a0),d0
		cmp.w	$34(a0),d0
		bne.s	loc_16484
		move.w	ost_y_pos(a0),d0
		cmp.w	$36(a0),d0
		bne.s	loc_16484
		moveq	#0,d1
		move.b	$38(a0),d1
		add.b	$3A(a0),d1
		cmp.b	$39(a0),d1
		bcs.s	loc_16456
		move.b	d1,d0
		moveq	#0,d1
		tst.b	d0
		bpl.s	loc_16456
		move.b	$39(a0),d1
		subq.b	#4,d1

loc_16456:
		move.b	d1,$38(a0)
		movea.l	ost_spinc_corner_ptr(a0),a1
		move.w	(a1,d1.w),$34(a0)
		move.w	2(a1,d1.w),$36(a0)
		tst.w	d1
		bne.s	loc_16474
		move.b	#1,ost_anim(a0)

loc_16474:
		cmpi.w	#8,d1
		bne.s	loc_16480
		move.b	#0,ost_anim(a0)

loc_16480:
		bsr.w	LCon_Platform_Move

loc_16484:
		jmp	(SpeedToPos).l
