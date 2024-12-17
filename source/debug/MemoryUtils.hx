package debug;

import cpp.vm.Gc;

class MemoryUtils {
    public static function getMemoryUsage():Float {
        return Gc.memInfo64(Gc.MEM_INFO_USAGE);
    }
}