#/usr/bin/sh 

echo "Running Docker Job"

# Start a very useful long-running process
$ JOB=$(docker run -d ubuntu /bin/sh -c "while true; do echo Hello world; sleep 1; done")
echo "The Job: $JOB"

# Collect the output of the job so far
$ docker logs $JOB

# Kill the job
$ docker kill $JOB
