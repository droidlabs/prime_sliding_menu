# PrimeSlidingMenu

[ECSlidingViewController](https://github.com/ECSlidingViewController/ECSlidingViewController) integration for [MotionPrime](https://github.com/droidlabs/motion-prime).

![iPhone and iPad Mini screenshots](http://github.com/ECSlidingViewController/ECSlidingViewController/wiki/readme-assets/readme-hero.png)

## Installation

Add this line to your application's Gemfile:

    gem 'prime_sliding_menu'

And then execute:

    $ bundle
    $ rake pod:install

## Usage

  class AppDelegate < Prime::BaseAppDelegate
    def on_load(app, options)
      open_screen :main, sidebar: true
    end
  end

  class SidebarScreen < Prime::Screen
    def render
      # Add anything to menu
    end
  end


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
