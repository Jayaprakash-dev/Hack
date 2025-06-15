// The Mult program, designed to compute R2 = R0 * R1
// mul => R0, product => R1
// for (i = 0; i < product; i++) { mul += mul; }

@i
M = 0 // i = 0

@R2
M = 0 // Ensures that the program initialized R2 to 0

(LOOP)
    @R1
    D = M // D = RAM[R1]

    @i
    D = D - M // D = D - RAM[i]
    @END
    D; JEQ // if D == 0 then goto END

    @R0
    D = M // D = RAM[R0]
    @R2
    M = M + D // RAM[R2] = RAM[R2] + D

    @i
    M = M + 1 // i++

    @LOOP
    0; JMP

(END)
    @END
    0; JMP
