package debug;

import sys.io.Process; // For running external processes in Haxe

class DEBUG_SYSTEM_INFO {
    public static function getCpuName():String {
        #if windows
            return getCpuInfoWindows();
        #elseif mac
            return getCpuInfoMac();
        #elseif linux
            return getCpuInfoLinux();
        #else
            return "Unable to get CPU Info.";
        #end
    }

    public static function getGpuName():String {
        #if windows
            return getGpuInfoWindows();
        #elseif mac
            return getGpuInfoMac();
        #elseif linux
            return getGpuInfoLinux();
        #else
            return "Unable to get GPU Info.";
        #end
    }

    #if windows
    private static function getCpuInfoWindows():String {
        try {
            var process = new Process("wmic", ["cpu", "get", "Name"]);
            var output = process.stdout.readAll().toString().trim(); // Read and trim the output
            //process.waitFor(); // Ensure the process has finished
            var lines = output.split("\n");
            if (lines.length > 1) {
                return lines[1].trim(); // CPU info is expected in the second line
            }
            return "No CPU information found.";
        } catch (e:Dynamic) {
            return "Error fetching CPU info on Windows: " + Std.string(e);
        }
    }

    private static function getGpuInfoWindows():String {
        try {
            var process = new Process("wmic", ["path", "win32_videocontroller", "get", "caption"]);
            var output = process.stdout.readAll().toString().trim(); // Read and trim the output
            //process.waitFor(); // Ensure the process has finished
            var lines = output.split("\n");
            if (lines.length > 1) {
                return lines[1].trim(); // GPU info is expected in the second line
            }
            return "No GPU information found.";
        } catch (e:Dynamic) {
            return "Error fetching GPU info on Windows: " + Std.string(e);
        }
    }
    #end
    
    #if linux
    private static function getCpuInfoLinux():String {
        try {
            var process = new Process("lscpu", ["|", "grep", "'Model name'", "|", "cut", "-d", ":", "-f2"]);
            var output = process.stdout.readAll().toString().trim(); // Read and trim the output
            //process.waitFor(); // Ensure the process has finished
            if (output != "") {
                return output.split("\n")[0].trim(); // Model name from the output
            }
            return "No CPU information found.";
        } catch (e:Dynamic) {
            return "Error fetching CPU info on Linux: " + Std.string(e);
        }
    }

    private static function getGpuInfoLinux():String {
        try {
            var process = new Process("lspci", ["|", "grep", "VGA"]);
            var output = process.stdout.readAll().toString().trim(); // Read and trim the output
            //process.waitFor(); // Ensure the process has finished
            if (output != "") {
                return output.split(":")[1].trim(); // Extract GPU name after colon
            }
            return "No GPU information found.";
        } catch (e:Dynamic) {
            return "Error fetching GPU info on Linux: " + Std.string(e);
        }
    }
    #end

    #if mac
    private static function getCpuInfoMac():String {
        try {
            var process = new Process("sysctl", ["-n", "machdep.cpu.brand_string"]);
            var output = process.stdout.readAll().toString().trim(); // Read and trim the output
            //process.waitFor(); // Ensure the process has finished
            return output != "" ? output : "No CPU information found.";
        } catch (e:Dynamic) {
            return "Error fetching CPU info on macOS: " + Std.string(e);
        }
    }

    private static function getGpuInfoMac():String {
        try {
            var process = new Process("system_profiler", ["SPDisplaysDataType"]);
            var output = process.stdout.readAll().toString().trim(); // Read and trim the output
            //process.waitFor(); // Ensure the process has finished
            var lines = output.split("\n");
            for (line in lines) {
                if (line.indexOf("Chipset Model") != -1) {
                    return line.split(":")[1].trim(); // Extract GPU name after colon
                }
            }
            return "No GPU information found.";
        } catch (e:Dynamic) {
            return "Error fetching GPU info on macOS: " + Std.string(e);
        }
    }
    #end
}
