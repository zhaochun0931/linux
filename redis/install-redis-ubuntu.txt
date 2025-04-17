sudo apt-get install lsb-release curl gpg
curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
sudo chmod 644 /usr/share/keyrings/redis-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list
sudo apt-get update
sudo apt-get install redis






sudo systemctl enable redis-server
sudo systemctl start redis-server


systemctl status redis-server




redis-server

# redis-server
58581:C 24 Oct 2024 10:03:18.357 # WARNING Memory overcommit must be enabled! Without it, a background save or replication may fail under low memory condition. Being disabled, it can also cause failures without low memory condition, see https://github.com/jemalloc/jemalloc/issues/1328. To fix this issue add 'vm.overcommit_memory = 1' to /etc/sysctl.conf and then reboot or run the command 'sysctl vm.overcommit_memory=1' for this to take effect.
58581:C 24 Oct 2024 10:03:18.360 * oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
58581:C 24 Oct 2024 10:03:18.360 * Redis version=7.4.1, bits=64, commit=00000000, modified=0, pid=58581, just started
58581:C 24 Oct 2024 10:03:18.360 # Warning: no config file specified, using the default config. In order to specify a config file use redis-server /path/to/redis.conf
58581:M 24 Oct 2024 10:03:18.361 * Increased maximum number of open files to 10032 (it was originally set to 1024).
58581:M 24 Oct 2024 10:03:18.361 * monotonic clock: POSIX clock_gettime
                _._
           _.-``__ ''-._
      _.-``    `.  `_.  ''-._           Redis Community Edition
  .-`` .-```.  ```\/    _.,_ ''-._     7.4.1 (00000000/0) 64 bit
 (    '      ,       .-`  | `,    )     Running in standalone mode
 |`-._`-...-` __...-.``-._|'` _.-'|     Port: 6379
 |    `-._   `._    /     _.-'    |     PID: 58581
  `-._    `-._  `-./  _.-'    _.-'
 |`-._`-._    `-.__.-'    _.-'_.-'|
 |    `-._`-._        _.-'_.-'    |           https://redis.io
  `-._    `-._`-.__.-'_.-'    _.-'
 |`-._`-._    `-.__.-'    _.-'_.-'|
 |    `-._`-._        _.-'_.-'    |
  `-._    `-._`-.__.-'_.-'    _.-'
      `-._    `-.__.-'    _.-'
          `-._        _.-'
              `-.__.-'

58581:M 24 Oct 2024 10:03:18.363 # Warning: Could not create server TCP listening socket *:6379: bind: Address already in use
58581:M 24 Oct 2024 10:03:18.363 # Failed listening on port 6379 (tcp), aborting.
#
