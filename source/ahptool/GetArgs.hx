package source.ahptool;

import haxe.Json;

class GetArgs {
    public dynamic static function getArgs(): Map<Int, String> {
        // Retrieve command-line arguments
        var args = Sys.args();

        // Initialize an empty map to store arguments
        var argsMap = new Map<Int, String>();

        // Check if there are any arguments
        if (args.length > 0) {
            var i = 1;
            for (arg in args) {
                argsMap.set(i, arg);
                i++;
            }
        }

        // Return the map of arguments
        return argsMap;
    }
}