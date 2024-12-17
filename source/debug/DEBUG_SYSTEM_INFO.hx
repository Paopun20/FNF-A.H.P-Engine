package debug;

import sys.io.Process; // For running external processes in Haxe

class DEBUG_SYSTEM_INFO {
    public static function getCpuName():String {
        #if windows
            // Windows: fetching only the CPU Name
            return getCpuInfoWindows();
        #elseif mac
            // macOS: fetching only the CPU Name
            return getCpuInfoMac();
        #elseif linux
            // Linux: fetching only the CPU Name
            return getCpuInfoLinux();
        #else
            return "Unable to get CPU Info.";
        #end
    }

    public static function getGpuName():String {
        #if windows
            // Windows: fetching only the GPU Name
            return getGpuInfoWindows();
        #elseif mac
            // macOS: fetching only the GPU Name
            return getGpuInfoMac();
        #elseif linux
            // Linux: fetching only the GPU Name
            return getGpuInfoLinux();
        #else
            return "Unable to get GPU Info.";
        #end
    }

    private static function getCpuInfoWindows():String {
        // Windows: Fetching CPU info using sys.io.new Process
        try {
            var process = new Process("wmic cpu get Name", []);  // Command with args as null
            var output = process.stdout.readAll().toString().trim(); // Convert Bytes to String and trim
            return output.split("\n")[1].trim(); // CPU info is on the second line
        } catch (e:Dynamic) {
            return "Error fetching CPU info.";
        }
    }

    private static function getCpuInfoMac():String {
        // macOS: Using sysctl to fetch the CPU Name
        try {
            var process = new Process("sysctl -n machdep.cpu.brand_string", []);  // Single string command with args as null
            var output = process.stdout.readAll().toString().trim(); // Convert Bytes to String and trim
            return output; // The output is directly the CPU name
        } catch (e:Dynamic) {
            return "Error fetching CPU info.";
        }
    }

    private static function getCpuInfoLinux():String {
        // Linux: Using lscpu to fetch the CPU Model Name
        try {
            var process = new Process("lscpu | grep 'Model name' | cut -d ':' -f2", []); // Command with args as null
            var output = process.stdout.readAll().toString().trim(); // Convert Bytes to String and trim
            return output.split("\n")[0].trim(); // Extract Model name line
        } catch (e:Dynamic) {
            return "Error fetching CPU info.";
        }
    }

    private static function getGpuInfoWindows():String {
        // Windows: Fetching GPU info using sys.io.new Process
        try {
            var process = new Process("wmic path win32_videocontroller get caption", []); // Command with args as null
            var output = process.stdout.readAll().toString().trim(); // Convert Bytes to String and trim
            return output.split("\n")[1].trim(); // GPU info is on the second line
        } catch (e:Dynamic) {
            return "Error fetching GPU info.";
        }
    }

    private static function getGpuInfoMac():String {
        // macOS: Using system_profiler to fetch GPU Name
        try {
            var process = new Process("system_profiler SPDisplaysDataType | grep 'Chipset Model'", []); // Command with args as null
            var output = process.stdout.readAll().toString().trim(); // Convert Bytes to String and trim
            return output.split(":")[1].trim(); // GPU info after the colon
        } catch (e:Dynamic) {
            return "Error fetching GPU info.";
        }
    }

    private static function getGpuInfoLinux():String {
        // Linux: Using lspci to fetch GPU Name
        try {
            var process = new Process("lspci | grep VGA", []); // Command with args as null
            var output = process.stdout.readAll().toString().trim(); // Convert Bytes to String and trim
            return output.split("\n")[0].split(":")[1].trim(); // GPU info after the colon
        } catch (e:Dynamic) {
            return "Error fetching GPU info.";
        }
    }
}
