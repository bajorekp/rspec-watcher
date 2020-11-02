# RSpec Watcher

Watcher for RSpec and Zeitwerk based projects.
It waits and runs affected tests in background with Pry console in
foreground. Console allows for easy code debugging on the fly.

The repository is not a gem but it simply contains a single script you can copy and use it for your own project.

## Setup

1. Copy `bin/rspec-watcher` to _bin_ directory in your project
1. Set `BOOT_FILE` for path to file which boots but don't start the application
1. Change `APP_LOADER` to the constant which points to your setup `Zeitwerk::Loader`
1. Make sure that `loader.enable_reloading` has been executed before `loader.setup`
1. Run with `bin/rspec-watcher`

## Options

```
-a, --[no-]all                   Run all test with every change (default: false)
-n, --[no-]all-when-none         Run all test when no spec file is founded (default: true)
-s, --[no-]all-on-start          Run all test on start (default: false)
-r, --[no-]retry                 Retry tests failed on previous run until fixed (default: true)
-c, --[no-]console               Wait with Pry console (default: true)
-h, --help                       Show this message
```

The script is based on rspec-preloader. Check it out under the link:
 - [victormours/rspec-preloader](https://github.com/victormours/rspec-preloader)
