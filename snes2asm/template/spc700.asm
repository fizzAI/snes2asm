;SPC700 I/O Register Definitions
;Sony SPC700 Audio Processor Registers

;==============================================================================
; Communication Ports (CPU <-> SPC700)
;==============================================================================
APUIO0 = $F4					;APU I/O Port 0 (CPU: $2140)
APUIO1 = $F5					;APU I/O Port 1 (CPU: $2141)
APUIO2 = $F6					;APU I/O Port 2 (CPU: $2142)
APUIO3 = $F7					;APU I/O Port 3 (CPU: $2143)

;==============================================================================
; Control and Test Registers
;==============================================================================
TEST = $F0					;Test Register (typically unused)

CONTROL = $F1					;Control Register
	CONTROL_TIMER0_ENABLE = 1 << 0
	CONTROL_TIMER1_ENABLE = 1 << 1
	CONTROL_TIMER2_ENABLE = 1 << 2
	CONTROL_RESET_PORTS_4_5 = 1 << 4
	CONTROL_RESET_PORTS_6_7 = 1 << 5
	CONTROL_IPL_ROM_ENABLE = 1 << 7

;==============================================================================
; DSP Interface Registers
;==============================================================================
DSPADDR = $F2					;DSP Register Address
DSPDATA = $F3					;DSP Register Data

;==============================================================================
; Timer Registers
;==============================================================================
T0DIV = $FA					;Timer 0 Divider (8000 Hz / n)
T1DIV = $FB					;Timer 1 Divider (8000 Hz / n)
T2DIV = $FC					;Timer 2 Divider (64000 Hz / n)

T0OUT = $FD					;Timer 0 Counter Output (read-only)
T1OUT = $FE					;Timer 1 Counter Output (read-only)
T2OUT = $FF					;Timer 2 Counter Output (read-only)

;==============================================================================
; Timer Common Values
;==============================================================================
; Timer frequency = base_freq / divider
; Timer 0/1: 8000 Hz base (125 us per tick)
; Timer 2: 64000 Hz base (15.625 us per tick)

	TIMER0_1MS = 8		;8000 Hz / 8 = 1000 Hz (1ms)
	TIMER0_2MS = 16		;8000 Hz / 16 = 500 Hz (2ms)
	TIMER0_4MS = 32		;8000 Hz / 32 = 250 Hz (4ms)
	TIMER0_8MS = 64		;8000 Hz / 64 = 125 Hz (8ms)
	TIMER0_16MS = 128		;8000 Hz / 128 = 62.5 Hz (16ms)
	TIMER0_32MS = 256		;8000 Hz / 256 = 31.25 Hz (32ms)

	TIMER1_1MS = 8		;8000 Hz / 8 = 1000 Hz (1ms)
	TIMER1_2MS = 16		;8000 Hz / 16 = 500 Hz (2ms)
	TIMER1_4MS = 32		;8000 Hz / 32 = 250 Hz (4ms)
	TIMER1_8MS = 64		;8000 Hz / 64 = 125 Hz (8ms)
	TIMER1_16MS = 128		;8000 Hz / 128 = 62.5 Hz (16ms)
	TIMER1_32MS = 256		;8000 Hz / 256 = 31.25 Hz (32ms)

	TIMER2_1MS = 64		;64000 Hz / 64 = 1000 Hz (1ms)
	TIMER2_500US = 32		;64000 Hz / 32 = 2000 Hz (0.5ms)
	TIMER2_250US = 16		;64000 Hz / 16 = 4000 Hz (0.25ms)

;==============================================================================
; DSP Register Addresses (accessed via $F2/$F3)
;==============================================================================
; Voice 0 Registers
DSP_V0_VOLL = $00				;Voice 0 Volume Left
DSP_V0_VOLR = $01				;Voice 0 Volume Right
DSP_V0_PITCHL = $02				;Voice 0 Pitch Low
DSP_V0_PITCHH = $03				;Voice 0 Pitch High
DSP_V0_SRCN = $04				;Voice 0 Source Number
DSP_V0_ADSR1 = $05				;Voice 0 ADSR1
DSP_V0_ADSR2 = $06				;Voice 0 ADSR2
DSP_V0_GAIN = $07				;Voice 0 Gain
DSP_V0_ENVX = $08				;Voice 0 Envelope (read-only)
DSP_V0_OUTX = $09				;Voice 0 Output (read-only)

; Voice 1 Registers
DSP_V1_VOLL = $10
DSP_V1_VOLR = $11
DSP_V1_PITCHL = $12
DSP_V1_PITCHH = $13
DSP_V1_SRCN = $14
DSP_V1_ADSR1 = $15
DSP_V1_ADSR2 = $16
DSP_V1_GAIN = $17
DSP_V1_ENVX = $18
DSP_V1_OUTX = $19

; Voice 2 Registers
DSP_V2_VOLL = $20
DSP_V2_VOLR = $21
DSP_V2_PITCHL = $22
DSP_V2_PITCHH = $23
DSP_V2_SRCN = $24
DSP_V2_ADSR1 = $25
DSP_V2_ADSR2 = $26
DSP_V2_GAIN = $27
DSP_V2_ENVX = $28
DSP_V2_OUTX = $29

; Voice 3 Registers
DSP_V3_VOLL = $30
DSP_V3_VOLR = $31
DSP_V3_PITCHL = $32
DSP_V3_PITCHH = $33
DSP_V3_SRCN = $34
DSP_V3_ADSR1 = $35
DSP_V3_ADSR2 = $36
DSP_V3_GAIN = $37
DSP_V3_ENVX = $38
DSP_V3_OUTX = $39

; Voice 4 Registers
DSP_V4_VOLL = $40
DSP_V4_VOLR = $41
DSP_V4_PITCHL = $42
DSP_V4_PITCHH = $43
DSP_V4_SRCN = $44
DSP_V4_ADSR1 = $45
DSP_V4_ADSR2 = $46
DSP_V4_GAIN = $47
DSP_V4_ENVX = $48
DSP_V4_OUTX = $49

; Voice 5 Registers
DSP_V5_VOLL = $50
DSP_V5_VOLR = $51
DSP_V5_PITCHL = $52
DSP_V5_PITCHH = $53
DSP_V5_SRCN = $54
DSP_V5_ADSR1 = $55
DSP_V5_ADSR2 = $56
DSP_V5_GAIN = $57
DSP_V5_ENVX = $58
DSP_V5_OUTX = $59

; Voice 6 Registers
DSP_V6_VOLL = $60
DSP_V6_VOLR = $61
DSP_V6_PITCHL = $62
DSP_V6_PITCHH = $63
DSP_V6_SRCN = $64
DSP_V6_ADSR1 = $65
DSP_V6_ADSR2 = $66
DSP_V6_GAIN = $67
DSP_V6_ENVX = $68
DSP_V6_OUTX = $69

; Voice 7 Registers
DSP_V7_VOLL = $70
DSP_V7_VOLR = $71
DSP_V7_PITCHL = $72
DSP_V7_PITCHH = $73
DSP_V7_SRCN = $74
DSP_V7_ADSR1 = $75
DSP_V7_ADSR2 = $76
DSP_V7_GAIN = $77
DSP_V7_ENVX = $78
DSP_V7_OUTX = $79

; Global DSP Registers
DSP_MVOLL = $0C				;Main Volume Left
DSP_MVOLR = $1C				;Main Volume Right
DSP_EVOLL = $2C				;Echo Volume Left
DSP_EVOLR = $3C				;Echo Volume Right
DSP_KON = $4C				;Key On
DSP_KOFF = $5C				;Key Off
DSP_FLG = $6C				;DSP Flags
DSP_ENDX = $7C				;Voice End (read-only)

DSP_EFB = $0D				;Echo Feedback
DSP_PMOD = $2D				;Pitch Modulation Enable
DSP_NON = $3D				;Noise Enable
DSP_EON = $4D				;Echo Enable
DSP_DIR = $5D				;Sample Table Directory
DSP_ESA = $6D				;Echo Buffer Start Address
DSP_EDL = $7D				;Echo Delay Length

; Echo FIR Filter Coefficients
DSP_FIR0 = $0F
DSP_FIR1 = $1F
DSP_FIR2 = $2F
DSP_FIR3 = $3F
DSP_FIR4 = $4F
DSP_FIR5 = $5F
DSP_FIR6 = $6F
DSP_FIR7 = $7F

;==============================================================================
; DSP Flag Register ($6C) Bit Definitions
;==============================================================================
	DSP_FLG_SOFT_RESET = 1 << 7
	DSP_FLG_MUTE = 1 << 6
	DSP_FLG_ECHO_DISABLE = 1 << 5
	DSP_FLG_NOISE_FREQ_32KHZ = 0 << 0
	DSP_FLG_NOISE_FREQ_16KHZ = 1 << 0
	DSP_FLG_NOISE_FREQ_8KHZ = 2 << 0
	DSP_FLG_NOISE_FREQ_4KHZ = 3 << 0
	DSP_FLG_NOISE_FREQ_2KHZ = 4 << 0
	DSP_FLG_NOISE_FREQ_1KHZ = 5 << 0
	DSP_FLG_NOISE_FREQ_500HZ = 6 << 0
	DSP_FLG_NOISE_FREQ_250HZ = 7 << 0
	DSP_FLG_NOISE_FREQ_125HZ = 8 << 0
	DSP_FLG_NOISE_FREQ_62HZ = 9 << 0
	DSP_FLG_NOISE_FREQ_31HZ = 10 << 0
	DSP_FLG_NOISE_FREQ_15HZ = 11 << 0
	DSP_FLG_NOISE_FREQ_7HZ = 12 << 0
	DSP_FLG_NOISE_FREQ_4HZ = 13 << 0
	DSP_FLG_NOISE_FREQ_2HZ = 14 << 0
	DSP_FLG_NOISE_FREQ_1HZ = 15 << 0
	DSP_FLG_NOISE_FREQ_0_5HZ = 16 << 0
	DSP_FLG_NOISE_FREQ_0_25HZ = 17 << 0
	DSP_FLG_NOISE_FREQ_0_125HZ = 18 << 0
	DSP_FLG_NOISE_FREQ_0_0625HZ = 19 << 0
	DSP_FLG_NOISE_FREQ_0_03125HZ = 20 << 0
	DSP_FLG_NOISE_FREQ_0_015625HZ = 21 << 0
	DSP_FLG_NOISE_FREQ_0_0078125HZ = 22 << 0
	DSP_FLG_NOISE_FREQ_0_00390625HZ = 23 << 0
	DSP_FLG_NOISE_FREQ_0_001953125HZ = 24 << 0
	DSP_FLG_NOISE_FREQ_0_0009765625HZ = 25 << 0
	DSP_FLG_NOISE_FREQ_0_00048828125HZ = 26 << 0
	DSP_FLG_NOISE_FREQ_0_000244140625HZ = 27 << 0
	DSP_FLG_NOISE_FREQ_0_0001220703125HZ = 28 << 0
	DSP_FLG_NOISE_FREQ_0_00006103515625HZ = 29 << 0
	DSP_FLG_NOISE_FREQ_0_000030517578125HZ = 30 << 0
	DSP_FLG_NOISE_FREQ_0_0000152587890625HZ = 31 << 0

;==============================================================================
; ADSR1 Register Bit Definitions
;==============================================================================
	DSP_ADSR1_ENABLE = 1 << 7
	DSP_ADSR1_DECAY_MASK = $70
	DSP_ADSR1_ATTACK_MASK = $0F

;==============================================================================
; ADSR2 Register Bit Definitions
;==============================================================================
	DSP_ADSR2_SUSTAIN_LEVEL_MASK = $E0
	DSP_ADSR2_SUSTAIN_RATE_MASK = $1F

;==============================================================================
; GAIN Register Bit Definitions
;==============================================================================
	DSP_GAIN_DIRECT = 0 << 7		;Direct gain mode
	DSP_GAIN_ENVELOPE = 1 << 7		;Envelope mode
	DSP_GAIN_MODE_LINEAR_DEC = 0 << 5		;Linear decrease
	DSP_GAIN_MODE_EXP_DEC = 1 << 5		;Exponential decrease
	DSP_GAIN_MODE_LINEAR_INC = 2 << 5		;Linear increase
	DSP_GAIN_MODE_BENT_INC = 3 << 5		;Bent line increase
	DSP_GAIN_RATE_MASK = $1F

;==============================================================================
; Common Volume Values
;==============================================================================
	VOL_FULL = $7F				;Maximum volume
	VOL_HALF = $40				;50% volume
	VOL_QUARTER = $20				;25% volume
	VOL_MUTE = $00				;Mute/silence

;==============================================================================
; Common Pitch Values (middle C = $1000)
;==============================================================================
	PITCH_C4 = $1000			;Middle C (261.63 Hz)
	PITCH_NORMAL = $1000			;Normal playback rate
	PITCH_DOUBLE = $2000			;Double speed (octave up)
	PITCH_HALF = $0800			;Half speed (octave down)

;==============================================================================
; Voice Bit Masks (for KON, KOFF, PMON, NON, EON, ENDX)
;==============================================================================
	VOICE0_BIT = 1 << 0
	VOICE1_BIT = 1 << 1
	VOICE2_BIT = 1 << 2
	VOICE3_BIT = 1 << 3
	VOICE4_BIT = 1 << 4
	VOICE5_BIT = 1 << 5
	VOICE6_BIT = 1 << 6
	VOICE7_BIT = 1 << 7
	ALL_VOICES = $FF
