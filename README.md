# RSpec Watcher

Watcher for RSpec and Zeitwerk based projects.
It waits and runs affected tests in background with Pry console in
foreground. Console allows for easy code debugging on the fly.

The repository is not a gem. Just copy files from _lib_ and _bin_ directories and you are good. If you think it should be publish to RubyGem, just leave a star for the repo or open an issue.

## Setup

1. Copy files from `lib` directory to _lib_ directory in your project
1. Copy `bin/rspec-watcher` to _bin_ directory in your project
1. Change `APP_LOADER` to the constant which points to `Zeitwerk::Loader` instance in your project
1. Make sure that `loader.enable_reloading` has been executed before `loader.setup`
1. Run `bin/rspec-watcher` to test the watcher out

## Options

```
-a, --[no-]all                   Run all test with every change (default: false)
-n, --[no-]all-when-none         Run all test when no spec file is founded (default: true)
-s, --[no-]all-on-start          Run all test on start (default: false)
-r, --[no-]retry                 Retry tests failed on previous run until fixed (default: true)
-c, --[no-]console               Wait with Pry console (default: true)
-h, --help                       Prints help
```

The script is based on rspec-preloader. Check it out under the link:
 - [victormours/rspec-preloader](https://github.com/victormours/rspec-preloader)
