package ahptool;

import lime.app.Application;
import lime.ui.Window;
import lime.ui.WindowAttributes;

class WindowManager {
    private var window:Window; // Declare the window property

    /**
     * Constructor for the WindowManager class.
     * @param attributes A WindowAttributes object containing the configuration for the window.
     */
    public function new(attributes:WindowAttributes) {
        if (attributes == null) {
            throw "Error: WindowAttributes cannot be null.";
        }
        // Create the window
        this.window = Application.current.createWindow(attributes);
    }

    /**
     * Gets the current window instance.
     * @return The created window.
     */
    public function getWindow():Window {
        return this.window;
    }
}
