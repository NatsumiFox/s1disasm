; ---------------------------------------------------------------------------
; Object 48 - ball on a	chain that Eggman swings (GHZ)
; ---------------------------------------------------------------------------

		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	GBall_Index(pc,d0.w),d1
		jmp	GBall_Index(pc,d1.w)
; ===========================================================================
GBall_Index:	index *,,2
		ptr GBall_Main
		ptr GBall_Base
		ptr GBall_Display2
		ptr loc_17C68
		ptr GBall_ChkVanish
; ===========================================================================

GBall_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.w	#$4080,ost_angle(a0)
		move.w	#-$200,$3E(a0)
		move.l	#Map_BossItems,ost_mappings(a0)
		move.w	#$46C,ost_tile(a0)
		lea	ost_subtype(a0),a2
		move.b	#0,(a2)+
		moveq	#5,d1
		movea.l	a0,a1
		bra.s	loc_17B60
; ===========================================================================

GBall_MakeLinks:
		jsr	(FindNextFreeObj).l
		bne.s	GBall_MakeBall
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.b	#id_BossBall,0(a1) ; load chain link object
		move.b	#6,ost_routine(a1)
		move.l	#Map_Swing_GHZ,ost_mappings(a1)
		move.w	#$380,ost_tile(a1)
		move.b	#1,ost_frame(a1)
		addq.b	#1,ost_subtype(a0)

loc_17B60:
		move.w	a1,d5
		subi.w	#$D000,d5
		lsr.w	#6,d5
		andi.w	#$7F,d5
		move.b	d5,(a2)+
		move.b	#render_rel,ost_render(a1)
		move.b	#8,ost_actwidth(a1)
		move.b	#6,ost_priority(a1)
		move.l	$34(a0),$34(a1)
		dbf	d1,GBall_MakeLinks ; repeat sequence 5 more times

GBall_MakeBall:
		move.b	#id_GBall_ChkVanish,ost_routine(a1)
		move.l	#Map_GBall,ost_mappings(a1) ; load different mappings for final link
		move.w	#$3AA+tile_pal3,ost_tile(a1) ; use different graphics
		move.b	#1,ost_frame(a1)
		move.b	#5,ost_priority(a1)
		move.b	#$81,ost_col_type(a1) ; make object hurt Sonic
		rts	
; ===========================================================================

GBall_PosData:	dc.b 0,	$10, $20, $30, $40, $60	; y-position data for links and	giant ball

; ===========================================================================

GBall_Base:	; Routine 2
		lea	(GBall_PosData).l,a3
		lea	ost_subtype(a0),a2
		moveq	#0,d6
		move.b	(a2)+,d6

loc_17BC6:
		moveq	#0,d4
		move.b	(a2)+,d4
		lsl.w	#6,d4
		addi.l	#v_objspace&$FFFFFF,d4
		movea.l	d4,a1
		move.b	(a3)+,d0
		cmp.b	$3C(a1),d0
		beq.s	loc_17BE0
		addq.b	#1,$3C(a1)

loc_17BE0:
		dbf	d6,loc_17BC6

		cmp.b	$3C(a1),d0
		bne.s	loc_17BFA
		movea.l	$34(a0),a1
		cmpi.b	#6,ost_routine2(a1)
		bne.s	loc_17BFA
		addq.b	#2,ost_routine(a0)

loc_17BFA:
		cmpi.w	#$20,$32(a0)
		beq.s	GBall_Display
		addq.w	#1,$32(a0)

GBall_Display:
		bsr.w	sub_17C2A
		move.b	ost_angle(a0),d0
		jsr	(Swing_Move2).l
		jmp	(DisplaySprite).l
; ===========================================================================

GBall_Display2:	; Routine 4
		bsr.w	sub_17C2A
		jsr	(Obj48_Move).l
		jmp	(DisplaySprite).l

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


sub_17C2A:
		movea.l	$34(a0),a1
		addi.b	#$20,ost_anim_frame(a0)
		bcc.s	loc_17C3C
		bchg	#0,ost_frame(a0)

loc_17C3C:
		move.w	ost_x_pos(a1),$3A(a0)
		move.w	ost_y_pos(a1),d0
		add.w	$32(a0),d0
		move.w	d0,$38(a0)
		move.b	ost_status(a1),ost_status(a0)
		tst.b	ost_status(a1)
		bpl.s	locret_17C66
		move.b	#id_ExplosionBomb,0(a0)
		move.b	#0,ost_routine(a0)

locret_17C66:
		rts	
; End of function sub_17C2A

; ===========================================================================

loc_17C68:	; Routine 6
		movea.l	$34(a0),a1
		tst.b	ost_status(a1)
		bpl.s	GBall_Display3
		move.b	#id_ExplosionBomb,0(a0)
		move.b	#0,ost_routine(a0)

GBall_Display3:
		jmp	(DisplaySprite).l
; ===========================================================================

GBall_ChkVanish:; Routine 8
		moveq	#0,d0
		tst.b	ost_frame(a0)
		bne.s	GBall_Vanish
		addq.b	#1,d0

GBall_Vanish:
		move.b	d0,ost_frame(a0)
		movea.l	$34(a0),a1
		tst.b	ost_status(a1)
		bpl.s	GBall_Display4
		move.b	#0,ost_col_type(a0)
		bsr.w	BossDefeated
		subq.b	#1,$3C(a0)
		bpl.s	GBall_Display4
		move.b	#id_ExplosionBomb,(a0)
		move.b	#0,ost_routine(a0)

GBall_Display4:
		jmp	(DisplaySprite).l
