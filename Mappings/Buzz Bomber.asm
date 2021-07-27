; ---------------------------------------------------------------------------
; Sprite mappings - Buzz Bomber	enemy
; ---------------------------------------------------------------------------
		index *
		ptr @Fly1
		ptr @Fly2
		ptr @Fly3
		ptr @Fly4
		ptr @Fire1
		ptr @Fire2
		
@Fly1:		spritemap		; flying
		piece	-$18, -$C, 3x2, 0
		piece	0, -$C, 3x2, $F
		piece	-$18, 4, 3x1, $15
		piece	0, 4, 2x1, $18
		piece	-$14, -$F, 3x1, $1A
		piece	4, -$F, 2x1, $1D
		endsprite
		
@Fly2:		spritemap
		piece	-$18, -$C, 3x2, 0
		piece	0, -$C, 3x2, $F
		piece	-$18, 4, 3x1, $15
		piece	0, 4, 2x1, $18
		piece	-$14, -$C, 3x1, $1F
		piece	4, -$C, 2x1, $22
		endsprite
		
@Fly3:		spritemap
		piece	$C, 4, 1x1, $30
		piece	-$18, -$C, 3x2, 0
		piece	0, -$C, 3x2, $F
		piece	-$18, 4, 3x1, $15
		piece	0, 4, 2x1, $18
		piece	-$14, -$F, 3x1, $1A
		piece	4, -$F, 2x1, $1D
		endsprite
		
@Fly4:		spritemap
		piece	$C, 4, 2x1, $31
		piece	-$18, -$C, 3x2, 0
		piece	0, -$C, 3x2, $F
		piece	-$18, 4, 3x1, $15
		piece	0, 4, 2x1, $18
		piece	-$14, -$C, 3x1, $1F
		piece	4, -$C, 2x1, $22
		endsprite
		
@Fire1:		spritemap		; stopping and firing
		piece	-$14, -$C, 4x2, 0
		piece	-$14, 4, 4x1, 8
		piece	$C, 4, 1x1, $C
		piece	-$C, $C, 2x1, $D
		piece	-$14, -$F, 3x1, $1A
		piece	4, -$F, 2x1, $1D
		endsprite
		
@Fire2:		spritemap
		piece	-$14, -$C, 4x2, 0
		piece	-$14, 4, 4x1, 8
		piece	$C, 4, 1x1, $C
		piece	-$C, $C, 2x1, $D
		endsprite
		piece	-$14, -$C, 3x1, $1F
		piece	4, -$C, 2x1, $22
		even
