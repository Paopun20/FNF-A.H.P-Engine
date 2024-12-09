package ahptool;

import haxe.ds.IntMap;

class BrainfuckError extends haxe.Exception {
    public function new(message: String) {
        super(message);
    }
}

class BrainFuck {
    public static function runBrainfuck(code: String, input: IntMap<Int>): String {
        var tape = new Array<Int>();
        var tapePointer = 0;
        var codePointer = 0;
        var output = new StringBuf();
        
        tape.push(0);  // Initialize tape with 1 cell set to 0
        //trace("Initialized tape with one cell: " + tape);

        // Filter valid Brainfuck commands
        var filteredCode = code.split("").filter(char -> {
            return char == '>' || char == '<' || char == '+' || char == '-' ||
                   char == '.' || char == ',' || char == '[' || char == ']';
        }).join("");
        //trace("Filtered Brainfuck code: " + filteredCode);

        // Verify balanced brackets and map pairs
        var openBrackets = 0;
        var bracketMap = new haxe.ds.IntMap<Int>();
        var positions = new Array<Int>();

        for (i in 0...filteredCode.length) {
            var c = filteredCode.charAt(i);
            if (c == '[') {
                openBrackets++;
                positions.push(i);
            } else if (c == ']') {
                if (openBrackets == 0) throw new BrainfuckError("Unmatched closing bracket at position " + i);
                openBrackets--;
                var openingPosition = positions.pop();
                bracketMap.set(openingPosition, i);
                bracketMap.set(i, openingPosition);
            }
        }
        if (openBrackets != 0) throw new BrainfuckError("Unmatched opening bracket");
        //trace("Bracket map created: " + bracketMap);

        // Brainfuck execution loop
        while (codePointer < filteredCode.length) {
            var command = filteredCode.charAt(codePointer);
            //trace("Executing command '" + command + "' at codePointer: " + codePointer + ", tapePointer: " + tapePointer);

            if (command == '>') {
                tapePointer++;
                if (tapePointer >= tape.length) {
                    tape.push(0);
                    //trace("Extended tape: " + tape);
                }
            } else if (command == '<') {
                tapePointer = Std.int(Math.max(0, tapePointer - 1));
                //trace("Moved tapePointer left to: " + tapePointer);
            } else if (command == '+') {
                tape[tapePointer] = (tape[tapePointer] + 1) % 256;
                //trace("Incremented cell at tapePointer " + tapePointer + " to: " + tape[tapePointer]);
            } else if (command == '-') {
                tape[tapePointer] = (tape[tapePointer] - 1 + 256) % 256;
                //trace("Decremented cell at tapePointer " + tapePointer + " to: " + tape[tapePointer]);
            } else if (command == '.') {
                var charCode = tape[tapePointer];
                if (charCode >= 0 && charCode <= 127) {
                    output.add(String.fromCharCode(charCode));
                    //trace("Output character: " + String.fromCharCode(charCode));
                } else {
                    output.add("?");
                    //trace("Output non-printable character as '?', tape value: " + charCode);
                }
            } else if (command == ',') {
                tape[tapePointer] = input.exists(tapePointer) ? input.get(tapePointer) : 0;
                //trace("Input value at tapePointer " + tapePointer + ": " + tape[tapePointer]);
            } else if (command == '[') {
                if (tape[tapePointer] == 0) {
                    codePointer = bracketMap.get(codePointer);
                    //trace("Jumped forward to codePointer: " + codePointer);
                }
            } else if (command == ']') {
                if (tape[tapePointer] != 0) {
                    codePointer = bracketMap.get(codePointer) - 1;
                    //trace("Jumped back to codePointer: " + codePointer);
                }
            }
            codePointer++;
        }

        //trace("Final tape state: " + tape);
        //trace("Final output: " + output.toString());
        return output.toString();
    }
}
