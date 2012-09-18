# xgem

xgem is a fast and simple supplement to RubyGems. You will notice a significant drop in the amount of time it takes Ruby to startup.

### The Problem with RubyGems

RubyGems is a good bit of software. It does a lot of things and usually serves its users well. Unfortunately, RubyGems imposes a nasty peformance penalty with regard to startup times.

When you first require a gem, RubyGems does a full scan of all installed gems which involves loading and evaluating the gemspecs of all installed gems. Once it has scanned all installed gems, it must ask each gem if it provides the file you tried to require.

### How does xgem fix this?

xgem caches the require paths provided by each installed gem. This is maintained in a Hash mapping require path to the full path of the file on the filesystem.

In practise, this can dramatically improve the time it takes for Ruby to start up. Take this example script which prints out the installed version of the Yajl gem:

```ruby
require "yajl/version"

puts Yajl::VERSION
```

When run with `xgem-ruby`, the time it takes for this script to run drops by more than 200 milliseconds:

![image](http://i.imgur.com/yqnXs.png)

### Caveats

RubyGems does a lot under the covers. One thing it does is managing multiple installed versions of the same gem. xgem doesn't currently do this.

You will also need to run `xgem refresh` every time you install or uninstall a gem. This allows xgem to update its cache.

### TODO

* Play nicely with multiple installed versions of the same gem
* Add a post_install hook to RubyGems to avoid the need to run `xgem refresh`
* Probably a lot more. If you run into troubles with xgem, please file an issue and let me know.

### License

Simplified BSD