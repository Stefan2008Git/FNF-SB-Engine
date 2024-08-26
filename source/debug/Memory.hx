package debug;

class Memory {
    inline public static function obtainMemory():Float {
        #if cpp
		return cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_USAGE);
        #elseif hl
        return hl.Gc.stats().currentMemory;
		#else
		return cast(openfl.system.System.totalMemory, UInt);
		#end
    }
}