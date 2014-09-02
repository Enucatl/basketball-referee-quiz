# Set the working application directory
# working_directory "/path/to/your/app"
working_directory "/home/deploy/basketball-referee-quiz"

# Unicorn PID file location
# pid "/path/to/pids/unicorn.pid"
pid "/home/deploy/basketball-referee-quiz/pids/unicorn.pid"

# Path to logs
# stderr_path "/path/to/log/unicorn.log"
# stdout_path "/path/to/log/unicorn.log"
stderr_path "/home/deploy/basketball-referee-quiz/log/unicorn.log"
stdout_path "/home/deploy/basketball-referee-quiz/log/unicorn.log"

# Unicorn socket
listen "/tmp/unicorn.basketball-referee-quiz.sock"

# Number of processes
# worker_processes 4
worker_processes 3

# Time-out
timeout 30
