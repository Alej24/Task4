.include "constants.inc"

.segment "ZEROPAGE"
map_pos: .res 1
nam_pos: .res 1
current_tile: .res 1

.segment "CODE"

.export draw_obstacles, draw_stage
.proc draw_stage
    LDA PPUSTATUS
	LDA #$20
	STA PPUADDR
	LDA #$20
	STA PPUADDR	
	LDX #$16		; stage 1
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
    LDX #$1f
	STX PPUDATA
.endproc

.proc draw_obstacles
    ; Draw obstacles and update attribute tables

    LDA #$20
    STA nam_pos
    LDA #$40   ; Starting map position
    STA map_pos

    LDY #$00   ; Initialize Y register to 0 for loop counter

draw_loop:
    LDA tilemap, Y   ; Load value from tilemap at index Y
    STA current_tile
    JSR draw_tiles

    INY             ; Increment Y to move to the next index
    CPY #$10        ; Compare Y to end
    BNE draw_loop   ; Branch back to draw_loop if Y is not equal to end
    LDA #$80   ; Starting map position
    STA map_pos
    LDY #$10

draw_loop2:
    LDA tilemap, Y   ; Load value from tilemap at index Y
    STA current_tile
    JSR draw_tiles

    INY             
    CPY #$20 
    BNE draw_loop2
    LDA #$c0   ; Starting map position
    STA map_pos
    LDY #$20

draw_loop3:
    LDA tilemap, Y   ; Load value from tilemap at index Y
    STA current_tile
    JSR draw_tiles

    INY             
    CPY #$30 
    BNE draw_loop3
    LDA #$21
    STA nam_pos
    LDA #$00   ; Starting map position
    STA map_pos
    LDY #$30
draw_loop4:
    LDA tilemap, Y   ; Load value from tilemap at index Y
    STA current_tile
    JSR draw_tiles

    INY             
    CPY #$40 
    BNE draw_loop4
    LDA #$40   ; Starting map position
    STA map_pos
    LDY #$40
draw_loop5:
    LDA tilemap, Y   ; Load value from tilemap at index Y
    STA current_tile
    JSR draw_tiles

    INY             
    CPY #$50 
    BNE draw_loop5
    LDA #$80   ; Starting map position
    STA map_pos
    LDY #$50
draw_loop6:
    LDA tilemap, Y   ; Load value from tilemap at index Y
    STA current_tile
    JSR draw_tiles

    INY             
    CPY #$60 
    BNE draw_loop6
    LDA #$c0   ; Starting map position
    STA map_pos
    LDY #$60
draw_loop7:
    LDA tilemap, Y   ; Load value from tilemap at index Y
    STA current_tile
    JSR draw_tiles

    INY             
    CPY #$70 
    BNE draw_loop7
    LDA #$22
    STA nam_pos
    LDA #$00   ; Starting map position
    STA map_pos
    LDY #$70
draw_loop8:
    LDA tilemap, Y   ; Load value from tilemap at index Y
    STA current_tile
    JSR draw_tiles

    INY             
    CPY #$80 
    BNE draw_loop8
    LDA #$40   ; Starting map position
    STA map_pos
    LDY #$80
draw_loop9:
    LDA tilemap, Y   ; Load value from tilemap at index Y
    STA current_tile
    JSR draw_tiles

    INY             
    CPY #$90 
    BNE draw_loop9
    LDA #$80   ; Starting map position
    STA map_pos
    LDY #$90
draw_loop10:
    LDA tilemap, Y   ; Load value from tilemap at index Y
    STA current_tile
    JSR draw_tiles

    INY             
    CPY #$a0 
    BNE draw_loop10
    LDA #$c0   ; Starting map position
    STA map_pos
    LDY #$a0
draw_loop11:
    LDA tilemap, Y   ; Load value from tilemap at index Y
    STA current_tile
    JSR draw_tiles

    INY             
    CPY #$b0 
    BNE draw_loop11
    LDA #$23
    STA nam_pos
    LDA #$00   ; Starting map position
    STA map_pos
    LDY #$b0
draw_loop12:
    LDA tilemap, Y   ; Load value from tilemap at index Y
    STA current_tile
    JSR draw_tiles

    INY             
    CPY #$c0 
    BNE draw_loop12
    LDA #$40   ; Starting map position
    STA map_pos
    LDY #$c0
draw_loop13:
    LDA tilemap, Y   ; Load value from tilemap at index Y
    STA current_tile
    JSR draw_tiles

    INY             
    CPY #$d0 
    BNE draw_loop13
    LDA #$80   ; Starting map position
    STA map_pos
    LDY #$d0

    RTS
.endproc

.proc draw_tiles
    LDA PPUSTATUS
    LDA nam_pos      ; Set PPU address to the beginning of the name table
    STA PPUADDR
    LDA map_pos
    STA PPUADDR

    ; Calculate the starting position to draw the tiles
    LDX #0

    ; Draw all four tiles
draw_tile_loop:
    ; Determine whether to draw on the top row or bottom row
    CPX #2           ; Check if two tiles have been drawn
    BNE draw_top_row   ; If not, draw on the top row
    LDA PPUSTATUS
    LDA nam_pos        ; Set PPU address to the beginning of the name table for the next row
    STA PPUADDR
    LDA map_pos
    CLC
    ADC #$20           ; Move to the next row
    STA PPUADDR

draw_top_row:
    LDA current_tile   ; Load current tile type
    CMP #WATER_TYPE     ; Compare with SAND_TYPE
    BEQ water_tile      ; If it's sand, go to sand_tile
    CMP #SAND_TYPE     ; Compare with SAND_TYPE
    BEQ sand_tile      ; If it's sand, go to sand_tile
	CMP #SANDWALL_TYPE     ; Compare with SAND_TYPE
    BEQ sandWall_tile      ; If it's sand, go to sand_tile
    CMP #CRATE_TYPE    ; Compare with CRATE_TYPE
    BEQ crate_tile     ; If it's crate, go to crate_tile
    CMP #SEAWEED_TYPE  ; Compare with SEAWEED_TYPE
    BEQ seaweed_tile   ; If it's seaweed, go to seaweed_tile
    CMP #LEFTCORNER_TYPE  ; Compare with SEAWEED_TYPE
    BEQ leftCorner_tile   ; If it's seaweed, go to seaweed_tile
    CMP #RIGHTCORNER_TYPE  ; Compare with SEAWEED_TYPE
    BEQ rightCorner_tile   ; If it's seaweed, go to seaweed_tile
    CMP #LEFTBOTTOM_TYPE  ; Compare with SEAWEED_TYPE
    BEQ leftBottom_tile   ; If it's seaweed, go to seaweed_tile
    CMP #RIGHTBOTTOM_TYPE  ; Compare with SEAWEED_TYPE
    BEQ rightBottom_tile   ; If it's seaweed, go to seaweed_tile

    ; Handle unknown tile types here or skip them
    JMP next_tile      ; Jump to next_tile

water_tile:
    LDA water, X        ; Load sand tile data
    JMP draw_tile_data ; Jump to draw_tile_data

sand_tile:
    LDA sand, X        ; Load sand tile data
    JMP draw_tile_data ; Jump to draw_tile_data

sandWall_tile:
	LDA sandWall, X    ; Load sand tile data
	JMP draw_tile_data ; Jump to draw_tile_data

crate_tile:
    LDA crate, X       ; Load crate tile data
    JMP draw_tile_data ; Jump to draw_tile_data

seaweed_tile:
    LDA seaweed, X     ; Load seaweed tile data
    JMP draw_tile_data ; Jump to draw_tile_data

leftCorner_tile:
    LDA leftCorner, X    
    JMP draw_tile_data ; Jump to draw_tile_data

rightCorner_tile:
    LDA rigthCorner, X    
    JMP draw_tile_data ; Jump to draw_tile_data

leftBottom_tile:
    LDA leftBottom, X    
    JMP draw_tile_data ; Jump to draw_tile_data

rightBottom_tile:
    LDA rightBottom, X    
    JMP draw_tile_data ; Jump to draw_tile_data

draw_tile_data:
    STA PPUDATA        ; Write tile data to PPU
    INX                ; Increment X to read next tile data
    CPX #4           ; Check if two tiles have been drawn on the top row
    BNE draw_tile_loop ; If not, continue drawing
    ; If two tiles have been drawn on the top row, move to the next row

next_tile:
    LDA map_pos
    CLC
    ADC #$02
    STA map_pos
    RTS
.endproc

.export draw_obstacles2
.proc draw_obstacles2
    ; Draw obstacles and update attribute tables

    LDA #$24
    STA nam_pos
    LDA #$40   ; Starting map position
    STA map_pos

    LDY #$00   ; Initialize Y register to 0 for loop counter

draw_loop:
    LDA tilemap2, Y   ; Load value from tilemap at index Y
    STA current_tile
    JSR draw_tiles

    INY             ; Increment Y to move to the next index
    CPY #$08        ; Compare Y to end
    BNE draw_loop   ; Branch back to draw_loop if Y is not equal to end
    LDA #$80   ; Starting map position
    STA map_pos
    LDY #$08

draw_loop2:
    LDA tilemap2, Y   ; Load value from tilemap at index Y
    STA current_tile
    JSR draw_tiles

    INY             
    CPY #$10 
    BNE draw_loop2
    LDA #$c0   ; Starting map position
    STA map_pos
    LDY #$10

draw_loop3:
    LDA tilemap2, Y   ; Load value from tilemap at index Y
    STA current_tile
    JSR draw_tiles

    INY             
    CPY #$18 
    BNE draw_loop3
    LDA #$25
    STA nam_pos
    LDA #$00   ; Starting map position
    STA map_pos
    LDY #$18
draw_loop4:
    LDA tilemap2, Y   ; Load value from tilemap at index Y
    STA current_tile
    JSR draw_tiles

    INY             
    CPY #$20 
    BNE draw_loop4
    LDA #$40   ; Starting map position
    STA map_pos
    LDY #$20
draw_loop5:
    LDA tilemap2, Y   ; Load value from tilemap at index Y
    STA current_tile
    JSR draw_tiles

    INY             
    CPY #$28 
    BNE draw_loop5
    LDA #$80   ; Starting map position
    STA map_pos
    LDY #$28
draw_loop6:
    LDA tilemap2, Y   ; Load value from tilemap at index Y
    STA current_tile
    JSR draw_tiles

    INY             
    CPY #$30 
    BNE draw_loop6
    LDA #$c0   ; Starting map position
    STA map_pos
    LDY #$30
draw_loop7:
    LDA tilemap2, Y   ; Load value from tilemap at index Y
    STA current_tile
    JSR draw_tiles

    INY             
    CPY #$38 
    BNE draw_loop7
    LDA #$26
    STA nam_pos
    LDA #$00   ; Starting map position
    STA map_pos
    LDY #$38
draw_loop8:
    LDA tilemap2, Y   ; Load value from tilemap at index Y
    STA current_tile
    JSR draw_tiles

    INY             
    CPY #$40 
    BNE draw_loop8
    LDA #$40   ; Starting map position
    STA map_pos
    LDY #$40
draw_loop9:
    LDA tilemap2, Y   ; Load value from tilemap at index Y
    STA current_tile
    JSR draw_tiles

    INY             
    CPY #$48 
    BNE draw_loop9
    LDA #$80   ; Starting map position
    STA map_pos
    LDY #$48
draw_loop10:
    LDA tilemap2, Y   ; Load value from tilemap at index Y
    STA current_tile
    JSR draw_tiles

    INY             
    CPY #$50 
    BNE draw_loop10
    LDA #$c0   ; Starting map position
    STA map_pos
    LDY #$50
draw_loop11:
    LDA tilemap2, Y   ; Load value from tilemap at index Y
    STA current_tile
    JSR draw_tiles

    INY             
    CPY #$58 
    BNE draw_loop11
    LDA #$27
    STA nam_pos
    LDA #$00   ; Starting map position
    STA map_pos
    LDY #$58
draw_loop12:
    LDA tilemap2, Y   ; Load value from tilemap at index Y
    STA current_tile
    JSR draw_tiles

    INY             
    CPY #$60 
    BNE draw_loop12
    LDA #$40   ; Starting map position
    STA map_pos
    LDY #$60
draw_loop13:
    LDA tilemap2, Y   ; Load value from tilemap at index Y
    STA current_tile
    JSR draw_tiles

    INY             
    CPY #$68 
    BNE draw_loop13
    LDA #$80   ; Starting map position
    STA map_pos
    LDY #$68

    RTS
.endproc

.segment "RODATA"
WATER_TYPE = $00
SAND_TYPE = $01
SANDWALL_TYPE = $02
CRATE_TYPE = $03
SEAWEED_TYPE = $04
LEFTCORNER_TYPE = $05
RIGHTCORNER_TYPE = $06
LEFTBOTTOM_TYPE = $07
RIGHTBOTTOM_TYPE = $08

water:
.byte $00, $00, $00, $00
sand:
.byte $32, $33, $42, $43
sandWall:
.byte $36, $37, $46, $47
crate:
.byte $50, $51, $60, $61
seaweed: 
.byte $52, $53, $62, $63
leftCorner:
.byte $30, $31, $40, $41
rigthCorner:
.byte $34, $35, $44, $45
leftBottom:
.byte $3a, $3b, $4a, $4b
rightBottom:
.byte $3e, $3f, $4e, $4f

tilemap:
.byte $05, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
.byte $02, $00, $00, $00, $03, $04, $04, $04, $03, $00, $00, $00, $03, $03, $03, $00
.byte $02, $00, $03, $00, $03, $04, $03, $04, $03, $00, $03, $00, $03, $04, $00, $00
.byte $02, $00, $03, $03, $03, $04, $03, $04, $03, $00, $03, $03, $03, $04, $03, $03
.byte $02, $00, $00, $00, $00, $00, $03, $00, $03, $00, $03, $04, $04, $04, $03, $00
.byte $02, $00, $03, $03, $03, $03, $03, $00, $03, $00, $03, $04, $03, $03, $03, $00
.byte $02, $00, $03, $00, $00, $00, $03, $00, $00, $00, $03, $04, $03, $00, $00, $00
.byte $02, $04, $03, $04, $03, $00, $03, $00, $03, $00, $03, $04, $03, $00, $03, $03
.byte $02, $04, $03, $04, $03, $00, $03, $04, $03, $03, $03, $00, $03, $00, $03, $04
.byte $02, $04, $04, $04, $03, $00, $03, $04, $04, $04, $03, $00, $03, $00, $03, $04
.byte $08, $00, $03, $04, $03, $03, $03, $04, $03, $04, $03, $00, $03, $03, $03, $04
.byte $00, $00, $03, $04, $03, $00, $00, $00, $03, $00, $00, $00, $04, $04, $04, $04
.byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01

tilemap2:
.byte $01, $01, $01, $01, $01, $01, $01, $06
.byte $00, $00, $03, $03, $03, $03, $04, $02
.byte $03, $00, $04, $04, $04, $03, $04, $02
.byte $03, $03, $03, $03, $04, $03, $04, $02
.byte $04, $04, $04, $03, $04, $03, $04, $02
.byte $03, $04, $03, $03, $04, $03, $04, $02
.byte $03, $04, $03, $03, $04, $03, $00, $02
.byte $03, $04, $00, $00, $00, $00, $00, $02
.byte $03, $04, $03, $03, $03, $03, $00, $02
.byte $03, $00, $03, $04, $04, $03, $00, $02
.byte $03, $00, $03, $03, $04, $03, $00, $07
.byte $03, $00, $04, $04, $04, $03, $00, $00
.byte $01, $01, $01, $01, $01, $01, $01, $01 