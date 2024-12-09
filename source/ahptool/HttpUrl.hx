package ahptool;

import haxe.ds.Option;

class HttpUrl {
    private static final regexp = ~/^(https?):\/\/([a-zA-Z0-9.-]+)(:[0-9]+)?(\/.*)?$/;

    public var url(default, null): String;
    public var valid(default, null): Bool;
    public var secure(default, null): Bool;
    public var host(default, null): String;
    public var port(default, null): Int;
    public var request(default, null): String;

    public function new(url: String) {
        this.url = url;
        var match = regexp.match(url);
        this.valid = match;

        if (match) {
            this.secure = regexp.matched(1) == "https";
            this.host = regexp.matched(2);
            this.port = parsePort(regexp.matched(3));
            this.request = regexp.matched(4) != null ? regexp.matched(4) : "/";
        } else {
            // Default values for invalid URLs
            this.secure = false;
            this.host = "";
            this.port = 80;
            this.request = "/";
        }
    }

    private function parsePort(portStr: String): Int {
        return portStr != null ? Std.parseInt(portStr.substr(1)) : (secure ? 443 : 80);
    }

    public function toString(): String {
        return url;
    }
}
