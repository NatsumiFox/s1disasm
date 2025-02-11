; ---------------------------------------------------------------------------
; Object 7C - flash effect when	you collect the	giant ring
; ---------------------------------------------------------------------------

RingFlash:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Flash_Index(pc,d0.w),d1
		jmp	Flash_Index(pc,d1.w)
; ===========================================================================
Flash_Index:	index *,,2
		ptr Flash_Main
		ptr Flash_ChkDel
		ptr Flash_Delete

ost_flash_parent:	equ $3C	; address of OST of parent object (4 bytes)
; ===========================================================================

Flash_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)
		move.l	#Map_Flash,ost_mappings(a0)
		move.w	#$462+tile_pal2,ost_tile(a0)
		ori.b	#render_rel,ost_render(a0)
		move.b	#0,ost_priority(a0)
		move.b	#$20,ost_actwidth(a0)
		move.b	#-1,ost_frame(a0)

Flash_ChkDel:	; Routine 2
		bsr.s	Flash_Collect
		out_of_range	DeleteObject
		bra.w	DisplaySprite

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Flash_Collect:
		subq.b	#1,ost_anim_time(a0)
		bpl.s	locret_9F76
		move.b	#1,ost_anim_time(a0)
		addq.b	#1,ost_frame(a0)
		cmpi.b	#id_frame_flash_final+1,ost_frame(a0) ; has animation finished?
		bcc.s	Flash_End	; if yes, branch
		cmpi.b	#id_frame_flash_full,ost_frame(a0) ; is 3rd frame displayed?
		bne.s	locret_9F76	; if not, branch
		movea.l	ost_flash_parent(a0),a1	; get parent object address
		move.b	#id_GRing_Delete,ost_routine(a1) ; delete parent object
		move.b	#id_Blank,(v_ost_player+ost_anim).w ; make Sonic invisible
		move.b	#1,(f_giantring_collected).w ; stop	Sonic getting bonuses
		clr.b	(v_invincibility).w	; remove invincibility
		clr.b	(v_shield).w	; remove shield

locret_9F76:
		rts	
; ===========================================================================

Flash_End:
		addq.b	#2,ost_routine(a0)
		move.w	#0,(v_ost_player).w ; remove Sonic object
		addq.l	#4,sp
		rts	
; End of function Flash_Collect

; ===========================================================================

Flash_Delete:	; Routine 4
		bra.w	DeleteObject
