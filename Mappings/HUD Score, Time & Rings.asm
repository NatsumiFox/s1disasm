; ---------------------------------------------------------------------------
; Sprite mappings - SCORE, TIME, RINGS
; ---------------------------------------------------------------------------
		index *
		ptr @allyellow
		ptr @ringred
		ptr @timered
		ptr @allred
		
@allyellow:	spritemap
		piece	0, -$80, 4x2, 0, hi
		piece	$20, -$80, 4x2, $18, hi
		piece	$40, -$80, 4x2, $20, hi
		piece	0, -$70, 4x2, $10, hi
		piece	$28, -$70, 4x2, $28, hi
		piece	0, -$60, 4x2, 8, hi
		piece	$20, -$60, 1x2, 0, hi
		piece	$30, -$60, 3x2, $30, hi
		piece	0, $40, 2x2, $10A, hi
		piece	$10, $40, 4x2, $10E, hi
		endsprite
		dc.b 0
		
@ringred:	spritemap
		piece	0, -$80, 4x2, 0, hi
		piece	$20, -$80, 4x2, $18, hi
		piece	$40, -$80, 4x2, $20, hi
		piece	0, -$70, 4x2, $10, hi
		piece	$28, -$70, 4x2, $28, hi
		piece	0, -$60, 4x2, 8, hi, pal2
		piece	$20, -$60, 1x2, 0, hi, pal2
		piece	$30, -$60, 3x2, $30, hi
		piece	0, $40, 2x2, $10A, hi
		piece	$10, $40, 4x2, $10E, hi
		endsprite
		dc.b 0
		
@timered:	spritemap
		piece	0, -$80, 4x2, 0, hi
		piece	$20, -$80, 4x2, $18, hi
		piece	$40, -$80, 4x2, $20, hi
		piece	0, -$70, 4x2, $10, hi, pal2
		piece	$28, -$70, 4x2, $28, hi
		piece	0, -$60, 4x2, 8, hi
		piece	$20, -$60, 1x2, 0, hi
		piece	$30, -$60, 3x2, $30, hi
		piece	0, $40, 2x2, $10A, hi
		piece	$10, $40, 4x2, $10E, hi
		endsprite
		dc.b 0
		
@allred:	spritemap
		piece	0, -$80, 4x2, 0, hi
		piece	$20, -$80, 4x2, $18, hi
		piece	$40, -$80, 4x2, $20, hi
		piece	0, -$70, 4x2, $10, hi, pal2
		piece	$28, -$70, 4x2, $28, hi
		piece	0, -$60, 4x2, 8, hi, pal2
		piece	$20, -$60, 1x2, 0, hi, pal2
		piece	$30, -$60, 3x2, $30, hi
		piece	0, $40, 2x2, $10A, hi
		piece	$10, $40, 4x2, $10E, hi
		endsprite
		even
