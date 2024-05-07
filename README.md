![xUnit Tests](https://github.com/Ifiht/Spriggan/actions/workflows/ruby.yml/badge.svg)
![Formatting Check](https://github.com/Ifiht/Spriggan/actions/workflows/syntax.yml/badge.svg)

<img src="https://raw.githubusercontent.com/Ifiht/Spriggan/main/resources/dhl4_harp_by_Rasgar.png" width="109" height="109">

# Spriggan
Climb the beanstalk! Ruby library to interact gracefully with [beanstalkd](https://github.com/beanstalkd/beanstalkd) & [PM2](https://github.com/Unitech/pm2).

## Usage
### beanstalkd
- beanstalkd jobs may be accessed via `get_msg` and `send_msg`
- Sending messages must take the format of `send_msg(<ruby_object>, "<beanstalkd_tube>")`
- Received messages from `hash = get_msg` will take the following form:
```ruby
hash = {
  "to" => "<beanstalkd_dest_tube>"
  "from" => "<beanstalkd_src_tube>"
  "msg" => Ruby.object
}
```
### PM2
- Any threads started with `Spriggan.run` have a trap to detect PM2 SIGINTs and exit gracefully
- Logging messages to PM2 is done with `Spriggan.pm2_log("<message>")`
