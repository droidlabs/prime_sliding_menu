module PrimeSlidingMenu
  class SidebarContainerScreen < ECSlidingViewController
    include ::MotionPrime::ScreenBaseMixin

    def self.new(menu, content, options = {})
      screen = self.alloc.initWithTopViewController(nil)
      screen.on_create(options.merge(navigation: false)) if screen.respond_to?(:on_create)
      screen.menu_controller = menu unless menu.nil?
      screen.content_controller = content unless content.nil?
      screen.content_controller.view.addGestureRecognizer screen.panGesture
      screen.setAnchorRightRevealAmount 260.0
      screen
    end

    def show_sidebar
      self.anchorTopViewToRightAnimated(false)
    end

    def hide_sidebar
      self.resetTopViewAnimated(false)
    end

    def toggle_sidebar
      if self.currentTopViewPosition == 2
        show_sidebar
      else
        hide_sidebar
      end
    end

    def menu_controller=(c)
      @menu_controller_ref = prepare_controller(c)
      self.underLeftViewController = @menu_controller_ref
    end

    def content_controller=(c)
      @content_controller_ref = prepare_controller(c)
      if should_reinit_content?(@content_controller_ref)
        self.topViewController = @content_controller_ref
      else
        content_controller.viewControllers = [@content_controller_ref]
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
        content_controller.blank? ||
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
        controller.strong_ref
      end
  end
end