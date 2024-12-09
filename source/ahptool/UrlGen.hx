package ahptool;

class UrlGen {
    private var baseUrl: String;
    private var pathSegments: Array<String>;
    private var queryParams: Map<String, String>;

    public function new(baseUrl: String) {
        // Validate base URL
        if (!isValidUrl(baseUrl)) {
            throw "Invalid base URL provided";
        }
        this.baseUrl = baseUrl;
        this.pathSegments = [];
        this.queryParams = new Map<String, String>();
    }

    // Add a path segment to the URL
    public function addPathSegment(segment: String): UrlGen {
        while (true) {
            if (segment.endsWith("/")) {
                segment = segment.substr(0, segment.length - 1);
            } else {
                break;
            }
        }

        if (segment != null && segment != "") {
            pathSegments.push(segment);
        }
        return this; // Enable method chaining
    }

    // Add a query parameter to the URL
    public function addQueryParam(key: String, value: String): UrlGen {
        while (true) {
            if (key.endsWith("/")) {
                key = key.substr(0, key.length - 1);
            } else {
                break;
            }
        }
        //while (true) {
        //    if (value.endsWith("/")) {
        //        value = value.substr(0, value.length - 1);
        //    } else {
        //        break;
        //    }
        //}
        
        if (key != null && value != null) {
            queryParams.set(key, value);
        }
        return this; // Enable method chaining
    }

    // Generate the final URL
    public function generate(): String {
        var url = baseUrl;
    
        // Ensure base URL ends without a trailing slash unless it's the root
        while (true) {
            if (url.endsWith("/") && pathSegments.length > 0) {
                url = url.substr(0, url.length - 1);
            } else {
                break;
            }
        }
    
        // Append path segments
        if (pathSegments.length > 0) {
            url += "/" + pathSegments.join("/");
        }
    
        // Append query parameters
        if (queryParams.keys().hasNext()) {
            var query = iteratorToArray(queryParams.keys())
                .map(key -> urlEncode(key) + "=" + urlEncode(queryParams.get(key)))
                .join("&");
            url += "?" + query;
        }
    
        return url;
    }

    // Validate if a URL is valid
    private static function isValidUrl(url: String): Bool {
        var regexp = ~/^(https?):\/\/([a-zA-Z0-9.-]+)(:[0-9]+)?(\/.*)?$/;
        return regexp.match(url);
    }

    // Helper: Convert iterator to array
    private static function iteratorToArray<T>(it: Iterator<T>): Array<T> {
        var arr: Array<T> = [];
        while (it.hasNext()) {
            arr.push(it.next());
        }
        return arr;
    }

    // Helper: URL encode a string
    private static function urlEncode(str: String): String {
        return StringTools.replace(StringTools.replace(str, " ", "%20"), "=", "%3D");
    }
}
