from engine.libs.glad cimport *
from engine.libs.glfw cimport *

from engine.event import Event


cdef void framebuffer_size_callback(GLFWwindow* window, int width, int height):
    glViewport(0, 0, width, height)


cdef void key_callback(GLFWwindow* window, int key, int scancode, int action, int mods):
    cdef Window curr_window
    for curr_window in windows:
        if curr_window.window == window:
            curr_window.key_events.append(Event(key, -2, action))


cdef void mouse_button_callback(GLFWwindow* window, int button, int action, int mods):
    cdef Window curr_window
    for curr_window in windows:
        if curr_window.window == window:
            curr_window.key_events.append(Event(-2, button, action))

windows = []

cdef class Window:
    cdef GLFWwindow* window
    cdef object key_events

    def __init__(self, size, window_name="'Engine Name' Window", vsync=False, high_dpi=True):
        window_name = window_name.encode()

        glfwInit()
        glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 4)
        glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 1)
        glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE)
        glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE)

        if high_dpi == False:
            glfwWindowHint(GLFW_COCOA_RETINA_FRAMEBUFFER, GL_FALSE)

        # window creation
        self.window = glfwCreateWindow(size[0], size[1], window_name, NULL, NULL)
        if (self.window == NULL):
            print("Failed to create GLFW window")
            glfwTerminate()
            return
        glfwMakeContextCurrent(self.window)

        if (not gladLoadGLLoader(<GLADloadproc>glfwGetProcAddress)):
            print("Failed to initialize GLAD")
            return

        # set callbacks
        glfwSetFramebufferSizeCallback(self.window, framebuffer_size_callback)
        glfwSetKeyCallback(self.window, key_callback)
        glfwSetMouseButtonCallback(self.window, mouse_button_callback)

        # vsync
        if vsync == False:
            glfwSwapInterval(0)

        # add window to windows list
        windows.append(self)

        self.key_events = []

    def set_title(self, name):
        glfwSetWindowTitle(self.window, name.encode());

    def close(self):
        glfwSetWindowShouldClose(self.window, True)

    def should_close(self):
        return glfwWindowShouldClose(self.window)

    def get_events(self):
        try:
            return self.key_events.copy()
        finally:
            self.key_events = []

    def get_key(self, key):
        return glfwGetKey(self.window, key)

    def get_mouse_button(self, button):
        return glfwGetMouseButton(self.window, button)

    def update(self):
        glfwSwapBuffers(self.window)
        glfwPollEvents()

    def quit(self):
        glfwTerminate()

