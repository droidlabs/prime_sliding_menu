module PrimeSlidingMenu
  module BaseAppDelegate

    def self.included(base)
      base.class_eval do
        alias_method :open_screen!, :open_screen
        def open_screen(screen, options = {})
          screen = prepare_screen_for_open(screen, options)
          if sidebar_option = options.delete(:sidebar)
            sidebar_option = :sidebar if sidebar_option == true
            sidebar = MotionPrime::Screen.create_with_options(sidebar_option, false, {})
            open_with_sidebar(screen, sidebar, options)
          else
            open_screen!(screen, options)
          end
        end

        alias_method :open_content_screen!, :open_content_screen
        def open_content_screen(screen, options = {})
          if sidebar?
            if options[:animated]
              UIView.transitionWithView @sidebar_container,
                      duration: 0.5,
                       options: UIViewAnimationOptionTransitionFlipFromLeft,
                    animations: proc { @sidebar_container.content_controller = screen },
                    completion: nil
            else
              @sidebar_container.content_controller = screen
            end
          else
            open_content_screen!(screen)
          end
        end
      end
    end

    def sidebar?
      self.window && self.window.rootViewController.is_a?(SidebarContainerScreen)
    end

    def show_sidebar
      @sidebar_container.show_sidebar
    end

    def hide_sidebar
      @sidebar_container.hide_sidebar
    end

    def toggle_sidebar
      @sidebar_container.toggle_sidebar
    end

    private
      def open_with_sidebar(content, sidebar, options = {})
        @sidebar_container = SidebarContainerScreen.new(sidebar, content, options)
        open_root_screen(@sidebar_container)
      end
  end
end

MotionPrime::BaseAppDelegate.send :include, PrimeSlidingMenu::BaseAppDelegate