module PrimeSlidingMenu
  class SidebarContainerScreen < ECSlidingViewController
    include ::MotionPrime::ScreenBaseMixin

    def self.new(menu, content, options = {})
      screen = self.alloc.init
      screen.on_create(options.merge(navigation: false)) if screen.respond_to?(:on_create)
      screen.menu_controller = menu unless menu.nil?
      screen.content_controller = content unless content.nil?
      screen.content_controller.view.addGestureRecognizer screen.panGesture
      screen.setAnchorRightRevealAmount 260.0
      screen
    end

    def show_sidebar
      anchorTopViewTo ECRight
    end

    def hide_sidebar
      self.resetTopView
    end

    def toggle_sidebar
      if self.topViewHasFocus
        show_sidebar
      else
        hide_sidebar
      end
    end

    def menu_controller=(c)
      self.underLeftViewController = prepare_controller(c)
    end

    def content_controller=(c)
      controller = prepare_controller(c)
      if should_reinit_content?(controller)
        self.topViewController = controller
      else
        content_controller.viewControllers = [controller]
      end
      hide_sidebar
    end

    def menu_controller
      self.underLeftViewController
    end

    def content_controller
      self.topViewController
    end

    private

      def should_reinit_content?(new_controller)
        content_controller.nil? ||
        content_controller.is_a?(MotionPrime::TabBarController) ||
        new_controller.is_a?(MotionPrime::TabBarController)
      end

      def prepare_controller(controller)
        controller = setup_screen_for_open(controller, {})
        if should_reinit_content?(controller)
          controller.wrap_in_navigation if controller.respond_to?(:wrap_in_navigation)
          controller.send(:on_screen_load) if controller.respond_to?(:on_screen_load)
          controller = controller.main_controller if controller.respond_to?(:main_controller)
        else
          controller.navigation_controller = content_controller if controller.respond_to?(:navigation_controller)
          controller.send(:on_screen_load) if controller.respond_to?(:on_screen_load)
        end
        controller
      end
  end
end