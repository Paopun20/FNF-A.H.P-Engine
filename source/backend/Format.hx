package backend;

class Format {
    // Helper method to return the formatted value with its suffix
    private static function getFormattedValueAndSuffix(value:Float):{formattedValue:Float, suffix:String} {
        var suffixes = [
            {threshold: 1_000_000_000_000_000_000, divisor: 1_000_000_000_000_000_000, suffix: "Q"},
            {threshold: 1_000_000_000_000_000, divisor: 1_000_000_000_000_000, suffix: "Qa"},
            {threshold: 1_000_000_000_000, divisor: 1_000_000_000_000, suffix: "T"},
            {threshold: 1_000_000_000, divisor: 1_000_000_000, suffix: "B"},
            {threshold: 1_000_000, divisor: 1_000_000, suffix: "M"},
            {threshold: 1_000, divisor: 1_000, suffix: "K"}
        ];

        // Find the appropriate suffix for the value
        for (suffix in suffixes) {
            if (value >= suffix.threshold) {
                return {formattedValue: value / suffix.divisor, suffix: suffix.suffix};
            }
        }
        // No suffix for values less than 1000
        return {formattedValue: value, suffix: ""};
    }

    // Public method to format the value with suffix
    public static function format(value:Float):String {
        var result = getFormattedValueAndSuffix(value);
        var formattedValue = CoolUtil.floorDecimal(result.formattedValue, 2); // Format to 2 decimal places
        return Std.string(formattedValue) + result.suffix; // Return formatted value with suffix
    }
}
