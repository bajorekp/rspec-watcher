# RSpec Watcher

Watcher for RSpec and Zeitwerk based projects.
It waits and runs affected tests in background with Pry console in
foreground. Console allows for easy code debugging on the fly.

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
