; ---------------------------------------------------------------------------
; Object 47 - pinball bumper (SYZ)
; ---------------------------------------------------------------------------

Bumper:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Bump_Index(pc,d0.w),d1
		jmp	Bump_Index(pc,d1.w)
; ===========================================================================
Bump_Index:	index *,,2
		ptr Bump_Main
		ptr Bump_Hit
; ===========================================================================

Bump_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Bump,ost_mappings(a0)
		move.w	#tile_Nem_Bumper,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#$10,ost_actwidth(a0)
		move.b	#1,ost_priority(a0)
		move.b	#id_col_8x8_2+id_col_custom,ost_col_type(a0)

Bump_Hit:	; Routine 2
		tst.b	ost_col_property(a0) ; has Sonic touched the bumper?
		beq.w	@display	; if not, branch
		clr.b	ost_col_property(a0)
		lea	(v_ost_player).w,a1
		move.w	ost_x_pos(a0),d1
		move.w	ost_y_pos(a0),d2
		sub.w	ost_x_pos(a1),d1
		sub.w	ost_y_pos(a1),d2
		jsr	(CalcAngle).l
		jsr	(CalcSine).l
		muls.w	#-$700,d1
		asr.l	#8,d1
		move.w	d1,ost_x_vel(a1) ; bounce Sonic away
		muls.w	#-$700,d0
		asr.l	#8,d0
		move.w	d0,ost_y_vel(a1) ; bounce Sonic away
		bset	#status_air_bit,ost_status(a1)
		bclr	#status_rolljump_bit,ost_status(a1)
		bclr	#status_pushing_bit,ost_status(a1)
		clr.b	ost_sonic_jump(a1)
		move.b	#id_ani_bump_bumped,ost_anim(a0) ; use "hit" animation
		play.w	1, jsr, sfx_Bumper		; play bumper sound
		lea	(v_respawn_list).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		beq.s	@addscore
		cmpi.b	#$8A,2(a2,d0.w)	; has bumper been hit 10 times?
		bcc.s	@display	; if yes, Sonic	gets no	points
		addq.b	#1,2(a2,d0.w)

	@addscore:
		moveq	#1,d0
		jsr	(AddPoints).l	; add 10 to score
		bsr.w	FindFreeObj
		bne.s	@display
		move.b	#id_Points,0(a1) ; load points object
		move.w	ost_x_pos(a0),ost_x_pos(a1)
		move.w	ost_y_pos(a0),ost_y_pos(a1)
		move.b	#id_frame_points_10,ost_frame(a1)

	@display:
		lea	(Ani_Bump).l,a1
		bsr.w	AnimateSprite
		out_of_range.s	@resetcount
		bra.w	DisplaySprite
; ===========================================================================

@resetcount:
		lea	(v_respawn_list).w,a2
		moveq	#0,d0
		move.b	ost_respawn(a0),d0
		beq.s	@delete
		bclr	#7,2(a2,d0.w)

	@delete:
		bra.w	DeleteObject
