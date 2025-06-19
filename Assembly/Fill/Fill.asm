//// Runs an infinite loop that listens to the keyboard input. 
//// When a key is pressed (any key), the program blackens the screen,
//// i.e. writes "black" in every pixel. When no key is pressed, 
//// the screen should be cleared.
//
//@SCREEN
//D = A // screen mapper base address
//
//// Screen = 256×512 = 131072 pixels = 8192 words (16 bits each)
//// Screen base = 16384 -> end = (16384 + 8192) - 1 = 24575
//// (Subtract 1 due to 0-based addressing)
//
//@24575
//D = A // end address of screen mapper
//@len
//M = D
//M = M + 1 // length of screen mapper
//
//@RESET_FLAG
//M = 0 // Track screen state (0 = cleared, 1 = black)
//
//(LOOP)
//    @KBD
//    D = M // read keyboard input
//    @RESET_SCREEN
//    D; JEQ // If no key is pressed, clear the screen
//
//    @RESET_FLAG
//    D = M
//    @LOOP
//    D; JGT // If screen is already black, skip
//
//    // Set i = base address of screen
//    @SCREEN
//    D = A // screen mapper base memory address
//    @i
//    M = D
//
//    (BLACKEN_SCREEN) // sets every word in screen mapper to -1
//        @i
//        D = M
//        @len
//        D = M - D // D = RAM[len] - RAM[i]
//        @BLACKEN_SCREEN_DONE
//        D; JEQ // if D == 0 then END
//
//        @i
//        A = M
//        M = -1 // RAM[A] = -1
//
//        @i
//        M = M + 1 // i++
//
//        @BLACKEN_SCREEN
//        0; JMP
//
//    (BLACKEN_SCREEN_DONE)
//        @RESET_FLAG
//        M = 1
//        @LOOP
//        0; JMP
//
//    (RESET_SCREEN) // sets every word in screen mapper to 0
//        @RESET_FLAG
//        D = M
//        @LOOP
//        D; JEQ // if RESET_FLAG == 0 then goto LOOP (no need to reset screen)
//
//        // set i = base add of screen mapper
//        @SCREEN
//        D = A
//        @i
//        M = D
//
//        (RESET_SCREEN_LOOP)
//            @i
//            D = M
//            @len
//            D = M - D // D = RAM[len] - RAM[i]
//            @RESET_DONE
//            D; JEQ // if D == 0 then END
//
//            @i
//            A = M
//            M = 0 // RAM[A] = 0
//
//            @i
//            M = M + 1 // i++
//
//            @RESET_SCREEN_LOOP
//            0; JMP
//        
//        (RESET_DONE)
//            @RESET_FLAG
//            M = 0
//            @LOOP
//            0; JMP
//

@SCREEN_COLOR
M = 0

(LOOP)
@SCREEN
D = A

@CURRENT_PIXEL
M = D

@KBD
D = M

@BLACKEN_SCREEN
D; JGT

@WHITEN_SCREEN
D; JEQ

(BLACKEN_SCREEN)
    @SCREEN_COLOR
    D = M
    @LOOP
    D; JGT // if SCREEN_COLOR == 1 then screen is already black, skip

    @SCREEN_COLOR
    M = 1
    
    @SCREEN_FILL_VALUE
    M = -1
    @CHANGE_SCREEN_PIXELS
    0; JMP

(WHITEN_SCREEN)
    @SCREEN_COLOR
    D = M
    @LOOP
    D; JEQ // if SCREEN_COLOR == 0 then screen is already white, skip

    @SCREEN_COLOR
    M = 0

    @SCREEN_FILL_VALUE
    M = 0
    @CHANGE_SCREEN_PIXELS
    0; JMP

(CHANGE_SCREEN_PIXELS)
    @SCREEN_FILL_VALUE
    D = M

    @CURRENT_PIXEL
    A = M
    M = D // get RAM[A] and fill it with the -1 or 0

    @CURRENT_PIXEL
    D = M + 1

    @KBD
    D = A - D

    @CURRENT_PIXEL
    M = M + 1

    @CHANGE_SCREEN_PIXELS
    D; JGT

@LOOP
0; JMP