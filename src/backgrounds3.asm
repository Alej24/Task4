.include "constants.inc"

.segment "ZEROPAGE"
map_pos2: .res 1
nam_pos2: .res 1
current_tile2: .res 1

.segment "CODE"

.import palettes

.export draw_obstacles3, draw_stage2
.proc draw_stage2
    LDA PPUSTATUS
	LDA #$28
	STA PPUADDR
	LDA #$20
	STA PPUADDR	
	LDX #$16		; stage 2
	STX PPUDATA
	LDX #$17
	STX PPUDATA
	LDX #$04
	STX PPUDATA
	LDX #$0a
	STX PPUDATA
    LDX #$08
	STX PPUDATA
    LDX #$00
	STX PPUDATA
    LDX #$20
	STX PPUDATA
.endproc

.proc draw_obstacles3
    ; Draw obstacles and update attribute tables

    LDA #$28
    STA nam_pos2
    LDA #$40   ; Starting map position
    STA map_pos2

    LDY #$00   ; Initialize Y register to 0 for loop counter

draw_loop:
    LDA tilemap3, Y   ; Load value from tilemap at index Y
    STA current_tile2
    JSR draw_tiles

    INY             ; Increment Y to move to the next index
    CPY #$10        ; Compare Y to end
    BNE draw_loop   ; Branch back to draw_loop if Y is not equal to end
    LDA #$80   ; Starting map position
    STA map_pos2
    LDY #$10

draw_loop2:
    LDA tilemap3, Y 
    STA current_tile2
    JSR draw_tiles

    INY             
    CPY #$20 
    BNE draw_loop2  
    LDA #$c0   ; Starting map position
    STA map_pos2
    LDY #$20

draw_loop3:
    LDA tilemap3, Y 
    STA current_tile2
    JSR draw_tiles

    INY             
    CPY #$30 
    BNE draw_loop3  
    LDA #$29
    STA nam_pos2
    LDA #$00   ; Starting map position
    STA map_pos2
    LDY #$30
draw_loop4:
    LDA tilemap3, Y 
    STA current_tile2
    JSR draw_tiles

    INY             
    CPY #$40 
    BNE draw_loop4  
    LDA #$40   ; Starting map position
    STA map_pos2
    LDY #$40
draw_loop5:
    LDA tilemap3, Y 
    STA current_tile2
    JSR draw_tiles

    INY             
    CPY #$50 
    BNE draw_loop5  
    LDA #$80   ; Starting map position
    STA map_pos2
    LDY #$50
draw_loop6:
    LDA tilemap3, Y 
    STA current_tile2
    JSR draw_tiles

    INY             
    CPY #$60 
    BNE draw_loop6  
    LDA #$c0   ; Starting map position
    STA map_pos2
    LDY #$60
draw_loop7:
    LDA tilemap3, Y 
    STA current_tile2
    JSR draw_tiles

    INY             
    CPY #$70 
    BNE draw_loop7  
    LDA #$2a
    STA nam_pos2
    LDA #$00   ; Starting map position
    STA map_pos2
    LDY #$70
draw_loop8:
    LDA tilemap3, Y 
    STA current_tile2
    JSR draw_tiles

    INY             
    CPY #$80 
    BNE draw_loop8  
    LDA #$40   ; Starting map position
    STA map_pos2
    LDY #$80
draw_loop9:
    LDA tilemap3, Y 
    STA current_tile2
    JSR draw_tiles

    INY             
    CPY #$90 
    BNE draw_loop9  
    LDA #$80   ; Starting map position
    STA map_pos2
    LDY #$90
draw_loop10:
    LDA tilemap3, Y 
    STA current_tile2
    JSR draw_tiles

    INY             
    CPY #$a0 
    BNE draw_loop10  
    LDA #$c0   ; Starting map position
    STA map_pos2
    LDY #$a0
draw_loop11:
    LDA tilemap3, Y 
    STA current_tile2
    JSR draw_tiles

    INY             
    CPY #$b0 
    BNE draw_loop11  
    LDA #$2b
    STA nam_pos2
    LDA #$00   ; Starting map position
    STA map_pos2
    LDY #$b0
draw_loop12:
    LDA tilemap3, Y 
    STA current_tile2
    JSR draw_tiles

    INY             
    CPY #$c0 
    BNE draw_loop12  
    LDA #$40   ; Starting map position
    STA map_pos2
    LDY #$c0
draw_loop13:
    LDA tilemap3, Y 
    STA current_tile2
    JSR draw_tiles

    INY             
    CPY #$d0 
    BNE draw_loop13  
    LDA #$80   ; Starting map position
    STA map_pos2
    LDY #$d0

    RTS
.endproc

.proc draw_tiles
    LDA PPUSTATUS
    LDA nam_pos2      ; Set PPU address to the beginning of the name table
    STA PPUADDR
    LDA map_pos2
    STA PPUADDR

    ; Calculate the starting position to draw the tiles
    LDX #0

    ; Draw all four tiles
draw_tile_loop:
    ; Determine whether to draw on the top row or bottom row
    CPX #2           ; Check if two tiles have been drawn
    BNE draw_top_row   ; If not, draw on the top row
    LDA PPUSTATUS
    LDA nam_pos2        ; Set PPU address to the beginning of the name table for the next row
    STA PPUADDR
    LDA map_pos2
    CLC
    ADC #$20           ; Move to the next row
    STA PPUADDR

draw_top_row:
    LDA current_tile2   ; Load current tile type
    CMP #WATER_TYPE     ; Compare with SAND_TYPE
    BEQ water_tile      ; If it's sand, go to sand_tile
    CMP #BUOY_TYPE     ; Compare with SAND_TYPE
    BEQ buoy_tile      ; If it's sand, go to sand_tile
	CMP #BUOYWALL_TYPE     ; Compare with SAND_TYPE
    BEQ buoyWall_tile      ; If it's sand, go to sand_tile
    CMP #JELLYFISH_TYPE    ; Compare with CRATE_TYPE
    BEQ jellyfish_tile     ; If it's crate, go to crate_tile
    CMP #TENTACLE_TYPE  ; Compare with TENTACLE_TYPE
    BEQ tentacle_tile   ; If it's tentacle, go to tentacle_tile
    CMP #LEFTTOP_TYPE
    BEQ leftTop_tile
    CMP #RIGHTTOP_TYPE
    BEQ rightTop_tile
    CMP #LEFTBOTTOMBUOY_TYPE
    BEQ leftBottomBuoy_tile
    CMP #RIGHTBOTTOMBUOY_TYPE
    BEQ rightBottomBuoy_tile

    ; Handle unknown tile types here or skip them
    JMP next_tile      ; Jump to next_tile

water_tile:
    LDA water, X    
    JMP draw_tile_data ; Jump to draw_tile_data

buoy_tile:
    LDA buoy, X    
    JMP draw_tile_data ; Jump to draw_tile_data

buoyWall_tile:
	LDA buoyWall, X    
	JMP draw_tile_data ; Jump to draw_tile_data

jellyfish_tile:
    LDA jellyfish, X    
    JMP draw_tile_data ; Jump to draw_tile_data

tentacle_tile:
    LDA tentacle, X     
    JMP draw_tile_data ; Jump to draw_tile_data

leftTop_tile:
    LDA leftTop, X     
    JMP draw_tile_data ; Jump to draw_tile_data

rightTop_tile:
    LDA rightTop, X     
    JMP draw_tile_data ; Jump to draw_tile_data

leftBottomBuoy_tile:
    LDA leftBottomBuoy, X     
    JMP draw_tile_data ; Jump to draw_tile_data

rightBottomBuoy_tile:
    LDA rightBottomBuoy, X     
    JMP draw_tile_data ; Jump to draw_tile_data

draw_tile_data:
    STA PPUDATA        ; Write tile data to PPU
    INX                ; Increment X to read next tile data
    CPX #4           ; Check if two tiles have been drawn on the top row
    BNE draw_tile_loop ; If not, continue drawing
    ; If two tiles have been drawn on the top row, move to the next row

next_tile:
    LDA map_pos2
    CLC
    ADC #$02
    STA map_pos2
    RTS
.endproc

.export draw_obstacles4
.proc draw_obstacles4
    ; Draw obstacles and update attribute tables

    LDA #$2c
    STA nam_pos2
    LDA #$40   ; Starting map position
    STA map_pos2

    LDY #$00   ; Initialize Y register to 0 for loop counter

draw_loop:
    LDA tilemap4, Y   ; Load value from tilemap at index Y
    STA current_tile2
    JSR draw_tiles

    INY             ; Increment Y to move to the next index
    CPY #$08        ; Compare Y to end
    BNE draw_loop   ; Branch back to draw_loop if Y is not equal to end
    LDA #$80   ; Starting map position
    STA map_pos2
    LDY #$08

draw_loop2:
    LDA tilemap4, Y 
    STA current_tile2
    JSR draw_tiles

    INY             
    CPY #$10 
    BNE draw_loop2 
    LDA #$c0   ; Starting map position
    STA map_pos2
    LDY #$10

draw_loop3:
    LDA tilemap4, Y 
    STA current_tile2
    JSR draw_tiles

    INY             
    CPY #$18 
    BNE draw_loop3 
    LDA #$2d
    STA nam_pos2
    LDA #$00   ; Starting map position
    STA map_pos2
    LDY #$18
draw_loop4:
    LDA tilemap4, Y 
    STA current_tile2
    JSR draw_tiles

    INY             
    CPY #$20 
    BNE draw_loop4 
    LDA #$40   ; Starting map position
    STA map_pos2
    LDY #$20
draw_loop5:
    LDA tilemap4, Y 
    STA current_tile2
    JSR draw_tiles

    INY             
    CPY #$28 
    BNE draw_loop5 
    LDA #$80   ; Starting map position
    STA map_pos2
    LDY #$28
draw_loop6:
    LDA tilemap4, Y 
    STA current_tile2
    JSR draw_tiles

    INY             
    CPY #$30 
    BNE draw_loop6 
    LDA #$c0   ; Starting map position
    STA map_pos2
    LDY #$30
draw_loop7:
    LDA tilemap4, Y 
    STA current_tile2
    JSR draw_tiles

    INY             
    CPY #$38 
    BNE draw_loop7 
    LDA #$2e
    STA nam_pos2
    LDA #$00   ; Starting map position
    STA map_pos2
    LDY #$38
draw_loop8:
    LDA tilemap4, Y 
    STA current_tile2
    JSR draw_tiles

    INY             
    CPY #$40 
    BNE draw_loop8 
    LDA #$40   ; Starting map position
    STA map_pos2
    LDY #$40
draw_loop9:
    LDA tilemap4, Y 
    STA current_tile2
    JSR draw_tiles

    INY             
    CPY #$48 
    BNE draw_loop9 
    LDA #$80   ; Starting map position
    STA map_pos2
    LDY #$48
draw_loop10:
    LDA tilemap4, Y 
    STA current_tile2
    JSR draw_tiles

    INY             
    CPY #$50 
    BNE draw_loop10 
    LDA #$c0   ; Starting map position
    STA map_pos2
    LDY #$50
draw_loop11:
    LDA tilemap4, Y 
    STA current_tile2
    JSR draw_tiles

    INY             
    CPY #$58 
    BNE draw_loop11 
    LDA #$2f
    STA nam_pos2
    LDA #$00   ; Starting map position
    STA map_pos2
    LDY #$58
draw_loop12:
    LDA tilemap4, Y 
    STA current_tile2
    JSR draw_tiles

    INY             
    CPY #$60 
    BNE draw_loop12 
    LDA #$40   ; Starting map position
    STA map_pos2
    LDY #$60
draw_loop13:
    LDA tilemap4, Y 
    STA current_tile2
    JSR draw_tiles

    INY             
    CPY #$68 
    BNE draw_loop13 
    LDA #$80   ; Starting map position
    STA map_pos2
    LDY #$68

    RTS
.endproc

.segment "RODATA"
WATER_TYPE = $00
BUOY_TYPE = $01
BUOYWALL_TYPE = $02
JELLYFISH_TYPE = $03
TENTACLE_TYPE = $04
LEFTTOP_TYPE = $05
RIGHTTOP_TYPE = $06
LEFTBOTTOMBUOY_TYPE = $07
RIGHTBOTTOMBUOY_TYPE = $08

water:
.byte $00, $00, $00, $00
buoy:
.byte $72, $73, $82, $83
buoyWall:
.byte $76, $77, $86, $87
jellyfish:
.byte $90, $91, $a0, $a1
tentacle: 
.byte $92, $93, $a2, $a3
leftTop:
.byte $70, $71, $80, $81
rightTop:
.byte $74, $75, $84, $85
leftBottomBuoy:
.byte $7a, $7b, $8a, $8b
rightBottomBuoy:
.byte $7e, $7f, $8e, $8f

tilemap3:
.byte $05, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
.byte $02, $00, $03, $00, $03, $03, $00, $00, $00, $00, $00, $03, $00, $00, $00, $00
.byte $02, $00, $03, $00, $03, $00, $00, $03, $03, $03, $00, $03, $00, $03, $03, $03
.byte $02, $00, $03, $00, $03, $00, $03, $03, $04, $03, $00, $03, $00, $03, $00, $00
.byte $02, $00, $03, $00, $03, $04, $03, $04, $04, $03, $04, $03, $04, $03, $03, $03
.byte $02, $04, $04, $00, $04, $04, $04, $04, $03, $03, $04, $04, $04, $04, $04, $00
.byte $02, $04, $03, $03, $03, $03, $03, $03, $03, $00, $04, $03, $03, $03, $03, $03
.byte $02, $04, $04, $04, $04, $00, $03, $00, $03, $00, $03, $03, $04, $04, $04, $03
.byte $02, $04, $03, $03, $03, $00, $03, $00, $03, $00, $03, $04, $04, $03, $04, $03
.byte $02, $00, $03, $00, $03, $00, $03, $00, $03, $00, $03, $04, $03, $03, $04, $03
.byte $08, $00, $03, $00, $03, $00, $03, $00, $03, $00, $03, $00, $03, $03, $03, $03
.byte $00, $00, $00, $00, $03, $00, $00, $00, $03, $00, $00, $00, $00, $00, $00, $00
.byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01

tilemap4:
.byte $01, $01, $01, $01, $01, $01, $01, $06
.byte $00, $04, $04, $04, $03, $00, $00, $02
.byte $03, $03, $03, $04, $03, $03, $00, $02
.byte $00, $00, $03, $04, $03, $03, $00, $02
.byte $03, $00, $03, $04, $04, $04, $00, $02
.byte $00, $00, $03, $00, $00, $00, $00, $02
.byte $03, $03, $03, $04, $04, $04, $00, $02
.byte $03, $04, $03, $04, $03, $03, $00, $02
.byte $03, $04, $03, $04, $03, $03, $03, $02
.byte $03, $04, $03, $04, $04, $04, $00, $02
.byte $03, $04, $03, $03, $03, $03, $00, $07
.byte $04, $04, $04, $04, $00, $03, $00, $00
.byte $01, $01, $01, $01, $01, $01, $01, $01 